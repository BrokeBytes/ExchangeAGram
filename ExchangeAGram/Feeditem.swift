//
//  Feeditem.swift
//  ExchangeAGram
//
//  Created by James Dykstra on 1/7/15.
//  Copyright (c) 2015 Broke Bytes. All rights reserved.
//

import Foundation
import CoreData

@objc (Feeditem)
class Feeditem: NSManagedObject {

    @NSManaged var image: NSData
    @NSManaged var caption: String

}
