
import UIKit
import CoreLocation


class ViewController: UIViewController {
    // MARK: - IBOutlet
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tableView: UIView!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var currentTempBasicLabel: UILabel!
    @IBOutlet weak var currentImageView: UIImageView!
    @IBOutlet weak var currentDescriptionWeatherLabel: UILabel!
    @IBOutlet weak var bluerView: UIVisualEffectView!
    @IBOutlet weak var viewMainDescribe: UIView!
    
    // MARK: - let
    
    private let locationManager = CLLocationManager()
    let managerVC = NetworkManager()
    let defaults = UserDefaults.standard
    
    // MARK: - var
    var circleSize: CGFloat{
        return viewMainDescribe.layer.frame.height / 2
    }
    var models = [List]()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        managerVC.delegate = self
        self.swipeSecondViewController()
        self.myTableView.separatorColor = .clear
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.startlocationManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.myTableView.reloadData()
        self.viewMainDescribe.layer.cornerRadius = self.circleSize
        viewMainDescribe.clipsToBounds = true
        viewMainDescribe.layer.masksToBounds = true
    }
    
    // MARK: - @IBAction
    
    
    @IBAction func searchCityButton(_ sender: UIBarButtonItem) {
        jumpSearchVC()
    }
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        let str = navigationController?.navigationBar.topItem?.title ?? ""
        mSave.shared.loadCity(str: str)
        jumpSecondViewController()
        
    }
    
    // MARK: - func
    
    private func startlocationManager() {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    private func swipeSecondViewController(){
        let swipeClear = UISwipeGestureRecognizer(target: self, action: #selector(jumpSecondViewController))
        swipeClear.direction = .left
        self.view.addGestureRecognizer(swipeClear)
    }
    
    private func jumpSearchVC(){
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: K.searchVC.rawValue) as? SearchViewController else{return}
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc private func jumpSecondViewController(){
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: K.savedTableVC.rawValue) as? SavedTableViewController else{return}
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: extension ViewController: UITableViewDelegate, UITableViewDataSource

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
       // view.backgroundColor =  #colorLiteral(red: 1, green: 0.3653766513, blue: 0.1507387459, alpha: 1)
      //  view.backgroundColor = .blu
           
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.layer.masksToBounds = true
        blurEffectView.layer.cornerRadius = K.uiSize.cornerRadius.rawValue
        view.addSubview(blurEffectView)
        
        let lbl = UILabel(frame: CGRect(x: 15, y: view.frame.origin.y, width: view.frame.width, height: 40))
        lbl.font = UIFont.systemFont(ofSize: 25)
        lbl.textColor = .black
        lbl.text = "Weather for 6 days: "
        lbl.layer.masksToBounds = true
        lbl.layer.cornerRadius = 10
        
        view.addSubview(lbl)
        
       
        
        
        
        return view
    }
    
    
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
               return 40
        }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: K.customTableViewCell.rawValue, for: indexPath) as? CustomTableViewCell else{
            return UITableViewCell()
        }
        
        DispatchQueue.main.async {
            cell.configureCell(with: self.models[indexPath.row])
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

// MARK: extension ViewController: CLLocationManagerDelegate

extension ViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = String(location.coordinate.latitude)
            let lon = String(location.coordinate.longitude)
            print(lat)
            print(lon)
            DispatchQueue.main.async {
                self.managerVC.callLoadDataUrl(lat: lat, long: lon)
            }
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error location")
        print(error)
    }
}

// MARK: extension ViewController: WeatherManagerDelegate

extension ViewController: WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: NetworkManager, weather: Any) {
        guard let safeWeather = weather as? CoordWeather else{fatalError("")}
        
        DispatchQueue.main.async {
            self.currentTempBasicLabel.text = "\(String(format: "%.1f",(safeWeather.list?.first?.main?.temp ?? "---")))°C"
            self.currentDescriptionWeatherLabel.text = safeWeather.list?.first?.weather?.first?.description ?? ""
            self.navigationController!.navigationBar.topItem?.title = safeWeather.city?.name
            let img = safeWeather.list?.first?.weather?.first?.icon ?? " "
            self.backgroundImageView.image = UIImage(named: img )
            let url = URL(string: "https://openweathermap.org/img/wn/\(img)@2x.png")
            
            if let safeUrl = url {
                
                let queue = DispatchQueue.global(qos: .utility)
                queue.async{
                    
                    if let data = try? Data(contentsOf: safeUrl){
                        DispatchQueue.main.async {
                            if let  image = UIImage(data: data){
                                self.currentImageView.image = image
                            }
                        }
                    }
                }
            }
            
            if let safeW = safeWeather.list {
                self.models.append(contentsOf: safeW )
                
            }
            self.myTableView.reloadData()
        }
    }
    
    
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}


