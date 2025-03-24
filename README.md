# Process PDF to Text Automation

## Overview
This repository contains an automated workflow that downloads PDF files from a designated Dropbox folder, processes them into a merged text file, and uploads the resulting file back to Dropbox. The workflow simplifies PDF-to-text conversion and ensures all files are processed seamlessly.

---

## How It Works
1. **Add PDF Files to Dropbox**:
   - Place the desired PDF files in the Dropbox folder `/Exchange/WebsitesToPdf`.

2. **Trigger the GitHub Workflow**:
   - Navigate to the **Actions** tab in this repository on GitHub.
   - Manually trigger the **"Run Process PDF to Text"** workflow by selecting it and clicking **"Run workflow"**. 
   - This workflow is officially named **"run process_pdf_to_text script"** within GitHub Actions.

3. **Resulting Output**:
   - After the workflow completes, the resulting text file (`merged.txt`) will be uploaded to `/Exchange/WebsitesToPdf` in Dropbox, replacing any existing file or creating a new one.







