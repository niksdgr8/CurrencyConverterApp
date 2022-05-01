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
    
    var fromCurrencyValue: String = ""
    var fromCurrencyCode: String = ""
    var toCurrencyCode: String = ""
    var toCurrencyValue: String = ""
    
    let disposeBag = DisposeBag()
    
    private lazy var dataViewForOtherCurrencyData: CurrencyDataTableViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "CurrencyDataTableViewController") as! CurrencyDataTableViewController
        viewController.informationType = .otherCurrencyData

        // Add View Controller as Child View Controller
        self.addChild(viewController)
        self.otherCurrencyView.addSubview(viewController.view)

        return viewController
    }()
    
    private lazy var dataViewForHistoricalCurrencyData: CurrencyDataTableViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "CurrencyDataTableViewController") as! CurrencyDataTableViewController
        viewController.informationType = .historicalData
        
        // Add View Controller as Child View Controller
        self.addChild(viewController)
        self.historicalView.addSubview(viewController.view)
        
        return viewController
    }()
    
    
    
    var currencyDetailViewModel = CurrencyDetailsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.addBlurArea(area: self.view.frame, style: .dark)
        setupBindings()
        currencyDetailViewModel.getConvertedCurrency(fromSymbol: fromCurrencyCode, toSymbol: ["USD", "GBP", "AUD"], valueToConvert: fromCurrencyValue)
        currencyDetailViewModel.getHistoricalCurrencyData(fromSymbol: fromCurrencyCode, toSymbol: toCurrencyCode, valueToConvert: fromCurrencyValue, convertedLatestValue: toCurrencyValue)
    }
    
    
    private func setupBindings() {
        
        // binding loading to vc
        
//        currencyDetailViewModel.loading
//            .bind(to: self.rx.isAnimating).disposed(by: disposeBag)
//
//
//        // observing errors to show
//
//        currencyDetailViewModel
//            .error
//            .observeOn(MainScheduler.instance)
//            .subscribe(onNext: { (error) in
//                switch error {
//                case .internetError(let message):
//                    MessageView.sharedInstance.showOnView(message: message, theme: .error)
//                case .serverMessage(let message):
//                    MessageView.sharedInstance.showOnView(message: message, theme: .warning)
//                }
//            })
//            .disposed(by: disposeBag)
//
//
//        // binding albums to album container
//
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
//
//        // binding tracks to track container
//
//        currencyDetailViewModel
//            .tracks
//            .observeOn(MainScheduler.instance)
//            .bind(to: tracksViewController.tracks)
//            .disposed(by: disposeBag)
       
    }
}
