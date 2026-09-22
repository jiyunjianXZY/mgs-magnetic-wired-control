# MGS 磁性有线控制系统 - 一键发布脚本
# 用法：双击 发布.bat，或运行: powershell -NoProfile -ExecutionPolicy Bypass -File publish.ps1
$ErrorActionPreference = 'Stop'
try { [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 } catch {}

Set-Location -LiteralPath $PSScriptRoot

$source = '磁性有线控制系统.html'
$index  = 'index.html'
$liveUrl = 'https://jiyunjianxzy.github.io/mgs-magnetic-wired-control/'

Write-Host ''
Write-Host '== 1/3 同步主页 index.html ==' -ForegroundColor Cyan
if (-not (Test-Path -LiteralPath $source)) {
    Write-Host "[错误] 找不到源文件: $source" -ForegroundColor Red
    exit 1
}
Copy-Item -LiteralPath $source -Destination $index -Force
Write-Host "已复制: $source -> $index"

Write-Host ''
Write-Host '== 2/3 提交改动 ==' -ForegroundColor Cyan
git add -A
$msg = '更新 ' + (Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
$commitOut = git commit -m $msg 2>&1
if ($LASTEXITCODE -ne 0) {
    $joined = $commitOut -join "`n"
    if ($joined -match 'nothing to commit') {
        Write-Host '没有检测到改动，跳过提交。'
    } else {
        Write-Host '[错误] 提交失败：' -ForegroundColor Red
        Write-Host $joined
        exit 1
    }
}

Write-Host ''
Write-Host '== 3/3 推送到 GitHub ==' -ForegroundColor Cyan
git push origin main
if ($LASTEXITCODE -ne 0) {
    Write-Host '[错误] 推送失败，请检查网络或登录状态。' -ForegroundColor Red
    exit 1
}

Write-Host ''
Write-Host '发布完成！' -ForegroundColor Green
Write-Host "访问地址: $liveUrl"