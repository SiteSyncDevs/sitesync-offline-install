#!/bin/bash

  PROJECT_DIR=$(pwd)
  DOCKER_DEB_DIR="$PROJECT_DIR/docker"
  GCC_DIR="$PROJECT_DIR/gcc"
  JAVA_DIR="$PROJECT_DIR/java" 
  JAVA_INSTALL_DIR="/usr/bin/java"
  FONTCONFIG_DIR="$PROJECT_DIR/fontconfig"
  CHIRPSTACK_DOCKER_IMAGES="$PROJECT_DIR/images" 
  APT_OFFLINE_DIR="$PROJECT_DIR/apt-offline"
  ALOXY_CORE_DIR="$PROJECT_DIR/aloxycore"
  
function installDocker() {

  if [ ! -d "$DOCKER_DEB_DIR" ]; then
    echo "ERROR: Unable to locate Docker installation files" >&2
    exit 1
  fi

  echo "Changing directory to $DOCKER_DEB_DIR"
  cd "$DOCKER_DEB_DIR"

  echo "INFO: Installing Docker"
  sudo dpkg -i *.deb 1>/dev/null || { echo "ERROR: Docker installation failed." >&2; exit 1; }
  echo "INFO: Docker installation from local media completed."


  echo "INFO: Adding user $USER to Docker management group"
  groupadd docker
  usermod -aG docker $USER

  echo "***************************************************** "
  echo "*                     NOTE                          * "
  echo "* You must log out of current session and re-login  * "
  echo "* for management group changes to take effect       * "
  echo "***************************************************** "

  echo "INFO: Docker installation complete"
}

function loadChirpstackImages(){
  echo "INFO: Loading Chirpstack Docker images"
  if [ -d "$CHIRPSTACK_DOCKER_IMAGES" ]; then
      for image_file in "$CHIRPSTACK_DOCKER_IMAGES"/*.tar; do
        if [ -f "$image_file" ]; then
          echo "INFO: Loading image from $image_file..."
            docker load < "$image_file" 1>/dev/null
        else
          echo "ERROR: No Chirpstack Docker images found in installation directory." >&2
        fi
      done
    else
      echo "ERROR: Directory $CHIRPSTACK_DOCKER_IMAGES not found." >&2
    fi
}
function loadAloxyCoreImage(){
  echo "INFO: Loading Aloxy Core Docker image"
  if [ -d "$ALOXY_CORE_DIR" ]; then
      for image_file in "$ALOXY_CORE_DIR"/*.tar; do
        if [ -f "$image_file" ]; then
          echo "INFO: Loading image from $image_file..."
            docker load < "$image_file" 1>/dev/null
        else
          echo "ERROR: No Aloxy Core Docker images found in installation directory." >&2
        fi
      done
    else
      echo "ERROR: Directory $ALOXY_CORE_DIR not found." >&2
    fi
}

function installJava(){
  echo "INFO: Preparing to install Java"
  if [ ! -d "$JAVA_DIR" ]; then
    echo "ERROR: Directory $JAVA_DIR does not exist." >&2
    exit 1
  fi

  JAVA_DEB=$(find "$JAVA_DIR" -type f -name "*.deb")

  if [ -z "$JAVA_DEB" ]; then
    echo "ERROR: No Java installation file found in $JAVA_DIR." >&2
    exit 1
  else
      echo "INFO: Found Java installation package: $JAVA_DEB"
      echo "INFO: Installing Java"
      sudo dpkg -i $JAVA_DEB 1>/dev/null
      echo "INFO: Java installation complete"
  fi
}

function installAptOffline(){
  echo "INFO: Preparing to install APT Offline"
  if [ ! -d "$APT_OFFLINE_DIR" ]; then
    echo "ERROR: Directory $APT_OFFLINE_DIR does not exist." >&2
    exit 1
  fi

  APT_OFFLINE_DEB=$(find "$APT_OFFLINE_DIR" -type f -name "*.deb")

  if [ -z "$APT_OFFLINE_DEB" ]; then
    echo "ERROR: No apt-offline installation file found in $APT_OFFLINE_DIR." >&2
    exit 1
  else
      echo "INFO: Found apt-offline installation package: $APT_OFFLINE_DEB"
      echo "INFO: Installing apt-offline"
      sudo dpkg -i $APT_OFFLINE_DEB 1>/dev/null
      echo "INFO: apt-offline installation complete"
  fi
}


function printUsage() {
  echo "Usage: $0 [options]"
  echo "Options:"
  echo "  -d      Install and load Docker images"
  echo "  -c      Load Chirpstack Docker images"
  echo "  -a      Load Aloxy Core Docker images"
  echo "  -j      Install Java"
  echo "  -i      Install Ignition"
  echo "  -o      Install APT Offline"
  echo "  -A      Install everything"
  echo "  -h      Display this help message"
  echo "  --help  Display this help message"
}

function main(){
 

  if [ "$(id -u)" != "0" ]; then
    echo "ERROR: This script must be run as root" 1>&2
    exit 1
  fi

  for arg in "$@"; do
    if [[ "$arg" == "--help" ]]; then
        printUsage
        exit 0
    fi
  done

  for arg in "$@"; do
      if [[ "$arg" == "-h" || "$arg" == "--help" ]]; then
          printUsage
          exit 0
      fi
      if [[ "$arg" =~ "h" && "${#arg}" -gt 2 ]]; then
          echo "Error: '-h' cannot be used with other options."
          printUsage
          exit 1
      fi
  done
  local installAll=false

  while getopts "djicahA" flag
  do
      case "${flag}" in
          h) printUsage exit 0;;
          d) installDocker;;
          j) installJava;;
          o) loadAloxyImages;;
          i) installIgnition;;
          c) loadChirpstackImages;;
          a) installAptOffline;;
          A) installAll=true;;
          \?) 
              echo "Invalid option: -${OPTARG}" >&2
              printUsage
              exit 1
              ;;
          :) # Handle missing option arguments
              echo "Option -${OPTARG} requires an argument." >&2
              printUsage
              exit 1
              ;;
      esac
  done

  if [[ "$installAll" == "true" ]]; then
      installDocker
      installJava
      installIgnition
      loadChirpstackImages
      installAptOffline
  fi

  if [[ "$installDocker" == "true" ]]; then


  

}

main "$@"