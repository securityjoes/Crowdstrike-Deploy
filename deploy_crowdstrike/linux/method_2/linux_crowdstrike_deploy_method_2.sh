#!/bin/bash

# Crowdstrike-Deploy Banner
echo ""
echo "  ██████╗██████╗  ██████╗ ██╗    ██╗██████╗ ███████╗████████╗██████╗ ██╗██╗  ██╗███████╗"
echo " ██╔════╝██╔══██╗██╔═══██╗██║    ██║██╔══██╗██╔════╝╚══██╔══╝██╔══██╗██║██║ ██╔╝██╔════╝"
echo " ██║     ██████╔╝██║   ██║██║ █╗ ██║██║  ██║███████╗   ██║   ██████╔╝██║█████╔╝ █████╗"
echo " ██║     ██╔══██╗██║   ██║██║███╗██║██║  ██║╚════██║   ██║   ██╔══██╗██║██╔═██╗ ██╔══╝"
echo " ╚██████╗██║  ██║╚██████╔╝╚███╔███╔╝██████╔╝███████║   ██║   ██║  ██║██║██║  ██╗███████╗"
echo "  ╚═════╝╚═╝  ╚═╝ ╚═════╝  ╚══╝╚══╝ ╚═════╝ ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝╚═╝  ╚══════╝"
echo ""
echo "                     ██████╗ ███████╗██████╗ ██╗      ██████╗ ██╗   ██╗"
echo "                     ██╔══██╗██╔════╝██╔══██╗██║     ██╔═══██╗╚██╗ ██╔╝"
echo "                     ██║  ██║█████╗  ██████╔╝██║     ██║   ██║ ╚████╔╝"
echo "                     ██║  ██║██╔══╝  ██╔═══╝ ██║     ██║   ██║  ╚██╔╝"
echo "                     ██████╔╝███████╗██║     ███████╗╚██████╔╝   ██║"
echo "                     ╚═════╝ ╚══════╝╚═╝     ╚══════╝ ╚═════╝    ╚═╝"
echo ""
echo "                           Created & Maintained by: Eilay Yosfan"
echo "                                   GitHub.com/YosfanEilay"
echo "                                          Method: 2"
echo ""

set -e

####################### Please Paste Your Information in Here ##############
Operation=""             # Choose operation: "Split" or "Deploy"
Parts=""                 # Number of parts to split the file into
OriginalFilePath=""      # Full path to the original file (for splitting)
SplittedFilesLocation="" # Path where split parts are stored (for deploying)
CrowdstrikeCID=""        # Tenant CID string
TenantName=""            # Display name for tenant (for logging)
############################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

split_file() {
    if [ ! -f "$OriginalFilePath" ]; then
        echo "Error: File not found: $OriginalFilePath"
        exit 1
    fi

    FILESIZE=$(stat -c%s "$OriginalFilePath")
    CHUNK_SIZE=$(( (FILESIZE + Parts - 1) / Parts ))

    echo "Splitting '$OriginalFilePath' into $Parts parts..."

    for ((i=1; i<=Parts; i++)); do
        OFFSET=$(( (i - 1) * CHUNK_SIZE ))
        OUTPUT_FILE="$SCRIPT_DIR/file_split_part_$i"
        dd if="$OriginalFilePath" of="$OUTPUT_FILE" bs=1 skip=$OFFSET count=$CHUNK_SIZE status=none
        echo "Created: $OUTPUT_FILE"
    done

    echo "Split complete."
}

deploy_sensor() {
    echo "Rebuilding original file from parts in: $SplittedFilesLocation"

    OUTPUT_FILE="$SCRIPT_DIR/CrowdstrikeSensor.deb"
    rm -f "$OUTPUT_FILE"

    for part in $(ls "$SplittedFilesLocation"/file_split_part_* 2>/dev/null | sort -V); do
        cat "$part" >> "$OUTPUT_FILE"
        echo "Appended: $part"
    done

    if [ ! -f "$OUTPUT_FILE" ]; then
        echo "Error: Reconstructed file not found."
        exit 1
    fi

    echo "Crowdstrike sensor file reconstructed as: $OUTPUT_FILE"
    echo ""

    echo "[+] Starting Crowdstrike sensor installation..."
    dpkg -i "$OUTPUT_FILE"

    echo "[+] Waiting for the service to settle..."
    sleep 60

    echo "[+] Configuring sensor with CID..."
    /opt/CrowdStrike/falconctl -s --cid="$CrowdstrikeCID" -f

    echo "[+] Starting falcon-sensor service..."
    systemctl start falcon-sensor

    echo "[+] Verifying that falcon-sensor is running:"
    ps aux | grep "[f]alcon"

    echo ""
    echo "[+] Done. Host will appear in the Falcon console under tenant '$TenantName' in 5-10 minutes."
}

case "$Operation" in
    "Split")
        split_file
        ;;
    "Deploy")
        deploy_sensor
        ;;
    *)
        echo "Error: Unknown Operation: $Operation (use 'Split' or 'Deploy')"
        exit 1
        ;;
esac

