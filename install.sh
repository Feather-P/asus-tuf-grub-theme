#!/bin/bash

# this is a install script for Feather-P/asus-tuf-grub-theme grub theme

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
echo "[1] 深色主题 (dark)"
echo "[2] 浅色主题 (light)"
read -n 1 -p "请输入选项 [1-2]: " THEME_CHOICE

# 根据用户选择设置主题
case $THEME_CHOICE in
    1)
        SELECTED_THEME="dark"
        echo
        echo "已选择深色主题"
        ;;
    2)
        SELECTED_THEME="light"
        echo
        echo "已选择浅色主题"
        ;;
    *)
        echo "无效选项，将使用默认深色主题"
        SELECTED_THEME="dark"
        ;;
esac

# 选择分辨率
echo ""
echo "请选择要安装的背景图像分辨率:"
echo "[1] 1920*1080(天选1/2)"
echo "[2] 2560*1440(天选3/4/5)"
echo "[3] 2560*1600(天选6)"
read -n 1 -p "请输入选项[1-3] " RESOLUTION_CHOICE

# 根据用户选择设置分辨率
case $RESOLUTION_CHOICE in
    1)
        SELECTED_RESOLUTION="1920*1080"
        echo
        echo "已选择1920*1080分辨率"
        ;;
    2)
        SELECTED_RESOLUTION="2560*1440"
        echo
        echo "已选择2560*1440分辨率"
        ;;
    3)
        SELECTED_RESOLUTION="2560*1600"
        echo "已选择2560*1600分辨率"
        ;;
    *)
        echo "无效选项，将使用默认1920*1080分辨率"
        SELECTED_RESOLUTION="1920*1080"
        ;;
esac

# 复制主题文件
echo "复制主题文件..."
for item in "theme/$SELECTED_THEME/$SELECTED_RESOLUTION"/*; do
    if ! cp -r "$item" "$GRUBTHEMESDIR/$THEMENAME/"; then
        echo "错误: 复制主题文件失败"
        exit 1
    fi
done

# 复制通用文件
echo "复制通用文件开始:"

# 复制字体文件
echo "复制字体文件..."
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

# 复制样式文件
echo "复制样式文件..."
if ! cp -r theme/common/patterns "$GRUBTHEMESDIR/$THEMENAME/"; then
    echo "错误: 复制样式文件失败"
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
echo "已应用 天选 $SELECTED_THEME $SELECTED_RESOLUTION 主题"
echo "主题路径: $GRUBTHEMESDIR/$THEMENAME"
echo "如需切换主题，请重新运行此脚本"