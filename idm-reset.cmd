@setlocal DisableDelayedExpansion
@echo off





::=========================================================================================================
:    Credits:
::=========================================================================================================

::  IDM trial reset logic is taken from @Dukun Cabul's autoit tool IDM-AIO 2020 Final.exe
::  https://www.nsaneforums.com/topic/366535--/?do=findComment&comment=1562675

::  @WindowsAddict - IDM Trial Script
::  [windowsaddict@protonmail.com]

::=========================================================================================================







::========================================================================================================================================

title  IDM Trial Script 0.1
set _elev=
if /i "%~1"=="-el" set _elev=1
for /f "tokens=6 delims=[]. " %%G in ('ver') do set winbuild=%%G
set "_psc=powershell -nop -ep bypass -c"
set "nul=1>nul 2>nul"
set "ELine=echo: & %_psc% write-host -back Black -fore Red ==== ERROR ==== &echo:"
set line=_____________________________________________________________________________________________________

::========================================================================================================================================

for %%i in (powershell.exe) do if "%%~$path:i"=="" (
echo: &echo ==== ERROR ==== &echo:
echo Powershell is not installed in the system.
echo Aborting...
goto Done
)

::========================================================================================================================================

if %winbuild% LSS 7600 (
%ELine%
echo Unsupported OS version Detected.
echo Project is supported only for Windows 7/8/8.1/10 and their Server equivalent.
goto Done
)

::========================================================================================================================================

::  Elevate script as admin and pass arguments and preventing loop
::  Thanks to @hearywarlot [ https://forums.mydigitallife.net/threads/.74332/ ] for the VBS method.
::  Thanks to @abbodi1406 for the powershell method and solving special characters issue in file path name.

::  VBS method as a first attempt is used because the powershell elevation is slow to load on average machines, and powershell elevation 
::  as a fallback is used because WSH can be blocked on system.

%nul% reg query HKU\S-1-5-19 && (
goto :_Passed
) || (
if defined _elev goto :_E_Admin
)


set "batf_=%~f0"
set "batp_=%batf_:'=''%"

set "_vbsf=%temp%\admin.vbs"
set _PSarg="""%~f0""" -el

setlocal EnableDelayedExpansion
(
echo Set strArg=WScript.Arguments.Named
echo Set strRdlproc = CreateObject^("WScript.Shell"^).Exec^("rundll32 kernel32,Sleep"^)
echo With GetObject^("winmgmts:\\.\root\CIMV2:Win32_Process.Handle='" ^& strRdlproc.ProcessId ^& "'"^)
echo With GetObject^("winmgmts:\\.\root\CIMV2:Win32_Process.Handle='" ^& .ParentProcessId ^& "'"^)
echo If InStr ^(.CommandLine, WScript.ScriptName^) ^<^> 0 Then
echo strLine = Mid^(.CommandLine, InStr^(.CommandLine , "/File:"^) + Len^(strArg^("File"^)^) + 8^)
echo End If
echo End With
echo .Terminate
echo End With
echo CreateObject^("Shell.Application"^).ShellExecute "cmd.exe", "/c " ^& chr^(34^) ^& chr^(34^) ^& strArg^("File"^) ^& chr^(34^) ^& strLine ^& chr^(34^), "", "runas", 1
)>"!_vbsf!"

(%nul% cscript //NoLogo "!_vbsf!" /File:"!batf_!" -el) && (
del /f /q "!_vbsf!"
exit /b
) || (
del /f /q "!_vbsf!"
%nul% %_psc% "start cmd.exe -arg '/c \"!_PSarg:'=''!\"' -verb runas" && (
exit /b
) || (
goto :_E_Admin
)
)
exit /b

:_E_Admin
%ELine%
echo This script require administrator privileges.
echo To do so, right click on this script and select 'Run as administrator'.
goto Done

:_Passed

::========================================================================================================================================

::  Fix for the special characters limitation in path name
::  Written by @abbodi1406

set "_work=%~dp0"
if "%_work:~-1%"=="\" set "_work=%_work:~0,-1%"

set "_batf=%~f0"
set "_batp=%_batf:'=''%"

setlocal EnableDelayedExpansion

::========================================================================================================================================

cls
mode con: cols=98 lines=30
echo:
echo:
echo:
echo:
echo                   _______________________________________________________________
echo                  ^|                                                               ^| 
echo                  ^|                                                               ^|
echo                  ^|      [1] Reset IDM Trial                                      ^|
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|      [2] Exit                                                 ^|
echo                  ^|                                                               ^|
echo                  ^|_______________________________________________________________^|
echo:
choice /C:12 /N /M ">                   Enter Your Choice [1,2] : "

if errorlevel 2 exit
if errorlevel 1 goto Reset

::========================================================================================================================================

:Reset

cls

::  Set buffer height independently of window height
::  https://stackoverflow.com/a/13351373
::  Written by @dbenham (stackoverflow)

mode con: cols=105 lines=30
%nul% %_psc% "&{$H=get-host;$W=$H.ui.rawui;$B=$W.buffersize;$B.height=999;$W.buffersize=$B;}"

::========================================================================================================================================

::  Check Windows Architecture 

reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > nul && set arch=x86|| set arch=x64

::========================================================================================================================================

echo:
echo Deleting registry keys...
echo:

if "%arch%"=="x86" set "Reg__key=HKCU\Software\Classes\CLSID" &set tokn=5
if "%arch%"=="x64" set "Reg__key=HKCU\Software\Classes\Wow6432Node\CLSID" &set tokn=6

for %%# in (
"HKLM\SOFTWARE\Wow6432Node\Internet Download Manager"
"HKLM\Software\Internet Download Manager"
""HKCU\Software\DownloadManager" "/v" "FName""
""HKCU\Software\DownloadManager" "/v" "LName""
""HKCU\Software\DownloadManager" "/v" "Email""
""HKCU\Software\DownloadManager" "/v" "Serial""
""HKCU\Software\DownloadManager" "/v" "scansk""
""HKCU\Software\DownloadManager" "/v" "tvfrdt""
""HKCU\Software\DownloadManager" "/v" "radxcnt""
""HKCU\Software\DownloadManager" "/v" "LstCheck""
""HKCU\Software\DownloadManager" "/v" "ptrk_scdt""
""HKCU\Software\DownloadManager" "/v" "LastCheckQU""
) do for /f "tokens=* delims=" %%A in ("%%~#") do (
set "reg="%%~A"" &reg query !reg! 2>nul | find /i "H" 1>nul && call :Delete_2a
)

for %%# in (
MData
Model
scansk
Therad
) do for /f "tokens=* delims=" %%G in ("%%~#") do (
for /f "tokens=%tokn% delims=\" %%a in ('reg query %Reg__key% /s /f %%G /e 2^>nul ^| find /i "CLSID"') do if not [%%a]==[] set "reg=%Reg__key%\%%a" &call :Delete_2
)

for /f "tokens=%tokn% delims=\" %%a in ('reg query %Reg__key% /s /f Version /k /e 2^>nul ^| find /i "CLSID"') do if not [%%a]==[] set "reg=%Reg__key%\%%a" &call :Delete_3

::========================================================================================================================================

echo:
echo Adding registry key...
echo:

if "%arch%"=="x64" (
set "key_HKLM="HKLM\SOFTWARE\WOW6432Node\Internet Download Manager" /v "AdvIntDriverEnabled2""
) else (
set "key_HKLM="HKLM\Software\Internet Download Manager" /v "AdvIntDriverEnabled2""
)

Reg add %key_HKLM% /t REG_DWORD /d "1" /f %nul%

reg query %key_HKLM% 2>nul | find /i "H" 1>nul

if [%errorlevel%]==[0] (
echo Added - %key_HKLM%
) else (
powershell write-host 'Failed' -fore '"white"' -back ' "DarkRed"' -NoNewline &echo  - %key_HKLM%
)

echo:

::========================================================================================================================================

:Done

echo %line%
echo:
echo:
echo Press any key to exit...
pause >nul
exit /b

::========================================================================================================================================

:Delete_3

for /f "skip=2 tokens=2*" %%a in ('reg query !reg!\Version /ve 2^>nul') do if 1%%b EQU +1%%b (
call :Delete_2
exit /b
)
exit /b

::========================================================================================================================================

:Delete_2

set "reg="!reg!""
reg query !reg! 2>nul | find /i "H" 1>nul || exit /b

reg query !reg! 2>nul | find /i "LocalServer32" 1>nul && exit /b
reg query !reg! 2>nul | find /i "InprocServer32" 1>nul && exit /b
reg query !reg! 2>nul | find /i "InprocHandler32" 1>nul && exit /b

:Delete_2a

reg delete !reg! /f %nul%

reg query !reg! 2>nul | find /i "H" 1>nul

if [%errorlevel%]==[0] (
powershell write-host 'Failed' -fore '"white"' -back ' "DarkRed"' -NoNewline &echo  - !reg!
) else (
echo Deleted - !reg!
)

exit /b

::========================================================================================================================================