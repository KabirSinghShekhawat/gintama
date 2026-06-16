# Gintama

A production-grade consistent hashing implementation in C, inspired by [Ketama](https://github.com/RJ/ketama/).

## Quick start

```sh
make          # dev build  (ASan + UBSan + debug symbols)
make run      # build + run
make check    # cppcheck static analysis
make test     # compile + run tests/
make release  # optimised build, no sanitizers
make clean    # remove obj/ and bin/
```

## Structure

```
├── src/        C source files
├── include/    Public headers
├── tests/      Test runner (compiled separately from src/)
├── obj/        Compiled objects  [git-ignored]
├── bin/        Output binary     [git-ignored]
└── .vscode/    VS Code config (launch, tasks, IntelliSense)
```

## Requirements

- macOS with Xcode Command Line Tools (`xcode-select --install`)
- [Homebrew](https://brew.sh) for `cppcheck` (`brew install cppcheck`)

## Dev build

The default `make` compiles with AddressSanitizer, UndefinedBehaviorSanitizer, and full debug symbols. No Valgrind needed — ASan covers memory errors on Apple Silicon.

## Release build

```sh
make release
```

Compiles with `-O2` and no sanitizer overhead. Enforces the same `-Wall -Wextra -Werror` strictness as the dev build.
