function New-DWPFile {
    param (
        [Parameter(Mandatory = $true)]
        [string]$FilePath
    )

    try {
        if (-not (Test-Path -Path $FilePath -PathType Leaf)) {
            throw "File not found: $FilePath"
        }

        $uri = "https://compassmsp.workplace.datto.com/1/api/v1/file/F492-G02C-VYZL-XU70-96Y6/files"

        $response = Invoke-RestMethod -Uri $uri -Method Post -Form @{
            file = Get-Item -Path $FilePath
        }

        return $response
    }
    catch {
        Write-Error "Upload failed: $($_.Exception.Message)"
    }
}