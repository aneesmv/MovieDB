//
//  ViewController.swift
//  NetworkLayer
//
//  Created by Malcolm Kumwenda on 2018/03/05.
//  Copyright © 2018 Malcolm Kumwenda. All rights reserved.
//

import UIKit
import CoreData
import SDWebImage

class MainViewController: UIViewController {
  
  @IBOutlet weak var mainTableView: UITableView!
  
  var networkManager: NetworkManager!
  var fetchedResultController: NSFetchedResultsController <NSManagedObject>!
  var dataController: DataController!
  var dataSource: [Movie] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    dataController = DataController(){
      //self.initializeFetchedResultsController()
    }
    networkManager.getNewMovies(page: 1) { movies, error in
      if error == nil {
        self.dataSource = movies!
        if self.dataSource.count > 0 {
          DispatchQueue.main.async {
            self.mainTableView.reloadData()
          }
        }
      }
    }
  }
  
  func initializeFetchedResultsController() {
    let moc = dataController.managedObjectContext
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieData")
    let idSort = NSSortDescriptor(key: "id", ascending: true)
    request.sortDescriptors = [idSort]
    
    fetchedResultController = NSFetchedResultsController(fetchRequest: request,
                                                         managedObjectContext: moc,
                                                         sectionNameKeyPath: nil,
                                                         cacheName: nil) as! NSFetchedResultsController<NSManagedObject>
    fetchedResultController.delegate = self as? NSFetchedResultsControllerDelegate
    
    do {
      try fetchedResultController.performFetch()
    } catch {
      fatalError("Failed to initialize FetchedResultsController: \(error)")
    }
  }
}

class MainTableCell: UITableViewCell {
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var posterImageView: UIImageView!
  let productionURL = "https://api.themoviedb.org/3/movie"
  
  func updateCellContenteWithModel(_ model: Movie) {
    titleLabel.text = model.title
    let imageURL = productionURL + model.backdrop
    posterImageView.sd_setImage(with: URL(string: imageURL))
  }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
  
  // Data Source Methods
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataSource.count > 0 ? dataSource.count : 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: MainTableCell =
      self.mainTableView .dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MainTableCell
    cell.updateCellContenteWithModel(dataSource[indexPath.row])
    
    return cell
  }
  
  // Delegate Methods.
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 200.0
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
  }
}
