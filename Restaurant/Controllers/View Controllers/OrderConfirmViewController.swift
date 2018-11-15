//
//  OrderConfirmViewController.swift
//  Restaurant
//
//  Created by Александр Макаров on 14.11.2018.
//  Copyright © 2018 Александр Макаров. All rights reserved.
//

import UIKit

class OrderConfirmViewController: UIViewController {
    
    @IBOutlet weak var timeDelivery: UILabel!
    
    var min: Int!

    override func viewDidLoad() {
        super.viewDidLoad()

        //let lastSymbol = min! == 1 ? "" : "ы"
        
        timeDelivery.text = "Спасибо за Ваш заказ! Ваш заказ будет готов в течении \(min!) минут."
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
