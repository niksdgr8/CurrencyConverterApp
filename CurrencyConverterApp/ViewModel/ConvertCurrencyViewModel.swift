//
//  ConvertCurrencyViewModel.swift
//  CurrencyConverterApp
//
//  Created by Nikhil Gupta on 30/04/22.
//

import Foundation
import RxSwift
import RxCocoa

class ConvertCurrencyViewModel {
    
    public let currencySymbols: PublishSubject<[String]> = PublishSubject()
    public let convertedValue: PublishSubject<String> = PublishSubject()
    public let error: PublishSubject<NetworkError> = PublishSubject()
    public let loading: PublishSubject<Bool> = PublishSubject()
    
    func getValidCurrencySymbols() {
        self.loading.onNext(true)
        NetworkManager.shared.getDataResponse(urlString: "symbols", completionBlock: { [weak self] result in
                   guard let self = self else {return}
                self.loading.onNext(false)
                   switch result {
                   case .failure(let networkError):
                       if let error = networkError as? NetworkError {
                           self.error.onNext(error)
                       }
       
                   case .success(let dta) :
                       print("success", dta)
                     //  let json = (try? JSONSerialization.jsonObject(with: dta, options: [])) as? [String: AnyObject]
                       print("Success Response: \(dta)")
                       if let symbolsData = dta["symbols"] as? [String: String] {
                           let allSymbols = Array(symbolsData.keys)
                           let sortedSymbols = allSymbols.sorted()
                           self.currencySymbols.onNext(sortedSymbols)
                       }
                      // self.currencySymbols.onNext(Array(symbolsData.keys))
                      // let decoder = JSONDecoder()
       //                do
       //                {
       //                    self.breaches = try decoder.decode([BreachModel].self, from: dta)
       //                    completion(.success(try decoder.decode([BreachModel].self, from: dta)))
                     //  } catch {
                           // deal with error from JSON decoding if used in production
                      // }
                   }
               })
    }
    
    func getConvertedCurrency(fromSymbol: String, toSymbol: String, valueToConvert: String) {
        var queryItemsDict = [String: String]()
        queryItemsDict["base"] = "EUR"
        queryItemsDict["symbols"] = fromSymbol + "," + toSymbol
        self.loading.onNext(true)
        NetworkManager.shared.getDataResponse(urlString: "latest", queryItems: queryItemsDict, completionBlock: { [weak self] result in
            guard let self = self else { return }
            self.loading.onNext(false)
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
                        self.convertCurrency(fromValue: fromValue, toValue: toValue, valueToConvert: value)
                    }
                }
            }
            
        })
    }
    
    func convertCurrency(fromValue: Double, toValue:Double, valueToConvert: Double) {
         let convertValue = (toValue * valueToConvert) / fromValue
        self.convertedValue.onNext(String(format: "%.3f", convertValue))
       
    }
}
