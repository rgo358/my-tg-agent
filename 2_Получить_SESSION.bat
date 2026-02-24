@echo off
chcp 65001 >nul
title 2_Получить SESSION_STRING — TG-Агент v4.0
echo.
echo ================================================
echo   Генерирую SESSION_STRING для твоего агента...
echo ================================================
echo.

set "FOLDER=%USERPROFILE%\Desktop\MyTGAgent"

if not exist "%FOLDER%" (
  echo ❌ Сначала запусти 1_Создать_Агента.bat !
  pause
  exit
)

cd /d "%FOLDER%"

echo Создаю get_session.py ...
(
echo from telethon import TelegramClient
echo from telethon.sessions import StringSession
echo import asyncio
echo import os
echo.
echo print("=== ПОЛУЧЕНИЕ SESSION_STRING ===")
echo print("Введи данные ниже:")
echo.
echo api_id = int(input("API_ID (с my.telegram.org): "))
echo api_hash = input("API_HASH: ")
echo phone = input("Телефон (+79xxxxxxxxx): ")
echo.
echo client = TelegramClient(StringSession(), api_id, api_hash)
echo.
echo async def main():
echo     print("Отправляю код в Telegram...")
echo     await client.start(phone=phone)
echo     session_string = client.session.save()
echo     print("\n✅ СКОПИРУЙ ЭТУ СТРОКУ ЦЕЛИКОМ и сохрани в блокнот:")
echo     print("─" * 80)
echo     print(session_string)
echo     print("─" * 80)
echo     print("\nГотово! Теперь иди на Railway и вставь эту строку в Variables.")
echo     input("\nНажми Enter чтобы закрыть...")
echo.
echo asyncio.run(main())
) > get_session.py

echo Запускаю скрипт...
echo.
echo Если откроется чёрное окно — вводи данные по очереди.
echo После этого получишь очень длинную строку SESSION_STRING.
echo.

python get_session.py

if %errorlevel% neq 0 (
  echo.
  echo ❌ Python не найден.
  echo Скачай Python здесь: https://www.python.org/downloads/
  echo Поставь галочку "Add python.exe to PATH" и попробуй снова.
  pause
  exit
)

echo.
echo ================================================
echo   Готово! SESSION_STRING получен.
echo ================================================
echo.
pause