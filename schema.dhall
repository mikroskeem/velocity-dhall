let ServerInfo = ./types/ServerInfo.dhall

let ForcedHost = ./types/ForcedHost.dhall

let t
    : Type
    = { bind : Text
      , motd : Text
      , show-max-players : Natural
      , online-mode : Bool
      , player-info-forwarding-mode : Text
      , forwarding-secret : Text
      , announce-forge : Bool
      , kick-existing-players : Bool
      , ping-passthrough : Text
      , servers : List ServerInfo
      , try : List Text
      , forced-hosts : List ForcedHost
      , advanced :
          { compression-threshold : Integer
          , compression-level : Integer
          , login-ratelimit : Natural
          , connection-timeout : Natural
          , read-timeout : Natural
          , proxy-protocol : Bool
          , tcp-fast-open : Bool
          }
      , query :
          { enabled : Bool, port : Natural, map : Text, show-plugins : Bool }
      , metrics : { enabled : Bool, id : Text, log-failure : Bool }
      }

in  t
