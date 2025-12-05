# 部署示例到 GitHub Pages 的 PowerShell 脚本
# 使用方法: .\scripts\deploy-examples.ps1

$ErrorActionPreference = "Stop"

Write-Host "🚀 开始构建示例项目..." -ForegroundColor Green

# 确保在项目根目录
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$rootPath = Split-Path -Parent $scriptPath
Set-Location $rootPath

# 构建所有包
Write-Host "📦 构建所有包..." -ForegroundColor Cyan
pnpm run build

# 构建示例
Write-Host "🎨 构建示例..." -ForegroundColor Cyan
pnpm run build-examples

# 创建部署目录
$deployDir = "gh-pages-examples"
if (Test-Path $deployDir) {
    Remove-Item -Recurse -Force $deployDir
}
New-Item -ItemType Directory -Path $deployDir | Out-Null

# 复制必要文件
Write-Host "📋 复制文件..." -ForegroundColor Cyan
Copy-Item "packages\troika-examples\index.html" $deployDir
Copy-Item "packages\troika-examples\index.css" $deployDir
Copy-Item -Recurse "packages\troika-examples\dist" $deployDir
if (Test-Path "packages\troika-examples\GitHub-Mark-64px.png") {
    Copy-Item "packages\troika-examples\GitHub-Mark-64px.png" $deployDir
}

# 复制示例需要的资源文件
$resourceDirs = @("globe", "shader-anim", "globe-connections")
foreach ($dir in $resourceDirs) {
    $sourcePath = "packages\troika-examples\$dir"
    if (Test-Path $sourcePath) {
        Copy-Item -Recurse $sourcePath "$deployDir\$dir"
    }
}

Write-Host "✅ 构建完成！文件已准备在 $deployDir 目录中" -ForegroundColor Green
Write-Host ""
Write-Host "📝 下一步：" -ForegroundColor Yellow
Write-Host "1. 如果使用 gh-pages 分支部署："
Write-Host "   git checkout --orphan gh-pages"
Write-Host "   git rm -rf ."
Write-Host "   Copy-Item -Recurse $deployDir\* ."
Write-Host "   git add ."
Write-Host "   git commit -m 'Deploy examples to GitHub Pages'"
Write-Host "   git push origin gh-pages"
Write-Host ""
Write-Host "2. 如果使用 GitHub Actions 自动部署，直接推送代码即可"

