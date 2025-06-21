@echo off
setlocal enabledelayedexpansion
echo Пуш репозитория в два места...
echo.

REM Проверяем и добавляем remote для GitHub (если не существует)
git remote | findstr /C:"github" >nul
if errorlevel 1 (
    echo Добавляем remote 'github'...
    git remote add github https://github.com/legacydayzmods/LegacyMods.git
) else (
    echo Remote 'github' уже существует.
)

REM Проверяем и добавляем remote для GitFlic (если не существует)
git remote | findstr /C:"gitflic" >nul
if errorlevel 1 (
    echo Добавляем remote 'gitflic'...
    git remote add gitflic https://gitflic.ru/project/legacy/workshop.git
) else (
    echo Remote 'gitflic' уже существует.
)

echo.
echo Добавляем изменения в коммит...
git add .
git status --porcelain | findstr /R /C:"^[AMDRC]" >nul
if not errorlevel 1 (
    set /p commit_message=Введите сообщение коммита: 
    if "!commit_message!"=="" set commit_message=Auto commit
    git commit -m "!commit_message!"
    echo Коммит создан: !commit_message!
) else (
    echo Нет изменений для коммита.
)

echo.
echo Синхронизируем с GitHub...
git pull github main --no-edit
if errorlevel 1 (
    echo ПРЕДУПРЕЖДЕНИЕ: Не удалось подтянуть изменения из GitHub
)
git push github main
if errorlevel 1 (
    echo ОШИБКА: Не удалось запушить в GitHub!
    pause
    exit /b 1
)

echo.
echo Синхронизируем с GitFlic...
git pull gitflic main --no-edit
if errorlevel 1 (
    echo ПРЕДУПРЕЖДЕНИЕ: Не удалось подтянуть изменения из GitFlic
)
git push gitflic main
if errorlevel 1 (
    echo ОШИБКА: Не удалось запушить в GitFlic!
    pause
    exit /b 1
)

echo.
echo Успешно запушено в оба репозитория!
echo GitHub: https://github.com/legacydayzmods/LegacyMods.git
echo GitFlic: https://gitflic.ru/project/legacy/workshop.git
echo.
pause 