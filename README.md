# Node.js monorepo with nix flakes + direnv

Modern Node.js/TypeScript monorepo setup using Nix for reproducible development environments.

## Quick start

### Prerequisites

- [Nix](https://determinate.systems/nix-installer/) with flakes enabled
- [direnv](https://direnv.net/)

### Setup

```bash
cd demo-nix-shell
direnv allow
pnpm install
```

## Development shells

### Automatic

```bash
cd demo-nix-shell  # direnv loads default shell automatically
```

### Manual

```bash
nix develop -c fish            # Default: Node.js + pnpm only
nix develop .#databases -c fish # + PostgreSQL, Redis, Docker
nix develop .#testing -c fish  # + Docker, PostgreSQL for tests
nix develop .#devops -c fish   # + Kubernetes, Helm
```

### Shell compatibility

Works with any shell - automatically detects your preference:

```bash
# Uses your default $SHELL (zsh, fish, bash, etc.)
nix develop
```

## What Nix provides vs pnpm

**Nix manages:**

- Node.js runtime (version 24)
- pnpm package manager
- System services (PostgreSQL, Redis, Docker)

**pnpm manages dependencies:**

- TypeScript, Biome, Turbo, Vitest
- All application dependencies
- Build and testing tools

## Project structure

```bash
❯ lt
 .
├──  .envrc
├──  .nvmrc
├──  flake.lock
├──  flake.nix
├──  packages
│   └──  shared-utils
│       ├──  package.json
│       └──  tsconfig.json
└── 󰂺 README.md
```
