//
//  OrderTableViewController.swift
//  Restaurant
//
//  Created by Александр Макаров on 12.11.2018.
//  Copyright © 2018 Александр Макаров. All rights reserved.
//

import UIKit

class OrderTableViewController: UITableViewController, AddToOrderDelegate {
    
    let menuController = MenuController()
    var menuItems = [MenuItem]()
    var orderMin = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! OrderTableViewCell
        
        let menuItem = menuItems[indexPath.row]
        
        cell.orderNameItem.text = menuItem.name
        cell.orderPriceItem.text = String(format: "$%.2f", menuItem.price)
        
        menuController.fetchImage(url: menuItem.imageURL) { image in
            guard let image = image else { return }
            
            DispatchQueue.main.async {
                guard let currentIndexPath = self.tableView.indexPath(for: cell) else { return }
                guard currentIndexPath == indexPath else { return }
                cell.orderImageItem.image = image
            }
        }
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            menuItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            updateBadgeNumber()
        }
    }
    
    @IBAction func submitTapped(_ sender: UIBarButtonItem) {
        
        let orderTotal = menuItems.reduce(0.0) { (result, menuItems) -> Double in
            return result + menuItems.price
        }
        
        let formattedOrder = String(format: "$%2.f", orderTotal)
        
        let alert = UIAlertController(
            title: "Подтвердите заказ",
            message: "Вы собираетесь подтвердить свой заказ на сумму \(formattedOrder)",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Подтвердить", style: .default) { action in
            self.uploadOrder()
        })
        
        alert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func unwindToOrderTableViewController(segue: UIStoryboardSegue) {
        if segue.identifier == "DismissConfirm" {
            menuItems.removeAll()
            tableView.reloadData()
            
            updateBadgeNumber()
        }
    }
    
    func uploadOrder() {
        
        let menuIds = menuItems.map { $0.id }
        menuController.submitOrder(forMenuIDS: menuIds) { min in
            
            DispatchQueue.main.async {
                if let min = min {
                    self.orderMin = min
                    self.performSegue(withIdentifier: "ConfirmSegue", sender: nil)
                }
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ConfirmSegue" {
            let orderConfirmationViewController = segue.destination as! OrderConfirmViewController
            orderConfirmationViewController.min = orderMin
        }
    }
    
    func added(menuItem: MenuItem) {
        menuItems.append(menuItem)
        let count = menuItems.count
        let indexPath = IndexPath(row: count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        updateBadgeNumber()
    }
    
    func updateBadgeNumber() {
        
        let badgeValue = 0 < menuItems.count ? "\(menuItems.count)" : nil
        navigationController?.tabBarItem.badgeValue = badgeValue
    }
    
}
