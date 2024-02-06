#!/bin/sh

# 待执行的命令
# command="ll"
# command='echo "This is a stdout output" >&1'
command='echo "This is a stderr output" >&2'

# 创建临时文件
stdout_file=$(mktemp)
stderr_file=$(mktemp)

# 执行 shell 命令，并输出到临时文件中
bash -c "$command" > "$stdout_file" 2>"$stderr_file"

# 获取退出 code
exit_code=$?

# 读取标准输出
stdout=$(cat "$stdout_file")

# 读取标准错误
stderr=$(cat "$stderr_file")

# 删除临时文件
echo "rm $stdout_file $stderr_file"
rm "$stdout_file" "$stderr_file"


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

echo "stdout: $stdout"
echo "stderr: $stderr"