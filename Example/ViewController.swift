//
//  ViewController.swift
//  Example
//
//  Created by Lasha Efremidze on 4/29/17.
//  Copyright © 2017 efremidze. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let strings = [
            "https://scontent.cdninstagram.com/t51.2885-15/s640x640/e35/12751247_1556549097988432_1552574224_n.jpg?ig_cache_key=MTE5MTY0OTc5MDg3OTI4NjkyOA%253D%253D.2",
            "https://scontent.cdninstagram.com/t51.2885-15/s640x640/e35/12747655_834461406677253_178252631_n.jpg?ig_cache_key=MTE5MTYxNDgyNDY1MzcwMTY4Mg%253D%253D.2.c",
            "https://scontent.cdninstagram.com/t51.2885-15/s640x640/e35/12724817_231270400541788_239495761_n.jpg?ig_cache_key=MTE5MTU0NjUyNDk2MTU4NTM0Ng%253D%253D.2",
            "https://scontent.cdninstagram.com/l/t51.2885-15/s640x640/e35/12783423_240906046242745_1164986462_n.jpg?ig_cache_key=MTE5MTU0MDUwMDk1OTU3NDAzNg%253D%253D.2",
            "https://scontent.cdninstagram.com/t51.2885-15/s640x640/e35/12747766_788911781214573_1500886810_n.jpg?ig_cache_key=MTE5MTUzMTc3OTMxNTQ0ODYyMg%253D%253D.2",
            "https://scontent.cdninstagram.com/t51.2885-15/s640x640/e35/12783415_1662427170648826_1291399988_n.jpg?ig_cache_key=MTE5MTEwMzU5MTE3NTkwNjU4OQ%253D%253D.2",
            "https://scontent.cdninstagram.com/t51.2885-15/s640x640/e35/12716514_254677984877817_56950437_n.jpg?ig_cache_key=MTE5MTQ2MDYwNjE3ODU2MDk1MA%253D%253D.2",
            "https://scontent.cdninstagram.com/t51.2885-15/s640x640/e35/12446048_875353972562195_1932785872_n.jpg?ig_cache_key=MTE5MTQzODk1MjExMTA4MTgyMw%253D%253D.2",
            "https://scontent.cdninstagram.com/t51.2885-15/s640x640/e35/12750296_897798193650893_1390433434_n.jpg?ig_cache_key=MTE5MTQzNjM3Mjg2NTc3OTk3Nw%253D%253D.2",
            "https://scontent.cdninstagram.com/t51.2885-15/s640x640/e35/12783892_163755587340119_904021412_n.jpg?ig_cache_key=MTE5MTA4MDYxMzIzMjcyMDI1NA%253D%253D.2.c"
        ]
        let urls = strings.flatMap { URL(string: $0) }
        DispatchQueue.global().async {
            let images = urls.flatMap { UIImage(data: try! Data(contentsOf: $0)) }
            DispatchQueue.main.async {
                let viewController = CollectionViewController(collectionViewLayout: UICollectionViewLayout())
                viewController.view.frame = UIScreen.main.bounds
                viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                viewController.images = images
                viewController.currentImage = viewController.images[Int(arc4random_uniform(UInt32(viewController.images.count)))]
                let navigationController = UINavigationController(rootViewController: viewController)
                navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
                navigationController.navigationBar.shadowImage = UIImage()
                navigationController.navigationBar.tintColor = .white
                navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
                navigationController.modalTransitionStyle = .crossDissolve
                navigationController.modalPresentationStyle = .overFullScreen
                self.present(navigationController, animated: true, completion: nil)
            }
        }
    }
    
}

class CollectionViewController: UICollectionViewController {
    
    var images = [UIImage]()
    var currentImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.navigationItem.title = "Scroll Me"
        
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        visualEffectView.frame = self.view.bounds
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.insertSubview(visualEffectView, at: 0)
        
        self.collectionView?.backgroundColor = .clear
        self.collectionView?.scrollsToTop = false
        self.collectionView?.decelerationRate = UIScrollViewDecelerationRateFast
        self.collectionView?.showsVerticalScrollIndicator = false
        self.collectionView?.register(Cell.self, forCellWithReuseIdentifier: "cell")
        
        let layout = Layout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        self.collectionView?.collectionViewLayout = layout
        
        if
            let image = currentImage,
            let item = images.index(of: image)
        {
            self.collectionView?.scrollToItem(at: IndexPath(item: item, section: 0), at: .centeredVertically, animated: false)
        }
    }
    
}

// MARK: - UICollectionViewDataSource
extension CollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
    }
    
}

// MARK: - UICollectionViewDelegate
extension CollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? Cell)?.imageView.image = images[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return images[indexPath.item].size.scaleAspectFit(boundingSize: collectionView.bounds.size)
    }
    
}

// MARK: - Layout
private class Layout: UICollectionViewFlowLayout {
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity) }
        var proposedContentOffset = proposedContentOffset
        let halfHeight = collectionView.bounds.height / 2
        proposedContentOffset.y += halfHeight
        proposedContentOffset.y += (velocity.y * halfHeight)
        let layoutAttributes = layoutAttributesForElements(in: collectionView.bounds)
        let closest = layoutAttributes?.sorted { abs($0.center.y - proposedContentOffset.y) < abs($1.center.y - proposedContentOffset.y) }.first ?? UICollectionViewLayoutAttributes()
        return CGPoint(x: proposedContentOffset.x, y: floor(closest.center.y - halfHeight))
    }
    
    override var collectionViewContentSize: CGSize {
        if
            let collectionView = collectionView,
            let first = layoutAttributesForItem(at: IndexPath(item: 0, section: 0)),
            let last = layoutAttributesForItem(at: IndexPath(item: collectionView.numberOfItems(inSection: 0) - 1, section: 0))
        {
            sectionInset = UIEdgeInsets(top: (collectionView.bounds.height / 2) - (first.bounds.height / 2), left: 0, bottom: (collectionView.bounds.height / 2) - (last.bounds.height / 2), right: 0)
        }
        return super.collectionViewContentSize
    }
    
}

// MARK: - Cell
private class Cell: UICollectionViewCell {
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = self.contentView.bounds
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.contentMode = .scaleAspectFit
        self.contentView.addSubview(imageView)
        return imageView
    }()
    
}

// MARK: - CGSize
private extension CGSize {
    
    func scaleAspectFit(boundingSize size: CGSize) -> CGSize {
        var rect = CGRect()
        rect.size = size
        return AVMakeRect(aspectRatio: self, insideRect: rect).size
    }
    
}
