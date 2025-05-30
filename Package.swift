// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "Stockfish",
    products: [
        .library(name: "Stockfish", targets: ["Stockfish"]),
    ],
    targets: [
        .target(
            name: "CStockfish",
            publicHeadersPath: ".",
            cxxSettings: [
                .headerSearchPath("Stockfish/src"),
                .define("NNUE_EMBEDDING_OFF"),
                .define("INCBIN_SILENCE_BITCODE_WARNING"),
            ],
            linkerSettings: [.linkedLibrary("m", .when(platforms: [.android]))]
        ),
        .target(
            name: "Stockfish",
            dependencies: ["CStockfish"],
            swiftSettings: [.interoperabilityMode(.Cxx)]
        ),
        .testTarget(
            name: "StockfishTests",
            dependencies: ["Stockfish"],
            swiftSettings: [.interoperabilityMode(.Cxx)]
        )
    ],
    cxxLanguageStandard: .cxx17
)
