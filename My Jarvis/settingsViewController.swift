//
//  settingsViewController.swift
//  My Jarvis
//
//  Created by surendra kumar on 3/5/17.
//  Copyright © 2017 weza. All rights reserved.
//

import UIKit
import DatePickerDialog

class settingsViewController: UIViewController, UITextFieldDelegate {
    var a = 8
    var name = ""
    var todo = "To do nothing"
    var currentDate : Date?
    var brightness: Float = 1.0
    var rept :Bool = true
    var mainB : Float = 0.3
    
    @IBOutlet var br: UILabel!
    let defaults = UserDefaults.standard
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var datelabel: UILabel!
    @IBOutlet var todotask: UITextField!
    @IBOutlet var updateName: UITextField!
    @IBOutlet var slide: UISlider!
    @IBOutlet var mainbrightness: UISlider!
    @IBOutlet var mainbrightnesslabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.todotask.delegate = self
        self.updateName.delegate = self
        slide.isContinuous = true
        self.mainbrightness.isContinuous = true
    
        self.datelabel.text = ""
        nameLabel.text = "your name is unknown"
        if let a = defaults.string(forKey: "name"){
            name = a
            nameLabel.text = "your name is \(a)"
        }
        let v = defaults.float(forKey: "mainB")
        self.mainbrightness.value = v
        self.mainbrightnesslabel.text = "Brightness of mainscreen:\(Int(v*100))%"
        

    }
    //BUTTON
    @IBAction func updateNameButton(_ sender: Any) {
        
           }
 
    @IBAction func updateTobutton(_ sender: Any) {
        
    }
   
    @IBAction func setdateButton(_ sender: Any) {
        DatePickerDialog(showCancelButton: false).show("Pick Time", doneButtonTitle: "Done", cancelButtonTitle: "", defaultDate: Date(), minimumDate: Date(), maximumDate: nil, datePickerMode: .dateAndTime) { (date) in
            self.currentDate = date
          
            let formate = DateFormatter()
            formate.dateFormat = "dd/MM/yyyy hh:mm:ss a"
            let d = formate.string(from: date!)
            //print(date ?? <#default value#>)
            print(d)
            self.datelabel.text = d
        }

    }
    @IBAction func Donebutton(_ sender: Any) {
        if todotask.text != ""{
            todo = todotask.text!
            todotask.text = ""
            todotask.placeholder = "Task is added"
            
        }
        if updateName.text != ""{
            name = updateName.text!
            defaults.set(name, forKey: "name")
            nameLabel.text = "your name is \(name)"
            updateName.text = ""
            updateName.placeholder = "Name is updated"
            
            
            
        }

        print(todo)
        print(name)
        
    }
   
    @IBAction func slidbutton(_ sender: UISlider) {
        let value = sender.value
        print(value)
        self.brightness = value
        self.br.text = "Brightness of clock:\(Int(value*100))%"
        
    }
    
    @IBAction func sharebutton(_ sender: Any) {
        let acivity1 = DESCRIPTION
        let activity2 = APP_URL
        let activity = UIActivityViewController(activityItems: [acivity1,activity2], applicationActivities: nil)
        
        
        activity.popoverPresentationController?.sourceView = self.view
        
        present(activity, animated: true, completion: nil)
        

        
    }
    @IBAction func Rateingbutton(_ sender: Any) {
        let url : URL = URL(string: "https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=\(APP_ID)&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=7")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
    }
    @IBAction func repearVoice(_ sender: UISwitch) {
        if sender.isOn{
           self.rept = true
        }else{
            self.rept = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.todotask.resignFirstResponder()
        self.updateName.resignFirstResponder()
    }
    
    @IBAction func mainBrightbutton(_ sender: UISlider) {
        let value = sender.value
        print("Brightness : \(value)")
        self.mainB = value
        self.mainbrightnesslabel.text = "Brightness of mainscreen:\(Int(value*100))%"
        // save brightness
        defaults.set(value, forKey: "mainB")
        
        
    }
    
}
