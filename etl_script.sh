#!/bin/bash
# This script downloads a CSV file, cleans it up, and saves the final version.
# It has 3 steps: Extract, Transform, Load (ETL).

# Store the download link in a variable, so it's easy to change later.
export CSV_URL="https://www.stats.govt.nz/assets/Uploads/Annual-enterprise-survey/Annual-enterprise-survey-2023-financial-year-provisional/Download-data/annual-enterprise-survey-2023-financial-year-provisional.csv"

echo "Starting ETL process..."

# ------------------------------------------------------------
# STEP 1: EXTRACT - download the CSV file into the raw folder
# ------------------------------------------------------------
echo "Step 1: Extracting data..."

# Create the raw folder if it doesn't already exist
mkdir -p raw

# Download the file from CSV_URL and save it inside raw/
curl -sSL -o raw/annual-enterprise-survey.csv "$CSV_URL"

# Check the file downloaded and isn't empty
if [ -s raw/annual-enterprise-survey.csv ]; then
  echo "Extract complete: file saved in raw folder"
else
  echo "ERROR: Extract failed - file is missing or empty"
  exit 1
fi

# ------------------------------------------------------------
# STEP 2: TRANSFORM - rename a column and keep only 4 columns
# ------------------------------------------------------------
echo "Step 2: Transforming data..."

# Create the Transformed folder if it doesn't already exist
mkdir -p Transformed

# FPAT lets awk understand commas inside quotes (e.g. "Sales, grants")
# so those don't get split into extra columns by mistake.
# We rename Variable_code to variable_code, and keep only:
# year, Value, Units, variable_code
awk 'BEGIN{FPAT="([^,]*)|(\"[^\"]*\")"; OFS=","} 
NR==1 {print "year","Value","Units","variable_code"; next} 
{print $1,$9,$5,$6}' raw/annual-enterprise-survey.csv > Transformed/2023_year_finance.csv

# Check the transformed file was created and isn't empty
if [ -s Transformed/2023_year_finance.csv ]; then
  echo "Transform complete: 2023_year_finance.csv saved in Transformed folder"
else
  echo "ERROR: Transform failed - file is missing or empty"
  exit 1
fi

# ------------------------------------------------------------
# STEP 3: LOAD - copy the final file into the Gold folder
# ------------------------------------------------------------
echo "Step 3: Loading data..."

# Create the Gold folder if it doesn't already exist
mkdir -p Gold

# Copy the transformed file into Gold
cp Transformed/2023_year_finance.csv Gold/2023_year_finance.csv

# Check the file was copied into Gold and isn't empty
if [ -s Gold/2023_year_finance.csv ]; then
  echo "Load complete: 2023_year_finance.csv saved in Gold folder"
else
  echo "ERROR: Load failed - file is missing or empty"
  exit 1
fi

echo "ETL process finished successfully."
