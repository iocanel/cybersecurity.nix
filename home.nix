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
    # Allow unfree packages for security tools like wpscan, burpsuite, etc.
    nixpkgs.config.allowUnfree = true;
    
    home.packages = with pkgs; 
      cybersecPackages.coreTools ++ 
      cybersecPackages.systemTools ++ 
      [
        cybersecPackages.deepce
        cybersecPackages.droopescan
        cybersecPackages.burpsuite
      ];

    # Create shell aliases for common security tasks
    programs.bash.shellAliases = mkIf config.programs.bash.enable {
      "nmap-quick" = "nmap -T4 -F";
      "nmap-stealth" = "nmap -sS -T2";
      "sqlmap-quick" = "sqlmap --batch --random-agent";
      "droopescan-drupal" = "droopescan scan drupal";
      "droopescan-wordpress" = "droopescan scan wordpress";
    };

    programs.zsh.shellAliases = mkIf config.programs.zsh.enable {
      "nmap-quick" = "nmap -T4 -F";
      "nmap-stealth" = "nmap -sS -T2";
      "sqlmap-quick" = "sqlmap --batch --random-agent";
      "droopescan-drupal" = "droopescan scan drupal";
      "droopescan-wordpress" = "droopescan scan wordpress";
    };

    # Create convenient directories for security work
    xdg.userDirs.extraConfig = {
      XDG_SECURITY_DIR = "${config.home.homeDirectory}/Security";
      XDG_WORDLISTS_DIR = "${config.home.homeDirectory}/Security/wordlists";
      XDG_REPORTS_DIR = "${config.home.homeDirectory}/Security/reports";
    };

    # Create security working directories
    home.file = {
      "Security/wordlists/.keep".text = "";
      "Security/reports/.keep".text = "";
      "Security/scripts/.keep".text = "";
      "Security/targets/.keep".text = "";
    };

    # Create wordlist symlinks in user space (equivalent to system.nix /share symlinks)
    xdg.dataFile = {
      "wordlists".source = "${pkgs.wordlists}/share/wordlists";
      "seclists".source = "${pkgs.seclists}/share/wordlists/seclists";
    };
  };
}