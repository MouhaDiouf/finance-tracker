# frozen_string_literal: true

class Stock < ApplicationRecord
  has_many :user_stocks
  has_many :users, through: :user_stocks

  def self.find_by_ticker(ticker_symbol)
    where(ticker: ticker_symbol).first
  end

  def self.new_from_lookup(ticker_symbol)
    client = IEX::Api::Client.new(publishable_token: 'pk_54221c22e9e24c0b909729faf0a1fbbd')
    looked_up_stock = client.quote(ticker_symbol)
    #    price = strip_commas(looked_up_stock.l)
    new(name: looked_up_stock.company_name,
        ticker: looked_up_stock.symbol, last_price: looked_up_stock.latest_price)
  rescue Exception => e
    nil
  end

  def self.strip_commas(number)
    number.gsub(',', '')
  end
end
