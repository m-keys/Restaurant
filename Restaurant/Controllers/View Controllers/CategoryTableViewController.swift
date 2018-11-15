//
//  CategoryTableViewController.swift
//  Restaurant
//
//  Created by Александр Макаров on 12.11.2018.
//  Copyright © 2018 Александр Макаров. All rights reserved.
//

import UIKit

class CategoryTableViewController: UITableViewController {
    
    let menuController = MenuController()
    var categories = [String]()
    var menuItems = [MenuItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        menuController.fetchCategories { categories in
        //            if let categories = categories {
        //                self.updateUI(with: categories)
        //            }
        //        }
        
        menuController.fetchMenuItems() { (menuItems) in
            if let menuItems = menuItems {
                for item in menuItems {
                    let category = item.category
                    
                    if !self.categories.contains(category) {
                        self.categories.append(category)
                    }
                }
                
                self.menuItems = menuItems
                self.updateUI(with: self.categories)
            }
        }
    }
    
    func updateUI(with categories: [String]) {
        self.categories = categories
        //print(#function, categories)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CategoryTableViewCell
        
        let category = categories[indexPath.row]
        
        cell.categoryName.text = category
        
        let menuItem = menuItems.first(where: { item in
            return item.category == category
        })
        
        menuController.fetchImage(url: menuItem!.imageURL) { image in
            guard let image = image else { return }
            
            DispatchQueue.main.async {
                guard let currentIndexPath = self.tableView.indexPath(for: cell) else { return }
                guard currentIndexPath == indexPath else { return }
                cell.categoryImage.image = image
            }
        }
        
        return cell
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Menu" {
            let menuTableViewController = segue.destination as! MenuTableViewController
            let index = tableView.indexPathForSelectedRow!.row
            menuTableViewController.category = categories[index]
        }
    }
    
}
