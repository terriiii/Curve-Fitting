//
//  ViewController.swift
//  curve fitting
//
//  Created by Tenzin Sim on 3/7/21.
//

import UIKit

//MARK: Global variables
var coefficients = [Double]()

var points = [[Int]]()
var degree = 5
class Canvas: UIView{
    var offset = 0
    var tooClose = false
    var tooCloseRelease = false
    var pointIsTouched = false
    var closestPoint = [Int]()
    let TOL = 20
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else {return}
        var point = 0
        
        offset = Int(bounds.height)
        // Drawing code
        
        if points.count > degree {
            point = Int(coefficients[coefficients.count-1])
            context.move(to: CGPoint(x:0, y:point))
            for x in 1...Int(bounds.width){
                point = 0
                for i in 0..<coefficients.count{
                    point += Int(coefficients[i] * pow( Double(x), Double(i)))
                }
                //aPath.addLine(to: CGPoint(x: centerX + radius * cos(angle), y: centerY - radius * sin(angle)))
                context.addLine(to: CGPoint(x: CGFloat(x), y: CGFloat(point)))
                //aPath.addLine(to: CGPoint(x: CGFloat(x), y: CGFloat(500)))
            }
        }
        
        print(coefficients)
        //Keep using the method addLineToPoint until you get to the one where about to close the path
        
        //aPath.close()
        
        //If you want to stroke it with a red color
        UIColor.red.set()
        context.setLineWidth(1)
        context.strokePath()
        //If you want to fill it as well
        //aPath.fill()

        print("pong")
        UIColor.blue.set()
        context.setLineWidth(1)
        let boxSize = 5
        for i in points{
            context.move(to: CGPoint(x:i[0]-boxSize, y:i[1]+boxSize))
            context.addLine(to: CGPoint(x:i[0]+boxSize, y:i[1]+boxSize))
            context.addLine(to: CGPoint(x:i[0]+boxSize, y:i[1]-boxSize))
            context.addLine(to: CGPoint(x:i[0]-boxSize, y:i[1]-boxSize))
            context.addLine(to: CGPoint(x:i[0]-boxSize, y:i[1]+boxSize))
        }
        context.strokePath()
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let pointTouched = touches.first?.location(in: nil) else {return}
        
        tooClose = false
        pointIsTouched = false
        for i in points{
            if Int(pointTouched.x) <= i[0] + TOL && Int(pointTouched.x) >= i[0] - TOL{
                tooClose = true
                closestPoint = i
                if Int(pointTouched.y) <= i[1] + TOL && Int(pointTouched.y) >= i[1] - TOL{
                    pointIsTouched = true
                }
            }
        }
        if tooClose == false{
            points.append([Int(pointTouched.x),Int(pointTouched.y)])
            ViewController().findCoefficients()
            setNeedsDisplay()
        }else if pointIsTouched == true{
            points = points.filter(){$0 != closestPoint}
        }else{
            tooClose = false
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>,
                      with event: UIEvent?){
        guard let pointReleased = touches.first?.location(in: nil) else {return}
        tooCloseRelease = false
        for i in points{
            if Int(pointReleased.x) <= i[0] + TOL && Int(pointReleased.x) >= i[0] - TOL{
                tooCloseRelease = true
            }
        }
        if tooClose == true && tooCloseRelease == false{
            points.append([Int(pointReleased.x),Int(pointReleased.y)])
            ViewController().findCoefficients()
            setNeedsDisplay()
        }else if tooClose == true && tooCloseRelease == true{
            points.append(closestPoint)
        }
        //print(pointReleased)
    }

}

class ViewController: UIViewController {
    var data = [[Double]]()
    var predictedData = [Double]()
    let canvas = Canvas()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(canvas)
        canvas.backgroundColor = .white
        canvas.frame = view.frame
    }
    func findCoefficients(){
        data = [[Double]]()
        for currentDegree in 1...degree{
            var array = [Double]()
            for i in points{
                array.append(pow(Double(i[0]),Double(currentDegree)))
            }
            data.append(array)
        }
        print(data)
        predictedData = []
        for i in points{
            predictedData.append(Double(i[1]))
        }
        solveRegression()
        print("ping")
        print(data)
    }
    func solveRegression(){
        let factorCount = data.count
        let dataCount = data[0].count
        data.insert([Double](repeating: 1, count: dataCount), at: 0)

        matrix = [[Double]](repeating: [Double](repeating: 0, count: factorCount+2), count: factorCount+1) //Initialise array

        for i in 0...factorCount{
            for j in 0...factorCount{
                for n in 0..<dataCount{
                    matrix[i][j] += data[i][n] * data[j][n]
                }
            }
        }
        for i in 0...factorCount{
            for n in 0..<dataCount{
                matrix[i][factorCount+1] += data[i][n] * predictedData[n]
            }
        }
        coefficients = solveGauss()
    }

}

