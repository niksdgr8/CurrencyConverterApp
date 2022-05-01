//
//  HistoricalDataTableViewCell.swift
//  CurrencyConverterApp
//
//  Created by Nikhil Gupta on 01/05/22.
//

import UIKit

class HistoricalDataTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var valueLabel: UILabel!
    
    public var cellModel : HistoricalDataModel! {
        didSet {
            self.dateLabel.text = "On" + " " + cellModel.dateString
            self.valueLabel.text = cellModel.fromCurrencyValue + " " + cellModel.fromCurrencySymbol + " -> " + cellModel.toCurrencyValue + " " + cellModel.toCurrencySymobl
            //self.titleLabel.text = cellModel.currencySymbol + " -> " + cellModel.currencyValue
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        dateLabel.text = ""
        valueLabel.text = ""
    }

}
