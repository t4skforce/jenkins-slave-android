FROM t4skforce/jenkins-slave

ENV KOTLIN_VERSION 1.2.50
ENV ANDROID_SDK_VERSION 4333796

ENV KOTLIN_HOME /opt/kotlinc
ENV ANDROID_HOME /opt/android-sdk
ENV ANDROID_SDK_HOME $ANDROID_HOME
ENV PATH ${PATH}:${KOTLIN_HOME}/bin:${ANDROID_HOME}/emulator:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/tools/bin

COPY ./licenses/* $ANDROID_SDK_HOME/licenses/

USER root
RUN apt-get update -qqy \
  && apt-get install -y curl build-essential sudo zip \
  && curl -sL https://deb.nodesource.com/setup_10.x | bash - \
  && apt-get install --fix-missing \
  && apt-get install -y --no-install-recommends nodejs git gradle \
  && rm -rf /var/lib/apt/lists/* \
  && cd /opt \
  && curl -Ls https://github.com/JetBrains/kotlin/releases/download/v${KOTLIN_VERSION}/kotlin-compiler-${KOTLIN_VERSION}.zip --output kotlin.zip \
  && unzip kotlin.zip \
  && rm kotlin.zip \
  && mkdir -p ${ANDROID_SDK_HOME} \
  && cd ${ANDROID_SDK_HOME} \
  && curl -Ls https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_SDK_VERSION}.zip --output android-sdk.zip \
  && unzip -o android-sdk.zip \
  && rm android-sdk.zip \
  && sdkmanager --list \
  && echo y | android update sdk --no-ui --all --filter platform-tools | grep 'package installed' \
  && echo y | android update sdk --no-ui --all --filter extra-android-support | grep 'package installed' \
  && echo y | android update sdk --no-ui --all --filter android-24 | grep 'package installed' \
  && echo y | android update sdk --no-ui --all --filter android-23 | grep 'package installed' \
  && echo y | android update sdk --no-ui --all --filter android-22 | grep 'package installed' \
  && echo y | android update sdk --no-ui --all --filter android-21 | grep 'package installed' \
  && echo y | android update sdk --no-ui --all --filter android-20 | grep 'package installed' \
  && echo y | android update sdk --no-ui --all --filter android-19 | grep 'package installed' \
  && echo y | android update sdk --no-ui --all --filter android-17 | grep 'package installed' \
  && echo y | android update sdk --no-ui --all --filter android-15 | grep 'package installed' \
  && echo y | android update sdk --no-ui --all --filter android-10 | grep 'package installed' \
  && echo y | android update sdk --no-ui --all --filter build-tools-24.0.1 | grep 'package installed' \
  && echo y | android update sdk --no-ui --all --filter build-tools-24.0.0 | grep 'package installed' \
  && echo y | android update sdk --no-ui --all --filter build-tools-23.0.3 | grep 'package installed' \
  && echo y | android update sdk --no-ui --all --filter build-tools-23.0.2 | grep 'package installed' \
  && echo y | android update sdk --no-ui --all --filter build-tools-23.0.1 | grep 'package installed' \
  && echo y | android update sdk --no-ui --all --filter build-tools-22.0.1 | grep 'package installed' \
  && echo y | android update sdk --no-ui --all --filter build-tools-21.1.2 | grep 'package installed' \
  && echo y | android update sdk --no-ui --all --filter build-tools-20.0.0 | grep 'package installed' \
  && echo y | android update sdk --no-ui --all --filter build-tools-19.1.0 | grep 'package installed' \
  && echo y | android update sdk --no-ui --all --filter build-tools-17.0.0 | grep 'package installed' \
  && echo y | android update sdk --no-ui --all --filter extra-android-m2repository | grep 'package installed' \
  && echo y | android update sdk --no-ui --all --filter extra-google-m2repository | grep 'package installed' \
  && echo y | android update sdk --no-ui --all --filter extra-google-google_play_services | grep 'package installed' \
  && echo y | android update sdk --no-ui --all --filter addon-google_apis-google-23 | grep 'package installed' \
  && echo y | android update sdk --no-ui --all --filter addon-google_apis-google-22 | grep 'package installed' \
  && echo y | android update sdk --no-ui --all --filter addon-google_apis-google-21 | grep 'package installed' \
  && cd /home/jenkins \
  && npm install -g cordova \
  && npm install -g ionic \
  && npm install -g bower \
  && npm install -g gulp \
  && chmod 777 -R $ANDROID_HOME \
  && rm -rf /var/lib/apt/lists/* \
  && chown -R jenkins:jenkins /home/jenkins
USER jenkins
