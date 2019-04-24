//
//  DataProvider.swift
//  iFlickr
//
//  Created by rigo on 23/04/2019.
//  Copyright © 2019 dev. All rights reserved.
//

import UIKit
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
    
    func fetchPhotoImage(photoURL: String, saveLocal: Bool, completionHandler: @escaping (UIImage?, Error?) -> ()) {
        if let photoName = URL(string: photoURL)?.lastPathComponent {
            if let fileData = self.loadFileFromLocalStorage(fileName: photoName) {
                completionHandler(UIImage(data: fileData), nil)
                return
            }
        }
        
        let session = URLSession.shared
        let requestURL = URL(string: photoURL)
        
        let dataTask = session.dataTask(with: requestURL! as URL, completionHandler: { (resultData, response, error) in
            if error != nil {
                completionHandler(nil, error)
                return
            }
            
            if saveLocal {
                self.saveFileToLocalStorage(fileData: resultData!, fileName: (URL(string: photoURL)?.lastPathComponent)!)
            }
            
            completionHandler(UIImage(data: resultData!), nil)
        })
        dataTask.resume()
    }
    
    func loadFileFromLocalStorage(fileName: String) -> Data? {
        do {
            let documentDirectoryURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fileURL = documentDirectoryURL.appendingPathComponent(fileName)
            let fileData = try Data(contentsOf: fileURL)
            return fileData
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func saveFileToLocalStorage(fileData: Data, fileName: String){
        do {
            let documentDirectoryURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fileURL = documentDirectoryURL.appendingPathComponent(fileName)
            try fileData.write(to: fileURL)
        } catch {
            print(error.localizedDescription)
            return
        }
    }
    
    private func mapPhotosFromJSON(_ data: Data?) -> [Photo]? {
        var photos: [Photo]?
        
        do {
            let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
            let photosData = json[FlickrAPI.PhotoPaths.photos] as! [String: Any]
            let photosArray = photosData[FlickrAPI.PhotoPaths.photo] as! [[String: Any]]
            
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
