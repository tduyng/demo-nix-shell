{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  name = "monorepo";

  buildInputs = with pkgs; [
    git ripgrep fd fnm pnpm esbuild nodejs_24 fish
  ];

  shellHook = ''
    echo "🐟 Starting Fish shell with Nix environment..."
    ${pkgs.fish}/bin/fish -c '
      echo "🏗️  Monorepo root environment"

      set -gx FNM_DIR "$HOME/.local/share/fnm"
      set -gx PNPM_HOME "$HOME/.local/share/pnpm"
      fish_add_path "$PNPM_HOME"
      fnm env --use-on-cd --shell fish | source

      echo ""
      echo "📦 Git (git --version)"
      echo "📦 Node.js (node --version)"
      echo "📦 pnpm (pnpm --version)"
      echo "📦 esbuild (esbuild --version)"
      echo ""
      echo "💡 Fish environment ready!"
    '
  '';

  SHELL = "${pkgs.fish}/bin/fish";
}
