FROM t4skforce/jenkins-slave

ENV KOTLIN_VERSION "v1.2.51"
ENV KOTLIN_DOWNLOADURL "https://github.com/JetBrains/kotlin/releases/download/v1.2.51/kotlin-compiler-1.2.51.zip"
ENV ANDROID_SDK_VERSION "4333796"
ENV ANDROID_SDK_DOWNLOADURL "https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip"

ENV KOTLIN_HOME /opt/kotlin
ENV ANDROID_HOME /opt/android-sdk
ENV ANDROID_SDK_HOME $ANDROID_HOME
ENV PATH ${PATH}:${KOTLIN_HOME}/bin:${ANDROID_HOME}/emulator:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/tools/bin

USER root
RUN apt-get update -qqy \
  && apt-get install -y curl build-essential sudo zip \
  && curl -sL https://deb.nodesource.com/setup_10.x | bash - \
  && apt-get install --fix-missing \
  && apt-get install -y --no-install-recommends nodejs git gradle \
  && cd /opt \
  && curl -Ls ${KOTLIN_DOWNLOADURL} --output kotlin.zip \
  && unzip -q kotlin.zip \
  && rm kotlin.zip \
  && mkdir -p ${ANDROID_SDK_HOME} \
  && cd ${ANDROID_SDK_HOME} \
  && curl -Ls ${ANDROID_SDK_DOWNLOADURL} --output android-sdk.zip \
  && unzip -q android-sdk.zip \
  && rm android-sdk.zip \
  && cd /home/jenkins \
  && yes | sdkmanager --licenses \
  && echo "#!/bin/bash" > install.sh \
  && echo "echo \"tools\" && sdkmanager \"tools\" > /dev/null 2>&1" > install.sh \
  && echo "echo \"platform-tools\" && sdkmanager \"platform-tools\" > /dev/null 2>&1" > install.sh \
  && echo "echo \"extras;android;m2repository\" && sdkmanager \"extras;android;m2repository\" > /dev/null 2>&1" > install.sh \
  && echo "echo \"extras;google;m2repository\" && sdkmanager \"extras;google;m2repository\" > /dev/null 2>&1" > install.sh \
  && for VER in $(sdkmanager --list 2>/dev/null | cut -d'|' -f1 | awk '{$1=$1};1' | grep -v '\-rc' | grep 'build-tools\;' | sort -r | head -n 1); do echo "echo \"$VER\" && sdkmanager \"$VER\" > /dev/null 2>&1" >> install.sh; done \
  && for VER in $(sdkmanager --list 2>/dev/null | cut -d'|' -f1 | awk '{$1=$1};1' | grep -v '\-rc' | grep 'platforms\;' | cut -d'-' -f2 | sort -nr | head -n 6); do echo "echo \"platforms;android-$VER\" && sdkmanager \"platforms;android-$VER\" > /dev/null 2>&1" >> install.sh ; done \
  && chmod +x install.sh \
  && ./install.sh \
  && rm ./install.sh \
  && ln -s $ANDROID_HOME/build-tools/*/zipalign /usr/bin/zipalign \
  && npm install -g cordova \
  && npm install -g ionic \
  && npm install -g bower \
  && npm install -g gulp \
  && chmod 777 -R $ANDROID_HOME \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /tmp/* \
  && chown -R jenkins:jenkins /home/jenkins
USER jenkins
