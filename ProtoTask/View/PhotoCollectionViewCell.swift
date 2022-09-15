//
//  PhotoCollectionViewCell.swift
//  ProtoTask
//
//  Created by Aya Bassi on 14/09/2022.
//

import UIKit

protocol PhotoCollectionViewCellDelegate {
    func performImageZoom(startingImageView: UIImageView)
}

class PhotoCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PhotoCollectionViewCell"
    
    var delegate : PhotoCollectionViewCellDelegate?
    
    private lazy var imageView : UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        let longTap = UILongPressGestureRecognizer(target: self, action: #selector(handleLongTapZoom))
        imageView.addGestureRecognizer(longTap)
        return imageView
    }()
    
    let durationLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(white: 0, alpha: 0.7)
        label.textColor = .white
        label.textAlignment = .center
        return label
   }()
    
    //lazy var size = imageView.frame.size.width
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        contentView.addSubview(imageView)
        
        imageView.addSubview(durationLabel)
        durationLabel.anchor(bottom: imageView.bottomAnchor, right: imageView.rightAnchor, paddingBottom: 4, paddingRight: 4)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    @objc func handleLongTapZoom(tap : UILongPressGestureRecognizer){
        // just in case more action is requred
        //        switch tap.state {
        //        case UILongPressGestureRecognizer.State.began:
        //
        //        case UILongPressGestureRecognizer.State.ended:
        //            break
        //        default:
        //            break
        //        }
        
        if tap.state == UILongPressGestureRecognizer.State.began {
            if let imageView = tap.view as? UIImageView {
                delegate?.performImageZoom(startingImageView: imageView)
            }
        }
    }
    
    
    
    func fetchImageDataAndAddToImageViewAlsoAddMovieDuration(with urlString:String,with moviesDuration:String){
        guard let url = URL(string: urlString) else {return}

        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data,error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self?.imageView.image = image
                
                // just grabing the title label width size and adding 10 pixels to it
                self?.durationLabel.text = moviesDuration
            }
        }.resume()
    }
    
}
