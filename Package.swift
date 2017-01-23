import PackageDescription

let package = Package(
    name: "CSodium",
    pkgConfig: "libsodium-dev",
    providers: [
        .Brew("libsodium"),
        .Apt("libsodium-dev")
    ]
)
