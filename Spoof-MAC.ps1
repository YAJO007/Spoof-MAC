$ErrorActionPreference = "Stop"

function Get-AdapterInfo {
    Get-NetAdapter | Where-Object Status -eq "Up" | Select-Object Name, InterfaceDescription, MacAddress, Status
}

function Get-RandomMAC {
    $hex = "0123456789ABCDEF"
    $mac = "02"  # Locally administered, unicast
    for ($i = 0; $i -lt 5; $i++) {
        $mac += "-" + $hex[(Get-Random -Max 16)] + $hex[(Get-Random -Max 16)]
    }
    $mac
}

function Set-MACSpoof {
    param([string]$AdapterName, [string]$NewMAC)

    $adapter = Get-NetAdapter -Name $AdapterName -ErrorAction SilentlyContinue
    if (-not $adapter) { Write-Host "Adapter not found"; return }

    # Disable adapter
    Disable-NetAdapter -Name $AdapterName -Confirm:$false
    # Set MAC via registry
    $regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}"
    Get-ChildItem $regPath | ForEach-Object {
        $key = $_.PSPath
        $desc = (Get-ItemProperty $key).DriverDesc
        if ($desc -eq $adapter.InterfaceDescription) {
            New-ItemProperty -Path $key -Name "NetworkAddress" -Value $NewMAC -PropertyType String -Force | Out-Null
        }
    }
    # Re-enable adapter
    Enable-NetAdapter -Name $AdapterName -Confirm:$false
    Write-Host "MAC changed to: $NewMAC"
}

function Reset-MAC {
    param([string]$AdapterName)

    $adapter = Get-NetAdapter -Name $AdapterName -ErrorAction SilentlyContinue
    if (-not $adapter) { Write-Host "Adapter not found"; return }

    $regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}"
    Disable-NetAdapter -Name $AdapterName -Confirm:$false
    Get-ChildItem $regPath | ForEach-Object {
        $key = $_.PSPath
        $desc = (Get-ItemProperty $key).DriverDesc
        if ($desc -eq $adapter.InterfaceDescription) {
            Remove-ItemProperty -Path $key -Name "NetworkAddress" -ErrorAction SilentlyContinue | Out-Null
        }
    }
    Enable-NetAdapter -Name $AdapterName -Confirm:$false
    Write-Host "MAC restored to original"
}

# Main menu
Clear-Host
Write-Host "=== MAC Address Spoofer ===" -ForegroundColor Cyan
Write-Host ""

$adapters = Get-AdapterInfo
if (-not $adapters) { Write-Host "No active adapters found"; exit }

$i = 1
$adapters | ForEach-Object {
    Write-Host "$i. $($_.Name) - $($_.MacAddress) - $($_.InterfaceDescription)"
    $i++
}

Write-Host ""
$choice = Read-Host "Select adapter (1-$($adapters.Count))"
$adapter = $adapters[$choice - 1]
if (-not $adapter) { Write-Host "Invalid choice"; exit }

Write-Host "`n1. Spoof with random MAC"
Write-Host "2. Enter custom MAC"
Write-Host "3. Restore original MAC"
Write-Host "4. Show current MAC only"
$action = Read-Host "`nSelect action"

switch ($action) {
    "1" {
        $newMAC = Get-RandomMAC
        Set-MACSpoof -AdapterName $adapter.Name -NewMAC $newMAC
    }
    "2" {
        $newMAC = Read-Host "Enter MAC (e.g. 02-1A-2B-3C-4D-5E)"
        if ($newMAC -notmatch '^([0-9A-Fa-f]{2}-){5}[0-9A-Fa-f]{2}$') {
            Write-Host "Invalid MAC format" -ForegroundColor Red
            exit
        }
        Set-MACSpoof -AdapterName $adapter.Name -NewMAC $newMAC.ToUpper()
    }
    "3" { Reset-MAC -AdapterName $adapter.Name }
    "4" { Get-NetAdapter -Name $adapter.Name | Select Name, MacAddress, Status }
    default { Write-Host "Invalid choice" }
}

Write-Host "`nCurrent MAC:" -ForegroundColor Cyan
Get-NetAdapter -Name $adapter.Name | Select-Object Name, MacAddress, Status
