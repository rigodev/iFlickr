//
//  CurPhoto.swift
//  iFlickr
//
//  Created by rigo on 24/04/2019.
//  Copyright © 2019 dev. All rights reserved.
//

import UIKit

class CurPhoto: UIViewController {
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var imageSpinner: UIActivityIndicatorView!
    
    var photo: Photo?
    
    func setPhoto(_ photo: Photo?) {
        self.photo = photo
        self.loadPhoto()
    }
    
    private func loadPhoto() {
        if let loadedPhoto = self.photo {
            DataProvider.shared().fetchPhotoImage(photoURL: loadedPhoto.imagePath!, useLocalStorage: true) { (image, error) in
                if error == nil && image != nil {
                    DispatchQueue.main.async {
                        self.photoImageView.image = image
                        self.imageSpinner.stopAnimating()
                    }
                }
            }
        }
    }
}
