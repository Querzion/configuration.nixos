{ pkgs, ... }:

{
  # Basic system settings
  networking.hostName = "nika";
  networking.networkmanager.enable = true;

  # Time zone
  time.timeZone = "Europe/Stockholm";

  # Users
  users.users.querzion = {
    isNormalUser = true;
    password = "your-password"; 
    extraGroups = [ "wheel" "networkmanager" ];
  };

  # Enable SSH
  services.openssh.enable = true;

  # Enable the graphical interface with KDE Plasma
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Keyboard layout
  services.xserver.layout = "se(dvorak)";
  services.xserver.xkbOptions = [
    "grp:toggle"
    "grp:win_space_toggle"
    "layout:se"
  ];

  # Create necessary directories
  systemd.services.createNetworkDirs = {
    description = "Create network directories";
    wantedBy = [ "multi-user.target" ];
    serviceConfig.ExecStart = ''
      mkdir -p /home/querzion/network/{Downloads,Backups,ISOs,"The Archives",Users,VMs}
    '';
    install = {
      wantedBy = [ "multi-user.target" ];
    };
  };

  # Network sharing
  services.samba.enable = true;
  services.samba.share = {
    "myshare" = {
      path = "/home/querzion/network/shared";
      writable = true;
      users = [ "querzion" ];
    };
  };

  # Mount network shares securely using a credentials file
  fileSystems = {
    "/home/querzion/network/Downloads" = {
      device = "smb://192.168.0.3/Downloads";
      fsType = "smbfs";
      options = [ "credentials=/etc/systemd/system/creds/samba.secret" ];
    };
    "/home/querzion/network/Backups" = {
      device = "smb://192.168.0.3/Backups";
      fsType = "smbfs";
      options = [ "credentials=/etc/systemd/system/creds/samba.secret" ];
    };
    "/home/querzion/network/ISOs" = {
      device = "smb://192.168.0.3/ISOs";
      fsType = "smbfs";
      options = [ "credentials=/etc/systemd/system/creds/samba.secret" ];
    };
    "/home/querzion/network/The Archives" = {
      device = "smb://192.168.0.3/The Archives";
      fsType = "smbfs";
      options = [ "credentials=/etc/systemd/system/creds/samba.secret" ];
    };
    "/home/querzion/network/Users" = {
      device = "smb://192.168.0.3/Users";
      fsType = "smbfs";
      options = [ "credentials=/etc/systemd/system/creds/samba.secret" ];
    };
    "/home/querzion/network/VMs" = {
      device = "smb://192.168.0.3/VMs";
      fsType = "smbfs";
      options = [ "credentials=/etc/systemd/system/creds/samba.secret" ];
    };
  };

  # Configure the system
  environment.systemPackages = with pkgs; [
    # Development tools
    vim          # Text editor
    git          # Version control
    wget         # Download utility
    firefox      # Web browser
    dotnet       # .NET SDK
    vscode       # Visual Studio Code

    # Fonts
    fonts.microsoft   # Microsoft fonts
    fonts.nerd-fonts  # Nerd fonts

    # Audio and virtual cable
    pulseaudio        # Audio server
    pulseeffects      # Audio effects
    pavucontrol       # Volume control

    # Streaming tools
    obs-studio        # Streaming software
    streamlabs        # Stream management
    ffmpeg            # Video processing

    # KDE Applications
    plasma-desktop    # KDE Plasma desktop environment
    kate              # Advanced text editor
    konsole           # Terminal emulator
    dolphin           # File manager
    kdenlive          # Video editor
    yakuake           # Drop-down terminal

    # Monitoring tools
    btop              # System resource monitor
    fastfetch         # System info fetcher

    # Gaming applications
    steam             # Game platform
    lutris            # Game manager
    wine              # Windows compatibility layer
    discord           # Communication platform
    heroic            # Epic Games launcher
    proton-ge         # Proton for gaming
    dosbox            # DOS emulator
    gamescope         # Game session manager
    gamemode          # Gaming performance manager
    mangohud          # Performance overlay

    # Backup tool
    timeshift         # System backup tool

    # Firewall
    firewalld         # Firewall service
  ];

  # Configure Timeshift
  services.timeshift = {
    enable = true;
    snapshotType = "RSYNC"; # Use RSYNC for snapshots
    backupPath = "/home/querzion/network/Backups/NixOS"; # Updated backup path
    includeHome = true;     # Include home directory
  };

  # Fastfetch mockup output
  programs.fastfetch.enable = true;
  programs.fastfetch.mockup = ''
    🖥️  Host: nika
    🐧  OS: NixOS
    🎨  DE: KDE Plasma
    ⚙️  Shell: bash
    🗄️  User: querzion
    📦  Packages: ${builtins.length (import <nixpkgs> {}).pkgs // {}}
    💾  Memory: $(free -h | awk '/^Mem:/ {print $2}')
    💻  CPU: $(lscpu | awk '/Model name:/ {print $3, $4, $5, $6, $7, $8}')
    🎮  GPU: $(lspci | grep -i vga | awk '{print $1, $2, $3, $4, $5}')
    📊  Uptime: $(uptime -p)
    🌐  Kernel: $(uname -r)
    🌍  Resolution: $(xrandr | grep '*' | awk '{print $1}')
  '';

  # Yakuake session settings
  services.yakuake.enable = true;
  services.yakuake.sessions = [
    {
      name = "Session 1";
      command = "bash";
    }
    {
      name = "Session 2";
      command = "bash";
    }
    {
      name = "Session 3";
      command = "btop";
    }
  ];

  # Additional settings for KDE Plasma
  services.plasma5.enable = true;
  services.kdeApplications.enable = true;

  # Firewall setup
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 139 445 ];
  networking.firewall.allowedUDPPorts = [ 137 138 ];

  # Configure hardware
  hardware.opengl.enable = true;
  hardware.pulseaudio.enable = true;

  # Configure the system
  system.stateVersion = "23.05"; # Change this to your NixOS version
}
