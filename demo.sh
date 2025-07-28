#!/bin/zsh

# API供应商环境切换工具演示脚本

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== API供应商环境切换工具 v2.0 演示 ===${NC}"
echo ""

echo -e "${YELLOW}1. 显示所有可用供应商${NC}"
./ai-env-manager --list
echo ""

echo -e "${YELLOW}2. 切换到OpenAI供应商（包含模型配置）${NC}"
echo "运行: source ./ai-env-manager openai-official"
source ./ai-env-manager openai-official
echo ""

echo -e "${YELLOW}3. 查看当前环境变量${NC}"
echo "OPENAI_API_KEY: ${OPENAI_API_KEY:+已设置}"
echo "OPENAI_BASE_URL: $OPENAI_BASE_URL"
echo "OPENAI_MODEL: $OPENAI_MODEL"
echo "ANTHROPIC_AUTH_TOKEN: ${ANTHROPIC_AUTH_TOKEN:-未设置}"
echo "ANTHROPIC_BASE_URL: ${ANTHROPIC_BASE_URL:-未设置}"
echo ""

echo -e "${YELLOW}4. 切换到Claude供应商${NC}"
echo "运行: source ./ai-env-manager claude-official"
source ./ai-env-manager claude-official
echo ""

echo -e "${YELLOW}5. 查看环境变量变化${NC}"
echo "OPENAI_API_KEY: ${OPENAI_API_KEY:-未设置}"
echo "OPENAI_BASE_URL: ${OPENAI_BASE_URL:-未设置}"
echo "OPENAI_MODEL: ${OPENAI_MODEL:-未设置}"
echo "ANTHROPIC_AUTH_TOKEN: ${ANTHROPIC_AUTH_TOKEN:+已设置}"
echo "ANTHROPIC_BASE_URL: $ANTHROPIC_BASE_URL"
echo ""

echo -e "${YELLOW}6. 显示当前状态${NC}"
./ai-env-manager --status
echo ""

echo -e "${YELLOW}7. 切换到DeepSeek（带模型）${NC}"
echo "运行: source ./ai-env-manager deepseek"
source ./ai-env-manager deepseek
echo ""

echo -e "${YELLOW}8. 最终状态检查${NC}"
./ai-env-manager --status
echo ""

echo -e "${GREEN}🎉 演示完成！${NC}"
echo -e "${GREEN}主要特性：${NC}"
echo -e "  ✓ 支持OpenAI和Claude API"
echo -e "  ✓ OpenAI模型配置支持"
echo -e "  ✓ 正确的环境变量命名"
echo -e "  ✓ 自动冲突清理"
echo -e "  ✓ 配置文件驱动"
echo -e "  ✓ 向后兼容"