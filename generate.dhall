let Bool/bshow
    : Bool → Text
    = λ(b : Bool) → if b then "true" else "false"

let List/map =
      https://prelude.dhall-lang.org/List/map sha256:dd845ffb4568d40327f2a817eb42d1c6138b929ca758d50bc33112ef3c885680

let Text/concatSep =
      https://prelude.dhall-lang.org/Text/concatSep sha256:e4401d69918c61b92a4c0288f7d60a6560ca99726138ed8ebc58dca2cd205e58

let ServerInfo = ./types/ServerInfo.dhall

let ForcedHost = ./types/ForcedHost.dhall

let convServerInfo = ./functions/ServerInfo/toToml.dhall

let convForcedHosts = ./functions/ForcedHost/toToml.dhall

let cfgType = ./schema.dhall

let cfg = env:CONFIG_FILE ? ./config.dhall : cfgType

in  ''
    config-version = "1.0"
    bind = "${cfg.bind}"
    motd = "${cfg.motd}"
    show-max-players = ${Natural/show cfg.show-max-players}
    online-mode = ${Bool/bshow cfg.online-mode}
    player-info-forwarding-mode = "${cfg.player-info-forwarding-mode}"
    forwarding-secret = "${cfg.forwarding-secret}"
    announce-forge = ${Bool/bshow cfg.announce-forge}
    kick-existing-players = ${Bool/bshow cfg.kick-existing-players}
    ping-passthrough = "${cfg.ping-passthrough}"

    [servers]
    ${Text/concatSep "\n" (List/map ServerInfo Text convServerInfo cfg.servers)}
    try = [${Text/concatSep ", " (List/map Text Text Text/show cfg.try)}]

    [forced-hosts]
    ${Text/concatSep
        "\n"
        (List/map ForcedHost Text convForcedHosts cfg.forced-hosts)}

    [advanced]
    compression-threshold = ${Integer/show cfg.advanced.compression-threshold}
    compression-level = ${Integer/show cfg.advanced.compression-level}
    login-ratelimit = ${Natural/show cfg.advanced.login-ratelimit}
    connection-timeout = ${Natural/show cfg.advanced.connection-timeout}
    read-timeout = ${Natural/show cfg.advanced.read-timeout}
    proxy-protocol = ${Bool/bshow cfg.advanced.proxy-protocol}
    tcp-fast-open = ${Bool/bshow cfg.advanced.tcp-fast-open}

    [query]
    enabled = ${Bool/bshow cfg.query.enabled}
    port = ${Natural/show cfg.query.port}
    map = "${cfg.query.map}"
    show-plugins = ${Bool/bshow cfg.query.show-plugins}

    [metrics]
    enabled = ${Bool/bshow cfg.metrics.enabled}
    id = "${cfg.metrics.id}"
    log-failure = ${Bool/bshow cfg.metrics.log-failure}
    ''
