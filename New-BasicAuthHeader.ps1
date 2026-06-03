function New-BasicAuthHeader {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Username,
        [Parameter(Mandatory = $true)]
        [SecureString]$Password
    )

    try {
        $pair = "$Username`:$Password"
        $bytes = [System.Text.Encoding]::ASCII.GetBytes($pair)
        $base64 = [Convert]::ToBase64String($bytes)

        Write-Log -Level Info -Message "Created Basic Auth header for user '$Username'."
        return @{
            Authorization = "Basic $base64"
        }
    }
    catch {
        Write-Log -Level Error -Message "Failed to create auth header: $($_.Exception.Message)"
        throw "Failed to create auth header: $($_.Exception.Message)"
    }
}