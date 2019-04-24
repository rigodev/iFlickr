//
//  API.swift
//  iFlickr
//
//  Created by rigo on 23/04/2019.
//  Copyright © 2019 dev. All rights reserved.
//

struct FlickrAPI {
    static let apiKey: String = "5d948e182c58bb208f71132d9e186d47"
    static let baseURL: String = "https://api.flickr.com/services/rest/"
    static let searchMethod: String = "?method=flickr.photos.search"
    static let extras: String = "&extras=url_m,url_s&media=photos"
    static let format: String = "&format=json&nojsoncallback=1"
    
    struct PhotoPaths {
        static let photos: String = "photos"
        static let photo: String = "photo"
        static let title: String = "title"
        static let thumbnailPath: String = "url_m"
        static let imagePath: String = "url_s"
    }
}
