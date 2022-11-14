function Pipo() {
    $DOWNLOADS = $HOME + '\Downloads'
     Write-Host 'android1'
    [void](New-Item -type directory -Path $DOWNLOADS"\test2" -Force)
    Start-Sleep -Seconds 5;
    Write-Host 'android2'
}

function Popi() {
   $DOWNLOADS = $HOME + '\Downloads'
     Write-Host 'intellij1'
    [void](New-Item -type directory -Path $DOWNLOADS+"\test" -Force)
    Start-Sleep -Seconds 10;
    Write-Host 'intellij2'
}

start powershell ${function:Pipo} 
start powershell ${function:Popi} 
start powershell ${function:Pipo} 
start powershell ${function:Popi} 