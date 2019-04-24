//
//  PhotoList.swift
//  iFlickr
//
//  Created by rigo on 23/04/2019.
//  Copyright © 2019 dev. All rights reserved.
//

import UIKit

class PhotoList: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var photoTableView: UITableView!
    @IBOutlet weak var searchField: UITextField!
    
    var photos: [Photo]?
    let cellId: String = "PhotoCellID"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - searching photos
    
    func fetchPhotos() {
        self.photos = nil
        self.photoTableView.reloadData()
        
        let searchString = (searchField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))!
        if searchString.count < 3 {
            return
        }
        
        DataProvider.shared().fetchPhotos(tags: searchString) { (result, error) in
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
    
    @IBAction func searchFieldTextChanged(_ searchField: UITextField) {
        self.fetchPhotos()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
        let cell: PhotoCell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as! PhotoCell
        
        let photo = self.photos?[indexPath.row]
        cell.setTitle((photo?.title)!)
        cell.setThumbnail(nil)
        cell.spinnerActivity(true)
        
        if let thumbnailPath = photo?.thumbnailPath {
            DataProvider.shared().fetchPhotoImage(photoURL: thumbnailPath, saveLocal: false) { (image, error) in
                if error == nil && image != nil {
                    DispatchQueue.main.async {
                        cell.setThumbnail(image!)
                    }
                }
                
                DispatchQueue.main.async {
                    cell.spinnerActivity(false)
                }
            }
        } else {
            cell.spinnerActivity(false)
        }
        
        return cell
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let selectedRow = self.photoTableView.indexPathForSelectedRow?.row
        if let photo = self.photos?[selectedRow!] {
            let curPhoto = segue.destination as! CurPhoto
            curPhoto.setPhoto(photo)
        }
    }
}
