#!/bin/bash

# Check if a file parameter is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <file>"
    exit 1
fi

# Get the file path from the parameter
input_file="$1"

# Check if the file exists
if [ ! -f "$input_file" ]; then
    echo "File $input_file not found!"
    exit 1
fi

# Directory where the input file is located
directory=$(dirname "$input_file")

# Split the file based on the pattern "------- New chunk -------"
awk -v dir="$directory" 'BEGIN {count=1}
    /------- New chunk -------/ {close(output_file); count++; next}
    {output_file = dir "/merged" count ".txt"; print > output_file}' "$input_file"

echo "File has been split into chunks in the directory: $directory"



