//
//  PhotoCell.swift
//  iFlickr
//
//  Created by rigo on 24/04/2019.
//  Copyright © 2019 dev. All rights reserved.
//

import UIKit

class PhotoCell: UITableViewCell {
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    let imageSpinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
        spinner.color = UIColor(red: 0, green: 175.9/255.0, blue: 1.0, alpha: 1.0)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupControls()
    }
    
    private func setupControls() {
        // thumbnail image
        self.thumbnailImageView.layer.cornerRadius = 10
        self.thumbnailImageView.clipsToBounds = true
        
        // image spinner
        self.addSubview(imageSpinner)
        self.imageSpinner.centerXAnchor.constraint(equalTo: self.thumbnailImageView.centerXAnchor).isActive = true
        self.imageSpinner.centerYAnchor.constraint(equalTo: self.thumbnailImageView.centerYAnchor).isActive = true
        self.imageSpinner.widthAnchor.constraint(equalToConstant: 50.0).isActive = true
        self.imageSpinner.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
    }
    
    func setTitle(_ title: String) {
        self.titleTextView.text = title
    }
    
    func setThumbnail(_ image: UIImage?) {
        self.thumbnailImageView.image = image
    }
    
    func spinnerActivity(_ isActive: Bool) {
        if isActive {
            self.imageSpinner.startAnimating()
        } else {
            self.imageSpinner.stopAnimating()
        }
    }
}
