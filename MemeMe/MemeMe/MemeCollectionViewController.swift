//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Erwin Mazwardi on 25/04/2015.
//  Copyright (c) 2015 Socdesign. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController: UIViewController, UIApplicationDelegate{
    
    // Declare a variable which has a type of memeModel array.
    var memes = [memeModel]()
    
    // Back to Meme Editor
    @IBAction func startOver(sender: AnyObject) {
        var controller: UIViewController
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("MemeEditor") as! UIViewController
        
        self.presentViewController(controller, animated: true, completion: nil)
    }
    // Get the shared memes list    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Get the Application delegate
        self.tabBarController?.tabBar.hidden = false
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        // Point to the shared memes list
        memes = appDelegate.memes
        
    }
    //////////////////////////////////////////
    // Implement the collection view delegate
    // 1. collectionView(numberOfItemsInSection)
    // 2. collectionView(cellForItemAtIndexPath)
    // 3. collectionView(didSelectItemAtIndexPath)
    //////////////////////////////////////////
    // Count the number of items
    func collectionView(tableView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //println(self.memes.count)
        return self.memes.count
    }
    // Display it in the collection view cell
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionCell", forIndexPath: indexPath) as! MemeCollectionCell
        let memed = self.memes[indexPath.row]
        //cell.memeLabel.text = memed.top
        cell.memeLabel.hidden = true
        cell.memeImage?.image = memed.memedImage
        //let imageView = UIImageView(image: memed.memedImage)
        //cell.backgroundView = imageView
        return cell
    }
    // Display a selected row in another view
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath) {
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailController.memeDetail = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
}