$env:PSModulePath = $env:PSModulePath + ":/home/lily/Downloads/public-techjournal/modules"
Import-Module '480utils' -Force
Show-Banner-480
$config_path = '/home/lily/Downloads/public-techjournal/480.json'
$conf = Get-480Config -config_path = $config_path
Connect-480 -server $conf.vcenter_server
Write-Host "Selecting your VM..."
Select-VM -folder BaseVM 