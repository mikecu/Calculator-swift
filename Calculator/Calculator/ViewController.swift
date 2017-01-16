//
//  ViewController.swift
//  Calculator
//
//  Created by Lisa Quayle on 4/01/17.
//  Copyright © 2017 Lisa Quayle. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet fileprivate weak var display: UILabel!
    
    fileprivate var userIsInTheMiddleOfTyping = false
    
    
    @IBAction fileprivate func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textInTheDisplay = display.text!
            display.text = textInTheDisplay + digit
        }
        else{
            display.text = digit
        }
        userIsInTheMiddleOfTyping = true
    }
    
    fileprivate var displayValue: Double {
        get {
            return Double (display.text!)!
        }
        
        set {
            display.text = String(newValue)
        }
    }

    var savedProgram: CalculatorBrain.PropertyList?
    
    @IBAction func save() {
        savedProgram = brain.program
    }
    

    @IBAction func restore() {
        if savedProgram != nil {
            brain.program = savedProgram!
            displayValue = brain.result
        }
    }
    
    fileprivate var brain = CalculatorBrain()
    
    @IBAction fileprivate  func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping{
            brain.setOperand(operand: displayValue)
            userIsInTheMiddleOfTyping = false
            
        }
        
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(symbol: mathematicalSymbol)
        }
        displayValue = brain.result
    }
}

