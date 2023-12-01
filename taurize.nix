{
  pkgs,
  system,
  stdenv,
  binaryPath,
  app_name,
  host,
  port,
}: let
  devURL = "http://localhost:${port}";

  main_rs = pkgs.writeTextFile {
    name = "main.rs";
    text = ''
      // Prevents additional console window on Windows in release, DO NOT REMOVE!!
      #![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]
      use tauri::api::process::{Command, CommandEvent};

      fn main() {
          tauri::Builder::default()
              .setup(|_app| {
                  start_server();
                  check_server_started();
                  Ok(())
              })
              .run(tauri::generate_context!())
              .expect("error while running tauri application");
      }

      fn start_server() {
          tauri::async_runtime::spawn(async move {
              let (mut rx, mut _child) = Command::new_sidecar("desktop")
                  .expect("failed to setup `desktop` sidecar")
                  .spawn()
                  .expect("Failed to spawn packaged node");

              while let Some(event) = rx.recv().await {
                  if let CommandEvent::Stdout(line) = event {
                      println!("{}", line);
                  }
              }
          });

          const command = Command.sidecar("${binaryPath}", ['start'])
          const output = await command.execute()

      }

      fn check_server_started() {
          let sleep_interval = std::time::Duration::from_secs(1);
          let host = "${host}".to_string();
          let port = "${port}".to_string();
          let addr = format!("{}:{}", host, port);
          println!(
              "Waiting for your phoenix dev server to start on {}...",
              addr
          );
          loop {
              if std::net::TcpStream::connect(addr.clone()).is_ok() {
                 break;
              }
              std::thread::sleep(sleep_interval);
          }
      }
    '';
  };

  tauri-conf-json = builtins.fromJSON (builtins.readFile ./src-tauri/tauri.conf.json);
  bundle = tauri-conf-json.tauri.bundle // {"externalBin" = [ "${binaryPath}" ];} // {"identifier" = "dev.testproject.desktop";};
  allowlist =
    tauri-conf-json.tauri.allowlist
    // {
      "shell" = {
        "sidecar" = true;
        "scope" = [
          {
            "name" = "testproject-desktop";
            "sidecar" = true;
            "args" = ["start"];
          }
        ];
      };
    };
  build = tauri-conf-json.build // { "devPath" = "${devURL}"; "distDir" = "${devURL}";};
  tauri-attr =
    tauri-conf-json.tauri
    // {
      "bundle" = bundle;
      "allowlist" = allowlist;
    };
  conf-str = builtins.toJSON (tauri-conf-json // {"tauri" = tauri-attr; "build" = build;});
  conf-file = pkgs.writeTextFile {
      name = "tauri-conf-json";
      text = conf-str;
      destination = "/tauri.conf.json";
    };
in pkgs.rustPlatform.buildRustPackage rec {
  pname = "${app_name}";
  version = "0.1";

  src = ./src-tauri;

  libraries = with pkgs; [
      webkitgtk
      gtk3
      cairo
      gdk-pixbuf
      glib
      dbus
      openssl_3
      librsvg
  ];

    buildInputs = with pkgs; [
      cargo
      rustc
      rustup
      libsoup
      librsvg
      cairo
      gtk3
      webkitgtk
      pkg-config
    ];

    nativeBuildInputs = with pkgs; [ cargo-tauri cargo rustc pkg-config glib gtk3 librsvg ];

    doCheck = false;
    strictDeps = false;

    configurePhase = ''
        ln -s ${binaryPath} testproject-x86_64-unknown-linux-gnu
        cp ${conf-file}/tauri.conf.json tauri.conf.json

        cp ${main_rs} src/main.rs
        cp build.rs src/build.rs
        ls -al
        substituteInPlace Cargo.toml \
          --replace 'name = "app"' 'name = "${app_name}-desktop"' \
          --replace 'default-run = "app"' 'default-run = "${app_name}-desktop"'

        substituteInPlace Cargo.lock \
          --replace 'name = "app"' 'name = "${app_name}-desktop"'
    '';

#    postInstall = ''
#    mv $out/bin/app $out/bin/${app_name}-desktop
#    '';

#    Build = ''
#            #export target=$out/bin/testproject
#            #export defaultRun='default-run' = $target
#            substituteInPlace Cargo.toml --replace 'default-run = "app"' 'default-run = "$out"';
#    '';

#    buildPhase = ''
#      export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath libraries}:$LD_LIBRARY_PATH
#
#      export OUT_DIR="$out"
#
#      echo $out
#      cargo-tauri build --config ${conf-file} -v --target x86_64-unknown-linux-gnu -b appimage -- --out-dir $out/bin -Z unstable-options
#      ls -al src-tauri
#    '';

    #buildAndTestSubdir = ./.;

    cargoHash = "sha256-LLPz78T6D9IaCWim7y7zgTTcVQRz8XO9s+H5qDqeWko=";
    cargoLock.lockFile = ./src-tauri/Cargo.lock;
}
