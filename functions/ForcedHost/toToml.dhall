let Text/concatSep =
      https://prelude.dhall-lang.org/Text/concatSep sha256:e4401d69918c61b92a4c0288f7d60a6560ca99726138ed8ebc58dca2cd205e58

let List/map =
      https://prelude.dhall-lang.org/List/map sha256:dd845ffb4568d40327f2a817eb42d1c6138b929ca758d50bc33112ef3c885680

let ForcedHost = ../../types/ForcedHost.dhall

let f
    : ForcedHost → Text
    =   λ(f : ForcedHost)
      → "\"${f.host}\" = [${Text/concatSep
                              ", "
                              (List/map Text Text Text/show f.servers)}]"

in  f
