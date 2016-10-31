die () {
    if [ -n "$1" ]; then
        >&2 echo -n $(tput setaf 1)
        >&2 echo -e "$1"
        >&2 echo -n $(tput sgr0)
    fi
    exit 1
}

need_rg() {
    RG=$1
    if [ -z "$RG" ]; then
        echo "Please specify a resource group. Here's the list: "
        azure_display_rgs
        die
    fi
}

need_ips_file() {
    IPS_FILE=$1
    if [ -z "$IPS_FILE" ]; then
        echo "IPS_FILE not set."
        die
    fi

    if [ ! -s "$IPS_FILE" ]; then
        echo "IPS_FILE $IPS_FILE not found. Please run: trainer ips <TAG>"
        die
    fi
}
