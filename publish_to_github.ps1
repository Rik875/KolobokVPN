# Скрипт быстрой публикации репозитория Kolobok VPN на GitHub
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "       Публикация Kolobok VPN Clients на GitHub           " -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan

$RepoPath = $PSScriptRoot
Set-Location $RepoPath

# 1. Проверка Git
if (-not (Test-Path ".git")) {
    Write-Host "`n[1/4] Инициализация Git-репозитория..." -ForegroundColor Green
    git init -b main
} else {
    Write-Host "`n[1/4] Git репозиторий уже инициализирован." -ForegroundColor Green
}

# 2. Добавление файлов (только README, ассеты, лицензия; APK исключены в .gitignore)
Write-Host "`n[2/4] Подготовка файлов (исходный код и APK скрыты от Git)..." -ForegroundColor Green
git add .gitignore README.md README_EN.md LICENSE assets/

$Status = git status --porcelain
if ($Status) {
    git commit -m "feat: initial landing page for Kolobok VPN Android & Android TV"
    Write-Host "Изменения закоммичены." -ForegroundColor Green
} else {
    Write-Host "Рабочая ветка чиста, нет новых изменений для коммита." -ForegroundColor Yellow
}

# 3. Настройка Remote
Write-Host "`n[3/4] Настройка удаленного репозитория GitHub..." -ForegroundColor Green
$CurrentRemote = git remote get-url origin 2>$null

if (-not $CurrentRemote) {
    Write-Host "Введите URL вашего репозитория на GitHub (например, https://github.com/Rik875/kolobok-vpn.git):" -ForegroundColor Cyan
    $RemoteUrl = Read-Host "URL репозитория"
    if ($RemoteUrl) {
        git remote add origin $RemoteUrl.Trim()
        Write-Host "Добавлен remote: $RemoteUrl" -ForegroundColor Green
    }
} else {
    Write-Host "Текущий remote: $CurrentRemote" -ForegroundColor Green
}

# 4. Отправка ветки main
Write-Host "`n[4/4] Отправка изменений в GitHub..." -ForegroundColor Green
$CanPush = Read-Host "Отправить изменения на GitHub прямо сейчас? (y/n)"
if ($CanPush -eq 'y' -or $CanPush -eq 'Y' -or $CanPush -eq 'д' -or $CanPush -eq 'Д') {
    git push -u origin main
    Write-Host "`nГотово! Страница репозитория успешно загружена на GitHub." -ForegroundColor Green
}

Write-Host "`n==========================================================" -ForegroundColor Cyan
Write-Host "Следующий шаг: загрузка APK в GitHub Releases" -ForegroundColor Yellow
Write-Host "1. Откройте ваш репозиторий на GitHub."
Write-Host "2. Справа нажмите 'Releases' -> 'Draft a new release'."
Write-Host "3. Укажите тег: v1.1.0, заголовок: Kolobok VPN v1.1.0"
Write-Host "4. Перетащите оба APK-файла из папки:"
Write-Host "   $RepoPath\releases\" -ForegroundColor Cyan
Write-Host "   - KolobokVPN_android_universal.apk"
Write-Host "   - Kolobok_TV_release.apk"
Write-Host "5. Нажмите 'Publish release'."
Write-Host "==========================================================" -ForegroundColor Cyan
