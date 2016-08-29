require 'spec_helper'

describe DocassemblerDocusign do

  describe 'create_envelope' do
    it 'builds envelope payload' do

      sign = DocassemblerDocusign.new(
        username:"oooooooo-oooo-oooo-oooo-oooooooooooo",
        password: "p@ssw0rd",
        integrator_key: "oooooooo-oooo-oooo-oooo-oooooooooooo",
        account_id: "oooooooo-oooo-oooo-oooo-oooooooooooo",
      )

      config = sign
        .set_email(subject: "lorem", body: "ipsum")
        .add_signer(
          name: "John",
          email: "john@johnhamelink.com",
          role_name: "Attorney",
          sign_here_tabs: [
            sign.build_tab(anchor_string: "sign_here_1"),
            sign.build_tab(anchor_string: "sign_here_2"),
          ])
        .add_signer(
          name: "Hans",
          email: "hans@johnhamelink.com",
          role_name: "Attorney",
          sign_here_tabs: [
            sign.build_tab(anchor_string: "sign_here_1")
          ])
        .add_file(path: "/tmp/doc.pdf")
        .build_config

      expected = {
        email: {
          subject: "lorem",
          body: "ipsum"
        },
        signers: [
          {
            embedded: false,
            name: "John",
            email: "john@johnhamelink.com",
            role_name: "Attorney",
            sign_here_tabs: [
              {
                anchor_string: "sign_here_1",
                anchor_x_offset: "0",
                anchor_y_offset: "0"
              },
              {
                anchor_string: "sign_here_2",
                anchor_x_offset: "0",
                anchor_y_offset: "0"
              }
            ]
          },
          {
            embedded: false,
            name: "Hans",
            email: "hans@johnhamelink.com",
            role_name: "Attorney",
            sign_here_tabs: [
              {
                anchor_string: "sign_here_1",
                anchor_x_offset: "0",
                anchor_y_offset: "0"
              }
            ]
          }
        ],
        files: [
          {path: "/tmp/doc.pdf", name: "doc.pdf"}
        ]
      }

      expect(config).to eq(expected)
    end
  end
end
