@echo off
title 🐢 Turtle Chat Launcher
color 0A

echo.
echo ================================================
echo           🐢 TURTLE CHAT LAUNCHER 🐢
echo ================================================
echo.

REM Check Python
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Python not found!
    echo.
    echo Please install Python from:
    echo https://www.python.org/downloads/
    echo.
    echo Make sure to check "Add Python to PATH"!
    echo.
    pause
    exit /b
)
echo ✅ Python found

REM Check Ollama
where ollama >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Ollama not found!
    echo.
    echo Please install Ollama from:
    echo https://ollama.ai/download
    echo.
    pause
    exit /b
)
echo ✅ Ollama found

echo.
echo ------------------------------------------------
echo Starting services...
echo ------------------------------------------------
echo.

REM Start Ollama if not running
curl -s http://localhost:11434/api/tags >nul 2>&1
if %errorlevel% neq 0 (
    echo Starting Ollama service...
    start /B ollama serve
    timeout /t 5 /nobreak >nul
    echo ✅ Ollama started
) else (
    echo ✅ Ollama already running
)

REM Check for model
echo.
echo Checking for turtle model...
curl -s http://localhost:11434/api/tags 2>nul | find "turtle-llama-3" >nul
if %errorlevel% neq 0 (
    echo.
    echo Model not found. Checking for model.gguf...
    
    if exist model.gguf (
        echo ✅ Found model.gguf
        echo.
        echo Importing model (this may take a minute)...
        echo FROM ./model.gguf > Modelfile
        ollama create turtle-llama-3 -f Modelfile
        
        if %errorlevel% equ 0 (
            echo ✅ Model imported successfully!
        ) else (
            echo.
            echo ❌ Failed to import model
            echo.
            echo Possible issues:
            echo - Not enough RAM (need ~5GB free)
            echo - model.gguf is corrupted
            echo - Try a smaller quantization (Q3_K_M or Q2_K)
            echo.
            pause
            exit /b
        )
    ) else (
        echo.
        echo ❌ model.gguf not found!
        echo.
        echo Please:
        echo 1. Download your GGUF from Hugging Face
        echo 2. Rename it to: model.gguf  
        echo 3. Put it in this folder
        echo 4. Run this script again
        echo.
        echo Current folder: %CD%
        echo.
        pause
        exit /b
    )
) else (
    echo ✅ Model ready
)

REM Enable CORS for Ollama
echo.
echo Configuring Ollama CORS...
setx OLLAMA_ORIGINS "*" >nul 2>&1
echo ✅ CORS configured

echo.
echo ------------------------------------------------
echo Starting web server...
echo ------------------------------------------------
echo.
echo ✅ Opening browser in 2 seconds...
echo.
echo Your chat will open at:
echo http://localhost:8000/turtle-chat.html
echo.
echo ⚠️  KEEP THIS WINDOW OPEN while chatting!
echo    Close it when you're done.
echo.
echo ================================================

timeout /t 2 /nobreak >nul

REM Open browser
start http://localhost:8000/turtle-chat.html

REM Start web server (this blocks)
echo Starting server... (Press Ctrl+C to stop)
echo.
python -m http.server 8000