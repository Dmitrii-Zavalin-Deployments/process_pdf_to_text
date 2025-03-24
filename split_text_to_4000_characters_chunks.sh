#!/bin/bash

# Function to split the text into chunks
split_text_into_chunks() {
  local input_file=$1
  local chunk_size=10000 # Updated 4000 to 10000 in this line. If needed return to 4000 here
  local current_chunk=""
  local result=""
  
  while IFS= read -r line || [[ -n "$line" ]]; do
    if [ $((${#current_chunk} + ${#line} + 1)) -le $chunk_size ]; then
      current_chunk+="$line\n"
    else
      if [ -n "$current_chunk" ]; then
        result+="$current_chunk\n\n------- New chunk -------\n\n"
        current_chunk=""
      fi
      current_chunk+="$line\n"
    fi
  done < "$input_file"

  if [ -n "$current_chunk" ]; then
    result+="$current_chunk"
  fi

  echo -e "$result" > "$input_file"
}

# Check if the path to the txt file is provided
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 path_to_txt_file"
  exit 1
fi

# Run the function with the provided input file
split_text_into_chunks "$1"