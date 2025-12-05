# Monoglot-NLink

A self-contained, single-language implementation of the NexusLink dynamic component system-no external build tools, no polyglot dependencies, just C and a C compiler.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Build](https://github.com/obinexus/monoglot-nlink/workflows/build/badge.svg)](https://github.com/obinexus/monoglot-nlink/actions)
[![Size](https://img.shields.io/badge/size-%3C%20200%20KB-blue)](https://github.com/obinexus/monoglot-nlink/releases)
[![C11](https://img.shields.io/badge/C-11%2B-green.svg)](https://en.cppreference.com/w/c)

---

## What It Is

Monoglot-NLink is a **zero-dependency** CLI that can

* dynamically load C components (DLL/SO)  
* chain them into single- or multi-pass pipelines  
* minimise their state-machines via the Okpala algorithm  
* report memory, symbols, and version info  
* bootstrap **itself** to under 200 KB

All you need is a C11 compiler (`gcc`, `clang`, `cl`, `tcc`, .).  
No CMake, no Make, no Python, no shell scripts.

---

## Quick Start (30 s)

```bash
# 1. Clone
git clone https://github.com/obinexus/monoglot-nlink.git
cd monoglot-nlink

# 2. Build (literally one file)
gcc -O2 -DNLINK_BUILD -o nlink src/nlink.c

# 3. Run
./nlink --interactive
nexus> load hello
nexus> minimal hello:greet=World
nexus> exit
```

Static build for a **100 KB** single-file executable:

```bash
gcc -O2 -DNLINK_BUILD -static -s -o nlink src/nlink.c
strip nlink
ls -lh nlink
```

---

## Command Cheat-Sheet

| Command | Purpose | Example |
|---------|---------|---------|
| `load <comp> [@ver]` | load a component | `load parser@2.1` |
| `pipeline create` | start a pipeline | `pipeline create mode=multi` |
| `pipeline add-stage` | push a stage | `pipeline add-stage lexer` |
| `pipeline execute` | run it | `pipeline execute` |
| `minimize <file>` | Okpala minimisation | `minimize foo.so level=3` |
| `minimal <expr>` | ultra-short syntax | `minimal logger:log=hi` |
| `stats` | runtime metrics | `stats` |
| `version` | version info | `version --json` |

---

## Minimal Syntax

One-liner Swiss-army knife:

```
nlink component[@version][:function][=args]
```

Examples  
```
nlink base64:encode=hello
nlink json@1.4:validate={"ok":true}
nlink gzip:compress < big.txt > big.gz
```

---

## Self-Bootstrap Demo

Monoglot-NLink can compile **itself** without any build system:

```bash
./nlink --bootstrap            # produces nlink-tiny.exe
./nlink-tiny.exe --bootstrap   # repeat, still works
ls -lh nlink-tiny.exe          # ~180 KB
```

---

## Pipeline Modes

| Mode | Description | When to Use |
|------|-------------|-------------|
| `single-pass` | each stage once | simple transforms |
| `multi-pass` | iterate till fix-point | optimisation loops |
| `auto` | heuristic pick | don't care |

---

## API (Embedding)

Drop `nlink.c` into your project and call:

```c
#include "nlink.c"   /* header-only mode */

NexusContext* ctx = nlink_create_context(NULL);
nlink_load_component(ctx, "math.so");
double (*sin)(double) = nlink_symbol(ctx, "math", "sin");
printf("%f\n", sin(3.1415));
nlink_destroy_context(ctx);
```

---

## Building Variants

| Goal | Command | Size |
|------|---------|------|
| **debug** | `gcc -g -DNLINK_BUILD src/nlink.c -o nlink` | ~400 KB |
| **release** | `gcc -O2 -DNLINK_BUILD src/nlink.c -o nlink` | ~220 KB |
| **static** | `gcc -O2 -static -DNLINK_BUILD src/nlink.c -o nlink && strip nlink` | **< 200 KB** |
| **tiny** | `gcc -Os -march=native -DNLINK_BUILD -s src/nlink.c -o nlink && strip nlink` | **< 150 KB** |

---

## Directory Layout

```
monoglot-nlink/
ÃÄÄ src/
³   ÀÄÄ nlink.c          # single 3 k-line file, everything
ÃÄÄ include/             # public headers (optional)
ÃÄÄ examples/
³   ÃÄÄ hello.c          # minimal component example
³   ÃÄÄ pipeline.nlink   # sample script
³   ÀÄÄ self_build.c     # bootstrap source
ÃÄÄ docs/
³   ÀÄÄ monoglot.md      # this file
ÃÄÄ test/
³   ÀÄÄ ctests.c         # unit tests (compile & run)
ÀÄÄ LICENSE
```

---

## Okpala Minimiser (Level 3)

State-machine reduction shipped in the same file:

```bash
./nlink minimize big.so level=3
# original : 1 247 states, 312 KB
# minimised:   189 states,  71 KB (-77 %)
```

Algorithm: partition-refinement + boolean expression folding.  
Paper: [Okpala 2025 - *State Machine Minimisation & AST Optimisation*](docs/okpala2025.pdf)

---

## Porting Guide

New platform ~ 20 lines:

1. implement `nlink_dlopen` / `nlink_dlsym` wrappers  
2. define `NLINK_PATH_SEP` (`/` or `\`)  
3. adjust `nlink_page_size()` if needed  

Everything else is portable C11.

---

## Contributing

We **only** accept patches that keep the project **monoglot**.  
No new languages, no extra tools, no generated files.  
Open an issue first-simplicity is non-negotiable.

---

## License

MIT - see [LICENSE](LICENSE)  
Copyright ¸ 2025 OBINexus Computing
