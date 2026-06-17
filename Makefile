COMPOSE ?= docker compose
SERVICE ?= 3x-ui
PANEL_PORT ?= 14523
DATA_DIR ?= data
BACKUP_DIR ?= backups

.DEFAULT_GOAL := help

.PHONY: prepare up set-panel-port down restart logs ps backup

prepare:
	@mkdir -p "$(DATA_DIR)/etc-x-ui" "$(DATA_DIR)/certs" "$(BACKUP_DIR)"

up: prepare
	$(COMPOSE) up -d

down:
	$(COMPOSE) down

restart:
	$(COMPOSE) restart

logs:
	$(COMPOSE) logs -f "$(SERVICE)"

ps:
	$(COMPOSE) ps

backup:
	@if [ ! -d "$(DATA_DIR)/etc-x-ui" ]; then \
		echo "No settings directory found: $(DATA_DIR)/etc-x-ui"; \
		echo "Start the service first with: make up"; \
		exit 1; \
	fi
	@mkdir -p "$(BACKUP_DIR)"
	@timestamp=$$(date +%Y%m%d-%H%M%S); \
	archive="$(BACKUP_DIR)/3x-ui-settings-$$timestamp.tar.gz"; \
	paths="$(DATA_DIR)/etc-x-ui"; \
	if [ -d "$(DATA_DIR)/certs" ]; then paths="$$paths $(DATA_DIR)/certs"; fi; \
	tar -czf "$$archive" $$paths; \
	echo "Backup created: $$archive"

help:
	@echo "Usage: make <target>"
	@echo "Targets:"
	@echo "  up - Start the service"
	@echo "  down - Stop the service"
	@echo "  restart - Restart the service"
	@echo "  logs - Show logs"
	@echo "  ps - Show running containers"
	@echo "  backup - Create a backup of the settings"
	@echo "  help - Show this help message"