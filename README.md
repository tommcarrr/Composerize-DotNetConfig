# Composerize-DotNetConfig
Script to create docket-compose environment variables from appsettings.json files

## Usage
```powershell
.\Composerize-DotNetConfig.ps1 `
    -AppSettingsFile "C:\Thing\src\Project\appsettings.json" ` # Path to appsettings.json
    -AppSettingsDevFile "C:\Thing\src\Project\appsettings.development.json" ` # Path to appsettings.development.json (optional - in case of conflict these values supersede those from the AppSettingsFile)
    -OutputFile "ouput.txt" #path to output
```
## Sample
### Input
#### appsettings.json
```json
{
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft": "Warning",
      "Microsoft.Hosting.Lifetime": "Information"
    }
  },
  "AllowedHosts": "*",
  "ConnectionStrings": {
    "DefaultConnection": "Server=(localdb)\\mssqllocaldb;Database=aspnet-WebApp1-53bc9b9d-9d6a-45d4-8429-2a2761773502;Trusted_Connection=True;MultipleActiveResultSets=true"
  },
  "ServiceApi": {
    "BaseUrl": "https://api.service.com/",
    "Timeout": 30
  },
  "FeatureToggles": [
    {
      "Name": "Feature1",
      "IsActive": true
    },
    {
      "Name": "Feature2",
      "IsActive": false
    }
  ]
}
```
#### appsettings.development.json
```json
{
  "Logging": {
    "LogLevel": {
      "Default": "Debug",
      "Microsoft": "Information",
      "Microsoft.Hosting.Lifetime": "Information"
    }
  },
  "ConnectionStrings": {
    "DefaultConnection": "Server=(localdb)\\mssqllocaldb;Database=aspnet-WebApp1-DEV;Trusted_Connection=True;MultipleActiveResultSets=true"
  },
  "ServiceApi": {
    "Timeout": 60
  },
  "FeatureToggles": [
    {
      "Name": "Feature1",
      "IsActive": false
    },
    {
      "Name": "Feature2",
      "IsActive": true
    }
  ]
}
```
### Output
#### output.txt
```
      - Logging__LogLevel__Default=Debug
      - Logging__LogLevel__Microsoft=Information
      - Logging__LogLevel__Microsoft.Hosting.Lifetime=Information
      - AllowedHosts=*
      - ConnectionStrings__DefaultConnection=Server=(localdb)\mssqllocaldb;Database=aspnet-WebApp1-DEV;Trusted_Connection=True;MultipleActiveResultSets=true
      - ServiceApi__BaseUrl=https://api.service.com/
      - ServiceApi__Timeout=60
      - FeatureToggles__0__Name=Feature1
      - FeatureToggles__0__IsActive=False
      - FeatureToggles__1__Name=Feature2
      - FeatureToggles__1__IsActive=True
```