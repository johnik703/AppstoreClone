//
//  AppDetailController.swift
//  Appstore
//
//  Created by John Nik on 10/9/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit

class AppDetailContrller: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var app: App? {
        didSet {
            navigationItem.title = app?.name
            
            if app?.screenshots != nil {
                return 
            }
            
            
            if let id = app?.id {
                let urlString = "www.sere\(id)"
                let url = URL(string: urlString)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                    
                    if error != nil {
                        print(error!)
                        return
                    }
                    do {
                        
                        let json = try(JSONSerialization.jsonObject(with: data!, options: .mutableContainers)) as! [String: AnyObject]
                        
                        let appDetail = App()
                        appDetail.setValuesForKeys(json)
                        
                        self.app = appDetail
                        
                        DispatchQueue.main.async {
                            self.collectionView?.reloadData()
                            
                        }
                        
                    } catch let err {
                        print(err)
                    }

                    
                }).resume()
                
            }
            
        }
    }
    
    private let headerId = "headerId"
    private let cellId = "cellId"
    private let descriptionCellId = "descriptionCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = .white
        collectionView?.register(AppDetailHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView?.register(ScreenshotCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(AppDetailDescriptionCell.self, forCellWithReuseIdentifier: descriptionCellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: descriptionCellId, for: indexPath) as! AppDetailDescriptionCell
            cell.textView.attributedText = descriptionAttributedText()
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ScreenshotCell
        
        cell.app = app
        return cell
        
    }
    
    private func descriptionAttributedText() -> NSAttributedString {
        
        let attribtedText = NSMutableAttributedString(string: "Description\n", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)])
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 10
        let range = NSMakeRange(0, attribtedText.string.characters.count)
        attribtedText.addAttribute(NSParagraphStyleAttributeName, value: style, range: range)
        
        if let desc = app?.desc {
            attribtedText.append(NSAttributedString(string: desc, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 11), NSForegroundColorAttributeName: UIColor.darkGray]))
        }
        
        return attribtedText
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.item == 1 {
            
            let dummySize = CGSize(width: view.frame.width - -16, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin)
            let rect = descriptionAttributedText().boundingRect(with: dummySize, options: options, context: nil)
            
            return CGSize(width: view.frame.width, height: rect.height + 30)
            
        }
        
        return CGSize(width: view.frame.width, height: 170)
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! AppDetailHeader
        return header
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 170)
    }
}

class AppDetailDescriptionCell: BaseCell {
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.text = "dfsdfs"
        return tv
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        return view
    }()
    
    override func setupViews() {
        super.setupViews()
        
        
        addSubview(textView)
        addSubview(dividerLineView)
        
        addConstranitsWithFormat(format: "H:|-0-[v0]-0-|", views: textView)
        addConstranitsWithFormat(format: "H:|-14-[v0]|", views: dividerLineView)
        
        addConstranitsWithFormat(format: "V:|-4-[v0]-4-[v1(1)|", views: textView, dividerLineView)
    }
    
}

class AppDetailHeader: BaseCell {
    
    var app: App? {
        didSet {
            
            if let imageName = app?.imageName {
                imageView.image = UIImage(named: imageName)
            }
            
            nameLabel.text = app?.name
            
            if let price = app?.price?.stringValue {
                buyButton.setTitle("$\(price)", for: .normal)
            }
        }
    }
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let segmentControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Details", "Reviews", "Related"])
        sc.tintColor = .darkGray
        return sc
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Test"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let buyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("BUY", for: .normal)
        button.layer.borderColor = UIColor(red: 0, green: 129 / 255, blue: 250 / 255, alpha: 1).cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return button
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        return view
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(imageView)
        addSubview(segmentControl)
        addSubview(nameLabel)
        addSubview(buyButton)
        addSubview(dividerLineView)
        
        addConstranitsWithFormat(format: "H:|-14-[v0(100)]-8-[v1]|", views: imageView, nameLabel)
        addConstranitsWithFormat(format: "V:|-14-[v0(100)]|", views: imageView)
        
        addConstranitsWithFormat(format: "V:|-14-[v0(20)]", views: nameLabel)
        
        addConstranitsWithFormat(format: "H:|-40-[v0]-40-|", views: segmentControl)
        addConstranitsWithFormat(format: "V:[v0(34)]-8-|", views: segmentControl)
        
        addConstranitsWithFormat(format: "H:[v0(60)]-14-|", views: buyButton)
        addConstranitsWithFormat(format: "V:[v0(32)]-44-", views: buyButton)
        
        addConstranitsWithFormat(format: "H:|[v0]|", views: dividerLineView)
        addConstranitsWithFormat(format: "V:[v0(0.5)]|", views: dividerLineView)
        
    }
}

extension UIView {
    func addConstranitsWithFormat(format: String, views: UIView...) {
        
        var viewDictionary = [String: UIView]()
        
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewDictionary))
    }
}

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
    }
}
