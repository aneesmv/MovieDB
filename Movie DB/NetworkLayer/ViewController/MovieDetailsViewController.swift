//
//  MovieDetailsViewController.swift
//  NetworkLayer
//
//  Created by Dinoop Raj T on 08/07/18.
//  Copyright © 2018 Malcolm Kumwenda. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
  
  var movieModel: Movie?
  // Outlets
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var backDropImage: UIImageView!

  @IBOutlet weak var ratingLabel: UILabel!
  
  @IBOutlet weak var releaseDateLabel: UILabel!
  
  @IBOutlet weak var overviewTextView: UITextView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.loadData()
  }
  
  func loadData() {
    let imageBaseURL = "http://image.tmdb.org/t/p/original/"
    titleLabel.text = movieModel?.title
    if let ratingValue: Double = movieModel?.rating {
      let rating = String(ratingValue)
      ratingLabel.text = rating
    }
    releaseDateLabel.text = movieModel?.releaseDate
    overviewTextView.text = movieModel?.overview
    let imageUrl = imageBaseURL + (movieModel?.backdrop)!
    backDropImage.sd_setImage(with: URL(string: imageUrl))
  }
  
}
