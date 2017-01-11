//
//  ConversionViewController.swift
//  WorldTrotter
//
//  Created by Toph Matta on 12/17/16.
//  Copyright © 2016 Toph Matta. All rights reserved.
//

import UIKit

class ConversionViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var celsiusLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    
    let todaysDate = NSDate()
    let calendar = NSCalendar.current
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        let currentHour = calendar.component(.hour, from: todaysDate as Date)
                
        if 17...24 ~= currentHour {
            
            self.view.backgroundColor = UIColor.darkGray
            
        }
        
    }
    
    let numberFormatter: NumberFormatter = {
        
        let nf = NumberFormatter()
        
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 1
        
        
        return nf
        
    }()
    
    var fahrenheitValue: Double? {
        
        didSet {
            
            updateCelsiusLabel()
            
        }
        
    }
    
    var celsiusValue: Double? {
        
        if let value = fahrenheitValue {
            
            return (value - 32) * (5/9)
            
        } else {
            
            return nil
            
        }
        
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentLocale = NSLocale.current
        let decimalSeparator = currentLocale.decimalSeparator!
        
        let existingTextHasDecimalSeparator = textField.text?.range(of: decimalSeparator)
        let replacementTextHasDecimalSeparator = string.range(of: decimalSeparator)
        
        let charactersNotAllowed = NSCharacterSet.letters
        let replacementTextHasLetter = string.rangeOfCharacter(from: charactersNotAllowed)
        
        if existingTextHasDecimalSeparator != nil && replacementTextHasDecimalSeparator != nil {

            return false
            
        }
        
        if replacementTextHasLetter != nil {
            
            return false
            
        }
        
        return true
        
    }
    
    func updateCelsiusLabel() {
        
        if let value = celsiusValue {
            
            celsiusLabel.text = numberFormatter.string(from: NSNumber(value: value))
            
        } else {
            
            celsiusLabel.text = "???"
            
        }
        
        
    }
    
    @IBAction func fahrenheitFieldEditingChanged(textField: UITextField){
        
        if let text = textField.text, let number = numberFormatter.number(from: text) {
            
            fahrenheitValue = number.doubleValue
            
        } else {
            
            fahrenheitValue = nil
            
        }
        
        
    }
    
    @IBAction func dismissKeyboard(sender: AnyObject){
        
        textField.resignFirstResponder()
        
    }
    
    
    
    
}
