# 仓库目录整理 · 2026-11-18

参考本机 Chi-Agent 的源码布局（`Kaggle@9680c4d`）：
将开发、实验和工具脚本分组，将辅助镜像集中到 Docker 目录，并以 README 提供统一导航。

本次按局部文件整理处理，保留应用 Python 模块、API、数据契约与既有 Make 命令。
现有 `Openspec.md` 继续记录行为和路线图；没有初始化 OpenSpec CLI 或改变规格的交付状态。

## 路径对照

| 原位置 | 当前维护位置 |
| --- | --- |
| `scripts/ch*_integration.sh`、迁移与 smoke | `scripts/development/` |
| `scripts/eval_real.sh`、检索诊断与冻结语料检查 | `scripts/experiments/` |
| 审批载荷、连接检查、兼容检查与验证汇总脚本 | `scripts/tools/` |
| `Dockerfile.sandbox` | `docker/sandbox/Dockerfile` |
| `Dockerfile.real-tasks`、`Dockerfile.eval-tools` | `docker/evaluation/` |
| `docker-compose.ch*-test.yml`、`Dockerfile.ch*-cached` | `docker/verification/` |
| 架构和当前契约文档 | `docs/architecture/` |
| 安装、演示和模型配置 | `docs/guides/` |
| 评测协议、结果和失败观察 | `docs/evaluation/` |
| 按日期保留的专项验收 | `docs/verification/` |
| 交付状态、设计取舍和版本说明 | `docs/project/` |
| 中断计划、修正方案和旧交接 | `docs/archive/` |

共迁移 80 份文件。同步更新 Make、Docker COPY、Compose 相对上下文、CI 路径过滤、
脚本定位、测试引用与文档链接。主 Dockerfile、主 Compose 及 Reviewer override 保留根目录入口。
根目录版本文件由 30 份减少为 17 份。Ruff 显式将 Docker SDK 标记为第三方依赖，
避免新增的部署目录被导入排序规则识别为本地 Python 模块。

`src/`、`evals/`、`examples/`、`docs/evidence/`、`requirements/`、`delivery/`
及 `uv.lock` 的既有文件保持原始字节。
本地原始 reports、工作区和凭据沿用既有位置；历史 JSON 中的路径保留当时版本身份。

## 验证

| 检查 | 本次结果 |
| --- | --- |
| 项目完整 lint | 通过；使用已有 `repopilot:test` 的锁定依赖，只读挂载当前源码 |
| 离线 pytest | **510 passed / 45 skipped**，73.89 秒；服务条件用例未在本轮执行 |
| 确定性 Mock 回归 | **10/10**，权限、测试门槛和人工审批路径通过 |
| 依赖锁 | `uv lock --check --offline` 通过，原 `uv.lock` 未变 |
| Compose 配置 | 8 份主服务／专项配置解析通过；除移动后的 Dockerfile 路径外，实际服务、构建上下文与挂载等价 |
| Make | 原有 26 个目标全部保留并通过 dry-run，17 处脚本引用均存在 |
| 静态与链接 | 185 份 Python 解析、15 份 shell 语法检查通过；444 个本地文档文件引用无缺失 |
| 固定输入 | 170 份源码、语料、证据及锁定文件的原始字节一致；3 份移位的 sandbox／evaluation Dockerfile 原字节一致 |
| 独立镜像构建 | 默认 Dockerfile 的 `integration-test` 阶段构建通过，镜像为 `repopilot:layout-20261118` |
| 新镜像离线预检 | doctor、模型检查脚本的 CLI 入口、23 例冻结语料元数据检查通过；真实模型请求 0 |

离线检查使用断网、只读根文件系统、无凭据与 Docker socket 挂载的临时容器。
首次 pytest 的默认 `workspaces/` 仍指向只读应用目录，出现 22 failed / 488 passed / 45 skipped；
设置独立的 `WORKSPACE_ROOT=/tmp/repopilot-workspaces` 后，同一源码得到上述 510 passed。
未修改测试断言或应用逻辑来绕过环境错误。

首次禁用构建容器网络的镜像构建，因缺少 apt 缓存而无法解析 Debian 镜像源，
随后按默认构建方式验证成功，并在新镜像中完成离线预检。原始验证文件保存在本机临时目录
`/private/tmp/repopilot-layout-20261118/`，不作为公开评测数据提交。

本次未重跑独立 PostgreSQL／Redis／Docker 服务故障矩阵、实际 Worker 重启或真实模型实验。
历史 555 用例零跳过 CI 和真实模型结果仍按原日期、实现身份及分母解释。
本次为文件整理，未创建 OpenSpec Change。用户于 2026-11-18 明确授权提交并推送；
提交与远端分支身份以 Git 记录为准，PR 和合并状态单独记录。
