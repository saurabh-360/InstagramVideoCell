//
//  ImageTableViewCell.swift
//  EditSoftDemo
//
//  Created by Saurabh Yadav on 02/02/17.
//  Copyright © 2017 Saurabh Yadav. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    @IBOutlet weak var imageVIew: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
