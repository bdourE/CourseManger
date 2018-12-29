//
//  Course.swift
//  CourseManger
//
//  Created by بدور on 24/12/2018.
//  Copyright © 2018 Bdour. All rights reserved.
//

import Foundation
import RealmSwift
import Firebase

class Course: Object {
    @objc dynamic var Title = ""
    @objc dynamic var Detaile : String? = nil
    @objc dynamic var Host = ""
    @objc dynamic var Time = ""
    @objc dynamic var Location = ""
    @objc dynamic var avilableSeats = ""
     @objc dynamic var key = ""
    @objc dynamic var ID = UUID().uuidString
    
    override static func primaryKey() -> String? {
        return "ID"
    }
    func getCourseObj()-> CourseObject{
        let course = CourseObject(Tile: Title, Detaile: Detaile!, Time: Time, Location: Location, host: Host, avilableSeats: Int(avilableSeats)!, key: key)
      
        
        return course
        
    }
}
