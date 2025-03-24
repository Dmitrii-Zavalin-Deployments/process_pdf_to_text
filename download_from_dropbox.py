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

# Function to download PDFs from a specified Dropbox folder
def download_pdfs_from_dropbox(dropbox_folder, local_folder, refresh_token, client_id, client_secret, log_file_path, file_list_path=None):
    # Refresh the access token
    access_token = refresh_access_token(refresh_token, client_id, client_secret)
    dbx = dropbox.Dropbox(access_token)

    with open(log_file_path, "a") as log_file:
        log_file.write("Starting download process...\n")
        try:
            os.makedirs(local_folder, exist_ok=True)

            # Initialize the list of files to download
            files_to_download = []
            if file_list_path and os.path.exists(file_list_path):
                with open(file_list_path, 'r') as file_list:
                    files_to_download = [line.strip() for line in file_list.readlines()]
                log_file.write(f"Files to download: {files_to_download}\n")

            # Handle pagination
            has_more = True
            cursor = None
            while has_more:
                if cursor:
                    result = dbx.files_list_folder_continue(cursor)
                else:
                    result = dbx.files_list_folder(dropbox_folder)
                log_file.write(f"Listing files in Dropbox folder: {dropbox_folder}\n")

                for entry in result.entries:
                    if isinstance(entry, dropbox.files.FileMetadata) and entry.name.endswith('.pdf'):
                        file_name_without_extension = os.path.splitext(entry.name)[0]
                        if not files_to_download or file_name_without_extension in files_to_download:
                            local_path = os.path.join(local_folder, entry.name)
                            with open(local_path, "wb") as f:
                                metadata, res = dbx.files_download(path=entry.path_lower)
                                f.write(res.content)
                            log_file.write(f"Downloaded {entry.name} to {local_path}\n")
                            print(entry.name)  # Print only the name of the downloaded file to GitHub Actions logs

                has_more = result.has_more
                cursor = result.cursor

            log_file.write("Download completed successfully.\n")
        except dropbox.exceptions.ApiError as err:
            log_file.write(f"Error downloading files: {err}\n")
            print(f"Error downloading files: {err}")  # Log the error in GitHub Actions
        except Exception as e:
            log_file.write(f"Unexpected error: {e}\n")
            print(f"Unexpected error: {e}")  # Log the error in GitHub Actions

# Entry point for the script
if __name__ == "__main__":
    # Read command-line arguments
    dropbox_folder = sys.argv[1]  # Dropbox folder path
    local_folder = sys.argv[2]  # Local folder path
    refresh_token = sys.argv[3]  # Dropbox refresh token
    client_id = sys.argv[4]  # Dropbox client ID
    client_secret = sys.argv[5]  # Dropbox client secret
    log_file_path = sys.argv[6]  # Path to the log file

    # Call the function
    download_pdfs_from_dropbox(dropbox_folder, local_folder, refresh_token, client_id, client_secret, log_file_path)



