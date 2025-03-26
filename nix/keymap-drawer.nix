{ lib
, buildPythonApplication
, buildPythonPackage
, callPackage
, fetchFromGitHub
, setuptools
, poetry-core
, pydantic
, pyparsing
, pcpp
, pyyaml
, platformdirs
, pydantic-settings
, tree-sitter
}:
let
  tree-sitter-devicetree = callPackage ./tree-sitter-devicetree.nix {};
in
buildPythonApplication rec {
  pname = "keymap-drawer";
  version = "0.21.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "caksoylar";
    repo = pname;
    rev = "855933863fcc6f0db6098a03e679319dbf7f8bf2";
    hash = "sha256-InddS9NxVrYOufiP7iWQTQ3VBeJgX2UlBA+Gf7ZfFrI=";
  };

  postPatch = ''
    # nixos-unstable no longer bundles v23 of tree-sitter
    substituteInPlace pyproject.toml --replace 'tree-sitter (>=0.23.2,<0.24.0)' 'tree-sitter (>=0.23.2,<0.25.0)'
  '';

  build-system = [ poetry-core ];

  propagatedBuildInputs = [
    pydantic
    pyparsing
    pcpp
    pyyaml
    platformdirs
    pydantic-settings
    tree-sitter
    tree-sitter-devicetree
  ];

  doCheck = false;

  meta = {
    homepage = "https://github.com/caksoylar/keymap-drawer";
    description = "Parse QMK & ZMK keymaps and draw them as vector graphics";
    license = lib.licenses.mit;
  };
}
