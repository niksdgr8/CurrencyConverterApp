//
//  CurrencyDetailsViewController.swift
//  CurrencyConverterApp
//
//  Created by Nikhil Gupta on 30/04/22.
//

import UIKit
import RxSwift
import RxCocoa

class CurrencyDetailsViewController: BaseViewController {
    
    @IBOutlet weak var historicalView: UIView!
    @IBOutlet weak var otherCurrencyView: UIView!
    
    var fromCurrencyValue: String = StringConstants.emptyString
    var fromCurrencyCode: String = StringConstants.emptyString
    var toCurrencyCode: String = StringConstants.emptyString
    var toCurrencyValue: String = StringConstants.emptyString
    
    let disposeBag = DisposeBag()
    
    private lazy var dataViewForOtherCurrencyData: CurrencyDataTableViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        var viewController = storyboard.instantiateViewController(withIdentifier: "CurrencyDataTableViewController") as! CurrencyDataTableViewController
        viewController.informationType = .otherCurrencyData
        self.add(asChildViewController: viewController, to: self.otherCurrencyView)
        return viewController
    }()
    
    private lazy var dataViewForHistoricalCurrencyData: CurrencyDataTableViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "CurrencyDataTableViewController") as! CurrencyDataTableViewController
        viewController.informationType = .historicalData
        self.add(asChildViewController: viewController, to: historicalView)
        return viewController
    }()
    
    
    
    var currencyDetailViewModel = CurrencyDetailsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        currencyDetailViewModel.getConvertedCurrency(fromSymbol: fromCurrencyCode, toSymbol: currencyDetailViewModel.getPopularCurrencySymbols(), valueToConvert: fromCurrencyValue)
        currencyDetailViewModel.getHistoricalCurrencyData(fromSymbol: fromCurrencyCode, toSymbol: toCurrencyCode, valueToConvert: fromCurrencyValue, convertedLatestValue: toCurrencyValue)
    }
    
    
    private func setupBindings() {

        currencyDetailViewModel
            .currencyModel
            .observe(on: MainScheduler.instance)
            .bind(to: dataViewForOtherCurrencyData.currencyData)
            .disposed(by: disposeBag)
        
        currencyDetailViewModel
            .historicalDataModel
            .observe(on: MainScheduler.instance)
            .bind(to: dataViewForHistoricalCurrencyData.historicalData)
            .disposed(by: disposeBag)
        
        currencyDetailViewModel.error.observe(on: MainScheduler.instance)
            .subscribe(onNext: { error in
                self.parseNetworkError(error: error)
                
            }).disposed(by: disposeBag)
       
    }
}
