# 本地测试部署文件的脚本
# 使用方法: .\scripts\test-local.ps1

$ErrorActionPreference = "Stop"

Write-Host "🧪 本地测试部署文件..." -ForegroundColor Green

# 确保在项目根目录
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$rootPath = Split-Path -Parent $scriptPath
Set-Location $rootPath

# 检查部署目录是否存在
if (-not (Test-Path "gh-pages-examples")) {
    Write-Host "❌ 部署目录不存在，请先运行 .\scripts\deploy-examples.ps1" -ForegroundColor Red
    exit 1
}

# 检查必要文件
$requiredFiles = @(
    "gh-pages-examples\index.html",
    "gh-pages-examples\dist\examples-bundle.js"
)

foreach ($file in $requiredFiles) {
    if (-not (Test-Path $file)) {
        Write-Host "❌ 缺少必要文件: $file" -ForegroundColor Red
        exit 1
    }
}

Write-Host "✅ 文件检查通过" -ForegroundColor Green
Write-Host ""
Write-Host "🌐 启动本地服务器..." -ForegroundColor Cyan
Write-Host ""
Write-Host "选择服务器类型：" -ForegroundColor Yellow
Write-Host "1. Python HTTP Server (默认端口 8080)"
Write-Host "2. Node.js http-server (需要先安装: npm install -g http-server)"
Write-Host "3. PowerShell 简单服务器 (端口 8080)"
Write-Host ""
$choice = Read-Host "请选择 (1/2/3) [默认: 1]"

if ([string]::IsNullOrEmpty($choice)) {
    $choice = "1"
}

Set-Location "gh-pages-examples"

switch ($choice) {
    "1" {
        Write-Host "启动 Python HTTP Server..." -ForegroundColor Cyan
        Write-Host "访问地址: http://localhost:8080" -ForegroundColor Green
        Write-Host "按 Ctrl+C 停止服务器" -ForegroundColor Yellow
        python -m http.server 8080
    }
    "2" {
        Write-Host "启动 Node.js http-server..." -ForegroundColor Cyan
        Write-Host "访问地址: http://localhost:8080" -ForegroundColor Green
        Write-Host "按 Ctrl+C 停止服务器" -ForegroundColor Yellow
        http-server -p 8080
    }
    "3" {
        Write-Host "启动 PowerShell 简单服务器..." -ForegroundColor Cyan
        Write-Host "访问地址: http://localhost:8080" -ForegroundColor Green
        Write-Host "按 Ctrl+C 停止服务器" -ForegroundColor Yellow
        
        $listener = New-Object System.Net.HttpListener
        $listener.Prefixes.Add("http://localhost:8080/")
        $listener.Start()
        
        Write-Host "服务器已启动在 http://localhost:8080" -ForegroundColor Green
        
        while ($listener.IsListening) {
            $context = $listener.GetContext()
            $request = $context.Request
            $response = $context.Response
            
            $localPath = $request.Url.LocalPath
            if ($localPath -eq "/") {
                $localPath = "/index.html"
            }
            
            $filePath = Join-Path (Get-Location) $localPath.TrimStart('/')
            
            if (Test-Path $filePath -PathType Leaf) {
                $content = [System.IO.File]::ReadAllBytes($filePath)
                $response.ContentLength64 = $content.Length
                
                # 设置 MIME 类型
                $ext = [System.IO.Path]::GetExtension($filePath).ToLower()
                $mimeTypes = @{
                    ".html" = "text/html"
                    ".css" = "text/css"
                    ".js" = "application/javascript"
                    ".json" = "application/json"
                    ".jpg" = "image/jpeg"
                    ".png" = "image/png"
                    ".glsl" = "text/plain"
                }
                $mimeType = if ($mimeTypes.ContainsKey($ext)) { $mimeTypes[$ext] } else { "application/octet-stream" }
                $response.ContentType = $mimeType
                
                $response.OutputStream.Write($content, 0, $content.Length)
            } else {
                $response.StatusCode = 404
                $response.Close()
                continue
            }
            
            $response.Close()
        }
    }
    default {
        Write-Host "❌ 无效选择" -ForegroundColor Red
        exit 1
    }
}

