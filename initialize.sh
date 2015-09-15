#!/bin/bash

2015-09-14 20:17:11

ANDROID_SDK_FILENAME=android-sdk_r24.3.4-linux.tgz
ANDROID_NDK_FILENAME=android-ndk-r10e

install_pkgs() {
  # Use Gradle ppa to get latest gradle
  echo 'deb http://ppa.launchpad.net/cwchien/gradle/ubuntu trusty main' | sudo tee /etc/apt/sources.list.d/gradle.list
  echo 'deb-src http://ppa.launchpad.net/cwchien/gradle/ubuntu trusty main' | sudo tee --append /etc/apt/sources.list.d/gradle.list

  # Update & Add i386 Components that are needed
  sudo dpkg --add-architecture i386
  sudo apt-get update
  sudo apt-get upgrade
  sudo apt-get install -y libncurses5:i386 libstdc++6:i386 zlib1g:i386 lib32z1 lib32ncurses5 lib32bz2-1.0 libstdc++6:i386

  # Pull in all the Development stuff
  sudo apt-get install -y mc linux-headers-generic build-essential g++ ant git openjdk-7-jdk p7zip p7zip-full gradle
}


install_node() {
  echo Downloading Latest version of Node
  sudo wget -q --output-document=/usr/src/node-latest.tar.gz http://nodejs.org/dist/latest-v0.12.x/node-v0.12.7.tar.gz
  pushd /usr/src
  echo Extracting Node...
  sudo tar zxvf node-latest.tar.gz > /dev/null
  sudo chown -R $USER:$USER node-v*
  cd node-v*
  echo Compiling Node -- This might take a while...
  ./configure
  make
  sudo make install
  popd
}


install_android_sdk() {
  echo Downloading Latest version of Android SDK, this can take a while...
  sudo wget -q --output-document=/usr/src/android-sdk.tgz  http://dl.google.com/android/$ANDROID_SDK_FILENAME
  pushd /usr/local
  echo Extracting Android SDK...
  sudo tar zxvf /usr/src/android-sdk.tgz > /dev/null
  sudo chown -R $USER:$USER /usr/local/android-sdk-linux
  popd
}

create_exports() {
  # export for our current session
  export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64
  export ANT_HOME=/usr/local/ant
  export ANDROID_HOME=/usr/local/android-sdk-linux
  export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:/usr/local/$ANDROID_NDK_FILENAME


  # Write to the Non-Interactive bash file
  echo 'export ANDROID_HOME=/usr/local/android-sdk-linux' >> ~/.bashrc
  echo 'export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:/usr/local/$ANDROID_NDK_FILENAME' >> ~/.bashrc
  echo "export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64" >> ~/.bashrc
  echo "export ANT_HOME=/usr/local/ant" >> ~/.bashrc

  # Write to the Standard .Profile that everything uses
  if [[ -f ~/.profile ]]; then
    echo 'ANDROID_HOME=/usr/local/android-sdk-linux' >> ~/.profile
    echo 'PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:/usr/local/$ANDROID_NDK_FILENAME' >> ~/.profile
    echo "export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64" >> ~/.profile
    echo "export ANT_HOME=/usr/local/ant" >> ~/.profile
  fi

  if [[ -f ~/.bash_profile ]]; then
    echo 'export ANDROID_HOME=/usr/local/android-sdk-linux' >> ~/.bash_profile
    echo 'export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:/usr/local/$ANDROID_NDK_FILENAME' >> ~/.bash_profile
    echo "export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64" >> ~/.bash_profile
    echo "export ANT_HOME=/usr/local/ant" >> ~/.bash_profile
  fi
}

install_android_tools() {
  echo Installing Android Components This can take a while...
  # Yes, I fully realize I'm pulling android-17, 21 & 22.  17 & 21 are required for different parts of NativeScript; 22 is the latest
  ( sleep 7 && while [ 1 ]; do sleep 2; echo y; done ) | android update sdk --no-ui --filter platform-tool,android-17,android-21,android-22,build-tools-22.0.1
}

install_android_ndk() {
  echo Downloading Android NDK, this can take a while...
  sudo wget -q --output-document=/usr/src/$ANDROID_NDK_FILENAME.7z http://dl.google.com/android/ndk/$ANDROID_NDK_FILENAME-linux-x86_64.bin
  sudo chmod a+r /usr/src/$ANDROID_NDK_FILENAME.7z
  sudo mkdir /usr/local/$ANDROID_NDK_FILENAME
  sudo chmod 777 /usr/local/$ANDROID_NDK_FILENAME
  7z x /usr/src/$ANDROID_NDK_FILENAME.7z -o/usr/local
}

install_nativescript() {
  sudo npm install grunt -g --unsafe-perm
  sudo npm install grunt-cli -g --unsafe-perm
  sudo npm install nativescript -g --unsafe-perm
}

install_github_support() {
  mkdir ~/repos
  pushd ~/repos

  git clone https://github.com/NativeScript/NativeScript
  git clone https://github.com/NativeScript/android-runtime
  git clone https://github.com/NativeScript/nativescript-cli
  git clone https://github.com/NativeScript/android-metadata-generator

  cd NativeScript
  npm install
  cd ..

  cd android-runtime
  npm install
  cd ..

  cd nativescript-cli
  npm install
  cd ..

  cd android-metadata-generator
  npm install
  cd ..

  popd
}

install_network_support() {
  echo 'auto eth1' | sudo tee --append /etc/network/interfaces.d/eth1.cfg
  echo 'iface eth1 inet dhcp' | sudo tee --append /etc/network/interfaces.d/eth1.cfg
  sudo service networking restart
  sleep 5
}

create_exports
install_pkgs
install_node
install_android_sdk
install_android_tools
install_android_ndk
install_github_support
install_nativescript
install_network_support

echo "Done"



