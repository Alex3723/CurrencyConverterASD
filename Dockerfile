FROM dart:stable as flutter-app


USER root
RUN apt-get update && \
    apt-get install -y unzip xz-utils zip libglu1-mesa git curl && \
    rm -rf /var/lib/apt/lists/*


RUN groupadd -r flutteruser && useradd -ms /bin/bash -g flutteruser flutteruser


RUN mkdir -p /opt/flutter && chown flutteruser:flutteruser /opt/flutter


USER flutteruser


WORKDIR /opt
RUN git clone https://github.com/flutter/flutter.git -b 3.27.1 --depth 1


ENV PATH="/opt/flutter/bin:/opt/flutter/bin/cache/dart-sdk/bin:${PATH}"


RUN flutter precache


RUN yes | flutter doctor --android-licenses


RUN /opt/flutter/bin/flutter --version
RUN flutter doctor -v


WORKDIR /app


RUN chown -R flutteruser:flutteruser /app


COPY . .


USER root
RUN rm -rf /app/.dart_tool /app/build /app/.flutter-plugins


RUN chown -R flutteruser:flutteruser /app
USER flutteruser


RUN flutter pub get


RUN flutter analyze


RUN flutter test


RUN flutter build web --release


FROM nginx:alpine


COPY --from=flutter-app /app/build/web /usr/share/nginx/html


EXPOSE 8090


CMD ["nginx", "-g", "daemon off;"]
