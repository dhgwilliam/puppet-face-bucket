# bucket_face

Deploy a Puppet Face that allows human readable access to the filebucket contents, e.g.

    master# puppet bucket list
    c74c148efcf0db7a55b4095628d72708        2014-03-06 22:31        /etc/asound.conf
    83bac3ca862d50579ed8b8690ffcb6d0        2014-03-06 05:38        /etc/krb5.conf
    7fe170afee81af1e7c1551533249c88e        2014-03-06 01:21        /etc/puppetlabs/activemq/activemq-wrapper.conf
    af071e4b4a1c3f06b731ac1fe0cf6f43        2014-03-06 01:21        /etc/puppetlabs/activemq/activemq.xml
    5cc6def84abf53ca1769d771d5f4e93a        2014-03-06 01:21        /etc/puppetlabs/mcollective/client.cfg
    a9c7335a83c5ac9f6a19bb195ea0c63e        2014-03-06 01:22        /etc/puppetlabs/mcollective/server.cfg
    1891233908ecf2dd0fff8a73a3a97097        2014-03-06 01:21        /etc/puppetlabs/puppet/auth.conf
    ad775a0c21b24d38f2d15f4ee7b9e1b3        2014-03-06 01:20        /opt/puppet/var/lib/pgsql/9.2/data/pg_hba.conf
    d41d8cd98f00b204e9800998ecf8427e        2014-03-06 01:22        /opt/puppet/var/lib/pgsql/9.2/data/postgresql_puppet_extras.conf

    master# puppet bucket view c74c148efcf0db7a55b4095628d72708
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

License
-------

Apache 2


Contact
-------

dhgwilliam@gmail.com


Support
-------

Please log tickets and issues at our [github](https://github.com/dhgwilliam/puppet-face-bucket)
