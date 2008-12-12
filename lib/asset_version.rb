module ActionView::Helpers::AssetTagHelper  
  
  def javascript_include_tag_with_versioned(*sources)
    options = sources.extract_options!.stringify_keys!
    options['cache'] = version_cache_name(options['cache'], options.delete('version'))
    javascript_include_tag_without_versioned(sources, options)
  end

  def stylesheet_link_tag_with_versioned(*sources)
    options = sources.extract_options!.stringify_keys!
    options['cache'] = version_cache_name(options['cache'], options.delete('version'))
    stylesheet_link_tag_without_versioned(sources, options)
  end  
  
  def version_cache_name(cache_name, version)
    if cache_name
      cache_name = 'all' unless cache_name.is_a? String
      cache_name = 
        if version
          [cache_name, version].join('_')          
        else
          [cache_name, "some_uuid"].join('_')  
        end
    end
  end

  alias_method_chain :javascript_include_tag, :versioned
  alias_method_chain :stylesheet_link_tag, :versioned

end
