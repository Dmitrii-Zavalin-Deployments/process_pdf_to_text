# Process PDF to Text Automation

## Overview
This repository contains an automated workflow that downloads PDF files from a designated Dropbox folder, processes them into a merged text file, splits the text into smaller files of manageable size, and uploads all resulting files back to Dropbox. The workflow simplifies PDF-to-text conversion and ensures all files are processed seamlessly.

---

## How It Works
1. **Add PDF Files to Dropbox**:
   - Place the desired PDF files in the Dropbox folder `/Exchange/WebsitesToPdf`.

2. **Trigger the GitHub Workflow**:
   - Navigate to the **Actions** tab in this repository on GitHub.
   - Manually trigger the **"Run Process PDF to Text"** workflow by selecting it and clicking **"Run workflow"**. 
   - This workflow is officially named **"run process_pdf_to_text script"** within GitHub Actions.

3. **Resulting Output**:
   - The workflow processes all the PDF files in the folder into a single merged text file, named `merged.txt`.
   - The content in `merged.txt` is then split into smaller text files, each containing no more than 10,000 characters. These files are sequentially named `merged<number>.txt` (e.g., `merged1.txt`, `merged2.txt`, etc.) in the order the text appears in `merged.txt`.
   - All files (`merged.txt` and the `merged<number>.txt` files) are uploaded to the `/Exchange/WebsitesToPdf` folder in Dropbox. Existing files with the same names are replaced.



