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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "close"), style: .done, target: self, action: #selector(dismissButtonTapped))
        
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        visualEffectView.frame = self.view.bounds
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.insertSubview(visualEffectView, at: 0)
        
        self.collectionView?.backgroundColor = .clear
        self.collectionView?.scrollsToTop = false
        self.collectionView?.decelerationRate = UIScrollViewDecelerationRateFast
        self.collectionView?.showsVerticalScrollIndicator = false
        self.collectionView?.register(Cell.self, forCellWithReuseIdentifier: "cell")
//        self.collectionView?.registerNib(UINib(nibName: PhotoHeaderView.className, bundle: nil), forSupplementaryViewOfKind: PhotoHeaderView.className, withReuseIdentifier: PhotoHeaderView.className)
//        self.collectionView?.registerNib(UINib(nibName: PhotoFooterView.className, bundle: nil), forSupplementaryViewOfKind: PhotoFooterView.className, withReuseIdentifier: PhotoFooterView.className)
        
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
    
    @IBAction func dismissButtonTapped(_: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - UICollectionViewDataSource
extension CollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case "PhotoHeaderView", "PhotoFooterView":
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kind, for: indexPath)
        default:
            return UICollectionReusableView()
        }
    }
    
}

// MARK: - UICollectionViewDelegate
extension CollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? Cell)?.imageView.image = images[indexPath.item]
        
//        guard let
//            cell = cell as? PhotoCollectionViewCell,
//            image = images[safe: indexPath.item]
//            else { return }
//        
//        cell.configure(withImage: image)
//        
//        cell.setSelected(cell.selected, animated: false)
//        
//        cell.overlayView.buttonTapped = { _ in
//            guard let url = image.instagramUrl else { return }
//            UIApplication.sharedApplication().openURL(url)
//        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        guard
            let protocolView = view as? IGImageProtocol,
            let image = images[safe: indexPath.item]
        else { return }
        
        view.userInteractionEnabled = false
        
        protocolView.configure(withImage: image)
        
        let key = keyForElementKind(elementKind, atIndexPath: indexPath)
        visibleSupplementaryViews.setObject(view, forKey: key)
        
        if !collectionView.scrolling {
            scrollViewDidScroll(collectionView)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? PhotoCollectionViewCell)?.imageView.kf_cancelDownloadTask()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        let key = keyForElementKind(elementKind, atIndexPath: indexPath)
        visibleSupplementaryViews.removeObjectForKey(key)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return images[indexPath.item].size.scaleAspectFit(boundingSize: collectionView.bounds.size)
        
//        var center = collectionView.bounds.height / 2
//        center += collectionView.contentOffset.y
//        if let
//            aIndexPath = collectionView.indexPathsForVisibleItems().sort({ abs(collectionView.collectionViewLayout.layoutAttributesForItemAtIndexPath($0)!.center.y - center) < abs(collectionView.collectionViewLayout.layoutAttributesForItemAtIndexPath($1)!.center.y - center) }).first
//            where aIndexPath == indexPath
//        {
//            return true
//        } else {
//            collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredVertically, animated: true)
//            return false
//        }
    }
    
}

//// MARK: - UIScrollViewDelegate
//extension PhotoViewController {
//    
//    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
//        guard let collectionView = scrollView as? UICollectionView else { return }
//        collectionView.indexPathsForSelectedItems()?.forEach {
//            collectionView.deselectItemAtIndexPath($0, animated: true)
//        }
//    }
//    
//    override func scrollViewDidScroll(scrollView: UIScrollView) {
//        guard let collectionView = scrollView as? UICollectionView else { return }
//        var center = collectionView.bounds.height / 2
//        center += collectionView.contentOffset.y
//        collectionView.indexPathsForVisibleItems().forEach { indexPath in
//            guard let cell = collectionView.cellForItemAtIndexPath(indexPath) as? PhotoCollectionViewCell else { return }
//            
//            let alpha = max(0, 1 - (abs(cell.center.y - center) / (cell.bounds.height / 2)))
//            
//            [cell, visibleSupplementaryViews.objectForKey(keyForElementKind(PhotoHeaderView.className, atIndexPath: indexPath)), visibleSupplementaryViews.objectForKey(keyForElementKind(PhotoFooterView.className, atIndexPath: indexPath))].forEach {
//                ($0 as? IGImageProtocol)?.setContentAlpha(alpha)
//            }
//        }
//    }
//    
//}
//
//// MARK: - UICollectionViewDelegateFlowLayout
//extension PhotoViewController: UICollectionViewDelegateFlowLayout {
//    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        return images[safe: indexPath.item]?.thumbnailUrl.flatMap { UIImage.imageInMemory(withURL: $0) }?.size.scaleAspectFit(boundingSize: collectionView.bounds.size) ?? collectionView.bounds.size
//    }
//    
//}

// MARK: - Layout
private class Layout: UICollectionViewFlowLayout {
    
    var images = [IGImage]()
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes = super.layoutAttributesForElements(in: rect)!
        var array = [UICollectionViewLayoutAttributes]()
        array += layoutAttributes.flatMap { layoutAttributesForItem(at: $0.indexPath) }
        array += layoutAttributes.flatMap { layoutAttributesForSupplementaryView(ofKind: "PhotoHeaderView", at: $0.indexPath) }
        array += layoutAttributes.flatMap { layoutAttributesForSupplementaryView(ofKind: "PhotoFooterView", at: $0.indexPath) }
        return array
    }
    
//    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        guard let collectionView = collectionView, image = images[safe: indexPath.item] else { return nil }
//        let layoutAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)
//        let frame = layoutAttributesForItem(at: indexPath)!.frame
//        switch elementKind {
//        case PhotoHeaderView.className:
//            layoutAttributes.frame.size.height = 38
//            layoutAttributes.frame.origin.y = frame.minY - layoutAttributes.frame.size.height
//        case PhotoFooterView.className:
//            layoutAttributes.frame.origin.y = frame.maxY
//            layoutAttributes.frame.size.height = min((collectionView.bounds.height / 2) - (frame.height / 2), NSAttributedString(string: image.caption ?? "", minimumLineHeight: 20).calculatedHeight(frame.width) + 10)
//        default: break
//        }
//        layoutAttributes.frame.size.width = frame.width
//        layoutAttributes.zIndex = 1
//        return layoutAttributes
//    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var proposedContentOffset = proposedContentOffset
        guard let collectionView = collectionView else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity) }
        let halfHeight = collectionView.bounds.height / 2
        proposedContentOffset.y += halfHeight
        if -1...1 ~= velocity.y {
            proposedContentOffset.y += (velocity.y * halfHeight)
        }
        let layoutAttributes = layoutAttributesForElements(in: collectionView.bounds)?.filter { $0.representedElementCategory == .cell }
        let closest = layoutAttributes?.sorted { abs($0.center.y - proposedContentOffset.y) < abs($1.center.y - proposedContentOffset.y) }.first ?? UICollectionViewLayoutAttributes()
        return CGPoint(x: proposedContentOffset.x, y: floor(closest.center.y - halfHeight))
    }
    
//    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
//        guard let collectionView = collectionView else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity) }
//        var proposedContentOffset = proposedContentOffset
//        let halfHeight = collectionView.bounds.height / 2
//        proposedContentOffset.y += halfHeight
//        proposedContentOffset.y += (velocity.y * halfHeight)
//        let layoutAttributes = layoutAttributesForElements(in: collectionView.bounds)
//        let closest = layoutAttributes?.sorted { abs($0.center.y - proposedContentOffset.y) < abs($1.center.y - proposedContentOffset.y) }.first ?? UICollectionViewLayoutAttributes()
//        return CGPoint(x: proposedContentOffset.x, y: floor(closest.center.y - halfHeight))
//    }
    
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

struct Image {
    let image: UIImage?
    let url: URL?
    let caption: String?
    let user: User?
    init(image: UIImage?) {
        self.image = image
    }
    init(url: URL?) {
        self.url = url
    }
}

struct User {
    let username: String?
    let imageUrl: URL?
}
