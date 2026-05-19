function Test-FileExists {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Path
    )

    try {
        # Validate path explicitly as a file (not a directory)
        if (Test-Path -Path $Path -PathType Leaf) {
            return $true
        }
        else {
            return $false
        }
    }
    catch {
        return $false
    }
}