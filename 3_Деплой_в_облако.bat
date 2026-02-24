@echo off
chcp 65001 >nul
title 3_Деплой_в_облако — TG-Агент v4.0
echo.
echo ================================================
echo   Финальный шаг: подготовка к деплою в облако
echo ================================================
echo.

set "FOLDER=%USERPROFILE%\Desktop\MyTGAgent"

if not exist "%FOLDER%" (
  echo ❌ Папка MyTGAgent не найдена!
  echo Сначала запусти 1_Создать_Агента.bat
  pause
  exit
)

echo ✅ Папка найдена. Открываю её...
explorer "%FOLDER%"

echo Создаю ZIP-архив для удобной загрузки на GitHub...
powershell -command "Compress-Archive -Path '%FOLDER%' -DestinationPath '%USERPROFILE%\Desktop\MyTGAgent.zip' -Force"
echo ✅ ZIP готов: MyTGAgent.zip на рабочем столе!

echo.
echo Открываю GitHub (создай новый репозиторий)...
start https://github.com/new

echo Открываю Railway (твой облачный Docker)...
start https://railway.app/dashboard

echo.
echo ================================================
echo   ЧТО ДЕЛАТЬ ДАЛЬШЕ (3 минуты):
echo ================================================
echo 1. На GitHub:
echo    • Назови репозиторий например my-tg-agent
echo    • Оставь Public
echo    • Нажми "Create repository"
echo.
echo 2. На странице репозитория нажми зелёную кнопку "Add file" → "Upload files"
echo    • Перетащи весь ZIP MyTGAgent.zip ИЛИ распакуй его и загрузи все файлы
echo    • Commit changes
echo.
echo 3. Перейди на Railway.app
echo    • New Project → Deploy from GitHub repo
echo    • Выбери свой новый репозиторий → Deploy
echo.
echo 4. После деплоя зайди в Settings → Variables и добавь 4 строки:
echo    SESSION_STRING = [твоя длинная строка из второго батника]
echo    API_ID = твой
echo    API_HASH = твой
echo    XAI_API_KEY = xai-...
echo.
echo 5. Нажми Deploy снова (если нужно)
echo.
echo ================================================
echo   Всё! Через 1-2 минуты агент запустится в облаке 24/7
echo   Пиши ему в «Сохранённые сообщения» обычным языком.
echo ================================================
echo.
echo Я открыл все нужные сайты и папку.
echo Если что-то не так — кидай сюда скрин.
pause