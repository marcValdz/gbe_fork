$sourcePath = ".\output"
$destinationPath = "$env:APPDATA\Achievement Watcher\steam_cache\schema"

# Initialize a collection to store the gameIndex data
$list = @()

# Process each game's schema folder
Get-ChildItem -Path $sourcePath -Directory | ForEach-Object {
    $gameSchemaPath = Join-Path $_.FullName "Achievement Watcher\steam_cache\schema"

    if (Test-Path -Path $gameSchemaPath) {
        # Define source gameIndex.json path
        $sourceGameIndex = Join-Path $gameSchemaPath "gameIndex.json"

        # Load the JSON content from the source gameIndex.json
        $sourceJson = Get-Content -Path $sourceGameIndex -Raw | ConvertFrom-Json

        # Add the source JSON entries to the collection
        $list += $sourceJson
        
        # Copy other files from source to destination
        Get-ChildItem -Path $gameSchemaPath | Where-Object { $_.Name -ne "gameIndex.json" } |
            ForEach-Object {
                Copy-Item -Path $_.FullName -Destination $destinationPath -Force -Recurse
            }
    }
}

# Sort the collection by appid
$sortedList = $list | Sort-Object -Descending -Property appid

# Define destination gameIndex.json path
$destinationGameIndex = Join-Path $destinationPath "gameIndex.json"

# Save the sorted list to the destination gameIndex.json
$sortedList | ConvertTo-Json -Depth 10 | Set-Content -Path $destinationGameIndex -Encoding UTF8

# Create a symbolic link for gameIndex.json in cfg folder
$cfgIndexPath = "$env:APPDATA\Achievement Watcher\cfg\gameIndex.json"
New-Item -ItemType SymbolicLink -Path $cfgIndexPath -Target $destinationGameIndex -Force | Out-Null

Write-Host "Achievement Watcher files have been successfully updated."
Write-Host "To apply the changes, please restart AW's watchdog (node.exe), or sign out/restart your PC."
#>