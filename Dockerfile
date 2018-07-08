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
  && cd /opt \
  && curl -Ls https://github.com/JetBrains/kotlin/releases/download/v${KOTLIN_VERSION}/kotlin-compiler-${KOTLIN_VERSION}.zip --output kotlin.zip \
  && unzip -q kotlin.zip \
  && rm kotlin.zip \
  && mkdir -p ${ANDROID_SDK_HOME} \
  && cd ${ANDROID_SDK_HOME} \
  && curl -Ls https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_SDK_VERSION}.zip --output android-sdk.zip \
  && unzip -q android-sdk.zip \
  && rm android-sdk.zip \
  && cd /home/jenkins \
  && yes | sdkmanager --licenses \
  && sdkmanager --list | cut -d'|' -f1 | awk '{$1=$1};1' | grep -v '-rc' | grep 'build-tools;' | sort -r | head -n 21  \
  && sdkmanager --list | cut -d'|' -f1 | awk '{$1=$1};1' | grep -v '-rc' | grep 'platforms;' | sort -nr | head -n 10 \
  && sdkmanager "platform-tools" > /dev/null \
  && sdkmanager "extras;android;m2repository" > /dev/null \
  && sdkmanager "extras;google;m2repository" > /dev/null \
  && npm install -g cordova \
  && npm install -g ionic \
  && npm install -g bower \
  && npm install -g gulp \
  && chmod 777 -R $ANDROID_HOME \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /tmp/* \
  && ls -la \
  && chown -R jenkins:jenkins /home/jenkins
USER jenkins
