FROM dart:stable

# Install dependencies
RUN apt-get update && \
    apt-get install -y unzip xz-utils zip libglu1-mesa git && \
    rm -rf /var/lib/apt/lists/*

# Install Flutter SDK
WORKDIR /opt
RUN git clone https://github.com/flutter/flutter.git -b stable --depth 1
ENV PATH="/opt/flutter/bin:/opt/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Fix permissions to ensure flutter user can execute commands
RUN useradd -m flutteruser && \
    chown -R flutteruser:flutteruser /opt/flutter && \
    chmod -R 755 /opt/flutter

USER flutteruser

# Run flutter commands
RUN flutter precache
RUN yes | flutter doctor --android-licenses
RUN flutter doctor -v

# Set the working directory for app
WORKDIR /app

# Copy the app code into the container
COPY . .

# Get dependencies, analyze, and test
RUN flutter pub get
RUN flutter analyze
RUN flutter test

# Build the app for web
RUN flutter build web --release

# Use NGINX to serve the built app
FROM nginx:alpine
COPY --from=0 /app/build/web /usr/share/nginx/html

EXPOSE 8090

CMD ["nginx", "-g", "daemon off;"]
