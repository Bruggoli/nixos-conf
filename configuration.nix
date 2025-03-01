# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ home, config, pkgs, ... }:

let 
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz";
in
{
  home-manager.users.markus = {
    home.stateVersion = "24.11";
  };

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (import "${home-manager}/nixos")
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Oslo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the plasma6 Desktop environment.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.plasma6.enable = true;
  services.xserver.displayManager.setupCommands = ''
    RIGHT='HDMI-0'
    LEFT='DP-0'
    ${pkgs.xorg.xrandr}/bin/xrandr --output $RIGHT --right-of $LEFT
  '';

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bluetooth
  hardware.bluetooth.enable = true;
  #services.bluez.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "no";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "no";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
  };

  # Nvidia driver
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {

    # Modesetting required
    modesetting.enable = true;
    
    # Change to true if struggling to wake from suspend. Can cause sleep/suspend to fail if true.
    powerManagement.enable = false;

    powerManagement.finegrained = false;
    
    open = true;

    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.stable;

  };

  # Monitor settings
  #services.xserver.xrandrHeads = [
  #{
  #  output = "DP-0";
  #  monitorConfig = ''
  #    Option "PreferredMode" "1920x1080"
  #  '';
  #}
  #{
  #  output = "HDMI-0";
  #  monitorConfig = ''
  #    Option "PreferredMode" "2560x1080"
  #  '';
  #}
  #primary = true;
  #];

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
  


  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.markus = {
    isNormalUser = true;
    description = "Markus";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Environment
  environment.variables = { EDITOR= "nvim"; TERMINAL="ghostty";};

  # Install firefox.
  programs.firefox.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.steam = {
    enable = true;
  };

  programs.hyprland.enable = true;

  # needed for hyprland
  security.polkit.enable = true;

  

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    pkgs.kitty
    neofetch
    lutris
    ghostty
    vesktop
    putty
    filezilla
    android-studio
    p7zip
    (pkgs.discord.override {
      withVencord = true;
    }) 
  ];

  programs.git = {
    enable = true;
    userName = "bruggoli";
    userEmail = "marmomag@gmail.com";
  };


 
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
    fira-code
  ];

  #nvim config
  #home.nvim.source = ./nvim;

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
  system.stateVersion = "24.11"; # Did you read the comment?

}

