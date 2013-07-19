@echo off

rem Start eines Batch Scanners
rem
rem Speedpoint GmbH (FW), Stand: Maerz 2011, Version 1

rem --------------------------------------------------------------------

rem Bitte anpassen:

set job="PA-Scanner"
set prog="C:\Program Files (x86)\fiScanner\ScandAll PRO\ScandAllPro.exe"
set task="ScandAllPro.exe"

rem --------------------------------------------------------------------

tasklist | find /I %task% && taskkill /IM %task% /F
call %prog% /exit /batch:%job%

exit