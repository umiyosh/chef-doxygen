require 'serverspec'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

describe 'doxygen::default' do
  it 'should have doxygen installed' do
    expect(command("doxygen --version | grep '1.8.6'")).to return_exit_status 0
  end
end
