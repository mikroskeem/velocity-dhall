let Bool/bshow
    : Bool → Text
    = λ(b : Bool) → if b then "true" else "false"

let List/map
    : ∀(a : Type) → ∀(b : Type) → (a → b) → List a → List b
    =   λ(a : Type)
      → λ(b : Type)
      → λ(f : a → b)
      → λ(xs : List a)
      → List/build
          b
          (   λ(list : Type)
            → λ(cons : b → list → list)
            → List/fold a xs list (λ(x : a) → cons (f x))
          )

let Status = < Empty | NonEmpty : Text >

let Text/concatSep
    : ∀(separator : Text) → ∀(elements : List Text) → Text
    =   λ(separator : Text)
      → λ(elements : List Text)
      → let status =
              List/fold
                Text
                elements
                Status
                (   λ(element : Text)
                  → λ(status : Status)
                  → merge
                      { Empty = Status.NonEmpty element
                      , NonEmpty =
                            λ(result : Text)
                          → Status.NonEmpty (element ++ separator ++ result)
                      }
                      status
                )
                Status.Empty

        in  merge { Empty = "", NonEmpty = λ(result : Text) → result } status

let ServerInfo
    : Type
    = { name : Text, address : Text, port : Natural }

let ForcedHost
    : Type
    = { host : Text, servers : List Text }

let convServerInfo
    : ServerInfo → Text
    =   λ(i : ServerInfo)
      → "\"${i.name}\" = \"${i.address}:${Natural/show i.port}\""

let convForcedHosts
    : ForcedHost → Text
    =   λ(f : ForcedHost)
      → "\"${f.host}\" = [${Text/concatSep
                              ", "
                              (List/map Text Text Text/show f.servers)}]"

let cfg =
      { bind = "0.0.0.0:25577"
      , motd = "&3A Velocity Proxy"
      , show-max-players = 500
      , online-mode = True
      , player-info-forwarding-mode = "MODERN"
      , forwarding-secret = "yeet"
      , announce-forge = False
      , kick-existing-players = False
      , ping-passthrough = "DISABLED"
      , servers =
            [ { name = "hub1", address = "127.0.0.1", port = 25565 }
            , { name = "hub2", address = "127.0.0.1", port = 25566 }
            ]
          : List ServerInfo
      , try = [ "hub1" ]
      , forced-hosts =
            [ { host = "hub.example.com", servers = [ "hub1", "hub2" ] } ]
          : List ForcedHost
      , advanced =
          { compression-threshold = -1
          , compression-level = -1
          , login-ratelimit = 3000
          , connection-timeout = 5000
          , read-timeout = 30000
          , proxy-protocol = True
          , tcp-fast-open = True
          }
      , query =
          { enabled = False
          , port = 25577
          , map = "Velocity"
          , show-plugins = False
          }
      , metrics = { enabled = True, id = "", log-failure = False }
      }

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
