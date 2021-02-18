//
//  ShimmerCellCollectionViewCell.swift
//  rxCollectionViewShimmerModuleTest
//
//  Created by hanwe lee on 2021/02/18.
//

import UIKit

class ShimmerCellCollectionViewCell: UICollectionViewCell, HWShimmerCollectionViewCellProtocol {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var myLabel: UILabel!
    
    var shimmerBackgroundColor: UIColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)
    var shimmerViewPool: Array<UIView> = Array()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imgView.layer.cornerRadius = 25
        registShimmerPool()
    }
    
    func registShimmerPool() {
        self.shimmerViewPool.append(self.imgView)
        self.shimmerViewPool.append(self.myLabel)
    }

}
