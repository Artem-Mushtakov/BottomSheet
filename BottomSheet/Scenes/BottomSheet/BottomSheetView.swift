//
//  BottomSheetView.swift
//  BottomSheet
//
//  Created by Artem Mushtakov on 14.12.2022.
//

import UIKit

private enum Appearance {
    static let separatorCornerRadius: CGFloat = 2
    static let  separatorTopOffset: CGFloat = 6
    static let  separatorHeight: CGFloat = 4
    static let  separatorWidth: CGFloat = 52
    static let  dismissibleHeight: CGFloat = 200
    static let  maximumContainerHeight: CGFloat = UIScreen.main.bounds.height - 64
    static let  currentContainerHeight: CGFloat = 0
    static let  backgroundAlpha: CGFloat = 0.6
    static let  containerViewSpacing: CGFloat = 12
    static let  animateContainerHeightDuration: TimeInterval = 0.1
    static let  animateDismissViewDuration: TimeInterval = 0.3
    static let containerViewCornerRadius: CGFloat = 12
}

final class BottomSheetView: UIView {
    
    // MARK: - Properties
    
    var dismissViewController: (() -> ())?
    
    private let defaultHeight: CGFloat
    
    private var currentContainerHeight: CGFloat
    
    private lazy var dismissibleHeight = Appearance.dismissibleHeight
    
    private lazy var maximumContainerHeight = Appearance.maximumContainerHeight
    
    private var containerViewHeightConstraint: NSLayoutConstraint?
    
    private var containerViewBottomConstraint: NSLayoutConstraint?
    
    private lazy var containerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.layer.cornerRadius = Appearance.containerViewCornerRadius
        stackView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        // цвет контейнера bottom Sheet
        stackView.backgroundColor = .white
        stackView.spacing = Appearance.containerViewSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = Appearance.backgroundAlpha
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var separator: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(Appearance.backgroundAlpha)
        view.layer.cornerRadius = Appearance.separatorCornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(_ contentView: UIView, height: CGFloat) {
        defaultHeight = height
        currentContainerHeight = height
        super.init(frame: .zero)
        containerView.addArrangedSubview(contentView)
        configureView()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        currentUpdateConstraints()
    }
    
    private func addSubviews() {
        addSubview(backgroundView)
        addSubview(containerView)
        containerView.addSubview(separator)
    }
    
    private func makeConstraints() {
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: defaultHeight)
        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: defaultHeight)
        containerViewHeightConstraint?.isActive = true
        containerViewBottomConstraint?.isActive = true
    }
    
    private func configureView() {
        backgroundColor = .clear
        
        backgroundView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(handleCloseAction))
        )
        
        addSubviews()
        makeConstraints()
        setupPanGesture()
    }
    
    /// Анимация открытия контроллера
    func animatePresentContainer() {
        UIView.animate(withDuration: Appearance.animateContainerHeightDuration) {
            self.containerViewBottomConstraint?.constant = .zero
            self.layoutIfNeeded()
        }
    }
    
    /// Вызываем во layoutSubviews тк при изменении высоты нужно перерисовывать UI
    private func currentUpdateConstraints() {
        NSLayoutConstraint.activate([
            separator.topAnchor.constraint(equalTo: topAnchor, constant: Appearance.separatorTopOffset),
            separator.widthAnchor.constraint(equalToConstant: Appearance.separatorWidth),
            separator.heightAnchor.constraint(equalToConstant: Appearance.separatorHeight),
            separator.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    /// Настройка жестов
    private func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(gesture:)))
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        addGestureRecognizer(panGesture)
    }
    
    /// Обработка жестов
    @objc private func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        let newHeight = currentContainerHeight - translation.y
        
        switch gesture.state {
        case .changed:
            if newHeight < maximumContainerHeight {
                containerViewHeightConstraint?.constant = newHeight
                layoutIfNeeded()
            }
        case .ended:
            newHeight < dismissibleHeight
            ? animateDismissView()
            : animateContainerHeight(defaultHeight)
        default:
            break
        }
    }
    
    /// Закрытие контроллера при тапе на фоновую вью
    @objc private func handleCloseAction() {
        animateDismissView()
    }
    
    /// Анимация изменения высоты
    private func animateContainerHeight(_ height: CGFloat) {
        UIView.animate(withDuration: Appearance.animateContainerHeightDuration) {
            self.containerViewHeightConstraint?.constant = height
            self.layoutIfNeeded()
        }
        
        currentContainerHeight = height
    }
    
    /// Анимация закрытия вью
    private func animateDismissView() {
        UIView.animate(withDuration: Appearance.animateDismissViewDuration) {
            self.backgroundView.alpha = .zero
        } completion: { [weak self] _ in
            self?.dismissViewController?()
        }
        
        UIView.animate(withDuration: Appearance.animateDismissViewDuration) {
            self.containerViewBottomConstraint?.constant = self.defaultHeight
            self.layoutIfNeeded()
        }
    }
}

