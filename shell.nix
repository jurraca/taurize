{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  packages = with pkgs; [
    cargo
    rustc
    rustup
    cargo-tauri
    pkg-config
    libsoup
    librsvg
    cairo
    gtk3
    webkitgtk

    elixir
    esbuild
    sqlite
    inotify-tools

    mix2nix
  ];
}
