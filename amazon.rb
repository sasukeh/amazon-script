# -*- coding: utf-8 -*-
require 'bundler'
Bundler.require

SCREENSHOTS_DIR = './screenshots'

module Amazon
  class Driver
    # 新しいタブで 指定された URL を開き、制御をそのタブに移す。
    def open_new_window(wd, url)
      a = wd.execute_script("var d=document,a=d.createElement('a');a.target='_blank';a.href=arguments[0];a.innerHTML='.';d.body.appendChild(a);return a", url)
      a.click
      wd.switch_to.window(wd.window_handles.last)

      wd.find_element(:link_text, '利用規約')
      yield
      wd.close
      wd.switch_to.window(wd.window_handles.last)
    end

    # 現在の画面からリンクが張られている購入明細を全て保存する。
    def save_order(wd)
      wd.find_element(:link_text, '利用規約')
      orders = wd.find_elements(:link_text, '領収書／購入明細書')
      orders.each do |ord|

        open_new_window(wd, ord.attribute('href')) do
          @order_seq += 1
          sleep 2
          wd.save_screenshot("#{SCREENSHOTS_DIR}/order_#{format('%03d', @order_seq)}.png")
        end
      end
    end

    def save_order_history(wd, auth, period)
      @page_seq = 0
      @order_seq = 0

      # 購入履歴ページへ
      wd.get 'https://www.amazon.co.jp/gp/css/order-history'

      # ログイン処理
      wd.find_element(:id, 'ap_email').click
      wd.find_element(:id, 'ap_email').clear
      wd.find_element(:id, 'ap_email').send_keys auth[:email]

      wd.find_element(:id, 'ap_password').click
      wd.find_element(:id, 'ap_password').clear
      wd.find_element(:id, 'ap_password').send_keys auth[:password]

      wd.find_element(:id, 'signInSubmit-input').click

      wd.find_element(:css, "span.a-dropdown-prompt").click  # 今年の注文
      wd.find_element(:css, "#dropdown1_#{period}").click

      # [次] ページをめくっていく
      loop do
        wd.find_element(:link_text, '利用規約')
        @page_seq += 1
        wd.save_screenshot("#{SCREENSHOTS_DIR}/page_#{format('%03d', @page_seq)}.png")
        open("#{SCREENSHOTS_DIR}/page_#{format('%03d', @page_seq)}.html", 'w') {|f|
          f.write wd.page_source
        }

        # ページ中の個々の注文を閲覧する。
        save_order(wd)

        elems = wd.find_elements(:link_text, '次へ→' )
        break if elems.size == 0
        elems[0].click
      end

      # サインアウト
      wd.get 'http://www.amazon.co.jp/gp/flex/sign-out.html/ref=gno_signout'
    end
  end
end

include Amazon

if ARGV.size != 3
  puts "usage: ruby #{$PROGRAM_NAME} account password period(確定されたx件の注文の選択肢上から順番に0,1,2,3.....)"
  exit 1
end

wd = nil
begin
  ad = Amazon::Driver.new
  Headless.ly do
    wd = Selenium::WebDriver.for :chrome
    wd.manage.timeouts.implicit_wait = 20 # 秒
    ad.save_order_history(wd, { email: ARGV[0], password: ARGV[1] }, ARGV[2])
  end
ensure
  wd.quit if wd
end
