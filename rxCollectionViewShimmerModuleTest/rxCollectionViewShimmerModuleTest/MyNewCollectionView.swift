//
//  MyNewCollectionView.swift
//  rxCollectionViewShimmerModuleTest
//
//  Created by hanwe on 2021/02/17.
//

import UIKit

protocol MyNewCollectionViewDelegate: UICollectionViewDelegate {
    func testFunc()
}

class MyNewCollectionView: UIView {
    
    //MARK: property
    public lazy var collectionView: HWReloadHandlerCollectionView = HWReloadHandlerCollectionView(frame: self.bounds, collectionViewLayout: UICollectionViewLayout())
    public lazy var shimmerCollectionView: HWReloadHandlerCollectionView = HWReloadHandlerCollectionView(frame: self.bounds, collectionViewLayout: UICollectionViewLayout())
    
    weak var delegate: MyNewCollectionViewDelegate? {
        didSet {
            self.collectionView.delegate = self.delegate
        }
    }
    
    weak var datasource: UICollectionViewDataSource? {
        didSet {
            self.collectionView.dataSource = self.datasource
        }
    }
    
    var collectionViewLayout: UICollectionViewLayout = .init() {
        didSet {
            self.collectionView.collectionViewLayout = self.collectionViewLayout
        }
    }
    
    var showsHorizontalScrollIndicator: Bool = true {
        didSet {
            self.collectionView.showsHorizontalScrollIndicator = self.showsHorizontalScrollIndicator
        }
    }
    
    var showsVerticalScrollIndicator: Bool = true {
        didSet {
            self.collectionView.showsVerticalScrollIndicator = self.showsVerticalScrollIndicator
        }
    }
    
    //MARK: life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        shimmerCollectionViewInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        shimmerCollectionViewInit()
    }
    
    //MARK: private function
    func shimmerCollectionViewInit() {
        print("MyNewCollectionView shimmerCollectionViewInit")
//        self.addSubview(self.shimmerCollectionView)
//        self.shimmerCollectionView.backgroundColor = .blue // test
//        self.shimmerCollectionView.translatesAutoresizingMaskIntoConstraints = false
//        let constraint1 = NSLayoutConstraint(item: self.shimmerCollectionView, attribute: .leading, relatedBy: .equal,
//                                             toItem: self, attribute: .leading,
//                                             multiplier: 1.0, constant: 0)
//
//        let constraint2 = NSLayoutConstraint(item: self.shimmerCollectionView, attribute: .trailing, relatedBy: .equal,
//                                             toItem: self, attribute: .trailing,
//                                             multiplier: 1.0, constant: 0)
//
//        let constraint3 = NSLayoutConstraint(item: self.shimmerCollectionView, attribute: .top, relatedBy: .equal,
//                                             toItem: self, attribute: .top,
//                                             multiplier: 1.0, constant: 0)
//
//        let constraint4 = NSLayoutConstraint(item: self.shimmerCollectionView, attribute: .bottom, relatedBy: .equal,
//                                             toItem: self, attribute: .bottom,
//                                             multiplier: 1.0, constant: 0)
//        self.addConstraints([constraint1, constraint2, constraint3, constraint4])
        
        self.addSubview(self.collectionView)
        self.collectionView.backgroundColor = .lightGray
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        let constraint1 = NSLayoutConstraint(item: self.collectionView, attribute: .leading, relatedBy: .equal,
                                             toItem: self, attribute: .leading,
                                             multiplier: 1.0, constant: 0)

        let constraint2 = NSLayoutConstraint(item: self.collectionView, attribute: .trailing, relatedBy: .equal,
                                             toItem: self, attribute: .trailing,
                                             multiplier: 1.0, constant: 0)

        let constraint3 = NSLayoutConstraint(item: self.collectionView, attribute: .top, relatedBy: .equal,
                                             toItem: self, attribute: .top,
                                             multiplier: 1.0, constant: 0)

        let constraint4 = NSLayoutConstraint(item: self.collectionView, attribute: .bottom, relatedBy: .equal,
                                             toItem: self, attribute: .bottom,
                                             multiplier: 1.0, constant: 0)
        self.addConstraints([constraint1, constraint2, constraint3, constraint4])
        
        
    }
    
    //MARK: public function
    
    func callTestFuncDelegateFunction() {
        self.delegate?.testFunc()
    }
}

class HWReloadHandlerCollectionView: UICollectionView {
    //https://medium.com/@jongwonwoo/uicollectionview-reloaddata-%EA%B0%80-%EC%99%84%EB%A3%8C%EB%90%9C-%EC%8B%9C%EC%A0%90%EC%9D%84-%EC%95%8C%EC%95%84%EB%82%B4%EB%8A%94-%EC%95%88%EC%A0%84%ED%95%9C-%EB%B0%A9%EB%B2%95-fa9bac8d0a89
    var reloadCompleteHandler: (() -> ())?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let closure = self.reloadCompleteHandler {
            closure()
        }
    }
}
