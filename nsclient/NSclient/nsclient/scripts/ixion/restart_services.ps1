# Variables
$service = $args[0]
$nspath = "C:\Program Files\Centreon NSClient++\scripts\ixion"
$serviceCounterPath="$nspath\Services\$service.xml"
$serviceCounter=0

if (-not(Test-Path $nspath"\Services")) {
	mkdir $nspath"\Services"
}
if (Test-Path $serviceCounterPath) {
	$serviceCounter = import-clixml -path $serviceCounterPath
}


if ($service -eq $null -OR $(Get-Service $service) -eq $null) {
	write-host "Warning: Bad or missing argument"
	exit 1
} elseif ($(Get-Service $service).status -eq "Stopped") {
	Start-Service $service
	$serviceCounter++
	$serviceCounter | export-clixml -path $serviceCounterPath
	Write-host "Critical: "$service"is stopped. Restart attempts : "$serviceCounter
	exit 2
} elseif ($(Get-Service $service).status -eq "Running") {
	$serviceCounter=0
	$serviceCounter | export-clixml -path $serviceCounterPath
	Write-Host "OK: "$service" is running" 
	exit 0
}