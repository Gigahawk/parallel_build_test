{ inputs, ... }:
{
  perSystem =
    {
      self',
      pkgs,
      lib,
      ...
    }:
    {
      packages =
        let
          # Define our own writeText to allow remote builds
          writeText =
            name: value:
            pkgs.stdenv.mkDerivation {
              src = null;
              pname = name;
              version = "0unstable";
              dontUnpack = true;
              installPhase = ''
                echo "${value}" > $out
              '';
            };
          impureTime =
            if builtins.hasAttr "currentTime" builtins then
              builtins.toString builtins.currentTime
            else
              "PURE MODE";
          msg = ''
            CHANGEME
            ${impureTime}
          '';
          buildTextFile =
            value:
            writeText (builtins.toString value) ''
              ${builtins.toString value}
              ${msg}
            '';
          modulo = a: b: a - b * builtins.floor (a / b);
          isEven = x: modulo x 2 == 0;
          numFiles = lib.range 0 64;
          textFiles = builtins.map (
            x:
            if isEven x then
              buildTextFile "${toString x}-REMOTE"
            else
              (buildTextFile "${toString x}-LOCAL").overrideAttrs {
                preferLocalBuild = true;
              }
          ) numFiles;
          textFileInstallCmds = builtins.map (x: "cp ${builtins.toString x} $out") textFiles;
          installCmd = lib.concatStringsSep "\n" textFileInstallCmds;
        in
        {
          default = pkgs.stdenv.mkDerivation {
            src = null;
            pname = "parallel";
            version = "0unstable";
            dontUnpack = true;
            installPhase = ''
              mkdir -p "$out"
              ${installCmd}
            '';
          };
        };
    };
}
