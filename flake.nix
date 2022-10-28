{
  description = "A metronome application using GTK+";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        packages = rec {
          default = gtick;

          gtick = pkgs.stdenv.mkDerivation rec {
            pname = "gtick";
            version = "0.5.5";

            src = ./.;

            configureFlags = [
              "--with-sndfile"
            ];

            fixupPhase = ''
              substituteInPlace $out/share/applications/gtick.desktop \
                --replace "/usr" "$out"
            '';

            nativeBuildInputs = with pkgs; [
              pkgconfig
              autoreconfHook
              wrapGAppsHook
              flex
              bison
                         ];

            buildInputs = with pkgs; [
              gtk2
              libpulseaudio
              libsndfile
            ];
          };
        };
      }
    );
}
