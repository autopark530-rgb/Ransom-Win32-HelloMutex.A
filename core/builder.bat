@echo off
REM =====================================================
REM Ultimate Zero-Touch Portable Builder for core_app.exe
REM =====================================================

SETLOCAL ENABLEDELAYEDEXPANSION

REM --- Configurable paths & URLs ---
SET SRC_TAR=%~dp0xxx.tar
SET SRC_DIR=%~dp0Source
SET BUILD_DIR=%~dp0Build
SET MINGW_DIR=%~dp0mingw-w64-portable
SET MINGW_BIN=%MINGW_DIR%\bin
SET MINGW_PORTABLE_URL=https://sourceforge.net/projects/mingw-w64/files/latest/download
SET GITHUB_RAW_URL=https://raw.githubusercontent.com/YourRepo/YourProject/main/

REM --- Step 1: Extract source if missing ---
IF NOT EXIST "%SRC_DIR%\Core\main.cpp" (
    echo Source folder not found, extracting xxx.tar...
    IF EXIST "%SRC_TAR%" (
        mkdir "%SRC_DIR%"
        where tar >nul 2>&1
        IF %ERRORLEVEL% EQU 0 (
            tar -xf "%SRC_TAR%" -C "%SRC_DIR%"
        ) ELSE (
            where "C:\Program Files\7-Zip\7z.exe" >nul 2>&1
            IF %ERRORLEVEL% NEQ 0 (
                echo Neither tar.exe nor 7-Zip found. Please install one.
                pause
                exit /b 1
            ) ELSE (
                "C:\Program Files\7-Zip\7z.exe" x "%SRC_TAR%" -aoa -o"%SRC_DIR%"
            )
        )
    ) ELSE (
        mkdir "%SRC_DIR%"
        echo xxx.tar not found. Will fetch files from GitHub.
    )
)

REM --- Step 2: Ensure portable MinGW ---
IF NOT EXIST "%MINGW_BIN%\g++.exe" (
    echo Portable MinGW not found. Downloading...
    SET MINGW_ZIP=%TEMP%\mingw-w64-portable.zip
    powershell -Command "Invoke-WebRequest -Uri '%MINGW_PORTABLE_URL%' -OutFile '%MINGW_ZIP%'"
    IF %ERRORLEVEL% NEQ 0 (
        echo Failed to download portable MinGW.
        pause
        exit /b 1
    )
    echo Extracting MinGW...
    powershell -Command "Expand-Archive -LiteralPath '%MINGW_ZIP%' -DestinationPath '%MINGW_DIR%' -Force"
    IF %ERRORLEVEL% NEQ 0 (
        echo MinGW extraction failed!
        pause
        exit /b 1
    )
)

REM --- Step 3: Add MinGW to PATH ---
SET PATH=%MINGW_BIN%;%PATH%

REM --- Step 4: Prepare build folder ---
mkdir "%BUILD_DIR%" >nul 2>&1

REM --- Step 5: List all source files ---
SET FILES=Core\main.cpp Core\innocent\Base64.cpp Core\innocent\lock.cpp Core\crc32\crc32.cpp Core\sha256\sha256.cpp ^
          Core\innocent\Base64.h Core\innocent\lock.h Core\crc32\crc32.h Core\sha256\sha256.h

REM --- Step 6: Fetch missing source/header files from GitHub ---
FOR %%F IN (%FILES%) DO (
    IF NOT EXIST "%SRC_DIR%\%%F" (
        echo Fetching missing file %%F from GitHub...
        mkdir "%SRC_DIR%\%%~dpF" 2>nul
        powershell -Command "Invoke-WebRequest -Uri '%GITHUB_RAW_URL%%%F' -OutFile '%SRC_DIR%\%%F'"
        IF %ERRORLEVEL% NEQ 0 (
            echo ERROR: Failed to download %%F
            pause
            exit /b 1
        )
    )
)

REM --- Step 7: Compile ---
echo Compiling core_app.exe...
g++ ^
  "%SRC_DIR%\Core\main.cpp" ^
  "%SRC_DIR%\Core\innocent\Base64.cpp" ^
  "%SRC_DIR%\Core\innocent\lock.cpp" ^
  "%SRC_DIR%\Core\crc32\crc32.cpp" ^
  "%SRC_DIR%\Core\sha256\sha256.cpp" ^
  -I"%SRC_DIR%" ^
  -o "%BUILD_DIR%\core_app.exe" ^
  -lws2_32 -liphlpapi -lshlwapi -lole32 -luuid

IF %ERRORLEVEL% EQU 0 (
    echo Build complete: %BUILD_DIR%\core_app.exe
) ELSE (
    echo Build failed!
)

pause
