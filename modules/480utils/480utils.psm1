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