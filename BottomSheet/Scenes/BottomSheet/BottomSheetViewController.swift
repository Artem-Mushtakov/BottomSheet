//
//  BottomSheetViewController.swift
//  BottomSheet
//
//  Created by Artem Mushtakov on 14.12.2022.
//

import UIKit

class BottomSheetViewController: UIViewController {
    
    private let bottomSheetView: BottomSheetView
    
    init(_ contentView: UIView, height: CGFloat) {
        bottomSheetView = BottomSheetView(contentView, height: height)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = bottomSheetView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bottomSheetView.dismissViewController = { [weak self] in
            self?.dismiss(animated: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Вызываем анимацию показа вью, после открытия контроллера
        // для анимированного показа шторки
        bottomSheetView.animatePresentContainer()
    }
}
