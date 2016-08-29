require "bundler/gem_tasks"
require "rspec/core/rake_task"
require_relative "lib/docassembler_docusign"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

desc "Send an example Envelope to Docusign"
task :send_example_envelope do
  d = DocassemblerDocusign.new
  d = d.set_email(subject: 'lorem', body: 'ipsum')
       .add_signer(
         name: 'John Hamelink',
         email: 'john@johnhamelink.com',
         role_name: 'Issuer',
         sign_here_tabs: [
           d.build_tab(anchor_string: 'sign-here-1'),
       ])
       .add_signer(
         name: 'Hans Kayaert',
         email: 'hans@kayaert.be',
         role_name: 'Attorney',
         sign_here_tabs: [
           d.build_tab(anchor_string: 'sign-here-3')
       ])
       .add_file(
         path: 'spec/example_contract.pdf'
       )
  d.sign
end
