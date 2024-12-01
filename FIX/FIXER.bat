@echo off
color 0C
echo Grazie per aver scelto il nostro software
echo Stiamo preparando il tuo PC - sei pronto?
choice /C YN /M "Premi Y per continuare o N per uscire."

if errorlevel 2 (
	color C0
	cls
    echo Uscita dallo script...
    timeout /nobreak /t 2 >nul
    exit
)

:: Rest des Skripts...
@echo off
title System Configuration
color 0C

:: Request admin access
NET FILE >nul 2>&1
if %errorLevel% == 0 (
    goto :adminCheck
) else (
	color C0
	cls
    echo Si prega di eseguire questo script come amministratore.
    pause
    exit
)

:adminCheck
color 0C
cls
echo Grazie per aver scelto AREA 51!
echo Se riscontri altri problemi, crea un ticket nel server Discord nella categoria "SUPPORT".
echo Inizieremo a preparare il tuo PC, quindi siediti e rilassati per un momento.
timeout /t 3 /nobreak > NUL
echo
echo
:: Delete all temporary files
color 0C
echo Eliminazione dei file temporanei...
del /q /s %TEMP%\*.*

:: Deactivate Riot Vanguard
color 0C
echo Riot Vanguard verrà disattivato.
sc stop vgk
timeout /nobreak /t 2 >nul

:: Disable Hyper-V
color 0C
echo Disattivazione di Hyper-V...
bcdedit /set hypervisorlaunchtype off
powershell.exe -ExecutionPolicy Bypass -Command "Disable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All"

:: Disable VulnerableDriverBlocklist for Windows 11 22h2
color 0C
echo Disattivazione di VulnerableDriverBlocklist...
reg add "HKLM\SOFTWARE\Microsoft\SQMClient\Windows\Vulnerability\Override" /v "Windows11_22H2_BlockList" /t REG_DWORD /d 0 /f

:: Add the specified regedits
color 0C
echo Aggiunta di regedits...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettingsOverride /t REG_DWORD /d 3 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettingsOverrideMask /t REG_DWORD /d 3 /f

:: Disable Core Isolation
color 0C
echo Disattivazione dell'isolamento del kernel...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v "EnableVirtualizationBasedSecurity" /t REG_DWORD /d 0 /f
color 02



echo Fatto! Il sistema si riavvierà tra 5 secondi...
timeout /nobreak /t 5 >nul
shutdown /r /f /t 0
pause
