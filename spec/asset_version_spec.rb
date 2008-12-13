require File.join(File.dirname(__FILE__), 'spec_helper')  

describe 'AssetVersion' do
  before(:each) do
    @action_view_instance = ActionView::Base.new
  end
    
  describe 'version_cache_name' do    

    it "should return the given cache_name if version and ASSET_VERSION is not defined" do
      @action_view_instance.send(:version_cache_name, true, nil).should be true    
    end
    
    it "should set the cache name to 'all' if it is pass as true" do
      @action_view_instance.send(:version_cache_name, true, '1234').should =~ /^all_/            
    end
    
    describe 'using ASSET_VERSION' do

      before(:all) do
        ::ASSET_VERSION = nil
      end
      
      it "should return the given cache_name if version is nil and ASSET_VERSION is nil" do
        @action_view_instance.send(:version_cache_name, true, nil).should be true          
      end

      it "should return the cache name with the ASSET_VERSION appended" do
        ::ASSET_VERSION = '1234'
        @action_view_instance.send(:version_cache_name, 'test', nil).should == 'test_1234'                 
      end    

    end
    
    describe 'using version' do

      it "should return the cache name with the version appended" do
        @action_view_instance.send(:version_cache_name, 'test', '1234').should == 'test_1234'                 
      end    

    end

  end
  
  describe 'set_cache_options_with_versioning_from_sources!' do

    before(:each) do
      @sources = ['test', 'test2', { :cache => true, :version => '1234' }]
    end

    it "should call version_cache_name" do
      @action_view_instance.should_receive(:version_cache_name)
      @action_view_instance.send(:set_cache_options_with_versioning_from_sources!, @sources)
    end
    
    describe 'sources' do
      it "should be an array of sources" do
        @action_view_instance.send(:set_cache_options_with_versioning_from_sources!, @sources).should be an_instance_of Array      
      end
      
      it "should have options key 'cache'" do
        @action_view_instance.send(:set_cache_options_with_versioning_from_sources!, @sources).extract_options!.should have_key 'cache'           
      end
      
      it "should not have options key 'version'" do
        @action_view_instance.send(:set_cache_options_with_versioning_from_sources!, @sources).extract_options!.should_not have_key 'version'           
      end      
      
      it "should have options cache value set to the version_cache_name" do
        cache_name = @action_view_instance.send(:version_cache_name, true, '1234')
        @action_view_instance.send(:set_cache_options_with_versioning_from_sources!, @sources).extract_options!['cache'].should == cache_name                   
      end
    end

  end
  
  describe 'javascript_include_tag_with_versioned' do

    before(:each) do
      ::ASSET_VERSION = nil
      @action_view_instance.stub!(:javascript_include_tag_without_versioned)
    end

    it "should call set_cache_options_with_versioning_from_sources!" do
      @action_view_instance.should_receive(:set_cache_options_with_versioning_from_sources!).with(['test', 'test2', { :cache => true }])
      @action_view_instance.javascript_include_tag_with_versioned('test', 'test2', :cache => true)
    end  
    
    it "should call javascript_include_tag_without_versioned" do
      @action_view_instance.should_receive(:javascript_include_tag_without_versioned).with('test', 'test2', 'cache' => true )
      @action_view_instance.javascript_include_tag_with_versioned('test', 'test2', :cache => true)      
    end
    
    it "should call javascript_include_tag_without_versioned with the proper cache_name when version option is passed" do
      @action_view_instance.should_receive(:javascript_include_tag_without_versioned).with('test', 'test2', 'cache' => 'test_all_1234' )
      @action_view_instance.javascript_include_tag_with_versioned('test', 'test2', :cache => 'test_all', :version => '1234')          
    end

    it "should call javascript_include_tag_without_versioned with the proper cache_name when ASSET_VERSION is set" do
      ::ASSET_VERSION = '1234'
      @action_view_instance.should_receive(:javascript_include_tag_without_versioned).with('test', 'test2', 'cache' => 'test_all_1234' )
      @action_view_instance.javascript_include_tag_with_versioned('test', 'test2', :cache => 'test_all')          
    end

  end
  
  describe 'stylesheet_link_tag_with_versioned' do

    before(:each) do
      ::ASSET_VERSION = nil    
      @action_view_instance.stub!(:stylesheet_link_tag_without_versioned)
    end

    it "should call set_cache_options_with_versioning_from_sources!" do
      @action_view_instance.should_receive(:set_cache_options_with_versioning_from_sources!).with(['test', 'test2', { :cache => true }])
      @action_view_instance.stylesheet_link_tag_with_versioned('test', 'test2', :cache => true )
    end    

    it "should call stylesheet_link_tag_without_versioned" do
      @action_view_instance.should_receive(:stylesheet_link_tag_without_versioned).with('test', 'test2', 'cache' => true)
      @action_view_instance.stylesheet_link_tag_with_versioned('test', 'test2', :cache => true)      
    end

    it "should call stylesheet_link_tag_without_versioned with the proper cache_name when version options is passed" do
      @action_view_instance.should_receive(:stylesheet_link_tag_without_versioned).with('test', 'test2', 'cache' => 'test_all_1234' )
      @action_view_instance.stylesheet_link_tag_with_versioned('test', 'test2', :cache => 'test_all', :version => '1234')          
    end

    it "should call stylesheet_link_tag_without_versioned with the proper cache_name when ASSET_VERSION is set" do
      ::ASSET_VERSION = '1234'
      @action_view_instance.should_receive(:stylesheet_link_tag_without_versioned).with('test', 'test2', 'cache' => 'test_all_1234' )
      @action_view_instance.stylesheet_link_tag_with_versioned('test', 'test2', :cache => 'test_all')          
    end
    
  end
end
