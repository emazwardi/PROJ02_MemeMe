//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Erwin Mazwardi on 25/04/2015.
//  Copyright (c) 2015 Socdesign. All rights reserved.
//

import UIKit

class MemeDetailViewController : UIViewController {
    
    // Declare a variable which has a type of memeModel array.
    var memes = [memeModel]()
    
    var table_row: Int!
    
    @IBOutlet weak var memeImageDetailView: UIImageView!
    @IBOutlet weak var memeTextDetailView: UILabel!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    var memeDetail: memeModel!
    // Display the image
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true
        self.memeTextDetailView.text = self.memeDetail.top
        self.memeImageDetailView.image = self.memeDetail.memedImage
    }
    // Close the MemeDetailViewController
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.hidden = false
    }
    
    @IBAction func deleteImage(sender: AnyObject) {
        // Get the Application delegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        let rem_memed = appDelegate.memes.removeAtIndex(table_row)
        deleteButton.enabled = false
    }
    
    // Back to Meme Editor
    @IBAction func startOver(sender: AnyObject) {
        var controller: UIViewController
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("MemeEditor") as! UIViewController
        self.presentViewController(controller, animated: true, completion: nil)
    }
}

