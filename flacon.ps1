param ( [string]$Path = "C:\Users\$env:username\Downloads", [int]$IsRecurse = $true)


function Get-PSPath {
    param (
        $Path
    )
    $PSPath = Join-Path -Path $Path -ChildPath "*"
}

function Get-IncludeDirectories {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Path
    )

    $IncludeDirectories = @()
    $ContentPath = (Get-ChildItem -LiteralPath $Path -Recurse -Directory).FullName

    return $ContentPath
}

function Get-FlaconFilesInDirectory {
    param (
        $Path
    )
    $FlaconFiles = Get-ChildItem $Path | Where-Object {$_.Extension -eq ".flacon"}
    return $FlaconFiles
}

function Get-FlaconFilesInDirectoryRecurse {
    param (
        $IncludeDirectories
    )
    $FlaconFiles = @()

    foreach ($IncludeDirectory in $IncludeDirectories) {
        $FlaconFiles += Get-FlaconFilesInDirectory $IncludeDirectory
    }
    return $FlaconFiles
}

function Rename-FlaconFiles {
    param (
        $FlaconFiles
    )
    $RanamedFlaconFiles = @()
    foreach ($FlaconFile in $FlaconFiles) {
        Rename-FlaconFile $FlaconFile
        $RanamedFlaconFiles += $FlaconFile
    }
    return $RanamedFlaconFiles
}

function Rename-FlaconFile {
    param ($FlaconFile)
    
    $OldPath = $FlaconFile.FullName
    $NewPath = [System.IO.Path]::ChangeExtension($FlaconFile.Name, ".flac")
    Rename-Item -LiteralPath $OldPath -NewName $NewPath
}

function Main {
    param (
        $Path,
        $IsRecurse
    )

    $FlaconFiles = @()
    $FlaconFiles += Get-FlaconFilesInDirectory $Path

    if ($IsRecurse){
        $IncludeDirectories = Get-IncludeDirectories $Path
        $FlaconFiles += Get-FlaconFilesInDirectoryRecurse $IncludeDirectories
    }
    
    $RanamedFlaconFiles = Rename-FlaconFiles $FlaconFiles
    Write-Host $RanamedFlaconFiles
}

Main $Path $IsRecurse