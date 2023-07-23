{ config, pkgs, ... }:

let 
  system = builtins.currentSystem;
in
{
  home.packages = with pkgs; [
    tor-browser-bundle-bin
    kleopatra
    discord
    spotify
    qpwgraph
    protonup-qt
    monero-gui
    microsoft-edge
    git
    grc
    gdb
    bitwarden
    bitwarden-cli
    ventoy
  ];

  programs.git = {
    enable = true;
    userName = "kunihir0";
    userEmail = "kunihir0@tutanota.com";
  };

  programs.fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting # Disable greeting
      '';
      plugins = [
        # Enable a plugin (here grc for colorized command output) from nixpkgs
        { name = "grc"; src = pkgs.fishPlugins.grc.src; }
        # Manually packaging and enable a plugin
        {
        name = "z";
        src = pkgs.fetchFromGitHub {
          owner = "jethrokuan";
          repo = "z";
          rev = "e0e1b9dfdba362f8ab1ae8c1afc7ccf62b89f7eb";
          sha256 = "0dbnir6jbwjpjalz14snzd3cgdysgcs3raznsijd6savad3qhijc";
        };
      }
    ];
  };

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-vkcapture
      obs-teleport
      input-overlay
    ];
  };

  programs.vscode = {
    enable = true;
    extensions = with (import (builtins.fetchGit {
      url = "https://github.com/nix-community/nix-vscode-extensions";
      ref = "refs/heads/master";
      rev = "c43d9089df96cf8aca157762ed0e2ddca9fcd71e";
    })).extensions.${system}; [
      pinage404.nix-extension-pack # added Nix Extension Pack
    ];
  };
}
