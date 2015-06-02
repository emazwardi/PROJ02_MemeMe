//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Erwin Mazwardi on 25/04/2015.
//  Copyright (c) 2015 Socdesign. All rights reserved.
//


import UIKit

class MemeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIApplicationDelegate {
    
    // Declare a variable which has a type of memeModel array.
    var memes = [memeModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Get the shared memes list
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Get the Application delegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        // Point to the shared memes list
        memes = appDelegate.memes
    }
    // Back to Meme Editor
    @IBAction func startOver(sender: AnyObject) {
        var controller: UIViewController
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("MemeEditor") as! UIViewController
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    //override func viewDidAppear(animated: Bool) {
    //     self.dismissViewControllerAnimated(true, completion: nil)
    //}
  
    //////////////////////////////////////////
    // Implement the table view delegate
    // 1. tableView(numberOfRowsInSection)
    // 2. tableView(cellForRowAtIndexPath)
    // 3. tableView(didSelectRowAtIndexPath)
    //////////////////////////////////////////
    // Count the row numbers
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    // Create a cell view
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell") as! UITableViewCell
        let memed = self.memes[indexPath.row]
        cell.textLabel?.text = memed.top
        cell.imageView?.image = memed.memedImage
        return cell
    }
    // Display a selected row in another view
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailController.memeDetail = self.memes[indexPath.row]
        detailController.table_row = indexPath.row
        self.navigationController!.pushViewController(detailController, animated: true)
    }

}