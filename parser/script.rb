require 'open-uri'
require 'nokogiri'
require 'csv'
 

url = ARGV[0]
file_name = ARGV[1] + '.csv'
url_p = '?p='
page = Nokogiri::HTML(open URI.join(url + url_p + '1'))

last_page_number = page.xpath("//*[@id='pagination_bottom']/ul/li/a/span").text.strip.to_i	
if(last_page_number > 230)
	last_page_number = last_page_number - 230
end
if(last_page_number > 20)
	last_page_number = last_page_number - 20
end
puts "Колличество страниц #{last_page_number}"
for pg_number in 1..last_page_number do
puts "Считывание страницы #{pg_number}"
page_c = Nokogiri::HTML(open(url+url_p+pg_number.to_s))
last_link_product = page_c.xpath("//a[@class='product-name']/@href").size
 
     for link in 0..last_link_product-1 do
         link_product = page_c.xpath("//a[@class='product-name']/@href")[link].to_s
         page_p = Nokogiri::HTML(open(link_product))
         number_el_product = page_p.xpath(".//ul[@class='attribute_list']/ul").size
         name_product = page_p.xpath(".//p[@class='product_main_name']/span[@class='product_main_name_man']/text()").text.strip
         image_link = page_p.xpath(".//*[@id='bigpic']/@src").text.strip.to_s
         products = [] 
         if (number_el_product > 0)  
           for number in 0..number_el_product-1 do
             product_mass = page_p.xpath(".//ul[@class='attribute_list']/li/label/span[@class='radio_label']")[number].text.strip
             product_price = page_p.xpath(".//ul[@class='attribute_list']/li/label/span[@class='price_comb']")[number].text.strip
             product_name = ''+name_product+' - '+product_mass+''
             products.push(
                Name: product_name,
                Price: product_price,
                Image: image_link,
             )
           end
         else 
             product_price = page_p.xpath(".//*[@id='our_price_display']").text.strip
             product_name = "#{name_product}"
             products.push(
                Name: product_name,
                Price: product_price,
                Image: image_link,
             )
         end 
		 File.open(file_name, 'a') do |csv|
			products.each do |item|
			csv << "#{item[:Name]};#{item[:Price]};#{item[:Image]}\n"     
	   end
	   end
     end
puts 'Завершено'  

end