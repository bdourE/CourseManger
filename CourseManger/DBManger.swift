//
//  DBManger.swift
//  CourseManger
//
//  Created by بدور on 26/12/2018.
//  Copyright © 2018 Bdour. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class DBManager {
    private var   database:Realm
    static let   sharedInstance = DBManager()
    private init() {
        database = try! Realm()
        let path = database.configuration.fileURL
        print(path)
    }
    func getDataFromDB() ->   Results<Course> {
        let results: Results<Course> =   database.objects(Course.self)
        return results
    }
    func addData(object: Course)   {
        try! database.write {
            database.add(object, update: true)
            print("Added new object")
        }
    }
    func updateData(object: Course , value : String )   {
        try! database.write {
            object.avilableSeats = value
        }
    }
    func deleteAllFromDatabase()  {
        try!   database.write {
            
            database.deleteAll()
           print ( database.objects(Course.self).count)
        }
    }
    func deleteFromDb(object: Course)   {
        try!   database.write {
            database.delete(object)
            print("item deleted")
        }
    }
}
