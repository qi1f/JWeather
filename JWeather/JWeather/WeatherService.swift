//
//  WeatherService.swift
//  JWeather
//
//  Created by Fan Qi on 12/8/15.
//  Copyright © 2015 Fan Qi. All rights reserved.
//

import Foundation

protocol WeatherServiceDelegate {
    func setWeather(weather: Weather)
}

class WeatherService {
    
    var wServiceDelegate: WeatherServiceDelegate?
    var timeZoneInfo = String()
    var cityName = String()
    
    func getWeather(GeoCoordination: String) {
        
        // Set API key
        let apiKey = ""
        
        // Request data
        let path = "https://api.forecast.io/forecast/\(apiKey)/\(GeoCoordination)"
        let url = NSURL(string: path)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            let json = JSON(data: data!)
            let weatherSummary = json["currently"]["summary"].string
            let temp = json["currently"]["temperature"].int
            let temp_min = json["daily"]["data"][0]["temperatureMin"].int
            let temp_max = json["daily"]["data"][0]["temperatureMax"].int
            let temp_apparent = json["currently"]["apparentTemperature"].int
            let sun_up_unix = json["daily"]["data"][0]["sunriseTime"].double
            let sun_dwn_unix = json["daily"]["data"][0]["sunsetTime"].double
            let humidity_origional = json["currently"]["humidity"].double
            self.timeZoneInfo = json["timezone"].string!
            
            // Conver data
            let humidity = Int(humidity_origional! * 100)
            let sun_up = self.unixTimeConvertion(sun_up_unix!)
            let sun_dwn = self.unixTimeConvertion(sun_dwn_unix!)
            
            let weather = Weather(wCityName: self.cityName,
                                  wSummary: weatherSummary!,
                                  wTemp: temp!,
                                  wTemp_min: temp_min!,
                                  wTemp_max: temp_max!,
                                  wTemp_apparent: temp_apparent!,
                                  wSun_up: sun_up,
                                  wSun_dwn: sun_dwn,
                                  wHumidity: humidity)
            
            if self.wServiceDelegate != nil {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.wServiceDelegate?.setWeather(weather)
                })
            }
        }
        
        task.resume()
    }
    
    func unixTimeConvertion(unixTime: Double) -> String {
        let time = NSDate(timeIntervalSince1970: unixTime)
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: timeZoneInfo)
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.stringFromDate(time)
    }
    
    func getCity(city: String) -> String {
        self.cityName = city
        return cityName
    }
    
}