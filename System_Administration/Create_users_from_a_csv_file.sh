#!/bin/bash
# This cript creates users from a CSV file..
set -e

# Check for CSV input
if [ $# -lt 1 ]; then
    echo "Usage: $0 <file.csv> [--dry-run]"
    exit 1
fi

CSV_FILE="$1"
DRY_RUN=false

# Check for optional --dry-run flag
if [[ "$2" == "--dry-run" ]]; then
    DRY_RUN=true
fi

# Check if file exists
if [ ! -f "$CSV_FILE" ]; then
    echo "Error: File '$CSV_FILE' not found!"
    exit 2
fi

# Read CSV line by line
while IFS=',' read -r username fullname; do
    if [[ "$username" == "username" ]] || [[ -z "$username" ]]; then
        continue
    fi

    if id "$username" &>/dev/null; then
        echo "User '$username' already exists. Skipping..."
        continue
    fi

    password=$(openssl rand -base64 12)

    if [ "$DRY_RUN" = true ]; then
        echo "[DRY RUN] Would create user: $username ($fullname) | Password: $password"
    else
        sudo useradd -m -c "$fullname" "$username"
        echo "$username:$password" | sudo chpasswd
        sudo passwd -e "$username"
        echo "User created: $username ($fullname) | Password: $password"
    fi
done < "$CSV_FILE"
