// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "MarkWalkthrough",
    platforms: [.macOS(.v13)],
    products: [
        .library(name: "MarkWalkthrough", targets: ["MarkWalkthrough"]),
    ],
    dependencies: [
        .package(url: "https://github.com/MarkCodable/MarkCodable", from: "0.6.0"),
        .package(url: "https://github.com/EmergeTools/Pow", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "MarkWalkthrough",
            dependencies: [
                "MarkCodable",
                "Pow"
            ]
        )
    ]
)
