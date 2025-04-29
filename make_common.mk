SHELL := /bin/bash
.ONESHELL:
.SILENT:

GREEN := \033[0;32m
RED := \033[0;31m
YELLOW := \033[0;33m
BLUE := \033[0;34m
NC := \033[0m


define start_msg
	@trap 'echo -e "$(RED)[ERROR]$(NC) Failed at line $$LINENO at $$(date +%H:%M:%S)"; exit 1' ERR; \
	set -e; \
	echo -e "$(BLUE)[START]$(NC) $(1) at `date +%H:%M:%S`"
endef

define success_msg
	echo -e "$(GREEN)[SUCCESS]$(NC) $(1) at `date +%H:%M:%S`"
endef

define info_msg
	echo -e "$(BLUE)[INFO]$(NC) $(1)"
endef

define warn_msg
	echo -e "$(YELLOW)[WARNING]$(NC) $(1)"
endef

