@echo off
setlocal enabledelayedexpansion 
cls
rem ****************************************************************************************************
call :InitColorText
rem ****************************************************************************************************

set savedOldDir=%CD%
set newDir=%~dp0
set PluginsDir=%newDir%Plugins
set cx=0
set forceClear=0
set errorMessage="Cleaning successful"
set errorColor=0A

rem ****************************************************************************************************
rem ***  /f - silence force clean
IF [%1]==[/f] set forceClear=1 


echo ================================================================================
echo  Project DIR : %newDir%
echo ================================================================================
chdir /d %newDir% 

rem *** Add from root Binaries & Intermediate
call :AddToDirsList %newDir%Binaries
call :AddToDirsList %newDir%Intermediate
rem uncomment if you are sure in it
rem call :AddToDirsList %newDir%Saved

rem *** Add all Binaries & Intermediate from Plugins 
for /f "delims=" %%D in ('dir %PluginsDir% /a:d /b') do (
call :AddToDirsList %PluginsDir%\%%D\Binaries
call :AddToDirsList %PluginsDir%\%%D\Intermediate
)

if %cx%==0 (
rem call :ColorText 0A "Nothing to clean up"
rem echo.
set errorMessage="Nothing to clean up"
 GOTO :Done 
)

echo Will be deleted :
set /A len=%cx%-1
for /L %%i in (0,1,%len%) do (
 echo     !dirs[%%i]!
)

IF %forceClear%==1 GOTO :YES

echo ================================================================================
	
Choice /M "Delete all ?"
if Errorlevel 2 (
set errorMessage="Cancled"
Goto :Done
)
if Errorlevel 1 Goto Yes
Goto :Done

:Yes
echo ================================================================================
for /L %%i in (0,1,%len%) do (
 rmdir  !dirs[%%i]! /s /q
)

rem *** If all folders not exist - successful, else - failed
for /L %%i in (0,1,%len%) do ( 
 if exist !dirs[%%i]! (
 set errorMessage="Cleaning FAILED"
 set errorColor=0C
 )
)

:Done
rem *** print result
echo ================================================================================
call :ColorText %errorColor% %errorMessage%
echo .

echo ================================================================================
if %forceClear%==1   goto :eof
pause

echo ================================================================================
goto :eof

chdir /d %savedOldDir% rem restore old pwd
 
rem ****************************************************************************************************
rem ******* AddTodirs **********************************************************************************
rem ****************************************************************************************************

:AddToDirsList

if exist %~1 (

set dirs[!cx!]=%~1
set /A cx=cx+1
)

goto :eof

rem ****************************************************************************************************
rem ******* Init color text func ***********************************************************************
rem *****

:InitColorText
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  set "DEL=%%a"
)
goto :eof

rem ****************************************************************************************************
rem ******* echo color text func ***********************************************************************
rem ****************************************************************************************************

:ColorText
echo off
<nul set /p ".=%DEL%" > "%~2"
findstr /v /a:%1 /R "^$" "%~2" nul
del "%~2" > nul 2>&1
goto :eof