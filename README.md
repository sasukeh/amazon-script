# amazon領収書一括で、作れるマン
確認環境は、OSX 10.10のみです。

多分、2.0系のRubyが入っていれば動きます。

setup.sh がありますが、保証しません。

** PR歓迎。 **

# よくわからない人向け
1. Firefox, [こ↑れ↓](http://release.seleniumhq.org/selenium-ide/2.9.0/selenium-ide-2.9.0.xpi)をダブルクリック
2. setup.sh をダブルクリック(途中にパスワード聞かれるよ)
3. get_screenshots.sh をダブルクリック(途中にメッセージ出てくるよ)
4. convert_pdf.sh をダブルクリック
5. このフォルダ内部に 領収書.pdf ができたよ

# わかっている人向け
 - Firefox, [Selenium IDE](http://release.seleniumhq.org/selenium-ide/2.9.0/selenium-ide-2.9.0.xpi), ImageMagick, bundlerが必要だよっ
 - bundle しよう
 - `$ ruby amazon.rb email password period(確定されたx件の注文の選択肢上から順番に0,1,2,3.....)`
 - `$ convert -gravity north -background white screenshot/order_*.png 領収書.pdf`

元の人: http://qiita.com/katoy/items/2256ad7b59b8f59161cf
