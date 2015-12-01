//
//  CollectionExtension.swift
//  SafeCollection
//
//  Created by machaabani on 28/11/2015.
//  Copyright © 2015 ThinkRight. All rights reserved.
//

import Foundation
import Crashlytics

extension CollectionType{
    func safeIndex(i:Int) -> Self.Generator.Element?{
        //CollectionType.Index.Distance defaults to Int, but may not always be Int.
        //To prevent problem on 32 bit machine we convert toIntMax(Int64) to Int
        let collectionCount = Int(self.count.toIntMax())
        //If release configuration
        if !DEBUG_BUILD {
            /* If collection is not empty & (i < collectionCount) continue else
             send information about the error to Answers(Fabric) */
            guard !self.isEmpty && collectionCount > abs(i) else {
                self .sendStackCallers(i, count: collectionCount)
                return nil
            }
        }
        // Iterate over the collection and send element if it exist
        for (index, element) in self.enumerate(){
            if index == i {
                return element
            }
        }
        // If Debug configuration we print the error and simulate a crash using crashlytics
        if DEBUG_BUILD {
            NSLog("fatal error: Array index : \(i) out of range \(collectionCount)")
            Crashlytics.sharedInstance().crash()
        }
        return nil

    }
    
    func sendStackCallers(i:Int, count:Int){
        let sourceString: String = NSThread.callStackSymbols()[2]
        let separatorSet :NSCharacterSet = NSCharacterSet(charactersInString: " -[]+?.,")
        let array = NSMutableArray(array: sourceString.componentsSeparatedByCharactersInSet(separatorSet))
        array.removeObject("")

        if let classCaller = array[3] as? String{
            let errorMessage = "fatal error: Array index : \(i) out of range \(count)"
            let date = NSDate()
            let attributes: [String: String] = ["Date": date.description,
                                                "Error message": errorMessage,
                                                "Framework&Class&Method": classCaller]
            //Send all information of the out of range bug to Answers(Fabric)
            // You can use google analytics to send informations too
            Answers.logCustomEventWithName("Array crash",
                    customAttributes: attributes)
        }
    }
}
