#!/bin/bash
set -e

IMAGE_NAME="react-native-pjsip-builder/android"
CONTAINER_NAME="react-native-pjsip-builder-${RANDOM}"

rm -rf ./android-dist;

docker build -t react-native-pjsip-builder/android ./android/;
docker run --name ${CONTAINER_NAME} ${IMAGE_NAME} bin/true

docker cp ${CONTAINER_NAME}:/output/pjsip ./android-dist
rm -rf ./android-dist/pjsip/java/org/pjsip/pjsua2/app;

docker rm ${CONTAINER_NAME}
