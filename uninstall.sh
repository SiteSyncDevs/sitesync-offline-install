#!/bin/bash

# List of Docker package names to uninstall.
# These should be the same names used during the installation.
PACKAGES=(
  "containerd.io"
  "docker-ce"
  "docker-ce-cli"
  "docker-buildx-plugin"
  "docker-compose-plugin"
)

# Uninstall each package listed above.
for PACKAGE in "${PACKAGES[@]}"; do
  echo "Uninstalling $PACKAGE..."
  sudo dpkg --purge "$PACKAGE"
done

echo "Docker packages have been uninstalled."
