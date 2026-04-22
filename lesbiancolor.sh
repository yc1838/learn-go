# ==========================================
# Shell字体女同性恋旗帜配色方案
# Lesbian Flag Shell Colors
# ==========================================
# 使用 24-bit (RGB) 真色彩
# Utilizes 24-bit (RGB) true colors
# 颜色顺序：深红橙 -> 浅橙 -> 白 -> 淡粉 -> 暗紫 -> 淡紫(输入)
# Color order: dark red-orange -> light orange -> white -> light pink -> dark purple -> light purple (input)
# ==========================================
# 把以下内容添加到zsh配置文件（一般来说是 ~/.zshrc）中
# Add the following content to the zsh configuration file (usually ~/.zshrc)
# 然后运行 'source ~/.zshrc' 来应用更改
# Then run 'source ~/.zshrc' to apply the changes


PROMPT="%F{#D84B20}➜ %F{#EF7627}lilith%F{#FFFFFF}@%F{#D162A4}%1~ %F{#A30262}$ %F{#C197D2}"


# 在敲下回车键执行命令的瞬间，重置颜色，防止污染外部程序的输出
# Resets colors the instant the return key is pressed to prevent polluting external program output
preexec() {
  print -rn -- $'\e[0m'
}

# ==========================================
# 彩虹打字机 (Rainbow Typewriter) 功能
# ==========================================

# 默认状态为 off (使用默认的淡紫色)
export RAINBOW_TYPING="off"

# 定义颜色库：LGBT (6色) + Trans (3色)
typeset -a rainbow_colors
rainbow_colors=(
  "#FF8A8A" # Pastel 红 (柔和红)
  "#FFB37C" # Pastel 橙 (柔和橙)
  "#FFE599" # Pastel 黄 (柔和黄)
  "#A2E4B8" # Pastel 绿 (柔和绿)
  "#9BC1FF" # Pastel 蓝 (柔和蓝)
  "#D0B0FF" # Pastel 紫 (柔和紫)
  "#5BCEFA" # Trans 浅蓝
  "#F5A9B8" # Trans 浅粉
  "#FFFFFF" # Trans 白
)

rainbow_typewriter() {
  if [[ "$RAINBOW_TYPING" != "on" ]]; then
    # 如果没开，则清空我们自己加的高亮，使用终端默认（也就是 Prompt 结尾留下的淡紫色）
    region_highlight=()
    return
  fi

  local len=${#BUFFER}
  region_highlight=()
  
  if (( len == 0 )); then
    return
  fi

  local i
  local word_count=0
  local in_word=0

  for (( i=0; i < len; i++ )); do
    # 提取当前字符
    local char="${BUFFER:$i:1}"
    
    # 如果是空格或制表符，标记不在单词内，并且跳过着色
    if [[ "$char" == " " || "$char" == $'\t' ]]; then
      in_word=0
      continue
    fi

    # 如果刚才不在单词内，现在遇到了可见字符，说明进入了一个新单词
    if (( in_word == 0 )); then
      in_word=1
      ((word_count++))
    fi

    # 根据单词的数量来计算颜色索引
    local color_idx=$(( ((word_count - 1) % 9) + 1 ))
    local c=${rainbow_colors[$color_idx]}
    region_highlight+=("$i $((i+1)) fg=$c")
  done
}

# 注册 Zsh 的实时重绘 Hook，每次按键都会触发
autoload -Uz add-zle-hook-widget
zle -N rainbow_typewriter
add-zle-hook-widget line-pre-redraw rainbow_typewriter

# 提供开启/关闭的快捷命令
alias rainbow-on='export RAINBOW_TYPING="on"'
alias rainbow-off='export RAINBOW_TYPING="off"'