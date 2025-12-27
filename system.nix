{ config, pkgs, lib, ... }:

with lib;

let
  cybersecPackages = import ./packages.nix { inherit pkgs; };
in
{
  options.cybersecurity = {
    enable = mkEnableOption "cybersecurity tools and packages";
  };

  config = mkIf config.cybersecurity.enable {
    environment.systemPackages = with pkgs; 
      cybersecPackages.coreTools ++ 
      cybersecPackages.systemTools ++ 
      [
        cybersecPackages.deepce
        cybersecPackages.droopescan
        cybersecPackages.burpsuite
      ];

    # Enable additional kernel modules for security testing
    boot.kernelModules = [
      "netfilter_log"    # For network monitoring
      "nf_conntrack"     # Connection tracking
      "usbmon"           # USB monitoring for security analysis
      "rfcomm"           # Bluetooth security testing
    ];

    # Configure group memberships for security tools
    users.groups.cybersec = {};

    # Enable wireshark for non-root users
    programs.wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };

    # Configure udev rules for USB security analysis
    services.udev.extraRules = ''
      # Allow members of cybersec group to access USB monitoring
      SUBSYSTEM=="usbmon", GROUP="cybersec", MODE="0640"
      
      # Enable raw socket access for security tools
      KERNEL=="tun", GROUP="cybersec", MODE="0660"
    '';

    # Allow monitor mode for wireless testing
    networking.wireless.userControlled.enable = mkDefault true;
    
    # Configure sysctl settings for security analysis
    boot.kernel.sysctl = {
      # Allow unprivileged access to network namespaces for some security tools
      "user.max_user_namespaces" = mkDefault 28633;
      
      # Enable BPF for advanced network analysis
      "kernel.unprivileged_bpf_disabled" = mkDefault 0;  # Allow for security analysis
    };

    # Create convenient symlinks for wordlists and seclists in /share
    systemd.tmpfiles.rules = [
      "L+ /share/wordlists - - - - ${pkgs.wordlists}/share/wordlists"
      "L+ /share/seclists - - - - ${pkgs.seclists}/share/wordlists/seclists"
    ];
  };
}