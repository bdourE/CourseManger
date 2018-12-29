//
//  CourseDetailViewController.swift
//  CourseManger
//
//  Created by بدور on 27/12/2018.
//  Copyright © 2018 Bdour. All rights reserved.
//


import Foundation
import UIKit
import RealmSwift
import Firebase

class CourseDetailViewController : UIViewController {
    
     // MARK: Properties
    var course : Course?
    var courseObj : CourseObject?
    
     // MARK: Outlets
    @IBOutlet weak var courseTitle: UILabel!
    @IBOutlet weak var courseDescription: UITextView!
    @IBOutlet weak var courseTime: UILabel!
    @IBOutlet weak var courseHost: UILabel!
    @IBOutlet weak var NumberOfSeat: UILabel!
    @IBOutlet weak var RigisterBtn: UIButton!
    @IBOutlet weak var seatsAvailabilatyImg : UIImageView!
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        courseDescription.text = course?.Detaile
        courseTitle.text = course?.Title
        courseHost.text = course?.Host
         courseTime.text  = course?.Time
         NumberOfSeat.text = course?.avilableSeats
        if (Int((course?.avilableSeats)!)! == 0){
            RigisterBtn.isEnabled = false
            seatsAvailabilatyImg.image = UIImage(named: "notavalbe")
        }
    }
    
    // MARK: Actions
    @IBAction func rigiterNew(_ sender: Any) {
       presentNewStudentAlert()
   }
    
    // MARK: Alert
    func presentNewStudentAlert() {
        if let obj = courseObj {
            let ref = Database.database().reference(withPath: "CourseList")
            let CurrentCourse = ref.child((obj.key))
        let alert = UIAlertController(title: "New Student", message: "Enter a name of student ", preferredStyle: .alert)
        // Create actions
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] action in
            if let name = alert.textFields?.first?.text {
                if  !name.isEmpty  {
                    let newNumber = String (Int((self?.course?.avilableSeats)!)! - 1)
                    DBManager.sharedInstance.updateData(object: (self?.course)!,  value: newNumber)
                    self?.NumberOfSeat.text = newNumber
                    CurrentCourse.ref.updateChildValues([
                     "avilableSeats": newNumber
                      ])
                     if (Int((self?.NumberOfSeat.text)!)! == 0){
                   self?.RigisterBtn.isEnabled = false
                    self?.seatsAvailabilatyImg.image = UIImage(named: "notavalbe")
                }
                }}}
        // Add a text field
        alert.addTextField { textField in
            textField.placeholder = "Name"
            }
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        present(alert, animated: true, completion: nil)
        }   else {
                alertWithError(error: "check internet Connection")
            }
    }
    
    private func alertWithError(error: String) {
        let alertView = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "dismiss", style: .cancel)
        alertView.addAction(cancelAction)
        self.present(alertView, animated: true){
            self.view.alpha = 1.0   }
    }
        
    }
