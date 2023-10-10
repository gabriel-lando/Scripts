@echo off

set ROOT_DIR=%~dp0

rem Clean environment
echo ******** Clean environment ********
del /Q /F 7zr.exe > nul 2>&1
del /Q /F ProxSpace.7z > nul 2>&1
rmdir /S /Q ProxSpace > nul 2>&1

rem Download ProxSpace and 7z CLI
echo ******** Download ProxSpace ********
call powershell.exe "$ProgressPreference = 'SilentlyContinue'; wget https://github.com/Gator96100/ProxSpace/releases/latest/download/ProxSpace.7z -O ProxSpace.7z"
echo ******** Download 7z CLI ********
call powershell.exe "$ProgressPreference = 'SilentlyContinue'; wget https://www.7-zip.org/a/7zr.exe -O 7zr.exe"

rem Extract ProxSpace
echo ******** Extract ProxSpace ********
7zr.exe x ProxSpace.7z -bd -y > nul 2>&1

rem Change directory to ProxSpace
cd ProxSpace

rem Fix runme64.bat replacing setup\installed64.txt to setup\installed
echo ******** Fix runme64.bat ********
call powershell.exe "(Get-Content runme64.bat) -replace 'setup\\installed64.txt', 'setup\installed' | Set-Content runme64.bat"

rem Run setup to install dependencies, clone Proxmark3 repo and checkout to latest tag
echo ******** Run setup and clone Proxmark3 repo ********
call runme64.bat -c "git clone https://github.com/RfidResearchGroup/proxmark3"
echo ******** Checkout to latest tag ********
call runme64.bat -c "cd proxmark3 && git fetch --tags && git checkout $(git describe --tags `git rev-list --tags --max-count=1`)"
echo ******** Configure to PM3GENERIC platform ********
call runme64.bat -c "cd proxmark3 && cp Makefile.platform.sample Makefile.platform && sed -i 's/PLATFORM=PM3RDV4/PLATFORM=PM3GENERIC/g' Makefile.platform"

rem Build Proxmark3
echo ******** Build Proxmark3 ********
call autobuild.bat

rem Copy Proxmark3 binaries to root directory
echo ******** Copy Proxmark3 binaries to root directory ********
copy builds\proxmark3\proxmark3-*.7z %ROOT_DIR% > nul 2>&1

rem Change directory to root directory
cd %ROOT_DIR%
