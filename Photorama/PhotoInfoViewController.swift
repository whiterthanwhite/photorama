//
//  PhotoInfoViewController.swift
//  Photorama
//
//  Created by Vlad Akhpanov on 28.06.2023.
//

import UIKit

class PhotoInfoViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    
    var photo: Photo! {
        didSet {
            navigationItem.title = photo.title
        }
    }
    var store: PhotoStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        store.fetchImage(for: photo) {
            (result) -> Void in
            
            switch result {
            case let .success(image):
                self.imageView.image = image
            case let .failure(error):
                print("Error while fetching image fo photo: \(error)")
                
            }
        }
    }
}
