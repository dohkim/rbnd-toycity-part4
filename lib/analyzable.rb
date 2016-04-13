module Analyzable
    def average_price(lists)
        sum=lists.each.inject(0) {|total, list| total + list.price.to_f }/lists.length
        sum.round(2)
    end
    
    def print_report(lists)
        report=[]
        report << "#=> Average Price: $#{average_price(lists)}"
        report << "Inventory by Brand:"
        count_by_brand(lists).each do |k, v|
            report << " - #{k}: #{v}"
        end
        report << "Inventory by Name:"
        count_by_name(lists).each do |k, v|
            report << " - #{k}: #{v}"
        end
        puts report
        return report.to_s
    end
    
    def self.method_missing(method_name, *arguments, &block)
        attributes = ["id", "brand", "name","price"]
        attributes.each do |attribute|
          count_by_method= %Q{
            def count_by_#{attribute} (lists)
                count=Hash.new(0)
                lists.each do |list|
                    count[list.#{attribute}] += 1
                end
                count
            end
          }
         self.class_eval(count_by_method)
        end
        send "#{method_name}", *arguments
    end
end