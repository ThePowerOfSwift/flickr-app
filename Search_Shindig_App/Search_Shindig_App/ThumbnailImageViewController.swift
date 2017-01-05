//
//  ThumbnailImageViewController.swift
//  Search_Shindig_App
//
//  Created by Kyle Stewart on 1/3/17.
//  Copyright © 2017 Kyle Stewart. All rights reserved.
//

import UIKit

class ThumbnailImageViewController: UIViewController {
    
    var selectedThumbnailTitle = ""
    var selectedThumbnailImage = UIImageView()

    @IBOutlet weak var thumbmailTitle: UILabel!
    @IBOutlet weak var thumbnailImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        thumbnailImage.image = selectedThumbnailImage.image
        thumbmailTitle.text = selectedThumbnailTitle

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func backButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }

}
