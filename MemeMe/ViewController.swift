//
//  ViewController.swift
//  MemeMe
//
//  Created by Mohamad Basuony on 2/8/19.
//  Copyright © 2019 Mohamad Basuony. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var toolBarTop: UIToolbar!
    
    @IBOutlet weak var toolBarBottom: UIToolbar!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomtextField: UITextField!
    let memeTextAttributes : [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor : UIColor.white,
        NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth : -3
        
        ]
    override func viewDidLoad() {
        imagePicker.delegate = self
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tapToHideKeyboard()

        textFieldinit(textField: topTextField, text: "TOP")
        textFieldinit(textField: bottomtextField, text: "BOTTOM")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        subscribeToKeyboardNotifications()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeToKeyboardNotifications()
    }
    func textFieldinit (textField : UITextField ,text : String){
        textField.text = text
        textField.backgroundColor = UIColor.clear
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = NSTextAlignment.center

    }
    
    

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        self.imageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    @IBAction func picturePicker(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            present(imagePicker,animated: true,completion: nil)
        }

    }
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cameraButton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera){

        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        present(imagePicker,animated: true,completion: nil)
        }
    }
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    func unsubscribeToKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if bottomtextField.isEditing{
            self.view.frame.origin.y = -getKeyboardHeight(notification: notification)
            
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    func generateMemedImage() -> UIImage {
        toolBarTop.isHidden = true
        toolBarBottom.isHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        toolBarTop.isHidden = false
        toolBarBottom.isHidden = false
        return memedImage
    }
    func save(memedImg: UIImage){
    
    }
}
extension UIViewController {
    func tapToHideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

