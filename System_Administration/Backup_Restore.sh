#!/bin/bash

# === Configuration ===
BACKUP_DIR="/path/to/backup"  # <-- Set this to your actual backup location

# === Argument check ===
if [ $# -ne 2 ]; then
    echo "Usage: $0 <backup_date> <directory_to_restore>"
    exit 1
fi

RESTORE_DATE="$1"
RESTORE_DIR="$2"

# === Verify backup exists ===
if [ ! -d "$BACKUP_DIR/$RESTORE_DATE/$RESTORE_DIR" ]; then
    echo "❌ No backup found for date '$RESTORE_DATE' and directory '$RESTORE_DIR'"
    exit 1
fi

# === Prevent restoring to root or unsafe target ===
if [[ "$RESTORE_DIR" == "/" || "$RESTORE_DIR" == "" ]]; then
    echo "⚠️ Refusing to restore to root ('/') — specify a subdirectory."
    exit 1
fi

# === Perform restoration ===
echo "🔁 Restoring '$RESTORE_DIR' from backup dated '$RESTORE_DATE'..."

sudo rsync -avz --delete \
    "$BACKUP_DIR/$RESTORE_DATE/$RESTORE_DIR/" "/$RESTORE_DIR/"

echo "✅ Restoration of '$RESTORE_DIR' from $RESTORE_DATE completed."
