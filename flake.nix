{
  description = "Modern Node.js/TypeScript monorepo with Nix flakes and direnv";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
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

        # Base development tools available in all shells
        baseTools = with pkgs; [
          fish
          nodePackages.pnpm
          esbuild
          fnm
        ];

        # Create a development shell with custom message
        mkDevShell =
          {
            packages ? [ ],
            shellName ? "default",
            message ? "",
          }:
          pkgs.mkShell {
            name = "demo-nix-shell-${shellName}";
            buildInputs = baseTools ++ packages;
            shellHook = ''
              export PATH="$PWD/node_modules/.bin:$PATH"

              # Initialize fnm to prevent warnings
              eval "$(fnm env --use-on-cd)"

              ${message}
            '';
            NIX_SHELL_PRESERVE_PROMPT = 1;
          };

      in
      {
        devShells = {
          default = mkDevShell {
            shellName = "default";
            message = ''
              echo -e "\033[32m❄️  Nix shell: default\033[0m"
              echo -e "\033[36m📦 Tools: pnpm, esbuild, fnm\033[0m"
            '';
          };

          database = mkDevShell {
            shellName = "database";
            packages = with pkgs; [
              redis
            ];
            message = ''
              echo -e "\033[32m❄️  Nix shell: database\033[0m"
              echo -e "\033[36m📦 Tools: pnpm, esbuild, fnm, redis\033[0m"
            '';
          };

          testing = mkDevShell {
            shellName = "testing";
            packages = with pkgs; [
              k6
              httpie
              jq
            ];
            message = ''
              echo -e "\033[32m❄️  Nix shell: testing\033[0m"
              echo -e "\033[36m📦 Tools: pnpm, esbuild, fnm, k6, httpie, jq\033[0m"
            '';
          };

          devops = mkDevShell {
            shellName = "heavy";
            packages = with pkgs; [
              docker
              kubernetes-helm
              kubectl
              redis
            ];
            message = ''
              echo -e "\033[32m❄️  Nix shell: heavy\033[0m"
              echo -e "\033[36m📦 Tools: pnpm, esbuild, fnm, docker, kubernetes, helm, redis\033[0m"
            '';
          };
        };

        formatter = pkgs.nixpkgs-fmt;
      }
    );
}
