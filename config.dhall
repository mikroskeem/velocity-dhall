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
, try = [ "hub1" ]
, forced-hosts = [ { host = "hub.example.com", servers = [ "hub1", "hub2" ] } ]
, advanced =
    { compression-threshold = +256
    , compression-level = -1
    , login-ratelimit = 3000
    , connection-timeout = 5000
    , read-timeout = 30000
    , proxy-protocol = False
    , tcp-fast-open = False
    }
, query =
    { enabled = False, port = 25577, map = "Velocity", show-plugins = False }
, metrics = { enabled = True, id = "", log-failure = False }
}
