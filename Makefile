.PHONY: up down build logs test lint migration-test ch10-migration-test ch02b-integration ch03a-integration ch05a-integration ch03b-integration smoke smoke-recovery eval eval-real eval-real-reproduce eval-real-retrieval

up:
	docker compose up --build -d

down:
	docker compose down

build:
	docker compose build

logs:
	docker compose logs -f api worker

.PHONY: test-image check doctor verify
test-image:
	docker build -f Dockerfile --target integration-test -t repopilot:test .

test: test-image
	docker run --rm --network none repopilot:test python -m pytest --cov=repopilot --cov-report=term-missing --cov-fail-under=70 -q

lint: test-image
	docker run --rm --network none repopilot:test ruff check .

check: lint test eval

doctor: test-image
	docker run --rm --network none repopilot:test repopilot-doctor

verify:
	./scripts/development/ch18_integration.sh

.PHONY: demo
demo: test-image
	mkdir -p reports/demo
	docker run --rm --network none --read-only --cap-drop ALL \
		--security-opt no-new-privileges --memory 512m --pids-limit 128 \
		--tmpfs /tmp:rw,nosuid,size=128m --user "$$(id -u):$$(id -g)" \
		-v "$$(pwd)/reports/demo:/demo-output" repopilot:test \
		repopilot-demo --decision approve --output /demo-output

migration-test:
	./scripts/development/migration_integration.sh

ch10-migration-test:
	./scripts/development/ch10_migration_integration.sh

ch02b-integration:
	./scripts/development/ch02b_integration.sh

ch03a-integration:
	./scripts/development/ch03a_integration.sh

ch05a-integration:
	./scripts/development/ch05a_integration.sh

ch03b-integration:
	./scripts/development/ch03b_integration.sh

smoke:
	./scripts/development/smoke.sh

smoke-recovery:
	./scripts/development/recovery_smoke.sh

eval: test-image
	docker run --rm --network none repopilot:test python -m repopilot.evaluation --provider mock --dataset evals/cases.jsonl --fail-on-regression

eval-real:
	bash scripts/experiments/eval_real.sh

eval-real-reproduce:
	bash scripts/experiments/eval_real.sh --reproduce-only

eval-real-retrieval:
	docker run --rm --network none \
		-v "$$(pwd)/src:/app/src:ro" \
		-v "$$(pwd)/scripts/experiments/eval_real_retrieval.py:/app/scripts/experiments/eval_real_retrieval.py:ro" \
		-v "$$(pwd)/evals:/app/evals:ro" \
		-v "$$(pwd)/reports/real-corpus-cache/thefuck:/source:ro" \
		-v "$$(pwd)/reports:/app/reports" \
		repopilot-eval-tools:local python scripts/experiments/eval_real_retrieval.py \
			--source /source --output reports/real-retrieval.json

.PHONY: ch06a-integration
ch06a-integration:
	./scripts/development/ch06a_integration.sh

.PHONY: ch06c-integration
ch06c-integration:
	./scripts/development/ch06c_integration.sh

.PHONY: ch07a-integration
ch07a-integration:
	./scripts/development/ch07a_integration.sh
