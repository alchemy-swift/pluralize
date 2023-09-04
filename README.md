# Pluralize

Pluralize is a Swift only port of the string inflection functionality from
[InflectorKit](https://github.com/mattt/InflectorKit).

## Usage

### Swift

```swift
import InflectorKit

for singular in ["person", "tomato", "matrix", "octopus", "fish"] {
    print("\(singular) → \(singular.pluralized)")
}
/*
Prints:
person → people
tomato → tomatoes
matrix → matrices
octopus → octopi
fish → fish
*/

// You can also add pluralization rules,
// including irregular and uncountable words:

let inflector = StringInflector.default
inflector.addPluralRule(#"^i(Pod|Pad)( Mini)?$"#, replacement: #"i$1s$2"#)
inflector.addIrregular(singular: "lol", plural: "lolz")
inflector.addUncountable("Herokai")

for singular in ["iPad Mini", "lol", "Herokai"] {
    print("\(singular) → \(singular.pluralized)")
}
/*
Prints:
iPad Mini → iPads Mini
lol → lolz
Herokai → Herokai
*/
```

## Installation

### Swift Package Manager

Add the Pluralize package to your target dependencies in `Package.swift`:

```swift
import PackageDescription

let package = Package(
  name: "YourProject",
  dependencies: [
    .package(
        url: "https://github.com/alchemy-swift/pluralize",
        from: "1.0.0"
    ),
  ]
)
```

Then run the `swift build` command to build your project.

## License

MIT
