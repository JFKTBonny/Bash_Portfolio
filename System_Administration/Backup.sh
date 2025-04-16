#!/bin/bash

# === Configuration ===
BACKUP_DIR="/path/to/backup"
SOURCE_DIRS=("/etc" "/home" "/var/www")
DATE=$(date +%Y-%m-%d)
DEST_DIR="$BACKUP_DIR/$DATE"
LATEST_LINK="$BACKUP_DIR/latest"

# === Ensure the backup root directory exists ===
mkdir -p "$BACKUP_DIR"
mkdir -p "$DEST_DIR"

# === Perform incremental backups ===
for dir in "${SOURCE_DIRS[@]}"; do
    dirname=$(basename "$dir")
    src="$dir"
    dest="$DEST_DIR/$dirname"
    link_dest="$LATEST_LINK/$dirname"

    echo "Backing up $src to $dest..."

    rsync -avz --delete \
        --link-dest="$link_dest" \
        "$src/" "$dest/"
done

# === Update the symbolic link to latest backup ===
rm -f "$LATEST_LINK"
ln -s "$DEST_DIR" "$LATEST_LINK"

echo " Incremental backup completed for: $DATE"
