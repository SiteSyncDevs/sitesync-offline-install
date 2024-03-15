
installDocker=false
installJava=false
installIgnition=false
loadChirpstack=false

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

while getopts ":djich" flag
do
    case "${flag}" in
        h) printUsage exit 0;;
        d) installDocker=true;;
        j) installJava=true;;
        i) installIgnition=true;;
        c) loadChirpstack=true;;
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

if ! $installDocker && 
    ! $installJava && 
    ! $installIgnition && 
    ! $loadChirpstack; 
    then
    echo "No valid options were provided."
    printUsage
    exit 1
fi
echo "Docker: $installDocker";
echo "Java: $installJava";
echo "Ignition: $installIgnition";
echo "Chirpstack: $loadChirpstack";