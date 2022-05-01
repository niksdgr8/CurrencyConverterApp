//
//  CurrencyDetailsViewModel.swift
//  CurrencyConverterApp
//
//  Created by Nikhil Gupta on 30/04/22.
//

import Foundation
import RxSwift
import RxCocoa

class CurrencyDetailsViewModel {
    
    public let currencyModel: PublishSubject<[CurrencyModel]> = PublishSubject()
    public let historicalDataModel: PublishSubject<[HistoricalDataModel]> = PublishSubject()
    public let error: PublishSubject<NetworkError> = PublishSubject()
    
    func getHistoricalCurrencyData(fromSymbol: String, toSymbol: String, valueToConvert: String, convertedLatestValue: String) {
        var queryItemsDict = [String: String]()
        queryItemsDict["base"] = "EUR"
        queryItemsDict["symbols"] = fromSymbol + "," + toSymbol
        
        var historicalModel = [HistoricalDataModel]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateStr:String = dateFormatter.string(from: NSDate() as Date)
        historicalModel.append(HistoricalDataModel(fromCurrencySymbol: fromSymbol, fromCurrencyValue: valueToConvert, toCurrencySymobl: toSymbol, toCurrencyValue: convertedLatestValue, dateString: dateStr))
        
        let dispatchGroup = DispatchGroup()
        
        let datesArray = self.getHistoricalDates()
        
        for dateString in datesArray {
            dispatchGroup.enter()
            NetworkManager.shared.getDataResponse(urlString: dateString, queryItems: queryItemsDict, completionBlock: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .failure(let networkError):
                    if let error = networkError as? NetworkError {
                        self.error.onNext(error)
                    }
                case .success(let dta) :
                    print("success", dta)
                  //  let json = (try? JSONSerialization.jsonObject(with: dta, options: [])) as? [String: AnyObject]
                    print("Success Response: \(dta)")
                    if let rates = dta["rates"] as? [String: Double] {
                        if let fromValue = rates[fromSymbol], let toValue = rates[toSymbol], let value = Double(valueToConvert) {
                            let convertedValue = self.convertCurrency(fromValue: fromValue, toValue: toValue, valueToConvert: value)
                            historicalModel.append(HistoricalDataModel(fromCurrencySymbol: fromSymbol, fromCurrencyValue: valueToConvert, toCurrencySymobl: toSymbol, toCurrencyValue: convertedValue, dateString: dateString))
                        }
                    }
                }
                dispatchGroup.leave()
                
            })
        }
        dispatchGroup.notify(queue: .main) {
            self.historicalDataModel.onNext(historicalModel)
        }
    }
    
    func getConvertedCurrency(fromSymbol: String, toSymbol: [String], valueToConvert: String) {
        var queryItemsDict = [String: String]()
        queryItemsDict["base"] = "EUR"
        var symbolData = fromSymbol
        for symbol in toSymbol {
            symbolData += "," + symbol
        }
        queryItemsDict["symbols"] = symbolData
      
        NetworkManager.shared.getDataResponse(urlString: "latest", queryItems: queryItemsDict, completionBlock: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let networkError):
                if let error = networkError as? NetworkError {
                    self.error.onNext(error)
                }

            case .success(let dta) :
                print("success", dta)
              //  let json = (try? JSONSerialization.jsonObject(with: dta, options: [])) as? [String: AnyObject]
                print("Success Response: \(dta)")
                if let rates = dta["rates"] as? [String: Double] {
                    self.createData(toSymbols: toSymbol, ratesData: rates, fromSymbol: fromSymbol, valueToConvert: valueToConvert)
//                    if let fromValue = rates[fromSymbol], let toValue = rates[toSymbol], let value = Double(valueToConvert) {
//                        self.convertCurrency(fromValue: fromValue, toValue: toValue, valueToConvert: value)
//                    }
                }
            }
            
        })

    }
        
    func createData(toSymbols:[String], ratesData:[String: Double], fromSymbol: String, valueToConvert: String) {
        var model = [CurrencyModel]()
        for symbol in toSymbols {
            if let fromValue = ratesData[fromSymbol], let toValue = ratesData[symbol], let value = Double(valueToConvert) {
                let convertedValue = convertCurrency(fromValue: fromValue, toValue: toValue, valueToConvert: value)
                model.append(CurrencyModel(currencySymbol: symbol, currencyValue: convertedValue))
            
            }
            
            
        }
        self.currencyModel.onNext(model)
    }
    
    func convertCurrency(fromValue: Double, toValue:Double, valueToConvert: Double) -> String {
         let convertValue = (toValue * valueToConvert) / fromValue
        return String(format: "%.3f", convertValue)
       
    }
    
    func getHistoricalDates() -> [String] {
        
        var datesData = [String]()
        
        for  i in 0...1{
            let lastWeekDate = NSCalendar.current.date(byAdding: .day, value: -(1+i), to: NSDate() as Date)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateStr:String = dateFormatter.string(from: lastWeekDate!)
            datesData.append(dateStr)
        }
        return datesData
    }
}