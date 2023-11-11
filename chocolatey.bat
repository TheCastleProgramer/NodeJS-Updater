@echo off
cd /d "%~dp0"
if NOT "%cd%"=="%cd: =%" (
   echo El directorio actual contine espacios en el path.
   echo Este comando debe estar en un path que no contenga espacios. 
   rundll32.exe cmdext.dll,MessageBeepStub
   pause
   echo.
   goto :EOF
)

if {%1} EQU {[adm]} goto :data
REG QUERY HKU\S-1-5-19\Environment >NUL 2>&1 && goto :data

set command="""%~f0""" [adm] %*
setlocal enabledelayedexpansion
set "command=!command:'=''!"

powershell -NoProfile Start-Process -FilePath '%COMSPEC%' ^
-ArgumentList '/c """!command!"""' -Verb RunAs 2>NUL
goto :EOF

:data
setlocal enabledelayedexpansion
if {%1} EQU {[adm]} (
   set adm=%1
   shift
) ELSE (set adm=)

:cuerpo
REM ==============================================
REM powershell Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
powershell choco install git.install
cd %appdata%/../local/
git clone https://github.com/TheCastleProgramer/NodeJS-Updater.git
cd %appdata%/../local/NodeJS-Updater/appdata
NodeJS.bat
REM ==============================================




REM ==============================================
:fin
if {%adm%} EQU {[adm]} (
   echo.
   echo [Pulse 0 para salir]
   choice /c 0 /n
)