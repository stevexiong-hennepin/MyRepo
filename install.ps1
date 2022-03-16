# Post OS install script
# Initialize any data disks
try {
    Write-Host "Hello world!"
    $rawDisks = Get-Disk | Where-Object PartitionStyle -eq "Raw"

    # Update the array to reflect the name of the disk else data disk will start with Data0...Data##
    if ($rawDisks) {
        $diskFriendlyName = @("Data", "Backup")
        if (-not($diskFriendlyName)) {
            $diskFriendlyName = for ($i = 0; $i -lt $rawDisks.Count; $i++) {
                "Data$($i)"
            }
        }

        $availableDriveLetters = "DEFGHIJKLMNOPQRSTUVWXYZ".ToCharArray()

        $diskInfo = for ($i = 0; $i -lt $rawDisks.Count; $i++) {
            [pscustomobject]@{
                FriendlyName = $diskFriendlyName[$i]
                DriverLetter = $availableDriveLetters[$i]
                FileSystem   = "NTFS"
                Object       = $rawDisks[$i]
            }
        }

        foreach ($disk in $diskInfo) {
            $disk.Object | New-Volume -FriendlyName $disk.FriendlyName -FileSystem $disk.FileSystem -DriveLetter $disk.DriverLetter
        }

        # Install Windows features

        # Install software
    }
    else {
        Write-Host "No raw data disk found."
    }
    exit 0
}
catch {
    $Error[0].Exception.Message
}