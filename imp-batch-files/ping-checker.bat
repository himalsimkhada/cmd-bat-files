:Start
@ECHO off
ECHO Ping Tester
ECHO BY
ECHO HarHarMahadev
ECHO -_-
ECHO CSGO Ping Tester
ECHO ***********************************
ECHO ------------SEA Servers------------
CALL:ping 103.10.124.116
ECHO - (sgp) Singapore:            %ms%
CALL:ping 153.254.86.164
ECHO - (hgk) Hongkong:            %ms%
ECHO ----------Indian Servers-----------
CALL:ping 155.133.232.2
ECHO - (maa) Chennai:              %ms%
CALL:ping 155.133.233.2
ECHO - (bom) Mumbai:               %ms%
ECHO ***********************************

ECHO .

ECHO .

ECHO .

ECHO Valorant Ping Tester
ECHO ***********************************
ECHO ----------Indian Servers-----------
CALL:ping 75.2.66.166
ECHO - Mumbai 1:         	      %ms%
CALL:ping 99.83.136.104
ECHO - Mumbai 2:         	      %ms%
ECHO ***********************************

ECHO .

ECHO .

ECHO .

ECHO Rust Ping Tester
ECHO ***********************************
ECHO -------Rustified SEA Servers-------
CALL:ping 139.99.125.47
ECHO - SEA Main:         	      %ms%
CALL:ping 139.99.124.97
ECHO - SEA Medium:         	      %ms%
CALL:ping 139.99.124.15
ECHO - SEA Long:         	      %ms%
ECHO ***********************************

ECHO .

ECHO .

ECHO .

ECHO PUBG Ping Tester
ECHO ***********************************
ECHO ------------SEA Servers------------
CALL:ping 13.228.0.251
ECHO - SEA #1:         	      %ms%
CALL:ping 46.51.216.14
ECHO - SEA #2:         	      %ms%
CALL:ping 52.221.255.252
ECHO - SEA #3:         	      %ms%
ECHO ***********************************

ECHO .

ECHO .

ECHO .

ECHO Apex Legends Ping Tester
ECHO ***********************************
ECHO ------------SEA Servers------------
CALL:ping 107.6.114.196
ECHO - (sgp) Singapore:            %ms%
CALL:ping 107.6.119.124
ECHO - (sgp) Singapore:           %ms%
ECHO ***********************************

ECHO Ping Tester
ECHO BY
ECHO HarHarMahadev
ECHO -_-

pause
cls
goto Start
 
:ping
SET ms=Error
FOR /F "tokens=4 delims==" %%i IN ('ping.exe -n 1 %1 ^| FIND "ms"') DO SET ms=%%i
GOTO:EOF