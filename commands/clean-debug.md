---
description: 清理 /debug 产生的临时调试日志（代码里的 [DEBUG-TEMP]）并清空 Unity Console，避免遗留污染
---

# 清理 Debug 临时日志

此指令用于**兜底清理** `/debug` 过程中可能遗留的调试信息，避免因为 AI 上下文不足终止对话或人工遗漏而导致：
- 临时 `Debug.Log` 残留在代码里，污染代码库与 Git 历史
- Console 堆积旧日志，影响下一轮排查与测试结论

## 清理目标

- **清空 Unity Console**：移除历史 Error/Warning/Log 输出，降低干扰。
- **删除代码中的临时日志**：删除所有带 `[DEBUG-TEMP]` 标记的临时调试输出（以及与之强相关的临时变量/临时代码片段）。

> 约定：所有临时调试日志必须带有统一前缀 **`[DEBUG-TEMP]`**，以便可被安全、批量清理。

---

## 执行流程

### 1. 清空 Unity Console

```pseudo
mcp_unityMCP_read_console({ action: "clear" })
```

### 2. 全项目扫描 `[DEBUG-TEMP]`

在代码库中全局搜索以下关键字（至少覆盖 `Assets/` 下所有脚本）：
- `[DEBUG-TEMP]`

并定位所有命中位置（包括注释、字符串、日志输出、临时代码）。

### 3. 删除临时调试日志与相关片段

对每一个命中位置，执行以下规则：

- **必须删除**：所有包含 `[DEBUG-TEMP]` 的 `Debug.Log/LogWarning/LogError` 调用。
- **尽量一并删除**：仅为这些日志服务的临时变量、临时分支、临时计时器/计数器等。
- **严禁误删**：业务必要日志、正式埋点、关键错误日志（必须保留或迁移到正式日志策略）。

### 4. 等待编译并确认无新增错误

```pseudo
mcp_unityMCP_read_console({ action: "get", types: ["error", "warning"], count: "50", include_stacktrace: true })
```

### 5. 复核：确保没有遗留

再次全局搜索 `[DEBUG-TEMP]`，确保搜索结果为 0。

---

## 常见使用时机

- `/debug` 调试到一半被迫中断（上下文不足/对话终止）
- 修复完成后想快速确认代码库无临时日志
- 准备提交 PR 前的“卫生清理”


