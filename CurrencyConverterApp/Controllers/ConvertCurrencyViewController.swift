//
//  ConvertCurrencyViewController.swift
//  CurrencyConverterApp
//
//  Created by Nikhil Gupta on 30/04/22.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class ConvertCurrencyViewController: BaseViewController {
    
    
    @IBOutlet weak var fromTextField: PickerTextField!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var toTextField: PickerTextField!
    
    @IBOutlet weak var swapButton: UIButton!
    @IBOutlet weak var detailsButton: UIButton!
    @IBOutlet weak var convertedCurrencyTextField: UITextField!
    @IBOutlet weak var inputCurrencyTextField: UITextField!
    
    
    var currencyConverterViewModel = ConvertCurrencyViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.detailsButton.setTitle(NSLocalizedString("DETAILS", comment: "Details"), for: .normal)
        self.detailsButton.isEnabled = false
        self.titleLabel.text = NSLocalizedString("CURRENCY_CONVERTER_TITLE", comment: "Currency Converter title")
        self.titleLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        self.titleLabel.adjustsFontForContentSizeCategory = true
        //self.titleLabel.
        self.setupViewModelBindings()
        self.currencyConverterViewModel.getValidCurrencySymbols()
        
        fromTextField.tintColor = .white
        // Do any additional setup after loading the view.
//        NetworkManager.shared.get(urlString: "", completionBlock: { [weak self] result in
//            guard let self = self else {return}
//            switch result {
//            case .failure(let networkError):
//                if let error = networkError as? NetworkError {
//                    switch error {
//                    case .invalidResponse(let json, let response):
//                        print ("failure",json)
//                    default:
//                        print ("failure",networkError)
//                    }
//                }
//
//            case .success(let dta) :
//                print("success", dta)
//              //  let json = (try? JSONSerialization.jsonObject(with: dta, options: [])) as? [String: AnyObject]
//                print("Success Response: \(dta)")
//               // let decoder = JSONDecoder()
////                do
////                {
////                    self.breaches = try decoder.decode([BreachModel].self, from: dta)
////                    completion(.success(try decoder.decode([BreachModel].self, from: dta)))
//              //  } catch {
//                    // deal with error from JSON decoding if used in production
//               // }
//            }
//        })
    }
    
    func setupViewModelBindings() {
        //currencyConverterViewModel.currencySymbols.bind(to: fromTextField.pickerItems)
//            .observe(on: MainScheduler.instance)
//            .bind(to: fromTextField.pickerItems)
          //  .disposed(by: disposeBag)
        
        currencyConverterViewModel.loading
            .bind(to: self.rx.isAnimating).disposed(by: disposeBag)
        currencyConverterViewModel.currencySymbols
        .observe(on: MainScheduler.instance)
        .bind(to: fromTextField.pickerItems)
        .disposed(by: disposeBag)

        currencyConverterViewModel.currencySymbols.observe(on: MainScheduler.instance)
            .bind(to: toTextField.pickerItems)
            .disposed(by: disposeBag)
        currencyConverterViewModel.convertedValue.observe(on: MainScheduler.instance)
            .bind(to: convertedCurrencyTextField.rx.text)
            .disposed(by: disposeBag)
        
        currencyConverterViewModel.convertedValue.observe(on: MainScheduler.instance)
            .subscribe(onNext: { value in
                self.detailsButton.isEnabled = true
            })
            .disposed(by: disposeBag)
        //currencyConverterViewModel.currencySymbols.subscribe()
        
        currencyConverterViewModel.currencySymbols.observe(on: MainScheduler.instance)
            .subscribe(onNext: { _ in
            self.callAPI()
                //self.inputCurrencyTextField.text = "20"
            }).disposed(by: disposeBag)
        inputCurrencyTextField.rx.controlEvent([.editingDidEnd])
            .asObservable()
            .subscribe(onNext:{
                self.callAPI()
            }).disposed(by: disposeBag)
        
        currencyConverterViewModel.error.observe(on: MainScheduler.instance)
            .subscribe(onNext: { error in
                self.parseNetworkError(error: error)
                
            }).disposed(by: disposeBag)
        
        fromTextField.rx.controlEvent([.editingDidEnd])
            .asObservable()
            .subscribe(onNext: {
                self.callAPI()
            }).disposed(by: disposeBag)
        
        toTextField.rx.controlEvent([.editingDidEnd])
            .asObservable()
            .subscribe(onNext: {
                self.callAPI()
            }).disposed(by: disposeBag)
        
        swapButton.rx.tap.bind {
            let temp = self.fromTextField.text
            self.fromTextField.text = self.toTextField.text
            self.toTextField.text = temp
            
            self.inputCurrencyTextField.text = "1"
            self.callAPI()
        }
        
        detailsButton.rx.tap.bind {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

            // Instantiate View Controller
            var viewController = storyboard.instantiateViewController(withIdentifier: "CurrencyDetailsViewController") as! CurrencyDetailsViewController
            viewController.fromCurrencyCode = self.fromTextField.text!
            viewController.fromCurrencyValue = self.inputCurrencyTextField.text!
            viewController.toCurrencyCode = self.toTextField.text!
            viewController.toCurrencyValue = self.convertedCurrencyTextField.text!

            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
        
    }
    
    func callAPI() {
        currencyConverterViewModel.getConvertedCurrency(fromSymbol: fromTextField.text!, toSymbol: toTextField.text!, valueToConvert: inputCurrencyTextField.text!)
    }


}
