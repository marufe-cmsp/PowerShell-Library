function Test-RegistryValueExists {
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
        [string]$Type
    )

    try {
        $item = Get-ItemProperty -Path $Path -ErrorAction Stop

        if ($null -eq $item.$Name) {
            return $false
        }

        switch ($Type) {
            "String"        { return ($item.$Name -is [string]) }
            "ExpandString"  { return ($item.$Name -is [string]) }
            "Binary"        { return ($item.$Name -is [byte[]]) }
            "DWord"         { return ($item.$Name -is [int]) }
            "QWord"         { return ($item.$Name -is [long]) }
            "MultiString"   { return ($item.$Name -is [string[]]) }
            default         { return $false }
        }
    }
    catch {
        return $false
    }
}