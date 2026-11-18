# Docker 配置导航

主服务仍从仓库根目录的 [Dockerfile](../Dockerfile) 与
[docker-compose.yml](../docker-compose.yml) 构建和启动。

| 目录 | 用途 |
| --- | --- |
| [sandbox/](sandbox/) | 断网、受资源限制的测试子容器镜像 |
| [evaluation/](evaluation/) | 真实历史缺陷的环境镜像，以及评测工具镜像 |
| [verification/](verification/) | 各专项独立服务 Compose 和可选依赖缓存 Dockerfile |
| [../delivery/images.json](../delivery/images.json) | 基础镜像 digest 清单 |

## 构建入口

以下命令从仓库根目录执行，构建上下文为仓库根目录：

```sh
make test-image
docker build -f docker/sandbox/Dockerfile -t repopilot-sandbox:local .
docker build -f docker/evaluation/Dockerfile.real-tasks -t repopilot-real-tasks:local .
docker build -f docker/evaluation/Dockerfile.eval-tools -t repopilot-eval-tools:local .
```

专项 Compose 的构建上下文和测试挂载已显式指回仓库根目录。
服务验收需要脚本准备专用数据库、临时目录和项目名，请通过 `make verify`、
`make migration-test` 及既有 `make ch*-integration` 入口运行。

`verification/Dockerfile.ch*-cached` 沿用其对应专项的可选依赖缓存路径；
`make verify` 继续使用默认锁安装构建。冻结真实语料在
[evals/real/](../evals/real/) 保留其原始 recipe、哈希和镜像身份。

配置私有凭据、源码挂载和部署升级时，遵循[安装手册](../docs/guides/reproducible-delivery.md)、
[数据库迁移](../docs/architecture/database-migrations.md)及现有 Docker 忽略规则。
