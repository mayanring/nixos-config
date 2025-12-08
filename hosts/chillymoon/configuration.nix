{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
    inputs.nixos-hardware.nixosModules.common-pc-ssd
  ];

  networking = {
    hostId = "652184b4";
    hostName = "chillymoon";
  };

  boot = {
    loader = {
      timeout = 0;
      efi.canTouchEfiVariables = true;

      systemd-boot = {
        enable = true;
      };
    };
  };

  hardware = {
    bluetooth = {
      enable = true;
      settings.General.experimental = true;
    };
    graphics.enable = true;
    nvidia.open = true;
  };

  services = {
    blueman.enable = true;
    xserver.videoDrivers = [ "nvidia" ];
  };
}
