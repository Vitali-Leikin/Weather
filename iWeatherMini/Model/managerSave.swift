//
//  managerSave.swift
//  iWeatherMini
//
//  Created by vitali on 15.07.2023.
//

import Foundation


class mSave{
    
    let defaults =  UserDefaults.standard
    static let shared = mSave()
    let keyCity = "city"
    private let  wrongCity = "Неправельно указан город"
    
    private init(){}
    
    
    func removeCity(_ indexPath: Int){
        let array = mSave.shared.defaults.stringArray(forKey: mSave.shared.keyCity)
        if let safeArray = array {
            print(safeArray)
            var temp = safeArray
            temp.remove(at: indexPath)
            print(temp)
            mSave.shared.defaults.set(temp, forKey:  mSave.shared.keyCity)
        }
    }
    
    func loadCity(str: String){
        let array = mSave.shared.defaults.stringArray(forKey: mSave.shared.keyCity)
            if let safeArray = array {
            if !str.isEmpty && str != wrongCity{
                var tempArray:[String] = safeArray
                mSave.shared.defaults.removeObject(forKey: mSave.shared.keyCity)
                tempArray.append(str)
                let unique = Array(Set(tempArray)).sorted()
                mSave.shared.defaults.set(unique, forKey: mSave.shared.keyCity)
            }
        }else{
            mSave.shared.defaults.set([str], forKey:  mSave.shared.keyCity)
        }
    }
    
}
