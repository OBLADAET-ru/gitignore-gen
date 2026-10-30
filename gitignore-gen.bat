@echo off
setlocal
set SCRIPT_DIR=%~dp0
if "%~1"=="" (
  set DIR=.
) else (
  set DIR=%~1
)
node "%SCRIPT_DIR%dist\cli\index.js" %DIR%
pause
