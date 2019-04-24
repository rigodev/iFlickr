//
//  PhotoList.swift
//  iFlickr
//
//  Created by rigo on 23/04/2019.
//  Copyright © 2019 dev. All rights reserved.
//

import UIKit

class PhotoList: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var photoTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var photos: [Photo]?
    
    // MARK: - searching photos
    
    @IBAction func fetchPhotos(_ sender: Any) {
        self.photos = nil
        self.photoTableView.reloadData()
        
        DataProvider.shared().fetchPhotos(tags: "flowers") { (result, error) in
            if error != nil {
                return
            }
            
            if let photos = result {
                self.photos = photos
                
                DispatchQueue.main.async {
                    self.photoTableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let rowCount = self.photos?.count {
            return rowCount
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        cell.detailTextLabel?.text = self.photos?[indexPath.row].title
        
        return cell
    }
    
}
