//
//  FirstViewController.swift
//  GoGo
//
//  Created by 水垣岳志 on 2017/09/22.
//  Copyright © 2017年 mzgkworks. All rights reserved.
//

import UIKit
import CoreMotion

class FirstViewController: UIViewController {

    let myPedometor = CMPedometer()
    weak var timer: Timer!

    @IBOutlet weak var labelSteps: UILabel!
    @IBOutlet weak var labelDistance: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var buttonExecute: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func tapExecuteButton(_ sender: UIButton) {
        if sender.titleLabel?.text == "Start" {
            labelSteps.text = "0"
            labelDistance.text = "0"
            labelTime.text = "00:00"

            startCounting()
            buttonExecute.setTitle("Stop", for: UIControlState())
        }
        else {
            myPedometor.stopUpdates()
            buttonExecute.setTitle("Start", for: UIControlState())
        }
    }

    func startCounting() {
        if CMPedometer.isPedometerEventTrackingAvailable() {
            myPedometor.startUpdates(from: Date(), withHandler: { (data: CMPedometerData?, error: Error?) in
                DispatchQueue.main.async {
                    // errorがある場合はリターン
                    if error != nil {
                        print("ERROR: \(String(describing: error?.localizedDescription))")
                        return
                    }
                    // dataがnil場合はリターン
                    guard data != nil else {
                        print("ERROR: data = nil")
                        return
                    }
                    let lengthFormatter = LengthFormatter()
                    let steps = data?.numberOfSteps
                    let distance = data?.distance?.doubleValue
                    let time = data?.endDate.timeIntervalSince((data?.startDate)!)

                    self.labelSteps.text = steps?.stringValue
                    self.labelDistance.text = lengthFormatter.string(fromMeters: distance!)

                    // 秒数から時間を算出
                    let formatter = DateComponentsFormatter()
                    formatter.unitsStyle = .positional
                    formatter.allowedUnits = [.minute, .hour, .second]
                    self.labelTime.text = formatter.string(from: time!)
                }
            })
        }
    }

}
