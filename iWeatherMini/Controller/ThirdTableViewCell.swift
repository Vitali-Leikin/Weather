//
//  ThirdTableViewCell.swift
//  iWeatherMini
//
//  Created by vitali on 15.07.2023.
//

import UIKit

class ThirdTableViewCell: UITableViewCell {
    
    @IBOutlet weak private var imageLabel: UIImageView!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var describeLabel: UILabel!
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var nameCity: UILabel!
    
    func setCell(img: UIImage, temp: String, describe:String, city: String){
        
        
        describeLabel.text = describe
        temperatureLabel.text = temp + "°C"
        nameCity.text = city
        imageLabel.image = img
        backGroundView.setupShadow()
        backGroundView.backgroundColor = .lightGray
    }
}

extension UIView {

     func setupShadow() {
        self.layer.cornerRadius = 8
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.3
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 8, height: 8)).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}
