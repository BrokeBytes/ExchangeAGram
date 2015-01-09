//
//  FeedViewController.swift
//  ExchangeAGram
//
//  Created by James Dykstra on 1/7/15.
//  Copyright (c) 2015 Broke Bytes. All rights reserved.
//

import UIKit
import MobileCoreServices
import CoreData

class FeedViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var feedArray: [AnyObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let request = NSFetchRequest(entityName: "Feeditem")
        let appDelegate:AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        let context:NSManagedObjectContext = appDelegate.managedObjectContext!
        
        feedArray = context.executeFetchRequest(request, error: nil)!
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func snapBarButtonTapped(sender: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            var cameraController = UIImagePickerController()
            cameraController.delegate = self
            cameraController.sourceType = UIImagePickerControllerSourceType.Camera
            let mediaTypes:[AnyObject] = [kUTTypeImage]
            cameraController.mediaTypes = mediaTypes
            cameraController.allowsEditing = false
            
            self.presentViewController(cameraController, animated: true, completion: nil)
            
        }//if
        else if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            
       
        var photoLibController = UIImagePickerController()
        photoLibController.delegate = self
        photoLibController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        let mediaTypes:[AnyObject] = [kUTTypeImage]
        photoLibController.mediaTypes = mediaTypes
        photoLibController.allowsEditing = false
            
            self.presentViewController(photoLibController, animated: true, completion: nil)
            
        }//else if
            
        else {
            var alertController = UIAlertController(title: "Alert!", message: "You Suck", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        } //else
        
    }//func
    
    //UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell:FeedCell = collectionView.dequeueReusableCellWithReuseIdentifier("myCell", forIndexPath: indexPath) as FeedCell
        
        let thisItem = feedArray[indexPath.row] as Feeditem
        
        cell.imageView.image = UIImage(data: thisItem.image)
        cell.captionLabel.text = thisItem.caption
        
        
        return cell
    }
    
    //UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as UIImage
        let imageData = UIImageJPEGRepresentation(image, 1.0)
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
        let entityDescription = NSEntityDescription.entityForName("Feeditem", inManagedObjectContext: managedObjectContext!)
        
        let myFeedItem = Feeditem(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext!)
        
        myFeedItem.image = imageData
        myFeedItem.caption = "Test Caption"
        
        (UIApplication.sharedApplication().delegate as AppDelegate).saveContext()
        
        feedArray.append(myFeedItem)
        
        
            
        self.dismissViewControllerAnimated(true, completion: nil)
        
        self.collectionView.reloadData()
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let thisItem = feedArray[indexPath.row] as Feeditem
        var filterVC = FilterViewController()
        filterVC.thisFeedItem = thisItem
        self.navigationController!.pushViewController(filterVC, animated: false)
    }
    

}
