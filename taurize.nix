{
  pkgs,
  system,
  stdenv,
  binaryPath,
  app_name,
  host,
  port,
}: let
  devURL = "http://${app_name}:${port}";

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
                  .expect("Failename = "${app_name}"
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
  bundle = tauri-conf-json.tauri.bundle // {"externalBin" = [ binaryPath ];} // {"identifier" = "dev.seer.desktop";};
  allowlist =
    tauri-conf-json.tauri.allowlist
    // {
      "shell" = {
        "sidecar" = true;
        "scope" = [
          {
            "name" = binaryPath;
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
  };

in pkgs.rustPlatform.buildRustPackage rec {
  pname = "${app_name}";
  version = "0.1";

  src = ./.;

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

    configurePhase = ''
        cp ${main_rs} src-tauri/src/main.rs
        substituteInPlace src-tauri/Cargo.toml --replace 'name = "app"' 'name = "${app_name}"';
        substituteInPlace src-tauri/Cargo.toml --replace 'default-run = "app"' 'default-run = "${app_name}"';

        echo $PWD
    '';

    buildPhase = ''
      export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath libraries}:$LD_LIBRARY_PATH
      cargo-tauri build --config ${conf-file} --debug -v
    '';

   cargoRoot = "src-tauri";
   cargoLock.lockFile = ./src-tauri/Cargo.lock;
}