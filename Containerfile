# For building the app for the Android platform
FROM archlinux
WORKDIR /

# Dependencies
RUN pacman -Sy --noconfirm wget curl file git xz unzip gcc cmake ninja pkg-config clang gtk3 jre17-openjdk-headless which glibc
RUN rm -rf /var/cache/pacman

# Flutter download
RUN git clone https://github.com/flutter/flutter.git -b beta
ENV PATH=/flutter/bin:${PATH}
RUN flutter doctor
RUN flutter config --no-analytics
RUN flutter config --no-enable-web
RUN flutter config --no-enable-android

RUN mkdir /project
WORKDIR /project

ENTRYPOINT [ "flutter" , "--no-version-check" ]
CMD [ "--help" ]
