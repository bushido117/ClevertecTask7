//
//  TableViewFooter.swift
//  Task7
//
//  Created by Вадим Сайко on 24.01.23.
//

import UIKit
import SnapKit

final class FooterView: UIView {
    private lazy var sendButton: UIButton = {
        let button = UIButton(configuration: .borderedTinted())
        button.setTitle("Отправить", for: .normal)
        button.addTarget(self, action: #selector(sendData), for: .touchUpInside)
        return button
    }()
    
    var onDarkThemeButtonTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(sendButton)
        setupConstraints()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        sendButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalToSuperview()
        }
    }
    
    @objc func sendData() {
        onDarkThemeButtonTapped?()
    }
}
