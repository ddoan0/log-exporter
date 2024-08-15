#!/bin/bash

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> /var/log/usb-mount.log
}

ALLOWED_UUIDS="01194a5c-f2aa-420c-9d41-a84ded34a11b" # UUID for a flash drive
DEVICE="/dev/$1"

if [ ! -b "$DEVICE" ]; then
    log "Device $DEVICE does not exist"
    exit 1
fi

UUID=$(blkid -s UUID -o value $DEVICE)

if [ -z "$UUID" ]; then
    log "Failed to get UUID for device $DEVICE"
    exit 1
fi


if [[ ! " $ALLOWED_UUIDS " =~ " $UUID " ]]; then
    log "UUID $UUID is not in the list of allowed UUIDs"
    exit 1
fi	

MOUNT_POINT="/mnt/usb-$UUID"

if [ -d "$MOUNT_POINT" ]; then
    log "Mount point $MOUNT_POINT already exists"

    if mountpoint -q "$MOUNT_POINT"; then
        log "Device is already mounted at $MOUNT_POINT"
	exit 0
    fi
else
    if ! mkdir -p $MOUNT_POINT; then
	log "Failed to create mount point $MOUNT_POINT"
	exit 1
    fi
fi

if ! mount $DEVICE $MOUNT_POINT; then
    log "Failed to mount $DEVICE to $MOUNT_POINT"
    exit 1
fi

log "Successfully mounted $DEVICE to $MOUNT_POINT
exit 0
