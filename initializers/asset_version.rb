ASSET_VERSION_FILENAME = File.join(RAILS_ROOT, 'REVISION')

ASSET_VERSION = 
  if File.exists?(ASSET_VERSION_FILENAME)
    File.read(ASSET_VERSION_FILENAME).gsub(/[^[:alnum:]]/, '')
  end
