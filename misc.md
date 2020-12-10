# misc

```cmd
prompt %COMPUTERNAME%$S%USERNAME%$S%USERDOMAIN%$_$D$T$_$P$_$G
```

```powershell

new-item -itemtype file -path $profile -force
notepad $PROFILE

function Global:prompt {
    $dateTime = get-date -Format "dd.MM.yyyy HH:mm:ss"
    "`n$($Env:username) $dateTime`n$PWD`nPS>"
} 

```

