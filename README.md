# SiteSync Offline Installation Script

SiteSync installation script for Debian Linux systems in air gapped environments .


### Usage
./offline-install.sh [options]
Options:
-d --> Install Docker
-c --> Load Chirpstack Docker images
-j --> Install Java
-i --> Install Ignition
-h --> Display this help message


### Directory Structure
└── sitesync-offline-install
    ├── chirpstack-docker
    ├── docker
    │   ├── *Docker installation files (.deb)* 
    ├── images
    │   ├── *Exported Docker images in .tar format*
    ├── java
    │   ├── *Java installation file (.deb)*
    ├── offline-install.sh
    ├── README.md
    ├── testArgs.sh
    └── uninstall.sh

### Docker Installation Files

If Docker is needed, installation files can be found at https://download.docker.com/linux/debian/dists/ and are categorized based on Debian distribution and system architecture.  

- ##### Determining Debian distribution
	-	System architecture can be determined by executing `cat /etc/debian_version` in the terminal

- ##### Determining system architecture:
	- System architecture can be determined by executing `arch` in the terminal

Once distribution and system architecture have been determined, latest versions of the packages below should be downloaded from the DISTRIBUTION/pool/stable/ARCHUTECTURE directory.
-   `containerd.io_<version>_<arch>.deb`
-   `docker-ce_<version>_<arch>.deb`
-   `docker-ce-cli_<version>_<arch>.deb`
-   `docker-buildx-plugin_<version>_<arch>.deb`
-   `docker-compose-plugin_<version>_<arch>.deb`

These downloaded files should be placed into the `/sitesync-offline-install/docker` directory

### Java Installation Files
If Java is needed, installation files can be found at https://www.oracle.com/java/technologies/downloads/#java21. 

The latest Debian package of JDK21 should be downloaded and placed into the  `/sitesync-offline-install/java` directory

