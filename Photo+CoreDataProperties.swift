//
//  Photo+CoreDataProperties.swift
//  Photorama
//
//  Created by Vlad Akhpanov on 28.06.2023.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var photoID: String?
    @NSManaged public var title: String?
    @NSManaged public var dateTaken: Date?
    @NSManaged public var remoteURL: NSURL?

}

extension Photo : Identifiable {

}
