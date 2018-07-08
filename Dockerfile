FROM t4skforce/jenkins-slave

ENV ANDROID_HOME /usr/lib/android-sdk
ENV ANDROID_SDK_HOME $ANDROID_HOME
ENV PATH $PATH:$ANDROID_SDK_HOME/tools:$ANDROID_SDK_HOME/platform-tools:$ANDROID_SDK_HOME/tools/bin:$JAVA_HOME/bin

COPY ./licenses/* $ANDROID_SDK_HOME/licenses/

USER root
RUN apt-get update -qqy \
  && apt-get install -y curl build-essential sudo \
  && curl -sL https://deb.nodesource.com/setup_10.x | bash - \
  && apt-get install --fix-missing \
  && apt-get install -y --no-install-recommends nodejs git android-sdk android-sdk-build-tools android-sdk-platform-23 gradle \
  && rm -rf /var/lib/apt/lists/* \
  && npm install -g cordova \
  && npm install -g ionic \
  && npm install -g bower \
  && npm install -g gulp \
  && chmod 777 -R $ANDROID_HOME \
  && rm -rf /var/lib/apt/lists/* \
  && chown -R jenkins:jenkins /home/jenkins
USER jenkins
