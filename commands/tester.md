---
description: 自动运行 Unity 测试并生成报告，用于验证代码修改后的功能正确性
---

# 运行测试并生成报告

> ⚠️ **依赖**: 需要 Unity MCP >= 7.0.0

此指令定义了在代码改动后自动运行测试并生成报告的标准操作流程（SOP）。

## 执行流程

### 1. 准备阶段
保存所有编辑器与脚本改动，等待 Unity 完成一次脚本编译（若有）。

### 2. 清空控制台
清空 Console，避免旧日志干扰判定：

```pseudo
mcp_unityMCP_read_console({ action: "clear" })
```

### 3. 触发测试

使用 Unity MCP 内置测试工具 `mcp_unityMCP_run_tests`，直接返回测试结果。

#### EditMode 测试（默认必须运行）
```pseudo
mcp_unityMCP_run_tests({ mode: "EditMode" })
```

#### PlayMode 测试（必要时运行）
```pseudo
mcp_unityMCP_run_tests({ mode: "PlayMode" })
```

#### 返回值示例
```json
{
  "success": true,
  "message": "EditMode tests completed: 2/2 passed, 0 failed, 0 skipped",
  "data": {
    "mode": "EditMode",
    "summary": {
      "total": 2,
      "passed": 2,
      "failed": 0,
      "skipped": 0,
      "durationSeconds": 0.27,
      "resultState": "Passed"
    },
    "results": [
      {
        "name": "TestMethodName",
        "fullName": "TestClassName.TestMethodName",
        "state": "Passed",
        "durationSeconds": 0.01,
        "message": null,
        "stackTrace": null
      }
    ]
  }
}
```

### 4. 解析返回值与判定

#### 成功条件
- `data.summary.failed == 0`
- `data.summary.resultState == "Passed"`

#### 失败条件
- `data.summary.failed > 0`
- 任一 `results[].state == "Failed"`

#### 失败处理
若存在失败或错误：
1. 阻断流程
2. 从 `results[]` 中提取失败测试的 `message` 和 `stackTrace`
3. AI 必须中止合并，转入修复流程

### 5. 异常处理
若调用失败或返回异常，收集 Console 日志进行诊断：

```pseudo
mcp_unityMCP_read_console({ action: "get", types: ["error", "warning", "log"], count: "50" })
```

## 超时判定

- **EditMode 测试**：若超过 **10 秒** 测试仍未返回，可能存在问题
- 此时应检查 Console 日志分析原因

## Gate 规则

| 状态 | 条件 | 后续操作 |
|-----|------|---------|
| ✅ PASS | `summary.failed == 0` 且 `resultState == "Passed"` | 可继续开发/合并 |
| ❌ FAIL | 任一测试失败 | 中止，转入修复流程 |
| ⚠️ ERROR | 调用异常或返回错误 | 诊断并恢复 |
