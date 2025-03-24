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

# Run the additional processing shell script
if [ -x ./process_downloaded_pdfs.sh ]; then
    echo "Running process_downloaded_pdfs.sh..."
    ./process_downloaded_pdfs.sh
else
    echo "process_downloaded_pdfs.sh is not found or not executable."
    exit 1
fi

# Run the upload script to replace or create merged.txt in Dropbox
if [ -f ./upload_to_dropbox.py ]; then
    echo "Running upload_to_dropbox.py to upload merged.txt..."
    python3 upload_to_dropbox.py "$REFRESH_TOKEN" "$APP_KEY" "$APP_SECRET"
else
    echo "upload_to_dropbox.py is not found."
    exit 1
fi



