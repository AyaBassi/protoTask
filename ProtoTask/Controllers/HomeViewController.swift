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
    var imageUrlDurationArray : [(id:Int,url:String,duration:String,movieDescrib:String)] = []
    var moveiInfos : [MovieInfos] = [] {
        didSet {
            for movieInfo in moveiInfos {
                if let jsonItemsImages = movieInfo.images {
                    for image in jsonItemsImages {
                        if image.type == TypeEnum.thumbnail {
                            self.imageUrlDurationArray.append((movieInfo.id,image.url,movieInfo.duration,movieInfo.movieDescription))
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
        
        let (id,imageURLString,movieDuration,_) = imageUrlDurationArray[indexPath.row]
        
        cell.fetchImageDataAndAddToImageViewAlsoAddMovieDuration(with: imageURLString, with: movieDuration)
        cell.imageView.tag = id
        cell.tag = id
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
    

        print("Selected section \(indexPath.section) and row \(indexPath.row) ")
    }
    
    // MARK: - PhotoCollectionViewCellDelegate
    var startingFrame : CGRect?
    var blackBackgroudView : UIView?
    
    let photoCollectionViewCell = PhotoCollectionViewCell()
    
    func getImagesAndToScreen(with urlString: String, with moviesDuration: String) {
        print("getImagesAndaddTo screen")
        
            guard let url = URL(string: urlString) else {return}
    
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data,error == nil else {
                    return
                }
    
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self?.photoCollectionViewCell.imageView.image = image
    
                    // just grabing the title label width size and adding 10 pixels to it
                    self?.photoCollectionViewCell.durationLabel.text = moviesDuration
                }
            }.resume()
    }
    
    let descriptionLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "No Description Available"
        label.font = UIFont(name: "Avenir-Light", size: 16)
        label.textColor = .white
        return label
    }()
    
    func performImageZoomAndShowMovieDescription(startingImageView: UIImageView) {
        startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
        if let startingFrameChecked = startingFrame {
            let zoomingImageView = UIImageView(frame: startingFrameChecked)
            
            zoomingImageView.image = startingImageView.image
            zoomingImageView.isUserInteractionEnabled = true
            zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
            
            // find the tag of image long pressed from startignImageView tag that is set right at the beginning and then add the description of the found movie item to description label
            for moveiInfo in moveiInfos {
                if moveiInfo.id == startingImageView.tag {
                    descriptionLabel.text = moveiInfo.movieDescription
                }
            }
            
            if let keyWindow = view.window?.windowScene?.keyWindow {
                
                blackBackgroudView = UIView(frame: keyWindow.frame)
                blackBackgroudView?.backgroundColor = .black
                blackBackgroudView?.alpha = 0
                
                keyWindow.addSubview(blackBackgroudView!)
                keyWindow.addSubview(zoomingImageView)
                blackBackgroudView?.addSubview(descriptionLabel)
                
                descriptionLabel.anchor(top: zoomingImageView.bottomAnchor, left: blackBackgroudView?.leftAnchor, right: blackBackgroudView?.rightAnchor, paddingTop: 4, paddingLeft: 4, paddingRight: 4)
                descriptionLabel.alpha = 0
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    
                    self.blackBackgroudView?.alpha = 1
                    self.descriptionLabel.alpha = 1
                    let height = self.startingFrame!.height / self.startingFrame!.width * keyWindow.frame.width
                    zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                
                    zoomingImageView.center = keyWindow.center
                    
                }, completion:nil)
            }
        }
    }
    
    // MARK: - Selectors
    
    @objc func handleZoomOut(tapGesture: UITapGestureRecognizer){
        if let zoomOutImageView = tapGesture.view {
            // need to anmage back out to controller
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
                zoomOutImageView.frame = self.startingFrame!
                self.descriptionLabel.alpha = 0
                self.blackBackgroudView?.alpha = 0
            } completion: { _ in
                zoomOutImageView.removeFromSuperview()
                self.descriptionLabel.removeFromSuperview()
                self.blackBackgroudView?.removeFromSuperview()
            }
        }
    }
    
}
