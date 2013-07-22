def get_doxygen_options()
  temp = []
  node[:doxygen][:options].sort.each do |key, val|
    if val == true
      temp.push("--"+key)
    elsif val == false
    else
      temp.push("--"+key+"="+val)
    end
  end
  return temp.join(" ")
end

git "/home/vagrant/doxygen" do
  repository "git://github.com/doxygen/doxygen.git"
  user "vagrant"
  if node[:doxygen].has_key?("version")
    resource node[:doxygen][:version]
  end
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
    ./configure #{get_doxygen_options()}
    make
  EOH
  if node[:doxygen][:force_recompile] = true
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
