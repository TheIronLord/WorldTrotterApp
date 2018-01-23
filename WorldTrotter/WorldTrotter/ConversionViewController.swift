//
//  ConversionViewController.swift
//  WorldTrotter
//
//  Created by Sajjad Patel on 2018-01-22.
//  Copyright © 2018 Sajjad Patel. All rights reserved.
//

import UIKit

class ConversionViewController : UIViewController{
    @IBOutlet var celsiusLabel : UILabel!
    
    @IBAction func fahrenheitFieldEditingChanged(_ textField: UITextField){
        if let text = textField.text, !text.isEmpty{
            celsiusLabel.text = textField.text
        }else{
            celsiusLabel.text = "???"
        }
    }
}
