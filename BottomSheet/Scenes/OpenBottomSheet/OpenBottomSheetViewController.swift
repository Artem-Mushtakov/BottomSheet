//
//  OpenBottomSheetViewController.swift
//  BottomSheet
//
//  Created by Artem Mushtakov on 14.12.2022.
//

import UIKit

final class OpenBottomSheetViewController: BottomSheetViewController {
    
    private let contentView: OpenBottomSheetView
    
    init() {
        contentView = OpenBottomSheetView()
        // передаем контент вью и высоту шторки
        super.init(contentView, height: 500)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
