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
    
    
       
       var dateandTime:Float!
       var temprature:Float!
       var tempTomorrow:Float!
       var precipitation:Float!
       var hours:String!
       var minutes:String!
    
   
    
    
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
                        
                        // Setting current time Zone!
                        hourFormat.timeZone = .current
                        minuteFormat.timeZone = .current
                        hourFormat.dateFormat = "h"
                        minuteFormat.dateFormat = "mm"
                        
                        // Setting current date 
                        let hourString = hourFormat.string(from: date as Date)
                        self.hours = hourFormat.string(from: date as Date)
                        self.minutes = minuteFormat.string(from: date as Date)
                        print("HH: \(self.hours!)")
                        print("MM:\(self.minutes!)")
                        
                        
                        self.sendHourToParticle()
                        self.sendMinuteToParticle()
                        self.sendTempToParticle()
                        self.sendTempTomToParticle()
                        self.sendPrecipToParticle()
                    }
                }
    }
   

    // MARK: User variables
    let USERNAME = "eramriksidhu@gmail.com"
    let PASSWORD = "gill@000"
    
    // MARK: Device
    let DEVICE_ID = "2b0040000f47363333343437"
    var myPhoton : ParticleDevice?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            // 1. Check if phone supports WCSessions
            print("Phone view loaded")
            if WCSession.isSupported() {
                print("Phone supports WCSession")
                WCSession.default.delegate = self
                WCSession.default.activate()
                print("Session Activated")
            }
            else {
                print("Phone does not support WCSession")
            }
        }
        
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
        
        self.getDeviceFromCloud()
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
    
    func sendHourToParticle(){
        let funcArgs = [self.hours!] as [Any]
        let task = self.myPhoton!.callFunction("setHour", withArguments: funcArgs) { (resultCode : NSNumber?, error : Error?) -> Void in
            if (error == nil) {
                print("sent hour to particle")
            }
            else{
                print("Error: Hours")
            }
        }
        
    }
    
    func sendMinuteToParticle(){
        let funcArgs = [self.minutes!] as [Any]
        let task = self.myPhoton!.callFunction("setMinute", withArguments: funcArgs) { (resultCode : NSNumber?, error : Error?) -> Void in
            if (error == nil) {
                print("sent minute to particle")
            }
            else{
                print("Error sending minute")
            }
        }
        
    }
    
    func sendTempToParticle(){
        let funcArgs = [self.temprature!] as [Any]
        let task = self.myPhoton!.callFunction("setTemp", withArguments: funcArgs) { (resultCode : NSNumber?, error : Error?) -> Void in
            if (error == nil) {
                print("sent temp to particle")
            }
            else{
                print("Error sending temp")
            }
        }
        
    }

    func sendTempTomToParticle(){
        let funcArgs = [self.tempTomorrow!] as [Any]
        let task = self.myPhoton!.callFunction("setTempTom", withArguments: funcArgs) { (resultCode : NSNumber?, error : Error?) -> Void in
            if (error == nil) {
                print("sent tempTom to particle")
            }
            else{
                print("Error sending tempTom")
            }
        }
        
    }
    
    func sendPrecipToParticle(){
        let funcArgs = [self.precipitation!] as [Any]
        let task = self.myPhoton!.callFunction("setPrecip", withArguments: funcArgs) { (resultCode : NSNumber?, error : Error?) -> Void in
            if (error == nil) {
                print("sending precipitation to particle")
            }
            else{
                print("Error sending precip")
            }
        }
        
    }
    

}

