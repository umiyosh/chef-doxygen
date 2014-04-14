require_relative 'spec_helper'

describe 'doxygen::default' do
  
  let(:chef_run) do
    ChefSpec::Runner.new do |node|
    end.converge(described_recipe)
  end

  it 'should sync_git["/home/vagrant/doxygen"]' do
    expect(chef_run).to sync_git("/home/vagrant/doxygen").with("user" => "vagrant", "checkout_branch" => chef_run.node['doxygen']['version'])
  end

  it 'syncing git[/home/vagrant/doxygen] should notify[bash[config_doxygen]] immediately' do
    git_home_vagrant_doxygen = chef_run.find_resource "git", "/home/vagrant/doxygen"
    expect(git_home_vagrant_doxygen).to notify('bash[config_doxygen]').to('run').immediately
   end
 end
