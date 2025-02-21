# Usa l'immagine di base Dart
FROM flutter/flutter:stable AS flutter-builder


# Crea una directory per il progetto
RUN mkdir /app

# Crea un nuovo utente non root
RUN useradd -m flutteruser && \
    chown -R flutteruser:flutteruser /app

# Installa le dipendenze di sistema
RUN apt-get update && \
    apt-get install -y unzip xz-utils zip libglu1-mesa git curl && \
    rm -rf /var/lib/apt/lists/*

# Passa all'utente non root
USER flutteruser

# Clona Flutter nella home dell'utente
RUN git clone https://github.com/flutter/flutter.git /home/flutteruser/flutter

# Aggiungi Flutter al PATH
ENV PATH="/home/flutteruser/flutter/bin:${PATH}"

# Crea la directory per il progetto
WORKDIR /app

# Copia il progetto Flutter nella cartella di lavoro
COPY . .


# Copia pubspec.lock se esistente
COPY pubspec.lock /app/

# Installa le dipendenze di Flutter
RUN flutter pub get --no-analytics

# Esegui flutter analyze per il controllo del codice
RUN flutter analyze

# Esegui i test del progetto
RUN flutter test

# Crea la build per il web
RUN flutter build web --release

# Usa un'immagine nginx per servire il progetto
FROM nginx:alpine

# Copia solo la build dal primo stage, per ridurre le dimensioni finali
COPY --from=flutter-builder /app/build/web /usr/share/nginx/html

# Espone la porta per il server
EXPOSE 80

# Avvia nginx
CMD ["nginx", "-g", "daemon off;"]
