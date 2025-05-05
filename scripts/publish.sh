#!/bin/bash

source .env

# Base paths
DRAFTS_DIR="$HOME/$DRAFTS_PATH"
PUBLISHED_DIR="$HOME/$PUBLISHED_PATH"
ARCHIVE_DIR="$HOME/$ARCHIVE_PATH"
LOG_DIR="$HOME/$LOGS_PATH"
LOG_FILE="$LOG_DIR/publish.log"

# Ensure the folders exist
mkdir -p "$DRAFTS_DIR" "$PUBLISHED_DIR" "$ARCHIVE_DIR" "$LOG_DIR"

# # Find the first .md file in drafts
ARTICLE=$(find "$DRAFTS_DIR" -maxdepth 1 -type f -name "*.md" | sort | head -n 1)

if [[ -z "$ARTICLE" ]]; then
  echo "No markdown files to publish in $DRAFTS_DIR."
  echo "$(date '+%Y-%m-%d %H:%M:%S') - No articles to publish." >> "$LOG_FILE"
  exit 0
fi

# Get the filename
FILENAME=$(basename "$ARTICLE")

# Copy the file to published
cp "$DRAFTS_DIR/$FILENAME" "$PUBLISHED_DIR/$FILENAME"

# Save current directory
ORIGINAL_DIR=$(pwd)

# Move to the published repo and commit
cd "$PUBLISHED_DIR" || exit 1

git add "$FILENAME"
if git commit -m "Publish article: $FILENAME" && git push $REMOTE $BRANCH; then
    # Move the original draft to archive
    mv "$DRAFTS_DIR/$FILENAME" "$ARCHIVE_DIR"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Published and archived: $FILENAME" >> "$LOG_FILE"
    echo "✅ Published and archived: $FILENAME"
else
    # If git fails, remove the copied file from published
    rm "$PUBLISHED_DIR/$FILENAME"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Failed to publish: $FILENAME" >> "$LOG_FILE"
    echo "❌ Failed to publish: $FILENAME"
    exit 1
fi

# Go back to the original repo
cd "$ORIGINAL_DIR"
