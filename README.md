# bucket_face #

Deploy a Puppet Face that allows human readable access to the filebucket contents, e.g.

    [root@master ~]# puppet bucket list
    c74c148efcf0db7a55b4095628d72708        2014-03-06 22:31        /etc/asound.conf
    83bac3ca862d50579ed8b8690ffcb6d0        2014-03-06 05:38        /etc/krb5.conf
    7fe170afee81af1e7c1551533249c88e        2014-03-06 01:21        /etc/puppetlabs/activemq/activemq-wrapper.conf
    af071e4b4a1c3f06b731ac1fe0cf6f43        2014-03-06 01:21        /etc/puppetlabs/activemq/activemq.xml
    5cc6def84abf53ca1769d771d5f4e93a        2014-03-06 01:21        /etc/puppetlabs/mcollective/client.cfg
    a9c7335a83c5ac9f6a19bb195ea0c63e        2014-03-06 01:22        /etc/puppetlabs/mcollective/server.cfg
    1891233908ecf2dd0fff8a73a3a97097        2014-03-06 01:21        /etc/puppetlabs/puppet/auth.conf
    ad775a0c21b24d38f2d15f4ee7b9e1b3        2014-03-06 01:20        /opt/puppet/var/lib/pgsql/9.2/data/pg_hba.conf
    d41d8cd98f00b204e9800998ecf8427e        2014-03-06 01:22        /opt/puppet/var/lib/pgsql/9.2/data/postgresql_puppet_extras.conf

    [root@master ~]# puppet bucket view c74c148efcf0db7a55b4095628d72708
    #
    # Place your global alsa-lib configuration here...
    #

    @hooks [
            {
                    func load
                    files [
                            "/etc/alsa/pulse-default.conf"
                    ]
                    errors false
            }
    ]

`puppet bucket grep`:

    [root@master ~]# puppet bucket grep Manager
    6f2472320af7af559035203c520267a4        2014-03-08 21:27        /etc/libuser.conf:
            # binddn = cn=Manager,dc=example,dc=com
            # user = Manager
            # authuser = Manager

    [root@master ~]# puppet bucket grep /etc/hosts
    554df081fa9d04fb28067dd2f227128b        2014-03-11 02:48        No path:
                echo '<%= @serverip %>  classroom.puppetlabs.vm classroom' >> /etc/hosts
    bad420278dea7f7a2632eec42d93beef        2014-03-10 21:40        /etc/hosts
    ee5f4cd1f70310816ed6eb552cc2c245        2014-03-10 21:21        /etc/hosts
    decf8046d098a1db72e67dc7bea46c06        2014-03-10 22:16        /etc/hosts

Commands
---

* `puppet bucket list [--date]`
* `puppet bucket grep [search terms]`
* `puppet bucket view [md5]`
* `puppet bucket copy [md5] [dest]`

License
-------

Apache 2


Contact
-------

dhgwilliam@gmail.com


Support
-------

Please log tickets and issues at our [github](https://github.com/dhgwilliam/puppet-face-bucket)
