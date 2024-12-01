@echo off

echo Privilegi utente attuali: %userprofile%
echo.
echo Richiesta di privilegi di amministratore...

net session >nul 2>&1
if %errorLevel% == 0 (
    goto :continue
) else (
    goto :admin
)

:admin
echo.
echo E necessario eseguire questo file .bat come amministratore.
echo Concedere i privilegi di amministratore selezionando "Si" quando richiesto.
echo.
powershell -Command "Start-Process '%0' -Verb RunAs"
exit

:continue
echo Privilegi di amministratore confermati.
echo.

reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettingsOverride /t REG_DWORD /d 3
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettingsOverrideMask /t REG_DWORD /d 3
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CI\Config" /v VulnerableDriverBlocklistEnable /t REG_DWORD /d 0x000000

bcdedit /set hypervisorlaunchtype off

echo.
echo Riavviare il PC.
echo.
pause>nul
exit