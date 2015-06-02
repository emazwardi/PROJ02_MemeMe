//
//  memeViewController.swift
//  MemeMe
//
//  Created by Erwin Mazwardi on 26/04/2015.
//  Copyright (c) 2015 Socdesign. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController {
    //
    var memesTest = [memeModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        var memeSentController: UITabBarController
        var memeEditController: UINavigationController
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        
        // This part is used to test which view should be displayed first: Sent Meme or Meme Editor
        // If it's commented out, then Meme Editor will be displayed first, otherwise
        // Send Meme will be displayed first
        
        //var meme = memeModel(top: "TOPTEST", bottom: "BUTTOMTEST", image: UIImage(named: "space"), memedImage: UIImage(named: "space"))
        //appDelegate.memes.append(meme)

        // Point to the shared memes list
        memesTest = appDelegate.memes
        
        // If no sent images then jump to Meme Editor,
        // otherwise go to Sent Meme
        if (self.memesTest.count != 0) {
            // Jump to Sent Meme
            self.performSegueWithIdentifier("memeEditor2", sender: self)
            
        } else {
            // Jump to Meme Editor
            self.performSegueWithIdentifier("sentMemeSegue", sender: self)
        }
    }
    
}