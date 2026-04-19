@echo off
chcp 866 >nul
set "FLACONPATH=%~1"

powershell.exe -ExecutionPolicy Bypass -File "%~dp0flacon.ps1" -Path "%FLACONPATH%"