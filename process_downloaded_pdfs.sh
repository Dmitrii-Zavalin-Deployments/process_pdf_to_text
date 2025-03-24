#!/bin/bash

# Directory containing downloaded PDFs
default_pdf_dir="./downloaded_pdfs"

# Check if the directory exists; if not, create it
if [ ! -d "$default_pdf_dir" ]; then
    echo "The directory for PDFs does not exist. Creating $default_pdf_dir..."
    mkdir -p "$default_pdf_dir"
else
    echo "The directory for PDFs already exists: $default_pdf_dir"
fi

# Verify if there are PDF files in the directory
pdf_files=$(find "$default_pdf_dir" -maxdepth 1 -name "*.pdf")

if [ -z "$pdf_files" ]; then
    echo "No PDF files found in $default_pdf_dir. Please ensure files are downloaded before running this script."
    exit 1
fi

echo "Found the following PDF files in $default_pdf_dir:"
for pdf_file in $pdf_files; do
    echo "$(basename "$pdf_file")"
done

# Install Python3 if not installed
if ! command -v python3 &> /dev/null; then
    echo "Python3 is not installed. Installing Python3..."
    sudo apt-get update
    sudo apt-get install -y python3
else
    echo "Python3 is already installed."
fi

# Install pip if not installed
if ! command -v pip &> /dev/null; then
    echo "pip is not installed. Installing pip..."
    sudo apt-get update
    sudo apt-get install -y python3-pip
else
    echo "pip is already installed."
fi

# Install PyMuPDF if not installed
if ! pip show pymupdf > /dev/null 2>&1; then
    echo "PyMuPDF is not installed. Installing now..."
    pip install pymupdf
else
    echo "PyMuPDF is already installed."
fi

# Run PDFMerge.sh if it exists
if [ -x ./PDFMerge.sh ]; then
    echo "Running PDFMerge.sh on $default_pdf_dir..."
    ./PDFMerge.sh "$default_pdf_dir"
else
    echo "PDFMerge.sh is not found or not executable."
    exit 1
fi

# Set the merged PDF path
pdf_path="$default_pdf_dir/merged.pdf"

# Run the Python script to convert merged PDF to text
if [ -f ./pdf_to_text.py ]; then
    echo "Running pdf_to_text.py on $pdf_path..."
    python3 pdf_to_text.py "$pdf_path" false
else
    echo "pdf_to_text.py is not found."
    exit 1
fi

# Split text into chunks using split_text_to_4000_characters_chunks.sh if it exists
txt_path="$default_pdf_dir/merged.txt"

if [ -f "$txt_path" ] && [ -x ./split_text_to_4000_characters_chunks.sh ]; then
    echo "Splitting $txt_path into smaller chunks..."
    ./split_text_to_4000_characters_chunks.sh "$txt_path"
    echo "Text has been split into chunks."
else
    echo "split_text_to_4000_characters_chunks.sh is not found or $txt_path does not exist."
    exit 1
fi

# delete the merged PDF
rm "$pdf_path"
echo "The merged.pdf file was deleted."



