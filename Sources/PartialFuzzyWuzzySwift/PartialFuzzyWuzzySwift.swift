//
//  PartialFuzzyWuzzySwift.swift
//
//
//  Created by Jeroen Besse on 18/11/2019.
//

import UIKit

public extension String {

    /// try's to match the shorter string with the most common substring of the longer one
    static func fuzzPartialRatio(str1: String, str2: String) -> Int {
        let shorter: String
        let longer: String
        if str1.count < str2.count {
            shorter = str1
            longer = str2
        } else {
            shorter = str2
            longer = str1
        }

        let matchingBlocks = Levenshtein.getMatchingBlocks(s1: shorter, s2: longer)
        
        var scores: [Double] = []
        
        for block in matchingBlocks {
            
            let dist = block.destPos - block.sourcePos
            
            let longStart = dist > 0 ? dist : 0
            var longEnd = longStart + shorter.count
            
            if longEnd > longer.count {
                longEnd = longer.count
            }
            
            //handle empty strings
            var longSubstr: String
            if longStart != longEnd {
                let startIndex = longer.index(longer.startIndex, offsetBy: longStart)
                let endIndex = longer.index(longer.startIndex, offsetBy: longEnd - 1)
                longSubstr = String(longer[startIndex...endIndex])
            } else {
                longSubstr = ""
            }

            let ratio = DiffUtils.getRatio(s1: shorter, s2: longSubstr)

            if ratio > 0.995 {
                return 100
            }
            
            scores.append(ratio)
        }
        
        return Int((scores.max() ?? 0) * 100)
    }
}
