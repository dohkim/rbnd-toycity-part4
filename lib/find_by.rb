class Module
  def create_finder_methods(*attributes)
    attributes.each do |attribute|
      attribute = attribute.to_s.delete("@")
      find_by_method= %Q{
        def find_by_#{attribute} (parameter)
          lists=self.all
          find_result=lists.select do |list|
            list.#{attribute} == parameter
          end
          find_result.first
        end
      }
      self.instance_eval(find_by_method)
    end
  end
  
end
