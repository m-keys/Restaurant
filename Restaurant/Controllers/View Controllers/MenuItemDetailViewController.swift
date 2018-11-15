//
//  MenuItemDetailViewController.swift
//  Restaurant
//
//  Created by Александр Макаров on 12.11.2018.
//  Copyright © 2018 Александр Макаров. All rights reserved.
//

import UIKit

class MenuItemDetailViewController: UIViewController {
    
    let menuController = MenuController()
    var menuItem: MenuItem!
    var delegate: AddToOrderDelegate?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addToOrderButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = menuItem.name
        priceLabel.text = String(format: "$%.2f", menuItem.price)
        descriptionLabel.text = menuItem.description
        
        updateUI()
        setupDelegate()
    }
    
    func updateUI() {
        menuController.fetchImage(url: menuItem.imageURL) { image in
            guard let image = image else { return }
            
            DispatchQueue.main.sync {
                self.imageView.image = image
            }
        }
    }
    
    func setupDelegate() {
        if let navigationController = tabBarController?.viewControllers?.last as?UINavigationController,
            let orderTableViewController = navigationController.viewControllers.first as? OrderTableViewController {
            delegate = orderTableViewController
        }
    }
    
    @IBAction func addToOrderButtonTapped(_ sender: UIButton) {
        
        delegate?.added(menuItem: menuItem)
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
