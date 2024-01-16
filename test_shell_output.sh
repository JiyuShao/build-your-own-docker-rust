#!/bin/sh

# 执行 shell 命令，并输出命令的结果
bash -c "ll"

# 获取退出代码
exit_code=$?

# 根据退出代码进行错误判断
if [ $exit_code -eq 0 ]; then
  echo "命令执行成功"
else
  echo "命令执行失败，退出代码：$exit_code"
  
  # 根据具体的退出代码值进行错误处理
  if [ $exit_code -eq 1 ]; then
    echo "General Error: 1"
  elif [ $exit_code -eq 2 ]; then
    echo "Misuse of Shell Built-in: 2"
  elif [ $exit_code -eq 126 ]; then
    echo "Cannot Execute: 126"
  elif [ $exit_code -eq 127 ]; then
    echo "Command Not Found: 127"
  fi
fi