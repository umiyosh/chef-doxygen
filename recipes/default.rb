doxygen_options = node.to_hash['doxygen'].to_hash['options'].sort.find_all do |key, val|
  !val.nil? || val != false
end.map do |key, val|
  if val == true
    "--#{key}"
  else
    "--#{key}" + "=" + val
  end
end.join " "

git "/home/vagrant/doxygen" do
  repository "git://github.com/doxygen/doxygen.git"
  user "vagrant"
  checkout_branch node['doxygen']['version']
  action :sync
  notifies :run, "bash[config_doxygen]", :immediately
end

bash "config_doxygen" do
  user "vagrant"
  cwd "/home/vagrant/doxygen"
  flags "-lx"
  code <<-EOH
    git checkout master
    ./configure
    make
    make distclean
    git pull
    ./configure
    ./configure #{doxygen_options}
    make
  EOH
  if node["doxygen"]["force_recompile"] == true
    action :run
  else
    action :nothing
  end
  notifies :run, "bash[install_doxygen]", :immediately
end

bash "install_doxygen" do
  user "root"
  cwd "/home/vagrant/doxygen"
  flags "-lx"
  code <<-EOH
    sudo make install
  EOH
  action :nothing
end
