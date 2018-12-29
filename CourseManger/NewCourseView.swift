//
//  AddNewCourseController.swift
//  CourseManger
//
//  Created by بدور on 27/12/2018.
//  Copyright © 2018 Bdour. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class NewCourseView : UIViewController {
    
    // MARK: Properties
    var courseLocation = ""
    let ref = Database.database().reference(withPath: "CourseList")

    // MARK: Outlets
    @IBOutlet weak var courseTitle: UITextField!
    @IBOutlet weak var courseDescription: UITextField!
    @IBOutlet weak var courseTime: UIDatePicker!
    @IBOutlet weak var courseHost: UITextField!
    @IBOutlet weak var NumberOfSeat: UITextField!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        stepper.wraps = true
        stepper.autorepeat = true
        stepper.maximumValue = 100
        stepper.minimumValue = 1
    }
    
    // MARK: Actions
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        NumberOfSeat.text = Int(sender.value).description
    }
    
    @IBAction func save(_ sender: Any) {
        if (courseTitle.text! != "" && courseHost.text != ""){
      
            let NewCourse : CourseObject?
            let df = DateFormatter()
            df.dateFormat = "dd-MM-yyyy"
            let courseTimeTxt  = df.string(from: courseTime.date)
            NewCourse = CourseObject(Tile: courseTitle.text!, Detaile: courseDescription.text!, Time: courseTimeTxt, Location: courseLocation, host: courseHost.text!, avilableSeats: Int (NumberOfSeat.text!)!)
            // Get a key for a new Post.
            let newKey = ref.childByAutoId();
            newKey.setValue(NewCourse?.toAnyObject())
            DBManager.sharedInstance.addData(object: (NewCourse?.getCourse())!)
            dismiss(animated: true)
        }
        else {
            alertWithError(error: "complete Missing field to continue")
        } }
  
    @IBAction func cancel(_ sender: Any) {
         dismiss(animated: true)
    }
    
    // MARK: ERROR Alert
    private func alertWithError(error: String) {
        let alertView = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "dismiss", style: .cancel) {
            UIAlertAction in
            self.saveBtn.isEnabled = true
        }
        alertView.addAction(cancelAction)
        self.present(alertView, animated: true){
            self.view.alpha = 1.0
             self.saveBtn.isEnabled = false
        }
    }
}
