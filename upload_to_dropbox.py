import dropbox
import os
import requests
import sys

# Function to refresh the access token
def refresh_access_token(refresh_token, client_id, client_secret):
    url = "https://api.dropbox.com/oauth2/token"
    data = {
        "grant_type": "refresh_token",
        "refresh_token": refresh_token,
        "client_id": client_id,
        "client_secret": client_secret
    }
    response = requests.post(url, data=data)
    if response.status_code == 200:
        return response.json()["access_token"]
    else:
        raise Exception("Failed to refresh access token")

# Function to upload a file to Dropbox
def upload_file_to_dropbox(local_file_path, dropbox_file_path, refresh_token, client_id, client_secret):
    # Refresh the access token
    access_token = refresh_access_token(refresh_token, client_id, client_secret)
    dbx = dropbox.Dropbox(access_token)
    
    try:
        with open(local_file_path, "rb") as f:
            dbx.files_upload(f.read(), dropbox_file_path, mode=dropbox.files.WriteMode.overwrite)
        print(f"Uploaded file to Dropbox: {dropbox_file_path}")
    except Exception as e:
        print(f"Failed to upload file to Dropbox: {e}")

# Entry point for the script
if __name__ == "__main__":
    # Command-line arguments
    local_file_path = "./downloaded_pdfs/merged.txt"  # Path to the local file
    dropbox_folder = "/Exchange/WebsitesToPdf"       # Dropbox folder path
    dropbox_file_path = f"{dropbox_folder}/merged.txt"  # Path to the file in Dropbox
    refresh_token = sys.argv[1]                     # Dropbox refresh token
    client_id = sys.argv[2]                         # Dropbox client ID
    client_secret = sys.argv[3]                     # Dropbox client secret

    # Call the upload function
    upload_file_to_dropbox(local_file_path, dropbox_file_path, refresh_token, client_id, client_secret)



