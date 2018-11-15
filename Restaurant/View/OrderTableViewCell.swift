//
//  OrderTableViewCell.swift
//  Restaurant
//
//  Created by Александр Макаров on 14.11.2018.
//  Copyright © 2018 Александр Макаров. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    @IBOutlet weak var orderImageItem: UIImageView!
    @IBOutlet weak var orderNameItem: UILabel!
    @IBOutlet weak var orderPriceItem: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
