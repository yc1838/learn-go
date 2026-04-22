#!/bin/bash

# 0. 语言选择 (Language Selection)
echo "Please select your language / 请选择你的语言:"
echo "[E] English"
echo "[C] 中文 (Chinese)"
echo -n "> "
read LANG_CHOICE

# Parse language
if [[ "${LANG_CHOICE}" == "E" || "${LANG_CHOICE}" == "e" || "${LANG_CHOICE}" == "1" ]]; then
    LANG_MODE="en"
    
    PREVIEW_DARK="\033[38;2;255;138;138mThis\033[0m \033[38;2;255;179;124mis\033[0m \033[38;2;255;229;153ma\033[0m \033[38;2;162;228;184mpreview\033[0m \033[38;2;155;193;255mof\033[0m \033[38;2;208;176;255mthe\033[0m \033[38;2;91;206;250mrainbow\033[0m \033[38;2;245;169;184mtypewriter\033[0m \033[38;2;255;255;255meffect!\033[0m"
    PREVIEW_LIGHT="\033[38;2;201;59;78mThis\033[0m \033[38;2;217;119;43mis\033[0m \033[38;2;181;153;20ma\033[0m \033[38;2;58;150;94mpreview\033[0m \033[38;2;52;101;164mof\033[0m \033[38;2;139;80;153mthe\033[0m \033[38;2;61;153;200mrainbow\033[0m \033[38;2;212;112;135mtypewriter\033[0m \033[38;2;136;136;136meffect!\033[0m"
    
    MSG_PREVIEW_INTRO="🎨 Here is a preview of the rainbow colors for different terminal backgrounds:"
    MSG_THEME="Choose your terminal background mode: Dark [d] or Light [l]? (d/l) [default: d]: "
    MSG_USER="📛 What username would you like to display? (Leave blank for system default): "
    MSG_RAINBOW="✨ Enable 'Rainbow Typewriter' effect by default? (y/n) [default: n]: "
    MSG_ERR_MISSING="❌ Error: Cannot find theme file (\$THEME_SCRIPT). Make sure it's in the same directory!"
    MSG_WRITING="🚀 Writing configuration to "
    MSG_SUCCESS="✅ Installation complete!"
    MSG_RESTART="Please restart your terminal or manually run the following command to apply:"
else
    LANG_MODE="zh"
    
    PREVIEW_DARK="\033[38;2;255;138;138m这\033[0m \033[38;2;255;179;124m是\033[0m \033[38;2;255;229;153m暗色系\033[0m \033[38;2;162;228;184m的\033[0m \033[38;2;155;193;255m彩虹\033[0m \033[38;2;208;176;255m打字机\033[0m \033[38;2;91;206;250m效果\033[0m \033[38;2;245;169;184m预览\033[0m \033[38;2;255;255;255m！\033[0m"
    PREVIEW_LIGHT="\033[38;2;201;59;78m这\033[0m \033[38;2;217;119;43m是\033[0m \033[38;2;181;153;20m明色系\033[0m \033[38;2;58;150;94m的\033[0m \033[38;2;52;101;164m彩虹\033[0m \033[38;2;139;80;153m打字机\033[0m \033[38;2;61;153;200m效果\033[0m \033[38;2;212;112;135m预览\033[0m \033[38;2;136;136;136m！\033[0m"

    MSG_PREVIEW_INTRO="🎨 在你选择颜色模式之前，请看两种模式下的彩虹打字机预览效果："
    MSG_THEME="请选择你的终端背景颜色模式：暗色系 [d] 还是 明色系 [l]？ (d/l) [默认: d]: "
    MSG_USER="📛 你希望在终端里显示什么名字？(留空则使用系统真实用户名): "
    MSG_RAINBOW="✨ 是否默认开启【彩虹打字机】特效？(y/n) [默认: n]: "
    MSG_ERR_MISSING="❌ 错误：找不到主题文件 (\$THEME_SCRIPT)。请确保它和此安装脚本在同一个目录下！"
    MSG_WRITING="🚀 正在将配置写入 "
    MSG_SUCCESS="✅ 安装成功！"
    MSG_RESTART="请重启终端，或者手动运行以下命令来立刻体验："
fi

echo ""
# 使用彩虹色打印欢迎语
echo -e "\033[38;2;213;45;86m🏳️‍🌈 \033[0m \033[38;2;239;118;39mW\033[0m\033[38;2;255;255;255me\033[0m\033[38;2;209;98;164ml\033[0m\033[38;2;163;2;98mc\033[0m\033[38;2;193;151;210mo\033[0m\033[38;2;213;45;86mm\033[0m\033[38;2;239;118;39me\033[0m \033[38;2;255;255;255mt\033[0m\033[38;2;209;98;164mo\033[0m \033[38;2;163;2;98mP\033[0m\033[38;2;193;151;210mr\033[0m\033[38;2;213;45;86mi\033[0m\033[38;2;239;118;39md\033[0m\033[38;2;255;255;255me\033[0m \033[38;2;209;98;164mS\033[0m\033[38;2;163;2;98mh\033[0m\033[38;2;193;151;210me\033[0m\033[38;2;213;45;86ml\033[0m\033[38;2;239;118;39ml\033[0m \033[38;2;255;255;255mI\033[0m\033[38;2;209;98;164mn\033[0m\033[38;2;163;2;98ms\033[0m\033[38;2;193;151;210mt\033[0m\033[38;2;213;45;86ma\033[0m\033[38;2;239;118;39ml\033[0m\033[38;2;255;255;255ml\033[0m\033[38;2;209;98;164me\033[0m\033[38;2;163;2;98mr\033[0m \033[38;2;193;151;210m 🏳️‍⚧️\033[0m"
echo "================================================="
echo ""

# 0.5 预览颜色
echo "$MSG_PREVIEW_INTRO"
echo -e "  [d] Dark  : $PREVIEW_DARK"
echo -e "  [l] Light : $PREVIEW_LIGHT"
echo ""

# 1. 询问用户喜欢什么颜色模式
echo -n "$MSG_THEME"
read THEME_MODE
if [[ "$THEME_MODE" == "l" || "$THEME_MODE" == "L" ]]; then
    THEME_MODE="light"
else
    THEME_MODE="dark"
fi

# 2. 询问用户想显示什么名字
echo -n "$MSG_USER"
read THEME_USER
if [[ -z "$THEME_USER" ]]; then
    THEME_USER="%n"
fi

# 3. 询问是否开启打字机特效
echo -n "$MSG_RAINBOW"
read RAINBOW_TYPING
if [[ "$RAINBOW_TYPING" == "y" || "$RAINBOW_TYPING" == "Y" ]]; then
    RAINBOW_TYPING="on"
else
    RAINBOW_TYPING="off"
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
source "$THEME_SCRIPT"
EOF

echo -e "\033[38;2;162;228;184m$MSG_SUCCESS\033[0m"
echo "$MSG_RESTART"
echo -e "  \033[36msource ~/.zshrc\033[0m"
echo ""
