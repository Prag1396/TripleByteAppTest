//
//  ViewController.swift
//  TripleByteApp
//
//  Created by Pragun Sharma on 8/13/18.
//  Copyright © 2018 Pragun Sharma. All rights reserved.
//

import UIKit
import Alamofire

class MainVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    @IBOutlet weak var mytableView: UITableView!
    
    var indicator = UIActivityIndicatorView()
    let loadingView: UIView = UIView()
    
    var petArray = [DataPetModel]()
    
    var imageurl: URL? = nil
    var image: UIImage? = nil
    
    
    //Pagination
    var totalEnteries: Int = 0
    var limit: Int = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mytableView.delegate = self
        mytableView.dataSource = self
        
        DispatchQueue.global(qos: .userInteractive).async {
            self.downloadPetDetails(url: BASE_URL) { (dict) in
                    var index = 0
                    while index < self.limit {
                        
                        let petData = DataPetModel(petdict: dict[index])
                        self.petArray.append(petData)
                        index = index + 1
                        
                    }
                    DispatchQueue.main.async {
                    self.mytableView.reloadData()
                    }
            }
        }

    }

    func setUpActivityIndicator() {
        
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = self.view.center
        loadingView.backgroundColor = UIColor(red: 68/255, green: 68/255, blue: 68/255, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        indicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        indicator.bounds.origin.x = self.view.bounds.origin.x - 30
        indicator.bounds.origin.y = self.view.bounds.origin.y - 30

        loadingView.addSubview(indicator)
        view.addSubview(loadingView)
        
    }

    
    //API Call to download Pet Details
    func downloadPetDetails(url: String, downloadCompleted: @escaping(_ dict: [Dictionary<String, AnyObject>]) -> ()) {
        
        guard let currentURL = URL(string: url) else { return }
        Alamofire.request(currentURL).responseJSON { (response) in
            
            
            guard let dict = response.value as? [Dictionary<String, AnyObject>] else {return}
            self.totalEnteries = dict.count
            

            downloadCompleted(dict)
        }
    }
    
    @objc func loadtable() {
        DispatchQueue.main.async {
            self.mytableView.reloadData()
            self.indicator.stopAnimating()
            self.loadingView.removeFromSuperview()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.petArray.count - 1 {
            if self.petArray.count < self.totalEnteries {
                //present activity indicator
                self.setUpActivityIndicator()
                self.indicator.startAnimating()
                self.downloadPetDetails(url: BASE_URL) { (dict) in
                    
                    var index = self.petArray.count
                    if (self.totalEnteries - self.petArray.count >= 5) {
                        
                        self.limit = index + 5
                    } else {
                        self.limit = index + (self.totalEnteries - self.petArray.count)
                    }
                    
                    while index < self.limit {
                        
                        let petData = DataPetModel(petdict: dict[index])
                        self.petArray.append(petData)
                        index = index + 1
                        
                    }
                    self.perform(#selector(self.loadtable), with: nil, afterDelay: 1.0)
                    
                }
                
            }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.petArray.count > 0 {
            return self.petArray.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "petCell", for: indexPath) as? PetCell {
            if self.petArray.count > 0 {
                let petObj = self.petArray[indexPath.row]
                
                cell.configureCell(petDataObj: petObj)
                
            }
            
            return cell
        } else {
            return PetCell()
        }
    }
}

