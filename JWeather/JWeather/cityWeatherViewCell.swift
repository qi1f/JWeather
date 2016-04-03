//
//  cityWeatherViewCell.swift
//  JWeather
//
//  Created by Fan Qi on 11/29/15.
//  Copyright © 2015 Fan Qi. All rights reserved.
//

import UIKit

class cityWeatherViewCell: UITableViewCell {
    
    @IBOutlet weak var cityLabels: UILabel!
    @IBOutlet weak var tempLabels: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
