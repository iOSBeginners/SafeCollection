# SafeCollection

Write safer applications with Swift
===================================

I created this project after reading the article "Swift’s Protocol Extensions" of Jordan Morgan
(https://medium.com/the-traveled-ios-developers-guide/protocol-oriented-programming-9e1641946b5c#.v9pqn445m)

I agree with Morgan when he say that 80% of all runtime exceptions are caused by this bug:
fatal error: Array index out of range

But i don't agree to ignore always this error because in debug mode we need this crash to know 
that something was wrong

That is why a create this rule :
- In Debug mode   : Simulate a crash so developers can correct their alogorithm
- In Release mode : Don't simulate crash but send this data to Crashlytics or GoogleAnalytics to solve them later

In this project i used Answers a solution of Fabric to send the name of method/Class and error message to help developer to correct it later.
I used Crashlytics to simulate a crash in debug mode to alert the developer that something was wrong.

# How to Use this extension :
Example :        
```
var someInts = [Int]()
someInts = [1,2,3,4,5]
// use safeIndex(index) in any CollectionType
someInts.safeIndex(18)
```
1. Add Crashlytics to your project

2. Add "PreProcessorMacros" .h and .m files

3. Then, in your Objective-C Bridging Header #import "PreProcessorMacros.h"

4. Then add this extension :

```
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
    let collectionCount = Int(self.count.toIntMax())
    if !DEBUG_BUILD {
        guard !self.isEmpty && collectionCount > abs(i) else {
        self .sendStackCallers(i, count: collectionCount)
        return nil
        }
    }
    for (index, element) in self.enumerate(){
        if index == i {
            return element
        }
    }
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
    //Send all information of the out of range bug to Crashlytics
    // You can use google analytics to send informations too
    Answers.logCustomEventWithName("Array crash",
                                customAttributes: attributes)
    }

    }
}
```

#
I'm preparing an article to explain why i made this choice if you are interrested i can post it in your blog

Contact : 
twitter : @dali_ios
mail :mohamedali.chaabani@gmail.com
