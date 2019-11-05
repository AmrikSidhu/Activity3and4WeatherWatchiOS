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


class InterfaceController: WKInterfaceController {

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
                let URL = "https://api.openweathermap.org/data/2.5/weather?lat=30.8&lon=75.17&appid=f8224a96eb0f4821f53f1a9b04106649"
        
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
                }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
