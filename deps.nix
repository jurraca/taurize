{ lib, beamPackages, overrides ? (x: y: {}) }:

let
  buildRebar3 = lib.makeOverridable beamPackages.buildRebar3;
  buildMix = lib.makeOverridable beamPackages.buildMix;
  buildErlangMk = lib.makeOverridable beamPackages.buildErlangMk;

  self = packages // (overrides self packages);

  packages = with beamPackages; with self; {
    castore = buildMix rec {
      name = "castore";
      version = "1.0.4";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1y44amb8falsmrfzpkmf7qp6215g9kdl76g91dpna4af2jwc264l";
      };

      beamDeps = [];
    };

    cowboy = buildErlangMk rec {
      name = "cowboy";
      version = "2.10.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0sqxqjdykxc2ai9cvkc0xjwkvr80z98wzlqlrd1z3iiw32vwrz9s";
      };

      beamDeps = [ cowlib ranch ];
    };

    cowboy_telemetry = buildRebar3 rec {
      name = "cowboy_telemetry";
      version = "0.4.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1pn90is3k9dq64wbijvzkqb6ldfqvwiqi7ymc8dx6ra5xv0vm63x";
      };

      beamDeps = [ cowboy telemetry ];
    };

    cowlib = buildRebar3 rec {
      name = "cowlib";
      version = "2.12.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1c4dgi8canscyjgddp22mjc69znvwy44wk3r7jrl2wvs6vv76fqn";
      };

      beamDeps = [];
    };

    db_connection = buildMix rec {
      name = "db_connection";
      version = "2.6.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1wrmi8xmxlyaw6l4dis8cvvzx2nvxka8j4dwgzn23rr5az8r5yf2";
      };

      beamDeps = [ telemetry ];
    };

    decimal = buildMix rec {
      name = "decimal";
      version = "2.1.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1k7z418b6cj977wswpxsk5844xrxc1smaiqsmrqpf3pdjzsfbksk";
      };

      beamDeps = [];
    };

    ecto = buildMix rec {
      name = "ecto";
      version = "3.10.3";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0crlrpl392pbkzl6ar4z6afna8h9d46wshky1zbr3m344d7cggj4";
      };

      beamDeps = [ decimal jason telemetry ];
    };

    ecto_sql = buildMix rec {
      name = "ecto_sql";
      version = "3.10.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "01whmapzs08xzachra73lhb0d8f7mvysz29qbqivjz55pkg1ih38";
      };

      beamDeps = [ db_connection ecto postgrex telemetry ];
    };

    esbuild = buildMix rec {
      name = "esbuild";
      version = "0.8.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "03snlxg5aj5b2in2k190vap6nmai92bxgdg7fskv0g61cxm8gz15";
      };

      beamDeps = [ castore jason ];
    };

    expo = buildMix rec {
      name = "expo";
      version = "0.4.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0iyfl4vppfhmimfqaracjza9a6y8rgia03sm28y5934cg5xbmxrg";
      };

      beamDeps = [];
    };

    file_system = buildMix rec {
      name = "file_system";
      version = "0.2.10";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1p0myxmnjjds8bbg69dd6fvhk8q3n7lb78zd4qvmjajnzgdmw6a1";
      };

      beamDeps = [];
    };

    finch = buildMix rec {
      name = "finch";
      version = "0.16.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1iayffbjzb1rcy1p0wibzv6j5n7dc16ha5lhcbn5z7ji9m61fq7n";
      };

      beamDeps = [ castore mime mint nimble_options nimble_pool telemetry ];
    };

    floki = buildMix rec {
      name = "floki";
      version = "0.35.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1nbkcz8pngi9q4l9rf02s0gj06bypbjc42agciglgb4yisd2h1bb";
      };

      beamDeps = [];
    };

    gettext = buildMix rec {
      name = "gettext";
      version = "0.23.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1nwmhzmpw7y43db5dgcf2nfqa9a4jdxw4mqbc46q37c0dfil9mqr";
      };

      beamDeps = [ expo ];
    };

    heroicons = buildMix rec {
      name = "heroicons";
      version = "0.5.3";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "00im5yrzbhfzgsm3nk238k4j3j49krr9sxx0l3i1gb09i9z06452";
      };

      beamDeps = [ castore phoenix_live_view ];
    };

    hpax = buildMix rec {
      name = "hpax";
      version = "0.1.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "04wci9ifsfyd2pbcrnpgh2aq0a8fi1lpkrzb91kz3x93b8yq91rc";
      };

      beamDeps = [];
    };

    jason = buildMix rec {
      name = "jason";
      version = "1.4.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "18d70i31bz11nr6vgsjn5prvhkvwqbyf3xq22ck5cnsnzp6ixc7v";
      };

      beamDeps = [ decimal ];
    };

    mime = buildMix rec {
      name = "mime";
      version = "2.0.5";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0p50h0ki8ay5sraiqxiajgwy1829bvyagj65bj9wjny4cnin83fs";
      };

      beamDeps = [];
    };

    mint = buildMix rec {
      name = "mint";
      version = "1.5.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "07jvgmggmv6bxhkmrskdjz1xvv0a1l53fby7sammcfbwdbky2qsa";
      };

      beamDeps = [ castore hpax ];
    };

    nimble_options = buildMix rec {
      name = "nimble_options";
      version = "1.0.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1f7ih1rnkvph0daf4lsv4rrp6dpccksjd7rh5bhnq0r143dsh4px";
      };

      beamDeps = [];
    };

    nimble_pool = buildMix rec {
      name = "nimble_pool";
      version = "1.0.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0ymn22kj8jkyx1xjh2ldz65s4lhr3f70g1v04n11hd9d5n43pgl0";
      };

      beamDeps = [];
    };

    phoenix = buildMix rec {
      name = "phoenix";
      version = "1.7.10";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1l3rpcavz0zkx4kq4nzyzs74k944lpbflzvdcmnp7z8hw0r4jy6g";
      };

      beamDeps = [ castore jason phoenix_pubsub phoenix_template plug plug_cowboy plug_crypto telemetry websock_adapter ];
    };

    phoenix_ecto = buildMix rec {
      name = "phoenix_ecto";
      version = "4.4.3";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "01xcc5pl4zc1l3whglfrflcpkj3fcbpyh11xsvpiy0gk0q940v6k";
      };

      beamDeps = [ ecto phoenix_html plug ];
    };

    phoenix_html = buildMix rec {
      name = "phoenix_html";
      version = "3.3.3";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0v6pplj51x5m101dl2h09gajr4yyc1jxrywxaqz3nbkfxipvwglj";
      };

      beamDeps = [ plug ];
    };

    phoenix_live_dashboard = buildMix rec {
      name = "phoenix_live_dashboard";
      version = "0.7.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1dq5vj1a6fzclr3fwj7y8rg2xq3yigvgqc3aaq664fvs7h3dypqf";
      };

      beamDeps = [ ecto mime phoenix_live_view telemetry_metrics ];
    };

    phoenix_live_reload = buildMix rec {
      name = "phoenix_live_reload";
      version = "1.4.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1aqm6sxy4ijd5gi8lmjmcaxal1smg2smibjlzrkq9w6xwwsbizwv";
      };

      beamDeps = [ file_system phoenix ];
    };

    phoenix_live_view = buildMix rec {
      name = "phoenix_live_view";
      version = "0.18.18";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "052jv2kbc2nb4qs4ly4idcai6q8wyfkvv59adpg9w67kf820v0d5";
      };

      beamDeps = [ jason phoenix phoenix_html phoenix_template telemetry ];
    };

    phoenix_pubsub = buildMix rec {
      name = "phoenix_pubsub";
      version = "2.1.3";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "00p5dvizhawhqbia2cakdn4whaxsm2adq3lzfn3b137xvk0np85v";
      };

      beamDeps = [];
    };

    phoenix_template = buildMix rec {
      name = "phoenix_template";
      version = "1.0.3";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0b4fbp9dhfii6njksm35z8xf4bp8lw5hr7bv0p6g6lj1i9cbdx0n";
      };

      beamDeps = [ phoenix_html ];
    };

    plug = buildMix rec {
      name = "plug";
      version = "1.15.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0c4xqw9xxh04r8cv4f7civ9arzkn1dnfqm40jj6xjhfhjjyrg525";
      };

      beamDeps = [ mime plug_crypto telemetry ];
    };

    plug_cowboy = buildMix rec {
      name = "plug_cowboy";
      version = "2.6.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "04v6xc4v741dr2y38j66fmcc4xc037dnaxzkj2vih6j53yif2dny";
      };

      beamDeps = [ cowboy cowboy_telemetry plug ];
    };

    plug_crypto = buildMix rec {
      name = "plug_crypto";
      version = "2.0.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1aayyjqa2q9c7v2g2ripbav99n74fh8b0glrdmb58kncayp5nsak";
      };

      beamDeps = [];
    };

    postgrex = buildMix rec {
      name = "postgrex";
      version = "0.17.3";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1389zgxvv90nzz0nwb7l5l4gyg2hldmyg2s4h5xcmzd46mlz8v4l";
      };

      beamDeps = [ db_connection decimal jason ];
    };

    ranch = buildRebar3 rec {
      name = "ranch";
      version = "1.8.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1rfz5ld54pkd2w25jadyznia2vb7aw9bclck21fizargd39wzys9";
      };

      beamDeps = [];
    };

    swoosh = buildMix rec {
      name = "swoosh";
      version = "1.14.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "098hqy222l3qmzq9894sspb7z09d9f9qn6iymd2q7hcrmj3ckkyw";
      };

      beamDeps = [ cowboy finch jason mime plug plug_cowboy telemetry ];
    };

    tailwind = buildMix rec {
      name = "tailwind";
      version = "0.1.10";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1wgiyb3fnmyns5sabbav1axhz9rwzp2nkb2i71bs9mwfz96lgz70";
      };

      beamDeps = [ castore ];
    };

    telemetry = buildRebar3 rec {
      name = "telemetry";
      version = "1.2.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1mgyx9zw92g6w8fp9pblm3b0bghwxwwcbslrixq23ipzisfwxnfs";
      };

      beamDeps = [];
    };

    telemetry_metrics = buildMix rec {
      name = "telemetry_metrics";
      version = "0.6.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1iilk2n75kn9i95fdp8mpxvn3rcn3ghln7p77cijqws13j3y1sbv";
      };

      beamDeps = [ telemetry ];
    };

    telemetry_poller = buildRebar3 rec {
      name = "telemetry_poller";
      version = "1.0.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0vjgxkxn9ll1gc6xd8jh4b0ldmg9l7fsfg7w63d44gvcssplx8mk";
      };

      beamDeps = [ telemetry ];
    };

    websock = buildMix rec {
      name = "websock";
      version = "0.5.3";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0lxlp1h18595nqczfg15iy34kw5xbbab3yk6ml9cf8mcgwyla1b1";
      };

      beamDeps = [];
    };

    websock_adapter = buildMix rec {
      name = "websock_adapter";
      version = "0.5.5";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1sgw9wi8zi25lhawa4wj00m2r5znwy6zhpq4fyzsq60rl2j7p5sb";
      };

      beamDeps = [ plug plug_cowboy websock ];
    };
  };
in self

