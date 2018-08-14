//
//  PetCell.swift
//  TripleByteApp
//
//  Created by Pragun Sharma on 8/13/18.
//  Copyright © 2018 Pragun Sharma. All rights reserved.
//

import UIKit

class PetCell: UITableViewCell {

    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var descp: UILabel!
    @IBOutlet weak var myimageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(petDataObj: DataPetModel) {
        
        if let url = URL(string: petDataObj.imageURL) {
            self.downloadImage(withImageURL: url, downloadCompleted: { (status, error, _image) in
                if (error != nil) {
                    //present alert
                }
                else {
                    if let _img = _image {
                        DispatchQueue.main.async {
                            self.name.text = petDataObj.title
                            self.descp.text = petDataObj.description
                            self.myimageView.image = _img
                            self.timeStamp.text = petDataObj.timestamp
                        }
                    }
                }
            })
        }

    }
    
    func downloadImage(withImageURL url: URL, downloadCompleted: @escaping (_ status: Bool, _ error: Error?, _ image: UIImage?)->()) {
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if (error != nil) {
                print("HI-II: \(error.debugDescription)")
                downloadCompleted(false, error, nil)
            } else {
                if let data = data {
                    downloadCompleted(true, nil, UIImage(data: data))
                }
            }
            }.resume()
    }
    
}
