# 任务 API 与人工审批

本页保留原 README 中的任务创建、绑定审批和可选发布操作说明。
命令从仓库根目录执行，字段与接口契约不变。

## 确定性 smoke 的准备

优先通过 `make verify` 使用独立实例。检查已有实例前，核对其 `.env` 的 provider 选择；
确认目标实例可以重建后，可用下列显式 Mock 覆盖准备确定性 smoke：

```sh
MODEL_PROVIDER=mock MODEL_NAME=deterministic-mock-v1 REVIEW_MODEL_PROVIDER= \
  OPENAI_API_KEY= OPENAI_BASE_URL= GITHUB_WRITE_ENABLED=false \
  docker compose up --build -d --force-recreate api worker
make smoke
make smoke-recovery
```

## 创建、审批和发布

Create a task:

```bash
curl -X POST http://localhost:8000/api/v1/tasks \
  -H 'Content-Type: application/json' \
  -d '{
    "repository_url": "https://github.com/owner/repository",
    "issue_title": "Fix the failing parser edge case",
    "issue_body": "Describe expected behavior and acceptance criteria.",
    "base_branch": "main",
    "test_command": "python -m pytest -q"
  }'
```

When the task reaches `awaiting_approval`, inspect `GET /api/v1/tasks/TASK_ID/approval` for the
frozen candidate, complete manifest, test evidence and Reviewer risk. Fetch the full Diff from
`/api/v1/tasks/TASK_ID/candidates/CANDIDATE_ID/diff`. Then resume the durable thread using the exact
bindings from that view (the helper builds the required `approval-v2` body):

```bash
curl -fsS http://localhost:8000/api/v1/tasks/TASK_ID/approval \
  | python3 scripts/approval_payload.py 'Reviewed full diff and test evidence' \
  | curl -fsS -X POST http://localhost:8000/api/v1/tasks/TASK_ID/approval \
      -H 'Content-Type: application/json' --data-binary @-
```

Legacy boolean-only requests return 422. A committed decision whose Redis delivery fails returns
202 with `saved=true`, `dispatch_state=pending` and a decision ID. Explicitly retry that ID at
`POST /api/v1/tasks/TASK_ID/approval/dispatch`; do not create another approval. Old unbound
checkpoints require a new task and fresh tests. See [candidate and approval contracts](../architecture/candidate-approvals.md).
Publication uses a durable intent bound to the approved artifact, evidence, decision and base SHA.
It creates deterministic Git objects and a unique branch, and reconciles uncertain responses before
continuing. Ambiguous PR creation never triggers a second blind create. Base movement requires
retesting and approval; cancellation preserves observed remote effects. Receipts remain available at
`GET /api/v1/tasks/{task_id}/publication`. See [publication/recovery](../architecture/publication.md).
Automatic outbox delivery and Worker fencing remain later change cards.

GitHub writes are off by default. To enable draft-PR creation, set all of the following locally:

```dotenv
GITHUB_WRITE_ENABLED=true
GITHUB_TOKEN=your-fine-grained-token
GITHUB_ALLOWED_OWNERS=your-account-or-organization
```

The token should be fine-grained and limited to the intended repositories. RepoPilot never needs
permission to merge a pull request.

Use a feature branch and pull request for repository changes. The included PR template requires
test, evaluation, recovery, security, and resume-claim evidence before review.
