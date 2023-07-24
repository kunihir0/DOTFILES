#!/nix/store/kgj67hni0ygzapkf5a7fa6isbkblmbdk-system-path/bin/bash

VIRT_TYPE="kvm"
VM_NAME="win11"
OS_VARIANT="win11"
VCPUS="8"
SOCKETS="1"
CORES="8"
THREADS="1"
CPU="host-passthrough"
MEMORY="8192"
DISK_PATH="/var/lib/libvirt/images/win11.qcow2"
DISK_SIZE="100"
DISK_FORMAT="qcow2"
DISK_BUS="scsi"
DISK_CACHE="writethrough"
DISK_DISCARD="unmap"
DISK_IO="threads"
CONTROLLER_MODEL="virtio-scsi"
GRAPHICS_TYPE="spice"
VIDEO_MODEL="qxl"
VIDEO_VGAMEM="32768"
VIDEO_RAM="131072"
VIDEO_VRAM="131072"
VIDEO_HEADS="1"
NETWORK_BRIDGE="virbr0"
NETWORK_MODEL="virtio"
INPUT_TYPE="tablet"
INPUT_BUS="virtio"
METADATA_TITLE='Win11 (TPM2 and SB)'
VIRTIO_ISO_PATH='/home/kunihir0/Downloads/virtio-win-0.1.229.iso'
CDROM_PATH='/var/lib/libvirt/images/Win11_22H2_English_x64v2.iso'
TPM_TYPE='passthrough'
TPM_VERSION='2.0'
TPM_MODEL='tpm-tis'
TPM_DEVICE='/dev/tpm0'
BOOT_LOADER='/nix/store/lmh8zy5dwflkzmw9l24xq5srnd6kkq4h-qemu-8.0.2/share/qemu/edk2-x86_64-secure-code.fd'
BOOT_LOADER_READONLY='yes'
BOOT_LOADER_TYPE='pflash'
BOOT_LOADER_SECURE='yes'
BOOT_NVRAM_TEMPLATE='/run/libvirt/nix-ovmf/OVMF_CODE.fd'
BOOT_MENU='on'

# Function to create a new disk image file if it doesn't already exist
create_disk_image() {
  if [ ! -f "$DISK_PATH" ]; then
    qemu-img create -f $DISK_FORMAT $DISK_PATH ${DISK_SIZE}G
  fi
}

#create_disk_image

virt-install \
--virt-type $VIRT_TYPE \
--name=$VM_NAME \
--os-variant=$OS_VARIANT \
--vcpus $VCPUS,sockets=$SOCKETS,cores=$CORES,threads=$THREADS \
--cpu $CPU \
--memory $MEMORY \
--boot loader=$BOOT_LOADER,loader.readonly=$BOOT_LOADER_READONLY,loader.type=$BOOT_LOADER_TYPE,loader.secure=$BOOT_LOADER_SECURE \
--features smm.state=on,kvm_hidden=on,hyperv_relaxed=on,hyperv_vapic=on,hyperv_spinlocks=on,hyperv_spinlocks_retries=8191 \
--clock hypervclock_present=yes \
--disk path=$DISK_PATH,size=$DISK_SIZE,format=$DISK_FORMAT,sparse=true,bus=$DISK_BUS,cache=$DISK_CACHE,discard=$DISK_DISCARD,io=$DISK_IO  \
--controller type=scsi,model=$CONTROLLER_MODEL \
--graphics $GRAPHICS_TYPE \
--video model=$VIDEO_MODEL,vgamem=$VIDEO_VGAMEM,ram=$VIDEO_RAM,vram=$VIDEO_VRAM,heads=$VIDEO_HEADS \
--channel spicevmc,target_type=virtio,name=com.redhat.spice.0 \
--channel unix,target_type=virtio,name=org.qemu.guest_agent.0 \
--network bridge=$NETWORK_BRIDGE,model=$NETWORK_MODEL \
--input type=$INPUT_TYPE,bus=$INPUT_BUS \
--metadata title="$METADATA_TITLE" \
--cdrom $CDROM_PATH \
--tpm $TPM_DEVICE

ASS="nvram.template=$BOOT_NVRAM_TEMPLATE,menu=$BOOT_MENU"
