//
//  InterfaceController.swift
//  ParticleWatchiOS
//
//  Created by Z Angrazy Jatt on 2019-11-05.
//  Copyright © 2019 Parrot. All rights reserved.
//

import WatchKit
import Foundation
import Alamofire
import SwiftyJSON
import WatchConnectivity


class InterfaceController: WKInterfaceController, WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    @IBOutlet weak var lblCityName: WKInterfaceLabel!
    
    @IBOutlet weak var lbltime: WKInterfaceLabel!
    
    @IBOutlet weak var lbltemprature: WKInterfaceLabel!
    
    @IBOutlet weak var lblperception: WKInterfaceLabel!
    
    @IBAction func btnSendToParticleClicked() {
        
        self.sendingWeatherInfoToiPhone()
    }
    
    
    
    var latitude:String!
    var longitude:String!
    var dateAndTime:Float!
    var tempratureToday:Float!
    var tempratureTomorrow:Float!
    var perceptionIs:Float!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        if WCSession.isSupported() {
            print("Watch supports WCSession")
            WCSession.default.delegate = self
            WCSession.default.activate()
            print("Session Activated")
        }
        else {
            print("Watch does not support WCSession")
        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        let userDefaults = UserDefaults.standard
        var city = userDefaults.string(forKey: "city")
        
        if (city == nil) {
            
            city = "Moga"
            print("by Default Moga City selected!")
        }
        else {
            print("Got city: \(city)")
        }
        
        // update the label to show the current city
        self.lblCityName.setText(city!)
        
        // getting longitude and latitude

               self.latitude = userDefaults.string(forKey: "latitude")
               self.longitude = userDefaults.string(forKey: "longitude")
               
               if (self.latitude == nil || self.longitude == nil) {
                   // set lat long to toronto's lat long if they are nil.
                   self.latitude = "30.8"
                   self.longitude = "75.17"
               }
        
        
        
                let URL = "https://api.openweathermap.org/data/2.5/weather?lat=\(self.latitude!)&lon=\(self.longitude!)&appid=f8224a96eb0f4821f53f1a9b04106649"
        
                Alamofire.request(URL).responseJSON{
                    response in
                    guard let apiData = response.result.value else{
                        print("Error getting response from url")
                        return
                    }
                    print(apiData)
        
                    let jsonResponse = JSON(apiData)
                    let weatherDescription = jsonResponse["weather"].array![0]["description"].string
                    let temperature = jsonResponse["main"]["temp"].float
                    let pressure = jsonResponse["main"]["pressure"].float
                    let humidity = jsonResponse["main"]["humidity"].float
                    let country = jsonResponse["sys"]["country"].string
        
                    print("Weather description : \(weatherDescription!)")
                    print("Temperature : \(temperature!)")
                    print("Pressure: \(pressure!)")
                    print("Humidity: \(humidity!)")
                    print("Country: \(country!)")
                    // loading weather On watch
                    self.getWeather()
                }
        
        
        
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    public func getWeather(){
        
        self.lbltime.setText("...")
        self.lbltemprature.setText("...")
        self.lblperception.setText("...")
        
        let URL = "https://api.openweathermap.org/data/2.5/weather?lat=\(self.latitude!)&lon=\(self.longitude!)&appid=f8224a96eb0f4821f53f1a9b04106649"
        
        Alamofire.request(URL).responseJSON{
            response in
            guard let apiData = response.result.value else{
                print("Error getting response from url")
                return
            }
            //print(apiData)
            
            let jsonResponse = JSON(apiData)
            let weatherDescription = jsonResponse["weather"].array![0]["description"].string
            let temperature = jsonResponse["main"]["temp"].float
            let tempCelcius = temperature! - 273.15
            let pressure = jsonResponse["main"]["pressure"].float
            let humidity = jsonResponse["main"]["humidity"].float
            let precipitation = jsonResponse["main"]["humidity"].float
            let country = jsonResponse["sys"]["country"].string
            let currentTime = jsonResponse["dt"].float
            
            let date = NSDate(timeIntervalSince1970: TimeInterval(currentTime!))
            let format = DateFormatter()
            format.dateFormat = "h:mm a '' dd-MM-yyyy"
            // Set the current date, altered by timezone.
            let dateString = format.string(from: date as Date)
            
            self.dateAndTime = currentTime!
            self.tempratureToday = tempCelcius
            self.perceptionIs = precipitation!
            
            self.lbltemprature.setText("Temperature: \(tempCelcius) °C")
            self.lblperception.setText("Precipitation: \(precipitation!) %")
            self.lbltime.setText("\(dateString)")
            
            print("Weather description : \(weatherDescription!)")
            print("Temperature : \(temperature!)")
            print("Temperature :\(tempCelcius) °C")
            print("Pressure: \(pressure!)")
            print("Humidity: \(humidity!)")
            print("Country: \(country!)")
            print("Current Date: \(date)")
        }
    }
    
    public func sendingWeatherInfoToiPhone(){
        
        if (WCSession.default.isReachable) {
            print("phone reachable")
            
    let message = ["time":self.dateAndTime,"temprature":self.tempratureToday,"tempratureTomorrow":self.tempratureTomorrow,"precipitation":perceptionIs]
            WCSession.default.sendMessage(message as [String : Any], replyHandler: nil)
            // output a debug message to the console
            print("sent weather data request to phone")
        }
        else {
            print("WATCH: Cannot reach phone")
        }
    }

}
