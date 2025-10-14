{
  pkgs ? import <nixpkgs> { },
}:

pkgs.mkShell {
  name = "project1";

  buildInputs = with pkgs; [
  ];

  shellHook = ''
    echo "🚀 Project1 Environment"
    echo ""
  '';

}
