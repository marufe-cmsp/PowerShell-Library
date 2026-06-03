function Get-DWPFile {
    param (
        [Parameter(Mandatory = $true)]
        [string]$ProjectID
    )

    try {
        $uri = "https://compassmsp.workplace.datto.com/1/api/v1/file/$ProjectID/files"

        $response = Invoke-RestMethod -Uri $uri -Method Get

        Write-Log "Successfully retrieved files for Project ID: $ProjectID" -Level Info

        return $response
    }
    catch {
        Write-Log "Error retrieving files for Project ID: $ProjectID. Error: $_" -Level Error
        throw $_
    }
}