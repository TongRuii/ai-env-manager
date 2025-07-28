#!/bin/zsh

# Git提交脚本

git commit -m "feat: AI环境管理器 v2.0 - 专业版API供应商环境切换工具

主要功能:
- 重命名为更专业的名称: ai-env-manager
- 支持配置文件驱动的供应商管理
- 支持OpenAI和Claude API
- 支持OpenAI模型配置 (OPENAI_MODEL)
- 使用标准环境变量命名:
  - OpenAI: OPENAI_API_KEY, OPENAI_BASE_URL, OPENAI_MODEL
  - Claude: ANTHROPIC_AUTH_TOKEN, ANTHROPIC_BASE_URL
- 环境变量冲突自动清理
- 配置验证和错误处理
- 状态查询和供应商列表
- 安全的API密钥处理
- 完全向后兼容原始脚本
- 性能优化和缓存
- 完整的测试套件 (17个单元测试 + 端到端测试)
- 详细的文档和迁移指南

文件结构:
- ai-env-manager: 主脚本 (重命名自 switch_api_env.sh)
- vendors.conf: 配置文件
- README.md: 使用文档
- MIGRATION.md: 迁移指南
- test_switch_api_env.sh: 单元测试
- test_e2e.sh: 端到端测试
- demo.sh: 功能演示
- switch_openai_env.sh: 原始脚本 (保留用于参考)"