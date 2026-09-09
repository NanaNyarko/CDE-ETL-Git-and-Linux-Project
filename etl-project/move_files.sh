#!/bin/bash
# This script moves all .csv and .json files from one folder
# into a folder called json_and_CSV.

# The folder to search is given as the first argument when running the script
SOURCE_DIR=$1

# The destination folder is always named json_and_CSV
DEST_DIR="json_and_CSV"

# Create the destination folder if it doesn't already exist
mkdir -p "$DEST_DIR"

# Move all .csv files into the destination folder
mv "$SOURCE_DIR"/*.csv "$DEST_DIR"/ 2>/dev/null

# Move all .json files into the destination folder
mv "$SOURCE_DIR"/*.json "$DEST_DIR"/ 2>/dev/null

echo "Done. CSV and JSON files moved into $DEST_DIR"
