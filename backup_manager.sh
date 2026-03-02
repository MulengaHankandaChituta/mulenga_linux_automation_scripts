#!/bin/bash

SOURCE_DIR=$1
BACKUP_DIR="$HOME/backups"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
LOG_FILE="$BACKUP_DIR/backup.log"
RETENTION_DAYS=7

if [ -z "$SOURCE_DIR" ]; then
    echo "Usage: ./backup_manager.sh /path/to/directory"
    exit 1
fi

# Make sure backup directory exists
mkdir -p "$BACKUP_DIR"

ARCHIVE_NAME="backup_$TIMESTAMP.tar.gz"

# Use variables correctly with $
tar -czf "$BACKUP_DIR/$ARCHIVE_NAME" "$SOURCE_DIR"

if [ $? -eq 0 ]; then
    echo "$TIMESTAMP - Backup successful: $ARCHIVE_NAME" >> "$LOG_FILE"
    echo "Backup completed successfully: $ARCHIVE_NAME"
else
    echo "$TIMESTAMP - Backup failed" >> "$LOG_FILE"
    echo "Backup failed."
fi

# Delete old backups
find "$BACKUP_DIR" -type f -mtime +$RETENTION_DAYS -name "*.tar.gz" -exec rm {} \;
