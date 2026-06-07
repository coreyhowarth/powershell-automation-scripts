function Show-Menu {
    Clear-Host
    Write-Host "----------------------------"
    Write-Host "       Network Utility Menu"
    Write-Host "----------------------------"
    Write-Host "1. Get IP Address of Remote Computer"
    Write-Host "2. Get Hostname from IP Address"
    Write-Host "3. Ping a Host"
    Write-Host "4. Get System Information from Remote Computer"
    Write-Host "5. Exit"
    Write-Host "----------------------------"
}

function Get-IP {
    $computerName = Read-Host "Enter the hostname of the remote computer"

    try {
        $ipAddresses = Get-WmiObject -Class Win32_NetworkAdapterConfiguration -ComputerName $computerName |
                       Where-Object { $_.IPEnabled -eq $true } |
                       Select-Object -ExpandProperty IPAddress

        if ($ipAddresses) {
            Write-Host "IP Address(es) for ${computerName}: $($ipAddresses -join ', ')"
        } else {
            Write-Host "No IP Address found or the computer is unreachable."
        }
    } catch {
        Write-Host "Error: $_"
    }
}

function Get-HostName {
    $ipAddress = Read-Host "Enter the IP address"

    try {
        $results = Resolve-DnsName -Name $ipAddress

        if ($results) {
            Write-Host "Hostname(s) for ${ipAddress}:"
            $results | ForEach-Object { Write-Host $_.Name }
        } else {
            Write-Host "No hostname found for ${ipAddress}."
        }
    } catch {
        Write-Host "Error: $_"
    }
}

function Ping-Host {
    $pingHost = Read-Host "Enter the hostname or IP address to ping"

    try {
        $pingResults = Test-Connection -ComputerName $pingHost -Count 4 -ErrorAction Stop

        Write-Host "Ping results for ${pingHost}:"
        foreach ($result in $pingResults) {
            Write-Host "$($result.Address): Status = $($result.StatusCode), Response Time = $($result.ResponseTime)ms"
        }
    } catch {
        Write-Host "Error: $_"
    }
}

function Get-SystemInfo {
    $target = Read-Host "Enter the hostname or IP address of the target computer"

    try {
        $systemInfo = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $target
        $osInfo = Get-WmiObject -Class Win32_OperatingSystem -ComputerName $target
        $networkAdapters = Get-WmiObject -Class Win32_NetworkAdapterConfiguration -ComputerName $target | Where-Object { $_.IPEnabled -eq $true }

        Write-Output "Computer Name: $($systemInfo.Name)"
        Write-Output "Domain: $($systemInfo.Domain)"
        Write-Output "Operating System: $($osInfo.Caption) Version: $($osInfo.Version)"
        Write-Output "Total Physical Memory: $([math]::round($systemInfo.TotalPhysicalMemory / 1MB, 2)) MB"
        Write-Output "Current User: $($systemInfo.UserName)"

        Write-Output "Network Adapters:"
        foreach ($adapter in $networkAdapters) {
            Write-Output "  Adapter Name: $($adapter.Description)"
            Write-Output "  IP Addresses: $($adapter.IPAddress -join ', ')"
            Write-Output "  MAC Address: $($adapter.MACAddress)"
        }
    } catch {
        Write-Output "Error: $_"
    }
}

# Main Loop
do {
    Show-Menu
    $choice = Read-Host "Please select an option (1, 2, 3, 4, or 5)"

    switch ($choice) {
        1 { Get-IP }
        2 { Get-HostName }
        3 { Ping-Host }
        4 { Get-SystemInfo }
        5 { Write-Host "Exiting..."; break }
        default { Write-Host "Invalid option, please try again." }
    }

    Pause
} while ($true)





  


