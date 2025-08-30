# 一款适配于华硕天选的GRUB主题
---

![preview](preview_images/Preview.gif)

## 安装说明

1. 克隆或下载本仓库到本地：
   ```shell
   git clone https://github.com/Feather-P/asus-tuf-grub-theme.git
   cd asus-tuf-grub-theme
   ```

2. 运行安装脚本（需要root权限）：
   ```shell
   sudo ./install.sh
   ```

3. 根据提示选择您喜欢的主题：
   - 输入 `1` 选择深色主题
   - 输入 `2` 选择浅色主题

4. 安装完成后，安装脚本会自动更新GRUB配置

## 卸载方法

1. 恢复原始GRUB配置文件：
   ```shell
   sudo cp /etc/default/grub.bak /etc/default/grub
   ```

2. 更新GRUB配置：
   ```shell
   sudo update-grub
   ```

3. 删除主题文件（可选）：
   ```shell
   sudo rm -rf /boot/grub/themes/asus-tuf-grub-theme
   ```

## 主题切换

如需在深色和浅色主题之间切换，只需重新运行安装脚本并选择不同的主题：
```shell
sudo ./install.sh
```

## 文件结构

```
asus-tuf-grub-theme/
├── install.sh              # 安装脚本
├── LICENSE                 # MIT许可证
├── readme.md              # 项目说明文档
├── preview_images/        # 预览图像
├── source/                # 源文件
│   ├── background_dark.xcf    # 深色背景源文件
│   ├── background_light.xcf   # 浅色背景源文件
│   ├── HarmonyOS_Sans_Bold.ttf   # 粗体字体文件
│   └── HarmonyOS_Sans_Regular.ttf # 常规字体文件
└── theme/                 # 主题文件
    ├── common/            # 通用资源
    │   ├── fonts/        # 字体文件
    │   └── icons/        # 系统图标
    ├── dark/             # 深色主题
    │   ├── background.png
    │   ├── patterns/
    │   └── theme.txt
    └── light/            # 浅色主题
        ├── background.png
        ├── patterns/
        └── theme.txt
```

## 自定义主题

如果您想自定义主题，可以修改以下文件：

- `theme/dark/theme.txt`：深色主题配置
- `theme/light/theme.txt`：浅色主题配置
- `source/` 目录下的源文件：GIMP背景图像和字体
- `theme/dark/background.png`：深色背景文件
- `theme/light/background.png`：浅色背景文件

修改后，重新运行安装脚本即可应用更改。

## 关于PR

~~求求你了，行行好吧~~

## 许可证

本项目采用MIT许可证。详情请参阅[LICENSE](LICENSE)文件。

## 连吃带拿这块

- 感谢HarmonyOS Sans字体

## 联系方式

如有问题或建议，请通过以下方式联系：

- 提交Issue：[GitHub Issues](https://github.com/Feather-P/asus-tuf-grub-theme/issues)
- 邮箱：[featherp@qq.com](mailto:featherp@qq.com)