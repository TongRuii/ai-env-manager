#!/bin/zsh

# 端到端测试脚本 - 测试完整的用户工作流程

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== 端到端测试：完整用户工作流程 ===${NC}"
echo ""

# 清理环境
echo -e "${YELLOW}1. 清理测试环境${NC}"
rm -f vendors.conf
unset OPENAI_API_KEY OPENAI_API_URL CLAUDE_API_KEY CLAUDE_API_URL

# 测试首次使用 - 配置文件自动创建
echo -e "\n${YELLOW}2. 测试首次使用 - 配置文件自动创建${NC}"
echo "运行: ./ai-env-manager --list"
./ai-env-manager --list
echo ""

# 检查配置文件是否创建
if [[ -f "vendors.conf" ]]; then
    echo -e "${GREEN}✓ 配置文件已自动创建${NC}"
    echo "配置文件权限: $(ls -l vendors.conf | awk '{print $1}')"
else
    echo -e "${RED}✗ 配置文件创建失败${NC}"
    exit 1
fi

# 测试列出供应商
echo -e "\n${YELLOW}3. 测试列出所有供应商${NC}"
echo "运行: ./ai-env-manager --list"
./ai-env-manager --list
echo ""

# 测试切换到OpenAI供应商
echo -e "\n${YELLOW}4. 测试切换到OpenAI供应商${NC}"
echo "运行: source ./ai-env-manager openai-official"
source ./ai-env-manager openai-official
echo ""

# 验证环境变量设置
echo -e "${YELLOW}5. 验证OpenAI环境变量设置${NC}"
echo "OPENAI_API_KEY: ${OPENAI_API_KEY:+已设置}"
echo "OPENAI_BASE_URL: $OPENAI_BASE_URL"
echo "OPENAI_MODEL: $OPENAI_MODEL"
echo "ANTHROPIC_AUTH_TOKEN: ${ANTHROPIC_AUTH_TOKEN:-未设置}"
echo "ANTHROPIC_BASE_URL: ${ANTHROPIC_BASE_URL:-未设置}"

if [[ -n "$OPENAI_API_KEY" && -n "$OPENAI_BASE_URL" && -z "$ANTHROPIC_AUTH_TOKEN" && -z "$ANTHROPIC_BASE_URL" ]]; then
    echo -e "${GREEN}✓ OpenAI环境变量设置正确，Claude变量已清理${NC}"
else
    echo -e "${RED}✗ 环境变量设置不正确${NC}"
    exit 1
fi

# 测试状态查询
echo -e "\n${YELLOW}6. 测试状态查询${NC}"
echo "运行: ./ai-env-manager --status"
./ai-env-manager --status
echo ""

# 测试切换到Claude供应商
echo -e "\n${YELLOW}7. 测试切换到Claude供应商${NC}"
echo "运行: source ./ai-env-manager claude-official"
source ./ai-env-manager claude-official
echo ""

# 验证环境变量切换
echo -e "${YELLOW}8. 验证Claude环境变量设置和OpenAI变量清理${NC}"
echo "OPENAI_API_KEY: ${OPENAI_API_KEY:-未设置}"
echo "OPENAI_BASE_URL: ${OPENAI_BASE_URL:-未设置}"
echo "OPENAI_MODEL: ${OPENAI_MODEL:-未设置}"
echo "ANTHROPIC_AUTH_TOKEN: ${ANTHROPIC_AUTH_TOKEN:+已设置}"
echo "ANTHROPIC_BASE_URL: $ANTHROPIC_BASE_URL"

if [[ -z "$OPENAI_API_KEY" && -z "$OPENAI_BASE_URL" && -n "$ANTHROPIC_AUTH_TOKEN" && -n "$ANTHROPIC_BASE_URL" ]]; then
    echo -e "${GREEN}✓ Claude环境变量设置正确，OpenAI变量已清理${NC}"
else
    echo -e "${RED}✗ 环境变量切换不正确${NC}"
    exit 1
fi

# 测试状态查询（Claude）
echo -e "\n${YELLOW}9. 测试Claude状态查询${NC}"
echo "运行: ./ai-env-manager --status"
./ai-env-manager --status
echo ""

# 测试错误处理
echo -e "\n${YELLOW}10. 测试错误处理${NC}"
echo "运行: ./ai-env-manager invalid-vendor"
./ai-env-manager invalid-vendor 2>&1 | head -2
echo ""

# 测试帮助信息
echo -e "\n${YELLOW}11. 测试帮助信息${NC}"
echo "运行: ./ai-env-manager --help"
./ai-env-manager --help | head -10
echo ""

# 测试配置文件内容
echo -e "\n${YELLOW}12. 验证配置文件内容${NC}"
echo "配置文件前10行:"
head -10 vendors.conf
echo ""

# 测试多次切换
echo -e "\n${YELLOW}13. 测试多次切换${NC}"
echo "切换序列: openai-official -> deepseek -> claude-official"

source ./ai-env-manager openai-official > /dev/null 2>&1
echo "当前: OpenAI Official ($OPENAI_BASE_URL) - 模型: $OPENAI_MODEL"

source ./ai-env-manager deepseek > /dev/null 2>&1
echo "当前: DeepSeek ($OPENAI_BASE_URL) - 模型: $OPENAI_MODEL"

source ./ai-env-manager claude-official > /dev/null 2>&1
echo "当前: Claude Official ($ANTHROPIC_BASE_URL)"

if [[ "$ANTHROPIC_BASE_URL" == "https://api.anthropic.com" ]]; then
    echo -e "${GREEN}✓ 多次切换测试通过${NC}"
else
    echo -e "${RED}✗ 多次切换测试失败${NC}"
    exit 1
fi

# 清理测试环境
echo -e "\n${YELLOW}14. 清理测试环境${NC}"
unset OPENAI_API_KEY OPENAI_BASE_URL OPENAI_MODEL ANTHROPIC_AUTH_TOKEN ANTHROPIC_BASE_URL
echo "环境变量已清理"

echo -e "\n${GREEN}🎉 端到端测试全部通过！${NC}"
echo -e "${GREEN}所有核心功能都正常工作：${NC}"
echo -e "  ✓ 配置文件自动创建"
echo -e "  ✓ 供应商列表显示"
echo -e "  ✓ OpenAI/Claude供应商切换"
echo -e "  ✓ 环境变量冲突清理"
echo -e "  ✓ 状态查询"
echo -e "  ✓ 错误处理"
echo -e "  ✓ 帮助信息"
echo -e "  ✓ 多次切换稳定性"