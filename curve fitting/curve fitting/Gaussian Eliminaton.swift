//
//  Gaussian Eliminaton.swift
//  curve fitting
//
//  Created by Tenzin Sim on 3/8/21.
//

import Foundation

//MARK: Declaration
let TOL = 1e-15 //accuracy tolerance level
let str = "no solution" //MARK: fail txt
var matrix = [[Double]]()
func solveGauss()->[Double]{
    //Initialise variables
    var state = false //Used for guacian Elimination
    var arraySize = matrix.count
    //MARK: output
    var output = [Double](repeating: 0.0, count: arraySize) //Initialise output

    //MARK: Gaucian Elimination functions
    func addRows(_ n:Int,_ m:Int){
        for i in 0...arraySize{
            matrix[n][i]+=matrix[m][i]
        }
    }
    func subRows(_ n:Int,_ m:Int){
        for i in 0...arraySize{
            matrix[n][i]-=matrix[m][i]
        }
    }
    func mulRow(_ n:Int,_ m:Double){ //multiply(row,value)
        for i in 0...arraySize{
            matrix[n][i] = matrix[n][i] * m
        }
    }
    func divRow(_ n:Int,_ m:Double){ //divide(row,value)
        for i in 0...arraySize{
            matrix[n][i] = matrix[n][i] / m
        }
    }
    func equalZero(_ n:Double)->Bool{
        if n < TOL && n > -TOL{
            return true
        }else{
            return false
        }
    }
    //MARK:Gaucian Elimination Start
    for i in 0..<arraySize{
        if equalZero(matrix[i][i]) && arraySize-i != 1{
            state = false
            for k in i+1..<arraySize{
                if !equalZero(matrix[k][i]) && state == false{
                    addRows(i, k)
                    state = true
                    //print(k)
                }
            }
        }else if equalZero(matrix[i][i]) && arraySize-i != 1{
            print(str)
        }
        divRow(i, matrix[i][i])
        for j in (i+1)..<arraySize{
            if !equalZero(matrix[j][i]){
                divRow(j, matrix[j][i])
                subRows(j, i)
            }
        }
    }
    //print(matrix)
    for i in 1...arraySize{
        output[arraySize-i] = matrix[arraySize-i][arraySize]
        for j in arraySize-i+1..<arraySize{
            output[arraySize-i]-=matrix[arraySize-i][j]*output[j]
        }
    }

    return output
}
