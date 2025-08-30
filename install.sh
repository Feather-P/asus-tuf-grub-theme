#!/bin/bash

# this is a install script for Feather-P/asus-tuf-grub-theme grub theme
# author: Feather-P
# date: Aug 30 2025

# 设置变量
THEMENAME="asus-tuf-grub-theme"
GRUBTHEMESDIR="/boot/grub/themes"
GRUBDEFAULTFILE="/etc/default/grub"

# 检查是否以root权限运行
if [ "$EUID" -ne 0 ]; then
    echo "错误: 请使用root权限运行此脚本"
    exit 1
fi

# 检查GRUB是否已安装
if ! command -v grub-install &> /dev/null; then
    echo "错误: 未检测到GRUB安装"
    exit 1
fi

# 检查update-grub命令是否存在
if ! command -v update-grub &> /dev/null; then
    echo "错误: 未检测到update-grub命令"
    exit 1
fi

# 检查主题文件是否存在
if [ ! -d "theme" ]; then
    echo "错误: 主题目录不存在"
    exit 1
fi

if [ ! -d "theme/dark" ] || [ ! -d "theme/light" ] || [ ! -d "theme/common" ]; then
    echo "错误: 主题文件不完整"
    exit 1
fi

# 检查GRUB主题目录是否存在
if [ ! -d "$GRUBTHEMESDIR" ]; then
    echo "创建GRUB主题目录..."
    mkdir -p "$GRUBTHEMESDIR"
else
    echo "GRUB主题目录已存在: $GRUBTHEMESDIR"
fi

# 创建主题目录
echo "创建主题目录..."
mkdir -p "$GRUBTHEMESDIR/$THEMENAME"

# 让用户选择主题
echo ""
echo "请选择要使用的主题:"
echo "1) 深色主题 (dark)"
echo "2) 浅色主题 (light)"
read -p "请输入选项 [1-2]: " theme_choice

# 根据用户选择设置主题
case $theme_choice in
    1)
        SELECTED_THEME="dark"
        echo "已选择深色主题"
        ;;
    2)
        SELECTED_THEME="light"
        echo "已选择浅色主题"
        ;;
    *)
        echo "无效选项，将使用默认深色主题"
        SELECTED_THEME="dark"
        ;;
esac

# 复制主题文件
echo "复制主题文件..."
if [ "$SELECTED_THEME" = "dark" ]; then
    echo "复制深色主题文件..."
    if ! cp -r theme/dark/* "$GRUBTHEMESDIR/$THEMENAME/"; then
        echo "错误: 复制深色主题文件失败"
        exit 1
    fi
else
    echo "复制浅色主题文件..."
    if ! cp -r theme/light/* "$GRUBTHEMESDIR/$THEMENAME/"; then
        echo "错误: 复制浅色主题文件失败"
        exit 1
    fi
fi

# 复制通用字体文件
echo "复制通用字体文件..."

if ! cp -r theme/common/fonts/* "$GRUBTHEMESDIR/$THEMENAME/"; then
    echo "错误: 复制字体文件失败"
    exit 1
fi

# 复制图标文件
echo "复制图标文件..."
if ! cp -r theme/common/icons "$GRUBTHEMESDIR/$THEMENAME/"; then
    echo "错误: 复制图标文件失败"
    exit 1
fi

# 备份原始GRUB配置文件
if [ ! -f "$GRUBDEFAULTFILE.bak" ]; then
    if ! cp "$GRUBDEFAULTFILE" "$GRUBDEFAULTFILE.bak"; then
        echo "错误: 备份GRUB配置文件失败"
        exit 1
    fi
    echo "已备份原始GRUB配置文件"
fi

# 更新GRUB配置文件
echo "更新GRUB配置文件..."

# 检查是否已有GRUB_THEME设置
if grep -q "^GRUB_THEME=" "$GRUBDEFAULTFILE"; then
    # 如果已存在，则替换
    if ! sed -i "s|^GRUB_THEME=.*|GRUB_THEME=\"$GRUBTHEMESDIR/$THEMENAME/theme.txt\"|" "$GRUBDEFAULTFILE"; then
        echo "错误: 更新GRUB_THEME设置失败"
        exit 1
    fi
else
    # 如果不存在，则添加
    if ! echo "GRUB_THEME=\"$GRUBTHEMESDIR/$THEMENAME/$SELECTED_THEME/theme.txt\"" >> "$GRUBDEFAULTFILE"; then
        echo "错误: 添加GRUB_THEME设置失败"
        exit 1
    fi
fi

# 确保GRUB_TERMINAL_OUTPUT被注释掉，以便使用图形主题
if grep -q "^GRUB_TERMINAL_OUTPUT=" "$GRUBDEFAULTFILE"; then
    if ! sed -i 's/^GRUB_TERMINAL_OUTPUT=.*/#GRUB_TERMINAL_OUTPUT=console/' "$GRUBDEFAULTFILE"; then
        echo "错误: 注释GRUB_TERMINAL_OUTPUT设置失败"
        exit 1
    fi
fi

# 更新GRUB配置
echo "更新GRUB配置..."
if ! update-grub; then
    echo "错误: 更新GRUB配置失败"
    exit 1
fi

echo ""
echo "GRUB主题安装完成！"
echo "已应用 天选 $SELECTED_THEME 主题"
echo "主题路径: $GRUBTHEMESDIR/$THEMENAME/theme.txt"
echo "如需切换主题，请重新运行此脚本"