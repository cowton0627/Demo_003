//
//  ViewController.swift
//  Demo_003
//
//  Created by 鄭淳澧 on 2021/7/12.
//

import UIKit
import SwiftUI

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //宣告編輯框
    var activeTextField: UITextField!
    
    //編輯時, 儲存實體
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    //按下return 鍵盤收
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
//        self.view.endEditing(true)
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTextField.delegate = self
        passwordTextField.delegate = self
       
        /* 監聽 鍵盤顯示/隱藏 事件 */
        let center:NotificationCenter = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardShown),
                          name: UIResponder.keyboardWillShowNotification,
                          object: nil)
        center.addObserver(self, selector: #selector(keyboardHidden),
                          name: UIResponder.keyboardWillHideNotification,
                          object: nil)

    }
    
    
    @objc func keyboardShown(notification: Notification) {
        let info: NSDictionary = notification.userInfo! as NSDictionary
        //取得鍵盤尺寸
        let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        //鍵盤頂部 Y軸的位置
        let keyboardY = self.view.frame.height - keyboardSize.height
        //編輯框底部 Y軸的位置
        let editingTextFieldY = activeTextField.convert(activeTextField.bounds, to: self.view).maxY
        //相減得知, 編輯框有無被鍵盤擋住, > 0 有擋住, < 0 沒擋住, 即是擋住多少
        let targetY = editingTextFieldY - keyboardY
        
        //設置想要多移動的高度
        let offsetY: CGFloat = 20

        if self.view.frame.minY >= 0 {
            if targetY > 0 {
                UIView.animate(withDuration: 0.25, animations: {
                    self.view.frame = CGRect(x: 0, y:  -targetY - offsetY, width: self.view.bounds.width, height: self.view.bounds.height)
                })
            }
        }
    }
    
    
    @objc func keyboardHidden(notification: Notification) {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        })
    }
    
    
//    struct ViewControllerView: UIViewControllerRepresentable {
//        func makeUIViewController(context: Context) -> ViewController {
//             UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ViewController") as! ViewController
//        }
//
//        func updateUIViewController(_ uiViewController: ViewController, context: Context) {
//        }
//
//        typealias UIViewControllerType = ViewController
//
//    }
//
//
//    struct ViewControllerView_Previews: PreviewProvider {
//        static var previews: some View {
//            Group {
//                ViewControllerView()
//                    .previewDevice("iPhone 12 mini")
//            }
//        }
//    }

}

