# CSodium

[Libsodium](https://github.com/jedisct1/libsodium) wrapper for Swift crypto.

# Usage

```swift
import PackageDescription

let package = Package(
    name: "MyApp",
    dependencies: [
        .Package(url: "https://github.com/jordanhamill/CSodium.git", majorVersion: 0, minor: 1),
   ]
)
```

```swift
import CSodium
sodium_init()

enum Sodium {
     enum OpsLimit {
         case Interactive
         case Moderate
         case Sensitive

         var rawValue: Int {
             switch self {
             case .Interactive:
                 return Int(crypto_pwhash_opslimit_interactive())
             case .Moderate:
                 return Int(crypto_pwhash_opslimit_moderate())
             case .Sensitive:
                 return Int(crypto_pwhash_opslimit_sensitive())
             }
         }
     }

     enum MemLimit {
         case Interactive
         case Moderate
         case Sensitive

         var rawValue: Int {
             switch self {
             case .Interactive:
                 return Int(crypto_pwhash_memlimit_interactive())
             case .Moderate:
                 return Int(crypto_pwhash_memlimit_moderate())
             case .Sensitive:
                 return Int(crypto_pwhash_memlimit_sensitive())
             }
         }
     }

     static func hash(password pwdString: String, opsLimit: OpsLimit, memLimit: MemLimit) -> String? {
         guard let password = pwdString.data(using: .utf8) else { return nil }
         let StrBytes = Int(crypto_pwhash_strbytes()) - (1 as Int)

         var output = Data(count: StrBytes)
         let result = output.withUnsafeMutableBytes { outputPtr in
             return password.withUnsafeBytes { passwdPtr in
                 return crypto_pwhash_str(outputPtr,
                                          passwdPtr,
                                          CUnsignedLongLong(password.count),
                                          CUnsignedLongLong(opsLimit.rawValue),
                                          size_t(memLimit.rawValue)
                 )
             }
         }

         if result != 0 {
             return nil
         }

         return String(data: output, encoding: .utf8)
     }
 }

 print("sodium test", Sodium.hash(password: "hello", opsLimit: .Interactive, memLimit: .Interactive) ?? "-none-")
 // sodium test $argon2i$v=19$m=32768,t=4,p=1$Hkh31FcE6Txm+JmeX9BMWA$pgIn6F+8Nl3qG34axiD7ARSITPJj8cy5k6hyVDavIto                               
```

## Installation
```
// macos
$ brew install libsodium
// Ubuntu
$ apt-get install libsodium-dev

```

Ubuntu 16.04 (the base image for swiftdocker/swift) only has packages up to `libsodium` 1.0.8 with `apt-get`. You'll want to compile from source (or ppa) to get access to newer features like Argon2.
```
$ curl https://download.libsodium.org/libsodium/releases/libsodium-1.0.11.tar.gz | tar xyz
$ cd libsodium-1.0.11
$ ./configure
$ make && make check
$ make install
```
