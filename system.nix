{
  pkgs,
  stateVersion,
  username,
  inputs,
  hostname,
  ...
}: let
  sshPublicKeys = [];
in {
  system = {inherit stateVersion;};

  nix = {
    registry.nixpkgs.flake = inputs.nixpkgs;
    nixPath = ["nixpkgs=${inputs.nixpkgs.outPath}"];

    settings = {
      trusted-users = ["root" "ryan"];
      experimental-features = ["nix-command" "flakes" "pipe-operators"];
      auto-optimise-store = true;
    };

    package = pkgs.nixVersions.stable;

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  time = {
    timeZone = "America/Toronto";
    hardwareClockInLocalTime = true;
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  programs = {
    niri.enable = true;
    waybar.enable = true;
    steam.enable = true;
    gamescope.enable = true;
    gamemode.enable = true;

    # ssh.startAgent = true;
    dconf.enable = true;

    _1password.enable = true;
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = ["${username}"];
    };

    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        # add any missing dynamic libraries for unpackaged programs here
      ];
    };
  };

  environment = {
    shells = [pkgs.zsh pkgs.bash];

    systemPackages = with pkgs; [
      helix
      ghostty
    ];
  };

  services = {
    upower.enable = true;
    openssh.enable = true;
    dbus.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    printing.enable = true;

    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
      publish = {
        enable = true;
        addresses = true;
        domain = true;
      };
    };

    displayManager.gdm.enable = true;
    displayManager.gdm.wayland = true;
    
    interception-tools =
      let
        itools = pkgs.interception-tools;
        itools-caps = pkgs.interception-tools-plugins.caps2esc;
      in
      {
        enable = true;
        plugins = [ itools-caps ];
        # requires explicit paths: https://github.com/NixOS/nixpkgs/issues/126681
        udevmonConfig = pkgs.lib.mkDefault ''
          - JOB: "${itools}/bin/intercept -g $DEVNODE | ${itools-caps}/bin/caps2esc -m 1 | ${itools}/bin/uinput -d $DEVNODE"
            DEVICE:
              EVENTS:
                EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
        '';
      };
  };

  users.users = {
    ryan = {
      isNormalUser = true;
      extraGroups = ["wheel" "networkmanager"];
      openssh.authorizedKeys.keys = sshPublicKeys;
    };
  };

  networking = {
    networkmanager.enable = true;
    firewall.enable = false;
  };

  security.rtkit.enable = true;

  fonts = {
    fontconfig.defaultFonts = {
      sansSerif = ["Noto Sans"];
      serif = ["Noto Serif"];
      monospace = ["JetBrains Mono Nerd Font"];
    };

    packages = with pkgs; [
      inter
      nerd-fonts.jetbrains-mono
      noto-fonts
      noto-fonts-color-emoji
      noto-fonts-cjk-sans
    ];
  };
}
