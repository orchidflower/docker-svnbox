# Overview
This image is built from Ubuntu:14.04.5. The following packing are added:

* Apache2
* WebSVN
The main purpose of this image is to build a one box which contains all SVN & WebSVN dependencies. This image would be helpful for you to deploy one SVN server quickly. 

# Usage
It is very easy to run this image quickly using docker-compose.

## Directory struction in image
* /opt/scmroot/svnrep  All SVN repository should be placed here. You should mount local directory as volume;
* /opt/scmroot/svndigest  The user information should be put in it. You should specify one local file and mount it;
* /etc/apache2/ The configuration of apache2.

## docker-compose.yaml
```
version: '2'
services:
  apache:
    image: svnbox
    volumes:
      # let container use same timezone as host
      - /etc/localtime:/etc/localtime
      - /opt/docker/svnbox/runtime/svnrep:/opt/scmroot/svnrep
      - /opt/docker/svnbox/runtime/svndigest:/opt/scmroot/svndigest
      - /opt/docker/svnbox/runtime/svn_deb_conf.inc:/etc/websvn/svn_deb_conf.inc
      - /opt/docker/svnbox/runtime/index.html:/var/www/index.html
    ports:
      - "85:80"
    environment:
      NODE_ENV: prd
    restart: always
    hostname: apache
```
In the configuration, some files are referenced:

* svndigest User configuration.
* svn_deb_conf.inc WebSVN configuration file.
* index.html The homepage of this Apache.

## svn_deb_conf.inc
You should specify one WebSVN configuration named as this. You can add the configuration like:
* add  SVN Repository
* Change behavior

```
<?php
// Show Date instead of Age
$config->setShowAgeInsteadOfDate(false);
// Use flat view
//$config->useFlatView();
// Expand tab to 4 spaces
$config->expandTabsBy(4);
// Show changes in logs view
$config->setLogsShowChanges(true);
// Add one repository (Name, Location)
$config->addRepository("AuthServer", "file:///opt/scmroot/svnrep/AuthServer");
$config->setEnscriptPath("/usr/bin");
$config->setSedPath("/bin");
$config->useEnscript();
?>
```

## svndigest
The password in this file is encrypted using Digest (NOT Basic). You can use Apache `htdigest` tool to generate it. You can create one file (including user test) like the following:

```
$ htdigest -c svndigest "SVN Access" test
Adding user test in realm SVN Access
New password: 
Re-type new password: 
```
Note:  the realm in command line must be "SVN Access", because it is defined in Apache config (/etc/apache2/sites-available/000-default.conf).

# How to access the SVN?
You should:

* `http://[your-server-ip]:85/svnrep/...`  to access the SVN repository;
* `http://[your-server-ip]:85/websvn/` to access bundled WebSVN.
