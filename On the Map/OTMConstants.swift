//
//  OTMConstants.swift
//  On the Map
//
//  Created by Peter Mäder on 28.04.16.
//  Copyright © 2016 Peter Mäder. All rights reserved.
//

import Foundation


extension OTMClient {
    
    // MARK: Constants
    struct Constants {
        
        // MARK: Facebook API Key
        static let FacebookID: String = "365362206864879"
        
        
        // MARK: PARSE Keys
        static let ParseApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let ParseRestAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        // MARK: Udacity URLs
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api"
        static let AuthorizationURL : String = "https://www.udacity.com/api/session"        
    }
    
    // MARK: Methods
    struct Methods {
        
        // MARK: User Data
        static let PublicUserData = "/users/{id}"
        
        // MARK: Authentication
        static let SessionID = "/session"
    }
    
    // MARK: URL Keys
    struct URLKeys {
        static let UserID = "id"
    }
    
    // MARK: JSON Body Keys
    struct JSONBodyKeys {
        static let UserName = "username"
        static let Password = "password"
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: General
        static let StatusCode = "status_code"
        
        // MARK: Authorization
        static let Session = "session"
        static let SessionID =  "id"
        static let SessionExpiration = "expiration"
        
        // MARK: Account
        static let Account = "account"
        static let AccountKey = "key"
        static let UserID = "id"
        
        // MARK: UserData Response
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MediaURL = "mediaURL"
        static let MapString = "mapString"
        static let Longitude = "longitude"
        static let Latitude = "latitude"
    }
}