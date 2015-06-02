//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Erwin Mazwardi on 23/04/2015.
//  Copyright (c) 2015 Socdesign. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UIScrollViewDelegate, UINavigationControllerDelegate, UITextFieldDelegate  {
    
    @IBOutlet weak var scrollBar: UIScrollView!
    @IBOutlet weak var imageScroll: UIScrollView!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var memeToolbar: UIToolbar!
    @IBOutlet weak var memeNavBar: UINavigationBar!
    // Default background image for Meme Editor
    var imageView = UIImageView(image: UIImage(named: "space"))
    var imageSize = CGSizeMake(0,0)
    // Meme Text Attributes
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -3
    ]
    // MemeDelegate pointer
    let memeDelegate = MemeTextFieldDelegate()
    // Create text field frmaes
    let topTextField = UITextField(frame: CGRectMake(0.0, 0.0, 100.0, 50.0))
    let bottomTextField = UITextField(frame: CGRectMake(0.0, 0.0, 150.0, 50.0))
    // Variables to be used in zooming operation
    var keyboardAppear: Bool!
    var isNewImage: Bool = true
    var isNewImagePicker: Bool = false
    var positionFromKeyboard: Bool = false
    var moveUp: CGFloat = 0.0
    
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardAppear = false
        // Set the Image Scroll Attributes
        self.automaticallyAdjustsScrollViewInsets = false
        imageScroll.contentSize = imageView.frame.size
        imageSize = imageView.frame.size
        imageScroll.delegate = self
        imageScroll.addSubview(imageView)
        imageScroll.showsHorizontalScrollIndicator = false
        imageScroll.showsVerticalScrollIndicator = false
        // Set the top field text attributes
        topTextField.text = "TOP"
        topTextField.restorationIdentifier = "top"
        topTextField.adjustsFontSizeToFitWidth = true
        topTextField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters;
        topTextField.textAlignment = NSTextAlignment.Center
        topTextField.defaultTextAttributes = memeTextAttributes
        self.topTextField.delegate = self.memeDelegate
        // Set the bottom field text attrubutes
        bottomTextField.text = "BOTTOM"
        bottomTextField.restorationIdentifier = "bottom"
        bottomTextField.adjustsFontSizeToFitWidth = true
        bottomTextField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters;
        bottomTextField.textAlignment = NSTextAlignment.Center
        bottomTextField.defaultTextAttributes = memeTextAttributes
        self.bottomTextField.delegate = self.memeDelegate
        // Display the textfields on top of the scroll view
        imageScroll.addSubview(bottomTextField)
        imageScroll.addSubview(topTextField)
    }
    
    
    //////////////////////////////////////////
    // Scroll View Delegate Implementations
    // 1. scrollViewDidZoom()
    // 2. viewDidLayoutSubviews()
    // 3. viewForZoomingInScrollView()
    // 4. calcImagePosition()
    // 5. adjustImageFromPicker()
    //////////////////////////////////////////
    
    // Potitioned the image after zoomed
    func scrollViewDidZoom(scrollView: UIScrollView) {
        adjustImageFromPicker()
    }
    // Set the zoom scale and put the resized image correctly
    override func viewDidLayoutSubviews() {
        // Execute the following code for deciding a zoom scale of a new image
        if isNewImage == true   {
            imageScroll.contentSize = imageSize
            let widthScale = imageScroll.bounds.size.width / imageSize.width
            let heightScale = imageScroll.bounds.size.height / imageSize.height
            imageScroll.minimumZoomScale = min(widthScale, heightScale)
            imageScroll.maximumZoomScale = heightScale
            imageScroll.setZoomScale(heightScale, animated: true)
            isNewImage = false
        }
        // Put the resized image correctly
        calcImagePosition()
    }
    // The scroll view delegate
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    // Recalculate image position after zooming
    func calcImagePosition() {
        var currXcenter: CGFloat!
        var bottomTextFieldX: CGFloat!
        var bottomTextFieldY: CGFloat!
        
        // Don't execute this part during the keypad appearance events
        if positionFromKeyboard == false {
            imageScroll.contentInset.top = 20.0
            imageScroll.contentOffset.x = imageScroll.contentSize.width/2.0 - imageScroll.bounds.size.width/2.0
            imageScroll.contentInset.top = -1 * (imageScroll.contentSize.height - imageScroll.bounds.size.height) / 2.0
        }
        // Calculate the x centre of the image
        if imageScroll.contentSize.width > imageScroll.contentOffset.x {
           currXcenter = imageScroll.contentSize.width/2
        }
        else {
           currXcenter = imageScroll.contentSize.width/2 + imageScroll.contentOffset.x
        }
        // Calculate the Y coordinate for the top text field
        let currYcentertop = imageScroll.contentSize.height/10
        // Calculate the Y coordinate for bottom text field
        let currYcenterbottom = (imageScroll.contentSize.height/10) * 9
        
        // Place the bottom text field on the middle of the bottom image
        bottomTextFieldX = currXcenter - bottomTextField.frame.width/2
        bottomTextFieldY = currYcenterbottom - bottomTextField.frame.height/2
        bottomTextField.frame = CGRect(x: bottomTextFieldX, y: bottomTextFieldY, width: bottomTextField.frame.width, height: bottomTextField.frame.height)
        // Place the top text field on the middle of the top image
        let topTextFieldX = currXcenter - topTextField.frame.width/2
        let topTextFieldY = currYcentertop - topTextField.frame.height/2
        topTextField.frame = CGRect(x: topTextFieldX, y: topTextFieldY, width: topTextField.frame.width, height: topTextField.frame.height)
    }
    // Recalculate the image just picked from the image gallery
    func adjustImageFromPicker() {
        // Set the zoom scale for a new image just selected from the gallery
        if isNewImagePicker == true   {
            imageScroll.contentSize = imageSize
            let widthScale = imageScroll.bounds.size.width / imageSize.width
            let heightScale = imageScroll.bounds.size.height / imageSize.height
            imageScroll.minimumZoomScale = min(widthScale, heightScale)
            imageScroll.maximumZoomScale = heightScale
            imageScroll.setZoomScale(heightScale, animated: true)
            isNewImagePicker = false
        }
        // Put the resized image correctly
        calcImagePosition()
    }
    
    //////////////////////////////////////////
    // Image Picker Implementations
    // 1. pickImageFromAlbum()
    // 2. pickImageFromCamera()
    // 3. imagePickerController()
    //////////////////////////////////////////
    //
    @IBAction func pickImageFromAlbum(sender: AnyObject) {
        // Create an image picker object
        let imagePicker = UIImagePickerController()
        // Delegate it
        imagePicker.delegate = self
        // Source from Photo library
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        // Present the Image Picker view
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    //
    @IBAction func pickImageFromCamera(sender: AnyObject) {
        // Create an image picker object
        let imagePicker = UIImagePickerController()
        // Delegate it
        imagePicker.delegate = self
        // Source from Photo library
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        // Present the Image Picker view
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    // Select the image
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            // Show the image on the image view
            imageView.image = image
            // Enable the share button
            self.shareButton.enabled = true
            // Dismiss the Image Picker view
            self.dismissViewControllerAnimated(true, completion: nil)
            // Ready for zooming
            isNewImagePicker = true
        }
    }

    //////////////////////////////////////////
    // 1. viewWillAppear()
    // 2. viewWillDisappear()
    //////////////////////////////////////////
    
    // When the view is about to appear
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        // Subscribe to the keyboard notifications, to allow the view to raise when necessary
        self.subscribeToKeyboardNotifications()
        // Recalculate the image just picked from the image gallery
        adjustImageFromPicker()
    }
    // When the view is about to disappear
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        // Subscribe to the keyboard notifications, to allow the view to fall when necessary
        self.unsubscribeFromKeyboardNotifications()
    }
    
    //////////////////////////////////////////
    // How to move the image up when keyboard appears
    // 1. subscribeToKeyboardNotifications()
    // 2. unsubscribeFromKeyboardNotifications()
    // 3. keyboardWillShow()
    // 4. keyboardWillHide()
    // 5. getKeyboardHeight()
    //////////////////////////////////////////
    
    // The view controller is signing up to be notified when an event is coming up,
    // in this case the UIKeyboardWillShow or the UIKeyboardWillHide
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:"    , name: UIKeyboardWillHideNotification, object: nil)
    }
    // A method to unsubscribe from keyboard notifications
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    // How do we know the keyboard is about to slide up?
    // We use NSNotification. NSNotifications provide a way to announce information
    // throughout a program, across classes.
    func keyboardWillShow(notification: NSNotification) {
        // If the bottom text field being selected, move the image up
        if bottomTextField.tag == 1  {
            moveUp = getKeyboardHeight(notification) - ((imageScroll.bounds.size.height - imageScroll.contentSize.height)/2)
            imageScroll.contentOffset.y = imageScroll.contentOffset.y + moveUp
            positionFromKeyboard = true
        }
        keyboardAppear = true
    }
    // How do we know the keyboard is about to slide down?
    // We use NSNotification. NSNotifications provide a way to announce information
    // throughout a program, across classes.
    func keyboardWillHide(notification: NSNotification) {
        // If te return button pressed, move the image down
        if bottomTextField.tag == 1  {
            bottomTextField.tag = 0 // Reset for the next selection
            imageScroll.contentOffset.y = imageScroll.contentOffset.y - moveUp
            positionFromKeyboard = false // Disable from keyboard activities
        }
    }
    // Calculate the keyboard height
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        // Notification carry information in the user info dictionary
        let userInfo = notification.userInfo
        // The UIKeyboardWillShowNotification carries the keyboard frame in its user info dictionary
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        // So that's how we get the keyboard height
        return keyboardSize.CGRectValue().height
    }

    //////////////////////////////////////////
    // Generate the memed image and move to the activity and sent meme controllers
    // 1. save()
    // 2. generateMemedImage()
    // 3. keyboardWillShow()
    // 4. keyboardWillHide()
    // 5. getKeyboardHeight()
    //////////////////////////////////////////
    
    // Save the image
    func save() {
        //Create the meme
        var meme = memeModel(top: topTextField.text!, bottom: bottomTextField.text!, image: imageView.image, memedImage: generateMemedImage())
        // Add it to the memes array in the Application Delegate
        let pa = UIApplication.sharedApplication().delegate
        let appDelegate = pa as! AppDelegate
        appDelegate.memes.append(meme)
    }
    // Generate memed Image
    func generateMemedImage() -> UIImage {
        // Hide toolbar and navbar
        self.memeToolbar.hidden = true
        self.memeNavBar.hidden = true
        // Render the scroll view to an image
        UIGraphicsBeginImageContext(scrollBar.frame.size)
        scrollBar.drawViewHierarchyInRect(scrollBar.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        // Show toolbar and navbar
        self.memeToolbar.hidden = false
        self.memeNavBar.hidden = false
        // Return the image
        return memedImage
    }
    // Display the Activity View Controller
    @IBAction func shareButtonClicked(sender: AnyObject) {
        // Create a variable with a type of UITabBarController
        var controller: UITabBarController
        // Generate the memed Image
        var sharedImage = generateMemedImage()
        // Create a variable with a type of UIActivityViewController
        var activity: UIActivityViewController!
        // Create the activity view for sending the memed image
        let objectsToShare = [sharedImage]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.excludedActivityTypes = [
            UIActivityTypePostToWeibo,
            UIActivityTypePrint,
            UIActivityTypeAssignToContact,
            UIActivityTypeAddToReadingList,
            UIActivityTypePostToFlickr,
            UIActivityTypePostToVimeo,
            UIActivityTypePostToTencentWeibo
        ]
        // Invoke the activity view controller
        self.presentViewController(activityVC, animated: true, completion: nil)
        // Point to the tab bar controller
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
        
        activityVC.completionWithItemsHandler = {
            (activity, success, items, error) in
                // Save the image
                self.save()
                // Jump to the TableView Controller
                self.presentViewController(controller, animated: true, completion: nil)
        }
        
    }
}

