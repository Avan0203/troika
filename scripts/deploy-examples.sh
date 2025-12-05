#!/bin/bash

# 部署示例到 GitHub Pages 的脚本
# 使用方法: ./scripts/deploy-examples.sh

set -e

echo "🚀 开始构建示例项目..."

# 确保在项目根目录
cd "$(dirname "$0")/.."

# 构建所有包
echo "📦 构建所有包..."
pnpm run build

# 构建示例
echo "🎨 构建示例..."
pnpm run build-examples

# 创建部署目录
DEPLOY_DIR="gh-pages-examples"
rm -rf $DEPLOY_DIR
mkdir -p $DEPLOY_DIR

# 复制必要文件
echo "📋 复制文件..."
cp packages/troika-examples/index.html $DEPLOY_DIR/
cp packages/troika-examples/index.css $DEPLOY_DIR/
cp -r packages/troika-examples/dist $DEPLOY_DIR/
cp packages/troika-examples/GitHub-Mark-64px.png $DEPLOY_DIR/ 2>/dev/null || true

# 复制示例需要的资源文件
cp -r packages/troika-examples/globe $DEPLOY_DIR/ 2>/dev/null || true
cp -r packages/troika-examples/shader-anim $DEPLOY_DIR/ 2>/dev/null || true
cp -r packages/troika-examples/globe-connections $DEPLOY_DIR/ 2>/dev/null || true

echo "✅ 构建完成！文件已准备在 $DEPLOY_DIR 目录中"
echo ""
echo "📝 下一步："
echo "1. 如果使用 gh-pages 分支部署："
echo "   git checkout --orphan gh-pages"
echo "   git rm -rf ."
echo "   cp -r $DEPLOY_DIR/* ."
echo "   git add ."
echo "   git commit -m 'Deploy examples to GitHub Pages'"
echo "   git push origin gh-pages"
echo ""
echo "2. 如果使用 GitHub Actions 自动部署，直接推送代码即可"

