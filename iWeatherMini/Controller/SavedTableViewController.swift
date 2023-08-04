//
//  ThirdTableViewController.swift
//  iWeatherMini
//
//  Created by vitali on 15.07.2023.
//

import UIKit

class SavedTableViewController: UITableViewController {
    
    var modelArray: [WeatherObject] = []
    var networManager = NetworkManager()
    
    var city: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
     //   weatherManager.delegate = self
        networManager.delegate = self
        loadCity()
        tableView.separatorColor = .clear

        tableView.register(UINib(nibName: K.searchCell.rawValue, bundle: nil), forCellReuseIdentifier: K.tabCell.rawValue)
    }

    func loadCity() {

        let array = mSave.shared.defaults.stringArray(forKey: mSave.shared.keyCity)
        if let safeArray = array{
            let tempArr = Array(Set(safeArray)).sorted()
            for item in tempArr{
                networManager.callLoadDataUrl(city: item)
            }
         //   mSave.shared.defaults.removeObject(forKey: mSave.shared.keyCity)
          //  mSave.shared.defaults.set(tempArr, forKey: mSave.shared.keyCity)
        }
      //  tableView.reloadData()
    }


    

    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.tabCell.rawValue, for: indexPath) as! ThirdTableViewCell
        
        let temperature = "\(String(format: "%.1f",(modelArray[indexPath.row].main?.temp ?? 0.0)))"
        let describe = (modelArray[indexPath.row].weather?.first?.description) ?? ""
        let cityName = modelArray[indexPath.row].name ?? ""
        guard let url = URL(string:"https://openweathermap.org/img/wn/\(modelArray[indexPath.row].weather?.first?.icon ?? "")@2x.png") else {fatalError("")}

        
            let queue = DispatchQueue.global(qos: .utility)
            queue.async{
                
                if let data = try? Data(contentsOf: url){
                    DispatchQueue.main.async {
                        if let  image = UIImage(data: data){
                            cell.setCell(img: image, temp: temperature, describe: describe, city: cityName)
                        }
                    }
                }
            }
  

        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
       
       let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in

           tableView.deleteRows(at: [indexPath], with: .automatic)
       }
        deleteAction.image = UIImage(named: "delete-icon")
       let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
        modelArray.remove(at: indexPath.row)
        mSave.shared.removeCity(indexPath.row)
       return swipeActions
   }
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}





extension SavedTableViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: NetworkManager, weather: Any) {
        print(weather)
        guard let safeWeather = weather as? WeatherObject else{fatalError("")}
        modelArray.append(safeWeather)
        print(modelArray.count)
        tableView.reloadData()
    }

    func didFailWithError(error: Error) {
        print("error Parse URL")
    }


}

