//
//  UiViewController+ext.swift
//  Task7
//
//  Created by Вадим Сайко on 28.01.23.
//

import UIKit

extension UIViewController {
    func wrongNumber() {
        let alertController = UIAlertController(
            title: "Неверное число",
            message: "Ваше число должно быть не меньше 1 и не больше 1024. Вы можете использовать только одну ., если Вам необходимо десятичное число",
            preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Закрыть", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    func serverResponse(response: Response) {
        let alertController = UIAlertController(
            title: "Ответ сервера",
            message: response.result,
            preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Закрыть", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
}
