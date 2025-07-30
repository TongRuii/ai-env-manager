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

## 部署方案

### 系统级部署

#### 1. 全局安装部署

将工具部署到系统路径，供所有用户使用：

```bash
# 1. 复制脚本到系统路径
sudo cp ai-env-manager /usr/local/bin/
sudo chmod +x /usr/local/bin/ai-env-manager

# 2. 创建全局配置目录
sudo mkdir -p /etc/ai-env-manager
sudo cp vendors.conf /etc/ai-env-manager/

# 3. 设置权限
sudo chmod 600 /etc/ai-env-manager/vendors.conf  # 保护敏感信息
sudo chmod 755 /etc/ai-env-manager/               # 配置目录权限
```

**使用方式**：
```bash
# 全局使用
ai-env-manager --list
ai-env-manager openai-official
```

#### 2. 用户级部署

为单个用户安装，避免使用sudo权限：

```bash
# 1. 创建用户bin目录
mkdir -p ~/bin

# 2. 复制脚本
cp ai-env-manager ~/bin/
chmod +x ~/bin/ai-env-manager

# 3. 添加到PATH（如果还没有）
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

# 4. 创建用户配置目录
mkdir -p ~/.config/ai-env-manager
cp vendors.conf ~/.config/ai-env-manager/
chmod 600 ~/.config/ai-env-manager/vendors.conf
```

### 开发环境部署

#### 1. 项目级部署

集成到开发项目中，通过版本控制管理：

```bash
# 1. 添加到项目根目录
cp ai-env-manager ./project-root/
cp vendors.conf ./project-root/

# 2. 添加到.gitignore（保护敏感信息）
echo "vendors.conf" >> .gitignore
echo "*.key" >> .gitignore
echo "*.secret" >> .gitignore

# 3. 创建模板配置文件
cp vendors.conf vendors.conf.template
git add vendors.conf.template
```

**项目结构**：
```
project-root/
├── ai-env-manager           # 环境管理工具
├── vendors.conf            # 实际配置（不提交）
├── vendors.conf.template   # 配置模板（提交）
├── .env.example           # 环境变量示例
└── .gitignore             # Git忽略规则
```

#### 2. Docker容器部署

在Docker容器中使用环境管理：

```dockerfile
# Dockerfile
FROM ubuntu:22.04

# 安装必要工具
RUN apt-get update && apt-get install -y \
    zsh \
    curl \
    wget \
    && rm -rf /var/lib/apt/lists/*

# 复制环境管理工具
COPY ai-env-manager /usr/local/bin/
RUN chmod +x /usr/local/bin/ai-env-manager

# 创建配置目录
RUN mkdir -p /etc/ai-env-manager

# 设置工作目录
WORKDIR /app

# 复制配置模板
COPY vendors.conf.template /etc/ai-env-manager/
```

**docker-compose.yml**：
```yaml
version: '3.8'
services:
  ai-app:
    build: .
    volumes:
      - ./vendors.conf:/etc/ai-env-manager/vendors.conf:ro
    environment:
      - CONFIG_PATH=/etc/ai-env-manager/vendors.conf
    command: ["/bin/zsh"]
```

### 自动化部署

#### 1. 脚本自动化部署

使用提供的部署脚本进行自动化安装：

```bash
# 运行部署脚本
./deploy.sh

# 或者指定安装类型
./deploy.sh --user      # 用户级安装
./deploy.sh --system    # 系统级安装
./deploy.sh --project   # 项目级安装
```

#### 2. CI/CD集成

在持续集成流程中使用：

```yaml
# .github/workflows/ci.yml
name: CI
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup AI Environment
        run: |
          source ./ai-env-manager test-vendor
          ./ai-env-manager --validate
      
      - name: Run Tests
        run: |
          ./test_switch_api_env.sh
          ./test_e2e.sh
```

### 云服务部署

#### 1. AWS部署

在AWS EC2实例上部署：

```bash
# 1. 连接到EC2实例
ssh -i your-key.pem ec2-user@your-instance

# 2. 下载并安装工具
wget https://raw.githubusercontent.com/your-repo/ai-env-manager/main/ai-env-manager
chmod +x ai-env-manager
sudo mv ai-env-manager /usr/local/bin/

# 3. 使用AWS Secrets Manager管理API密钥
aws secretsmanager get-secret-value --secret-id ai-api-keys --query SecretString --output text > /tmp/secrets.json
```

#### 2. Kubernetes部署

在Kubernetes集群中使用：

```yaml
# configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: ai-env-config
data:
  vendors.conf.template: |
    [test-vendor]
    type=openai
    api_key=${API_KEY}
    api_url=${API_URL}
    model=gpt-3.5-turbo
---
apiVersion: v1
kind: Secret
metadata:
  name: ai-api-secrets
type: Opaque
data:
  api-key: eW91ci1hY3R1YWwtYXBpLWtleQ==
```

### 配置管理策略

#### 1. 环境隔离

为不同环境创建独立的配置：

```bash
# 开发环境
vendors.dev.conf
./ai-env-manager --config vendors.dev.conf dev-openai

# 测试环境
vendors.test.conf
./ai-env-manager --config vendors.test.conf test-openai

# 生产环境
vendors.prod.conf
./ai-env-manager --config vendors.prod.conf prod-openai
```

#### 2. 配置版本控制

使用Git管理配置变更：

```bash
# 创建配置分支
git checkout -b config/v2.0

# 添加配置文件
git add vendors.conf.template
git commit -m "Add vendor configuration template"

# 标记版本
git tag config-v2.0
```

### 监控和日志

#### 1. 使用日志

启用日志记录环境切换：

```bash
# 设置日志文件
export AI_ENV_LOG_FILE="/var/log/ai-env-manager.log"
export AI_ENV_LOG_LEVEL="INFO"

# 使用工具
./ai-env-manager production-vendor
```

#### 2. 监控脚本

创建监控脚本检查API状态：

```bash
#!/bin/bash
# monitor.sh - 监控API环境状态

LOG_FILE="/var/log/ai-env-monitor.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

echo "[$TIMESTAMP] Checking API environment status..." >> $LOG_FILE

# 检查环境变量
if [ -n "$OPENAI_API_KEY" ]; then
    echo "[$TIMESTAMP] OpenAI API: Configured" >> $LOG_FILE
else
    echo "[$TIMESTAMP] OpenAI API: Not configured" >> $LOG_FILE
fi

if [ -n "$ANTHROPIC_AUTH_TOKEN" ]; then
    echo "[$TIMESTAMP] Claude API: Configured" >> $LOG_FILE
else
    echo "[$TIMESTAMP] Claude API: Not configured" >> $LOG_FILE
fi
```

### 安全最佳实践

#### 1. 权限管理

```bash
# 限制配置文件权限
chmod 600 vendors.conf

# 设置脚本执行权限
chmod 700 ai-env-manager

# 使用ACL控制访问
setfacl -m u:www-data:r vendors.conf
```

#### 2. 密钥轮换

定期更新API密钥：

```bash
#!/bin/bash
# rotate-keys.sh - API密钥轮换脚本

# 备份当前配置
cp vendors.conf vendors.conf.backup.$(date +%Y%m%d)

# 生成新密钥（示例）
NEW_KEY=$(openssl rand -hex 32)

# 更新配置文件
sed -i "s/api_key=.*/api_key=$NEW_KEY/" vendors.conf

echo "API密钥已更新: $(date)"
```

### 备份和恢复

#### 1. 配置备份

```bash
#!/bin/bash
# backup-config.sh - 配置备份脚本

BACKUP_DIR="/backups/ai-env-manager"
DATE=$(date +%Y%m%d_%H%M%S)

mkdir -p $BACKUP_DIR

# 备份配置文件
cp vendors.conf $BACKUP_DIR/vendors.conf.$DATE

# 备份脚本
cp ai-env-manager $BACKUP_DIR/ai-env-manager.$DATE

# 创建压缩包
tar -czf $BACKUP_DIR/backup_$DATE.tar.gz -C $BACKUP_DIR vendors.conf.$DATE ai-env-manager.$DATE

# 清理临时文件
rm $BACKUP_DIR/vendors.conf.$DATE $BACKUP_DIR/ai-env-manager.$DATE

echo "备份完成: $BACKUP_DIR/backup_$DATE.tar.gz"
```

#### 2. 灾难恢复

```bash
#!/bin/bash
# restore-config.sh - 灾难恢复脚本

BACKUP_FILE=$1
RESTORE_DIR="/tmp/restore"

if [ -z "$BACKUP_FILE" ]; then
    echo "使用方法: $0 <backup_file>"
    exit 1
fi

# 创建恢复目录
mkdir -p $RESTORE_DIR

# 解压备份文件
tar -xzf $BACKUP_FILE -C $RESTORE_DIR

# 恢复配置文件
cp $RESTORE_DIR/vendors.conf.* ./vendors.conf
cp $RESTORE_DIR/ai-env-manager.* ./ai-env-manager

# 设置权限
chmod 600 vendors.conf
chmod +x ai-env-manager

# 清理临时文件
rm -rf $RESTORE_DIR

echo "恢复完成"
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
├── test_e2e.sh               # 端到端测试
├── demo.sh                   # 演示脚本
├── git_commit.sh             # Git提交脚本
└── deploy.sh                 # 部署脚本（建议创建）
```

## 快速开始

### 1. 克隆或下载项目

```bash
# 克隆项目
git clone <repository-url>
cd ai-env-manager

# 或直接下载文件
wget https://raw.githubusercontent.com/your-repo/ai-env-manager/main/ai-env-manager
wget https://raw.githubusercontent.com/your-repo/ai-env-manager/main/vendors.conf
```

### 2. 基本配置

```bash
# 设置执行权限
chmod +x ai-env-manager

# 编辑配置文件
nano vendors.conf
```

### 3. 验证安装

```bash
# 列出可用供应商
./ai-env-manager --list

# 检查状态
./ai-env-manager --status
```

## 贡献指南

欢迎提交问题报告和功能请求！

### 开发流程

1. Fork 项目
2. 创建功能分支：`git checkout -b feature/new-feature`
3. 提交更改：`git commit -am 'Add new feature'`
4. 推送到分支：`git push origin feature/new-feature`
5. 提交 Pull Request

### 代码规范

- 使用 4 空格缩进
- 添加适当的注释
- 确保脚本兼容 bash 和 zsh
- 遵循现有的代码风格

## 许可证

本项目采用 MIT 许可证。详见 [LICENSE](LICENSE) 文件。

## 更新日志

### v2.0.0 (2024-01-XX)
- ✨ 新增多API并存功能
- 🔄 支持OpenAI和Claude API同时配置
- 🛡️ 自动环境变量冲突清理
- 📊 增强的状态显示功能
- 🧪 完整的测试套件
- 📦 完善的部署方案

### v1.0.0 (2023-12-XX)
- 🎉 初始版本发布
- 🔧 基本的API供应商切换功能
- 📝 配置文件支持
- ✅ 配置验证和错误处理

## 支持

如果您遇到问题或有建议，请：

1. 查看 [故障排除](#故障排除) 部分
2. 提交 [Issue](https://github.com/your-repo/ai-env-manager/issues)
3. 查看 [Wiki](https://github.com/your-repo/ai-env-manager/wiki) 获取更多文档

## 致谢

感谢所有贡献者和用户的反馈与支持！

---

**⚠️ 安全提示**：请妥善保管您的API密钥，不要将其提交到版本控制系统或在不安全的环境中分享。