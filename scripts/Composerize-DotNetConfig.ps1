# Parametrize the input and output files
param (
    [String]$AppSettingsFile = 'appsettings.json',
    [String]$AppSettingsDevFile,
    [String]$OutputFile = 'docker-compose.env'
)

# Flatten a JSON object into a dictionary
function Flatten-Json {
    param (
        [Parameter(Mandatory)]
        [PSObject]
        $Json,

        [Parameter(Mandatory)]
        [System.Collections.Generic.Dictionary[string, string]]
        $Dict,

        [string]
        $Prefix = ''
    )

    foreach ($property in $Json.PSObject.Properties) {
        if ($property.Value -is [PSCustomObject]) {
            Flatten-Json -Json $property.Value -Dict $Dict -Prefix ($Prefix + $property.Name + "__")
        } elseif ($property.Value -is [array]) {
            $i = 0
            foreach ($value in $property.Value) {
                Flatten-Json -Json $value -Dict $Dict -Prefix ($Prefix + $property.Name + "__" + $i.ToString() + "__")
                $i++
            }
        } else {
            $Dict[$Prefix + $property.Name] = $property.Value
        }
    }
}

# Remove the output file if it already exists
if (Test-Path $OutputFile) {
    Remove-Item $OutputFile
}

# Load the JSON files
$AppSettings = Get-Content $AppSettingsFile | ConvertFrom-Json
$MergedSettings = $AppSettings | ConvertTo-Json -Depth 100 | ConvertFrom-Json

# If AppSettingsDevFile is provided
if ($AppSettingsDevFile -ne $null -and (Test-Path $AppSettingsDevFile)) {
    $AppSettingsDev = Get-Content $AppSettingsDevFile | ConvertFrom-Json
    # Merge the objects (Development settings will supersede base settings)
    $AppSettingsDev.PSObject.Properties | ForEach-Object {
        $MergedSettings.$($_.Name) = $_.Value
    }
}

# Flatten and output to docker-compose.env file
$Dict = New-Object 'System.Collections.Generic.Dictionary[string, string]'
Flatten-Json -Json $AppSettings -Dict $Dict
Flatten-Json -Json $MergedSettings -Dict $Dict
$Dict.GetEnumerator() | ForEach-Object {
    "      - $($_.Key)=$($_.Value)" | Out-File -FilePath $OutputFile -Append
}
