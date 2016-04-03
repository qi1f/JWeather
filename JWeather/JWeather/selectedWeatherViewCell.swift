//
//  selectedWeatherViewCell.swift
//  JWeather
//
//  Created by Fan Qi on 12/1/15.
//  Copyright © 2015 Fan Qi. All rights reserved.
//

import UIKit

class selectedWeatherViewCell: UITableViewCell {
    
    @IBOutlet weak var selectedCityLabels: UILabel!
    @IBOutlet weak var selectedWeatherSummaryLabels: UILabel!
    @IBOutlet weak var selectedTempLabels: UILabel!
    @IBOutlet weak var selectedHighTempLaels: UILabel!
    @IBOutlet weak var selectedLowTempLabels: UILabel!
    @IBOutlet weak var selectedApparentTemp: UILabel!
    @IBOutlet weak var selectedSunrise: UILabel!
    @IBOutlet weak var selectedSunset: UILabel!
    @IBOutlet weak var selectedHumidity: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
