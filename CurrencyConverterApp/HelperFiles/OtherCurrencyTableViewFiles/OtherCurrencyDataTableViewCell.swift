//
//  OtherCurrencyDataTableViewCell.swift
//  CurrencyConverterApp
//
//  Created by Nikhil Gupta on 01/05/22.
//

import UIKit

class OtherCurrencyDataTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    public var cellModel : CurrencyModel! {
        didSet {
            self.titleLabel.text = cellModel.currencySymbol + " -> " + cellModel.currencyValue
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
        titleLabel.text = ""
    }

}
