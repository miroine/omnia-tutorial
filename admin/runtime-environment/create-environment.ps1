<#
 .SYNOPSIS
    Setup shared resources for the Omnia tutorial

 .DESCRIPTION
    Setup shared resources for the Omnia tutorial using ARM templates and otherwise.

 .EXAMPLE
    ./create-environment.ps1 -subscription "Azure Subscription" -resourceGroupName myresourcegroup -resourceGroupLocation centralus

 .PARAMETER Subscription
    The subscription name or id where the template will be deployed.

 .PARAMETER ResourceGroupName
    The resource group where the template will be deployed. Can be the name of an existing or a new resource group.

 .PARAMETER ResourceGroupLocation
    Optional, a resource group location. If specified, will try to create a new resource group in this location. If not specified, assumes resource group is existing.

 .PARAMETER TemplateFilePath
    Optional, path to the template file. Defaults to template.json.

 .PARAMETER ParametersFilePath
    Optional, path to the parameters file. Defaults to parameters.json. If file is not found, will prompt for parameter values based on template.
#>

param(
 [string]
 $ScenarioName = "omnia-tutorial",

 [string]
 $Subscription = "Omnia Application Workspace - Sandbox",

 [string]
 $ResourceGroupName = "OmniaTutorialCommon",

 [string]
 $ResourceGroupLocation = "northeurope"
)

$AzModuleVersion = "2.0.0"

$DLSTemplateFilePath = "templates/dls/template.json"
$DLSParametersFilePath = "templates/dls/parameters.json"
$DFTemplateFilePath = "templates/data-factory/deployment.json"
#$DFParametersFilePath = "templates/data-factory/parameters.json"
$SQLTemplateFilePath = "templates/sql/template.json"
$SQLParametersFilePath = "templates/sql/parameters.json"
$DataBricksTemplateFilePath = "templates/databricks/template.json"
$DataBricksParametersFilePath = "templates/databricks/parameters.json"
$WebAppTemplateFilePath = "templates/webapp/template.json"
$WebAppParametersFilePath = "templates/webapp/parameters.json"

<#
.SYNOPSIS
    Registers RPs
#>
Function RegisterRP {
    Param(
        [string]$ResourceProviderNamespace
    )

    Write-Host "Registering resource provider '$ResourceProviderNamespace'";
    Register-AzResourceProvider -ProviderNamespace $ResourceProviderNamespace;
}

#******************************************************************************
# Script body
# Execution begins here
#******************************************************************************
$ErrorActionPreference = "Stop"

# Verify that the Az module is installed 
if (!(Get-InstalledModule -Name Az -MinimumVersion $AzModuleVersion -ErrorAction SilentlyContinue)) {
    Write-Host "This script requires to have Az Module version $AzModuleVersion installed..
It was not found, please install from: https://docs.microsoft.com/en-us/powershell/azure/install-az-ps"
    exit
} 

# sign in
$context = Get-AzContext
if ($null -eq $context )
{
    Write-Host "Logging in...";
    $context = Connect-AzAccount
}

# select subscription
Write-Host "Selecting subscription '$Subscription'";
Select-AzSubscription -Subscription $Subscription;

# Register RPs
$resourceProviders = @("microsoft.storage");
if($resourceProviders.length) {
    Write-Host "Registering resource providers"
    foreach($resourceProvider in $resourceProviders) {
        RegisterRP($resourceProvider);
    }
}

# Create or check for existing resource group
$resourceGroup = Get-AzResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue
# if(!$resourceGroup)
# {
#     if(!$ResourceGroupLocation) {
#         Write-Host "Resource group '$ResourceGroupName' does not exist. To create a new resource group, please enter a location.";
#         $resourceGroupLocation = Read-Host "ResourceGroupLocation";
#     }
#     Write-Host "Creating resource group '$ResourceGroupName' in location '$ResourceGroupLocation'";
#     New-AzResourceGroup -Name $ResourceGroupName -Location $ResourceGroupLocation
# }
# else{
#     Write-Host "Using existing resource group '$ResourceGroupName'";
# }

# # Create the Data Lake Store
# Write-Host "Creating Data Lake Store ... " -NoNewline
# if(Test-Path $DLSParametersFilePath) {
#     # New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile $DLSTemplateFilePath -TemplateParameterFile $DLSParametersFilePath;
# } else {
#     # New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile $DLSTemplateFilePath;
# }
# Write-Host "Done" -ForegroundColor Green

# Create the Data Factory
# Write-Host "Creating Data Factory ... " -NoNewline
# $df = New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile $DFTemplateFilePath;
# #$df = New-AzDataFactoryV2 -ResourceGroupName $ResourceGroupName  -TemplateFile $DFTemplateFilePath -TemplateParameterFile $DFParametersFilePath;
# Write-Host "$df Done" -ForegroundColor Green

# Create the Key Vault
$keyVault = Get-AzKeyVault -VaultName "$ScenarioName-common-kv" -ResourceGroupName $resourceGroupName -ErrorAction SilentlyContinue 
if ($null -eq $keyVault)
{
    Write-Host "Creating Key Vault ... " -NoNewline
    $keyVault = New-AzKeyVault -Name "$ScenarioName-common-kv" -ResourceGroupName $resourceGroupName -Location "$ResourceGroupLocation"
    Write-Host "$keyVault" -ForegroundColor Green
    Write-Host "Key Vault Created" -ForegroundColor Green
}
else {
    Write-Host "Key Vault already exists. Skipping creation!" -ForegroundColor "Yellow"
}

# Create the SQL Database
$sqlDb = Get-AzSqlDatabase -ResourceGroupName $resourceGroupName -ServerName "$ScenarioName-common-sql" -DatabaseName "common" -ErrorAction SilentlyContinue 
if ($null -eq $sqlDb)
{
    Write-Host "Creating SQL Database ... " -NoNewline
    if(Test-Path $SQLParametersFilePath) {
        $sql = New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile $SQLTemplateFilePath -TemplateParameterFile $SQLParametersFilePath -scenarioName $ScenarioName;
    } else {
        $sql = New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile $SQLTemplateFilePath;
    }
    Write-Host "$sql SQL Database Created" -ForegroundColor Green
}
else {
    Write-Host "SQL Database already exists. Skipping creation!" -ForegroundColor "Yellow"
}

# Create Databricks
$dataBricks = Get-AzResource -ResourceGroupName $resourceGroupName -Name "$ScenarioName-common-databricks" -ErrorAction SilentlyContinue 
if ($null -eq $dataBricks)
{
    Write-Host "Creating Databricks ... " -NoNewline
    if(Test-Path $DataBricksParametersFilePath) {
        $dataBricks = New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile $DataBricksTemplateFilePath -TemplateParameterFile $DataBricksParametersFilePath -scenarioName $ScenarioName;
    } else {
        $dataBricks = New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile $DataBricksTemplateFilePath;
    }
    Write-Host "$dataBricks Databricks Created" -ForegroundColor Green
}
else {
    Write-Host "Databricks already exists. Skipping creation!" -ForegroundColor "Yellow"
}

# Create the App Service
$webApp = Get-AzWebApp -ResourceGroupName $resourceGroupName -Name "$ScenarioName-common" -ErrorAction SilentlyContinue 
if ($null -eq $webApp)
{
    Write-Host "Creating Web App ... " -NoNewline
    if(Test-Path $WebAppParametersFilePath) {
        $webApp = New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile $WebAppTemplateFilePath -TemplateParameterFile $WebAppParametersFilePath -scenarioName $ScenarioName;
    } else {
        $webApp = New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile $WebAppTemplateFilePath;
    }
    Write-Host "$webApp Created" -ForegroundColor Green
}
else {
    Write-Host "Web App already exists. Skipping creation!" -ForegroundColor "Yellow"
}