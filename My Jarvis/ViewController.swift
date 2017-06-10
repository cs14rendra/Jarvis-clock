//
//  ViewController.swift
//  My Jarvis
//
//  Created by surendra kumar on 3/4/17.
//  Copyright © 2017 weza. All rights reserved.
//

import UIKit
import QuartzCore
import AVFoundation
import  SwiftDateExtension

extension ViewController : APIManagerDelegate{
    
    func weatherDatafromServer(weather : Weather){
        self.weather = weather
        print("Temp is : \(weather.temp)")
    }
}
var timer = Timer()

class ViewController: UIViewController {
    
    @IBOutlet var picker: UIDatePicker!
    let manager = APIManager.getManager
    var weather : Weather?
    let speechsynthesizer = AVSpeechSynthesizer()
    let currentDate = Date()
    let dateformatter = DateFormatter()
    var timeinterval : TimeInterval = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        manager.loadWeatherData(url: "http://api.openweathermap.org/data/2.5/weather?lat=28&lon=77&APPID=26af22efc8b735ce9aa1950cd769cafc")
       picker.minimumDate = currentDate
    }

    @IBAction func speak(_ sender: Any) {
        timer = Timer.scheduledTimer(timeInterval: timeinterval, target: self, selector: #selector(ViewController.tellit), userInfo: nil, repeats: false)
       
    }
    
    func tellit(){
        let speech = AVSpeechUtterance(string: "Good morning Surendra, the outer tempature is  degree celsius")
        speechsynthesizer.speak(speech)
    }

    
    @IBAction func datepickerVlaue(_ sender: Any) {
        timer.invalidate()
        print(currentDate)
        print(Date.secondsBetween(date1: Date(), date2: picker.date))
        let a = Date.secondsBetween(date1: Date(), date2: picker.date)
        if a > 0{
            self.timeinterval = Double(a)
        }else{
            print("NEGATIVE TIME INTERVAL")
        }
    }
   

}

