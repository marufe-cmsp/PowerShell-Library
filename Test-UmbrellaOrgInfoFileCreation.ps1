$env:Umbrella_Org_ID = '4363764'
$env:Umbrella_Org_Fingerprint = '6f30c1937d6ef12cc9ae33675874277a'
$env:Umbrella_User_ID = '11139528'

function Write-UmbrellaOrgInfoToStagingDir {
    <#
    .SYNOPSIS
        Writes OrgInfo.json into the pre-deploy staging directory so that the Umbrella RSM
        MSI installer picks it up during setup and embeds the org credentials — the Cisco
        documented pre-deploy pattern.

        Target path:
          <StagingDir>\cisco-secure-client\profiles\umbrella\OrgInfo.json

        All three site-level DRMM variables must be non-empty; the function throws with a
        site-context-enriched error message if any is missing.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$StagingDir
    )

    $credVars = [ordered]@{
        Umbrella_Org_ID          = $env:Umbrella_Org_ID
        Umbrella_Org_Fingerprint = $env:Umbrella_Org_Fingerprint
        Umbrella_User_ID         = $env:Umbrella_User_ID
    }

    foreach ($kv in $credVars.GetEnumerator()) {
        if ([string]::IsNullOrWhiteSpace($kv.Value)) {
            $ctx = Get-DrmmSiteContext
            throw "DRMM site-level variable '$($kv.Key)' is empty or not set. " +
            "OrgInfo.json cannot be written. " +
            "Site: '$($ctx.SiteName)' (ID: $($ctx.SiteId)). " +
            'Configure this variable in the DRMM Site Settings before deploying.'
        }
    }

    $orgInfoDir = Join-Path $StagingDir 'cisco-secure-client\profiles\umbrella'
    $orgInfoPath = Join-Path $orgInfoDir 'OrgInfo.json'

    if (-not (Test-Path -LiteralPath $orgInfoDir)) {
        New-Item -ItemType Directory -Path $orgInfoDir -Force -ErrorAction Stop | Out-Null
        Write-Log "Created pre-deploy profile directory: $orgInfoDir" 'INFO'
    }

    # Field names are case-sensitive — must match Cisco's expected schema exactly
    $orgInfoContent = [ordered]@{
        organizationId = $env:Umbrella_Org_ID
        fingerprint    = $env:Umbrella_Org_Fingerprint
        userId         = $env:Umbrella_User_ID
    } | ConvertTo-Json

    Set-Content -LiteralPath $orgInfoPath -Value $orgInfoContent -Encoding UTF8 -Force -ErrorAction Stop
    Write-Log "OrgInfo.json written to pre-deploy staging path: $orgInfoPath" 'OK'
}

$script:stagingDir = Join-Path $env:TEMP "umbrella-deploy-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
New-Item -ItemType Directory -Path $script:stagingDir -Force -ErrorAction Stop
$extractDir = Join-Path $script:stagingDir 'cisco-secure-client'
Write-UmbrellaOrgInfoToStagingDir -StagingDir $extractDir