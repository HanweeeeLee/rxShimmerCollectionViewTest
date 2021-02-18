//
//  MyNewCollectionView.swift
//  rxCollectionViewShimmerModuleTest
//
//  Created by hanwe on 2021/02/17.
//

import UIKit

@objc protocol HWCollectionViewDelegate: UICollectionViewDelegate {
    
    func numberOfShimmerCollectionViewCell(_ hwCollectionView: HWCollectionView) -> UInt
    func shimmerCollectionViewCellIdentifier(_ hwCollectionView: HWCollectionView) -> String
    @objc optional func willApearShimmerCollectionView(_ hwCollectionView: HWCollectionView)
    @objc optional func didApearShimmerCollectionView(_ hwCollectionView: HWCollectionView)
    @objc optional func willDisapearShimmerCollectionView(_ hwCollectionView: HWCollectionView)
    @objc optional func didDisapearShimmerCollectionView(_ hwCollectionView: HWCollectionView)
    
}

@objc protocol HWCollectionViewDelegateFlowLayout: HWCollectionViewDelegate {
    
    @objc optional func hwShimmerCollectionView(_ collectionView: HWCollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    @objc optional func hwShimmerCollectionView(_ collectionView: HWCollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    @objc optional func hwShimmerCollectionView(_ collectionView: HWCollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    @objc optional func hwShimmerCollectionView(_ collectionView: HWCollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    @objc optional func hwShimmerCollectionView(_ collectionView: HWCollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
    @objc optional func hwShimmerCollectionView(_ collectionView: HWCollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize
    
}

protocol HWShimmerCollectionViewCellProtocol: UICollectionViewCell {
    
    var shimmerBackgroundColor: UIColor { get set }
    var shimmerViewPool: Array<UIView> { get set }
    
    func startShimmer()
    func endShimmer()
}

extension HWShimmerCollectionViewCellProtocol {
    func startShimmer() {
        shimmerViewPool.map {
            let view: UIView = UIView()
            view.backgroundColor = shimmerBackgroundColor
            $0.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            let constraint1 = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal,
                                                 toItem: $0, attribute: .leading,
                                                 multiplier: 1.0, constant: 0)

            let constraint2 = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal,
                                                 toItem: $0, attribute: .trailing,
                                                 multiplier: 1.0, constant: 0)

            let constraint3 = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal,
                                                 toItem: $0, attribute: .top,
                                                 multiplier: 1.0, constant: 0)

            let constraint4 = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal,
                                                 toItem: $0, attribute: .bottom,
                                                 multiplier: 1.0, constant: 0)
            $0.addConstraints([constraint1, constraint2, constraint3, constraint4])
            $0.startShimmering()
        }
    }
    
    func endShimmer() {
        shimmerViewPool.map {
            $0.removeAllSubviewForHWCollectionView()
            $0.stopShimmering()
            
        }
    }
}

class HWCollectionView: UIView {
    
    //MARK: private property
    private var flowLayoutDelegate: HWCollectionViewDelegateFlowLayout?
    private var isShimmering: Bool = false
    private var minimumShimmerTimer: Timer?
    private var isOverMinimumShimmerTimer:Bool = true
    
    //MARK: property
    public lazy var collectionView: HWReloadHandlerCollectionView = HWReloadHandlerCollectionView(frame: self.bounds, collectionViewLayout: UICollectionViewLayout())
    public lazy var shimmerCollectionView: HWReloadHandlerCollectionView = HWReloadHandlerCollectionView(frame: self.bounds, collectionViewLayout: UICollectionViewLayout())
    
    weak var delegate: HWCollectionViewDelegate? {
        willSet {
            self.flowLayoutDelegate = newValue as? HWCollectionViewDelegateFlowLayout
        }
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
    
    var shimmerCollectionViewLayout: UICollectionViewLayout = .init() {
        didSet {
            self.shimmerCollectionView.collectionViewLayout = self.shimmerCollectionViewLayout
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
    
    override var backgroundColor: UIColor? {
        didSet {
            self.collectionView.backgroundColor = self.backgroundColor
        }
    }
    
    var minimumShimmerSecond: CGFloat = 1.5
    var shimmerCollectionViewFadeOutSecond: CGFloat = 0.15
    
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
    private func shimmerCollectionViewInit() {
        
        self.addSubview(self.collectionView)
        self.collectionView.backgroundColor = .clear
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
        
        self.addSubview(self.shimmerCollectionView)
        self.shimmerCollectionView.backgroundColor = .clear
        self.shimmerCollectionView.translatesAutoresizingMaskIntoConstraints = false
        let shimmerConstraint1 = NSLayoutConstraint(item: self.shimmerCollectionView, attribute: .leading, relatedBy: .equal,
                                             toItem: self, attribute: .leading,
                                             multiplier: 1.0, constant: 0)

        let shimmerConstraint2 = NSLayoutConstraint(item: self.shimmerCollectionView, attribute: .trailing, relatedBy: .equal,
                                             toItem: self, attribute: .trailing,
                                             multiplier: 1.0, constant: 0)

        let shimmerConstraint3 = NSLayoutConstraint(item: self.shimmerCollectionView, attribute: .top, relatedBy: .equal,
                                             toItem: self, attribute: .top,
                                             multiplier: 1.0, constant: 0)

        let shimmerConstraint4 = NSLayoutConstraint(item: self.shimmerCollectionView, attribute: .bottom, relatedBy: .equal,
                                             toItem: self, attribute: .bottom,
                                             multiplier: 1.0, constant: 0)
        self.addConstraints([shimmerConstraint1, shimmerConstraint2, shimmerConstraint3, shimmerConstraint4])
        self.shimmerCollectionView.delegate = self
        self.shimmerCollectionView.dataSource = self
        self.shimmerCollectionView.isHidden = true
        
    }
    
    @objc private func minimumShimmerTimerCallback() {
        self.isOverMinimumShimmerTimer = true
    }
    
    //MARK: public function
    
    public func registerShimmerCell(_ nib: UINib?, forCellWithReuseIdentifier identifier: String) {
        self.shimmerCollectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }
    
    public func showShimmer() {
        self.delegate?.willApearShimmerCollectionView?(self)
        self.isOverMinimumShimmerTimer = false
        self.shimmerCollectionView.alpha = 1
        self.shimmerCollectionView.isHidden = false
        self.isShimmering = true
        self.shimmerCollectionView.reloadData()
        if self.minimumShimmerTimer?.isValid ?? false {
            self.minimumShimmerTimer?.invalidate()
        }
        self.minimumShimmerTimer = Timer.scheduledTimer(timeInterval: TimeInterval(self.minimumShimmerSecond), target: self, selector: #selector(self.minimumShimmerTimerCallback), userInfo: nil, repeats: false)
        self.delegate?.didApearShimmerCollectionView?(self)
    }
    
    public func hideShimmer() {
        if self.isOverMinimumShimmerTimer {
            self.delegate?.willDisapearShimmerCollectionView?(self)
            self.isShimmering = false
            self.shimmerCollectionView.reloadData()
            self.shimmerCollectionView.fadeOutForHWCollectionView(duration: TimeInterval(self.shimmerCollectionViewFadeOutSecond), completeHandler: {
                self.shimmerCollectionView.isHidden = true
                self.delegate?.didDisapearShimmerCollectionView?(self)
            })
        }
        else {
            DispatchQueue.global(qos: .default).async { [weak self] in
                usleep(3 * 100 * 1000)
                DispatchQueue.main.async { [weak self] in
                    self?.hideShimmer()
                }
            }
        }
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

extension HWCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.shimmerCollectionView {
            return Int(self.delegate?.numberOfShimmerCollectionViewCell(self) ?? 0)
        }
        else {
            return 100
        }
    }
      
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let identifier = self.delegate?.shimmerCollectionViewCellIdentifier(self) else {
            return UICollectionViewCell()
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        if let shimmerCell = (cell as? HWShimmerCollectionViewCellProtocol) {
            if self.isShimmering {
                (shimmerCell as HWShimmerCollectionViewCellProtocol).startShimmer()
            }
            else {
                (shimmerCell as HWShimmerCollectionViewCellProtocol).endShimmer()
            }
        }

        return cell
    }
    
}

extension HWCollectionView: UICollectionViewDelegate {
    
}

extension HWCollectionView: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.flowLayoutDelegate?.hwShimmerCollectionView?(self, layout: collectionViewLayout, sizeForItemAt: indexPath) ?? CGSize(width: 0, height: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let edgeInsets:UIEdgeInsets = self.flowLayoutDelegate?.hwShimmerCollectionView?(self, layout: collectionViewLayout, insetForSectionAt: section) ?? .init(top: 0, left: 0, bottom: 0, right: 0)
        return edgeInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.flowLayoutDelegate?.hwShimmerCollectionView?(self, layout: collectionViewLayout, minimumLineSpacingForSectionAt: section) ?? 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return self.flowLayoutDelegate?.hwShimmerCollectionView?(self, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: section) ?? 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return self.flowLayoutDelegate?.hwShimmerCollectionView?(self, layout: collectionViewLayout, referenceSizeForHeaderInSection: section) ?? CGSize(width: 0, height: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return self.flowLayoutDelegate?.hwShimmerCollectionView?(self, layout: collectionViewLayout, referenceSizeForFooterInSection: section) ?? CGSize(width: 0, height: 0)
    }

}

extension UIView {
    
    func startShimmering() {
        let light = UIColor(white: 0, alpha: 0.1).cgColor
        let dark = UIColor.black.cgColor
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [dark, light, dark]
        gradient.frame = CGRect(x: -bounds.size.width, y: 0, width: 3 * bounds.size.width, height: bounds.size.height)
        
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint   = CGPoint(x: 1.0, y: 0.5)
        gradient.locations  = [0.49, 0.5, 0.51]
        
        layer.mask = gradient
        
        let animation: CABasicAnimation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0.0, 0.1, 0.2]
        animation.toValue   = [0.8, 0.9, 1.0]
        
        animation.duration = 1.3
        animation.repeatCount = Float.greatestFiniteMagnitude
        animation.isRemovedOnCompletion = false
        
        gradient.add(animation, forKey: "shimmer")
    }
    
    func stopShimmering(){
        DispatchQueue.main.async {
            self.layer.mask = nil
        }
    }
    
    func fadeOutForHWCollectionView(duration: TimeInterval = 0.2, completeHandler:@escaping () -> ()) {
        self.alpha = 1.0
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            self.alpha = 0.0
        }, completion: {[weak self] (finished: Bool) -> Void in
            completeHandler()
        })
    }
    func removeAllSubviewForHWCollectionView() {
        self.subviews.forEach({ $0.removeFromSuperview() })
    }
    
}
