class oracle::server {  
  exec { 
	"apt-update":
		command => "/usr/bin/apt-get -y update";
  }
  
  package {
    ["unzip", "vim", "ant"]:
      ensure => installed;
  }

  $install_dirs = [ "/home/vagrant/", "/home/vagrant/oracle/"]

  file {
    "/tmp/copy_all.sh":
		owner => vagrant,
		source => "puppet:///modules/oracle/copy_all.sh";
    $install_dirs:
		ensure => "directory",
		owner => vagrant;
  }
  
  exec { 
	"copy inst files":
        command => "/tmp/copy_all.sh",
        timeout => 0,
		user => vagrant,	
		require => [File["/tmp/copy_all.sh"]];
	"install java":
  		command => "/tmp/install_oracle_java.sh",
		user => root,
		timeout => 0,
    	require => [Exec["copy inst files"]];
        #unless => "/usr/lib/jvm/java-6-oracle/bin/java -version";
	"install weblogic":
		command => "/tmp/install_wls.sh",
		user => vagrant,
       	timeout => 0,
    	require => [Exec["install java"]],
		unless => "/usr/bin/test -d /home/vagrant/oracle/wlserver_10.3/";
	"unzip osb":
		command => "/usr/bin/unzip -o ofm_osb_generic_11.1.1.7.0_disk1_1of1.zip",
		user => vagrant,
		cwd => "/tmp",
		require => [Package["unzip"], Exec["copy inst files"]],
		unless => "/usr/bin/test -d /tmp/Disk1";
	"install osb":
		command => "/tmp/install_osb.sh  -silent -ResponseFile /tmp/osb_11_inst_silent.rsp",
       	cwd => "/tmp/Disk1",
		user => vagrant,
		timeout => 0,
    	require => [Exec["install weblogic"], Exec["copy inst files"]],
		unless => "/usr/bin/test -d /home/vagrant/oracle/Oracle_OSB_0";
  }
  
  group {
    "puppet":
      ensure => present;
  }
  
  Exec["apt-update"] -> Package <| |>
}
