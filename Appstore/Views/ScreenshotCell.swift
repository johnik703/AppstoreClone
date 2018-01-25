//
//  ScreenshotCell.swift
//  Appstore
//
//  Created by John Nik on 10/9/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit

class ScreenshotCell: BaseCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var app: App? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    let cellId = "cellId"
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .red
        return cv
    }()
    
    let dividerLineView: UIView = {
        let  view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func setupViews() {
        super.setupViews()
        
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        addSubview(collectionView)
        addSubview(dividerLineView)
        
        addConstranitsWithFormat(format: "H:|[v0]|", views: collectionView)
        
        addConstranitsWithFormat(format: "H:|-14-[v0]|", views: dividerLineView)
        
        addConstranitsWithFormat(format: "V:|[v0][v1(1)]|", views: collectionView, dividerLineView)
        
        collectionView.register(ScreenshotImageCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let count = app?.screenshots?.count {
            return count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ScreenshotImageCell
        if let imageName = app?.screenshots?[indexPath.row] {
            cell.imageView.image = UIImage(named: imageName)
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
    }
    
    private class ScreenshotImageCell: BaseCell {
        
        let imageView: UIImageView = {
            let iv = UIImageView()
            iv.contentMode = .scaleAspectFill
            iv.backgroundColor = .green
            return iv
        }()
        
        override func setupViews() {
            super.setupViews()
            backgroundColor = .blue
            layer.masksToBounds = true
            
            addSubview(imageView)
            
            addConstranitsWithFormat(format: "H:|[v0]|", views: imageView)
            addConstranitsWithFormat(format: "V:|[v1]|", views: imageView)
        }
    }
}
