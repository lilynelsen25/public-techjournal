$env:PSModulePath = $env:PSModulePath + ":/home/lily/Downloads/public-techjournal/modules"
Import-Module '480utils' -Force
Show-Banner-480
$conch = Get-480Config
Connect-480 -server $conch.vcenter_server
Write-Host "Selecting your VM..."
Select-VM -folder BaseVM