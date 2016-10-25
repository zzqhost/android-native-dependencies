#!/usr/bin/bash
#########################################################################
# File Name: deploy.sh
# Author: zhangzhiqiang

source ./deploy-common.sh


theVersion=`cat ../build.gradle | grep "version" | cut -d ' ' -f2 | cut -d "'" -f2`
echo "packing version: $theVersion"

cd ..
pwd
gradle clean; gradle assemble
find . -name *.jar
mydeplay_snapshot -f "./build/libs/android-native-dependencies-${theVersion}.jar" -g 'com.jingdong.wireless.tools' -a 'android-native-dependencies' -p 'jar' -v "$theVersion"
cd -
