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
    fileprivate var internalProgram = [AnyObject]()

    func setOperand(operand: Double) {
        accumulator = operand
        internalProgram.append(operand as AnyObject)
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
    
    func performOperation(symbol: String){
        internalProgram.append(symbol as AnyObject)
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
    
    typealias PropertyList = AnyObject
    
    var program: PropertyList{
    
        get {
            return internalProgram as CalculatorBrain.PropertyList
        }
        set{
            clear()
            if let arrayOfOps = newValue as? [AnyObject] {
                for op in arrayOfOps {
                    if let operand = op as? Double  {
                        setOperand(operand: operand)
                    } else if let operation = op as? String {
                        performOperation(symbol: operation)
                    }
                }
            }
        }
    }
    
    func clear() {
        accumulator = 0.0
        pending = nil
        internalProgram.removeAll()
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
