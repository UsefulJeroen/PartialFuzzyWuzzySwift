# PartialFuzzyWuzzySwift
Fuzzywuzzy port in Swift using Levenshtein Distance.
Ported from the C# Fuzzywuzzy library
https://github.com/JakeBayer/FuzzySharp

It has no external dependencies. 
And thanks to Swift String, it support's multi-language.
But it only supports the Partial Ratio.

## Installation
#### TODO

## Usage
```swift
import Fuzzywuzzy_swift
```

### Partial Ratio
Partial Ratio tries to match the shorter string to a substring of the longer one
```swift
String.fuzzPartialRatio(str1: "some text here", str2: "I found some text here!") // => 100
```

## Credits
* SeatGeek
* Adam Cohen
* David Necas (python-Levenshtein)
* Mikko Ohtamaa (python-Levenshtein)
* Antti Haapala (python-Levenshtein)
* Panayiotis (Java implementation)
* Jake Bayer (C# implementation I heavily borrowed from)
