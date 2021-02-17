//
//  MyCollectionView.swift
//  rxCollectionViewShimmerModuleTest
//
//  Created by hanwe on 2021/02/17.
//

import UIKit
import SnapKit
//실패
class MyCollectionView: UICollectionView {
    
    //MARK: property
    public lazy var shimmerCollectionView: HWReloadHandlerCollectionView = HWReloadHandlerCollectionView(frame: self.bounds, collectionViewLayout: UICollectionViewLayout())
    
    //MARK: life cycle
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
//        shimmerCollectionViewInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
//        shimmerCollectionViewInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        print("called My CollectionView Layout Subviews")
//        shimmerCollectionViewInit()
    }
    
    //MARK: private function
    func shimmerCollectionViewInit() {

        
    }
    
    //MARK: public function
    
    

}

