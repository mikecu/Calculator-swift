//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Lisa Quayle on 5/01/17.
//  Copyright © 2017 Lisa Quayle. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    fileprivate var accumulator = 0.0

    func setOperand(_ operand: Double) {
        accumulator = operand
    }
    
    fileprivate var operations: Dictionary<String, Operation> = [
        "π": Operation.constant(M_PI),
        "√": Operation.unaryOperand(sqrt),
        "cos": Operation.unaryOperand(cos),
        "✕": Operation.binaryOperand({ $0 * $1}),
        "+": Operation.binaryOperand({ $0 + $1}),
        "-": Operation.binaryOperand({ $0 - $1}),
        "÷": Operation.binaryOperand({ $0 / $1}),
        "=": Operation.equals
    ]
    
    fileprivate enum Operation {
        case constant(Double)
        case unaryOperand((Double) -> Double)
        case binaryOperand((Double, Double) -> Double)
        case equals
    }
    
    func performOperation(_ symbol: String){
        if let operation = operations[symbol] {
            switch operation{
            case .constant(let value):
                accumulator = value
            case .unaryOperand(let function):
                accumulator = function(accumulator)
            case .binaryOperand (let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .equals:
                executePendingBinaryOperation()
            }
        }
    }
    
    fileprivate func executePendingBinaryOperation()
    {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    fileprivate var pending: PendingBinaryOperationInfo?
    
    fileprivate struct  PendingBinaryOperationInfo{
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    var result: Double {
        get{
            return accumulator
        }
    }
    
}
