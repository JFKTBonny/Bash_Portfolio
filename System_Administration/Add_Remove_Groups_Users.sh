#!/bin/bash

# Make sure the number of arguments is correct
if [ $# -ne 3 ]; then
    echo "Usage: $0 <add|remove> <group> <user>"
    exit 1
fi

ACTION="$1"
GROUP="$2"
TARGET_USER="$3"

# Check if the group exists
if ! getent group "$GROUP" > /dev/null 2>&1; then
    echo "Error: The group '$GROUP' does not exist."
    exit 1
fi

# Check if the user exists
if ! id -u "$TARGET_USER" > /dev/null 2>&1; then
    echo "Error: The user '$TARGET_USER' does not exist."
    exit 1
fi

# Perform the requested action
case "$ACTION" in
    add)
        sudo usermod -a -G "$GROUP" "$TARGET_USER"
        echo "User '$TARGET_USER' has been added to group '$GROUP'."
        ;;
    remove)
        sudo gpasswd -d "$TARGET_USER" "$GROUP"
        echo "User '$TARGET_USER' has been removed from group '$GROUP'."
        ;;
    *)
        echo "Unknown action: '$ACTION'. Use 'add' or 'remove'."
        exit 1
        ;;
esac
