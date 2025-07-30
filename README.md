# API供应商环境切换工具 v2.0

这个工具可以帮助开发者快速切换不同的AI API供应商配置，支持OpenAI和Claude API。**v2.0 新增多API并存功能**，支持同时配置多个API环境。

## 功能特性

- 🔄 快速切换不同API供应商
- 🤝 **多API并存**：OpenAI和Claude API可以同时配置
- 📝 配置文件驱动，易于管理
- 🔒 安全的API密钥处理
- ✅ 配置验证和错误处理
- 📊 状态查询和供应商列表
- 🛡️ 环境变量冲突自动清理
- 🔙 完全向后兼容
- ⚡ 性能优化和缓存
- 🧪 完整的测试套件

## 安装和配置

1. 确保脚本有执行权限：
```bash
chmod +x ai-env-manager
```

2. 编辑 `vendors.conf` 文件，添加你的API供应商配置：
```bash
[your-vendor]
type=openai
api_key=your_actual_api_key
api_url=https://api.your-vendor.com
```

## 使用方法

### 传统模式（单API切换）
```bash
./ai-env-manager openai-official
./ai-env-manager claude-official
```

### 🆕 多API并存模式
```bash
# 设置第一个API
source ./ai-env-manager deepseek

# 添加第二个API（不会清除第一个）
source ./ai-env-manager --add-only claude-official

# 查看两个API都已配置
./ai-env-manager --status
```

### 查看当前状态
```bash
./ai-env-manager --status
```

### 列出所有可用供应商
```bash
./ai-env-manager --list
```

### 验证API环境配置
```bash
./ai-env-manager --validate
```

### 显示帮助信息
```bash
./ai-env-manager --help
```

### 显示版本信息
```bash
./ai-env-manager --version
```

## 配置文件格式

`vendors.conf` 文件使用简单的INI格式：

```ini
[供应商名称]
type=openai|claude
api_key=你的API密钥
api_url=API基础URL
model=模型名称 (可选，仅OpenAI类型)
```

### 支持的供应商类型

- `openai`: 设置 `OPENAI_API_KEY`、`OPENAI_BASE_URL` 和 `OPENAI_MODEL` 环境变量
- `claude`: 设置 `ANTHROPIC_AUTH_TOKEN` 和 `ANTHROPIC_BASE_URL` 环境变量

## 🆕 多API并存特性

### 环境变量管理
v2.0版本支持OpenAI和Claude API环境变量同时设置，互不冲突：

```bash
# 同时使用两个API
echo $OPENAI_API_KEY        # 已设置
echo $ANTHROPIC_AUTH_TOKEN  # 也已设置
```

### 使用场景
- **开发环境**：同时测试不同API的响应
- **应用集成**：在同一应用中使用多个AI服务
- **成本优化**：根据任务类型选择不同的API
- **备份方案**：主API不可用时快速切换

### 状态显示
```bash
$ ./ai-env-manager --status
当前API环境状态：

  ● OpenAI: 已配置
    Base URL: https://api.deepseek.com
    API Key: 已设置 (***隐藏***)
    模型: deepseek-chat

  ● Claude: 已配置
    Base URL: https://api.anthropic.com
    Auth Token: 已设置 (***隐藏***)

✓ 两个API都已配置，可以同时使用
```

## 环境变量

### OpenAI供应商
- `OPENAI_API_KEY`: OpenAI API密钥
- `OPENAI_BASE_URL`: OpenAI API基础URL
- `OPENAI_MODEL`: OpenAI模型名称（可选）

### Claude供应商
- `ANTHROPIC_AUTH_TOKEN`: Claude API认证令牌
- `ANTHROPIC_BASE_URL`: Claude API基础URL

## 安全注意事项

- API密钥不会在终端输出中显示
- 配置文件应设置适当的文件权限
- 切换供应商时会自动清理冲突的环境变量

## 故障排除

### 常见问题

1. **配置文件不存在**
   - 脚本会自动创建模板配置文件

2. **供应商名称无效**
   - 使用 `--list` 查看可用供应商

3. **URL格式错误**
   - 确保URL以 `http://` 或 `https://` 开头

4. **权限问题**
   - 确保脚本和配置文件有适当的读写权限
#
# 向后兼容性

新版本完全兼容原始的 `switch_openai_env.sh` 脚本：

```bash
# 这些命令仍然有效
source ./ai-env-manager vendor1
source ./ai-env-manager vendor2
source ./ai-env-manager claude1
```

## 性能优化

- 配置文件解析缓存
- 高效的环境变量管理
- 最小化外部命令调用

## 调试模式

启用调试模式查看详细信息：
```bash
DEBUG=1 ./ai-env-manager vendor1
```

## 测试

运行测试套件：
```bash
# 单元测试
./test_switch_api_env.sh

# 端到端测试
./test_e2e.sh
```

## 迁移指南

查看 [MIGRATION.md](MIGRATION.md) 了解如何从旧版本迁移。

## 文件结构

```
.
├── ai-env-manager             # 主脚本
├── vendors.conf               # 配置文件（自动生成）
├── README.md                  # 使用文档
├── MIGRATION.md               # 迁移指南
├── test_switch_api_env.sh     # 单元测试
└── test_e2e.sh               # 端到端测试
```