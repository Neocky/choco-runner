<div class="row">
  <div class="column">
    <img align="right" src="https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/60/google/274/horse_1f40e.png" alt="logo" width="60">
  </div>
  <div class="column">
    <img align="right" src="https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/60/google/274/chocolate-bar_1f36b.png" alt="logo" width="60">
  </div>
</div>

# Choco Runner

> Rapid fast multi package installer for chocolatey packages

Installs multiple [Chocolatey Packages](https://community.chocolatey.org/packages) paralell to each other.  
Installs [Chocolatey](https://chocolatey.org/) if it is not installed which then can be removed via the prompt or with the param `-removeChocoAfterwards`.  
Find all Chocolatey packagegs here: https://community.chocolatey.org/packages

## Useage
##### This script needs to be run as administrator.
#### Example:
Installs `Firefox` and `7Zip` and removes `Chocolatey` afterwards:
```PowerShell
.\choco-runner.ps1 -package firefox,7zip.install -removeChocoAfterwards
```
