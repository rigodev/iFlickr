//
//  DataProvider.swift
//  iFlickr
//
//  Created by rigo on 23/04/2019.
//  Copyright © 2019 dev. All rights reserved.
//

import Foundation

class DataProvider {
    private static let sharedDataProvider: DataProvider = {
        return DataProvider()
    }()
    
    private init() {}
    
    class func shared() -> DataProvider {
        return .sharedDataProvider
    }
    
    func fetchPhotos(tags: String, completionHandler: @escaping ([Photo]?, Error?) -> ()) {
        let session = URLSession.shared
        let requestURL = getFlickrSearchURL(tags: tags)
        
        let dataTask = session.dataTask(with: requestURL! as URL, completionHandler: { (resultData, response, error) in
            if error != nil {
                completionHandler(nil, error)
                return
            }
            
            completionHandler(self.mapPhotosFromJSON(resultData), nil)
        })
        
        dataTask.resume()
    }
    
    private func mapPhotosFromJSON(_ data: Data?) -> [Photo]? {
        var photos: [Photo]?
        
        do {
            let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
            let photosData = json["photos"] as! [String: Any]
            let photosArray = photosData["photo"] as! [[String: Any]]
            
            photos = []
            for element in photosArray {
                let photo = Photo(title: element[FlickrAPI.PhotoPaths.title] as? String, thumbnailPath: element[FlickrAPI.PhotoPaths.thumbnailPath] as? String, imagePath: element[FlickrAPI.PhotoPaths.imagePath] as? String)
                
                photos?.append(photo)
            }
            
            return photos
        } catch {
            print("JSON error: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func getFlickrSearchURL(tags: String) -> URL? {
        return URL(string: FlickrAPI.baseURL + FlickrAPI.searchMethod + "&api_key=\(FlickrAPI.apiKey)" + "&tags=\(tags)" + FlickrAPI.extras + FlickrAPI.format)
    }
}
