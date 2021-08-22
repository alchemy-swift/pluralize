// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "pluralize",
    products: [
        .library(name: "Pluralize", targets: ["Pluralize"])
    ],
    dependencies: [],
    targets: [
        .target(name: "Pluralize"),
        .testTarget(
            name: "PluralizeTests",
            dependencies: [
                .target(name: "Pluralize")
            ]
        )
    ]
)
