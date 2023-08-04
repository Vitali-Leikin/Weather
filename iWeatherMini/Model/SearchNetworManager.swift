

import Foundation
import UIKit



class SearchNetworManager: NSObject {
    
    // MARK: - let
    let backgroundImageView: Bindable<UIImage> = Bindable(UIImage())
    let currentCityLabel: Bindable<String> = Bindable("")
    let currentDescriptionWeatherLabel: Bindable<String> = Bindable("")
    let tempBasicLabel: Bindable<String> = Bindable("")
    let currentImageView: Bindable<UIImage> = Bindable(UIImage())
    let minTemp: Bindable<String> = Bindable("")
    let maxTemp: Bindable<String> = Bindable("")
    
    // MARK: - var
    
    var weatherLoadSecond:WeatherObject?
    
    // MARK: - func
    
    func callLoadDataUrl(city: String){
        if let url = URL(string:"https://api.openweathermap.org/data/2.5/weather?appid=51aa166cb6dd4873c45fb97c4b645fef&units=metric&q=\(city)"){
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: request) { [self] (data, response, error) in
                if error == nil, let data = data{
                    do {
                        let data = try JSONDecoder().decode(WeatherObject.self, from: data)
                        print(data)
                        self.weatherLoadSecond = data
                        print(weatherLoadSecond?.name as Any)
                        
                        DispatchQueue.main.async {
                            self.updateUI()
                        }
                        
                    } catch {
                        print(error)
                    }
                } else {
                    print(error?.localizedDescription as Any)
                }
            }
            task.resume()
        }else{
            self.currentCityLabel.value = "Неправельно указан город"
        }
    }
    

   private func updateUI(){
        DispatchQueue.main.async {
            if self.weatherLoadSecond?.name == nil {
                self.currentCityLabel.value = "Неправельно указан город"
                return
            }else{
                self.tempBasicLabel.value = "\(String(format: "%.1f",(self.weatherLoadSecond?.main?.temp ?? 0.0))) °C"
                self.currentDescriptionWeatherLabel.value = (self.weatherLoadSecond?.weather?.first?.description) ?? ""
                self.minTemp.value = "min temp: \(String(format: "%.1f",(self.weatherLoadSecond?.main?.temp_min ?? 0.0))) °C"
                self.maxTemp.value = "max temp: \(String(format: "%.1f",(self.weatherLoadSecond?.main?.temp_max ?? 0.0))) °C"
                self.currentCityLabel.value = self.weatherLoadSecond?.name ?? " "
                self.backgroundImageView.value = UIImage(named: self.weatherLoadSecond?.weather?.first?.icon ?? "01d") ?? UIImage()
                guard let url = URL(string:"https://openweathermap.org/img/wn/\(self.weatherLoadSecond?.weather?.first?.icon ?? "")@2x.png") else {fatalError("")}
                
                let queue = DispatchQueue.global(qos: .utility)
                queue.async{
                    
                    if let data = try? Data(contentsOf: url){
                        DispatchQueue.main.async {
                            if let  image = UIImage(data: data){
                                self.currentImageView.value = image
                                
                            }
                        }
                    }
                }
                
            }
            
        }
        
    }
    
}
