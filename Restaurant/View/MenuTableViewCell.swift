//
//  MenuTableViewCell.swift
//  Restaurant
//
//  Created by Александр Макаров on 14.11.2018.
//  Copyright © 2018 Александр Макаров. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var menuImageItem: UIImageView!
    @IBOutlet weak var menuNameItem: UILabel!
    @IBOutlet weak var menuPriceItem: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
