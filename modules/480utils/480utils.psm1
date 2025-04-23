function Show-Banner-480()
{
    Write-Host "480Utils"
}
Function Connect-480([string] $server)
{
    $conn = $global:DefaultVIServer
    
    if ($conn){
        $msg = "Already connected to: {0}" -f $conn

        Write-Host -ForegroundColor Green $msg
    }else
    {
        $conn = Connect-VIServer -server $server
    }
}
Function Get-480Config()
{
    $480_config_path = "/home/lily/Downloads/public-techjournal/modules/480.json"
    $conch = (Get-Content -Raw -Path $480_config_path | ConvertFrom-Json)
    $msg = "Using Configuration at {0}" -f $480_config_path
    Write-Host -ForegroundColor Green $msg
    return $conch
}
Function Select-VM([string] $folder)
{
    $selected_vm = $null
    try
    {
        $vms = Get-VM -Location $folder
        $index = 1
        foreach($vm in $vms)
        {
            Write-Host [$index] $vm.name
            $index += 1
        }
        $pick_index = Read-Host 'Which index number [x] do you wish to pick?'
        $selected_vm = $vms[$pick_index -1]
        Read-Host "You selected " $selected_vm.name
        Return $selected_vm
    }
    catch
    {
        Write-Host "Invalid Folder: $folder" -ForegroundColor "Red"
    }
}

Function FullClone($vm, $vmi, $snapshot, $vmhost, $ds, $Name)
{
    $vm = $vm
    $linkedname = "{0}.linked" -f $vm.Name

    # Creating linked clone.
    $linkedvm = New-VM -LinkedClone -Name $linkedname -VM $vm -ReferenceSnapshot $snapshot -VMHost $vmhost -Datastore $ds

    #Creating full clone.
    try
    {
        New-VM -Name $Name -VM $linkedvm -VMHost $vm -Datastore $ds -ErrorAction Stop
        Write-Host "New VM Created"
    }
    catch {
        Write-Host "Failed to Create VM" -ForegroundColor Red
        FullClone
    }
    $del =  Read-Host "Would you like to delete the temporary clone $linkedvm? [Y]/[N]"
    if ($del -eq "Y") {
        try {
            Remove-VM -VM $linkedvm -ErrorAction Stop
            Write-Host "Temp Clone Deleted"
        }
        catch {
            Write-Host "Could Not Delete Clone. You can do so manually in vCenter." -ForegroundColor Red
        }
    }
    else {
        Write-Host "It is advised to delete the temp clone manually in vCenter."
    }
}

function LinkedClone ($vm, $snapshot, $vmhost, $ds, $Name)
{
    try {
        New-VM -LinkedClone -Name $Name -VM $vm -ReferenceSnapshot $snapshot -VMHost $vmhost -Datastore $ds -ErrorAction Stop
        Write-Host "Linked clone created."
    }
    catch {
        Write-Host "Could not create linked clone." -ForegroundColor Red 
    }
}

Function New-Network($portgroup, $switch)
{
    New-VirtualSwitch 
    New-VirtualPortGroup
    Get-VirtualSwitch
}