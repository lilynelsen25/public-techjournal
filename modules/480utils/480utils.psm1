function 480Banner()
{
    Write-Host "Hello World"
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
    Write-Host "Reading" + $config_path
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