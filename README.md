## Nix on MacOS

To install on a fresh Mac:

1. Install Nix with the default installer, or the Determinate Systems installer.

2. Clone this repo to `~/dotfiles`.
   (You don't have to install the Developer Tools / XCode; `nix-shell -p git` will help.)

3. Unpack the nix-darwin dotfiles with `cd ~/dotfiles` and `nix-shell -p stow --command 'stow nix-darwin'`
   (is this necessary? nix-darwin doesn't seem to like the symlinks...)

4. Switch to the Nix configuration with:

   ```
   nix run nix-darwin -- switch --flake ~/dotfiles/nix-darwin/.config/nix-darwin/
   ```

Now open a new Terminal, and your Nix config will be available :+1:
 
