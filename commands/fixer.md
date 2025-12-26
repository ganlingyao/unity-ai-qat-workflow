---
description: 获取 Unity 控制台中的警告和报错信息，分析原因并进行修复
---

# 修复控制台错误

此指令用于快速获取 Unity 控制台中的警告和报错信息，分析原因并进行修复。

## 执行流程

### 1. 获取错误信息
使用 Unity MCP 获取控制台中的警告和报错信息：

```pseudo
mcp_unityMCP_read_console({ 
    action: "get", 
    types: ["error", "warning"], 
    count: "100",
    include_stacktrace: true 
})
```

### 2. 分析错误原因
根据获取的信息：
- 分析每个错误/警告的根本原因
- 确定错误之间的关联性（一个错误可能导致多个后续错误）
- 优先处理编译错误，再处理运行时错误

### 3. 修复错误
按优先级逐个修复：
1. **编译错误**（红色）- 必须首先修复，否则代码无法运行
2. **运行时错误**（红色）- 影响游戏正常运行
3. **警告**（黄色）- 潜在问题，建议修复

### 4. 验证修复
修复后重新获取控制台信息，确认错误已清除：

```pseudo
# 清空控制台
mcp_unityMCP_read_console({ action: "clear" })

# 等待编译完成后重新获取
mcp_unityMCP_read_console({ action: "get", types: ["error", "warning"], count: "50" })
```

## 常见错误类型

| 错误类型 | 处理方式 |
|---------|---------|
| CS0103: 名称不存在 | 检查拼写、命名空间引用 |
| CS0246: 找不到类型 | 添加 using 或检查程序集引用 |
| NullReferenceException | 添加空值检查或确保初始化 |
| MissingReferenceException | 检查 Inspector 引用是否丢失 |

## 注意事项

- 修复一个错误后可能会暴露更多错误，这是正常现象
- 如果错误数量很多，优先修复最底层的错误
- 对于第三方插件的警告，评估是否需要处理

