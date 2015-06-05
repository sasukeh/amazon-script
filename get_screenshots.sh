#!/usr/bin/env ruby

puts 'アカウント名'
account = gets.chomp
puts 'パスワード'
password = gets.chomp
puts "https://www.amazon.co.jp/gp/your-account/order-historyの確定されたx件の注文の選択肢上から順番に0,1,2,3....."
`ruby amazon.rb #{account} #{password} #{gets}`
