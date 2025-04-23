function 480Banner()
{
    Write-Host "480Utils"
}
Function 480Connect([string] $server)
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
Function Get-480Config([string] $config_path)
{
    Write-Host "hi"
    $conf = $null
    if(Test-Path $config_path)
    {
        $conf = (Get-Content -Raw -Path $config_path | ConvertFrom-Json)
        $msg = "Using Configuration at {0}" -f $config_path
        Write-Host -ForegroundColor Green $msg
    }else
    {
        Write-Host -ForegroundColor Yellow "No Configuration"
    }
    return $conf 
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