//
//  Weather.swift
//  JWeather
//
//  Created by Fan Qi on 12/10/15.
//  Copyright © 2015 Fan Qi. All rights reserved.
//

import Foundation

class Weather: NSObject, NSCoding {
    var cityName = String()
    var weatherSummary = String()
    var temp = Int()
    var temp_min = Int()
    var temp_max = Int()
    var temp_apparent = Int()
    var sun_up = String()
    var sun_dwn = String()
    var humidity = Int()
    
    init(wCityName: String, wSummary: String, wTemp: Int, wTemp_min: Int, wTemp_max: Int, wTemp_apparent: Int, wSun_up: String, wSun_dwn: String, wHumidity: Int) {
        cityName = wCityName
        weatherSummary = wSummary
        temp = wTemp
        temp_min = wTemp_min
        temp_max = wTemp_max
        temp_apparent = wTemp_apparent
        sun_up = wSun_up
        sun_dwn = wSun_dwn
        humidity = wHumidity
    }

    required init(coder aDecoder: NSCoder) {
        self.cityName = aDecoder.decodeObjectForKey("city") as! String
        self.weatherSummary = aDecoder.decodeObjectForKey("summary") as! String
        self.temp = aDecoder.decodeObjectForKey("temp") as! Int
        self.temp_min = aDecoder.decodeObjectForKey("temp_min") as! Int
        self.temp_max = aDecoder.decodeObjectForKey("temp_max") as! Int
        self.temp_apparent = aDecoder.decodeObjectForKey("temp_apparent") as! Int
        self.sun_up = aDecoder.decodeObjectForKey("sun_up") as! String
        self.sun_dwn = aDecoder.decodeObjectForKey("sun_dwn") as! String
        self.humidity = aDecoder.decodeObjectForKey("humidity") as! Int
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(cityName, forKey: "city")
        aCoder.encodeObject(weatherSummary, forKey: "summary")
        aCoder.encodeObject(temp, forKey: "temp")
        aCoder.encodeObject(temp_min, forKey: "temp_min")
        aCoder.encodeObject(temp_max, forKey: "temp_max")
        aCoder.encodeObject(temp_apparent, forKey: "temp_apparent")
        aCoder.encodeObject(sun_up, forKey: "sun_up")
        aCoder.encodeObject(sun_dwn, forKey: "sun_dwn")
        aCoder.encodeObject(humidity, forKey: "humidity")
    }

}