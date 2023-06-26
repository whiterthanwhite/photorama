//
//  PhotosViewController.swift
//  Photorama
//
//  Created by Vlad Akhpanov on 26.06.2023.
//

import UIKit

class PhotosViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var store: PhotoStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        store.fetchingInterestingPhotos()
    }
}
