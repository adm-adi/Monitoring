###########################################################################################
# Script basique pour l'installation automatique du service SNMP 
# et de l'agent Centreon-Nsclient chez OA SA
#
#        CopyrightÂ© adm_bfo, adm_adi
#        Date: 01.12.2021
#        Ajout variable chemin du partage (adapter selon le client)           
#        Ajout variables pour configuration snmp sans GPO (adapter selon le client)           
###########################################################################################

## Info importante
##
## Il faut créer un dossier qui sera partagé et accessible par les serveurs de l'infra, il faudra copier dans ce dossier partagé ce script 
## avec le dossier nsclient.
##
## Ensuite, il faut modifier la variable $NsClientSharePath avec le lien direct du dossier partagé.


$CheminInstallNsClient = 'C:\Program Files\Centreon NSClient++'
$SnmpManagers = 'Adresses des pollers'
$SnmpCommunity = 'snixionmp'
$IsSnmpInstalled = Get-WindowsFeature SNMP-Service
$IsRSATSnmpInstalled = Get-WindowsFeature RSAT-SNMP
$path = "c:\nsclientinstall"
$NsClientSharePath = '\\X.X.X.X\nsclientinstall\*' #Ã  modifier selon le client. Il faut faire un partage oÃ¹ les serveurs vont rechercher les ressources
$NsClientVersionActuelle = get-wmiobject -Query "select name,version from win32_product where name = 'NSClient++ (x64)'"
$NsClientVersionNouvelle = '0.5.2.41'
$NsClientVersionAncienne = '0.4.3.143'
$ProcessActive = Get-Process cmd -ErrorAction SilentlyContinue


#VÃ©rification et installation SNMP###############################################################################################################################
if(!$IsSnmpInstalled.Installed -eq $true) {
Install-WindowsFeature SNMP-Service -IncludeAllSubFeature -Verbose
}

if(!$IsRSATSnmpInstalled.Installed -eq $true) {
Install-WindowsFeature RSAT-SNMP -IncludeAllSubFeature -Verbose
}
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\services\SNMP\Parameters\PermittedManagers" -Name 2 -Value $SnmpManagers -ErrorAction SilentlyContinue
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\services\SNMP\Parameters\ValidCommunities" -Name $SnmpCommunity -Value 4 -ErrorAction SilentlyContinue

#################################################################################################################################################################

#Copie du dossier d'installation partagÃ© vers serveur local######################################################################################################
if(!(Test-Path -Path $path))
  {
   new-item -Path $path -Value $path -itemtype Directory
   Copy-Item -path $NsClientSharePath -destination $path -Recurse -Force
   
  }
#################################################################################################################################################################

#Install Centreon-Nsclient#######################################################################################################################################

if($NsClientVersionActuelle.Version -eq $NsClientVersionAncienne) {

Write-Output "old version detected" $NsClientVersionActuelle.Version
set-location 'C:\Program Files\centreon-nsclient\'
Start-Process .\Uninst.exe /S
Start-Process C:\nsclientinstall\nsclient\setup.bat -Verb runas
}

elseif($NsClientVersionActuelle.Version -eq $NsClientVersionNouvelle)
{

write-output "last version installed"

exit

}

elseif(!(Test-Path $CheminInstallNsClient))

{
   Start-Process C:\nsclientinstall\nsclient\setup.bat -Verb runas
  }
#################################################################################################################################################################

#Suppression du dossier d'installation sur le serveur local######################################################################################################
<#
if($ProcessActive -eq $null){
    Write-host "Not Running"
    Remove-Item -Recurse -Force $path
}
#>

Write-Output "Done."
#################################################################################################################################################################


#Check que tout soit bien installÃ© dans le serveur###############################################################################################################
$confirmation = Read-Host "Do you want to check if all is correctly installed ?"
if ($confirmation -eq 'y') {
    $NsClientVersionActuelle = get-wmiobject -Query "select name,version from win32_product where name = 'NSClient++ (x64)'"
    Write-host `n "Version Centreon Nsclient:" $NsClientVersionActuelle.Version 
    $IsSnmpInstalled = Get-WindowsFeature SNMP-Service
    Write-Host `n "SNMP installed:"
    if($IsSnmpInstalled.Installed -eq $true) {
        Write-Host " yes"
            }else{
                Write-Host " Nope"
            }
Start-Sleep -Seconds 10
}else{
    Write-Host "Bye."
    Exit
    Start-Sleep -Seconds 2
}
#################################################################################################################################################################
