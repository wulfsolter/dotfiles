
Import-Module posh-git

# Import-Module PowerTab


# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

function Docker-Connect {
    docker exec -t -i dev /bin/bash -c 'su - wherewolf'
}

function Docker-Run {
    C:\Users\User\code\docker\postgres\run.ps1
    C:\Users\User\code\docker\dev\run.ps1
}

function Docker-Root {
    docker exec -t -i dev /bin/bash
}

function gits {
    git status
}

function subl([string]$arg1) {
    C:\Program` Files\Sublime` Text` 3\sublime_text.exe $arg1
}

function Meld([string]$arg1, [string]$arg2) {
    C:\Program` Files` `(x86`)\Meld\Meld.exe $arg1 $arg2
}

function reboot() {
    shutdown -t 0 -r -f
}

function tig() {
    if(-Not ($env:PATH.Contains("C:\cygwin64\bin"))) {
        echo 'cygwin not in path, appending environment variable'
        $env:PATH += ";C:\cygwin64\bin\";
    }
    iex -c 'C:\cygwin64\bin\bash.exe -c "/usr/bin/tig"';
}

Set-Location ~/code
Set-Alias dc Docker-Connect
Set-Alias dr Docker-Run
