//
//  DiffUtils.swift
//  
//
//  Created by Jeroen Besse on 18/11/2019.
//

import Foundation

/*  This is a port of the C# based fuzzywuzzy implementation.
    https://github.com/JakeBayer/FuzzySharp
    This has all the functions needed from the Python-levenshtein C implementation.
    The code was ported line by line but unfortunately it was mostly undocumented,
    so it is mostly non readable (eg. var names)  */
class DiffUtils {
    
    class func getRatio(s1: String, s2: String) -> Double {
        
        let totalLength = s1.count + s2.count
        
        if totalLength == 0 {
            return 0
        }
        
        let levDistance = getLevDistance(s1: s1, s2: s2)
        let ratio = Double(totalLength - levDistance) / Double(totalLength)
        
        return ratio
    }
    
    class func getLevDistance(s1: String, s2: String) -> Int {
        var i: Int
        let c1 = Array(s1)
        let c2 = Array(s2)
        var str1 = 0
        var str2 = 0
        var len1 = s1.count
        var len2 = s2.count
        
        /* strip common prefix */
        while len1 > 0 && len2 > 0 && c1[str1] == c2[str2] {
            len1 -= 1
            len2 -= 1
            str1 += 1
            str2 += 1
        }
        
        /* strip common suffix */
        while len1 > 0 && len2 > 0 && c1[str1 + len1 - 1] == c2[str2 + len2 - 1] {
            len1 -= 1
            len2 -= 1
        }
        
        /* catch trivial cases */
        if len1 == 0 {
            return len2
        }
        if len2 == 0 {
            return len1
        }
        
        /* check len1 == 1 separately */
        if len1 == 1 {
            return len2 + 1 - 2 * memchr(haystack: c2, offset: str2, needle: c1[str1], num: len2)
        }
        
        len1 += 1
        len2 += 1
        
        var row: [Int: Int] = [:]
        let end = len2 - 1
        
        for index in 0..<len2 {
            row[index] = index
        }
        
        /* go through the matrix and compute the costs. yes this is an extremely obfuscated version, but also extremely memory-conservative and relatively fast. */
        for index in 1..<len1 {
            var p = 1
            let ch1 = c1[str1 + index - 1]
            var c2p = str2
            var d = index
            var x = index
            while p <= end {
                if ch1 == c2[c2p] {
                    d -= 1
                    x = d
                } else {
                    x += 1
                }
                c2p += 1
                
                d = row[p]!
                d += 1
                
                if x > d {
                    x = d
                }
                row[p] = x
                p += 1
            }
        }
        i = row[end]!
        return i
    }
    
    class func memchr(haystack: [Character], offset: Int, needle: Character, num: Int) -> Int {
        var num = num
        if num != 0 {
            var p = 0
            repeat {
                if haystack[offset + p] == needle {
                    return 1
                }
                p += 1
                num -= 1
            } while num != 0
        }
        return 0
    }
}
