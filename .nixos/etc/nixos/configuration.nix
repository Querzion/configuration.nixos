# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  hardware.enableAllFirmware = true;

  hardware.firmware = with pkgs; [
    linux-firmware
  ];

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      input = {
        General = {
          UserspaceHID = true;
        };
      };
      settings = {
        General = {
          MaxConnections = 10;
        };
      };
    };
  };

  services.upower.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;


  boot.plymouth.enable = true;
  boot.plymouth.theme = "bgrt"; # or your custom theme

  boot.kernelParams = [
    "quiet"
    "splash"
    "video=DP-1:1920x1080@60"
  ];

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "sv_SE.UTF-8";
    LC_IDENTIFICATION = "sv_SE.UTF-8";
    LC_MEASUREMENT = "sv_SE.UTF-8";
    LC_MONETARY = "sv_SE.UTF-8";
    LC_NAME = "sv_SE.UTF-8";
    LC_NUMERIC = "sv_SE.UTF-8";
    LC_PAPER = "sv_SE.UTF-8";
    LC_TELEPHONE = "sv_SE.UTF-8";
    LC_TIME = "sv_SE.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;
  services.xserver.videoDrivers = ["amdgpu"];

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "se";
    variant = "dvorak";
  };

  # Configure console keymap
  console.keyMap = "sv-latin1";

  # Enable CUPS to print documents.
  services.printing.enable = false;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  services.openssh = {
    enable = false;
    settings.PermitRootLogin = false;
    settings.PasswordAuthentication = false;
    ports = [22];
  };

  services.picom = {
    enable = true;
    backend = "glx";
    fade = true;
  };

  programs.git = {
    enable = true;
    config = {
      user.name = "Slisk Lindqvist";
      user.email = "slisk.lindqvist@querzion.com";
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = false;
  };

  programs.steam = {
    enable = true;

    extraCompatPackages = [ pkgs.proton-ge-bin ];
  };

  # Enable touchpad support (enabled default in most desktopManager).
  #services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.querzion = {
    isNormalUser = true;
    description = "Slisk Lindqvist";
    extraGroups = [ "networkmanager" "wheel" "bluetooth" "input" "lp" ];
    packages = with pkgs; [
      kdePackages.kate
      kdePackages.yakuake
    #  thunderbird
    ];

    shell = pkgs.bash;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.

    # Graphics & Utilities
    amdvlk
    vulkan-tools
    mesa
    pciutils
    glxinfo
    wget
    eza
    unzip
    btop
    fastfetch
    starship

    # Blutooth
    bluez
    bluez-tools
    libinput

    # AirDrop
    localsend

    # Large Language Model
    lmstudio

    # Browsers
    firefox
    brave
    google-chrome

    # Password Manager
    keepassxc

    # Editors/IDE's
    vscode
    jetbrains.rider
    jetbrains.rust-rover
    jetbrains.webstorm

    # Development Tools
    rustup
    nodejs_24
    npm-check
    android-tools
    android-studio
    azuredatastudio
    sql-studio
    docker_28
    postman
    insomnia
    gh
    ghz

    # .NET SDKs (combined into a single installation path)
    (
      with pkgs.dotnetCorePackages;
      combinePackages [
        sdk_8_0
        sdk_9_0
      ]
    )

    # .NET tooling
    #vscode-extensions.ms-dotnettools.csharp
    #vscode-extensions.ms-dotnettools.csdevkit
    #vscode-extensions.ms-dotnettools.vscode-dotnet-runtime
    #vscode-extensions.ms-dotnettools.vscodeintellicode-csharp

    # Communication
    discord
    teams-for-linux
    mailspring

    # Edit-tools
    libreoffice

    # Fonts
    corefonts

    # Wine
    wineWowPackages.stable
    wine64Packages.waylandFull

    # Multimedia
    mpv
    vlc
    jellyfin-media-player
    spotify

    # Security

    # Streaming
    obs-studio
    obs-studio-plugins.obs-multi-rtmp
    obs-studio-plugins.obs-source-switcher
    obs-studio-plugins.advanced-scene-switcher
    obs-studio-plugins.obs-pipewire-audio-capture
  ];

  environment.sessionVariables = {
    DOTNET_ROOT = "${pkgs.dotnetCorePackages.sdk_9_0}/share/dotnet";
  };


  # Fonts
  fonts.packages = with pkgs.nerd-fonts; [
    caskaydia-mono
    jetbrains-mono
  ];

  environment.etc."xdg/autostart/yakuake.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Exec=yakuake
    Hidden=false
    NoDisplay=false
    X-GNOME-Autostart-enabled=true
    Name=Yakuake
    Comment=Start Yakuake terminal emulator
  '';

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
