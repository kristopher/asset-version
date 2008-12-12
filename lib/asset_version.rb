module ActionView::Helpers::AssetTagHelper  
  
  def javascript_include_tag_with_versioned(*sources)
    set_cache_options_with_versioning_from_sources!(sources)
    javascript_include_tag_without_versioned(*sources)
    
  end

  def stylesheet_link_tag_with_versioned(*sources)
    set_cache_options_with_versioning_from_sources!(sources)
    stylesheet_link_tag_without_versioned(*sources)
  end  
  
  alias_method_chain :javascript_include_tag, :versioned
  alias_method_chain :stylesheet_link_tag, :versioned

  private   
    def set_cache_options_with_versioning_from_sources!(sources)
      options = sources.extract_options!.stringify_keys!
      options['cache'] = version_cache_name(options['cache'], options.delete('version'))
      sources << options
    end
    
    def version_cache_name(cache_name, version)
      if cache_name
        cache_name = 'all' unless cache_name.is_a? String
        cache_name = 
          if version
            [cache_name, version].join('_')          
          else
            [cache_name, Time.now.to_i].join('_')  
          end
      end
    end


end
