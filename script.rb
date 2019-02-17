require 'open-uri'
require 'nokogiri'
require 'csv'
require 'watir'

puts "Enter the link:"
link = gets.chomp()

puts "Enter the name of the file:"
fileName = gets.chomp()

CSV.open(fileName, "a") do |titles|
    titles << ["Name\;Price\;Image"]
end

browser = Watir::Browser.new
browser.goto link
sleep 50
openLink = browser.html
getInformation = Nokogiri::HTML(openLink)

getInformation.css(".pro_first_box").each do |pro_first_box|

    getLink = pro_first_box.css('.product_img_link')[0]["href"]

    openLink = open(getLink)
    getInformation = Nokogiri::HTML(openLink)
    recInformation = []

    getInformation.css(".primary_block").each do |primary_block|

        productName = primary_block.css('.nombre_fabricante_bloque h1').text.strip
        productWeight = primary_block.css('.radio_label').text.strip
        productPrice = primary_block.css('.price_comb').text.to_f
        productImage = primary_block.css('#bigpic')[0]["src"]

        recInformation.push(
            name: productName + " - ",
            weight: productWeight + "\;",
            price: productPrice,
            image: "\;" + productImage
        )

        CSV.open(fileName, "a") do |productInformation|
            recInformation.each do |x|
                productInformation << x.values
                puts ""
                print x.values
            end
        end

    end
end