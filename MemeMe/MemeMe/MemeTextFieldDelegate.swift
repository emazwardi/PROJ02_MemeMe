//
//  memeTextFieldDelegate.swift
//  MemeMe
//
//  Created by Erwin Mazwardi on 24/04/2015.
//  Copyright (c) 2015 Socdesign. All rights reserved.
//
import Foundation
import UIKit

class MemeTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    
    //////////////////////////////////////////
    // Implement the textfiled delegate
    // 1. textField(shouldChangeCharactersInRange)
    // 2. textFieldShouldBeginEditing()
    // 3. textFieldDidBeginEditing()
    // 4. textFieldShouldReturn()
    //////////////////////////////////////////
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var newText = textField.text as NSString
        newText = newText.stringByReplacingCharactersInRange(range, withString: string)
        return true
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Set the bottomField tag for the purpose of raising up and down the keyboard
        if textField.restorationIdentifier == "bottom" {
            textField.tag = 1
        } else if textField.restorationIdentifier == "top" {
            textField.tag = 2
        }
        // If the textfield is selected, erase the default text
        textField.text = ""
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
}
