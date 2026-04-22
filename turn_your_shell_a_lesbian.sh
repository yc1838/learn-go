#!/bin/bash

# ================================
# Terminal UI Colors & Components
# ================================
C1="\033[38;2;216;75;32m"
C2="\033[38;2;239;118;39m"
C3="\033[38;2;255;255;255m"
C4="\033[38;2;209;98;164m"
C5="\033[38;2;163;2;98m"
CR="\033[0m"

# 18 + 18 + 16 + 18 + 18 = 88 columns for the box width
LINE1="──────────────────"
LINE2="──────────────────"
LINE3="────────────────"
LINE4="──────────────────"
LINE5="──────────────────"

BOX_TOP="${C1}╭${LINE1}${C2}${LINE2}${C3}${LINE3}${C4}${LINE4}${C5}${LINE5}╮${CR}"
BOX_BOT="${C1}╰${LINE1}${C2}${LINE2}${C3}${LINE3}${C4}${LINE4}${C5}${LINE5}╯${CR}"

# ================================
# Interactive Menu Functions
# ================================
run_lang_menu() {
    local selected=0
    local options=("$@")
    local num_options=${#options[@]}
    
    echo -ne "\033[?25l"
    
    while true; do
        local i=0
        for opt in "${options[@]}"; do
            if [ $i -eq $selected ]; then
                echo -e " \033[1;36m➜\033[0m $opt\033[K"
            else
                echo -e "   $opt\033[K"
            fi
            ((i++))
        done
        
        read -rsn1 key
        if [[ $key == $'\x1b' ]]; then
            read -rsn2 key2
            if [[ $key2 == '[A' ]]; then
                ((selected--))
                if [ $selected -lt 0 ]; then selected=$((num_options - 1)); fi
            elif [[ $key2 == '[B' ]]; then
                ((selected++))
                if [ $selected -ge $num_options ]; then selected=0; fi
            fi
        elif [[ $key == "" ]]; then
            break
        fi
        
        echo -ne "\033[${num_options}A"
    done
    
    echo -ne "\033[?25h"
    return $selected
}

run_theme_menu() {
    local selected=0
    local options=("$@")
    local num_options=${#options[@]}
    
    echo -ne "\033[?25l"
    
    echo -e "$BOX_TOP"
    echo -e "${C1}│${CR}\033[90G${C5}│${CR}"
    echo -e "${C1}│${CR}\033[90G${C5}│${CR}\033[2G${WELCOME_LINE}"
    echo -e "${C1}│${CR}\033[90G${C5}│${CR}"
    echo -e "${C1}│${CR}  $MSG_PREVIEW_INTRO\033[90G${C5}│${CR}"
    echo -e "${C1}│${CR}\033[90G${C5}│${CR}"
    
    while true; do
        local i=0
        for opt in "${options[@]}"; do
            if [ $i -eq $selected ]; then
                echo -e "${C1}│${CR}  \033[1;36m➜\033[0m $opt\033[K\033[90G${C5}│${CR}"
            else
                echo -e "${C1}│${CR}    $opt\033[K\033[90G${C5}│${CR}"
            fi
            ((i++))
        done
        echo -e "${C1}│${CR}\033[90G${C5}│${CR}"
        echo -e "${BOX_BOT}\033[K"
        
        read -rsn1 key
        if [[ $key == $'\x1b' ]]; then
            read -rsn2 key2
            if [[ $key2 == '[A' ]]; then
                ((selected--))
                if [ $selected -lt 0 ]; then selected=$((num_options - 1)); fi
            elif [[ $key2 == '[B' ]]; then
                ((selected++))
                if [ $selected -ge $num_options ]; then selected=0; fi
            fi
        elif [[ $key == "" ]]; then
            break
        fi
        
        echo -ne "\033[$((num_options + 2))A"
    done
    
    echo -ne "\033[?25h"
    # Move cursor down past the box
    echo -ne "\033[$((num_options + 2))B"
    return $selected
}

run_loading() {
    local msg="$1"
    clear
    echo -e "$BOX_TOP"
    echo -e "${C1}│${CR}\033[90G${C5}│${CR}"
    echo -e "${C1}│${CR}\033[90G${C5}│${CR}\033[2G${WELCOME_LINE}"
    echo -e "${C1}│${CR}\033[90G${C5}│${CR}"
    echo -e "${C1}│${CR}  $msg ⠋\033[90G${C5}│${CR}"
    echo -e "${C1}│${CR}\033[90G${C5}│${CR}"
    echo -e "$BOX_BOT"
    
    echo -ne "\033[?25l"
    echo -ne "\033[3A"
    
    local frames=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
    
    for i in {1..20}; do
        local frame=${frames[$((i % 10))]}
        local c=$((i % 5))
        local col="${C3}"
        if [ $c -eq 0 ]; then col="${C1}"
        elif [ $c -eq 1 ]; then col="${C2}"
        elif [ $c -eq 2 ]; then col="${C3}"
        elif [ $c -eq 3 ]; then col="${C4}"
        elif [ $c -eq 4 ]; then col="${C5}"
        fi
        
        echo -ne "\033[1G${C1}│${CR}  $msg ${col}${frame}${CR}\033[K\033[90G${C5}│${CR}"
        sleep 0.08
    done
    
    echo -ne "\033[3B"
    echo -ne "\033[?25h"
}

# Clear screen at the very beginning
clear

# 0. Language Selection
echo "Please select your language (Use UP/DOWN arrows, then press ENTER):"
echo "请选择你的语言 (按上下方向键选择，然后按回车键确认):"
echo ""

LANG_OPTIONS=(
    "English"
    "中文"
)

run_lang_menu "${LANG_OPTIONS[@]}"
LANG_CHOICE=$?

# Clear the language selection menu
clear

PREFIX_DARK="\033[38;2;216;75;32m➜ \033[38;2;239;118;39muser\033[38;2;255;255;255m@\033[38;2;209;98;164mfolder \033[38;2;163;2;98m$ \033[0m"
PREFIX_LIGHT="\033[38;2;201;59;78m➜ \033[38;2;217;119;43muser\033[38;2;136;136;136m@\033[38;2;160;80;123mfolder \033[38;2;139;80;153m$ \033[0m"

if [ "$LANG_CHOICE" -eq 0 ]; then
    LANG_MODE="en"
    
    WELCOME_TEXT_EN="\033[38;2;216;75;32mWelcome\033[0m \033[38;2;239;118;39mto\033[0m \033[38;2;255;255;255mPride\033[0m \033[38;2;209;98;164mShell\033[0m \033[38;2;163;2;98mInstaller\033[0m"
    # 24 spaces padding for perfect center in 88 col width
    WELCOME_LINE="                        🌈  $WELCOME_TEXT_EN  ⚧️"

    PREVIEW_DW_EN="${PREFIX_DARK}\033[38;2;255;255;255mThis is a preview of the white typewriter for dark backgrounds.\033[0m"
    PREVIEW_D_EN="${PREFIX_DARK}\033[38;2;255;138;138mThis\033[0m \033[38;2;255;179;124mis a\033[0m \033[38;2;255;229;153mpreview\033[0m \033[38;2;162;228;184mof the\033[0m \033[38;2;155;193;255mrainbow\033[0m \033[38;2;208;176;255mtypewriter\033[0m \033[38;2;91;206;250mfor\033[0m \033[38;2;245;169;184mdark\033[0m \033[38;2;255;255;255mbackgrounds.\033[0m"
    PREVIEW_L_EN="${PREFIX_LIGHT}\033[38;2;201;59;78mThis\033[0m \033[38;2;217;119;43mis a\033[0m \033[38;2;181;153;20mpreview\033[0m \033[38;2;58;150;94mof the\033[0m \033[38;2;52;101;164mrainbow\033[0m \033[38;2;139;80;153mtypewriter\033[0m \033[38;2;61;153;200mfor\033[0m \033[38;2;212;112;135mlight\033[0m \033[38;2;136;136;136mbackgrounds.\033[0m"
    PREVIEW_DP_EN="${PREFIX_DARK}\033[38;2;193;151;210mThis is a preview of the purple typewriter for dark backgrounds.\033[0m"
    PREVIEW_LP_EN="${PREFIX_LIGHT}\033[38;2;142;106;158mThis is a preview of the purple typewriter for light backgrounds.\033[0m"

    MSG_PREVIEW_INTRO="🎨 Use UP/DOWN arrows to select your style, then press ENTER:"
    MSG_USER="📛 What username would you like to display? (Leave blank for default): "
    INPUT_COL=75
    MSG_LOADING="🚀 Writing configuration to ~/.zshrc..."
    MSG_ERR_MISSING="❌ Error: Cannot find theme file (\$THEME_SCRIPT). Make sure it's in the same directory!"
    MSG_SUCCESS="✅ Installation complete!"
    MSG_RESTART="Please restart your terminal or manually run the following command to apply:"
    
    OPTIONS=(
        "$PREVIEW_DW_EN"
        "$PREVIEW_D_EN"
        "$PREVIEW_L_EN"
        "$PREVIEW_DP_EN"
        "$PREVIEW_LP_EN"
    )
else
    LANG_MODE="zh"
    
    WELCOME_TEXT_ZH="\033[38;2;216;75;32m欢迎\033[0m \033[38;2;239;118;39m使用\033[0m \033[38;2;255;255;255mPride\033[0m \033[38;2;209;98;164mShell\033[0m \033[38;2;163;2;98m安装向导\033[0m"
    # 25 spaces padding for perfect center in 88 col width
    WELCOME_LINE="                         🌈  $WELCOME_TEXT_ZH  ⚧️"

    PREVIEW_DW_ZH="${PREFIX_DARK}\033[38;2;255;255;255m这 是 适合 暗色系 终端 背景的 纯白 打字机 预览\033[0m"
    PREVIEW_D_ZH="${PREFIX_DARK}\033[38;2;255;138;138m这\033[0m \033[38;2;255;179;124m是\033[0m \033[38;2;255;229;153m适合\033[0m \033[38;2;162;228;184m暗色系\033[0m \033[38;2;155;193;255m终端\033[0m \033[38;2;208;176;255m背景的\033[0m \033[38;2;91;206;250m彩虹\033[0m \033[38;2;245;169;184m打字机\033[0m \033[38;2;255;255;255m预览\033[0m"
    PREVIEW_L_ZH="${PREFIX_LIGHT}\033[38;2;201;59;78m这\033[0m \033[38;2;217;119;43m是\033[0m \033[38;2;181;153;20m适合\033[0m \033[38;2;58;150;94m明色系\033[0m \033[38;2;52;101;164m终端\033[0m \033[38;2;139;80;153m背景的\033[0m \033[38;2;61;153;200m彩虹\033[0m \033[38;2;212;112;135m打字机\033[0m \033[38;2;136;136;136m预览\033[0m"
    PREVIEW_DP_ZH="${PREFIX_DARK}\033[38;2;193;151;210m这 是 适合 暗色系 终端 背景的 淡紫 打字机 预览\033[0m"
    PREVIEW_LP_ZH="${PREFIX_LIGHT}\033[38;2;142;106;158m这 是 适合 明色系 终端 背景的 淡紫 打字机 预览\033[0m"

    MSG_PREVIEW_INTRO="🎨 请按【键盘上下键】选择你喜欢的风格，然后按【回车键】确认："
    MSG_USER="📛 你希望显示什么名字？(留空使用默认): "
    INPUT_COL=44
    MSG_LOADING="🚀 正在将绝美配置写入 ~/.zshrc..."
    MSG_ERR_MISSING="❌ 错误：找不到主题文件 (\$THEME_SCRIPT)。请确保它和此安装脚本在同一个目录下！"
    MSG_SUCCESS="✅ 安装成功！"
    MSG_RESTART="请重启终端，循环效果如需重置，可以手动运行以下命令来立刻体验："
    
    OPTIONS=(
        "$PREVIEW_DW_ZH"
        "$PREVIEW_D_ZH"
        "$PREVIEW_L_ZH"
        "$PREVIEW_DP_ZH"
        "$PREVIEW_LP_ZH"
    )
fi

# 1. Theme Selection
run_theme_menu "${OPTIONS[@]}"
CHOICE=$?

if [ "$CHOICE" -eq 0 ]; then
    THEME_MODE="dark"
    RAINBOW_TYPING="off"
    INPUT_COLOR="default"
elif [ "$CHOICE" -eq 1 ]; then
    THEME_MODE="dark"
    RAINBOW_TYPING="on"
    INPUT_COLOR="purple"
elif [ "$CHOICE" -eq 2 ]; then
    THEME_MODE="light"
    RAINBOW_TYPING="on"
    INPUT_COLOR="purple"
elif [ "$CHOICE" -eq 3 ]; then
    THEME_MODE="dark"
    RAINBOW_TYPING="off"
    INPUT_COLOR="purple"
elif [ "$CHOICE" -eq 4 ]; then
    THEME_MODE="light"
    RAINBOW_TYPING="off"
    INPUT_COLOR="purple"
fi

# 2. Prompt for username
clear
echo -e "$BOX_TOP"
echo -e "${C1}│${CR}\033[90G${C5}│${CR}"
echo -e "${C1}│${CR}\033[90G${C5}│${CR}\033[2G${WELCOME_LINE}"
echo -e "${C1}│${CR}\033[90G${C5}│${CR}"
echo -e "${C1}│${CR}  $MSG_USER\033[90G${C5}│${CR}"
echo -e "${C1}│${CR}\033[90G${C5}│${CR}"
echo -e "$BOX_BOT"

# Move cursor up to input line and read
echo -ne "\033[3A\033[${INPUT_COL}G"
read THEME_USER
if [[ -z "$THEME_USER" ]]; then
    THEME_USER="%n"
fi

# Get absolute path of lesbiancolor.sh
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
THEME_SCRIPT="$SCRIPT_DIR/lesbiancolor.sh"

if [ ! -f "$THEME_SCRIPT" ]; then
    echo -e "\n$MSG_ERR_MISSING"
    exit 1
fi

ZSHRC="$HOME/.zshrc"

# 3. Play loading animation
run_loading "$MSG_LOADING"

cat <<EOF >> "$ZSHRC"

# ==========================================
# Pride Shell Theme Configuration
# Installed on $(date)
# ==========================================
export PRIDE_THEME_MODE="$THEME_MODE"
export PRIDE_THEME_USER="$THEME_USER"
export RAINBOW_TYPING="$RAINBOW_TYPING"
export PRIDE_INPUT_COLOR="$INPUT_COLOR"
source "$THEME_SCRIPT"
EOF

# 4. Show success screen
clear
echo -e "$BOX_TOP"
echo -e "${C1}│${CR}\033[90G${C5}│${CR}"
echo -e "${C1}│${CR}\033[90G${C5}│${CR}\033[2G${WELCOME_LINE}"
echo -e "${C1}│${CR}\033[90G${C5}│${CR}"
echo -e "${C1}│${CR}  \033[38;2;162;228;184m$MSG_SUCCESS\033[0m\033[90G${C5}│${CR}"
echo -e "${C1}│${CR}\033[90G${C5}│${CR}"
echo -e "${C1}│${CR}  $MSG_RESTART\033[90G${C5}│${CR}"
echo -e "${C1}│${CR}    \033[36msource ~/.zshrc\033[0m\033[90G${C5}│${CR}"
echo -e "${C1}│${CR}\033[90G${C5}│${CR}"
echo -e "$BOX_BOT"
echo ""