//
//  ManagerVC.swift
//  iWeatherMini
//
//  Created by vitali on 15.07.2023.
//

import Foundation

protocol WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: NetworkManager ,weather: Any)
    func didFailWithError(error: Error)
}


class NetworkManager {
    
    var delegate: WeatherManagerDelegate?
    
    func callLoadDataUrl(lat: String, long: String){
        
        guard let url = URL(string:"https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(long)&appid=51aa166cb6dd4873c45fb97c4b645fef&units=metric") else {
            fatalError("Error answer url")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if error == nil, let data = data{
                do {
                    let data = try JSONDecoder().decode(CoordWeather.self, from: data)
                    self.delegate?.didUpdateWeather(self, weather: data)

                } catch {
                    self.delegate?.didFailWithError(error: error)
                }
            } else {
                print(error?.localizedDescription as Any)
            }
            
        }
        task.resume()
        
    }

    
    func callLoadDataUrl(city: String) {
        
        
        guard let url = URL(string:"https://api.openweathermap.org/data/2.5/weather?appid=51aa166cb6dd4873c45fb97c4b645fef&units=metric&q=\(city)") else {
            fatalError("Error answer url")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { [self] (data, response, error) in
            
            if error == nil, let data = data{
                
                do {
                    let data = try JSONDecoder().decode(WeatherObject.self, from: data)

                    DispatchQueue.main.async {

                        self.delegate?.didUpdateWeather(self, weather: data)
                        
                    }
                 
                } catch {
                    print(error)
                }
                } else {
                    print(error?.localizedDescription as Any)
                }

        }
        task.resume()
        
    }
    
    
    

    func createDate(_ date: Int?) -> String{
        guard let x = date else {return "error"}
         let timeInterval = TimeInterval(x)
         let myNSDate = Date(timeIntervalSince1970: timeInterval)

        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d HH:mm"
         return  formatter.string(from: myNSDate)
    }

    
}
