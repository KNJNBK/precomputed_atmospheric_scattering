{
  description = "Environment for Vulkan/Engine experimentation";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    neovim.url = "git+file:///home/yellow14/Documents/GitHub/NixConfiguration?dir=modules/neovim";
  };
  outputs =
    {
      self,
      nixpkgs,
      neovim,
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {

      devShells.${system}.default = pkgs.mkShell {
        stdenv = pkgs.clangStdenv;
        buildInputs = with pkgs; [
          vulkan-loader
          vulkan-headers
          vulkan-validation-layers
          vulkan-tools
          vulkan-extension-layer
          sdl3
          libxkbcommon
        ];
        nativeBuildInputs = with pkgs; [
          renderdoc
          shader-slang
          spirv-tools
          llvmPackages.clang-tools
          lldb
          #So other packages can find other packages
          pkg-config
          #build tools
          cmake
          cmake-language-server
          cmake-format
          neovim.packages.${system}.default
        ];

        shellHook = ''
          			export VK_LAYER_PATH="${pkgs.vulkan-validation-layers}/share/vulkan/explicit_layer.d"
                    echo "⚡ [Nix Flake] Vulkan development environment activated!"
        '';
      };
    };
}
