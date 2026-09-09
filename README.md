# Simple ETL Pipeline

## Project Background

I recently joined the Core Data Engineer Program to help me put together
the bits and bobs I had been learning in Data Engineering. To be honest,
this has been long overdue. I built this basic pipeline through Linux to
download a CSV file from a website, clean and transform it, and schedule
it to run automatically. Working on this is already giving me a clearer
picture of what Data Engineering is all about.

Along the way I hit real beginner problems (wrong folder paths, git not
working properly on a Windows-mounted drive, cron not existing in Git
Bash, GitHub login trouble) and fixed each one. Those problems taught me
more than if everything had just worked first try, so I kept it simple
rather than polishing over the messy parts.

## Overview

I extracted a CSV file from a data website using a Bash script. I then
cleaned it, renaming a column and keeping only the four columns I
needed, and saved the result as a new file. Finally, I loaded that
finished file into its own folder, ready for use. I also scheduled the
whole thing to run automatically every night, and wrote a second script
to tidy up CSV and JSON files into one folder.

## Folder Structure

etl-project/
├── etl_script.sh # The main ETL pipeline (see below)
├── move_files.sh # Moves .csv/.json files into one folder
├── raw/ # Step 1 output: the freshly downloaded CSV
├── Transformed/ # Step 2 output: the cleaned-up CSV
├── Gold/ # Step 3 output: the final, ready-to-use CSV
├── practice_files/ # Sample files used to test move_files.sh
├── json_and_CSV/ # Where move_files.sh moves things to
└── README.md


## Pipeline Diagram

[ Stats NZ website ]
|
| curl downloads the file
v
[ raw/ ] ---------------------> Extract
|
| awk renames + picks 4 columns
v
[ Transformed/ ] -----------------> Transform
|
| cp copies the final file
v
[ Gold/ ] ----------------------> Load


Every step prints a message confirming it worked (or an error if it
didn't), so the pipeline's progress is visible directly in the terminal.

## Quickstart

```bash
export CSV_URL="https://www.stats.govt.nz/assets/Uploads/Annual-enterprise-survey/Annual-enterprise-survey-2023-financial-year-provisional/Download-data/annual-enterprise-survey-2023-financial-year-provisional.csv"
chmod +x etl_script.sh
./etl_script.sh
```

`export` stores the download link in a variable. The script then uses
`curl` to actually fetch and save the file using that variable, `awk`
to clean it up, and `cp` to load the final version into `Gold/`.

## Reproduction Steps

1. **Create the project folder and write the scripts**:
```bash
   mkdir etl-project
   cd etl-project
   nano etl_script.sh   # paste in the ETL script, save and exit
   nano move_files.sh   # paste in the file-mover script, save and exit
```

2. **Run the ETL script**:
```bash
   export CSV_URL="https://www.stats.govt.nz/assets/Uploads/Annual-enterprise-survey/Annual-enterprise-survey-2023-financial-year-provisional/Download-data/annual-enterprise-survey-2023-financial-year-provisional.csv"
   chmod +x etl_script.sh
   ./etl_script.sh
```
   Confirmation:
```bash
   ls raw Transformed Gold
```

3. **Cron schedule** (runs daily at midnight):
```bash
   crontab -e
```
   Add this line, using the full path to the project folder:

0 0 * * * /bin/bash /full/path/to/etl_script.sh >> /full/path/to/etl_cron.log 2>&1

   Confirmation:
```bash
   crontab -l
```
   Git Bash doesn't include `crontab`, so this needs a real Linux
   environment — I used WSL (Ubuntu) for this step.

4. **File-mover script**, on any folder with `.csv`/`.json` files:
```bash
   chmod +x move_files.sh
   ./move_files.sh practice_files
```
   Confirmation:
```bash
   ls practice_files json_and_CSV
```

5. **Turn the project into a Git repo and push it to GitHub**:
```bash
   git init
   git add .
   git commit -m "Initial commit: ETL script, cron setup, file mover"
   git remote add origin https://github.com/NanaNyarko/CDE-ETL-Git-and-Linux-Project.git
   git branch -M main
   git push -u origin main
```

## Challenges Encountered

- **Folder confusion**: solved by always running `pwd` before trusting
  a relative path like `raw/file.csv`.
- **Quoted commas in the CSV** (e.g. `"Sales, grants"`) broke a simple
  comma-split: fixed using `awk`'s `FPAT` setting, which correctly
  understands quoted commas.
- **Missing `crontab` in Git Bash**: Git Bash isn't a full Linux
  system, so WSL (a real Linux environment on Windows) was installed
  to get a working `cron` service.
- **Git permissions error** on a Windows-mounted drive (`/mnt/c/...`):
  fixed by moving the project into the native Linux home folder, where
  Git works properly.
- **GitHub login kept failing** with tokens (copy-paste into the
  terminal was unreliable): fixed by installing GitHub CLI and logging
  in through the browser instead (`gh auth login`), which avoids
  typing or pasting a token by hand.

## Tools Used

Bash, curl, awk, cron, Git, GitHub CLI (`gh`) — standard Linux
command-line tools, no external programming language.
