# 文档导航

从[项目 README](../README.md)了解定位和运行入口，从[能力证据索引](evidence-index.md)核对实现与验证范围。
文档按用途分组；历史结果保留原日期、源码身份和分母。

## 运行与接入

- [演示和真实任务路径](guides/demo.md)
- [任务 API、绑定审批和可选发布](guides/task-api.md)
- [依赖锁定、安装、环境排查与分层 CI](guides/reproducible-delivery.md)
- [模型与 Reviewer 接入](guides/model-providers.md)
- [本地授权 CLI](guides/chatgpt-authorization.md)

## 架构与行为契约

- [系统架构](architecture/overview.md) · [运行时边界](architecture/runtime-correctness.md)
- [任务路由](architecture/task-routing.md) · [代码检索](architecture/retrieval.md)
- [工作区权限](architecture/workspace-capabilities.md) · [公开数据与私有状态](architecture/data-boundaries.md)
- [候选代次](architecture/candidate-generations.md) · [人工审批](architecture/candidate-approvals.md)
- [发布意图与远端对账](architecture/publication.md)
- [模型调用预算](architecture/model-call-control.md) · [取消与截止](architecture/execution-control.md)
- [数据库迁移](architecture/database-migrations.md) · [受信任项目适配](architecture/project-adapters.md)

## 评测与历史结果

- [评测总览](evaluation/overview.md) · [真实模型协议](evaluation/real-evaluation-protocol.md)
- [冻结语料与来源](evaluation/real-task-corpus.md) · [重复评测与统计口径](evaluation/repeated-evaluations.md)
- 2026-09-09：[结果与检索诊断](evaluation/real-evaluation-results-2026-09-09.md) · [失败观察](evaluation/failure-analysis-2026-09-09.md)
- 2026-10-23：[三策略结果](evaluation/real-evaluation-results-2026-10-23.md) · [失败观察](evaluation/failure-analysis-2026-10-23.md)

## 交付与验证

- [交付状态](project/delivery-status-2026-10-24.md) · [设计取舍](project/design-decisions.md)
- [版本说明草稿](project/release-notes.md) · [目录整理记录](project/repository-layout.md)
- [专项验收记录目录](verification/)：按原日期和任务编号保留。
- [公开机器证据目录](evidence/)：保持原始 JSON 字节和身份；历史报告中的路径属于其当时版本。
- [历史计划与交接](archive/)：包含初试中断、修正方案和阶段 checkpoint，不作为新的验收结论。

## 维护规则

新运行手册放入 `guides/`，当前行为约定放入 `architecture/`，评测方法和结果放入
`evaluation/`，专项验收记录放入 `verification/`。交付状态和设计材料归入 `project/`。
新增文档时更新本页，并核对从文档位置解析的相对链接。

开发任务继续遵循[贡献指南](../CONTRIBUTING.md)和[既有规范](../Openspec.md)；
涉及正式 OpenSpec Change 时，按用户批准与仓库流程执行。
