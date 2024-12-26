$src = ".\output"
if (-not (Test-Path -Path $src)) {
    Write-Host ".\output directory doesn't exist. Please run `generate_emu_config.exe` first."
    exit 1
}

$AW_Path = "$env:APPDATA\Achievement Watcher"
if (-not (Test-Path -Path $AW_Path)) {
    New-Item -ItemType Directory -Path $AW_Path -Force | Out-Null
}

# Initialize a collection to store the gameIndex data
$list = @()

# Process each game's schema folder
Get-ChildItem -Path $src -Directory | ForEach-Object {
    $schemaPath = Join-Path $_.FullName "Achievement Watcher\steam_cache\schema"

    if (Test-Path -Path $schemaPath) {
        # Parse the gameIndex.json for each game
        $jsonPath = Join-Path $schemaPath "gameIndex.json"
        $rawJSON = Get-Content -Path $jsonPath -Raw | ConvertFrom-JSON

        # Append each game entry to the collection
        $list += $rawJSON
        
        # Copy everything else, minus the .json file
        $dest = Join-Path $AW_Path "steam_cache\schema"
        Get-ChildItem -Path $schemaPath | Where-Object { $_.Name -ne "gameIndex.json" } |
            ForEach-Object {
                Copy-Item -Path $_.FullName -Destination $dest -Force -Recurse
            }
    }
}

# Sort the collection by appid
$sortedList = $list | Sort-Object -Descending -Property appid

# Convert the list back to JSON
$sortedJSON = $sortedList | ConvertTo-JSON -Depth 10

# Define paths where gameIndex.json should be
$schemaIndexPath = Join-Path $AW_Path "steam_cache\schema\gameIndex.json"
$cfgIndexPath = Join-Path $AW_Path "cfg\gameIndex.json"

# Export the JSON contents
Set-Content -Path $schemaIndexPath -Value $sortedJSON -Encoding UTF8
Set-Content -Path $cfgIndexPath -Value $sortedJSON -Encoding UTF8

Write-Host "Achievement Watcher files have been successfully updated."
Write-Host "To apply the changes, please restart AW's watchdog (node.exe), or sign out/restart your PC."

#>