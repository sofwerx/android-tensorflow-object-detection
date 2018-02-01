FROM gcr.io/tensorflow/tensorflow:1.5.0-devel

RUN apt-get update
RUN apt-get install -y wget git

RUN mkdir -p /android

WORKDIR /android
# cd /android

ENV ANDROID_SDK_VERSION=r25.2.3

RUN wget -q https://dl.google.com/android/repository/tools_${ANDROID_SDK_VERSION}-linux.zip \
 && unzip -q tools_${ANDROID_SDK_VERSION}-linux.zip \
 && rm tools_${ANDROID_SDK_VERSION}-linux.zip

ENV ANDROID_NDK_VERSION r14b

RUN wget -q https://dl.google.com/android/repository/android-ndk-${ANDROID_NDK_VERSION}-linux-x86_64.zip \
 && unzip -q android-ndk-${ANDROID_NDK_VERSION}-linux-x86_64.zip \
 && rm android-ndk-${ANDROID_NDK_VERSION}-linux-x86_64.zip

ENV ANDROID_HOME=/android
ENV ANDROID_NDK_HOME=/android/android-ndk-${ANDROID_NDK_VERSION}
ENV PATH=${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools:${ANDROID_NDK_HOME}:$PATH

RUN mkdir -p ${ANDROID_HOME}/licenses \
 && touch ${ANDROID_HOME}/licenses/android-sdk-license \
 && echo "\n8933bad161af4178b1185d1a37fbf41ea5269c55" >> $ANDROID_HOME/licenses/android-sdk-license \
 && echo "\nd56f5187479451eabf01fb78af6dfcb131a6481e" >> $ANDROID_HOME/licenses/android-sdk-license \
 && echo "\ne6b7c2ab7fa2298c15165e9583d0acf0b04a2232" >> $ANDROID_HOME/licenses/android-sdk-license \
 && echo "\n84831b9409646a918e30573bab4c9c91346d8abd" > $ANDROID_HOME/licenses/android-sdk-preview-license \
 && echo "\nd975f751698a77b662f1254ddbeed3901e976f5a" > $ANDROID_HOME/licenses/intel-android-extra-license

RUN yes | sdkmanager "platforms;android-23"
RUN mkdir -p ${ANDROID_HOME}/.android \
 && touch ~/.android/repositories.cfg ${ANDROID_HOME}/.android/repositories.cfg
RUN yes | sdkmanager "build-tools;26.0.2"

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

WORKDIR /tensorflow
# cd /tensorflow

RUN bazel fetch //tensorflow/examples/android:tensorflow_demo

COPY DetectorActivity.java /tensorflow/tensorflow/examples/android/src/org/tensorflow/demo/DetectorActivity.java
COPY INCMODEL.pb /tensorflow/tensorflow/examples/android/assets/INCMODEL.pb
COPY object-detection.pbtxt /tensorflow/tensorflow/examples/android/assets/object-detection.pbtxt
COPY WORKSPACE /tensorflow/WORKSPACE

RUN bazel build -c opt --local_resources 4096,4.0,1.0 -j 1 //tensorflow/examples/android:tensorflow_demo

VOLUME /outputs

CMD cp /tensorflow/bazel-bin/tensorflow/examples/android/tensorflow_demo.apk /outputs/tf.apk

