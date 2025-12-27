{ pkgs }:

{
  # Custom cybersecurity packages
  deepce = pkgs.callPackage ./packages/deepce.nix {};
  droopescan = pkgs.callPackage ./packages/droopescan.nix {};
  
  # Burpsuite with special wrapper (requires X11 configuration)
  burpsuite = pkgs.symlinkJoin {
    name = "burpsuite-wrapped";
    paths = [ pkgs.burpsuite ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/burpsuite \
        --set _JAVA_AWT_WM_NONREPARENTING 1 \
        --set GDK_BACKEND x11
    '';
  };
  
  # Core security analysis tools (suitable for both system and user)
  coreTools = with pkgs; [
    # Network Security & Analysis
    nmap
    smap # Drop-in replacement for nmap powered by shodan.io
    masscan
    rustscan
    tcpdump
    binwalk
    netcat
    netcat-gnu
    socat
    proxychains
    
    # Vulnerability Assessment
    nuclei
    
    # Web Security
    sqlmap
    nikto
    wpscan
    joomscan
    
    # Password Security
    john
    hashcat
    thc-hydra
    medusa
    ncrack
    cewl
    # Wordlists & Security Testing Lists
    wordlists
    seclists
    
    # OSINT (Open Source Intelligence)
    theharvester
    sherlock
    recon-ng
    amass
    waybackurls
    gau
    uncover
    
    # Exploitation & Post-Exploitation
    weevely
    python312Packages.impacket
    
    # Utilities
    exif
    curl
    wget
    git
    neovim
    tmux
    screen
    tree
    htop
  ];
  
  # System-level tools (require root or special permissions)
  systemTools = with pkgs; [
    # Network monitoring (requires root)
    wireshark
    
    # WiFi Security Testing (requires special permissions)
    aircrack-ng
    kismet
    
    # Metasploit Framework (system-wide installation preferred)
    metasploit
    ruby
    gem
    bundler
    rubyPackages.racc
    rubyPackages.rbs
    
    armitage
    
    # Credential Extraction & Windows Security Testing
    mimikatz # Windows credential extraction and WDigest vulnerability demonstration
  ];
}