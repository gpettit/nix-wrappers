{
  self,
  inputs,
  ...
}: {
  perSystem = {
    pkgs,
    self',
    ...
  }: {
    packages = rec {
      myKitty = inputs.wrapper-modules.wrappers.kitty.wrap {
        inherit pkgs;

        settings = {
          font = "JetBrainsMono Nerd Font Mono";
          fontSize = 10.0;
        };
      };

      myStarship = inputs.wrapper-modules.wrappers.starship.wrap {
        inherit pkgs;

        settings = {
          # add_newline = false;

          hostname = {
            ssh_only = true;
            ssh_symbol = "🚀 ";
            # format = "[$ssh_symbol]($style)";
            # style = "bold cyan";
          };

          username = {
            format = "[$user]($style) ";
            # style = "bold green";
          };
        };
      };

      # nix profile install .#remote-shell
      remote-shell = pkgs.symlinkJoin {
        name = "remote-shell";
        paths = [
          myKitty
          myStarship
        ];
      };
    };
  };
}
