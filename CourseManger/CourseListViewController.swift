//
//  ViewController.swift
//  CourseManger
//
//  Created by بدور on 23/12/2018.
//  Copyright © 2018 Bdour. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase
import FirebaseUI


class CourseListViewController: UIViewController  {

    // MARK: Properties
    var ref: DatabaseReference!
    var courses: [CourseObject]! = []
    fileprivate var _refHandle: DatabaseHandle!
    fileprivate var _authHandle: AuthStateDidChangeListenerHandle!
    var user: User?
    var displayName = "Anonymous"
    var items : Results<Course>?

    // MARK: Outlets
    @IBOutlet weak var tableView : UITableView?
    @IBOutlet weak var downloadingView : UIView?
    @IBOutlet weak var Indicator : UIActivityIndicatorView?
     @IBOutlet weak var AddBtn : UIBarButtonItem?
     @IBOutlet weak var SignInBtn : UIBarButtonItem?
     @IBOutlet weak var RefreshBtn : UIBarButtonItem?
    
    // MARK: Life Cycle
    override func viewDidLoad() {
       
        super.viewDidLoad()
       
        if (DBManager.sharedInstance.getDataFromDB().count == 0){
              configureAuth()
        }
        
        else {
            let newCourses = DBManager.sharedInstance.getDataFromDB()
            for c in newCourses
            {
              courses.append(c.getCourseObj())
            }
          
             self.downloadingInStatus(isDownloading: false)
        }
        }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if (user == nil && DBManager.sharedInstance.getDataFromDB().count == 0 ){
             SignInBtn?.title = "Sign In"
        }
        else {
            
            SignInBtn?.title = "Sign Out"
         
        }
           tableView?.reloadData()
        
    }
    
    // MARK: Config
    func configureAuth() {
        let provider: [FUIAuthProvider] = [FUIGoogleAuth()]
        FUIAuth.defaultAuthUI()?.providers = provider
        // listen for changes in the authorization state
        _authHandle = Auth.auth().addStateDidChangeListener { (auth: Auth, user: User?) in
        // refresh table data
            self.downloadingInStatus(isDownloading: true)
           
            // check if there is a current user
            if let activeUser = user {
                // check if the current app user is the current FIRUser
                if self.user != activeUser {
                    self.user = activeUser
                    self.configureDatabase()
                    let name = user!.email!.components(separatedBy: "@")[0]
                    self.displayName = name
                }
            } else {
                // user must sign in
                self.loginSession()
            }
        }
    }
    
    func configureDatabase() {
        //  configure database to sync messages
         ref = Database.database().reference(withPath: "CourseList")
        // 1
       _refHandle =  ref.observe(.value , with: { snapshot in
            // 2
            var courses: [CourseObject] = []
        DBManager.sharedInstance.deleteAllFromDatabase()
            // 3
            for item in snapshot.children {
                // 4
                let event = CourseObject(snapshot: item  as! DataSnapshot)
                courses.append(event)
                DBManager.sharedInstance.addData(object: event.getCourse())
                
        }
            // 5
        self.downloadingInStatus(isDownloading: false)
            self.courses = courses
            self.tableView?.reloadData()
        })}

    deinit {
        // set up what needs to be deinitialized when view is no longer being used
        ref.child("CourseList").removeObserver(withHandle: _refHandle)
            Auth.auth().removeStateDidChangeListener(_authHandle)
    }
    
    // MARK: update UI status
    func downloadingInStatus(isDownloading: Bool) {
        downloadingView?.isHidden = !isDownloading
        AddBtn?.isEnabled =  !isDownloading
       RefreshBtn?.isEnabled = !isDownloading
        if(isDownloading){
            SignInBtn?.title = ""
            Indicator?.startAnimating()
            
        }
        else {
            SignInBtn?.title = "Sign Out"
             Indicator?.stopAnimating()
            Indicator?.isHidden = true
        }
    }
    
    func loginSession() {
        let authViewController = FUIAuth.defaultAuthUI()!.authViewController()
        self.present(authViewController, animated: true, completion: nil)
    }
    
     // MARK: Actions
    @IBAction func addNewCourse(_ sender: AnyObject) {
        if Reachability.isConnectedToNetwork(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewCourseView") as! NewCourseView
        vc.courseLocation = displayName
            self.present(vc, animated: true, completion: nil)}
        else {
            alertWithError(error: "check internet connection")
        }
    }
    
    @IBAction func signOut(_ sender: AnyObject) {
        if (Reachability.isConnectedToNetwork()){
            if (user==nil){
                loginSession()
            }
            else{
                do {
                    try Auth.auth().signOut()
                    user = nil
                    DBManager.sharedInstance.deleteAllFromDatabase()
                } catch {
                    print("unable to sign out: \(error)")
                }
                
            }}
        else{ alertWithError(error: "check internet connection")}
    }
    
    @IBAction func refresh(_ sender: AnyObject) {
        if Reachability.isConnectedToNetwork(){
            downloadingInStatus(isDownloading: true)
            configureDatabase()
        }
        else
        {
            alertWithError(error: "check internet connection")
        }
    }
     // MARK: Alerts
    private func alertWithError(error: String) {
        let alertView = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "dismiss", style: .cancel) {
            UIAlertAction in
         }
        alertView.addAction(cancelAction)
        self.present(alertView, animated: true){
            self.view.alpha = 1.0
      }  }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
        case "ShowDetail":
            let vc = segue.destination as? CourseDetailViewController
            if let indexPath = tableView?.indexPathForSelectedRow {
                vc?.course = DBManager.sharedInstance.getDataFromDB() [indexPath.row] as Course
                if (courses.count>0){
                    vc?.courseObj = courses[indexPath.row] as CourseObject}
            }
            break
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
    }

extension CourseListViewController: UITableViewDelegate , UITableViewDataSource {
    
    // MARK: UITableView Delegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DBManager.sharedInstance.getDataFromDB().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)  as! CourseCell
        let index = indexPath.row
        let item = DBManager.sharedInstance.getDataFromDB() [index] as Course
        
        cell.courseTitle.text = item.Title
       
        cell.courseTime.text  =  item.Time
        if (Int(item.avilableSeats) == 0 ){
            cell.courseAvilabiltyImg.image = UIImage(named: "notavalbe")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if (Reachability.isConnectedToNetwork()){
            let item = DBManager.sharedInstance.getDataFromDB() [indexPath.row] as Course
            DBManager.sharedInstance.deleteFromDb(object: item)
           
               let CurrentCourse = ref.child((courses[indexPath.row].key))
                CurrentCourse.ref.removeValue()
            tableView.reloadData()
            
            }}
        else {
            alertWithError(error: "Check Internet Connection")
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowDetail", sender: nil)
    }
    
}
