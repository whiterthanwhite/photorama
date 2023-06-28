//
//  FlickrAPI.swift
//  Photorama
//
//  Created by Vlad Akhpanov on 26.06.2023.
//

import Foundation
import CoreData

enum FlickrError: Error {
    case invalidJSONData
}

enum Method: String {
    case interestinPhotos = "flickr.interestingness.getList"
}

struct FlickrAPI {
    private static let baseURLString = "https://www.flickr.com/services/rest"
    private static let apiKey = flickrAPIKey // insert api key
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    static var interestingPhotosURL: URL {
        return flickrURL(method: .interestinPhotos, parameters: ["extras": "url_h,date_taken"])
    }
    
    private static func flickrURL(method: Method, parameters: [String:String]?) -> URL {
        var components = URLComponents(string: baseURLString)!
        
        var queryItems = [URLQueryItem]()
        
        let baseParams = [
            "method": method.rawValue,
            "format": "json",
            "nojsoncallback": "1",
            "api_key": apiKey
        ]
        
        for (key, value) in baseParams {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        if let additionalParams = parameters {
            for (key, value) in additionalParams {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        
        components.queryItems = queryItems
        
        return components.url!
    }
    
    static func photos(fromJson data: Data, into context: NSManagedObjectContext) -> PhotoResult {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            
            guard
                let jsonDictionary = jsonObject as? [AnyHashable: Any],
                let photos = jsonDictionary["photos"] as? [String:Any],
                let photosArray = photos["photo"] as? [[String:Any]]
            else {
                return .failure(FlickrError.invalidJSONData)
            }
            
            var finalPhotos = [Photo]()
            for photoJSON in photosArray {
                if let photo = photo(fromJSON: photoJSON, into: context) {
                    finalPhotos.append(photo)
                }
            }
            
            if finalPhotos.isEmpty && !photosArray.isEmpty {
                return .failure(FlickrError.invalidJSONData)
            }
            
            return .success(finalPhotos)
        } catch let error {
            return .failure(error)
        }
    }
    
    private static func photo(fromJSON json: [String:Any], into context: NSManagedObjectContext) -> Photo? {
        guard
            let photoID = json["id"] as? String,
            let title = json["title"] as? String,
            let dateString = json["datetaken"] as? String,
            let photoURLString = json["url_h"] as? String,
            let url = URL(string: photoURLString),
            let dateTaken = dateFormatter.date(from: dateString)
        else {
            return nil
        }
        
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        let predicate = NSPredicate(format: "\(#keyPath(Photo.photoID)) == \(photoID)")
        fetchRequest.predicate = predicate
        
        var fetchPhotos: [Photo]?
        context.performAndWait {
            fetchPhotos = try? fetchRequest.execute()
        }
        if let existingPhoto = fetchPhotos?.first {
            return existingPhoto
        }
        
        var photo: Photo!
        context.performAndWait {
            photo = Photo(context: context)
            photo.title = title
            photo.photoID = photoID
            photo.remoteURL = url as NSURL
            photo.dateTaken = dateTaken
        }
        
        return photo
    }
}
