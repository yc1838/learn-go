#!/bin/bash

# ================================
# Interactive Menu Function
# ================================
run_menu() {
    local selected=0
    local options=("$@")
    local num_options=${#options[@]}
    
    # Hide cursor
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
        
        # Read key
        read -rsn1 key
        if [[ $key == $'\x1b' ]]; then
            read -rsn2 key2
            if [[ $key2 == '[A' ]]; then # Up arrow
                ((selected--))
                if [ $selected -lt 0 ]; then selected=$((num_options - 1)); fi
            elif [[ $key2 == '[B' ]]; then # Down arrow
                ((selected++))
                if [ $selected -ge $num_options ]; then selected=0; fi
            fi
        elif [[ $key == "" ]]; then
            # Enter key
            break
        fi
        
        # Move cursor back up to redraw
        echo -ne "\033[${num_options}A"
    done
    
    # Show cursor
    echo -ne "\033[?25h"
    return $selected
}

# 0. 语言选择 (Language Selection)
echo "Please select your language / 请选择你的语言 (Use UP/DOWN arrows, then ENTER):"

LANG_OPTIONS=(
    "English"
    "中文"
)

run_menu "${LANG_OPTIONS[@]}"
LANG_CHOICE=$?
echo ""

# 准备前缀，用来模拟真实的终端显示 (替换 ~ 为 folder)
PREFIX_DARK="\033[38;2;216;75;32m➜ \033[38;2;239;118;39muser\033[38;2;255;255;255m@\033[38;2;209;98;164mfolder \033[38;2;163;2;98m$ \033[0m"
PREFIX_LIGHT="\033[38;2;201;59;78m➜ \033[38;2;217;119;43muser\033[38;2;136;136;136m@\033[38;2;160;80;123mfolder \033[38;2;139;80;153m$ \033[0m"

# Parse language
if [ "$LANG_CHOICE" -eq 0 ]; then
    LANG_MODE="en"
    
    PREVIEW_DW_EN="${PREFIX_DARK}\033[38;2;255;255;255mThis is a preview of the white typewriter for dark backgrounds.\033[0m"
    PREVIEW_D_EN="${PREFIX_DARK}\033[38;2;255;138;138mThis\033[0m \033[38;2;255;179;124mis a\033[0m \033[38;2;255;229;153mpreview\033[0m \033[38;2;162;228;184mof the\033[0m \033[38;2;155;193;255mrainbow\033[0m \033[38;2;208;176;255mtypewriter\033[0m \033[38;2;91;206;250mfor\033[0m \033[38;2;245;169;184mdark\033[0m \033[38;2;255;255;255mbackgrounds.\033[0m"
    PREVIEW_DP_EN="${PREFIX_DARK}\033[38;2;193;151;210mThis is a preview of the purple typewriter for dark backgrounds.\033[0m"
    PREVIEW_L_EN="${PREFIX_LIGHT}\033[38;2;201;59;78mThis\033[0m \033[38;2;217;119;43mis a\033[0m \033[38;2;181;153;20mpreview\033[0m \033[38;2;58;150;94mof the\033[0m \033[38;2;52;101;164mrainbow\033[0m \033[38;2;139;80;153mtypewriter\033[0m \033[38;2;61;153;200mfor\033[0m \033[38;2;212;112;135mlight\033[0m \033[38;2;136;136;136mbackgrounds.\033[0m"
    PREVIEW_LP_EN="${PREFIX_LIGHT}\033[38;2;142;106;158mThis is a preview of the purple typewriter for light backgrounds.\033[0m"

    MSG_PREVIEW_INTRO="🎨 Use UP/DOWN arrows to select your style, then press ENTER:"
    MSG_USER="📛 What username would you like to display? (Leave blank for system default): "
    MSG_ERR_MISSING="❌ Error: Cannot find theme file (\$THEME_SCRIPT). Make sure it's in the same directory!"
    MSG_WRITING="🚀 Writing configuration to "
    MSG_SUCCESS="✅ Installation complete!"
    MSG_RESTART="Please restart your terminal or manually run the following command to apply:"
    
    OPTIONS=(
        "$PREVIEW_DW_EN"
        "$PREVIEW_D_EN"
        "$PREVIEW_DP_EN"
        "$PREVIEW_L_EN"
        "$PREVIEW_LP_EN"
    )
else
    LANG_MODE="zh"
    
    PREVIEW_DW_ZH="${PREFIX_DARK}\033[38;2;255;255;255m这 是 适合 暗色系 终端 背景的 纯白 打字机 预览\033[0m"
    PREVIEW_D_ZH="${PREFIX_DARK}\033[38;2;255;138;138m这\033[0m \033[38;2;255;179;124m是\033[0m \033[38;2;255;229;153m适合\033[0m \033[38;2;162;228;184m暗色系\033[0m \033[38;2;155;193;255m终端\033[0m \033[38;2;208;176;255m背景的\033[0m \033[38;2;91;206;250m彩虹\033[0m \033[38;2;245;169;184m打字机\033[0m \033[38;2;255;255;255m预览\033[0m"
    PREVIEW_DP_ZH="${PREFIX_DARK}\033[38;2;193;151;210m这 是 适合 暗色系 终端 背景的 淡紫 打字机 预览\033[0m"
    PREVIEW_L_ZH="${PREFIX_LIGHT}\033[38;2;201;59;78m这\033[0m \033[38;2;217;119;43m是\033[0m \033[38;2;181;153;20m适合\033[0m \033[38;2;58;150;94m明色系\033[0m \033[38;2;52;101;164m终端\033[0m \033[38;2;139;80;153m背景的\033[0m \033[38;2;61;153;200m彩虹\033[0m \033[38;2;212;112;135m打字机\033[0m \033[38;2;136;136;136m预览\033[0m"
    PREVIEW_LP_ZH="${PREFIX_LIGHT}\033[38;2;142;106;158m这 是 适合 明色系 终端 背景的 淡紫 打字机 预览\033[0m"

    MSG_PREVIEW_INTRO="🎨 请按【键盘上下键】选择你喜欢的风格，然后按【回车键】确认："
    MSG_USER="📛 你希望在终端里显示什么名字？(留空则使用系统真实用户名): "
    MSG_ERR_MISSING="❌ 错误：找不到主题文件 (\$THEME_SCRIPT)。请确保它和此安装脚本在同一个目录下！"
    MSG_WRITING="🚀 正在将配置写入 "
    MSG_SUCCESS="✅ 安装成功！"
    MSG_RESTART="请重启终端，或者手动运行以下命令来立刻体验："
    
    OPTIONS=(
        "$PREVIEW_DW_ZH"
        "$PREVIEW_D_ZH"
        "$PREVIEW_L_ZH"
        "$PREVIEW_DP_ZH"
        "$PREVIEW_LP_ZH"
    )
fi

echo ""
# 使用 Lesbian 色彩打印欢迎语
echo -e "🏳️‍🌈 \033[38;2;216;75;32mWelcome\033[0m \033[38;2;239;118;39mto\033[0m \033[38;2;255;255;255mPride\033[0m \033[38;2;209;98;164mShell\033[0m \033[38;2;163;2;98mInstaller\033[0m 🏳️‍⚧️"
echo "================================================="
echo ""

# 1. 用户选择颜色模式 (上下箭头交互式菜单)
echo "$MSG_PREVIEW_INTRO"
run_menu "${OPTIONS[@]}"
CHOICE=$?

echo ""

if [ "$CHOICE" -eq 0 ]; then
    THEME_MODE="dark"
    RAINBOW_TYPING="off"
    INPUT_COLOR="default"
elif [ "$CHOICE" -eq 1 ]; then
    THEME_MODE="dark"
    RAINBOW_TYPING="on"
    INPUT_COLOR="purple"
elif [ "$CHOICE" -eq 2 ]; then
    THEME_MODE="dark"
    RAINBOW_TYPING="off"
    INPUT_COLOR="purple"
elif [ "$CHOICE" -eq 3 ]; then
    THEME_MODE="light"
    RAINBOW_TYPING="on"
    INPUT_COLOR="purple"
elif [ "$CHOICE" -eq 4 ]; then
    THEME_MODE="light"
    RAINBOW_TYPING="off"
    INPUT_COLOR="purple"
fi

# 2. 询问用户想显示什么名字
echo -n "$MSG_USER"
read THEME_USER
if [[ -z "$THEME_USER" ]]; then
    THEME_USER="%n"
fi

# 获取当前 lesbiancolor.sh 的绝对路径
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
THEME_SCRIPT="$SCRIPT_DIR/lesbiancolor.sh"

if [ ! -f "$THEME_SCRIPT" ]; then
    eval echo "\"$MSG_ERR_MISSING\""
    exit 1
fi

ZSHRC="$HOME/.zshrc"

echo ""
echo "$MSG_WRITING $ZSHRC ..."

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

echo -e "\033[38;2;162;228;184m$MSG_SUCCESS\033[0m"
echo "$MSG_RESTART"
echo -e "  \033[36msource ~/.zshrc\033[0m"
echo ""