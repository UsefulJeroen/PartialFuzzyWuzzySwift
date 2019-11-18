//
//  Levenshtein.swift
//  
//
//  Created by Jeroen Besse on 18/11/2019.
//

import Foundation

class Levenshtein: NSObject {

    class func getMatchingBlocks(s1: String, s2: String) -> [MatchingBlock] {
        let ops = getEditOps(s1: s1, s2: s2)
        let len1 = s1.count
        let len2 = s2.count
        
        let n = ops.count
        
        var numberOfMatchingBlocks: Int
        var i: Int
        var sourcePos: Int
        var destPos: Int
        
        numberOfMatchingBlocks = 0
        var o = 0
        sourcePos = 0
        destPos = 0
        var type: EditType
        
        i = n
        while i != 0 {
            
            i -= 1
            while ops[o].editType == .keep && i != 0 {
                o += 1
            }
            if i == 0 {
                break
            }
            if sourcePos < ops[o].sourcePos! || destPos < ops[o].destPos! {
                numberOfMatchingBlocks += 1
                sourcePos = ops[o].sourcePos!
                destPos = ops[o].destPos!
            }
            
            if let type = ops[o].editType {
                switch type {
                case .replace:
                    repeat {
                        sourcePos += 1
                        destPos += 1
                        i -= 1
                        o += 1
                    } while i != 0 && ops[0].editType == type && sourcePos == ops[0].sourcePos && destPos == ops[o].destPos
                    break
                
                case .delete:
                    repeat {
                        sourcePos += 1
                        i -= 1
                        o += 1
                    } while i != 0 && ops[o].editType == type && sourcePos == ops[o].sourcePos && destPos == ops[o].destPos
                    break
                    
                case .insert:
                    repeat {
                        destPos += 1
                        i -= 1
                        o += 1
                    } while i != 0 && ops[0].editType == type && sourcePos == ops[o].sourcePos && destPos == ops[o].destPos
                    break
                    
                default:
                    break
                }
            }
        }
        if sourcePos < len1 || destPos < len2 {
            numberOfMatchingBlocks += 1
        }
        var matchingBlocks = [Int: MatchingBlock]()
        o = 0
        sourcePos = 0
        destPos = 0
        var mbIndex = 0
        
        i = n
        while i != 0 {
            i -= 1
            while ops[o].editType == .keep && i != 0 {
                o += 1
            }
            if i == 0 {
                break
            }
            if sourcePos < ops[o].sourcePos! || destPos < ops[o].destPos! {
                let mb = MatchingBlock(sourcePos: sourcePos, destPos: destPos, length: ops[o].sourcePos! - sourcePos)
                sourcePos = ops[o].sourcePos!
                destPos = ops[o].destPos!
                matchingBlocks[mbIndex] = mb
                mbIndex += 1
            }
            type = ops[o].editType!
            
            switch type {
            case .replace:
                repeat {
                    sourcePos += 1
                    destPos += 1
                    i -= 1
                    o += 1
                } while i != 0 && ops[o].editType == type && sourcePos == ops[o].sourcePos && destPos == ops[0].destPos
                break
            case .delete:
                repeat {
                    sourcePos += 1
                    i -= 1
                    o += 1
                } while i != 0 && ops[o].editType == type && sourcePos == ops[o].sourcePos && destPos == ops[o].destPos
                break
            case .insert:
                repeat {
                    destPos += 1
                    i -= 1
                    o += 1
                } while i != 0 && ops[o].editType == type && sourcePos == ops[o].sourcePos && destPos == ops[o].destPos
                break
            default:
                break
            }
        }
        
        if sourcePos < len1 || destPos < len2 {
            let mb = MatchingBlock(sourcePos: sourcePos, destPos: destPos, length: len1 - sourcePos)
            
            matchingBlocks[mbIndex] = mb
            mbIndex += 1
        }
        
        let finalBlock = MatchingBlock(sourcePos: len1, destPos: len2, length: 0)
        
        matchingBlocks[mbIndex] = finalBlock
        
        var matchingBlocksArray: [MatchingBlock] = []
        for block in matchingBlocks.sorted(by: { $0.key < $1.key }) {
            matchingBlocksArray.append(block.value)
        }
        
        return matchingBlocksArray
    }
    
    private class func getEditOps(s1: String, s2: String) -> [EditOp] {
        var len1 = s1.count
        let c1 = Array(s1)
        var len2 = s2.count
        let c2 = Array(s2)
        
        var matrix = [Int: Int]()
        
        var p1 = 0
        var p2 = 0
        
        var len1o = 0
        
        while len1 > 0 && len2 > 0 && c1[p1] == c2[p2] {
            len1 -= 1
            len2 -= 1
            
            p1 += 1
            p2 += 1
            
            len1o += 1
        }
        let len2o = len1o
        
        //strip common suffix
        while len1 > 0 && len2 > 0 && c1[p1 + len1 - 1] == c2[p2 + len2 - 1] {
            len1 -= 1
            len2 -= 1
        }
        len1 += 1
        len2 += 1
        
        for index in 0..<len2 {
            matrix[index] = index
        }
        for index in 1..<len1 {
            matrix[len2 * index] = index
        }
        
        for index in 1..<len1 {
            var ptrPrev = (index - 1) * len2
            var ptrC = index * len2
            let ptrEnd = ptrC + len2 - 1
            
            let char1 = c1[p1 + index - 1]
            var ptrChar2 = p2
            
            var x = index
            
            ptrC += 1
            
            while ptrC <= ptrEnd {
                
                var c3 = matrix.filter({ $0.key == ptrPrev }).first!.value + (char1 != c2[ptrChar2] ? 1 : 0)
                x += 1
                ptrPrev += 1
                ptrChar2 += 1
                
                if x > c3 {
                    x = c3
                }
                c3 = matrix[ptrPrev]! + 1
                if x > c3 {
                    x = c3
                }
                matrix[ptrC] = x
                ptrC += 1
            }
        }
        var matrixArray: [Int] = []
        for m in matrix.sorted(by: { $0.key < $1.key }) {
            matrixArray.append(m.value)
        }
        return editOpsFromCostMatrix(len1: len1, c1: c1, p1: p1, o1: len1o, len2: len2, c2: c2, p2: p2, o2: len2o, matrix: matrixArray)
    }
    
    private class func editOpsFromCostMatrix(len1: Int, c1: [Character], p1: Int, o1: Int, len2: Int, c2: [Character], p2: Int, o2: Int, matrix: [Int]) -> [EditOp] {
        
        var i: Int
        var j: Int
        var pos: Int
        var ptr: Int
        pos = matrix[len1 * len2 - 1]
        var ops = [Int: EditOp]()
        var dir = 0
        i = len1 - 1
        j = len2 - 1
        ptr = len1 * len2 - 1
        
        while i > 0 || j > 0 {
            
            if dir < 0 && j != 0 && matrix[ptr] == matrix[ptr - 1] + 1 {
                let eop = EditOp()
                pos -= 1
                ops[pos] = eop
                eop.editType = .insert
                eop.sourcePos = i + o1
                j -= 1
                eop.destPos = j + o2
                ptr -= 1
                continue
            }
            if dir > 0 && i != 0 && matrix[ptr] == matrix[ptr - len2] + 1 {
                let eop = EditOp()
                pos -= 1
                ops[pos] = eop
                eop.editType = .delete
                i -= 1
                eop.sourcePos = i + o1
                eop.destPos = j + o2
                ptr -= len2
                continue
            }
            if i != 0 && j != 0 && matrix[ptr] == matrix[ptr - len2 - 1] && c1[p1 + i - 1] == c2[p2 + j - 1] {
                i -= 1
                j -= 1
                ptr -= len2 + 1
                dir = 0
                continue
            }
            if i != 0 && j != 0 && matrix[ptr] == matrix[ptr - len2 - 1] + 1 {
                pos -= 1
                let eop = EditOp()
                ops[pos] = eop
                eop.editType = .replace
                i -= 1
                eop.sourcePos = i + o1
                j -= 1
                eop.destPos = j + o2
                ptr -= len2 + 1
                dir = 0
                continue
            }
            if dir == 0 && j != 0 && matrix[ptr] == matrix[ptr - 1] + 1 {
                pos -= 1
                let eop = EditOp()
                ops[pos] = eop
                eop.editType = .insert
                eop.sourcePos = i + o1
                j -= 1
                eop.destPos = j + o2
                ptr -= 1
                dir = -1
                continue
            }
            if dir == 0 && i != 0 && matrix[ptr] == matrix[ptr - len2] + 1 {
                pos -= 1
                let eop = EditOp()
                ops[pos] = eop
                eop.editType = .delete
                i -= 1
                eop.sourcePos = i + o1
                eop.destPos = j + o2
                ptr -= len2
                dir = 1
                continue
            }
            print("Can't calculate edit op")
        }
        var opsArray: [EditOp] = []
        for op in ops.sorted(by: { $0.key < $1.key }) {
            opsArray.append(op.value)
        }
        return opsArray
    }
}
