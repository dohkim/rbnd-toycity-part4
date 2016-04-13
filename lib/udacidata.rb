require_relative 'find_by'
require_relative 'errors'
require 'csv'

class Udacidata
  # Your code goes here!
  $data_path = File.dirname(__FILE__) + "/../data/data.csv"
  
  
  def self.create(opts={})
    new_record = self.new(opts)
    new_record.save
    p new_record
  end
  
  def save
    CSV.open($data_path, "ab") do |csv|
      csv << [self.id, self.brand, self.name, self.price]
    end
  end
  
  def self.all
    list=[]
    CSV.read($data_path).drop(1).each do |row|
      list << self.new(id: row[0], brand: row[1], name: row[2], price: row[3])
    end
    p list
  end
  
  def self.first(n=1)
    list=self.all
    p list.first(n)
    if n==1
      p list.first
    else
      p list.first(n)
    end
  end
  
  def self.last(n=1)
      list=self.all
    if n==1
      p list.last
    else
      p list.last(n)
    end
  end
  
  def self.find(n)
    list=self.all
    if list[n-1]
      p list[n-1]
    else
      raise ProductNotFoundError, "#{self} ID : #{n} can't be found"
    end
      
    #raise ProductNotFoundError, "#{self} ID : #{n} can't be found" unless p list[n-1]
  end
  
  def self.destroy(n)
    remove_product=self.find(n)
    self.remove_product_in_db(n)
    p remove_product
  end
  
  def self.remove_product_in_db(n)
    table=CSV.table($data_path)
    table.delete_if do |row|
      row[:id]==n
    end
    File.open($data_path, 'w') do |f|
      f.write(table.to_csv)
    end
  end
  
  def self.where(hashes = {})
    lists=self.all
    hashes.each do |k,v|
      lists.select! do |list|
        value = list.send "#{k}"
        value == v
      end
    end
    lists
  end
  
  def update(hashes = {})
    new_lists=[]
    hashes.each do |k,v|
      accessor = %Q{
        def #{k}=(parameter)
          @#{k}= parameter
        end}
      self.class.class_eval(accessor)
      self.send("#{k}=", v)
    end
    
    CSV.foreach($data_path).with_index do |row, index|
      if index==self.id
        new_lists << [self.id, self.brand, self.name, self.price]
      else
        new_lists << row
      end
    end
    
    CSV.open($data_path, 'w') do |csv|
      new_lists.each do |list|
        csv << list
      end
    end
    self
  end
  
  def self.method_missing(method_name, *arguments, &block)
    attributes = self::ATTRIBUTES
    create_finder_methods(*attributes)
    self.send "#{method_name}", *arguments
  end
end


