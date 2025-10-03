# Auto-detect all .ls files and project name
LS_FILES := $(wildcard src/*.ls)
PROJECT := traffic
JS_FILE := $(PROJECT).js
TIC_FILE := $(PROJECT).tic

# TIC-80 executable
TIC80 := tic80
TIC80_FLAGS := --fs . --skip

.PHONY: help dev run build web clean compile

help:
	@echo "TIC-80 Development Commands:"
	@echo "  make compile - Compile LiveScript to JavaScript"
	@echo "  make dev     - Auto-reload development mode"
	@echo "  make run     - Single run of the game"
	@echo "  make build   - Build the .tic cartridge"
	@echo "  make web     - Export for web deployment"
	@echo "  make clean   - Clean generated files"

# Compile LiveScript to JavaScript
compile:
	@if [ -z "$(LS_FILES)" ]; then \
		echo "Error: No .ls files found in src/"; \
		exit 1; \
	fi
	@if ! command -v lsc >/dev/null 2>&1; then \
		echo "Error: LiveScript not found. Install with: npm install -g livescript"; \
		exit 1; \
	fi
	@echo "Compiling LiveScript files..."
	@lsc --compile --bare --no-header --output .build $(LS_FILES)
	@mkdir -p .build
	@echo "// title:   Traffic" > $(JS_FILE)
	@echo "// author:  Carl Lange" >> $(JS_FILE)
	@echo "// desc:    Road deck-builder game" >> $(JS_FILE)
	@echo "// site:    redfloatplane.lol" >> $(JS_FILE)
	@echo "// license: MIT" >> $(JS_FILE)
	@echo "// version: 0.1" >> $(JS_FILE)
	@echo "// script:  js" >> $(JS_FILE)
	@echo "" >> $(JS_FILE)
	@cat .build/sprites.js >> $(JS_FILE)
	@cat .build/cards.js >> $(JS_FILE)
	@cat .build/traffic.js >> $(JS_FILE)
	@echo "Compiled to $(JS_FILE)"

# Single run
run: compile
	$(TIC80) $(TIC80_FLAGS) --cmd "new js & import code $(JS_FILE) & run"

# Auto-reload development mode
dev: compile
	@if ! command -v fswatch >/dev/null 2>&1 && ! command -v entr >/dev/null 2>&1; then \
		echo "Error: Neither fswatch nor entr found. Install one:"; \
		echo "  brew install fswatch  # Preferred on macOS"; \
		echo "  brew install entr     # Cross-platform alternative"; \
		exit 1; \
	fi
	@echo "Starting auto-reload development mode..."
	@echo "Watching src/*.ls for changes..."
	@if command -v fswatch > /dev/null; then \
		fswatch -o src/ | while read; do \
			echo "LiveScript files changed, recompiling..."; \
			make compile && $(TIC80) $(TIC80_FLAGS) --cmd "new js & import code $(JS_FILE) & run"; \
		done; \
	elif command -v entr > /dev/null; then \
		find src -name "*.ls" | entr -r sh -c 'make compile && $(TIC80) $(TIC80_FLAGS) --cmd "new js & import code $(JS_FILE) & run"'; \
	fi

# Build the .tic cartridge
build: compile
	$(TIC80) $(TIC80_FLAGS) --cmd "new js & import code $(JS_FILE) & save $(TIC_FILE)"
	@echo "Built $(TIC_FILE)"

# Export for web
web: build
	$(TIC80) $(TIC80_FLAGS) --cmd "load $(TIC_FILE) & export html $(PROJECT)"
	@echo "Exported $(PROJECT) for web"

# Clean generated files
clean:
	@echo "Cleaning generated files..."
	@rm -f $(JS_FILE) $(TIC_FILE)
	@rm -f *.html *.wasm *.zip
	@rm -rf web .build
	@echo "Clean complete"
