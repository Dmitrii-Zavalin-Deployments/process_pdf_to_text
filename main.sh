#!/bin/bash

# Set environment variables from GitHub Actions secrets
APP_KEY=${APP_KEY}
APP_SECRET=${APP_SECRET}
REFRESH_TOKEN=${REFRESH_TOKEN}
DROPBOX_FOLDER="/Exchange/WebsitesToPdf" # Set your Dropbox folder
LOCAL_FOLDER="./downloaded_pdfs" # Set your local folder
LOG_FILE="./action_log.txt"

# Create the local folder if it doesn't exist
mkdir -p $LOCAL_FOLDER

# Run the Python script to call the download function
python3 download_from_dropbox.py "$DROPBOX_FOLDER" "$LOCAL_FOLDER" "$REFRESH_TOKEN" "$APP_KEY" "$APP_SECRET" "$LOG_FILE"



