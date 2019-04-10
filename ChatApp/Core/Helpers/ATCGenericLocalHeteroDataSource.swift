//
//  ATCGenericLocalHeteroDataSource.swift
//  RestaurantApp
//
//  Created by Florian Marcu on 5/19/18.
//  Copyright © 2018 iOS App Templates. All rights reserved.
//

import UIKit

class ATCGenericLocalHeteroDataSource: ATCGenericCollectionViewControllerDataSource {
    weak var delegate: ATCGenericCollectionViewControllerDataSourceDelegate?

    var items: [ATCGenericBaseModel]

    init(items: [ATCGenericBaseModel]) {
        print("set items: \(items.count)")
        self.items = items
    }

    func object(at index: Int) -> ATCGenericBaseModel? {
        if index < items.count {
            return items[index]
        }
        return nil
    }

    func numberOfObjects() -> Int {
        print("numberOfObjects: \(items.count)")
        return self.items.count
    }

    func loadFirst() {
        self.delegate?.genericCollectionViewControllerDataSource(self, didLoadFirst: items)
    }

    func loadBottom() {
//        self.delegate?.genericCollectionViewControllerDataSource(self, didLoadBottom: items)
    }

    func loadTop() {
    }
    
    func removeAll() {
        items.removeAll()
    }
    
    func addObject(newObject: ATCGenericBaseModel) {
//        items.removeLast()
//        items[0] = newObject
        self.items.append(newObject)
        print("addObject: \(items.count)")
    }
}
