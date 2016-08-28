class DocassemblerDocusign
  require 'docusign_rest'
  require 'pathname'
  attr_accessor :email_info, :signers, :files, :client

  def initialize(username: nil, password: nil, integrator_key: nil, account_id: nil, docusign: DocusignRest)
    username       ||= "0debc564-78c5-432e-8c6b-3ea5c792fd6b"
    password       ||= "incheo009n"
    integrator_key ||= "fe941a1e-b200-4d7b-aac8-b8a1a3f7855d"
    account_id     ||="5f539fb6-c0cc-4d88-9bca-6550e8906dc5"

    docusign.configure do |config|
      config.username       = username
      config.password       = password
      config.integrator_key = integrator_key
      config.account_id     = account_id
    end

    @client  ||= docusign::Client.new
    @signers ||= []
    @files   ||= []
  end

  def self.build_sign_here_tab(anchor_string: nil, x_offset: 0, y_offset: 0)
    {
      anchor_string: anchor_string,
      anchor_x_offset: x_offset.to_s,
      anchor_y_offset: y_offset.to_s
    }
  end

  def set_email(subject: nil, body: nil)
    @email_info = {
      email: {
        subject: subject
        body: body
      }
    }
    self
  end


  def add_signer(name: nil, email: nil, role_name: nil, sign_here_tabs: [])
    @signers << [
      {
        embedded: false,
        name: name,
        email: email,
        role_name: role_name,
        sign_here_tabs: sign_here_tabs
      }
    ]
    self
  end

  def add_file(path: nil)
    name = Pathname.new(path).basename
    @files << {path: path, name: name}
    self
  end

  def build_config
    @email_info.merge({signers: @signers})
               .merge({files:   @files})
  end

  def sign
    req = build_config
    require 'pry'; binding.pry
    res = @client.create_envelope_from_document(req)
  end
end
