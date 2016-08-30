class DocassemblerDocusign
  require 'docusign_rest'
  require 'pathname'
  attr_accessor :email_info, :signers, :files, :client

  def initialize(username: nil, password: nil, integrator_key: nil,
                 account_id: nil, docusign: DocusignRest)
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

  def build_tab(anchor_string: nil, x_offset: 10, y_offset: 0)
    {
      anchor_string: anchor_string,
      anchor_x_offset: x_offset.to_s,
      anchor_y_offset: y_offset.to_s
    }
  end

  def set_email(subject: nil, body: nil)
    @email_info = {
      email: {
        subject: subject,
        body: body
      }
    }
    self
  end

  def add_signer(name: nil, email: nil, role_name: nil, sign_here_tabs: [])
    @signers = (@signers << [
      {
        embedded: false,
        name: name,
        email: email,
        role_name: role_name,
        sign_here_tabs: sign_here_tabs
      }
    ]).flatten
    self
  end

  def add_file(path: nil)
    name = Pathname.new(path).basename.to_s
    @files << { path: path, name: name }
    self
  end

  def build_config
    @email_info.merge(signers: @signers)
               .merge(files:   @files)
               .merge(status: 'sent')
  end

  def sign
    req = build_config
    res = @client.create_envelope_from_document(req)

    parse_error(res) if res.key?('errorCode')
    return res
  end

  ## Errors

  def parse_error(res)
    case res['errorCode']
    when 'USER_AUTHENTICATION_FAILED'
      raise DocassemblerDocusign::UserAuthenticationError.new(res)
    when 'ANCHOR_TAB_STRING_NOT_FOUND'
      raise DocassemblerDocusign::AnchorTabStringNotFoundError.new(res)
    end
  end


  class AnchorTabStringNotFoundError < StandardError
    attr_reader :object

    def initialize(object)
      @object = object
    end

    def to_s
      @object["message"]
    end
  end

  class UserAuthenticationError < StandardError
    attr_reader :object

    def initialize(object)
      @object = object
    end

    def to_s
      "Login credentials are not correct: #{@object}"
    end
  end
end
