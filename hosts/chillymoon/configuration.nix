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
      timeout = 10;
      efi.canTouchEfiVariables = true;

      systemd-boot = {
        enable = true;
      };
    };
    kernelParams = ["nvidia.NVreg_PreserveVideoMemoryAllocations=1" "nvidia.NVreg_TemporaryFilePath=/var/tmp"];
  };

  hardware = {
    bluetooth = {
      enable = true;
      settings.General.experimental = true;
    };
    graphics.enable = true;
    nvidia = {
      open = true;
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = false;
      nvidiaSettings = true;
    };
  };

  services = {
    blueman.enable = true;
    xserver.videoDrivers = [ "nvidia" ];
    gvfs.enable = true;
    udisks2.enable = true;
  };
}
