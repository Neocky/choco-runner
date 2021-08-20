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

Installs multiple [Chocolatey Packages](https://community.chocolatey.org/packages) paralell to each other with different threads.  
Installs [Chocolatey](https://chocolatey.org/) if it is not installed which then can be removed via the prompt or  
with the param `-removeChocoAfterwards`.  
Find all Chocolatey packages here: https://community.chocolatey.org/packages

## Usage
##### This script needs to be run as administrator.
#### Example:
Installs `Firefox` and `7Zip` and removes `Chocolatey` afterwards:
```PowerShell
.\choco-runner.ps1 -package firefox,7zip.install -removeChocoAfterwards
```
##### Supports Pipeline input:
```PowerShell
"7zip.install" | .\choco-runner.ps1
```

#### All parameters
```
.PARAMETER package
A list of packages which should be installed/upgraded. Seperate it with a ",".

.PARAMETER removeChocoAfterwards
Removes Chocolatey afterwards when this parameter is given.

.PARAMETER keepChocoAfterwards
Keeps Chocolatey afterwards when this parameter is given.

.PARAMETER threads
Maximum numbers of threads (Default=256)
```
