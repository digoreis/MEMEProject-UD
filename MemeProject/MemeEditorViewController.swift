//
//  ViewController.swift
//  MemeProject
//
//  Created by apple on 18/09/16.
//  Copyright © 2016 Rodrigo Reis. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var memeContainer: UIView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    
    @IBOutlet weak var imageContainer: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeFromKeyboardNotifications()
    }
    
    fileprivate func setupUI() {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center
        
       let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.black,
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40) ?? UIFont.systemFont(ofSize: 40),
            NSStrokeWidthAttributeName : -2.0,
            NSParagraphStyleAttributeName: style
        ] as [String : Any]
        
        topText.defaultTextAttributes = memeTextAttributes
        bottomText.defaultTextAttributes = memeTextAttributes
    }
    
    fileprivate func generateMemedImage() -> UIImage {
        UIGraphicsBeginImageContext(self.memeContainer.frame.size)
        memeContainer.drawHierarchy(in: self.memeContainer.frame,
                                     afterScreenUpdates: true)
        let memedImage : UIImage =
            UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return memedImage
    }
    
    @IBAction func pickAnImageFromCamera (sender: AnyObject) {
        openAlbumOrCamera(camera: false)
    }
    
    @IBAction func pickAnImageFromAlbum (sender: AnyObject) {
        openAlbumOrCamera(camera: true)
    }
    
    fileprivate func openAlbumOrCamera(camera : Bool) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        if camera {
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        }
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cancel(sender : AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func share(sender : AnyObject) {
        let generateImage =  generateMemedImage()
        
        let shareItems:Array = [generateImage]
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        activityViewController.completionWithItemsHandler = { activity, success, items, error in
            if success {
                self.save(memeImage: generateImage)
                self.dismiss(animated: true, completion: nil)
            }
        }
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    func save(memeImage : UIImage) {
        let meme = MemeData(topText : topText.text ?? "", bottomText : bottomText.text ?? "", originImage : imageContainer.image, memeImage: memeImage)

        let object = UIApplication.shared.delegate
        if let appDelegate = object as? AppDelegate {
            appDelegate.memes.append(meme)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            imageContainer.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if !string.isEmpty {
            textField.text = (textField.text?.uppercased() ?? "") + string.uppercased()
            return false
        }
        return true
    }

    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name:
            NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name:
            NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
       
        guard bottomText.isFirstResponder else { return }
        
        if view.frame.origin.y >= 0 {
            view.frame.origin.y -= getKeyboardHeight(notification: notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
            view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
}

