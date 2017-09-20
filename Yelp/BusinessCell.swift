//
//  BusinessCell.swift
//  Yelp
//
//  Created by Rajat Bhargava on 9/18/17.
//  Copyright © 2017 RNR. All rights reserved.
//

import UIKit
import AFNetworking

class BusinessCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var thumbImage: UIImageView!
    @IBOutlet weak var reviewImage: UIImageView!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var business: Business! {
        didSet{
            nameLabel.text = business.name
            categoryLabel.text = business.categories
            addressLabel.text = business.address
            reviewLabel.text = "\(business.reviewCount!) Reviews"
            distanceLabel.text = business.distance
            if let url = business.imageURL {
                thumbImage.setImageWith(url)
            }
            
            reviewImage.setImageWith(business.ratingImageURL!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        thumbImage.layer.cornerRadius = 5
        thumbImage.clipsToBounds = true
        
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
