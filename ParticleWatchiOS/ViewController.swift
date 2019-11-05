//
//  ViewController.swift
//  ParticleWatchiOS
//
//  Created by Z Angrazy Jatt on 2019-11-05.
//  Copyright © 2019 Parrot. All rights reserved.
//

import UIKit
import Particle_SDK
import WatchConnectivity

class ViewController: UIViewController, WCSessionDelegate{
    
    @IBOutlet weak var lblOpView: UILabel!
    
    
        func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
                    if (message.keys.contains("temprature")){
                        print("Weather data recieved from Watch")
                        
                        self.dateandTime = message["time"] as? Float
                        self.temprature = message["temprature"] as? Float
                        self.tempTomorrow = message["tempratureTomorrow"] as? Float
                        self.precipitation = message["precipitation"] as? Float
                        
                        
                        let date = NSDate(timeIntervalSince1970: TimeInterval(self.dateandTime!))
                        let hourFormat = DateFormatter()
                        let minuteFormat = DateFormatter()
                        // Set the current timezone to .current
                        hourFormat.timeZone = .current
                        minuteFormat.timeZone = .current
                    
        //                format.dateFormat = "h:mm a '' dd-MM-yyyy"
                        hourFormat.dateFormat = "h"
                        minuteFormat.dateFormat = "mm"
                        
                        // Set the current date, altered by timezone.
                        let hourString = hourFormat.string(from: date as Date)
                        self.hours = hourFormat.string(from: date as Date)
                        self.minutes = minuteFormat.string(from: date as Date)
                        print("HH: \(self.hours!)")
                        print("MM:\(self.minutes!)")
                        
                        self.lblOpView.text = "MSG: \(self.dateandTime)"
                        
//                        self.sendHourToParticle()
//                        self.sendMinuteToParticle()
//                        self.sendTempToParticle()
//                        self.sendTempTomToParticle()
//                        self.sendPrecipToParticle()
                    }
                }
    }
    
    
    var dateandTime:Float!
    var temprature:Float!
    var tempTomorrow:Float!
    var precipitation:Float!
    var hours:String!
    var minutes:String!

    // MARK: User variables
    let USERNAME = "eramriksidhu@gmail.com"
    let PASSWORD = "gill@000"// MARK: Device
    let DEVICE_ID = "2b0040000f47363333343437"
    var myPhoton : ParticleDevice?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1. Initialize the SDK
        ParticleCloud.init()
 
        // 2. Login to your account
        ParticleCloud.sharedInstance().login(withUser: self.USERNAME, password: self.PASSWORD) { (error:Error?) -> Void in
            if (error != nil) {
                // Something went wrong!
                print("Wrong credentials or as! ParticleCompletionBlock no internet connectivity, please try again")
                // Print out more detailed information
                print(error?.localizedDescription)
            }
            else {
                print("Login success!")
            }
        } // end login
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Get Device from Cloud
    // Gets the device from the Particle Cloud
    // and sets the global device variable
    func getDeviceFromCloud() {
    ParticleCloud.sharedInstance().getDevice(self.DEVICE_ID) { (device:ParticleDevice?, error:Error?) in
            
            if (error != nil) {
                print("Could not get device")
                print(error?.localizedDescription)
                return
            }
            else {
                print("Got photon: \(device?.id)")
                self.myPhoton = device
            }
            
        } // end getDevice()
    }
    

}

