FROM t4skforce/jenkins-slave

ARG KOTLIN_VERSION="v1.5.31"
ARG KOTLIN_DOWNLOADURL="https://github.com/JetBrains/kotlin/releases/download/v1.5.31/kotlin-compiler-1.5.31.zip"
ARG ANDROID_SDK_VERSION=""
ARG ANDROID_SDK_DOWNLOADURL=""
ARG BUILD_DATE="20211004"

ENV KOTLIN_HOME /opt/kotlin
ENV ANDROID_HOME /opt/android-sdk
ENV ANDROID_SDK_HOME $ANDROID_HOME
ENV PATH ${PATH}:${KOTLIN_HOME}/bin:${ANDROID_HOME}/emulator:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/tools/bin

USER root
COPY /install.sh /tmp/install.sh
RUN apt-get update -qqy \
  && apt-get install -y curl build-essential sudo zip expect \
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
  && chmod +x /tmp/install.sh && /tmp/install.sh \
  && ln -s $ANDROID_HOME/build-tools/*/zipalign /usr/bin/zipalign \
  && npm install -g cordova@8.1.2 \
  && npm install -g ionic \
  && npm install -g bower \
  && npm install -g gulp \
  && npm install -g gulp-sass \
  && chmod 777 -R $ANDROID_HOME \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /tmp/* \
  && chown -R jenkins:jenkins /home/jenkins
USER jenkins
