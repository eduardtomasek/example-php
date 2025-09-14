# Docker PHP Development Makefile with Composer
# Použití: make <command>

.PHONY: help up down restart logs shell build clean status install

# Default target
help: ## Zobrazit nápovědu
	@echo "🐳 Docker PHP Development Commands with Composer"
	@echo "=============================================="
	@grep -E '^[a-zA-Z_-]+:.*?## .*$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $1, $2}'
	@echo ""
	@echo "🌐 Aplikace: http://localhost:8080"
	@echo "🐛 Debug info: http://localhost:8080?route=debug"

up: ## Spustit aplikaci (builds if needed)
	docker-compose up -d --build
	@echo "🚀 Aplikace spuštěna na http://localhost:8080"
	@echo "📦 Composer balíčky jsou nainstalovány v Docker kontejneru"

dev: ## Spustit v development módu s logy
	docker-compose up --build

down: ## Zastavit aplikaci
	docker-compose down

restart: ## Restartovat aplikaci (rychlé pro změny v kódu)
	docker-compose restart php-app
	@echo "🔄 PHP kontejner restartován"

restart-all: ## Restartovat všechny služby
	docker-compose restart
	@echo "🔄 Všechny služby restartovány"

rebuild: ## Rebuild a restart (pro změny v Dockerfile nebo composer.json)
	docker-compose down
	docker-compose up -d --build --no-cache
	@echo "🏗️  Aplikace přestavěna s novými Composer balíčky"

hard-restart: ## Úplný restart (zastaví, odstraní a spustí znovu)
	docker-compose down
	docker-compose up -d --build
	@echo "💥 Tvrdý restart dokončen s rebuild"

logs: ## Zobrazit logy
	docker-compose logs -f php-app

logs-all: ## Zobrazit logy všech služeb
	docker-compose logs -f

shell: ## Vstoupit do PHP kontejneru
	docker exec -it test-php-app bash

composer-install: ## Spustit composer install v kontejneru
	docker-compose run --rm composer
	@echo "📦 Composer balíčky reinstanovány"

composer-shell: ## Vstoupit do composer kontejneru
	docker-compose run --rm --profile tools composer bash

status: ## Zobrazit status kontejnerů
	docker-compose ps
	@echo ""
	docker stats test-php-app --no-stream

clean: ## Vyčistit vše (kontejnery, volumes, images)
	docker-compose down -v
	docker system prune -f
	@echo "🧹 Vyčištěno (včetně vendor složky)"

# Rychlé příkazy pro development
watch: ## Spustit a sledovat logy (ideální pro development)
	docker-compose up --build

quick-restart: ## Nejrychlejší restart pro změny v PHP kódech
	docker-compose restart php-app &&# Docker PHP Development Makefile
# Použití: make <command>

.PHONY: help up down restart logs shell build clean status

# Default target
help: ## Zobrazit nápovědu
	@echo "🐳 Docker PHP Development Commands"
	@echo "=================================="
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'
	@echo ""
	@echo "🌐 Aplikace: http://localhost:8080"

up: ## Spustit aplikaci
	docker-compose up -d
	@echo "🚀 Aplikace spuštěna na http://localhost:8080"

dev: ## Spustit v development módu s logy
	docker-compose up

down: ## Zastavit aplikaci
	docker-compose down

restart: ## Restartovat aplikaci (rychlé pro změny v kódu)
	docker-compose restart php-app
	@echo "🔄 PHP kontejner restartován"

restart-all: ## Restartovat všechny služby
	docker-compose restart
	@echo "🔄 Všechny služby restartovány"

rebuild: ## Rebuild a restart (pro změny v Docker konfiguraci)
	docker-compose down
	docker-compose up -d --build
	@echo "🏗️  Aplikace přestavěna a spuštěna"

hard-restart: ## Úplný restart (zastaví, odstraní a spustí znovu)
	docker-compose down
	docker-compose up -d
	@echo "💥 Tvrdý restart dokončen"

logs: ## Zobrazit logy
	docker-compose logs -f php-app

logs-all: ## Zobrazit logy všech služeb
	docker-compose logs -f

shell: ## Vstoupit do PHP kontejneru
	docker exec -it test-php-app bash

status: ## Zobrazit status kontejnerů
	docker-compose ps
	@echo ""
	docker stats test-php-app --no-stream

clean: ## Vyčistit vše (kontejnery, volumes, images)
	docker-compose down -v
	docker system prune -f
	@echo "🧹 Vyčištěno"

# Rychlé příkazy pro development
watch: ## Spustit a sledovat logy (ideální pro development)
	docker-compose up

quick-restart: ## Nejrychlejší restart pro změny v PHP kódech
	docker-compose restart php-app && echo "✅ Restart dokončen - refresh stránku!"

# Test příkazy  
test-connection: ## Otestovat připojení k aplikaci
	@curl -s http://localhost:8080 > /dev/null && echo "✅ Aplikace běží!" || echo "❌ Aplikace neodpovídá"