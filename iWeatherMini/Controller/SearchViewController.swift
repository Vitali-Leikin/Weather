

import UIKit

class SearchViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var currentCityLabel: UILabel!
    @IBOutlet weak var currentDescriptionWeatherLabel: UILabel!
    @IBOutlet weak var tempBasicLabel: UILabel!
    @IBOutlet weak var currentImageView: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tempMax: UILabel!
    @IBOutlet weak var tempMin: UILabel!
    
    @IBOutlet weak var firstLineView: UIView!
    @IBOutlet weak var thirdLineView: UIView!
    
    @IBOutlet weak var secondLineView: UIView!
    
    @IBOutlet weak var allLineView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    // MARK: - var
    
    private var secondViewModel = SecondViewModel()
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.swipeViewController()
        
        self.searchBar.delegate = self
        registerForKeyboardNotifications()
    }
    
    
 
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        firstLineView.setupShadow()
        secondLineView.setupShadow()
        thirdLineView.setupShadow()
        allLineView.isHidden = true
        navigationItem.rightBarButtonItem?.isEnabled = false
        self.configureUI()
       
        
    }
    
    // MARK: - func
    
    private func configureUI(){
        
        self.secondViewModel.currentCityLabel.bind { (currentCityLabel) in
            self.currentCityLabel.text = currentCityLabel
        }
        self.secondViewModel.tempBasicLabel.bind { (tempBasicLabel) in
            self.tempBasicLabel.text = tempBasicLabel
        }
        
        self.secondViewModel.currentDescriptionWeatherLabel.bind { (currentDescriptionWeatherLabel) in
            self.currentDescriptionWeatherLabel.text = currentDescriptionWeatherLabel
        }
        self.secondViewModel.currentCityLabel.bind { (currentCityLabel) in
            self.currentCityLabel.text = currentCityLabel
        }
        self.secondViewModel.currentImageView.bind { (currentImageView) in
            self.currentImageView.image = currentImageView
        }
        self.secondViewModel.backgroundImageView.bind { (backgroundImageView) in
            self.backgroundImageView.image = backgroundImageView
        }
        self.secondViewModel.minTemp.bind { tempMin in
            self.tempMin.text = tempMin
        }
        self.secondViewModel.maxTemp.bind { tempMax in
            self.tempMax.text = tempMax
        }
        
    }
    
    
    
    @IBAction func addCityButton(_ sender: UIBarButtonItem) {
        guard let text = currentCityLabel.text else {fatalError("")}
        
        if text != "Неправельно указан город" && !text.isEmpty {
            mSave.shared.loadCity(str: text)
        }
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        UIView.animate(withDuration: 1.0) { //1
            

           self.navigationItem.title = "Saved"
        }
        
    }
    
    
    func swipeViewController(){
        
        let swipeClear = UISwipeGestureRecognizer(target: self, action: #selector(jumpViewController))
        swipeClear.direction = .right
        self.view.addGestureRecognizer(swipeClear)
        
    }
    
    
    @objc func jumpViewController(){
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    // MARK: - IBAction
    
    
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeForKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        
        let userInfo = notification.userInfo!
        let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentOffset = CGPoint.zero
        } else {
            scrollView.contentOffset = CGPoint(x: 0, y: keyboardScreenEndFrame.height + 150)
        }
        
        view.needsUpdateConstraints()
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    
    
}


extension SearchViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard var city  = searchBar.text else { fatalError("")}
        if !city.isEmpty{
            city = city.replacingOccurrences(of: " ", with: "%20")
            self.secondViewModel.callLoadDataUrl(city: city)
            allLineView.isHidden = false
            searchBar.resignFirstResponder()
            searchBar.text = ""
               navigationItem.rightBarButtonItem?.isEnabled = true
        }
        searchBar.resignFirstResponder()
        searchBar.text = ""
        
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
                self.tempMin.text = ""
                self.tempMax.text = ""
                self.tempBasicLabel.text = ""
                self.currentDescriptionWeatherLabel.text = ""
                self.currentImageView.image = UIImage()
        return true
    }
}
