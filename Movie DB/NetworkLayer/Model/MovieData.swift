//
//  MovieData.swift
//  NetworkLayer
//
//  Created by Dinoop Raj T on 03/07/18.
//  Copyright © 2018 Malcolm Kumwenda. All rights reserved.
//

import Foundation
import CoreData

class MovieData: NSManagedObject {
  @NSManaged var id: NSNumber?
  @NSManaged var rating: NSNumber?
  @NSManaged var backDrop: NSString?
  @NSManaged var overView: NSString?
  @NSManaged var posterPath: NSString?
  @NSManaged var releaseDate: NSString?
  @NSManaged var title: NSString?
  
}
