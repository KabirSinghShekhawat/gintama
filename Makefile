# ─── Compiler ─────────────────────────────────────────────────────────────────
CC := clang

# ─── Directories ──────────────────────────────────────────────────────────────
SRC_DIR := src
INC_DIR := include
OBJ_DIR := obj
BIN_DIR := bin
TST_DIR := tests

TARGET      := $(BIN_DIR)/app
TEST_RUNNER := $(BIN_DIR)/test_runner

# ─── Sources & Objects ────────────────────────────────────────────────────────
SRCS := $(wildcard $(SRC_DIR)/*.c)
OBJS := $(patsubst $(SRC_DIR)/%.c, $(OBJ_DIR)/%.o, $(SRCS))

# ─── Dev flags (ASan + UBSan, debug symbols, all warnings) ───────────────────
DEV_CFLAGS  := -Wall -Wextra -Werror -pedantic -std=c17 \
               -g -fsanitize=address,undefined -fno-omit-frame-pointer
DEV_LDFLAGS := -fsanitize=address,undefined

# ─── Release flags (optimised, no sanitizers) ─────────────────────────────────
REL_CFLAGS  := -Wall -Wextra -Werror -pedantic -std=c17 -O2
REL_LDFLAGS :=

# ─── Default to dev ───────────────────────────────────────────────────────────
CFLAGS  ?= $(DEV_CFLAGS)
LDFLAGS ?= $(DEV_LDFLAGS)

# ─── Phony targets ────────────────────────────────────────────────────────────
.PHONY: all release run check test clean help

# ─── Default target ───────────────────────────────────────────────────────────
all: $(TARGET)

# ─── Release target ───────────────────────────────────────────────────────────
release: CFLAGS  := $(REL_CFLAGS)
release: LDFLAGS := $(REL_LDFLAGS)
release: clean $(TARGET)
	strip $(TARGET)
	@echo "✓  Release build → $(TARGET)"

# ─── Link ─────────────────────────────────────────────────────────────────────
$(TARGET): $(OBJS) | $(BIN_DIR)
	$(CC) $(LDFLAGS) $^ -o $@
	@echo "✓  Built $(TARGET)"

# ─── Compile ──────────────────────────────────────────────────────────────────
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c | $(OBJ_DIR)
	$(CC) $(CFLAGS) -I$(INC_DIR) -c $< -o $@

# ─── Create dirs on demand ────────────────────────────────────────────────────
$(BIN_DIR) $(OBJ_DIR):
	mkdir -p $@

# ─── Run ──────────────────────────────────────────────────────────────────────
run: all
	./$(TARGET)

# ─── Static analysis ──────────────────────────────────────────────────────────
check:
	cppcheck --enable=all \
	         --suppress=missingIncludeSystem \
	         --error-exitcode=1 \
	         -I$(INC_DIR) \
	         $(SRC_DIR)/
	@echo "✓  cppcheck passed"

# ─── Tests ────────────────────────────────────────────────────────────────────
test: $(wildcard $(TST_DIR)/*.c) | $(BIN_DIR)
	$(CC) $(CFLAGS) -I$(INC_DIR) $^ -o $(TEST_RUNNER)
	./$(TEST_RUNNER)
	@echo "✓  Tests passed"

# ─── Clean ────────────────────────────────────────────────────────────────────
clean:
	rm -rf $(OBJ_DIR) $(BIN_DIR)
	@echo "✓  Cleaned"

# ─── Help ─────────────────────────────────────────────────────────────────────
help:
	@echo ""
	@echo "  make            dev build  (ASan + UBSan + debug symbols)"
	@echo "  make release    release build  (O2, stripped, no sanitizers)"
	@echo "  make run        build + run"
	@echo "  make check      cppcheck static analysis"
	@echo "  make test       compile + run tests/"
	@echo "  make clean      remove obj/ and bin/"
	@echo ""
