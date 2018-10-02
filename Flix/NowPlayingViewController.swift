//
//  NowPlayingViewController.swift
//  Flix
//
//  Created by Hanyu Huang on 10/1/18.
//  Copyright © 2018 Hanyu Huang. All rights reserved.
//

import UIKit
import AlamofireImage

class NowPlayingViewController: UIViewController ,UITableViewDataSource {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    var movies:[[String:Any]]=[]
    var refreshControl:UIRefreshControl!
    
    
    
    override func viewDidLoad() {
        activityIndicator.startAnimating()
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(NowPlayingViewController.didPullToRefresh(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        tableView.rowHeight = 200
        tableView.dataSource = self
        
        
        fetchMovies()
        
    }
    
    @objc func didPullToRefresh(_ refreshControl:UIRefreshControl){
        //self.tableView.isHidden=true
        
        fetchMovies()
    }
    
    func fetchMovies(){
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        let seesion = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        //this will run when the network request returns
        
        let task = seesion.dataTask(with: request) { (data, response, error) in
           
            sleep(1)
            if let error = error{
                //if error = nil, will skip
                print(error.localizedDescription)
            }else if let data = data{
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as![String:Any]
                //print(dataDictionary)
                let movies = dataDictionary["results"] as![[String:Any]]
            
                self.movies=movies
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                self.activityIndicator.stopAnimating()
                //self.tableView.isHidden=false
            }
        }
        task.resume()//will start task from suspended (睡觉) state
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
       
                let movie = movies[indexPath.row]
                let title = movie["title"]as! String
                let overview = movie["overview"]as! String
                let posterPathString = movie["poster_path"] as! String
                let baseURLString = "https://image.tmdb.org/t/p/w500"
                let posterURL = URL(string: baseURLString + posterPathString)!
        
                cell.titleLabel.text = title
                cell.overviewLabel.text = overview
                cell.posterImageView.af_setImage(withURL: posterURL)
        
        
        return cell
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}
