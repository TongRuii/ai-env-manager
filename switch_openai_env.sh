#!/bin/zsh

# 定义一个函数，用于加载环境变量
load_env() {
  case $1 in
    vendor1)
      export OPENAI_API_KEY="your_vendor1_api_key"
      export OPENAI_API_URL="https://api.vendor1.com"
      ;;
    vendor2)
      export OPENAI_API_KEY="your_vendor2_api_key"
      export OPENAI_API_URL="https://api.vendor2.com"
      ;;
    vendor3)
      export OPENAI_API_KEY="your_vendor3_api_key"
      export OPENAI_API_URL="https://api.vendor3.com"
      ;;
    claude1)
      export CLAUDE_API_KEY="your_claude1_api_key"
      export CLAUDE_API_URL="https://api.claude1.com"
      ;;
    claude2)
      export CLAUDE_API_KEY="your_claude2_api_key"
      export CLAUDE_API_URL="https://api.claude2.com"
      ;;
    *)
      echo "未知的厂商: $1"
      return 1
      ;;
  esac

  echo "已切换到 $1 的环境变量配置"
  return 0
}

# 检查是否提供了厂商参数
if [ $# -eq 0 ]; then
  echo "用法: $0 <厂商名称>"
  echo "可用厂商: vendor1, vendor2, vendor3, claude1, claude2"
  exit 1
fi

# 调用函数加载环境变量
load_env $1
