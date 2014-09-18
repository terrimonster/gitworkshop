# GIT Workshop

## Overview

This is the main repo for the GIT Workshop at PuppetConf 2014. 

### 1. Install Virtualbox

This vagrant setup requires one of the following versions: 4.0, 4.1, 4.2. The latest Virtualbox version is 4.3

### 2. Install Vagrant

Latest version, 1.5.6 when this repo was created, will work fine.

### 3. GIT clone this repo

### 4. cd into resulting directory

### 5. vagrant up xmaster gitlab

Get yourself a coffee and a snack. This is going to take awhile. Vagrant is provisioning the instances you specify. At minimum, provision 'xmaster' and 'gitlab'. You can optionally provision 'testagent'.

Once vagrant is done, you'll have an instance called xmaster and gitlab.

### 6. Set up the gitlab server

Login to the Gitlab web interface at: [http://192.168.137.11](http://192.168.137.11) (default)

**The default credentials are:**

|          |            |
| -------- | ---------- |
| Username | `root`     |
| Password | `5iveL!fe` |


#### 1.1 Create a new "organization" in Gitlab called `puppet`


#### 1.2 Create a new repository in Gitlab with the following settings:


Project Name: `motd`

Namespace: `puppet`

Visibility Level: `Public`

#### 1.3 Add an SSH key to Gitlab

Go to the "profile settings" in Gitlab and click on "SSH Keys"

Add a public SSH key from your local machine

#### 1.5 Get the mymotd code

On your local machine, clone the example mymotd module:

```shell
git clone https://github.com/terrimonster/mymotd.git
cd mymotd
rm -rf .git

Now the code is not a git working directory. Let's make that into a repo for your GitLab server. While still inside that mymotd directory:

```shell
git init
git add .
git commit -m "Initial commit"
git remote add origin git@192.168.137.11:puppet/motd.git
git push origin master
```

You should then be able to see the pushed code in the Gitlab repositories.

#### 1.6 Add the pre-receive hook to the mymotd repo

Access the GitLab server, copy the hooks in the vagrant directory to the mymotd directory, and make the pre-receive hook executable:

```shell
vagrant ssh gitlab
sudo su -
cp -r /vagrant/hooks /var/opt/gitlab/git-data/repositories/puppet/mymotd.git/
chmod a+x /var/opt/gitlab/git-data/repositories/puppet/mymotd.git/hooks/pre-receive




## Other

This makes use of Greg Sarjeant's [data-driven-vagrantfile](https://github.com/gsarjeant/data-driven-vagrantfile)

No Vagrant plugins are required.
