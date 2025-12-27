# Cybersecurity Tools Module

A comprehensive NixOS/Home Manager module providing security testing and analysis tools.

## Structure

```
cybersecurity/
├── system.nix         # NixOS system-level module
├── home.nix          # Home Manager user-level module  
├── packages.nix      # Shared package definitions
├── packages/         # Custom package definitions
│   ├── deepce.nix    # Docker container escape testing
│   └── droopescan.nix # CMS vulnerability scanner
└── README.md         # This file
```

## Usage

### NixOS (System-wide)

Add to your `configuration.nix`:

```nix
{
  imports = [
    ./cybersecurity/system.nix
  ];

  cybersecurity.enable = true;
}
```

**Provides:**
- All security tools system-wide
- Kernel modules for security testing (`netfilter_log`, `usbmon`, `rfcomm`)
- System groups and permissions (`cybersec` group)
- udev rules for hardware access
- Wireshark integration for non-root users
- Global wordlist symlinks (`/share/wordlists`, `/share/seclists`)

### Home Manager (User-level)

Add to your `home.nix`:

```nix
{
  imports = [
    ./cybersecurity/home.nix
  ];

  cybersecurity.enable = true;
}
```

**Provides:**
- All security tools in user environment
- Shell aliases for common tasks
- Security working directories (`~/Security/{wordlists,reports,scripts,targets}`)
- No assumptions about system-level configuration

## Tools Included

### Network Security & Analysis
- `nmap`, `smap`, `masscan`, `rustscan`
- `wireshark`, `tcpdump`, `binwalk`
- `netcat`, `socat`, `proxychains`

### Vulnerability Assessment
- `nuclei` - Fast vulnerability scanner
- `droopescan` - CMS vulnerability scanner (Drupal, WordPress)

### Web Security
- `burpsuite` - Web application security testing
- `sqlmap` - SQL injection testing
- `nikto`, `wpscan`, `joomscan` - Web scanners

### WiFi Security Testing
- `aircrack-ng` - WiFi security auditing
- `kismet` - Wireless network detector

### Password Security
- `john`, `hashcat` - Password cracking
- `thc-hydra`, `medusa`, `ncrack` - Network login crackers
- `cewl` - Custom wordlist generator
- `wordlists`, `seclists` - Password/security lists

### OSINT (Open Source Intelligence)
- `theharvester`, `sherlock`, `recon-ng`
- `amass`, `waybackurls`, `gau`, `uncover`

### Exploitation & Post-Exploitation
- `metasploit` - Penetration testing framework
- `armitage` - Metasploit GUI
- `weevely` - Web shell generator
- `impacket` - Network protocol toolkit
- `deepce` - Docker container escape testing
- `mimikatz` - Windows credential extraction

### Container Security
- `deepce` - Docker enumeration and escape testing

## Shell Aliases (Home Manager only)

When using Home Manager, these aliases are available:

```bash
nmap-quick        # nmap -T4 -F
nmap-stealth      # nmap -sS -T2
sqlmap-quick      # sqlmap --batch --random-agent
droopescan-drupal # droopescan scan drupal
droopescan-wordpress # droopescan scan wordpress
```

## Directory Structure (Home Manager only)

Creates these directories in your home:

```
~/Security/
├── wordlists/    # Custom wordlists
├── reports/      # Security assessment reports
├── scripts/      # Custom security scripts
└── targets/      # Target information and data
```

## System Requirements

### NixOS Module Requirements
- Root access for kernel module loading
- Hardware access for wireless testing
- System-wide package installation

### Home Manager Module Requirements
- User-level package installation only
- No special permissions required
- Works on any Nix-compatible system

## Notes

- Both modules install identical tools - only system configuration differs
- Home Manager module makes no assumptions about system-level setup
- Tools requiring special permissions (like packet capture) may need additional setup when using Home Manager only
- Wordlists are available at `/share/wordlists` (system) or can be placed in `~/Security/wordlists` (user)

## Contributing

When adding new security tools:

1. Add package definition to `packages.nix`
2. Categorize appropriately (`coreTools` vs `systemTools`)
3. Update both `system.nix` and `home.nix` to include the tool
4. Update this README