# Import necessary modules
Import-Module ActiveDirectory
Import-Module GroupPolicy

# Output directory for audit logs
$auditDirectory = "C:\AuditLogs"
$zipFilePath = "C:\AuditLogs.zip"

# Create the output directory if it doesn't exist
if (!(Test-Path -Path $auditDirectory)) {
    New-Item -ItemType Directory -Path $auditDirectory | Out-Null
}

# Get basic system information
$systemInfo = Get-CimInstance -ClassName Win32_ComputerSystem
$osInfo = Get-CimInstance -ClassName Win32_OperatingSystem
$processorInfo = Get-CimInstance -ClassName Win32_Processor

# Save system information to a text file
$systemInfo | Out-File "$auditDirectory\SystemInfo.txt"
$osInfo | Out-File "$auditDirectory\OSInfo.txt"
$processorInfo | Out-File "$auditDirectory\ProcessorInfo.txt"

# Get installed software information
$software = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*
$software | Select-Object DisplayName, Publisher, InstallDate, DisplayVersion | 
    Sort-Object DisplayName | Out-File "$auditDirectory\InstalledSoftware.txt"

# Get network configuration information
$networkInfo = Get-NetIPConfiguration
$networkInfo | Out-File "$auditDirectory\NetworkInfo.txt"

# Get user account information
$userAccounts = Get-LocalUser
$userAccounts | Out-File "$auditDirectory\UserAccounts.txt"

# Get list of running processes
$processes = Get-Process | Select-Object ProcessName, Id, MainWindowTitle
$processes | Out-File "$auditDirectory\RunningProcesses.txt"

# Get memory (RAM) information
$memoryInfo = Get-CimInstance -ClassName Win32_PhysicalMemory
$memoryInfo | Out-File "$auditDirectory\MemoryInfo.txt"

# Get disk drive information
$diskInfo = Get-CimInstance -ClassName Win32_DiskDrive
$diskInfo | Out-File "$auditDirectory\DiskDriveInfo.txt"

# Get network adapter information
$networkAdapterInfo = Get-NetAdapter
$networkAdapterInfo | Out-File "$auditDirectory\NetworkAdapterInfo.txt"

# Get firewall settings
$firewallInfo = Get-NetFirewallProfile
$firewallInfo | Out-File "$auditDirectory\FirewallInfo.txt"

# Check antivirus status (Windows Security)
$antivirusStatus = Get-MpComputerStatus
$antivirusStatus | Out-File "$auditDirectory\AntivirusStatus.txt"

# Check Windows Defender settings
$defenderSettings = Get-MpPreference
$defenderSettings | Out-File "$auditDirectory\WindowsDefenderSettings.txt"

# Get recent system event logs
$systemEventLogs = Get-WinEvent -LogName System -MaxEvents 100
$systemEventLogs | Out-File "$auditDirectory\SystemEventLogs.txt"

# Get recent security event logs
$securityEventLogs = Get-WinEvent -LogName Security -MaxEvents 100
$securityEventLogs | Out-File "$auditDirectory\SecurityEventLogs.txt"

# Get recent application event logs
$applicationEventLogs = Get-WinEvent -LogName Application -MaxEvents 100
$applicationEventLogs | Out-File "$auditDirectory\ApplicationEventLogs.txt"

# Get installed Windows updates
$windowsUpdates = Get-HotFix
$windowsUpdates | Out-File "$auditDirectory\WindowsUpdates.txt"

# Get installed software and their versions
$installedSoftware = Get-WmiObject -Class Win32_Product
$installedSoftware | Select-Object Name, Version, Vendor | Out-File "$auditDirectory\InstalledSoftwareDetailed.txt"

# Get domain information (if applicable)
$domainInfo = Get-WmiObject Win32_NTDomain
$domainInfo | Out-File "$auditDirectory\DomainInfo.txt"

# Get Active Directory user information (if applicable)
$adUsers = Get-ADUser -Filter *
$adUsers | Out-File "$auditDirectory\ADUsers.txt"

# Get group policy settings
$groupPolicies = Get-GPOReport -All -ReportType XML
$groupPolicies | Out-File "$auditDirectory\GroupPolicies.xml"

# Get scheduled tasks
$scheduledTasks = Get-ScheduledTask
$scheduledTasks | Out-File "$auditDirectory\ScheduledTasks.txt"

# Get running services
$services = Get-Service
$services | Out-File "$auditDirectory\RunningServices.txt"

# Check open ports and listening processes
$openPorts = Get-NetTCPConnection | Where-Object { $_.State -eq 'Listen' }
$openPorts | Out-File "$auditDirectory\OpenPorts.txt"

# Check file and folder permissions
Get-Acl C:\ | Format-List | Out-File "$auditDirectory\FileFolderPermissions.txt"

# Check registry permissions
Get-Acl HKLM:\SOFTWARE | Format-List | Out-File "$auditDirectory\RegistryPermissions.txt"

# Check UAC settings
$uacSettings = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" | Select-Object EnableLUA, ConsentPromptBehaviorAdmin
$uacSettings | Out-File "$auditDirectory\UACSettings.txt"

# Get startup programs
$startupPrograms = Get-CimInstance -Query "SELECT * FROM Win32_StartupCommand"
$startupPrograms | Out-File "$auditDirectory\StartupPrograms.txt"

# Additional Security Checks
# Check password policy
$passwordPolicy = net accounts
$passwordPolicy | Out-File "$auditDirectory\PasswordPolicy.txt"

# Check account lockout policy
$accountLockoutPolicy = secedit /export /cfg C:\lockout_policy.inf
$accountLockoutPolicy | Out-File "$auditDirectory\AccountLockoutPolicy.txt"

# Check audit policy
$auditPolicy = auditpol /get /category:*
$auditPolicy | Out-File "$auditDirectory\AuditPolicy.txt"

# Compress Archive
Compress-Archive -Path "$auditDirectory\*" -DestinationPath $zipFilePath -CompressionLevel Fastest

# Define date and time for email
$date = Get-Date -Format "MMMM dd, yyyy"
$time = Get-Date -Format "HH:mm:ss"

# Define email credentials
$Username = "kartikayrawat9416@outlook.com"
$Password = "Team@Crusaders" # Use an app password if MFA is enabled
$To = "kartikayrwt@gmail.com" # Recipient email address
$Subject = "AuditXpress Logs Report of Windows System at - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" # Email subject with date and time

# Define email body with HTML content
$Body = @"
<!DOCTYPE html>
<html>
<head>
    <style>
        body {
            font-family: Arial, sans-serif;
            color: #333;
            background-color: #f4f4f4;
            padding: 20px;
        }
        .container {
            background-color: #ffffff;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }
        .header {
            background-color: #0078D7;
            padding: 10px;
            color: #ffffff;
            text-align: center;
            border-radius: 8px 8px 0 0;
        }
        .header h2 {
            margin: 0;
            font-size: 24px;
        }
        .content {
            padding: 20px;
            color: #333;
        }
        .content p {
            font-size: 16px;
            margin: 10px 0;
        }
        .content .highlight {
            font-weight: bold;
            color: #0078D7;
        }
        .footer {
            margin-top: 20px;
            text-align: center;
            font-size: 14px;
            color: #555;
            padding: 10px;
            background-color: #f1f1f1;
            border-radius: 0 0 8px 8px;
        }
        .button {
            background-color: #0078D7;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
        }
        .button:hover {
            background-color: #005bb5;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h2>Audit Logs Report</h2>
        </div>
        <div class="content">
            <p><span class="highlight">Dear Admin,</span></p>
            <p>Please find the attached audit logs for the system report generated on <span class="highlight">$(Get-Date -Format 'dddd, MMMM dd, yyyy HH:mm:ss')</span>.</p>
            <p>The logs include detailed information about system configuration, installed software, network settings, and security status.</p>
            <p><strong>Highlights:</strong></p>
            <ul>
                <li>System Info</li>
                <li>Installed Software</li>
                <li>Security Settings</li>
                <li>Network Configuration</li>
                <li>Firewall and Antivirus Status</li>
            </ul>
            <p>For more details, please review the attached audit logs file. If you need any further information, feel free to reach out.</p>
            <a href="mailto:kartikayrawat9416@outlook.com" class="button">Contact Us</a>
        </div>
        <div class="footer">
            <p>Best regards,<br />
            <strong>Kartikay Rawat</strong><br />
            Team Leader<br />
            kartikayrawat9416@outlook.com<br />
            9991723770</p>
        </div>
    </div>
</body>
</html>
"@


# Define SMTP server and port
$SMTPServer = "smtp.office365.com" # SMTP server
$Port = 587 # SMTP server port

# Create the email message
$SMTPMessage = New-Object system.net.mail.mailmessage
$SMTPMessage.From = $Username
$SMTPMessage.To.Add($To)
$SMTPMessage.Subject = $Subject
$SMTPMessage.Body = $Body
$SMTPMessage.IsBodyHtml = $true # Set to true for HTML content

# Attach the specific file
if (Test-Path -Path $zipFilePath) {
    $attachment = New-Object System.Net.Mail.Attachment($zipFilePath)
    $SMTPMessage.Attachments.Add($attachment)
} else {
    Write-Host "File $zipFilePath does not exist."
}

# Create the SMTP client
$SMTPClient = New-Object Net.Mail.SmtpClient($SMTPServer, $Port)
$SMTPClient.EnableSsl = $true
$SMTPClient.Credentials = New-Object System.Net.NetworkCredential($Username, $Password)

# Send the email
try {
    $SMTPClient.Send($SMTPMessage)
    Write-Host "Email sent successfully."
} catch {
    Write-Host "Failed to send email. Error: $_"
} finally {
    # Clean up attachments
    $SMTPMessage.Attachments.Dispose()
}

# Delete Folder
Remove-Item -Path "$auditDirectory" -Recurse -Force

Write-Host "`nScript completed!" -ForegroundColor green -BackgroundColor black
