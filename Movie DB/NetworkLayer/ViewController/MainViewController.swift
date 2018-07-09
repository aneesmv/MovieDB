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
  var dataSource: [NSManagedObject] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.initializeFetchedResultsController()
    networkManager.getNewMovies(page: 1) { movies, error in
      if error == nil {
        DispatchQueue.main.async {
          self.dataSource.removeAll()
          guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
              return
          }
          
          // Object context.
          let managedContext = appDelegate.persistentContainer.viewContext
          
          // Entity.
          let entity = NSEntityDescription.entity(forEntityName: "MovieModel", in: managedContext)!
          
          for movie in movies!{
            let movieData =
              NSManagedObject(entity: entity, insertInto: managedContext)
            
            movieData.setValue(movie.title, forKey: "title")
            movieData.setValue(movie.id, forKey: "id")
            movieData.setValue(movie.rating, forKey: "rating")
            movieData.setValue(movie.overview, forKey: "overview")
            movieData.setValue(movie.backdrop, forKey: "backDrop")
            movieData.setValue(movie.posterPath, forKey: "posterPath")
            movieData.setValue(movie.releaseDate, forKey: "releaseDate")
            
            self.dataSource.append(movieData)
          }
          do {
            try managedContext.save()
          } catch {
            fatalError("Failure to save context: \(error)")
          }
          
          //self.dataSource = movies!
          if self.dataSource.count > 0 {
            DispatchQueue.main.async {
              self.mainTableView.reloadData()
            }
          }
        }
      }
    }
  }
  
  func initializeFetchedResultsController() {
    guard let appDelegate =
      UIApplication.shared.delegate as? AppDelegate else {
        return
    }
    let managedContext = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MovieModel")
    
    do {
      dataSource = try managedContext.fetch(fetchRequest)
      if dataSource.count > 0 {
        mainTableView.reloadData()
      }
    } catch let error as NSError{
      fatalError("Failed to initialize FetchedResultsController: \(error)")
    }
  }
  
  // Unwind Segue
  
  @IBAction func unwindFromMovieDetails(_ sender: UIStoryboardSegue) {
    
  }
}

class MainTableCell: UITableViewCell {
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var posterImageView: UIImageView!
  
  // "w92", "w154", "w185", "w342", "w500", "w780", or "original"
  let imageBaseURL = "http://image.tmdb.org/t/p/original/"
  
  func updateCellContenteWithModel(_ model: NSManagedObject) {
    
    titleLabel?.text = model.value(forKeyPath: "title") as? String
    
    if let posterPath = model.value(forKey: "posterPath") as? String {
      let posterImageURL = imageBaseURL + posterPath
      posterImageView.sd_setImage(with: URL(string: posterImageURL))
    }
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
    cell.selectionStyle = UITableViewCellSelectionStyle.none
    
    return cell
  }
  
  // Delegate Methods.
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 300.0
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let model: NSManagedObject = dataSource[indexPath.row]
    let movieDataModel = Movie(id: model.value(forKey: "id") as! Int,
                           posterPath: (model.value(forKey: "posterPath") as! NSString) as String,
                           backdrop: model.value(forKey: "backDrop") as! String,
                           title: model.value(forKey: "title") as! String,
                           releaseDate: model.value(forKey: "releaseDate") as! String,
                           rating: model.value(forKey: "rating") as! Double,
                           overview: model.value(forKey: "overview") as! String)
    let movieDetails =
      self.storyboard?.instantiateViewController(withIdentifier: "movieDetails") as! MovieDetailsViewController
    movieDetails.movieModel = movieDataModel
    self.present(movieDetails, animated: true, completion: nil)
  }
}
