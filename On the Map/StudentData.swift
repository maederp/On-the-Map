//
//  StudentData.swift
//  On the Map
//
//  Created by Peter Mäder on 24.05.16.
//  Copyright © 2016 Peter Mäder. All rights reserved.
//

import Foundation

class StudentData {
    
    static let sharedInstance = StudentData()
    
    var students : [StudentInformation]
    
    private init(){
        students = [StudentInformation]()
    }
}