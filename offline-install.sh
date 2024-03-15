#!/bin/bash

  PROJECT_DIR=$(pwd)
  DOCKER_DEB_DIR="$PROJECT_DIR/docker"
  GCC_DIR="$PROJECT_DIR/gcc"
  JAVA_DIR="$PROJECT_DIR/java" 
  JAVA_INSTALL_DIR="/usr/bin/java"
  FONTCONFIG_DIR="$PROJECT_DIR/fontconfig"
  CHIRPSTACK_DOCKER_IMAGES="$PROJECT_DIR/images" 

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



function printUsage() {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  -d      Install and load Docker images"
    echo "  -c      Load Chirpstack Docker images"
    echo "  -j      Install Java"
    echo "  -i      Install Ignition"
    echo "  -h      Display this help message"
    echo "  --help"
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


  while getopts "djich" flag
  do
      case "${flag}" in
          h) printUsage exit 0;;
          d) installDocker;;
          j) installJava;;
          i) installIgnition=true;;
          c) loadChirpstackImages;;
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

  if [[ "$installDocker" == "true" ]]; then
    echo "Docker will be installed"
  fi
    if [[ "$installJava" == "true" ]]; then
    echo "Java will be installed"
  fi
    if [[ "$installIgnition" == "true" ]]; then
    echo "Ignition will be installed"
  fi
    if [[ "$loadChirpstack" == "true" ]]; then
    echo "Chirp will be installed"
  fi

}

main "$@"
