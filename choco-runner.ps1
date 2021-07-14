<#
.SYNOPSIS
Rapid fast multi package installer for chocolatey packages

.DESCRIPTION
Installs programs super fast with chocolatey and installs chocolatey if needed.
More than one program can be given to as param -package to run the installation paralell.
This script needs to be run as administrator.

.PARAMETER package
A list of packages which should be installed/upgraded. Seperate it with a ",".

.PARAMETER removeChocoAfterwards
Removes Chocolatey afterwards when this parameter is given.

.NOTES
Author: Neocky
Version: 1.0.0

.LINK
https://github.com/Neocky/choco-runner

#>
#Requires -RunAsAdministrator


[CmdletBinding()]
param (
    [Parameter(Mandatory=$False)][array]$package,
    [Parameter(Mandatory=$False)][switch]$removeChocoAfterwards
)


function writeTitle {
    Write-Host "      ┌────────────────────────────────────────┐"
    Write-Host "      │              " -NoNewline; Write-Host "CHOCO RUNNER" -ForegroundColor Yellow -NoNewline; Write-Host "              │"
    Write-Host "      │ " -NoNewline; Write-Host "https://github.com/Neocky/choco-runner" -ForegroundColor Cyan -NoNewline; Write-Host " │"
    Write-Host "      └────────────────────────────────────────┘"
}


function checkParam {
    [CmdletBinding()]
    param (
        [Parameter()][array]$programsToInstall
        )
    
    if (($programsToInstall).Count -eq 0) {
        Write-Host "Package name is required. Please use the parameter: -package PACKAGENAME1,PACKAGENAME2" -ForegroundColor Red -BackgroundColor Black
        Write-Output "Here is a list with all available packages to install: https://community.chocolatey.org/packages"
        @(
            "POPULAR PACKAGES:"
            "├─ adobereader",
            "├─ googlechrome",
            "├─ firefoxesr",
            "├─ 7zip.install",
            "└─ office365business"
            ) -join "`n" | Write-Output
        Exit 1
    }
}


function installChocolatey {
    Write-Output "Installing Chocolatey..."
    try {
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')) -ErrorAction Stop
    } catch {
        Write-Error "Couldn't install Chocolatey. Check your network connection and try again!"
        Exit 1
    }
}


function removeChocolatey {
    Write-Output "Removing Chocolatey..."
    try {
        Remove-Item -Path "C:\ProgramData\chocolatey" -Force -Recurse -ErrorAction Stop
    } catch {
        Write-Error "Couldn't remove Chocolatey from the system. Check if Chocolatey is installed under C:\ProgramData\chocolatey and try again!"
        Exit 1
    }
    Write-Output "Chocolatey successfully removed"
}


function checkChocolateyInstall {
    if (-not (Test-Path $env:ChocolateyInstall)) {
        Write-Output "Chocolatey wasn't found on the system."
        installChocolatey
        
        if (-not (Test-Path $env:ChocolateyInstall)) {
            Write-Output "Chocolatey couldn't be installed correctly. Exiting program..."
            Exit 1
        }
    }
}


$installer = {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True)][String]$chocoProgram
    )

    function installPackage {
        [CmdletBinding()]
        param (
            [Parameter()][array]$programsToInstall
            )
        Write-Host "#### " -NoNewline -ForegroundColor Gray; Write-Host $programsToInstall -ForegroundColor Magenta -NonewLine; Write-Host " ####" -ForegroundColor Gray
        choco upgrade $programsToInstall -y --limitoutput --no-progress
        }

    try {
        installPackage -programsToInstall $chocoProgram
    } catch {
        Write-Host "● " -ForegroundColor Red -NonewLine; Write-Host "Couldn't install: " -ForegroundColor Red -NoNewline; Write-Host $chocoProgram
        Exit
    }
    Write-Host "● " -ForegroundColor Green -NonewLine; Write-Host "Successfully installed: " -ForegroundColor Green -NoNewline; Write-Host $chocoProgram
    Write-Host ""
}


writeTitle
checkParam -programsToInstall $package
checkChocolateyInstall
Write-Host ""
Write-Host "Packages to install: " -ForegroundColor Green
Write-Output $package
Write-Host ""


$jobs = @()
Foreach ($packageToInstall in $package) {
    $jobs += Start-Job -ArgumentList $packageToInstall -ScriptBlock $installer
}


# Spinner
$spinnerAnimation = "/-\|/-\|"
$i = 0
while (($jobs.State -eq "Running") -and ($jobs.State -ne "NotStarted"))
{
	Write-Host `r($spinnerAnimation[$i]) -NoNewline; Write-Host " Installing packages..." -NoNewline
	$i++
	if ($i -ge $spinnerAnimation.Length) {
		$i = 0
	}
	Start-Sleep -Milliseconds 100
}

Write-Host ""
Receive-Job $jobs -AutoRemoveJob -Wait


if ($removeChocoAfterwards -ne $True) {
    $removeChocolateyConfirmation = Read-Host "Remove Chocolatey? (y/n)"
}
if (($removeChocolateyConfirmation -eq "y") -or ($removeChocoAfterwards -eq $True)) {
    removeChocolatey
}
