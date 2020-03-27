let ServerInfo = ../../types/ServerInfo.dhall

let f
    : ServerInfo → Text
    =   λ(i : ServerInfo)
      → "\"${i.name}\" = \"${i.address}:${Natural/show i.port}\""

in  f
