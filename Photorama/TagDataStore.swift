//
//  TagDataStore.swift
//  Photorama
//
//  Created by Vlad Akhpanov on 28.06.2023.
//

import UIKit
import CoreData

class TagDataSource: NSObject, UITableViewDataSource {
    var tags: [Tag] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        let tag = tags[indexPath.row]
        
        var contentConf = UIListContentConfiguration.cell()
        contentConf.text = tag.name
        cell.contentConfiguration = contentConf
        
        return cell
    }
}
