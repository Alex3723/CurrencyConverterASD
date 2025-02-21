FROM dart:stable as flutter-app

# Installa le dipendenze di sistema come root
USER root
RUN apt-get update && \
    apt-get install -y unzip xz-utils zip libglu1-mesa git && \
    rm -rf /var/lib/apt/lists/*

# Crea un gruppo e un utente non root per eseguire Flutter
RUN groupadd -r flutteruser && useradd -ms /bin/bash -g flutteruser flutteruser

# Crea la directory /opt/flutter con i permessi giusti
RUN mkdir -p /opt/flutter && chown flutteruser:flutteruser /opt/flutter

# Passa a questo utente per il resto dei comandi
USER flutteruser

# Scarica Flutter SDK
WORKDIR /opt
RUN git clone https://github.com/flutter/flutter.git -b 3.27.1 --depth 1

# Aggiungi Flutter al PATH
ENV PATH="/opt/flutter/bin:/opt/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Assicura che Flutter sia riconosciuto correttamente
RUN flutter precache

# Accetta le licenze Android se necessarie
RUN yes | flutter doctor --android-licenses

# Esegui il doctor per garantire che l'ambiente sia pronto
RUN /opt/flutter/bin/flutter --version
RUN flutter doctor -v

# Imposta la cartella di lavoro dell'app
WORKDIR /app

# Assicura che flutteruser abbia i permessi sulla cartella dell'app
RUN chown -R flutteruser:flutteruser /app

# Copia i file del progetto Flutter nella cartella dell'app
COPY . .

# Esegui flutter pub get per installare le dipendenze
RUN flutter pub get

# Analizza il progetto
RUN flutter analyze

# Esegui i test
RUN flutter test

# Crea la build per il web
RUN flutter build web --release

# Usa un'immagine nginx per servire l'app
FROM nginx:alpine

# Copia i file della build dal primo stage
COPY --from=flutter-app /app/build/web /usr/share/nginx/html

# Espone la porta per il server web
EXPOSE 8090

# Avvia nginx in modalità foreground
CMD ["nginx", "-g", "daemon off;"]
