---
description: 使用 Unity MCP 获取控制台日志，分析运行时问题并进行调试修复
---

# Unity 控制台调试

此指令用于通过 Unity MCP 获取游戏运行时的控制台日志，分析可能存在的问题并进行修复。

## 执行流程

### 1. 获取日志
使用 Unity MCP 获取控制台日志进行分析：

```pseudo
mcp_unityMCP_read_console({ action: "get", types: ["error", "warning", "log"], count: "50" })
```

### 2. 分析问题
根据日志内容，分析出可能存在的问题，确定问题根因。

### 3. 添加调试日志（可选）
可在必要处添加临时调试日志，需满足以下要求：
- 日志需要有**明显标志**（如 `[DEBUG-TEMP]` 前缀）
- 等用户确认问题修复完成后，统一删除这些临时日志

### 4. 编译与验证
若已添加日志或进行代码修改：
1. 暂停几秒等待 Unity 进行编译
2. 若 Unity 编辑器在运行中，应先停止运行
3. 编译完成后运行游戏
4. 查看日志，分析原因进行修改

```pseudo
# 停止游戏（如果正在运行）
mcp_unityMCP_manage_editor({ action: "stop" })

# 等待编译完成后启动游戏
mcp_unityMCP_manage_editor({ action: "play", wait_for_completion: true })

# 获取新日志
mcp_unityMCP_read_console({ action: "get", types: ["error", "warning", "log"], count: "50" })
```

### 5. 迭代修复
重复步骤 2-4，直到问题解决。

## 注意事项

- 全程都需要使用 Unity MCP，可以帮助你获取日志、开始和关闭游戏
- 在开始游戏和编译阶段可能需要等待时间，可能有 **1 分钟以上** 的情况
- 修复完成后，记得清理所有临时调试日志（统一使用 `[DEBUG-TEMP]` 标记）
- 若因上下文不足/对话终止导致遗留，可直接运行 `/clean-debug` 一键兜底清理

