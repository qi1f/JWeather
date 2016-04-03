//
//  ViewController.swift
//  JWeather
//
//  Created by Fan Qi on 11/29/15.
//  Copyright © 2015 Fan Qi. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, WeatherServiceDelegate, CLLocationManagerDelegate {

    
    let userDefaults = NSUserDefaults()
    var refreshControl: UIRefreshControl!
    var currentRow: Int?
    
    // Init Weather
    var weatherDetail = [Weather]()
    
    // Init WeatherService
    let weatherService = WeatherService()
    
    // Location service
    var locationManager: CLLocationManager = CLLocationManager()
    var geocoder: CLGeocoder = CLGeocoder()
    var placemark: CLPlacemark = CLPlacemark()
    
    @IBOutlet weak var weatherCityTable: UITableView!
    
    @IBAction func addCity(sender: UIButton) {
        openAddCityAlert()
    }

    @IBAction func changeCF(sender: AnyObject) {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Background color
        let backgroundRed: CGFloat = 34 / 255
        let backgroundGreen: CGFloat = 167 / 255
        let backgroundBlue: CGFloat = 240 / 255
        let backgroundColor = UIColor(red: backgroundRed, green: backgroundGreen, blue: backgroundBlue, alpha: 1)
        
        // Cell separator line color
        let separatorRed: CGFloat = 197 / 255
        let separatorGreen: CGFloat = 239 / 255
        let separatorBlue: CGFloat = 247 / 255
        let separatorColor = UIColor(red: separatorRed, green: separatorGreen, blue: separatorBlue, alpha: 1)
        
        // Default settings
        self.weatherCityTable.backgroundColor = backgroundColor
        self.weatherCityTable.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        self.weatherCityTable.separatorColor = separatorColor
        self.weatherService.wServiceDelegate = self
        currentRow = 0
        
        // Pull to refresh
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshData), forControlEvents: UIControlEvents.ValueChanged)
        weatherCityTable.addSubview(refreshControl)
        
        // Load saved cityNames and cityWithCoordination
        loadCityList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // TableView section
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherDetail.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Set active cell color
        let activeCellRed: CGFloat = 200 / 255
        let activeCellGreen: CGFloat = 247 / 255
        let activeCellBlue: CGFloat = 197 / 255
        let activeCellColor = UIColor(red: activeCellRed, green: activeCellGreen, blue: activeCellBlue, alpha: 0.5)
        
        // Set inactive cell color
        let inactiveCellRed: CGFloat = 174 / 255
        let inactiveCellGreen: CGFloat = 168 / 255
        let inactiveCellBlue: CGFloat = 211 / 255
        let inactiveCellColor = UIColor(red: inactiveCellRed, green: inactiveCellGreen, blue: inactiveCellBlue, alpha: 0.0)
        
        if indexPath.row == currentRow {
            let cell:selectedWeatherViewCell = self.weatherCityTable.dequeueReusableCellWithIdentifier("selectedWeatherCell") as! selectedWeatherViewCell
            let info = weatherDetail[indexPath.row]
            cell.selectedCityLabels.text = info.cityName
            cell.selectedWeatherSummaryLabels.text = info.weatherSummary
            cell.selectedTempLabels.text = "\(info.temp)"
            cell.selectedLowTempLabels.text = "\(info.temp_min)"
            cell.selectedHighTempLaels.text = "\(info.temp_max)"
            cell.selectedApparentTemp.text = "\(info.temp_apparent)"
            cell.selectedSunrise.text = info.sun_up
            cell.selectedSunset.text = info.sun_dwn
            cell.selectedHumidity.text = "\(info.humidity)"
            cell.backgroundColor = activeCellColor
            cell.selectionStyle = .None
            cell.layoutMargins = UIEdgeInsetsZero
            cell.separatorInset = UIEdgeInsetsZero
            return cell
        } else {
            let cell:cityWeatherViewCell = self.weatherCityTable.dequeueReusableCellWithIdentifier("cityWeatherViewCell") as! cityWeatherViewCell
            let info = weatherDetail[indexPath.row]
            cell.cityLabels.text = info.cityName
            cell.tempLabels.text = "\(info.temp)"
            cell.backgroundColor = inactiveCellColor
            cell.selectionStyle = .None
            cell.layoutMargins = UIEdgeInsetsZero
            cell.separatorInset = UIEdgeInsetsZero
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var reloadRows = [NSIndexPath]()
        if currentRow != nil && indexPath.row != currentRow! {
            reloadRows.append(NSIndexPath(forRow: currentRow!, inSection: indexPath.section))
        }
        currentRow = indexPath.row
        reloadRows.append(NSIndexPath(forRow: currentRow!, inSection: indexPath.section))
        tableView.reloadRowsAtIndexPaths(reloadRows, withRowAnimation: .Fade)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == currentRow {
            return 360
        } else {
            return 100
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            weatherDetail.removeAtIndex(indexPath.row)
            saveCityList()
            self.weatherCityTable.reloadData()
        }
        
    }
    
    // Enter city
    func openAddCityAlert() {
        
        // Create alert controller
        let alert = UIAlertController(title: "City", message: "Enter City Name", preferredStyle: .Alert)
        
        // Create alert actions
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let ok = UIAlertAction(title: "OK", style: .Default) { (action: UIAlertAction) -> Void in
            let textField = alert.textFields?[0]
            let enteredCityName = textField?.text
            let capitalizedCity = enteredCityName?.capitalizedString
            self.forwardGeocoding(capitalizedCity!)
        }
        
        // Create textField
        alert.addTextFieldWithConfigurationHandler { (textField: UITextField) -> Void in
            textField.placeholder = "Enter City Name"
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // Append data to labels
    func setWeather(weather: Weather) {
        
        weatherDetail.append(weather)
        saveCityList()
        weatherCityTable.reloadData()
    }
    
    // Get geo coordination by city name
    func forwardGeocoding(enteredCityName: String) {
        CLGeocoder().geocodeAddressString(enteredCityName) { (placemarks, error) -> Void in
            if error != nil {
                print(error)
                self.weatherDetail.removeLast()
                
                // Display error
                let alert = UIAlertController(title: "Invalid City", message: "", preferredStyle: .Alert)
                let cancel = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                alert.addAction(cancel)
                self.presentViewController(alert, animated: true, completion: nil)
                
                return
            }
            if placemarks?.count > 0 {
                let placemark = placemarks?[0]
                let location = placemark?.location
                let coordinate = location?.coordinate
                let geoCoordination: String = ("\(coordinate!.latitude),\(coordinate!.longitude)")
                self.weatherService.getCity(enteredCityName)
                self.weatherService.getWeather(geoCoordination)
            }
        }
    }
    
    // Pull to refresh
    
    func refreshData() {
        let cityNames = weatherDetail.map { $0.cityName }
        print(cityNames)
        weatherDetail.removeAll()
        for city in cityNames {
            self.forwardGeocoding(city)
        }
        weatherCityTable.reloadData()
        refreshControl.endRefreshing()
    }

    func saveCityList() {
        
        let savedWeatherDetail = NSKeyedArchiver.archivedDataWithRootObject(weatherDetail)
        userDefaults.setObject(savedWeatherDetail, forKey: "WeatherInfo")
    }
    
    func loadCityList() {
        
        if let savedWeatherInfo = userDefaults.objectForKey("WeatherInfo") as? NSData {
            weatherDetail = NSKeyedUnarchiver.unarchiveObjectWithData(savedWeatherInfo) as! [Weather]
        }
    }

}

