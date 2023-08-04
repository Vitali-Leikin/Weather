
import Foundation

class WeatherObject: Codable{
    
    var main: WeatherObjectMain?
    var id: Int?
    var name: String?
    var weather:[WeatherObjectIcon]?
    
}

class WeatherObjectMain: Codable{
    var temp: Double?
    var temp_min: Double?
    var temp_max: Double?
    
}

class WeatherObjectIcon: Codable {
    var id: Int?
    var main: String?
    var description: String?
    var icon: String?
}
