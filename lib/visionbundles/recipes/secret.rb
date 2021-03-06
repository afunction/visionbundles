Capistrano::Configuration.instance(:must_exist).load do
  begin
    require 'rails'
  rescue e
    raise 'require rails faild'
  end

  major, minor = Rails::VERSION::STRING.split('.').map(&:to_i)
  if major == 4 && [0, 1, 2].include?(minor)
    source, desc = case minor
    when 0 then; ['secret_token.rb', 'config/initializers/secret_token.rb']
    else # 4.1.x, 4.2.x
      ['secrets.yml', 'config/secrets.yml']
    end
    preconfig_files(source => desc)
  else
    raise 'Only support rails 4.1.x and 4.0.x'
  end
end
