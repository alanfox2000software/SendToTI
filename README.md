# SendToTI
<img src="https://raw.githubusercontent.com/alanfox2000software/SendToTI/refs/heads/main/.github/images/logo.png" width="250" height="250"/>
</p>

Run any program or open any folder with **TrustedInstaller** privileges using the "Send to" context menu.

## Features
- Opens **any file** with its default associated program.
- Supports running executables (.exe), installers (.msi), batch files (.bat), registry files (.reg), etc.
- Supports shortcuts (.lnk) whose target is `cmd.exe` with custom arguments.
- Sending a folder to SendToTI opens it in Windows Explorer running as TrustedInstaller.

## Installation and Usage
1. Extract the downloaded archive.
2. Right-click `install.bat` and select **Run as administrator**.

After installation, two entries will appear in the right-click "Send to" context menu for files and folders:
- **SendToTI** – Runs/elevates the selected item with TrustedInstaller privileges.
- **SendToTI Powershell Script** – Dedicated option for PowerShell scripts (.ps1 files).

<img src="https://raw.githubusercontent.com/alanfox2000software/SendToTI/refs/heads/main/.github/images/contextmenu.png"/>

## Notes
- This tool relies on `wsudo.exe` to acquire TrustedInstaller privileges.
- By default, `SendToTI.exe` looks for `wsudo.exe` in the same directory.
- If `wsudo.exe` is deleted from the SendToTI folder, `SendToTI.exe` will automatically search for `wsudo.exe` in directories listed in the system's PATH environment variable.

## Important Warning
Running processes or opening Explorer as TrustedInstaller grants the highest level of system privileges in Windows. This can allow modifications to protected system files and may cause irreversible damage if misused (e.g., breaking Windows updates or stability). Use with extreme caution, only when necessary, and always back up important data first.