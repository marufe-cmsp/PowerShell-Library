function New-RegistryValue {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Path,

        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter(Mandatory)]
        [ValidateSet(
            "String","ExpandString","Binary","DWord","MultiString","QWord"
        )]
        [string]$Type,

        [Parameter(Mandatory)]
        $Value
    )

    try {
        # Ensure registry key path exists
        if (-not (Test-Path -Path $Path)) {
            throw "Registry path does not exist: $Path"
        }

        # Map friendly types to registry types
        $registryTypeMap = @{
            "String"       = "String"
            "ExpandString" = "ExpandString"
            "Binary"       = "Binary"
            "DWord"        = "DWord"
            "MultiString"  = "MultiString"
            "QWord"        = "QWord"
        }

        New-ItemProperty `
            -Path $Path `
            -Name $Name `
            -Value $Value `
            -PropertyType $registryTypeMap[$Type] `
            -Force | Out-Null

        return $true
    }
    catch {
        Write-Error $_.Exception.Message
        return $false
    }
}