# Auto-detect main .ls file and project name
MAIN_LS := $(wildcard src/*.ls)
PROJECT := $(basename $(notdir $(MAIN_LS)))
JS_FILE := $(PROJECT).js
TIC_FILE := $(PROJECT).tic

# TIC-80 executable
TIC80 := tic80

.PHONY: help dev run build web clean

help:
	@echo "TIC-80 Development Commands:"
	@echo "  make dev    - Auto-reload development mode"
	@echo "  make run    - Single run of the game"
	@echo "  make build  - Build the .tic cartridge"
	@echo "  make web    - Export for web deployment"
	@echo "  make clean  - Clean generated files"

# Compile LiveScript to JavaScript
compile:
	@lsc --compile --bare --no-header --output . $(MAIN_LS)

# Build the .tic cartridge
build: compile
	@$(TIC80) --skip --cli --cmd "load $(JS_FILE) & save $(TIC_FILE) & exit"

# Single run
run: compile
	@$(TIC80) $(JS_FILE)

# Auto-reload development mode
dev:
	@echo "Starting auto-reload development mode..."
	@echo "Watching $(MAIN_LS) for changes..."
	@if command -v fswatch > /dev/null; then \
		fswatch -o $(MAIN_LS) | xargs -n1 -I{} sh -c 'lsc --compile --bare --no-header --output . $(MAIN_LS) && $(TIC80) $(JS_FILE)'; \
	elif command -v entr > /dev/null; then \
		echo $(MAIN_LS) | entr sh -c 'lsc --compile --bare --no-header --output . $(MAIN_LS) && $(TIC80) $(JS_FILE)'; \
	else \
		echo "Error: Neither fswatch nor entr found. Install one:"; \
		echo "  brew install fswatch  # Preferred on macOS"; \
		echo "  brew install entr     # Cross-platform alternative"; \
		exit 1; \
	fi

# Export for web
web: build
	@mkdir -p web
	@$(TIC80) --skip --cli --cmd "load $(TIC_FILE) & export html web/$(PROJECT).html & exit"
	@echo "Web export complete: web/$(PROJECT).html"

# Clean generated files
clean:
	@rm -f $(JS_FILE) $(TIC_FILE)
	@rm -rf web
	@echo "Cleaned generated files"