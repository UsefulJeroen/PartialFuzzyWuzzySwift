import XCTest
@testable import PartialFuzzyWuzzySwift

final class PartialFuzzyWuzzySwiftTests: XCTestCase {
    
    struct RatioTestCase {
        var str1: String
        var str2: String
        var expectedResult: Int
    }
    
    func testRatio() {
        
        var testCases: [RatioTestCase] = []
        testCases.append(RatioTestCase(str1: "this is a test", str2: "this is a test!", expectedResult: 100))
        testCases.append(RatioTestCase(str1: "", str2: "some", expectedResult: 0))
        testCases.append(RatioTestCase(str1: "abcd", str2: "XXXbcdeEEE", expectedResult: 75))
        testCases.append(RatioTestCase(str1: "what a wonderful 世界", str2: "wonderful 世", expectedResult: 100))
        testCases.append(RatioTestCase(str1: "similar", str2: "somewhresimlrbetweenthisstring", expectedResult: 71))
        
        for testCase in testCases {
            XCTAssert(String.fuzzPartialRatio(str1: testCase.str1, str2: testCase.str2) == testCase.expectedResult)
        }
    }
    
    func testMatchingBlocks() {
        
        let str1 = "this is a test"
        let str2 = "this is a test!"
        let matchingBlocks = Levenshtein.getMatchingBlocks(s1: str1, s2: str2)
        let expectedResult: [MatchingBlock] = [
            MatchingBlock(sourcePos: 0, destPos: 0, length: 14),
            MatchingBlock(sourcePos: 14, destPos: 15, length: 0)]
        
        XCTAssert(matchingBlocks == expectedResult)
    }

    static var allTests = [
        ("testRatio", testRatio),
        ("testMatchingBlocks", testMatchingBlocks)
    ]
}
