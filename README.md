## Nix on MacOS

To install on a fresh Mac:

1. Install Nix with the [default installer], or the [Determinate Systems installer].

2. Clone [this repo] to `~/dotfiles`.
   (You don't have to install the Developer Tools / XCode; `nix-shell -p git` will help.)

3. Unpack the nix-darwin dotfiles with:

   ```
   $ cd ~/dotfiles
   $ nix-shell -p stow --command 'stow nix-darwin'`
   ```

   (is this necessary? nix-darwin doesn't seem to like the symlinks...)

4. Switch to the Nix configuration with:

   ```
   $ nix run nix-darwin -- switch --flake ~/dotfiles/nix-darwin/.config/nix-darwin/
   ```

Now open a new Terminal, and your Nix config will be available :+1:
 
[default installer]: https://nixos.org/download#nix-install-macos

[Determinate Systems installer]: https://github.com/DeterminateSystems/nix-installer

[this repo]: https://github.com/r-k-b/dotfiles


### Reinstalling Nix on MacOS

When reinstalling Nix, for example when switching from the default installer to the
Determinate Systems installer, you may run into errors about "ssl ca certs"; this
advice from [issue 2899] helped me:

```
sudo rm /etc/ssl/certs/ca-certificates.crt
sudo ln -s /nix/var/nix/profiles/default/etc/ssl/certs/ca-bundle.crt /etc/ssl/certs/ca-certificates.crt
```

Note, this is _after_ following the [official uninstall instructions].

[issue 2899]: https://github.com/NixOS/nix/issues/2899#issuecomment-1669501326

[official uninstall instructions]: https://nixos.org/manual/nix/stable/installation/uninstall
