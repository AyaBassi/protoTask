//
//  HomeViewController.swift
//  ProtoTask
//
//  Created by Aya Bassi on 12/09/2022.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout, PhotoCollectionViewCellDelegate{
    
    
    
    // MARK: - Properties
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    
    let urlSring = "https://content-cache.watchcorridor.com/v6/interview"
    
    let loginViewController = LoginViewController()
    var imageUrlDurationArray : [(url:String,duration:String)] = []
    var moveiInfos : [MovieInfos] = [] {
        didSet {
            for movieInfo in moveiInfos {
                if let jsonItemsImages = movieInfo.images {
                    for image in jsonItemsImages {
                        if image.type == TypeEnum.thumbnail {
                            self.imageUrlDurationArray.append((image.url,movieInfo.duration))
                            break
                        }
                    }
                }
            }
            self.collectionView.reloadData()
        }
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .backgroundColor
            
        if !loginViewController.isLoggedIn {
            // not logged in so present login view controller to login
            presentLogInViewController()
        }
    }
    
    // MARK: - Helper functions
    
    func presentLogInViewController(){
        DispatchQueue.main.async {
            let nav = UINavigationController(rootViewController: LoginViewController())
            if #available(iOS 13.0, *) {
                nav.isModalInPresentation = true
            }
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    // When Login button is clicked in LoginViewController,if there is a successful logging in,with correct email and password, login view controller is dismissed and this function is called.Which we will try
    // to then make the api calls and set up every thing from here
    func callAllUIComponentsToShow(){
        configureCollectionView()
        fetchMovieData()
    }
    
    // MARK: - API CALLS
    func fetchMovieData(){
        guard let url = URL(string: urlSring) else {
            print("Something wrong with url!")
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self] jsonData , _ , error in
            guard let jsonData = jsonData , error == nil else {
                print("No data received, error: ",error!.localizedDescription)
                return
            }
            // success
            print("got data!")
            
            let jsonItems = try? JSONDecoder().decode([MovieInfos].self, from: jsonData)
            DispatchQueue.main.async {
                guard let jsonItems = jsonItems else { return }
                // now can access moviInformation data
                self?.moveiInfos = jsonItems
            }
        }
        task.resume()
    }
    
// MARK: - COLLECTION VIEW
    
    func configureCollectionView(){
        collectionView.register(PhotoCollectionViewCell.self,
                                forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .black
        view.addSubview(collectionView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrlDurationArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.delegate = self
        
        let (imageURLString,movieDuration) = imageUrlDurationArray[indexPath.row]
        
        cell.fetchImageDataAndAddToImageViewAlsoAddMovieDuration(with: imageURLString, with: movieDuration)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width:  (view.frame.size.width/2) - 2,
                      height: (view.frame.size.width/2) - 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        print("Selected section \(indexPath.section) and row \(indexPath.row)")
    }
    
    // MARK: - Image Animation Functions
    
    func performImageZoom() {

        
        
    }
}





//        for jsonItem in jsonItems {
//            print(jsonItem.id)
//
//            if let jsonItemImages = jsonItem.images {
//
//                for jsonItemImage in jsonItemImages {
//                    print(jsonItemImage.url)
//                }
//            } else {
//                print("No image")
//            }
//        }
