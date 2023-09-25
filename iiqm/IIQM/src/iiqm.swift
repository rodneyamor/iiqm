//
//  iiqm.swift
//  IIQM
//
//  Created by Shaun Winters on 9/21/17.
//  Copyright © 2017 Dexcom. All rights reserved.
//

import Foundation

final class IIQM {
    
    /// Refactoring
    ///  - The original algorithm took too much time to read and understand. So I decided to rewrite the algorithm with one I could find online since it would be accessible for everyone and would also make it easier for me to make it more readable.
    ///     - Source: https://www.statisticshowto.com/interquartile-mean-iqm-midmean/
    ///  - I broke out the logic into a few functions to improve organization, readability, and testing. The previous version had the entire logic in one function which made it overwhelming to read. Please read my notes on the function `calculateMeanOfIQM`.
    ///     - I changed the name of the main function `calculate(for:)` since it did not explain what it was calculating for or that it would also print values. `calculateAndPrintIQM(forFileWithPath:)` fixes those issues as well as being a more "Swiftly" like function.
    ///  - The previous version used a naming scheme that poorly explained what a variable was for, playing a part in the difficulty of understanding the algorithm. So I improved it by providing more meaningful names such as "quartile".
    ///  - I've kept the old algorithm in the test file so that I can use it to create expected results for testing.
    
    /// Calculates and prints out the interquartile mean of each line of a text file containing integer numbers.
    ///
    /// - Parameters:
    ///     - path: The file path of the text file containing the set of numbers to calculate the IQM from.
    func calculateAndPrintIQM(forFileWithPath path: String) {
        let lines = readFile(path: path)
        var data: [Int] = []
        
        for line in lines {
            // Normally I would avoid force-unwrapping. But in this case, I'm assuming that each line is an integer. Otherwise, I would throw a guard in there.
            let value: Int = Int(line)!
            data.append(value)
            data.sort()
            
            guard data.count >= 4 else {
                continue
            }

            let mean = Self.calculateIQM(using: data)
            let meanString = String(format:"%.2f", mean)

            print("Index => \(data.count), Mean => \(meanString)")
        }
    }
    
    /// This function is internal so that developers can run tests with it since it handles the main logic of the calculation.
    /// By making it static, developers won't have to create an `IIQM` object for testing.
    static func calculateIQM(using data: [Int]) -> Double {
        if data.count % 4 == 0 {
            return calculateDivisibleIQM(using: data)
        } else {
            return calculateNonDivisibleIQM(using: data)
        }
    }
    
    private static func calculateDivisibleIQM(using data: [Int]) -> Double {
        var localData = data

        let numberOfItemsToRemove = Int(data.count / 4)
        localData.removeFirst(numberOfItemsToRemove)
        localData.removeLast(numberOfItemsToRemove)

        return Double(localData.reduce(0, +)) / Double(localData.count)
    }
    
    private static func calculateNonDivisibleIQM(using data: [Int]) -> Double {
        var localData = data

        let quartile = Double(data.count) / 4
        let numberOfItemsToRemove = Int(quartile.rounded(.down))

        localData.removeFirst(numberOfItemsToRemove)
        localData.removeLast(numberOfItemsToRemove)

        let first = localData.removeFirst()
        let last = localData.removeLast()

        let multiplier = 1 - (quartile - Double(numberOfItemsToRemove))
        let sum = (Double(first + last) * multiplier) + Double(localData.reduce(0, +))
        
        return Double(sum) / Double((quartile * 2))
    }
    
    private func readFile(path: String) -> [String] {
        do {
            let contents = try NSString(contentsOfFile: path, encoding: String.Encoding.ascii.rawValue)
            let trimmed = contents.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
            let lines =  NSString(string: trimmed).components(separatedBy: NSCharacterSet.newlines)
            
            return lines
            
        } catch {
            print("Unable to read file: \(path)")
            
            return []
        }
    }
}
