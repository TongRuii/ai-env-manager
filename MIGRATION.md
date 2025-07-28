# 迁移指南：从 switch_openai_env.sh 到 ai-env-manager

## 概述

新版本的 `ai-env-manager` 完全向后兼容原始的 `switch_openai_env.sh` 脚本，同时提供了更多功能。

## 主要改进

### 1. 配置文件驱动
- **旧版本**: 硬编码的供应商配置
- **新版本**: 使用 `vendors.conf` 配置文件，支持动态添加供应商

### 2. 增强的功能
- **状态查询**: `./ai-env-manager --status`
- **供应商列表**: `./ai-env-manager --list`
- **帮助信息**: `./ai-env-manager --help`
- **版本信息**: `./ai-env-manager --version`

### 3. 更好的错误处理
- 详细的错误消息和解决方案
- 配置验证
- URL格式检查

### 4. 安全改进
- API密钥在输出中隐藏
- 配置文件权限设置为600
- 环境变量冲突自动清理

## 迁移步骤

### 步骤1: 备份现有脚本
```bash
cp switch_openai_env.sh switch_openai_env.sh.backup
```

### 步骤2: 使用新脚本
```bash
# 直接使用新脚本，它会自动创建配置文件
./ai-env-manager --list
```

### 步骤3: 更新配置（可选）
编辑自动生成的 `vendors.conf` 文件，添加你的真实API密钥。

## 向后兼容性

新脚本完全兼容旧版本的用法：

```bash
# 这些命令在新版本中仍然有效
source ./ai-env-manager vendor1
source ./ai-env-manager vendor2
source ./ai-env-manager claude1
```

配置文件中已经包含了这些向后兼容的供应商别名。

## 新功能使用

### 查看所有可用供应商
```bash
./ai-env-manager --list
```

### 查看当前状态
```bash
./ai-env-manager --status
```

### 添加新供应商
编辑 `vendors.conf` 文件：
```ini
[my-new-vendor]
type=openai
api_key=your_api_key
api_url=https://api.my-vendor.com
model=gpt-4
```

然后使用：
```bash
source ./ai-env-manager my-new-vendor
```

## 故障排除

### 配置文件问题
如果配置文件损坏，删除它让脚本重新创建：
```bash
rm vendors.conf
./ai-env-manager --list
```

### 权限问题
确保脚本有执行权限：
```bash
chmod +x ai-env-manager
```

### 环境变量问题
使用状态查询检查当前环境：
```bash
./ai-env-manager --status
```

## 性能优化

新版本包含以下性能优化：
- 配置文件缓存解析
- 更高效的环境变量管理
- 减少外部命令调用

## 调试模式

启用调试模式查看详细信息：
```bash
DEBUG=1 ./ai-env-manager vendor1
```

## 测试

运行测试套件验证功能：
```bash
./test_switch_api_env.sh
./test_e2e.sh
```
## 环境变
量变更

### v2.0 环境变量更新

**OpenAI供应商环境变量变更：**
- `OPENAI_API_URL` → `OPENAI_BASE_URL`
- 新增：`OPENAI_MODEL`（可选）

**Claude供应商环境变量变更：**
- `CLAUDE_API_KEY` → `ANTHROPIC_AUTH_TOKEN`
- `CLAUDE_API_URL` → `ANTHROPIC_BASE_URL`

### 兼容性说明

新版本会自动设置正确的环境变量名称。如果你的应用程序依赖旧的环境变量名称，请更新你的代码以使用新的变量名。

### 配置文件更新

新版本支持在OpenAI供应商配置中添加 `model` 字段：

```ini
[openai-official]
type=openai
api_key=your_api_key
api_url=https://api.openai.com
model=gpt-4
```

这将自动设置 `OPENAI_MODEL` 环境变量。