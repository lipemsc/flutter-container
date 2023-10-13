# For building the app for the Android platform
FROM archlinux
WORKDIR /

# Dependencies
RUN pacman -Sy --noconfirm wget curl file git xz unzip cmake ninja jre17-openjdk-headless which
RUN rm -rf /var/cache/pacman

# Flutter download
RUN git clone https://github.com/flutter/flutter.git -b beta
ENV PATH=/flutter/bin:${PATH}
RUN flutter doctor
RUN flutter config --no-analytics

# Download commandline tools
RUN curl -LO https://dl.google.com/android/repository/commandlinetools-linux-10406996_latest.zip
RUN unzip commandlinetools-linux-10406996_latest.zip

# Creates sdk folder and moves the cmdline-tools into it
RUN mkdir /sdk
RUN flutter config --android-sdk /sdk
RUN mv /cmdline-tools /sdk/
ENV PATH=/sdk/cmdline-tools/bin:${PATH}

# Download sdk stuff
RUN echo y | sdkmanager --sdk_root=/sdk --install "platform-tools"
RUN echo y | sdkmanager --sdk_root=/sdk --install "build-tools;34.0.0"
RUN echo y | sdkmanager --sdk_root=/sdk --install "cmdline-tools;latest"
RUN echo y | sdkmanager --sdk_root=/sdk --install "platforms;android-29"

# Make sure everything is working
RUN echo -e "y\ny\ny\ny\ny\ny" | flutter doctor --android-licenses

RUN flutter config --no-enable-web
RUN flutter config --no-enable-linux-desktop

RUN mkdir /project
WORKDIR /project

ENTRYPOINT [ "flutter" , "--no-version-check" ]
CMD [ "--help" ]
