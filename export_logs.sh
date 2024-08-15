#!/bin/sh

# Set default values for environment variables
MAX_LINES="${MAX_LINES:-1000}"
DAYS_BACK="${DAYS_BACK:-7}"
LOG_DIR="/mnt/usb"
LOG_FILE="$LOG_DIR/extracted_logs.log"
TMP_FILE="/tmp/extracted_logs.tmp"

# Ensure the USB drive is mounted
if ! mountpoint -q "$LOG_DIR"; then
    echo "USB drive not mounted at $LOG_DIR"
    exit 1
fi

# Extract logs from the last DAYS_BACK days
journalctl --since "$DAYS_BACK days ago" | tail -n $MAX_LINES > "$TMP_FILE"

# Move the temporary log file to the USB drive
mv "$TMP_FILE" "$LOG_FILE"

