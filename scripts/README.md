# 脚本导航

所有命令从仓库根目录执行，优先使用 [Makefile](../Makefile) 提供的入口。
脚本沿用已有参数、环境变量、调用预算与资源清理规则。

| 目录 | 内容 | 常用入口 |
| --- | --- | --- |
| [development/](development/) | 迁移、专项服务验收、API smoke 和 Worker 审批恢复 | `make verify`、`make smoke`、`make smoke-recovery` |
| [experiments/](experiments/) | 真实评测、检索诊断和冻结语料验证 | `make eval-real-reproduce`、`make eval-real-retrieval` |
| [tools/](tools/) | 审批请求载荷、模型连接检查、历史兼容与验证汇总 | 由上述入口或运行手册调用 |

## 常用脚本

- [development/ch18_integration.sh](development/ch18_integration.sh)：`make verify` 的独立服务入口。
- [development/smoke.sh](development/smoke.sh)、[development/recovery_smoke.sh](development/recovery_smoke.sh)：检查指定的运行实例。
- [experiments/eval_real.sh](experiments/eval_real.sh)：真实模型评测编排；`--reproduce-only` 仅复现。
- [experiments/eval_real_retrieval.py](experiments/eval_real_retrieval.py)：issue-only 文件检索诊断。
- [experiments/verify_frozen_corpus.py](experiments/verify_frozen_corpus.py)：冻结语料元数据和复现检查。
- [tools/approval_payload.py](tools/approval_payload.py)：从审批视图构造绑定载荷。
- [tools/check_model_connections.py](tools/check_model_connections.py)：默认只读检查；真实请求需适用授权与预算。
- [tools/verification_summary.py](tools/verification_summary.py)：导出白名单计数与来源摘要。
- [tools/check_ch07a_compatibility.py](tools/check_ch07a_compatibility.py)：历史案例元数据、权限及检索兼容检查。

运行条件见[安装与验证手册](../docs/guides/reproducible-delivery.md)；
真实模型协议见[评测文档](../docs/evaluation/real-evaluation-protocol.md)。
