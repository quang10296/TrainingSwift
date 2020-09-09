//
//  ViewController.swift
//  Parse json
//
//  Created by Quang Nguyễn  on 9/5/20.
//  Copyright © 2020 PTIT. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

// tạo model để nhét dữ liệu lấy từ API về
struct ImageModel: Decodable {
    let name: String
    let timestamp: String
}

class ViewController: UIViewController {
    // tạo mảng chứa nhiều model để hiển thị tỏng collection view
    var model = [ImageModel]()
    var arrImageURL:[String] = [] {
        didSet{
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configCollection()
        getData()
    }
    
    // Sử dụng alamofire để lấy dữ liệu từ API
    func getData() {
        AF.request("https://api.androidhive.info/json/glide.json").responseJSON { response in
            let result = response.data
            // Sau khi có dữ liệu thì parse json to arr object đã tạo phía trên và reload collection view
            
            do {
                let object = try JSONSerialization.jsonObject(with: result!, options: .allowFragments)
                if let dictionary = object as? [[String: Any]] {
                    
                    for item in dictionary {
                        if let name = item["name"] as? String{
                            print("name : ",name)
                        }
                        
                        if let timestamp = item["timestamp"] as? String{
                            print("timestamp : ",timestamp)
                        }
                        
                        if let url = item["url"] as? [String:Any]{
                            if let small = url["small"] as? String {
                                print("small : ", small)
                                if !self.arrImageURL.contains(small) {
                                    self.arrImageURL.append(small)
                                }
                                
                            }
                            
                            if let medium = url["medium"] as? String {
                                print("medium : ", medium)
                            }
                            
                            if let large = url["large"] as? String {
                                print("large : ", large)
                            }
                        }
                    }
                    
                }
            } catch {
                // Handle Error
                print("quang")
            }
            
//            do {
//                self.model = try JSONDecoder().decode([ImageModel].self, from: result!)
//                print(self.model)
//                self.collectionView.reloadData()
//            } catch {
//                print("Error")
//            }
        }
    }
    
    func configCollection() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "Cell", bundle: nil), forCellWithReuseIdentifier: "Cell")
    }


}

//MARK: -- UICollectionViewDelegate, UICollectionViewDataSource
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImageURL.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? Cell {
            
            let url = URL(string: arrImageURL[indexPath.row])
            cell.imageCell.kf.indicatorType = .activity
            cell.imageCell.kf.setImage(with: url)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didselect ", arrImageURL[indexPath.row])
        
    }
}

//MARK: -- UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 20
        
        return CGSize(width: width, height: width * 1.5)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
       
        return UIEdgeInsets.init(top: 10, left: 10, bottom: 15, right: 10)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
       
        return 15
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

        return 15
    }
}
