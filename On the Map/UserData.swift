//
//  UserData.swift
//  On the Map
//
//  Created by Peter Mäder on 25.05.16.
//  Copyright © 2016 Peter Mäder. All rights reserved.
//

import Foundation

class UserData {
    
    static let sharedInstance = UserData()
    
    var user : StudentInformation
    
    private init(){
        user = StudentInformation()
    }
}