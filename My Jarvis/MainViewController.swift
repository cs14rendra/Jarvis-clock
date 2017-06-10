//
//  MainViewController.swift
//  My Jarvis
//
//  Created by surendra kumar on 3/4/17.
//  Copyright © 2017 weza. All rights reserved.
//

import UIKit
import SwiftSiriWaveformView
import QuartzCore
import AVFoundation
import MapKit
import MediaPlayer
import AlertOnboarding

//AlertOnBoarding
extension MainViewController{
    
    
    func cutomizeAlertView(){
        self.alertView.colorForAlertViewBackground = UIColor.black
        self.alertView.percentageRatioWidth = 0.95
        self.alertView.percentageRatioHeight = 0.93
        self.alertView.colorButtonText = RED
        self.alertView.colorCurrentPageIndicator = RED
        self.alertView.colorPageIndicator = RED.withAlphaComponent(0.30)
        self.alertView.colorTitleLabel = RED.withAlphaComponent(0.70)
        self.alertView.colorButtonBottomBackground = RED.withAlphaComponent(0.27)
        
    }
    
    func isAppAlreadyLaunchedOnce()->Bool{
        let defaults = UserDefaults.standard
        
        if let _ = defaults.string(forKey: "isAppAlreadyLaunchedOnce") {
            print("App already launched")
            return true
        }else{
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            print("App launched first time")
            return false
        }
    }

    
    
}

//LOCATION
extension MainViewController:  CLLocationManagerDelegate {
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // basic location Setup
        bright = defaults.float(forKey: "mainB")
        self.setMainScreenBrightness(f: bright)
        self.requestAuthorization()
        self.locationmanager.delegate = self
        locationmanager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        
    }
    
    // LOCATION Auth
    func requestAuthorization(){
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return
        case .denied,.restricted:
            self.showEventsAcessDeniedAlert()
            print("location access denied")
        default:
            locationmanager.requestWhenInUseAuthorization()
            
        }
    }
    
    //DELEGATE
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            print("Found user's location: \(location)")
            self.lattitude =  String(describing:location.coordinate.latitude)
            self.longitude = String(describing: location.coordinate.longitude)
            
        }
        self.fetchData() // if location is known
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
        self.fetchData() // if location in unknown
    }
}

//WEATHER
extension MainViewController : APIManagerDelegate{
    
    func weatherDatafromServer(weather : Weather){
        self.setMainScreenBrightness(f: 0.9)
        self.weather = weather
        print("Temp is : \(weather.temp)")
        self.myspeach()
        //self.updateUIvalue()
        
    }
}

//SPEECH
extension MainViewController : AVSpeechSynthesizerDelegate{
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        print("finisjed")
        if self.rt {
        timerofspeak = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(MainViewController.myspeach), userInfo: nil, repeats: self.rt)
            self.rt = false
            print("reapet is flase")
        }
        
        UIView.animate(withDuration: 2.0) { 
            
            self.buttonMainView.alpha = 0.0
            self.wave.alpha = 0.0
        }
       
    }
}

class MainViewController: UIViewController, AlertOnboardingDelegate {
    
    
    @IBOutlet var editbutton: UIButton!
    @IBOutlet var clockView: UIView!
    @IBOutlet var bell: UIImageView!
    @IBOutlet var buttonMainView: UIView!
    @IBOutlet var todo: UIView!
    @IBOutlet var rainlb: UILabel!
    @IBOutlet var todotext: UILabel!
    @IBOutlet var stopbutton: UIButton!
    @IBOutlet var cloudlb: UILabel!
    @IBOutlet var temp: UILabel!
    @IBOutlet var tempMax: UILabel!
    @IBOutlet var time: UILabel!
    @IBOutlet var buttonbackground: UIView!
    @IBOutlet var tempMin: UILabel!
    @IBOutlet var leftView: UIView!
    @IBOutlet var alarmtime: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var second: UILabel!
    @IBOutlet var first: UIView!
    @IBOutlet var secondView: UIView!
    @IBOutlet var third: UIView!
    @IBOutlet var wave: SwiftSiriWaveformView!
    
    var  passedtotText : String?
    var name = ""
    var todoitem = ""
    var timeinterval : Double = -1.0
    var wavetimer : Timer?
    var timer:Timer?
    var change:CGFloat = 0.01
    let manager = APIManager.getManager
    var weather : Weather?
    let formatter = DateFormatter()
    let speechsynthesizer = AVSpeechSynthesizer()
    var timerofspeak : Timer?
    var rt : Bool = false
    var screentimer : Timer?
    var  resetTimer : Timer?
    
    //Weather Var
    var w_temp = "NA"
    var w_mintemp = "NA"
    var w_maxtemp = "NA"
    var cloud = "NA"
    var windspeed = "NA"
    var city = "city"
    
    //LOACTION
    let locationmanager = CLLocationManager()
    var lattitude = "0"
    var longitude = "0"
    
    //Brightness
    var bright : Float = 0.0
    let defaults = UserDefaults.standard
    
    // ALAERT ON BOARDING 
    
    var alertView: AlertOnboarding!
    var arrayOfImage = ["item1", "item2", "item3","item4"]
    var arrayOfTitle = ["DIGITAL CLOCK", "SETTINGS & ENERGY SAVING", "SPEAKING TIME","INTERNET AND LOCATION"]
    var arrayOfDescription = ["Digital clock with curent date, you can put phone on table or beside bed and turn it into a digital clock",
                              "Click top right button and set alarm time, save battry by setting lower screen brightness and clock brightness in App setting",
                              "At the previously set time, phone will start speaking and phone brightness and Volume will increase automatically","App will work wihout it, but Turn location and Internet to fetch the weather data. App ask for location only once when phone will start speaking so It will not consume much energy"]
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = MPVolumeView().subviews.first as? UISlider
        {
            view.value = 1.0   // set b/w 0 t0 1.0
        }
        
        bright = defaults.float(forKey: "mainB")
        speechsynthesizer.delegate = self
        manager.delegate = self
        self.stopbutton.layer.borderWidth = 1.0
        self.stopbutton.layer.borderColor = UIColor(red:0.84, green:0.00, blue:0.00, alpha:1.0).cgColor
        self.wave.density = 1.0
        //GuestureMPVolumeView()
        self.resetTimerfunc()
        let guesture = UITapGestureRecognizer(target: self, action: #selector(MainViewController.resetTimerfunc));
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(guesture)
        
        //.............................Energy Consumption....................
        self.setclock()
         //CLOCK TIMER
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(MainViewController.setclock), userInfo: nil, repeats: true)
        self.clockView.alpha = 0.0
        //ScreenTimer
        //screentimer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(MainViewController.terminateApp), userInfo: nil, repeats: true)
        
        //animatation
        UIView.animate(withDuration: 2.0, delay: 1.0, options: [], animations: {
            self.clockView.alpha = 1.0
        }, completion: nil)
        
        
        self.setMainScreenBrightness(f: bright)
        self.hideeverything()
       
        let rate = RateMyApp.sharedInstance
        rate.appID = APP_ID
        rate.trackAppUsage()
        
        //ALERT
        alertView = AlertOnboarding(arrayOfImage: arrayOfImage, arrayOfTitle: arrayOfTitle, arrayOfDescription: arrayOfDescription)
        alertView.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !isAppAlreadyLaunchedOnce(){
            self.cutomizeAlertView()
            self.alertView.show()
            self.setMainScreenBrightness(f: 0.5)
        }
    }
    
    @IBAction func clk(_ sender: Any) {
        //timer?.invalidate()
        self.speechsynthesizer.stopSpeaking(at: .immediate)
        self.timerofspeak?.invalidate()
        self.buttonMainView.alpha = 0.0
        self.weather = nil
        locationmanager.stopUpdatingLocation()
        
        self.wavetimer?.invalidate()
        self.editbutton.isHidden = false
        
    }
    
    //SEGUE
    @IBAction func close(segue : UIStoryboardSegue){
        print("FROM RETURN : HIDE EVRYTHING ")
        self.hideeverything()
        self.removeEveryAnimation()
        
        if let settings = segue.source as? settingsViewController{
            
            if let date = settings.currentDate{
                //LATEST NAME AND TODO
                if let a = UserDefaults.standard.string(forKey: "name"){
                    self.name = a
                }
                self.todoitem = settings.todo
                print("FROM:\(date)")
                let formate = DateFormatter()
                formate.dateFormat = "dd/MM/yyyy hh:mm:ss a"
                self.alarmtime.text = formate.string(from: date)
                let a = Date.secondsBetween(date1: Date(), date2: date)
                print("Difference :\(formate.string(from: Date())) and : \(formate.string(from: date)) ")
                if a > 0{
                    self.timeinterval = Double(a)
                    print("INTERVAL: \(a)")
                    self.rt = settings.rept
                    self.speak()
                }else{
                    print("NEGATIVE TIME INTERVAL")
                }
              
                
            }else{ //if date is not set
                self.alarmtime.text = "No Alarm"
                timerofspeak?.invalidate()
                
            }
            self.clockView.alpha = CGFloat(settings.brightness)
        }
    }
    
    func terminateApp(){
        // Do your segue and invalidate the timer
        screentimer?.invalidate()
        UIView.animate(withDuration: 2.0) { 
            
            //self.alarmtime.alpha = 0.0
            self.editbutton.alpha = 0.0
            //self.bell.alpha = 0.0
        }
    }
    
    func resetTimerfunc(){
        // invaldidate the current timer and start a new one
        //self.alarmtime.alpha = 1.0
        self.editbutton.alpha = 1.0
        //self.bell.alpha = 1.0
        //screentimer?.invalidate()
        //screentimer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(MainViewController.terminateApp), userInfo: nil, repeats: true)
        DispatchQueue.main.asyncAfter(deadline: .now()+10) {
            UIView.animate(withDuration: 1.0, animations: { 
                self.editbutton.alpha = 0.0
            })
        }
    }
    
    internal func refreshAudioView(_:Timer) {
        if self.wave.amplitude <= self.wave.idleAmplitude || self.wave.amplitude > 1.0 {
            self.change *= -1.0
        }
        
        // Simply set the amplitude to whatever you need and the view will update itself.
        self.wave.amplitude += self.change
    }
    
    
    
    func updateUIvalue(){
        
       
        self.w_temp =  "\(getDegree(number: weather?.temp))"
        self.w_mintemp = "\(getDegree(number: weather?.temp_min))"
        self.w_maxtemp = "\(getDegree(number: weather?.temp_max))"
        if self.w_mintemp == self.w_maxtemp{
            self.w_mintemp = "NA"
            self.w_maxtemp = "NA"
        }
        if let a = weather?.cloud {
            cloud = String(describing: a.intValue)
        }
        
        if let a = weather?.wind_speed{
            windspeed = String(describing: a.intValue)
        }
        
        if let a = weather?.cityName{
            city = a
        }
        
        self.temp.text = "\(self.w_temp)\u{00B0}C  Current"
        self.tempMin.text = "\(self.w_mintemp)\u{00B0}C  Min"
        self.tempMax.text = "\(self.w_maxtemp)\u{00B0}C  Max"
        
        
        self.cloudlb.text = "\(cloud)% cloud, \(windspeed)m/s wind speed"
        
        //settextspeech
       self.todotext.text = "Hello, \(self.name). \nToday is a new Day." +
        "\n\nTODAY TASK :\n \(self.todoitem)" +
        "\n\nLocation:\na.lat: \(self.lattitude)\nb.lon:" +
        "\(self.longitude)\n\nCITY:\n\(self.city) "
        
        //self.alarmtime.text  = "tomorrow 8 PM"
        makeallVisible()
    }
    
    func getDegree(number : NSNumber?) -> String{
        if let value = number{
            var a = value.intValue
            a = a - 273
            return String(describing: a)
        }else{
            return "NA"
        }
    }
    
    func makeallVisible(){
        self.leftView.isHidden = false
        self.rainlb.isHidden = true
        self.todo.isHidden = false
        self.stopbutton.isHidden = false
        self.cloudlb.isHidden = false
        self.wave.isHidden = false
        self.buttonMainView.isHidden = false
    }
    
    func setclock(){
        //HOUR
        let date = Date()
        let timeformate = DateFormatter()
        timeformate.dateFormat = "hh:mm"
        self.time.text = timeformate.string(from: date)
        //DATE
        let formate = DateFormatter()
        formate.dateFormat = "dd/MM/yyyy  a"
        self.date.text = formate.string(from: date)
        //SECOND
        timeformate.dateFormat = "ss"
        self.second.text = timeformate.string(from: date)
        
        
    }
    
    

    
    
    func speak() {
        
        // Second phase of app will start here
        timerofspeak?.invalidate()
        timerofspeak = Timer.scheduledTimer(timeInterval: timeinterval, target: self, selector: #selector(MainViewController.fetchLocation), userInfo: nil, repeats: false)
        
    }
    
    func fetchLocation(){
         self.locationmanager.requestLocation()
    }
    
    // fetch data when location is known/unknwon after completion
    // it will execute only once
    func fetchData(){
    
        if let _ = weather{
            
        }else {
            
            DispatchQueue.main.async {
                
                self.manager.loadWeatherData(url: "http://api.openweathermap.org/data/2.5/weather?lat=\(self.lattitude)&lon=\(self.longitude)&APPID=26af22efc8b735ce9aa1950cd769cafc")
        
                
            }
        }
    }
    // speak when weather in completion
    func myspeach(){
        
        // Start evry Animation Here and animation Timer
        self.animateView()
        self.updateUIvalue()
        UIView.setAnimationsEnabled(true)
        //WAVE TIMER Start
        self.wavetimer?.invalidate()
        wavetimer = Timer.scheduledTimer(timeInterval: 0.009, target: self, selector: #selector(MainViewController.refreshAudioView(_:)), userInfo: nil, repeats: true)
        
        
        self.clockView.alpha = 1.0
        self.alarmtime.text = "No Alarm"
        self.editbutton.isHidden = true
        //GET Current DATE
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        let str = formatter.string(from: currentDate)
        
        let speech = AVSpeechUtterance(string: "Hello \(self.name). It's been \(str) already,The weather of \(self.city) is \(self.w_temp) degree celsius with \(self.cloud)% cloud........ The wind speed is \(self.windspeed) meter per second.......... Today minimum temprature is \(self.w_mintemp) degree celsius and.. maximum tempurature is \(self.w_maxtemp) degree celsius. Your today task is \(self.todoitem). Have a good day!")
        speechsynthesizer.speak(speech)
    }
    
    func animateView(){
        
        UIView.animate(withDuration: 3.0, delay: 0.0, options: [], animations: {
            self.first.transform = .identity
        }, completion: nil)
        
        UIView.animate(withDuration: 3.0, delay: 1.0, options: [], animations: {
            self.secondView.transform = .identity
        }, completion: nil)
        
        UIView.animate(withDuration: 3.0, delay: 2.0, options: [], animations: {
            self.third.transform = .identity
        }, completion: nil)
        UIView.animate(withDuration: 3.0, delay: 0.0, options: [.repeat,.autoreverse], animations: {
            self.todotext.alpha = 0.3
        }, completion: nil)
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.repeat,.autoreverse], animations: {
            self.buttonbackground.backgroundColor = UIColor(red:0.72, green:0.11, blue:0.11, alpha:0.30)
        }, completion: nil)
        
        UIView.animate(withDuration: 5.0) {
            self.todo.alpha = 1.0
            self.stopbutton.alpha = 1.0
            self.cloudlb.alpha = 1.0
            self.rainlb.alpha = 1.0
            self.wave.alpha = 1.0
            //self.alarmtime.alpha = 1.0
            
            
        }
        UIView.animate(withDuration: 1.0) {
            
            self.buttonMainView.alpha = 1.0
        }
        
        //SET LEFT VIEW ALPHA WIHOUT ANIMATION
        self.leftView.alpha = 1.0
    }
    
    func hideeverything(){
        self.todo.alpha = 0.0
        self.stopbutton.alpha = 0.0
        self.cloudlb.alpha = 0.0
        self.rainlb.alpha = 0.0
        self.wave.alpha = 0.0
        //self.alarmtime.alpha = 0.0
        self.buttonMainView.alpha = 0.0
        self.leftView.alpha = 0.0
        if self.first.transform == .identity {
          self.first.transform = CGAffineTransform(translationX: -200, y: 0)
          
        }
        if self.secondView.transform == .identity{
          self.secondView.transform = CGAffineTransform(translationX: -200, y: 0)
        }
        if self.third.transform == .identity{
           self.third.transform = CGAffineTransform(translationX: -200, y: 0)
        }
       
    }
    
    func removeEveryAnimation(){
        self.todotext.layer.removeAllAnimations()
        self.buttonbackground.layer.removeAllAnimations()
        
    }
    
    
    
    func setMainScreenBrightness(f : Float){
        UIScreen.main.brightness = CGFloat(f)
    }
    
   
    func showEventsAcessDeniedAlert() {
        let alertController = UIAlertController(title: "Weather Data!",
                                                message: "The location permission was not authorized. Please enable it in Settings to to fetch weather data.",
                                                preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (alertAction) in
            
            // THIS IS WHERE THE MAGIC HAPPENS!!!!
            if let appSettings = NSURL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(appSettings as URL, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(settingsAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settings"{
            self.timerofspeak?.invalidate()
            print("invalid because of segue")
        }
    }

    override var prefersStatusBarHidden: Bool{
        return true
    }
        
        
        // ALERT DELEGATE
        func alertOnboardingCompleted() {
            
            
        }
        
        func alertOnboardingNext(_ nextStep: Int) {
            
            
        }
        
        func alertOnboardingSkipped(_ currentStep: Int, maxStep: Int) {
            
            
        }
}
