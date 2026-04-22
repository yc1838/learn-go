# ==========================================
# Pride Shell Theme (Lesbian & Trans Flag Edition)
# Open Source Version v1.0
# ==========================================

# ------------------------------------------
# 1. 用户配置区 (Configuration)
# 你可以在 ~/.zshrc 引入此文件之前覆盖这些变量
# ------------------------------------------
: ${PRIDE_THEME_MODE:="dark"} # 终端背景模式：填 "dark" 或 "light"
: ${PRIDE_THEME_USER:="%n"}   # 强制显示的名字，默认为真实系统名 %n。如果想伪装，填 "lilith"
: ${RAINBOW_TYPING:="on"}     # 彩虹打字机默认状态："on" 或 "off"
: ${PRIDE_INPUT_COLOR:="purple"} # 彩虹关闭时的打字颜色："purple" 或 "default"

# ------------------------------------------
# 2. 动态色板定义 (Palette Definition)
# ------------------------------------------
typeset -A theme_colors
if [[ "$PRIDE_THEME_MODE" == "light" ]]; then
  # Light Theme (适合白色/浅色背景，采用莫兰迪/高对比度深色系)
  theme_colors=(
    [arrow]="#C93B4E" [user]="#D9772B" [at]="#888888" [dir]="#A0507B" [dollar]="#8B5099" [input]="#8E6A9E"
    [rainbow_1]="#C93B4E" [rainbow_2]="#D9772B" [rainbow_3]="#B59914" 
    [rainbow_4]="#3A965E" [rainbow_5]="#3465A4" [rainbow_6]="#8B5099"
    [trans_1]="#3D99C8" [trans_2]="#D47087" [trans_3]="#888888"
  )
else
  # Dark Theme (适合黑色/深色背景，采用你最喜欢的粉彩马卡龙色系)
  theme_colors=(
    [arrow]="#D84B20" [user]="#EF7627" [at]="#FFFFFF" [dir]="#D162A4" [dollar]="#A30262" [input]="#C197D2"
    [rainbow_1]="#FF8A8A" [rainbow_2]="#FFB37C" [rainbow_3]="#FFE599" 
    [rainbow_4]="#A2E4B8" [rainbow_5]="#9BC1FF" [rainbow_6]="#D0B0FF"
    [trans_1]="#5BCEFA" [trans_2]="#F5A9B8" [trans_3]="#FFFFFF"
  )
fi

# 处理原色输入覆盖
if [[ "$PRIDE_INPUT_COLOR" == "default" ]]; then
  if [[ "$PRIDE_THEME_MODE" == "light" ]]; then
    theme_colors[input]="#333333" # 浅色背景用深灰色
  else
    theme_colors[input]="#FFFFFF" # 深色背景用纯白色
  fi
fi

# ------------------------------------------
# 3. 生成 Prompt
# ------------------------------------------
PROMPT="%F{${theme_colors[arrow]}}➜ %F{${theme_colors[user]}}${PRIDE_THEME_USER}%F{${theme_colors[at]}}@%F{${theme_colors[dir]}}%1~ %F{${theme_colors[dollar]}}$ %F{${theme_colors[input]}}"

# 在敲下回车键执行命令的瞬间，重置颜色，防止污染外部程序的输出
preexec() {
  print -rn -- $'\e[0m'
}

# ------------------------------------------
# 4. 彩虹打字机 (Rainbow Typewriter ZLE Hook)
# ------------------------------------------
typeset -a rainbow_array
rainbow_array=(
  ${theme_colors[rainbow_1]} ${theme_colors[rainbow_2]} ${theme_colors[rainbow_3]}
  ${theme_colors[rainbow_4]} ${theme_colors[rainbow_5]} ${theme_colors[rainbow_6]}
  ${theme_colors[trans_1]}   ${theme_colors[trans_2]}   ${theme_colors[trans_3]}
)

rainbow_typewriter() {
  if [[ "$RAINBOW_TYPING" != "on" ]]; then
    region_highlight=()
    return
  fi

  local len=${#BUFFER}
  region_highlight=()
  if (( len == 0 )); then return; fi

  local i
  local word_count=0
  local in_word=0

  for (( i=0; i < len; i++ )); do
    local char="${BUFFER:$i:1}"
    
    # 遇到空格/制表符不换色
    if [[ "$char" == " " || "$char" == $'\t' ]]; then
      in_word=0
      continue
    fi
    
    # 遇到新单词则推进一步颜色
    if (( in_word == 0 )); then
      in_word=1
      ((word_count++))
    fi
    
    local color_idx=$(( ((word_count - 1) % 9) + 1 ))
    local c=${rainbow_array[$color_idx]}
    region_highlight+=("$i $((i+1)) fg=$c")
  done
}

autoload -Uz add-zle-hook-widget
zle -N rainbow_typewriter
add-zle-hook-widget line-pre-redraw rainbow_typewriter

# 快捷命令
alias rainbow-on='export RAINBOW_TYPING="on"'
alias rainbow-off='export RAINBOW_TYPING="off"'