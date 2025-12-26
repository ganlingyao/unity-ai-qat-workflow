# Unity AI QAT Workflow

为 Cursor 编辑器提供的 Unity 开发辅助指令集，帮助你更高效地进行 Unity 项目的调试、错误修复、测试和开发工作流管理。

> 🎯 **核心理念**：让 AI 成为你的 Unity 开发助手，自动化处理繁琐的调试、修复和测试工作。

---

## 🎬 功能演示

### `/debug` - 智能调试

当游戏运行时出现问题，AI 会自动获取控制台日志、分析问题、添加调试代码、迭代修复，直到问题解决。

![debug 演示](assets/debug.gif)

**适用场景**：
- 游戏运行时行为异常
- 需要追踪变量值变化
- 排查逻辑错误

---

### `/fixer` - 自动修复错误

控制台出现编译错误或警告？AI 会自动获取所有错误信息，分析根本原因，按优先级逐个修复。

![fixer 演示](assets/fix.gif)

**适用场景**：
- 代码编译错误
- 引用缺失或命名空间问题
- API 废弃警告

---

### `/tester` - 自动化测试

代码修改后一键运行测试，AI 会自动调用 Unity Test Framework，获取测试结果并生成报告。

![tester 演示](assets/tester.gif)

**适用场景**：
- 代码修改后的回归测试
- 功能开发完成后的验证
- CI/CD 流程中的测试环节

---

### `/plan-workflow` - 开发工作流

开始一次新spec的工作时，AI 会阅读设计文档、盘点开发进度、生成待执行任务列表，帮你快速进入工作状态。

**适用场景**：
- 每日工作启动
- 项目进度盘点
- 任务规划和分配

---

## ✨ 功能特性一览

| 指令 | 功能 | 说明 |
|-----|------|-----|
| `/debug` | 控制台调试 | 使用 Unity MCP 获取日志，分析运行时问题并调试修复 |
| `/fixer` | 修复错误 | 获取控制台警告/报错，分析原因并快速修复 |
| `/tester` | 运行测试 | 自动运行 EditMode/PlayMode 测试，生成报告并判定结果 |
| `/plan-workflow` | 开发工作流 | 阅读文档、盘点进度、生成待执行任务 |

---

## 🚀 快速开始

### 30 秒安装

在你的 **Unity 项目根目录** 打开终端（Git Bash 或 PowerShell），运行：

```bash
# Git Bash / WSL
curl -fsSL https://raw.githubusercontent.com/MayoooooG/unity-ai-qat-workflow/main/install.sh | bash

# PowerShell
curl -fsSL https://raw.githubusercontent.com/MayoooooG/unity-ai-qat-workflow/main/install.sh -o install.sh; bash install.sh; rm install.sh
```

安装完成后，在 Cursor 中输入 `/debug`、`/fixer`、`/tester` 等指令即可使用！

> ⚠️ **首次使用前**，请确保已配置好 [Unity MCP](#3-unity-mcp-配置重要)

---

## 🔧 前置要求

### 1. 终端工具

| 工具 | 说明 | 检查命令 |
|-----|------|---------|
| `curl` 或 `wget` | 下载文件 | `curl --version` |
| `bash` | 执行脚本 | `bash --version` |

**Windows 用户**推荐使用 **Git Bash**（安装 [Git for Windows](https://git-scm.com/download/win) 后自带）

---

### 2. 开发环境

| 依赖项 | 版本要求 | 说明 |
|-------|---------|------|
| [Cursor](https://cursor.sh/) | 最新版 | AI 代码编辑器 |
| Unity | 2021.3+ | Unity 编辑器 |
| [Unity MCP](https://github.com/CoplayDev/unity-mcp) | **>= 7.0.0** | Unity 与 Cursor 通信桥接 |
| [Unity Test Framework](https://docs.unity3d.com/Packages/com.unity.test-framework@1.1/manual/index.html) | - | `/tester` 指令需要 |

---

### 3. Unity MCP 配置（重要！）

本工具依赖 [Unity MCP](https://github.com/CoplayDev/unity-mcp) 与 Unity 编辑器进行交互。

#### 安装步骤

1. **安装 Unity MCP 插件**
   - 在 Unity 中打开 Package Manager
   - 点击 `+` → `Add package from git URL`
   - 输入：`https://github.com/CoplayDev/unity-mcp.git?path=MCPForUnity`

2. **验证版本**
   - 在 Package Manager 中查看 Unity MCP 版本
   - 确保版本号 >= 7.0.0

3. **打开 MCP 窗口**
   - 菜单：`Window` → `MCP For Unity` → `Toggle MCP Window`
   - 或使用快捷键：`Ctrl+Shift+M`

4. **启动 Session**
   - 在 MCP 窗口中点击 `Start Session` 或类似按钮
   - 确保状态显示连接成功

5. **配置 Cursor**
   - 在 Cursor 的 MCP 配置文件中添加：
   ```json
   {
     "mcpServers": {
       "unityMCP": {
         "url": "http://localhost:8080/mcp"
       }
     }
   }
   ```

详细配置请参考 [Unity MCP 官方文档](https://github.com/CoplayDev/unity-mcp#readme)

---

### 4. Unity Test Framework 检查

如果你需要使用 `/tester` 指令，请确保项目中已安装 Unity Test Framework：

1. 打开 `Window` → `Package Manager`
2. 搜索 `com.unity.test-framework`
3. 如果未安装，点击 `+` → `Add package by name...` → 输入 `com.unity.test-framework`

验证：能正常打开 `Window` → `General` → `Test Runner` 窗口

---

## 📦 安装方式

### 方式一：远程一键安装（推荐）

在 **Unity 项目根目录** 打开终端：

**Git Bash（推荐）**：
```bash
curl -fsSL https://raw.githubusercontent.com/MayoooooG/unity-ai-qat-workflow/main/install.sh | bash
```

**PowerShell**：
```powershell
curl -fsSL https://raw.githubusercontent.com/MayoooooG/unity-ai-qat-workflow/main/install.sh -o install.sh; bash install.sh; rm install.sh
```

> 💡 PowerShell 需要先下载脚本再用 bash 执行，因为 PowerShell 不能直接管道到 bash

### 方式二：本地安装

如果你已经克隆了本仓库：

```bash
# 克隆仓库
git clone https://github.com/MayoooooG/unity-ai-qat-workflow.git

# 进入仓库目录
cd unity-ai-qat-workflow

# 安装到目标项目（必须指定路径）
./install.sh /path/to/your/unity-project

# 示例
./install.sh ../my-game
```

### 方式三：手动安装

```bash
# 创建目录
mkdir -p .cursor/commands
mkdir -p .cursor/standards

cd .cursor/commands

# 下载 Cursor 指令文件
curl -O https://raw.githubusercontent.com/MayoooooG/unity-ai-qat-workflow/main/commands/debug.md
curl -O https://raw.githubusercontent.com/MayoooooG/unity-ai-qat-workflow/main/commands/fixer.md
curl -O https://raw.githubusercontent.com/MayoooooG/unity-ai-qat-workflow/main/commands/tester.md
curl -O https://raw.githubusercontent.com/MayoooooG/unity-ai-qat-workflow/main/commands/plan-workflow.md

# 下载内置规范文档
cd ../standards
curl -O https://raw.githubusercontent.com/MayoooooG/unity-ai-qat-workflow/main/standards/csharp-coding-standard.md
curl -O https://raw.githubusercontent.com/MayoooooG/unity-ai-qat-workflow/main/standards/development-standard.md
```

---

## 📖 使用方法详解

### `/debug` - 控制台调试

```
/debug
```

**执行流程**：
1. 🔍 获取 Unity 控制台日志
2. 🧠 分析可能存在的问题
3. 📝 必要时添加临时调试日志
4. ⚙️ 编译并运行游戏验证
5. 🔄 迭代修复直到问题解决

**提示**：运行游戏后再调用此指令，效果更佳。

---

### `/fixer` - 修复控制台错误

```
/fixer
```

**执行流程**：
1. 📋 获取所有错误和警告信息
2. 🔬 分析每个错误的根本原因
3. 🔧 按优先级逐个修复
4. ✅ 验证修复结果

**提示**：AI 会优先修复阻塞编译的错误，再处理警告。

---

### `/tester` - 运行测试

```
/tester
```

**执行流程**：
1. 🧹 清空控制台
2. ▶️ 运行 EditMode 测试
3. 📊 获取测试结果（JSON 格式）
4. 📝 生成测试报告
5. ✅/❌ 判定成功/失败

**可选**：如果需要运行 PlayMode 测试，可以在对话中说明。

---

### `/plan-workflow` - 开发工作流

```
/plan-workflow
```

**首次使用时**，AI 会引导你配置：
1. 📁 策划案/设计文档地址（如 `Docs/Design`）
2. 📂 AI 输出文档存放地址（如 `Docs/AI`）
3. 📄 项目规范文档地址（可选，如无则使用内置规范）

**配置完成后**：
1. 📖 阅读配置的设计文档目录
2. 📊 盘点当前开发进度
3. 📝 生成 `development_progress.md`
4. ✅ 确定待执行任务

> 配置保存在 `.cursor/workflow-config.json`，可手动编辑

---

## 📁 安装后目录结构

```
你的项目/
├── .cursor/
│   ├── commands/
│   │   ├── debug.md
│   │   ├── fixer.md
│   │   ├── tester.md
│   │   └── plan-workflow.md
│   ├── standards/                   # 内置规范文档
│   │   ├── csharp-coding-standard.md
│   │   └── development-standard.md
│   └── workflow-config.json         # 工作流配置（首次使用后生成）
└── ...
```

---

## 📚 内置规范文档

| 文档 | 说明 |
|-----|------|
| `csharp-coding-standard.md` | C# 代码规范：命名约定、注释标准、Unity 最佳实践 |
| `development-standard.md` | 开发流程规范：需求分析、设计、测试、审查流程 |

如果你的项目有自己的规范，可以在 `/plan-workflow` 首次配置时指定路径。

---

## 📝 更新

```bash
# 远程更新
curl -fsSL https://raw.githubusercontent.com/MayoooooG/unity-ai-qat-workflow/main/install.sh | bash

# 本地更新
cd unity-ai-qat-workflow && git pull && ./install.sh /path/to/project
```

---

## 🗑️ 卸载

```bash
rm -rf .cursor/commands .cursor/standards .cursor/workflow-config.json
```

---

## ❓ 常见问题

### Q: 安装后 Cursor 没有识别到指令？

**A:** 请确保：
1. 文件在 `.cursor/commands/` 目录下
2. 文件扩展名是 `.md`
3. 尝试重启 Cursor

### Q: Unity MCP 连接失败？

**A:** 请确保：
1. Unity 编辑器已打开
2. MCP 窗口已打开（`Window` → `MCP For Unity` → `Toggle MCP Window`）
3. Session 已启动
4. Cursor MCP 配置正确

### Q: `/tester` 报错？

**A:** 可能原因：
1. Unity MCP 版本过低（需要 >= 7.0.0）
2. Unity Test Framework 未安装
3. 项目中没有测试用例

### Q: Windows 下无法运行安装脚本？

**A:** 请使用 **Git Bash**，而不是 PowerShell：
- 右键项目文件夹 → "Git Bash Here"
- 或在 PowerShell 中运行 `bash ./install.sh`

---

## 📄 许可证

MIT License

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

---

## 📋 发布后 TODO

- [ ] 测试 `install.sh` 远程安装
- [ ] 验证所有指令正常工作
