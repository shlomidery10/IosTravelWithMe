//
//  User.swift
//  TravelMe
//
//  Created by admin on 13/01/2020.
//  Copyright © 2020 admin. All rights reserved.
//

import Foundation


class User{
    
    var email:String = ""
    var password:String = ""
    static var postEmail = ""
    
    init(email:String, pass:String){
        self.email = email
        self.password = pass
    }
    
}
