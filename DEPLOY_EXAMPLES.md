# 部署示例到 GitHub Pages

本指南说明如何将 Troika 示例项目部署到 GitHub Pages。

## 方法一：使用 GitHub Actions 自动部署（推荐）

这是最简单的方法，每次推送代码到 `main` 分支时会自动部署。

### 步骤：

1. **启用 GitHub Pages**
   - 进入你的 GitHub 仓库设置页面
   - 点击左侧的 "Pages" 选项
   - 在 "Source" 下拉菜单中选择 "GitHub Actions"
   - 保存设置

2. **推送代码**
   - 将 `.github/workflows/deploy-examples.yml` 文件提交并推送到仓库
   - GitHub Actions 会自动构建并部署示例

3. **访问示例**
   - 部署完成后，访问 `https://你的用户名.github.io/troika/` 查看示例

## 方法二：手动部署到 gh-pages 分支

如果你想手动控制部署过程：

### Windows (PowerShell):

```powershell
# 1. 构建示例
.\scripts\deploy-examples.ps1

# 2. 切换到 gh-pages 分支（如果不存在则创建）
git checkout --orphan gh-pages
git rm -rf .

# 3. 复制构建文件
Copy-Item -Recurse gh-pages-examples\* .

# 4. 提交并推送
git add .
git commit -m "Deploy examples to GitHub Pages"
git push origin gh-pages

# 5. 切换回主分支
git checkout main
```

### Linux/Mac:

```bash
# 1. 构建示例
chmod +x scripts/deploy-examples.sh
./scripts/deploy-examples.sh

# 2. 切换到 gh-pages 分支（如果不存在则创建）
git checkout --orphan gh-pages
git rm -rf .

# 3. 复制构建文件
cp -r gh-pages-examples/* .

# 4. 提交并推送
git add .
git commit -m "Deploy examples to GitHub Pages"
git push origin gh-pages

# 5. 切换回主分支
git checkout main
```

### 配置 GitHub Pages

1. 进入仓库设置页面
2. 点击 "Pages" 选项
3. 在 "Source" 下拉菜单中选择 "gh-pages" 分支
4. 保存设置

## 方法三：使用 GitHub CLI

如果你安装了 GitHub CLI：

```bash
# 构建示例
pnpm run build-examples

# 部署到 GitHub Pages
gh-pages -d packages/troika-examples/dist
```

## 注意事项

- 确保所有依赖的资源文件（如图片、JSON 文件等）都被正确复制
- 如果示例使用了相对路径，确保路径在 GitHub Pages 上正确
- 首次部署可能需要几分钟时间
- GitHub Pages 使用 HTTPS，确保所有资源都通过 HTTPS 加载

## 故障排除

### 示例无法加载

1. 检查浏览器控制台是否有错误
2. 确认所有文件路径正确
3. 检查 GitHub Pages 设置是否正确

### 资源文件缺失

确保在部署脚本中包含了所有必要的资源文件：
- `globe/` 目录（包含纹理图片）
- `shader-anim/` 目录（包含纹理图片）
- `globe-connections/` 目录（包含 JSON 数据）

### 构建失败

1. 确保所有依赖已安装：`pnpm install`
2. 确保所有包已构建：`pnpm run build`
3. 检查构建日志中的错误信息

