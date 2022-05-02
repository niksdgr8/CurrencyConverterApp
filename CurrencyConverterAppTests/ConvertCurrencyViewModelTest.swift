//
//  ConvertCurrencyViewModelTest.swift
//  CurrencyConverterAppTests
//
//  Created by Nikhil Gupta on 02/05/22.
//

import XCTest
@testable import CurrencyConverterApp

class ConvertCurrencyViewModelTest: XCTestCase {
    var convertCurrency: ConvertCurrencyViewModel?
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        convertCurrency = ConvertCurrencyViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        convertCurrency = nil
    }
    
    func testConvertCurrency() throws {
        guard let convertCurrencyModel = convertCurrency else {
            return
        }
        let convertedValue = convertCurrencyModel.convertCurrency(fromValue: 1.0, toValue: 1.0, valueToConvert: 2.0)
        
        XCTAssertNotNil(convertedValue)
        XCTAssertEqual(convertedValue, "2.000")
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
