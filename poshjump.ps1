function setup() {
    # Setup $markHome to $env:HOME, to be compatible with batch implementation
    if ($env:HOME) {
        $global:markHome = $env:HOME
    } else {
        $global:markHome = $env:USERPROFILE
    }

    # Setup $markPath to $env:MARKPATH, to be compatible with the batch implementation
    if ($env:MARKPATH) {
        $global:markPath = $env:MARKPATH
    } else {
        $global:markPath = "$markHome\.marks"
    }

    # Create $markPath if it does not exist
    if ((Test-Path $global:markPath) -ne $true) {
        New-Item -Path $global:markPath -ItemType Directory
    }
}

function mark ($markName)
{
    # Call the Setup Helper to Setup Variables and create required directories
    setup | Out-Null

    # Get the current directory to store in a mark
    $cwd = Get-Location | foreach { $_.Path }
    
    # Check if a name was given, if not auto-generate that name
    if (!$markName) 
    {  
        $markName = (get-item .).Name
    }

    # Check if a mark with the given name already exists
    if ((Test-Path -Path "$global:markPath\$markName") -eq $true) {
        # Ask the user if overwriting the mark is ok
        if ( askOverwrite $cwd $markName -eq $true ) {
            addMark $cwd $markName 
        }
    }
    else {
        addMark $cwd $markName
    }

}

function addMark ($path, $name) {
    Write-Verbose "$path -> $name"
    $path | Out-File -FilePath "$global:markPath\$name"
}

function askOverwrite($path, $name) {
    $answer = Read-Host "Mark $path as $name ? (y/n)"
    
    while ("y","n" -notcontains $answer) {
        $answer = Read-Host "y/n?"
    }

    if ($answer -eq "y") {
        addMark $path $name
    }
}

function jump($mark) {
    # Call the Setup Helper to Setup Variables and create required directories
    setup | Out-Null

    if ((Test-Path "$global:markPath\$mark") -eq $true) {
        $markTarget = Get-Content "$global:markPath\$mark"
        if ((Test-Path $markTarget) -eq $true) {
            Set-Location $markTarget
        } else {
            Write-Error "$mark -> ?"
        }
    } else {
        Write-Error "No such mark"
    }
}

function marks {
    # Call the Setup Helper to Setup Variables and create required directories
    setup | Out-Null
    
    Get-Item "$markPath\*" -Exclude "_back"| foreach {
        $name = $_.Name
        $path = Get-Content "$markPath\$name"
        if ((Test-path $path) -eq $true) {
            Write-Host "$name -> $path"
        } else {
            Write-Host "$name -> ?"
        }
    }
}

function unmark ($name) {
    # Call the Setup Helper to Setup Variables and create required directories
    setup | Out-Null

    if ((Test-Path "$markPath\$name") -eq $true) {
        Remove-Item "$markPath\$name"
    } else {
        Write-Error "No such mark"
    }
}

function keep {
    mark _back
}

function back {
    jump _back
}