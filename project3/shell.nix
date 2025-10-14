{
  pkgs ? import <nixpkgs> { },
}:

pkgs.mkShell {
  name = "project3";

  buildInputs = with pkgs; [
  ];

  shellHook = ''
    echo "🚀 Project3 Environment"
    echo ""
  '';

}
