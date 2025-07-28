#!/bin/zsh

# API供应商环境切换工具测试脚本
# 测试所有功能和错误处理场景

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 测试计数器
TESTS_TOTAL=0
TESTS_PASSED=0
TESTS_FAILED=0

# 测试结果函数
test_pass() {
    ((TESTS_PASSED++))
    echo -e "${GREEN}✓ PASS${NC}: $1"
}

test_fail() {
    ((TESTS_FAILED++))
    echo -e "${RED}✗ FAIL${NC}: $1"
    echo -e "  ${YELLOW}Expected: $2${NC}"
    echo -e "  ${YELLOW}Got: $3${NC}"
}

run_test() {
    ((TESTS_TOTAL++))
    local test_name="$1"
    local expected_exit_code="$2"
    local expected_output_pattern="$3"
    shift 3
    local command=("$@")
    
    echo -e "\n${BLUE}Testing:${NC} $test_name"
    echo -e "${BLUE}Command:${NC} ${command[*]}"
    
    local output
    local exit_code
    output=$("${command[@]}" 2>&1)
    exit_code=$?
    
    # 检查退出码
    if [[ $exit_code -eq $expected_exit_code ]]; then
        # 检查输出模式
        if [[ -z "$expected_output_pattern" ]] || [[ "$output" =~ $expected_output_pattern ]]; then
            test_pass "$test_name"
        else
            test_fail "$test_name" "Output matching: $expected_output_pattern" "$output"
        fi
    else
        test_fail "$test_name" "Exit code: $expected_exit_code" "Exit code: $exit_code"
    fi
}

# 备份原始配置文件（如果存在）
backup_config() {
    if [[ -f "vendors.conf" ]]; then
        cp "vendors.conf" "vendors.conf.backup"
        echo "已备份原始配置文件"
    fi
}

# 恢复配置文件
restore_config() {
    if [[ -f "vendors.conf.backup" ]]; then
        mv "vendors.conf.backup" "vendors.conf"
        echo "已恢复原始配置文件"
    fi
}

# 创建测试配置文件
create_test_config() {
    cat > "vendors.conf" << 'EOF'
# 测试配置文件
[test-openai]
type=openai
api_key=test_openai_key
api_url=https://api.openai.com

[test-claude]
type=claude
api_key=test_claude_key
api_url=https://api.anthropic.com

[test-invalid-type]
type=invalid
api_key=test_key
api_url=https://test.com

[test-missing-key]
type=openai
api_url=https://test.com

[test-invalid-url]
type=openai
api_key=test_key
api_url=invalid-url

[test-placeholder]
type=openai
api_key=your_test_api_key
api_url=https://test.com
model=gpt-3.5-turbo

[test-openai-with-model]
type=openai
api_key=test_key
api_url=https://test.com
model=test_model
EOF
}

# 开始测试
echo -e "${BLUE}=== API供应商环境切换工具测试套件 ===${NC}"
echo ""

# 备份配置
backup_config

# 测试1: 帮助信息
run_test "显示帮助信息" 0 "API供应商环境切换工具" ./ai-env-manager --help

# 测试2: 短参数帮助
run_test "短参数帮助" 0 "API供应商环境切换工具" ./ai-env-manager -h

# 测试3: 无参数显示帮助
run_test "无参数显示帮助" 1 "用法:" ./ai-env-manager

# 测试4: 配置文件自动创建
rm -f vendors.conf
run_test "配置文件自动创建" 0 "已创建配置文件模板" ./ai-env-manager test-vendor

# 测试5: 创建测试配置并测试列表功能
create_test_config
run_test "列出供应商" 0 "可用的API供应商" ./ai-env-manager --list

# 测试6: 短参数列表
run_test "短参数列表" 0 "test-openai.*OpenAI" ./ai-env-manager -l

# 测试7: 有效的OpenAI供应商切换
run_test "切换到OpenAI供应商" 0 "已切换到 OpenAI 供应商: test-openai" ./ai-env-manager test-openai

# 测试8: 有效的Claude供应商切换
run_test "切换到Claude供应商" 0 "已切换到 Claude 供应商: test-claude" ./ai-env-manager test-claude

# 测试9: 无效供应商名称
run_test "无效供应商名称" 1 "未知的供应商" ./ai-env-manager nonexistent-vendor

# 测试10: 无效供应商类型
run_test "无效供应商类型" 1 "type 字段无效" ./ai-env-manager test-invalid-type

# 测试11: 缺少API key
run_test "缺少API key" 1 "缺少 api_key 字段" ./ai-env-manager test-missing-key

# 测试12: 无效URL格式
run_test "无效URL格式" 1 "api_url 格式无效" ./ai-env-manager test-invalid-url

# 测试13: 占位符API key警告
run_test "占位符API key警告" 0 "使用了占位符 API key" ./ai-env-manager test-placeholder

# 测试14: 状态查询（需要先设置环境）
source ./ai-env-manager test-openai > /dev/null 2>&1
run_test "状态查询" 0 "当前API环境状态" ./ai-env-manager --status

# 测试15: 短参数状态查询
run_test "短参数状态查询" 0 "类型.*OpenAI" ./ai-env-manager -s

# 测试16: OpenAI模型配置
run_test "OpenAI模型配置" 0 "模型.*test_model" ./ai-env-manager test-openai-with-model

# 测试17: Claude环境变量
source ./ai-env-manager test-claude > /dev/null 2>&1
run_test "Claude环境变量" 0 "ANTHROPIC_AUTH_TOKEN.*已设置" ./ai-env-manager --status

# 恢复配置
restore_config

# 显示测试结果
echo ""
echo -e "${BLUE}=== 测试结果汇总 ===${NC}"
echo -e "总测试数: $TESTS_TOTAL"
echo -e "${GREEN}通过: $TESTS_PASSED${NC}"
echo -e "${RED}失败: $TESTS_FAILED${NC}"

if [[ $TESTS_FAILED -eq 0 ]]; then
    echo -e "\n${GREEN}🎉 所有测试通过！${NC}"
    exit 0
else
    echo -e "\n${RED}❌ 有 $TESTS_FAILED 个测试失败${NC}"
    exit 1
fi