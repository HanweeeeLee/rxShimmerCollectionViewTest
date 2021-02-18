//
//  ViewController.swift
//  rxCollectionViewShimmerModuleTest
//
//  Created by hanwe on 2021/02/17.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    //MARK: Interface Builder
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var myCollectionView: HWCollectionView!
    
    //MARK: property
    var viewModel: ViewModel = ViewModel()
    var disposeBag: DisposeBag = DisposeBag()
    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initBind()
        initSubscribe()
        viewModel.initSubscribe()
    }
    
    //MARK: function
    
    func initUI() {
        self.myCollectionView.delegate = self
        self.myCollectionView.collectionView.register(UINib(nibName: "MyCell", bundle: nil), forCellWithReuseIdentifier: "MyCell")
        self.myCollectionView.registerShimmerCell(UINib(nibName: "ShimmerCellCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ShimmerCellCollectionViewCell")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        self.myCollectionView.collectionViewLayout = layout
        let shimmerLayout = UICollectionViewFlowLayout()
        shimmerLayout.scrollDirection = .vertical
        shimmerLayout.minimumLineSpacing = 10
        shimmerLayout.minimumInteritemSpacing = 10
        self.myCollectionView.shimmerCollectionViewLayout = shimmerLayout
        self.myCollectionView.showsHorizontalScrollIndicator = false
        self.myCollectionView.showsVerticalScrollIndicator = false
    }
    
    func initBind() {
        searchBar.rx.text
            .orEmpty
            .bind(to: self.viewModel.searchTextRelay)
            .disposed(by: self.disposeBag)
    }
    
    func initSubscribe() {
        
        viewModel.gitHubRepositories
            .observe(on: MainScheduler.instance)
            .bind(to: self.myCollectionView.collectionView.rx.items) { collectionView, row, item in
                let indexPath: IndexPath = IndexPath(item: row, section: 0)
                guard let cell: MyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as? MyCell else {
                    return UICollectionViewCell()
                }
                cell.myLabel.text = item.fullName
                return cell
                
            }
            .disposed(by: self.disposeBag)
        
        viewModel.isLoading
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                if $0 {
                    print("isLoading")
                    self.myCollectionView.showShimmer()
                }
                else {
                    print("loading end")
                    self.myCollectionView.hideShimmer()
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    //MARK: action
}

extension ViewController: UICollectionViewDelegateFlowLayout, HWCollectionViewDelegate, HWCollectionViewDelegateFlowLayout {
    func numberOfShimmerCollectionViewCell(_ hwCollectionView: HWCollectionView) -> UInt {
        return 20
    }
    
    func shimmerCollectionViewCellIdentifier(_ hwCollectionView: HWCollectionView) -> String {
        return "ShimmerCellCollectionViewCell"
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSelected: \(indexPath)")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize:CGSize = CGSize(width: UIScreen.main.bounds.width/2 - 50, height: UIScreen.main.bounds.width)
        
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let edgeInsets:UIEdgeInsets = .init(top: 0,
                                            left: 0,
                                            bottom: 0,
                                            right: 0)
        return edgeInsets
    }
    
    func hwShimmerCollectionView(_ collectionView: HWCollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize:CGSize = CGSize(width: UIScreen.main.bounds.width/2 - 50, height: UIScreen.main.bounds.width)
        
        return cellSize
    }
    
    func hwShimmerCollectionView(_ collectionView: HWCollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let edgeInsets:UIEdgeInsets = .init(top: 0,
                                            left: 0,
                                            bottom: 0,
                                            right: 0)
        return edgeInsets
    }
    
}
