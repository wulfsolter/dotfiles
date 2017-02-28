
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

function Sublime([string]$arg1) {
	C:\Program` Files\Sublime` Text` 3\sublime_text.exe $arg1
}

function Meld([string]$arg1, [string]$arg2) {
	C:\Program` Files` `(x86`)\Meld\Meld.exe $arg1 $arg2
}

function GitStatus {
	git status
}

Set-Location ~/code
Set-Alias dc Docker-Connect
Set-Alias dr Docker-Run
Set-Alias subl Sublime
Set-Alias gits GitStatus