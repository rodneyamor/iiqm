//
//  IIQMTests.swift
//  IIQMTests
//
//  Created by Ryan Arana on 6/15/18.
//  Copyright © 2018 Dexcom. All rights reserved.
//

import XCTest

@testable import IIQM

final class IIQMTests: XCTestCase {
    
    func testCalculateIQM() {
        let tenValues = [301, 286, 287, 292, 311, 314, 303, 312, 299, 297, 280]
        let nineValues = [295, 301, 287, 301, 309, 296, 290, 290, 281]
        let eightValues = [307, 319, 316, 285, 292, 312, 293, 320]
        let sevenValues = [314, 282, 298, 291, 302, 305, 319]
        
        XCTAssertEqual(expectedIQM(for: tenValues), IIQM.calculateIQM(using: tenValues))
        XCTAssertEqual(expectedIQM(for: nineValues), IIQM.calculateIQM(using: nineValues))
        XCTAssertEqual(expectedIQM(for: eightValues), IIQM.calculateIQM(using: eightValues))
        XCTAssertEqual(expectedIQM(for: sevenValues), IIQM.calculateIQM(using: sevenValues))
    }
}

extension IIQMTests {
    
    private func expectedIQM(for data: [Int]) -> Double {
        let q: Double = Double(data.count) / 4.0
        let i: Int = Int(q.rounded(.up)) - 1
        let c: Int = Int((q * 3).rounded(.down)) - i + 1
        let ys = data[i...(i + c - 1)]
        let factor: Double = q - ((Double(ys.count) / 2.0) - 1)
        var sum = 0
    
        var j = 0
        for listEnumerator in ys {
            if (j == 0) {
                j += 1
                continue;
            }
            else if (j == (ys.count - 1)) {
                break;
            }
    
            sum += listEnumerator
            j += 1
        }
    
        return (Double(sum) + Double(ys.first! + ys.last!) * factor) / (2.0 * q)
    }
}
