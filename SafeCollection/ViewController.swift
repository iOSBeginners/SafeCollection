//
//  ViewController.swift
//  SafeCollection
//
//  Created by machaabani on 28/11/2015.
//  Copyright © 2015 ThinkRight. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        var someInts = [Int]()
        someInts = [1,2,3,4,5]
        print("someInts is of type [Int] with \(someInts.count) items.")
        // prints "someInts is of type [Int] with 0 items."
        someInts.safeIndex(18)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

