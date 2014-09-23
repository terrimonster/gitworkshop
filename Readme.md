# GIT Workshop

## Overview

This is the main repo for my GIT Workshop at PuppetConf 2014. [http://sched.co/1nwrtol](http://sched.co/1nwrtol)

### 1. Install Puppet

Although really you should have it installed on your local machine already.

### 2. Install puppet-lint

```shell
gem install puppet-lint
```

### 3. Install Virtualbox

This vagrant setup requires one of the following versions: 4.0, 4.1, 4.2. The latest Virtualbox version is 4.3

### 4. Install Vagrant

Latest version, 1.5.6 when this repo was created, will work fine.

### 5. GIT clone this repo

```shell
git clone https://github.com/terrimonster/gitworkshop.git
```

### 6. cd gitworkshop

### 7. vagrant up

Get yourself a coffee and a snack. This is going to take awhile. Vagrant is provisioning the instances xmaster, gitlab, and testagent.

If you destroy (vagrant destroy <instance name>) the vagrant VMs and rebuild, the provisioning process won't take nearly as long because you'll already have downloaded the Puppet Enterprise installation file.

### 8. Set up the gitlab server

Login to the Gitlab web interface at: [http://192.168.137.11](http://192.168.137.11) (default)

**The default credentials are:**

|          |            |
| -------- | ---------- |
| Username | `root`     |
| Password | `5iveL!fe` |

You will be prompted immediately to change the root password.

#### 8.1 Create a new "group" in Gitlab called `puppet`


#### 8.2 Create a new project in Gitlab with the following settings:


Project Name: `mymotd`

Namespace: `puppet`

Visibility Level: `Public`

#### 8.3 Add an SSH key to Gitlab

Go to the "profile settings" in Gitlab and click on "SSH Keys"

Add a public SSH key from your local machine


#### 8.4 Get the mymotd code

On your local machine, clone the example mymotd module:

```shell
git clone https://github.com/terrimonster/mymotd.git
cd mymotd
rm -rf .git
```

Now the code is not a git working directory. Let's make that into a repo for your GitLab server. While still inside that mymotd directory:

```shell
git init
git add .
git commit -m "Initial commit"
git remote add origin git@192.168.137.11:puppet/mymotd.git
git push origin master
```

You should then be able to see the pushed code in the Gitlab repositories.

#### 8.5 Add the pre-commit hook to your local repository

```shell
cd mymotd
cp hooks/pre-commit .git/hooks/
chmod 755 .git/hooks/pre-commit
```

Introduce an error into mymotd/manifests/init.pp, then try to add and commit the file. You will have a result somewhat like below.

```shell
vi manifests/init.pp
git add manifests/init.pp
git commit -m 'error'
Validating manifests/init.pp...
Error: Could not parse for environment production: Syntax error at 'owner'; expected '}' at mymotd/manifests/init.pp:6
[master df572b4] error
 1 file changed, 1 insertion(+), 1 deletion(-)
```
Fix the error(s) and re-attempt committing and pushing the file.

#### 8.6 Add the pre-receive hook to the mymotd repo

SSH into the GitLab server, copy the hooks in the vagrant directory to the mymotd directory, and make the pre-receive hook executable:

```shell
vagrant ssh gitlab
sudo su -
cp -r /vagrant/hooks /var/opt/gitlab/git-data/repositories/puppet/mymotd.git/
chmod a+x /var/opt/gitlab/git-data/repositories/puppet/mymotd.git/hooks/pre-receive
```

Delete the pre-commit hook from your local repository:

```shell
rm .git/hooks/pre-commit
```
Re-introduce an error into the manifests/init.pp file. You should see a result like below:

```shell
vi manifests/init.pp
git add manifests/init.pp
git commit -m 're-introducing error'
[master d66d298] re-introducing error
 1 file changed, 2 insertions(+), 2 deletions(-)
git push origin master
Counting objects: 7, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (3/3), done.
Writing objects: 100% (4/4), 358 bytes | 0 bytes/s, done.
Total 4 (delta 2), reused 0 (delta 0)
remote: Checking puppet manifest syntax for manifests/init.pp...
remote: Error: Could not parse for environment production: Syntax error at 'owner'; expected '}' at /tmp/mymotd/manifests/init.pp:6
remote: Error: puppet syntax error in manifests/init.pp (see above)
remote: Error: 1 syntax error(s) found in puppet manifests. Commit will be aborted.
remote: puppet-lint not installed. Skipping puppet-lint tests...
remote: Error: 1 subhooks failed. Declining push.
To git@gitlab.vagrant.vm:puppet/mymotd.git
 ! [remote rejected] master -> master (pre-receive hook declined)
error: failed to push some refs to 'git@gitlab.vagrant.vm:puppet/mymotd.git'
```

### 9. Add the master's SSH key to the GitLab Server


```shell
vagrant ssh xmaster
sudo su -
cat ~/.ssh/id_rsa.pub
```

Copy the output and paste it into a new SSH key entry in Gitlab.

### 10. Clone the mymotd to the master's module directory

```shell
vagrant ssh xmaster
sudo su -
cd /etc/puppetlabs/puppet/environments/production/modules
git clone git@gitlab.vagrant.vm:puppet/mymotd.git
``` 

### 11. Classify node default with mymotd

```shell
vagrant ssh xmaster
sudo su -
vi /etc/puppetlabs/puppet/environments/production/manifests/site.pp
``` 

Delete the comment to enable mymotd on node default.

### 12. Run puppet on testagent

```shell
vagrant ssh testagent
sudo su -
puppet agent -t
```

## Other

This makes use of Greg Sarjeant's [data-driven-vagrantfile](https://github.com/gsarjeant/data-driven-vagrantfile)

Learn more about [puppet-lint](http://puppet-lint.com/)

Go do an [interactive git tutorial](http://try.github.com)

No Vagrant plugins are required.
