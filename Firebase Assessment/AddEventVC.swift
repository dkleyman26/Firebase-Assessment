//
//  AddEventVC.swift
//  Firebase Assessment
//
//  Created by David Kleyman on 7/13/17.
//  Copyright © 2017 David Kleyman. All rights reserved.
//

import UIKit
import Firebase

protocol DataEditingDelegate {
    func userDidInputData(event: Event)
    func configureEventsDatabase()
}

class AddEventVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    //declaration of variables
    var ref: DatabaseReference!

    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var priceTF: UITextField!
    @IBOutlet weak var importedImage: UIImageView!
    @IBOutlet weak var datePickerTF: UITextField!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var warningLabel: UILabel!
    
    let datePicker = UIDatePicker()
    
    var delegate: DataEditingDelegate? = nil
    var desiredEventToBeUpdated: Event? = nil
    var name: String?
    var address: String?
    var price: String?
    var image: UIImage?
    var dateAndTime: String?
    
    var myIndex = 0
    var identifier: String? = nil
    //
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference().child("events")
        observe()
        createDatePicker()
        
        importedImage.layer.cornerRadius = view.frame.height/2
        importedImage.layer.masksToBounds = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        nameTF.text = name
        addressTF.text = address
        priceTF.text = price
        datePickerTF.text = dateAndTime
        
        if identifier == "segue"{
            deleteButton.isEnabled = true
            identifier = nil
        }else{
            deleteButton.isEnabled = false
            deleteButton.setTitleColor(UIColor.gray, for: .disabled)
            identifier = nil
        }
    }
    
    
    //date picker initializer
    func donePressed(){
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .short
        
        datePickerTF.text = df.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    func createDatePicker(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolBar.setItems([doneButton], animated: false)
        
        datePickerTF.inputAccessoryView = toolBar
        datePickerTF.inputView = datePicker
        
    }
    //
    
    //adding event to database
    func addEvent(){
        let key = ref.childByAutoId().key
        
        let event =
        ["id": key,
        "name": nameTF.text!,
        "address": addressTF.text!,
        "price": priceTF.text!,
        "date and time": datePickerTF.text!,
        ] as [String : AnyObject]
        
        ref.child(key).setValue(event)
    }
    
    
    //updating event to datatbase
    func updateEvent(id: String, name: String, address: String, price: String, dateAndTime: String){
        let event =
            ["id": id,
             "name": name,
             "address": address,
             "price": price,
             "date and time": dateAndTime,
            ] as [String : AnyObject]
        
        ref.child(id).setValue(event)
        
    }
    
    
    //observing database and gathering event json
    func observe(){
        ref.observe(DataEventType.value, with: { (snapshot) in
            if snapshot.childrenCount > 0{
                self.delegate?.configureEventsDatabase()
                
                if self.delegate != nil{
                    if self.desiredEventToBeUpdated == nil{
                        for events in snapshot.children.allObjects as! [DataSnapshot]{
                            let event = events.value as? [String: AnyObject]
                            let id = event?["id"] as! String
                            let name = event?["name"] as! String
                            let address = event?["address"] as! String
                            let price = event?["price"] as! String
                            let dateAndTime = event?["date and time"] as! String
                            let tempEvent = Event(name: name, image: #imageLiteral(resourceName: "NoImage") , price: price, address: address, time: dateAndTime)
                            tempEvent.setID(id: id)
                            self.delegate?.userDidInputData(event: tempEvent)
                            
                        }
                    }
                    
                }
                
            }
        })
    }
    
    
    // deleting event from database
    func deleteEvent(id: String){
        ref.child(id).setValue(nil)
        desiredEventToBeUpdated = nil
    }

    @IBAction func addImagePressed(_ sender: UIButton) {
        
        //presenting camera and photo library
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionsheet = UIAlertController(title: "Photo", message: "Choose a photo source", preferredStyle: .actionSheet)
        
        actionsheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionsheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionsheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionsheet, animated: true, completion: nil)
        
    }
    
    // image picker delegate functions
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        self.importedImage.image = image
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    //
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        if nameTF.text == "" || addressTF.text == "" || priceTF.text == "" || datePickerTF.text == ""{
            warningLabel.text = "Please enter all text fields."
        }else{
            warningLabel.text = ""
            self.navigationController?.popViewController(animated: true)
            if desiredEventToBeUpdated == nil{
                addEvent()
            }else{
                self.updateEvent(id: (self.desiredEventToBeUpdated?.id)!,
                                 name: self.nameTF.text!,
                                 address: self.addressTF.text!,
                                 price: self.priceTF.text!,
                                 dateAndTime: self.datePickerTF.text!)
                self.desiredEventToBeUpdated = nil
            }
        }
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        deleteEvent(id: (desiredEventToBeUpdated?.id)!)
    }
    

}
