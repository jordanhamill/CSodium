import PackageDescription

let package = Package(
    name: "CSodium",
    pkgConfig: "libsodium",
    providers: [
        .Brew("libsodium"),
        .Apt("libsodium-dev")
    ]
)
