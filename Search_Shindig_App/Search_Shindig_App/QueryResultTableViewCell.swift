//
//  QueryResultTableViewCell.swift
//  Search_Shindig_App
//
//  Created by Kyle Stewart on 1/3/17.
//  Copyright © 2017 Kyle Stewart. All rights reserved.
//

import UIKit

class QueryResultTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var thumbnailTitle: UILabel!
    
    override func awakeFromNib() {

        

        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
