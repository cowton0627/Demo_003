//
//  ViewController.swift
//  Demo_003
//
//  Created by 鄭淳澧 on 2021/7/12.
//

import UIKit
//import FirebaseAuth
import FacebookLogin
import GoogleSignIn

/// 登入頁面 VC
class ViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - IBOutlet
    @IBOutlet weak var fbLoginBtn: UIButton!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // 宣告編輯框
    var activeTextField: UITextField!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextField()
       
        // 監聽鍵盤顯示與隱藏
        let center:NotificationCenter = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardShown),
                          name: UIResponder.keyboardWillShowNotification,
                          object: nil)
        center.addObserver(self, selector: #selector(keyboardHidden),
                          name: UIResponder.keyboardWillHideNotification,
                          object: nil)
        
        // 加入註冊資料
//        Auth.auth().createUser(withEmail: "newton0627@frs.com", password: "1314520") { result, error in
//            guard let user = result?.user, error == nil else {
//                print(error?.localizedDescription)
//                return
//            }
//            print(user.email, user.uid)
//        }
        
        
        /// 邏輯測試1, 若在 viewDidLoad 中檢查 token, 若正確則隱藏 fbLoginBtn
//        if let token = AccessToken.current, !token.isExpired {
//            fbLoginBtn.isHidden = true
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // 檢查 FB Login token 決定是否登入
        if let token = AccessToken.current, !token.isExpired {
            performSegue(withIdentifier: "LoginToWelcome", sender: nil)
        }
        
        // 檢查 Google Login 決定是否登入
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error != nil || user == nil {
                print("Stay at or Come back to Login Page.")
            } else {
                self.performSegue(withIdentifier: "LoginToWelcome", sender: nil)
            }
            
        }
        
    }
    
    // MARK: - func
    // 編輯時, 儲存實體
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    // 按下return, 鍵盤收
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func configureTextField() {
        userNameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    // MARK: - IBAction
    @IBAction func signUpBtnTapped(_ sender: Any) {
        let signUpAlert = UIAlertController(title: "註冊帳號", message: "", preferredStyle: .alert)
        
        signUpAlert.addTextField { (emailSignUpTextField) in
            emailSignUpTextField.placeholder = "請輸入Email"
        }
        
        signUpAlert.addTextField { (passwordSignUpTextField) in
            passwordSignUpTextField.placeholder = "請輸入password"
            passwordSignUpTextField.isSecureTextEntry = true
        }
        
        let saveAction = UIAlertAction(title: "送出", style: .default) { (action) in
            let emailTextField = signUpAlert.textFields![0]
            let passwordTextField = signUpAlert.textFields![1]
            
//            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
//
//                    if error == nil {
//                        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: nil)
//                    } else {
//                        let alert = UIAlertController(title: "Caution", message: error?.localizedDescription, preferredStyle: .alert)
//                        let backAction = UIAlertAction(title: "Back", style: .cancel, handler: nil)
//                        alert.addAction(backAction)
//                        self.present(alert, animated: true, completion: nil)
//                    }
//            })
        }
                
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                
        signUpAlert.addAction(saveAction)
        signUpAlert.addAction(cancelAction)
                
        present(signUpAlert, animated: true, completion: nil)
        
    }
    
    /// 只使用 Google 登入時
    @IBAction func googleBtnTapped(_ sender: Any) {
        let signInConfig = GIDConfiguration(clientID: "1016905938526-96mub16ag1ep1a37mdfui8qibghsu0a2.apps.googleusercontent.com")
        GIDSignIn.sharedInstance.signIn(with: signInConfig,
                                        presenting: self) { user, error in
            guard error == nil else { return }
            guard let user = user else { return }
            print(user.profile?.email ?? "none of email.")
            print(user.profile?.name ?? "none of name.")
            print(user.profile?.givenName ?? "none of givenName.")
            print(user.profile?.familyName ?? "none of familyName.")
            self.performSegue(withIdentifier: "LoginToWelcome", sender: nil)
        }
    }
    
    @IBAction func fbLoginBtnTapped(_ sender: Any) {
        /// 只使用FB登入時
        let fbManager = LoginManager()
        fbManager.logIn(permissions: [.publicProfile, .email]) { result in
            
           switch result {
           case .success(granted: _, declined: _, token: _):
               self.performSegue(withIdentifier: "LoginToWelcome", sender: sender)
               print("success")
           case .cancelled:
               print("cancelled")
           case .failed(_):
               print("failed")
           }
        }
        
//        fbManager.logIn { result in
//           if case LoginResult.success(granted: _, declined: _, token: _) = result {
//               print("login ok")
//            self.performSegue(withIdentifier: "LoginToWelcome", sender: sender)
//           } else {
//               print("login fail")
//           }
//        }
        
        //透過Firebase檢驗FB登入
//        let manager = LoginManager()
//        manager.logIn(permissions: [.publicProfile], viewController: self) { (result) in
//            if case LoginResult.success(granted: _, declined: _, token: let token) = result {
//                print("fb login ok")
//
////                let credential =  FacebookAuthProvider.credential(withAccessToken: token!.tokenString)
////                    Auth.auth().signIn(with: credential) { [weak self] (result, error) in
////                    guard let self = self else { return }
////                    guard error == nil else {
////                        print(error!.localizedDescription)
////                        return
////                    }
////                    print("login ok")
////                    self.performSegue(withIdentifier: "LoginToWelcome", sender: sender)
////                }
//
//            } else {
//                print("login fail")
//            }
//        }
    }
    
    
    /// unwindSegue，為按下歡迎頁面 logout 後跳轉回此頁，需將 FB、Google 都 logout
    @IBAction func unwindToViewController(_ unwindSegue: UIStoryboardSegue) {
        userNameTextField.text = ""
        passwordTextField.text = ""
        
//        do {
//           try Auth.auth().signOut()
//        } catch {
//           print(error)
//        }
        
        // FB Logout
        let manager = LoginManager()
        manager.logOut()
        // Google Logout
        GIDSignIn.sharedInstance.signOut()

        
        /// 邏輯測試1.1, 此時登出 token 仍為原 token, fbLoginBtn 需重現
//        fbLoginBtn.isHidden = false
    }
    
    
    @IBAction func loginBtnTapped(_ sender: Any) {
        //繁瑣的檢查過程
//        if userNameTextField.text == "newton0627@frs.com" && passwordTextField.text == "1314520" {
//            performSegue(withIdentifier: "LoginToWelcome", sender: sender)
//
//        } else if userNameTextField.text == "newton0627@frs.com" && passwordTextField.text != "1314520"{
//            let alert = UIAlertController(title: "注意", message: "密碼錯誤", preferredStyle: .alert)
//            let alertAction = UIAlertAction(title: "返回", style: .cancel) { [self] alertAction in
//                    userNameTextField.text = ""
//                    passwordTextField.text = ""
//
//            }
//            alert.addAction(alertAction)
//            present(alert, animated: true, completion: nil)
//
//        } else if userNameTextField.text != "newton0627@frs.com" &&
//                    passwordTextField.text == "1314520" {
//            let alert = UIAlertController(title: "注意", message: "請輸入正確帳號", preferredStyle: .alert)
//            let alertAction = UIAlertAction(title: "返回", style: .cancel) { [self] alertAction in
//                userNameTextField.text = ""
//                passwordTextField.text = ""
//
//        }
//            alert.addAction(alertAction)
//            present(alert, animated: true, completion: nil)
//        } else if userNameTextField.text == "" || passwordTextField.text == "" {
//            let alert = UIAlertController(title: "注意", message: "帳號或密碼不得為空", preferredStyle: .alert)
//            let alertAction = UIAlertAction(title: "返回", style: .cancel, handler: nil)
//            alert.addAction(alertAction)
//            present(alert, animated: true, completion: nil)
//
//        } else {
//            let alert = UIAlertController(title: "注意", message: "帳號密碼錯誤", preferredStyle: .alert)
//            let alertAction = UIAlertAction(title: "返回", style: .cancel) { [self] alertAction in
//                userNameTextField.text = ""
//                passwordTextField.text = ""
//
//        }
//            alert.addAction(alertAction)
//            present(alert, animated: true, completion: nil)
//
//        }
        
        //簡單的檢查過程
//        Auth.auth().signIn(withEmail: userNameTextField.text!, password: passwordTextField.text!) { result, error in
//
//            if error == nil {
//                self.performSegue(withIdentifier: "LoginToWelcome", sender: sender)
//            } else {
//                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
//                let backAction = UIAlertAction(title: "Back", style: .cancel, handler: nil)
//                alert.addAction(backAction)
//                self.present(alert, animated: true, completion: nil)
//            }
//        }
        
        
    }
    
    
    
    
    // MARK: - objc func
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
    
}

