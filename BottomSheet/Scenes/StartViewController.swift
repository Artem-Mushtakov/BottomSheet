//
//  StartViewController.swift
//  BottomSheet
//
//  Created by Artem Mushtakov on 14.12.2022.
//

import UIKit

final class StartViewController: UIViewController {

    private let openBottomSheetButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    private func setupLayout() {
        view.backgroundColor = .white
        view.addSubview(openBottomSheetButton)
        
        openBottomSheetButton.setTitle("Open ButtonSheet", for: .normal)
        openBottomSheetButton.center = view.center
        openBottomSheetButton.bounds.size = .init(width: 150, height: 50)
        openBottomSheetButton.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
    }
    
    @objc private func tapButton() {
        // modalTransitionStyle и modalPresentationStyle обязательны
        // для открытия BottomSheetViewController
        let vc = OpenBottomSheetViewController()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true)
    }
}
