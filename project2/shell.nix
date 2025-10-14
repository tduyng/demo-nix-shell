{
  pkgs ? import <nixpkgs> { },
}:

pkgs.mkShell {
  name = "project2";

  buildInputs = with pkgs; [
  ];

  shellHook = ''
    echo "🚀 Project2 Environment"
    echo ""
  '';

}
