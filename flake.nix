{
  description = "Modern Node.js/TypeScript monorepo with Nix flakes and direnv";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        # Configuration - easily customizable
        config = {
          nodejs = pkgs.nodejs_24; # Change Node.js version here
        };

        # Base tools that everyone needs
        baseDevTools = with pkgs; [
          config.nodejs
          nodePackages.pnpm
          esbuild

          # Common utilities
        ];

        # Minimal setup script for direnv compatibility
        setupScript = ''
          # Add node_modules/.bin to PATH for any shell
          export PATH="$PWD/node_modules/.bin:$PATH"

          # Nix environment confirmation with tools versions
          echo -e "\033[32m❄️ Nix development environment activated\033[0m"
          echo -e "\033[32m🚀 Node.js $(node --version) + pnpm $(pnpm --version) ready\033[0m"
          echo -e "\033[32m📦 Available via Nix flake: esbuild, and more...\033[0m"
        '';

        # Create shell function
        createProjectShell =
          extraPackages:
          pkgs.mkShell {
            buildInputs = baseDevTools ++ extraPackages;
            shellHook = setupScript;

            # Don't force a specific shell
            NIX_SHELL_PRESERVE_PROMPT = 1;
          };

      in
      {
        # Development shells
        devShells = {
          default = createProjectShell [ ];

          services = createProjectShell (
            with pkgs;
            [
              postgresql
              redis
              docker
            ]
          );

          testing = createProjectShell (
            with pkgs;
            [
              docker
              postgresql
            ]
          );

          devops = createProjectShell (
            with pkgs;
            [
              docker
              kubernetes-helm
              kubectl
            ]
          );
        };

        # Formatter for `nix fmt`
        formatter = pkgs.nixpkgs-fmt;
      }
    );
}
