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
    @IBOutlet weak var collectionView: UICollectionView!
    
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
        self.collectionView.delegate = self
//        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "MyCell", bundle: nil), forCellWithReuseIdentifier: "MyCell")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        self.collectionView.collectionViewLayout = layout
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.showsVerticalScrollIndicator = false
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
            .bind(to: collectionView.rx.items) { collectionView, row, item in
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
                }
                else {
                    print("loading end")
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    //MARK: action
}

extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let resultCnt = 100
          
          return resultCnt
      }
      
      func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! MyCell
        if indexPath.item%2 == 0 {
            cell.myLabel.text = "hello"
        }
        else {
            cell.myLabel.text = "hi"
        }
        return cell
      }
      
      func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
      }
      
      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize:CGSize = CGSize(width: UIScreen.main.bounds.width/2 - 50, height: UIScreen.main.bounds.width)
          
          return cellSize
      }
      
      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let edgeInsets:UIEdgeInsets = .init(top: 100,
                                            left: 0,
                                            bottom: 0,
                                            right: 0)
          return edgeInsets
      }
    
}
