//
//  FlowLayoutView.swift
//  VideoDemo
//
//  Created by 강관구 on 2022/02/24.
//

import SwiftUI
import UIKit

class AlbumPrivateCell: UICollectionViewCell {
    private static let reuseId = "AlbumPrivateCell"

    static func registerWithCollectionView(collectionView: UICollectionView) {
        collectionView.register(AlbumPrivateCell.self, forCellWithReuseIdentifier: reuseId)
    }

    static func getReusedCellFrom(collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> AlbumPrivateCell{
        return collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! AlbumPrivateCell
    }
    
    override func prepareForReuse() {
        // 재사용시 이미지 지워줘야함
    }

    var albumView: UILabel = {
        let label = UILabel()
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(self.albumView)
    }

    required init?(coder: NSCoder) {
        fatalError("init?(coder: NSCoder) has not been implemented")
    }
}

struct AlbumGridView: UIViewRepresentable {
    @Binding var currentIndex: Int
    var data = [1,2,3,4,5,6,7,8,9]
    
    init(currentIndex: Binding<Int>) {
        _currentIndex = currentIndex
    }

    func makeUIView(context: Context) -> UICollectionView {
        let layout = CenteredCollectionViewLayout(currentIndex: $currentIndex)
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 36, height: 48)
        layout.minimumLineSpacing = 4
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.setCollectionViewLayout(layout, animated: false)
        collectionView.dataSource = context.coordinator
        collectionView.delegate = context.coordinator

        AlbumPrivateCell.registerWithCollectionView(collectionView: collectionView)
        return collectionView
    }

    func updateUIView(_ uiView: UICollectionView, context: Context) {
        
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        private let parent: AlbumGridView

        init(_ albumGridView: AlbumGridView) {
            self.parent = albumGridView
        }

        // MARK: UICollectionViewDataSource
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            self.parent.data.count
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let albumCell = AlbumPrivateCell.getReusedCellFrom(collectionView: collectionView, cellForItemAt: indexPath)
            albumCell.backgroundColor = .red
            return albumCell
        }

        // 가운데서 시작하도록 패딩
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            guard let flowLayout = collectionViewLayout as? CenteredCollectionViewLayout else {
                return .zero
            }
            let padding = (collectionView.frame.size.width - flowLayout.itemSize.width) / 2.0
            return UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
        }
    }
}

class CenteredCollectionViewLayout: UICollectionViewFlowLayout {
    var previousOffset: CGFloat    = 0
    @Binding var currentIndex: Int
    
    init(currentIndex: Binding<Int>) {
        _currentIndex = currentIndex
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
    }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {

        guard let collectionView = self.collectionView else {
            return CGPoint.zero
        }

        guard let itemsCount = collectionView.dataSource?.collectionView(collectionView, numberOfItemsInSection: 0) else {
            return CGPoint.zero
        }

        if (previousOffset > collectionView.contentOffset.x) && (velocity.x < 0) {
            currentIndex = max(currentIndex - 1, 0)
        } else if (previousOffset < collectionView.contentOffset.x) && (velocity.x > 0.0) {
            currentIndex = min(currentIndex + 1, itemsCount - 1)
        }

        let insetLeft = (collectionView.frame.size.width - itemSize.width) / 2.0
        let itemEdgeOffset: CGFloat = (collectionView.frame.width - itemSize.width -  minimumLineSpacing * 2) / 2
        let updatedOffset: CGFloat = (itemSize.width + minimumLineSpacing) * CGFloat(currentIndex) - (itemEdgeOffset + minimumLineSpacing) + insetLeft

        previousOffset = updatedOffset

        return CGPoint(x: updatedOffset, y: proposedContentOffset.y)
    }
}
