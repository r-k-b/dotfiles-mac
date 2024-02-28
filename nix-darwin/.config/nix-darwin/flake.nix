{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nvimconf = {
      url = "github:r-k-b/nvimconf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nvimconf }:
    let
      # see available config options at https://daiderd.com/nix-darwin/manual/index.html
      configuration = { pkgs, ... }: {

        # workaround the stow symlinks at the default location not being read by `darwin-rebuild`.
        # Saves having to write out `darwin-rebuild switch --flake ~/dotfiles/nix-darwin/.config/nix-darwin` every time.
        # (Still need the `--flake` arg, tho.)
        environment = {
          darwinConfig = "$HOME/dotfiles/nix-darwin/.config/nix-darwin/";
          variables = {
            EDITOR = "vim";
          };
        };

        # List packages installed in system profile. To search by name, run:
        # $ nix-env -qaP | grep wget
        environment.systemPackages = with pkgs; [
          broot
          direnv
          git
          nix-output-monitor
          nixfmt
          nushell
          nvimconf.packages.aarch64-darwin.default
          stow
          tldr
          zoxide
        ];

        # Auto upgrade nix package and the daemon service.
        services.nix-daemon.enable = true;
        # nix.package = pkgs.nix;

        # Necessary for using flakes on this system.
        nix.settings.experimental-features = "nix-command flakes";

        # Create /etc/zshrc that loads the nix-darwin environment.
        programs.zsh.enable = true; # default shell on catalina
        # programs.fish.enable = true;

        # Set Git commit hash for darwin-version.
        system.configurationRevision = self.rev or self.dirtyRev or null;

        # Used for backwards compatibility, please read the changelog before changing.
        # $ darwin-rebuild changelog
        system.stateVersion = 4;

        # The platform the configuration will be used on.
        nixpkgs.hostPlatform = "aarch64-darwin";
      };
    in {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#Roberts-Mac-mini
      darwinConfigurations."Roberts-Mac-mini" =
        nix-darwin.lib.darwinSystem { modules = [ configuration ]; };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."Roberts-Mac-mini".pkgs;
    };
}
