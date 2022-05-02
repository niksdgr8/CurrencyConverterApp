//
//  CurrencyDetailsViewModelTests.swift
//  CurrencyConverterAppTests
//
//  Created by Nikhil Gupta on 02/05/22.
//

import XCTest
@testable import CurrencyConverterApp

class CurrencyDetailsViewModelTests: XCTestCase {
    var currencyDetailModel: CurrencyDetailsViewModel?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        currencyDetailModel = CurrencyDetailsViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        currencyDetailModel = nil
    }
    
    func testConvertCurrency() throws {
        guard let convertCurrencyDetailsModel = currencyDetailModel else {
            return
        }
        let convertedValue = convertCurrencyDetailsModel.convertCurrency(fromValue: 1.0, toValue: 1.0, valueToConvert: 2.0)
        
        XCTAssertNotNil(convertedValue)
        XCTAssertEqual(convertedValue, "2.000")
    }
    
    func testGetHistoricalDates() throws {
        guard let convertCurrencyDetailsModel = currencyDetailModel else {
            return
        }
        
        let dates = convertCurrencyDetailsModel.getHistoricalDates()
        XCTAssertNotNil(dates)
        XCTAssertEqual(dates.count, 2)
        
    }
    
    func testGetPopularCurrencySymbols() throws {
        guard let convertCurrencyDetailsModel = currencyDetailModel else {
            return
        }
        
        let popularCurrency = convertCurrencyDetailsModel.getPopularCurrencySymbols()
        XCTAssertNotNil(popularCurrency)
        XCTAssertGreaterThanOrEqual(popularCurrency.count, 10)
    }
    
    func testCreateOtherCurrencyData() throws {
        guard let convertCurrencyDetailsModel = currencyDetailModel else {
            return
        }
        
        let rates = ["INR" : 1.0, "CAD": 2.0, "EUR": 3.0]
        let toArray = ["INR", "CAD"]
        
        let currencyData = convertCurrencyDetailsModel.createOtherCurrencyData(toSymbols: toArray, ratesData: rates, fromSymbol: "EUR", valueToConvert: "2")
        
        XCTAssertNotNil(currencyData)
        XCTAssertEqual(currencyData.count, 2)

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
