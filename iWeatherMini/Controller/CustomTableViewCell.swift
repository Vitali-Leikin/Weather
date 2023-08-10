

import UIKit

class CustomTableViewCell: UITableViewCell {
    
// MARK: -
    
    @IBOutlet weak var dayDateCellLabel: UILabel!
    @IBOutlet weak var dayImageViewCell: UIImageView!
    @IBOutlet weak var dayTempCellLabel: UILabel!
    @IBOutlet weak var nightDateCellLabel: UILabel!
    @IBOutlet weak var nightImageViewCell: UIImageView!
    @IBOutlet weak var nightTempCellLabel: UILabel!
    
    
    @IBOutlet weak var section: UIVisualEffectView!
    
    @IBOutlet weak var cellView: UIView!
   
    
// MARK: func
    func configureCell(with object: List ){
        let dayUrl = URL(string: "https://openweathermap.org/img/wn/\(object.weather?.first?.icon ?? "")@2x.png")
        
        self.nightTempCellLabel.text = " \(String(format: "%.1f",object.main?.temp ?? 0.0 )) °C"
        self.nightDateCellLabel.text = " \(getDayForDate(object.dt))"
        
        if let safeUrl = dayUrl {
            
            let queue = DispatchQueue.global(qos: .utility)
            queue.async{
                
                if let data = try? Data(contentsOf: safeUrl){
                    DispatchQueue.main.async {
                        if let  image = UIImage(data: data){
                            self.nightImageViewCell.image = image
                        }
                    }
                }
            }
        }
        
        
        self.section.rounded(radius: K.uiSize.cornerRadius.rawValue)
    }
    
    
    func getDayForDate(_ date: Int?) -> String {
        guard let x = date else {return "error"}
        let timeInterval = TimeInterval(x)
        let myNSDate = Date(timeIntervalSince1970: timeInterval)
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d HH:mm"
        return  formatter.string(from: myNSDate)
    }
    

  private func loadImageUrlNight(_ str: String) -> URL{
        switch str {
        case "01d":
            let url = URL(string: "https://openweathermap.org/img/wn/01n@2x.png")
            return url!
        case "02d":
            let url = URL(string: "https://openweathermap.org/img/wn/02n@2x.png")
            return url!
        case "03d":
            let url = URL(string: "https://openweathermap.org/img/wn/03n@2x.png")
            return url!
        case "04d":
            let url = URL(string: "https://openweathermap.org/img/wn/04n@2x.png")
            return url!
        case "09d":
            let url = URL(string: "https://openweathermap.org/img/wn/09n@2x.png")
            return url!
        case "10d":
            let url = URL(string: "https://openweathermap.org/img/wn/10n@2x.png")
            return url!
        case "11d":
            let url = URL(string: "https://openweathermap.org/img/wn/11n@2x.png")
            return url!
        case "13d":
            let url = URL(string: "https://openweathermap.org/img/wn/13n@2x.png")
            return url!
        case "50d":
            let url = URL(string: "https://openweathermap.org/img/wn/50n@2x.png")
            return url!
            
        default:
            let url = URL(string: "https://openweathermap.org/img/wn/10n@.png")
            return url!
        }
    }
}

// MARK: UIView cornerRadius
extension UIView {
    func rounded(radius: CGFloat) {
        self.layer.cornerRadius = radius
    }

}

