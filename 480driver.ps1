$env:PSModulePath = $env:PSModulePath + ":/home/lily/Downloads/public-techjournal/modules/480utils/"
Import-Module '480utils' -Force

480Banner
$conf = Get-480Config -config_path = '/home/lily/Downloads/public-techjournal'
480Connect -server $conf.vcenter_server
Write-Host "Selecting your VM..."
Select-VM -folder BaseVM