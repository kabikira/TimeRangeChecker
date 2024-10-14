## Time Range Checker  
<img width="150" src="https://github.com/user-attachments/assets/0009250a-2cbd-43d8-a26d-39ca08bd6ebc">  
<img width="150" src="https://github.com/user-attachments/assets/274ab4da-d9fd-4811-b333-204b128b6419">  
<img width="150" src="https://github.com/user-attachments/assets/c5875b85-9d3e-4974-9833-661e32caf7f8">  
　　
<img height="150" src="https://github.com/user-attachments/assets/8cd8a9d9-df2f-47f2-9102-7a7d895ca84b">  
<img height="150" src="https://github.com/user-attachments/assets/523f84c4-f0dd-485f-9de2-e249192b0a9f">  

### 概要
Time Range Checker は、指定された時刻が設定した時間範囲内に含まれているかどうかを判定するiOSアプリです。開始時刻と終了時刻を整数で指定し、結果をアプリ内に保存して、後から確認することができます。夜間をまたぐ範囲もサポートしています。

### 機能
- **時刻の範囲判定**：指定した時刻が、指定した開始時刻から終了時刻の範囲内に含まれるかどうかを判定します。  
- **結果の保存**：判定結果（開始時刻、終了時刻、指定時刻、判定結果）を CoreData を使用してデバイスに保存します。
- **結果の一覧表示**：保存した判定結果をテーブルビューで確認できます。
- **夜間範囲対応**：開始時刻が22時、終了時刻が5時など、夜間をまたぐ時間範囲もサポートします。
  
### 開発環境
- **言語**: Swift
- **ターゲットOS**: iOS 14.0 以上
- **アーキテクチャ**: MVC
- **ライブラリ**: 
  - SwiftLint（コードスタイルのチェック）
  - IQKeyboardManager（ナンバーパッドを閉じる実装のため）
  - IQKeyboardToolbarManager

### 実装詳細
- **データ管理**：Core Data を使用して、開始時刻、終了時刻、判定対象の時刻、および判定結果を保存します。

- **入力画面**：開始時刻、終了時刻、チェック時刻を整数で入力し、判定結果を表示します。
- **履歴画面**：保存された判定結果をテーブルビューで表示します。セルは再利用可能で、判定結果が反映されます。

- **ユニットテスト実装**：主なロジックとなるCoreDataManagerのテストコード実装  

