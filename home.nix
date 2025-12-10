{
  config,
  pkgs,
  stateVersion,
  hostname,
  username,
  ...
}: let
  home = "/home/${username}";
  dotfiles =
    config.lib.file.mkOutOfStoreSymlink "${home}/.nixos-config/config";
  hostDotfiles =
    config.lib.file.mkOutOfStoreSymlink "${home}/.nixos-config/hosts/${hostname}/config";
in {
  programs = {
    home-manager.enable = true;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };

  services.easyeffects = {
    enable = true;
    preset = "default";
  };

  home = {
    inherit stateVersion username;
    homeDirectory = home;

    packages =
      builtins.concatLists (builtins.attrValues (import ./packages.nix pkgs));

    file = {
      ".gitconfig".source = "${dotfiles}/git/gitconfig";
      ".gitignore".source = "${dotfiles}/git/gitignore";
      ".ssh/config".source = "${dotfiles}/ssh/config";
    };
  };

  xdg = {
    configFile = {
      "host".source = hostDotfiles;
      "bat".source = "${dotfiles}/bat";
      "starship.toml".source = "${dotfiles}/starship/starship.toml";
      "tealdeer".source = "${dotfiles}/tealdeer";
      "lazygit/config.yml".source = "${dotfiles}/lazygit/config.yml";
      "btop/btop.conf".source = "${dotfiles}/btop/btop.conf";
      "btop/themes".source = "${dotfiles}/btop/themes";
      "direnv/direnv.toml".source = "${dotfiles}/direnv/direnv.toml";
      "zed".source = "${dotfiles}/zed";
      "niri/config.kdl".source = "${dotfiles}/niri/config.kdl";
      "noctalia".source = "${dotfiles}/noctalia";
      "fish" = {
        source = "${dotfiles}/fish";
        recursive = true;
      };
      "ghostty".source = "${dotfiles}/ghostty";
    };
  };
}
