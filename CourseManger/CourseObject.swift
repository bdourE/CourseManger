/*
 * Copyright (c) 2015 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Foundation
import Firebase

struct CourseObject {
  
 
  let key: String
  let Title: String
  let Detaile: String
  let Time: String
  let Location: String
  let Host: String
  let avilableSeats: String
  let ref: DatabaseReference?
 
    init(Tile: String,Detaile: String ,Time: String ,Location: String, host: String ,avilableSeats : Int ,key: String = "") {
   self.key = key
    
   self.Title = Tile
      self.Detaile = Detaile
      self.Time = Time
      self.Location = Location
      self.Host = host
        self.avilableSeats = String(avilableSeats)
        
       self.ref = nil
      }

  init(snapshot: DataSnapshot) {
    key = snapshot.key
    let snapshotValue = snapshot.value as! [String : AnyObject]
   Title = snapshotValue["Title"] as! String
    Detaile = snapshotValue["Detaile"] as! String
    Time = snapshotValue["Time"] as! String
   Location = snapshotValue["Location"] as! String
    Host = snapshotValue["Host"] as! String
    avilableSeats = snapshotValue["avilableSeats"] as! String

     ref = snapshot.ref
  }

  func toAnyObject() -> Any {
    return [
      "Title": Title,
       "Detaile": Detaile,
        "Host": Host,
         "Time": Time,
          "Location": Location ,
           "avilableSeats": avilableSeats ,
 
    ]
  }
 
    func getCourse()-> Course{
    let course = Course()
        course.Title = Title
        course.Detaile = Detaile
        course.Host = Host
        course.Time = Time
        course.avilableSeats = avilableSeats
        course.Location = Location
       course.key = key
        return course
        
    }
  
}
