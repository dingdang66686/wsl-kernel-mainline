## Point to your custom kernel in .wslconfig:
```bash
powershell.exe /C 'Write-Output [wsl2]`nkernel=$env:USERPROFILE\bzImage | % {$_.replace("\","\\")} | Out-File $env:USERPROFILE\.wslconfig -encoding ASCII'
```

```
[wsl2]
kernel=C:\\Users\\<YOUR_USER>\\bzImage
```
