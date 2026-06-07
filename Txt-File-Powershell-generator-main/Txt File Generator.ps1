# ======================================================================
# Script Name: Create-EmptyTextFiles.ps1
# Purpose    : Generate a user-defined number of empty .txt files
# Author     : Corey
# ======================================================================

# ----------------------------------------------------------------------
# STEP 1: Define where you want the files to be created.
# Here, we set $path to a folder called "GeneratedFiles"
# inside your Downloads folder (USERPROFILE = your user directory).
# ----------------------------------------------------------------------


$path = "$env:USERPROFILE\Downloads\GeneratedFiles"

# ----------------------------------------------------------------------
# STEP 2: Check if that folder already exists.
# Test-Path returns True if the folder exists, False if not.
# If it doesn’t exist, we create it with New-Item.
# The "| Out-Null" hides the usual output message.
# ----------------------------------------------------------------------

if (-not (Test-Path $path)) {
    New-Item -ItemType Directory -Path $path | Out-Null
}

# ----------------------------------------------------------------------
# STEP 3: Ask the user how many text files they want to create.
# Read-Host pauses and waits for input in the terminal window.
# The number entered is stored in the $count variable.
# ----------------------------------------------------------------------

$count = Read-Host "How many empty text files do you want to create?"

# ----------------------------------------------------------------------
# STEP 4: Start a loop that runs from 1 up to the number the user entered.
# "$i" starts at 1, and increases by 1 each time until it reaches $count.
# ----------------------------------------------------------------------
for ($i = 1; $i -le $count; $i++) {

    # --------------------------------------------------------------
    # Inside the loop:
    # Build the name for each file using the loop counter ($i).
    # Example: File_1.txt, File_2.txt, etc.
    # --------------------------------------------------------------
    $filename = "File_$i.txt"

    # --------------------------------------------------------------
    # Combine the folder path and the filename to get the full path.
    # Join-Path automatically handles slashes correctly.
    # --------------------------------------------------------------
    $fullpath = Join-Path $path $filename

    # --------------------------------------------------------------
    # Create the actual empty file.
    # -ItemType File tells PowerShell to make a new file.
    # -Force allows it to overwrite existing files with the same name.
    # "| Out-Null" again hides the command output.
    # --------------------------------------------------------------
    New-Item -ItemType File -Path $fullpath -Force | Out-Null

    # --------------------------------------------------------------
    # Display a confirmation message for each created file.
    # --------------------------------------------------------------
    Write-Host "Created $filename"
}

# ----------------------------------------------------------------------
# STEP 5: When the loop finishes, display the output folder path.
# The "`n" inserts a blank line for readability.
# ----------------------------------------------------------------------
Write-Host "`nAll done! Files saved in: $path"

# ----------------------------------------------------------------------
# STEP 6: Pause keeps the PowerShell window open until you press Enter.
# Useful when you double-click the script so it doesn’t close instantly.
# ----------------------------------------------------------------------
pause