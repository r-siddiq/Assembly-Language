@echo off
setlocal enabledelayedexpansion

rem ---- Resolve VS Build Tools environment (try vcvars32, then VsDevCmd, else fall back to direct tools dir) ----
set "VSBT=C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools"

if exist "%VSBT%\VC\Auxiliary\Build\vcvars32.bat" (
  call "%VSBT%\VC\Auxiliary\Build\vcvars32.bat"
) else if exist "%VSBT%\Common7\Tools\VsDevCmd.bat" (
  call "%VSBT%\Common7\Tools\VsDevCmd.bat" -arch=x86 -host_arch=x86
) else (
  rem Fallback: directly add ml/link directory (update version folder if MSVC updates)
  set "TOOLSDIR=%VSBT%\VC\Tools\MSVC\14.44.35207\bin\Hostx86\x86"
  if exist "%TOOLSDIR%\ml.exe" (
    set "PATH=%TOOLSDIR%;%PATH%"
  ) else (
    echo Could not find vcvars32.bat, VsDevCmd.bat, or ml.exe in expected locations.
    exit /b 1
  )
)

rem ---- Build output dir ----
if not exist "build" mkdir "build"

rem ---- Args ----
rem %1 = full path to the .asm file
set "ASM=%~1"
if "%ASM%"=="" (
  echo No .asm file provided.
  exit /b 1
)

for %%F in ("%ASM%") do (
  set "BASE=%%~nF"
)

rem ---- Assemble ----
ml /c /coff /Zi /I "%~dp0..\irvine" /Fo "build\!BASE!.obj" "%ASM%"
if errorlevel 1 exit /b %errorlevel%

rem ---- Link (Irvine32.lib plus KERNEL32/USER32 from your irvine folder) ----
link /DEBUG /SUBSYSTEM:CONSOLE /MACHINE:X86 /LIBPATH:"%~dp0..\irvine" "build\!BASE!.obj" Irvine32.lib kernel32.lib user32.lib /OUT:"build\!BASE!.exe"
if errorlevel 1 exit /b %errorlevel%

endlocal
