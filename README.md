# Spoof-MAC

A simple Windows PowerShell tool for changing, restoring, and checking the MAC address of active network adapters.

## Features

- List active network adapters
- Generate a random locally administered MAC address
- Set a custom MAC address
- Restore the original MAC address
- Show the current MAC address

## Requirements

- Windows 10 or Windows 11
- PowerShell
- Administrator privileges

## Usage

1. Open PowerShell as Administrator.
2. Allow script execution for the current session if needed:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

3. Run the script:

```powershell
.\Spoof-MAC.ps1
```

4. Select an active network adapter.
5. Choose one of the menu actions:

```text
1. Spoof with random MAC
2. Enter custom MAC
3. Restore original MAC
4. Show current MAC only
```

## Custom MAC Format

Custom MAC addresses must use this format:

```text
02-1A-2B-3C-4D-5E
```

The random MAC generator starts with `02`, which marks the address as locally administered and unicast.

## Notes

- The script temporarily disables and re-enables the selected network adapter.
- Network connectivity may drop briefly while the change is applied.
- Some network drivers may ignore custom MAC addresses or require a restart.
- Use only on devices and networks you own or have permission to manage.

## Restore Original MAC

Run the script again, select the same adapter, then choose:

```text
3. Restore original MAC
```

This removes the `NetworkAddress` registry value used for spoofing.

## License

MIT
