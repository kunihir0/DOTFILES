let
  # AMD GPUs
  gpuIDs = [
    "1002:67df" # GPU
    "1002:aaf0" # Audio
  ];
in { pkgs, lib, config, ... }: {
  options.vfio.enable = with lib; mkEnableOption "Configure the machine for VFIO";

  config = let cfg = config.vfio;
  in {
    boot = {
      initrd.kernelModules = [
        "vfio_pci"
        "vfio"
        "vfio_iommu_type1"
        "vfio_virqfd"
      ];

      kernelParams = [
        # enable IOMMU
        "amd_iommu=on"
        "iommu=pt"
        "kvm_amd.npt=1"
        "kvm_amd.avic=1"
        "kvm.ignore_msrs=1"
        "video=vesafb:off,efifb:off"
        "disable_idle_d3=1"
      ] ++ lib.optional cfg.enable
        # isolate the GPU
        ("vfio-pci.ids=" + lib.concatStringsSep "," gpuIDs);
    };
    virtualisation.spiceUSBRedirection.enable = true;
  };
}
