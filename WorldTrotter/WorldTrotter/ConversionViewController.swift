//
//  ConversionViewController.swift
//  WorldTrotter
//
//  Created by Sajjad Patel on 2018-01-22.
//  Copyright © 2018 Sajjad Patel. All rights reserved.
//

import UIKit
import Foundation

class ConversionViewController : UIViewController, UITextFieldDelegate{
    
    @IBOutlet var celsiusLabel : UILabel!
    @IBOutlet var textField : UITextField!
    
    var fahrenheitValue: Measurement<UnitTemperature>?{
        didSet{
            updateCelsiusLabel()
        }
    }
    var celsiusValue: Measurement<UnitTemperature>?{
        if let fahrenheitValue = fahrenheitValue{
            return fahrenheitValue.converted(to: .celsius)
        }else{
            return nil
        }
    }
    
    /*TextField delegate that will filter the input field of decimals and letters*/
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let letterFilter = NSCharacterSet.letters
        let currentLocale = Locale.current
        let decimalSeperator = currentLocale.decimalSeparator ?? "."
        let existingTextHasDecimalSeparator = textField.text?.range(of: decimalSeperator)
        let replacementHasDecimalSeparator = string.range(of: decimalSeperator)
        
        if string.rangeOfCharacter(from: letterFilter) != nil{
            return false
        }
        
        if existingTextHasDecimalSeparator != nil && replacementHasDecimalSeparator != nil{
            return false
        }
        return true
    }
    
    /*Used to format the celsius variable*/
    let numberFormatter: NumberFormatter = {
       let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 1
        return nf
    }()
    
    /*Updates the fahrenheit to celsius*/
    func updateCelsiusLabel(){
        if let celsiusValue = celsiusValue{
            celsiusLabel.text = numberFormatter.string(from: NSNumber(value: celsiusValue.value))
        }else{
            celsiusLabel.text = "???"
        }
    }
    
    /*This is called when the user puts values into the textField*/
    @IBAction func fahrenheitFieldEditingChanged(_ textField: UITextField){
        if let text = textField.text, let number = numberFormatter.number(from: text){
            fahrenheitValue = Measurement(value: number.doubleValue, unit: .fahrenheit)
        }else{
            celsiusLabel.text = "???"
        }
    }
    
    /*Dismisses the keyboard*/
    @IBAction func dismissKeyBoard(_ sender:UITapGestureRecognizer){
        textField.resignFirstResponder()
    }
    
    /*Initializes the view before it loads*/
    override func viewDidLoad(){
        super.viewDidLoad()
        celsiusLabel.text = "???"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Change background color if its morning or evening
        let hour = NSCalendar.current.component(.hour, from: Date())
        switch hour{
        case 7..<16:
            self.view.backgroundColor = UIColor.gray
            break
        default:
            self.view.backgroundColor = UIColor.black
        }
    }
}
