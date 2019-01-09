//
//  FeedTableViewCell.swift
//  Clowder iOS Test
//
//  Created by Oraz Atakishiyev on 1/9/19.
//  Copyright © 2019 Oraz Atakishiyev. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    static let nibName = "FeedTableViewCell"
    
    @IBOutlet weak var titleLab: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
