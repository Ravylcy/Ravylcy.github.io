@echo off
setlocal enabledelayedexpansion
set "TARGET_DIR=%~dp0"
if "%TARGET_DIR:~-1%"=="\" set "TARGET_DIR=%TARGET_DIR:~0,-1%"
set "OUTPUT_FILE=%TARGET_DIR%\%~n0.txt"

echo Combining html files...

set /a html_count=0
set "TEMP_FILE=%TEMP%\combine_%RANDOM%.tmp"

:: Minimal header
echo Combined HTML - %date%> "%TEMP_FILE%"

:: Process .html files
for /r "%TARGET_DIR%" %%f in (*.html) do (
    set "relative_path=%%f"
    set "relative_path=!relative_path:%TARGET_DIR%\=!"
    set "relative_path=!relative_path:.=!"
    
    echo. >> "%TEMP_FILE%"
    echo === !relative_path! === >> "%TEMP_FILE%"
    
    for /f "usebackq delims=" %%L in ("%%f") do (
        set "line=%%L"
        if "!line:~-1!"=="." (
            set "line=!line:~0,-1!"
        )
        echo !line!>> "%TEMP_FILE%"
    )
    
    set /a html_count+=1
)

:: Compact summary
(
    echo.
    echo === SUMMARY ===
    echo HTML: %html_count%
) >> "%TEMP_FILE%"

move "%TEMP_FILE%" "%OUTPUT_FILE%" >nul

echo Complete! HTML: %html_count%
echo Output: %OUTPUT_FILE%
pause