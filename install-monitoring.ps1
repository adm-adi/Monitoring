###########################################################################################
# Script basique pour l'installation automatique du service SNMP 
# et de l'agent Centreon-Nsclient chez OA SA
#
#        Copyright© adm_bfo, adm_adi
#        Date: 01.12.2021
#        Ajout variable chemin du partage (adapter selon le client)           
#        Ajout variables pour configuration snmp sans GPO (adapter selon le client)           
###########################################################################################


$CheminInstallNsClient = 'C:\Program Files\Centreon NSClient++'
$SnmpManagers = '192.168.10.11'
$SnmpCommunity = 'snixionmp'
$IsSnmpInstalled = Get-WindowsFeature SNMP-Service
$IsRSATSnmpInstalled = Get-WindowsFeature RSAT-SNMP
$path = “c:\nsclientinstall”
$NsClientSharePath = '\\SRVV-MGT02\nsclientinstall\*'
$NsClientVersionActuelle = get-wmiobject -Query "select name,version from win32_product where name = 'NSClient++ (x64)'"
$NsClientVersionNouvelle = '0.5.2.41'
$NsClientVersionAncienne = '0.4.3.143'
$ProcessActive = Get-Process cmd -ErrorAction SilentlyContinue

if(!$IsSnmpInstalled.Installed -eq $true) {
Install-WindowsFeature SNMP-Service -IncludeAllSubFeature -Verbose
}



if(!$IsRSATSnmpInstalled.Installed -eq $true) {
Install-WindowsFeature RSAT-SNMP -IncludeAllSubFeature -Verbose
}


New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\services\SNMP\Parameters\PermittedManagers" -Name 2 -Value $SnmpManagers
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\services\SNMP\Parameters\ValidCommunities" -Name $SnmpCommunity -Value 4


if(!(Test-Path -Path $path))
  {
   new-item -Path $path -Value $path –itemtype Directory
   Copy-Item -path $NsClientSharePath -destination $path -Recurse -Force
   
  }




if($NsClientVersionActuelle.Version -eq $NsClientVersionAncienne) {

Write-Output "Ancienne version détectée " $NsClientVersionActuelle.Version
set-location 'C:\Program Files\centreon-nsclient\'
Start-Process .\Uninst.exe /S
Start-Process C:\nsclientinstall\nsclient\setup.bat -Verb runas
}

elseif($NsClientVersionActuelle.Version -eq $NsClientVersionNouvelle)
{

write-output "dernière version déjà installée."
exit

}

elseif(!(Test-Path $CheminInstallNsClient))

{
   Start-Process C:\nsclientinstall\nsclient\setup.bat -Verb runas
  }

$ProcessActive = Get-Process cmd -ErrorAction SilentlyContinue
if($ProcessActive -eq $null){
    Write-host "Running"
}else{
    Write-Host "Not Running"
}

Write-Output "Done."