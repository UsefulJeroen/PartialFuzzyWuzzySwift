# PartialFuzzyWuzzySwift
Fuzzywuzzy port in Swift using Levenshtein Distance.
Ported from the C# Fuzzywuzzy library
https://github.com/JakeBayer/FuzzySharp

It has no external dependencies. 
And thanks to Swift String, it support's multi-language.
But it only supports the Partial Ratio, and it's pretty slow.

## Installation
### Swift Package Manager
The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. 
Use the following url to add this project in Xcode 11:
```swift
https://github.com/swing7wing/PartialFuzzyWuzzySwift/
```

## Usage
```swift
import PartialFuzzyWuzzyString
```

### Partial Ratio
Partial Ratio tries to match the shorter string to a substring of the longer one
```swift
String.fuzzPartialRatio(str1: "some text here", str2: "I found some text here!") // => 100
String.fuzzPartialRatio(str1: "wonderful 世", str2: "what a wonderful 世界") // => 100
String.fuzzPartialRatio(str1: "similar", str2: "somewhresimlrbetweenthisstring") // => 71
```

## Credits
* SeatGeek
* Adam Cohen
* David Necas (python-Levenshtein)
* Mikko Ohtamaa (python-Levenshtein)
* Antti Haapala (python-Levenshtein)
* Panayiotis (Java implementation)
* Jake Bayer (C# implementation I heavily borrowed from)
