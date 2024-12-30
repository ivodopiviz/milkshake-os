#!/bin/bash

# This script provides common customization options for the ISO
#
# Usage: Copy this file to config.sh and make changes there.  Keep this file (default_config.sh) as-is
#   so that subsequent changes can be easily merged from upstream.  Keep all customiations in config.sh

# The version of Ubuntu to generate.  Successfully tested LTS: bionic, focal, jammy, noble
# See https://wiki.ubuntu.com/DevelopmentCodeNames for details
export TARGET_UBUNTU_VERSION="noble"

# The Ubuntu Mirror URL. It's better to change for faster download.
# More mirrors see: https://launchpad.net/ubuntu/+archivemirrors
export TARGET_UBUNTU_MIRROR="http://ftp.uni-stuttgart.de/ubuntu/"

# The packaged version of the Linux kernel to install on target image.
# See https://wiki.ubuntu.com/Kernel/LTSEnablementStack for details
export TARGET_KERNEL_PACKAGE="linux-generic"

# The file (no extension) of the ISO containing the generated disk image,
# the volume id, and the hostname of the live environment are set from this name.
export TARGET_NAME="milkshake-os"

# The text label shown in GRUB for booting into the live environment
export GRUB_LIVEBOOT_LABEL="Try Milkshake OS without installing"

# The text label shown in GRUB for starting installation
export GRUB_INSTALL_LABEL="Install Milkshake OS"

# Packages to be removed from the target system after installation completes succesfully
export TARGET_PACKAGE_REMOVE="
    ubiquity \
    casper \
    discover \
    laptop-detect \
    os-prober \
"

# Package customisation function.  Update this function to customize packages
# present on the installed system.
function customize_image() {
    # install graphics and desktop
    apt-get install -y \
        plymouth-themes \
        gnome-session \
        gnome-shell

    # useful tools
    apt-get install -y \
        apt-transport-https \
        curl \
        nano \
        less \
        flatpak

    # setup flathub
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

    # install flatpak apps
    flatpak install -y io.github.zen_browser.zen
    # FIXME: needs more chroot binding
    # flatpak install -y org.gnome.World.PikaBackup

    # set Zen as default browser
    xdg-settings set default-web-browser io.github.zen_browser.zen.desktop

    # remove ubuntu desktop settings panel
    rm /usr/share/applications/gnome-ubuntu-panel.desktop

    # remove snaps?

    # purge
    apt-get purge -y \
        transmission-gtk \
        transmission-common \
        "libreoffice*"
}

# Used to version the configuration.  If breaking changes occur, manual
# updates to this file from the default may be necessary.
export CONFIG_FILE_VERSION="0.4"
