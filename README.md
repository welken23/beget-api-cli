# beget-api-cli

---

This is the **unofficial** wrapper for automating queries to [Beget.API](https://beget.com/ru/kb/api/beget-api).

# Installation

### Ubuntu 18.04, Ubuntu 20.04, Debian 

If you do not have a Perl package manager installed, you must install it as follows:
```shell
sudo apt-get install make cpanminus
```
After that, you need to install the necessary modules to run the script:
```shell
cpanm Getopt::Long HTTP::Tiny JSON::PP URL::Encode::PP
```
Then you have to configure the Perl environment variables, which you can do as follows:
```shell
echo -e "\n# perl environment variables\n\
PATH=\"/home/${USER}/perl5/bin${PATH:+:${PATH}}\"; export PATH;\n\
PERL5LIB=\"/home/${USER}/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}\"; export PERL5LIB;\n\
PERL_LOCAL_LIB_ROOT=\"/home/${USER}/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}\"; export PERL_LOCAL_LIB_ROOT;\n\
PERL_MB_OPT=\"--install_base \\\"/home/${USER}/perl5\\\"\"; export PERL_MB_OPT;\n\
PERL_MM_OPT=\"INSTALL_BASE=/home/${USER}/perl5\"; export PERL_MM_OPT" >> ~/.bashrc
. ~/.bashrc
```
You can then download the script and add a link to it in your executable directory:
```shell
git clone https://github.com/welken23/beget-api-cli && cd beget-api-cli
sudo ln -s `realpath beget-api-cli.pl` /usr/bin/beget-api-cli
```
### Setting up autocompletion in bash
```shell
echo -e "\n# beget-api-cli autocompletion\n. `realpath beget-api-cli-completion.sh`" >> ~/.bashrc && . ~/.bashrc
```

# Usage

```shell
beget-api-cli
beget-api-cli -h -m [command]
beget-api-cli -m [command] [options]
```
### Examples
```shell
beget-api-cli -h -m mysql/addDb
beget-api-cli -m mysql/addDb -l login -p 'password' --ending test --mysql_password 'dbpassword'
```
### List of available commands
```plaintext
account/info [options]                Print customer account info
account/ssh [options]                 Toggle ssh on/off for the main account
account/sshFtpUser [options]          Toggle ssh on/off for an additional ftp user
backup/list [options]                 Show a list of file backups
backup/dbList [options]               Show a list of database backups
backup/getFileList [options]          Show a list of files and directories from the backup by the specified path and identifier
backup/getDbList [options]            Show a list of databases from the backup by the specified identifier
backup/restoreFile [options]          Create a request to restore files and/or directories from the selected backup to the specified path (or paths)
backup/restoreDb [options]            Create a request to restore database or databases from the selected backup
backup/downloadFile [options]         Create a request to download and upload data from backup to the account
backup/downloadDb [options]           Create a request to download and upload databases from backup to the account
backup/status [options]               Create a request for a list of recovery task statuses from a backup
crontab/list [options]                Show a list of all CronTab tasks
crontab/add [options]                 Add CronTab task
crontab/edit [options]                Edit crontab task
crontab/delete [options]              Delete crontab task
crontab/toggleState [options]         Enable/disable automatic start crontab task
dns/getRecords [options]              Get domain or subdomain DNS-records by FQDN
dns/setRecordsUsingFile [options]     Set domain or subdomain DNS-records by FQDN
dns/saveRecordsToFile [options]       Save domain or subdomain DNS-records to file
ftp/getListAccounts [options]         Get a list of additional FTP accounts
ftp/addAccount [options]              Add new FTP account
ftp/changePassword [options]          Change password of an additional FTP account
ftp/deleteAccount [options]           Delete FTP account
mysql/getList [options]               Get databases list
mysql/addDb [options]                 Add new database
mysql/addAccess [options]             Add new access to database
mysql/deleteDb [options]              Delete database
mysql/deleteAccess [options]          Delete access to database
mysql/changeAccessPassword [options]  Change access password
site/getList [options]                Get sites list
site/add [options]                    Add new site
site/delete [options]                 Remove site without removing site directory on server
site/linkDomain [options]             Link domain to site folder
site/unlinkDomain [options]           Unlink domain from site
site/freeze [options]                 Prohibit changing site files
site/unfreeze [options]               Allow site files to be modified
site/isFrozen [options]               Check freeze status
domain/getList [options]              Get domains list
domain/getId [options]                Get domain identifier
domain/getZoneList [options]          Get a list of domain zones, information about the cost of registration and renewal of domains in these zones
domain/getZoneId [options]            Get domain zone identifier
domain/add [options]                  Add domain to account
domain/delete [options]               Delete domain from account
domain/getSubdomainsList [options]    Get subdomains list
domain/getSubdomainId [options]       Get subdomain identifier
domain/addSubdomain [options]         Add subdomain
domain/deleteSubdomain [options]      Delete subdomain
domain/checkDomainToReg [options]     Check domain to see if it can be registered
domain/getPhpVersion [options]        Get information about the current version of php selected for the domain, available php versions to install
domain/changePhpVersion [options]     Change PHP version of a domain or subdomain
domain/getPhpDirectives [options]     Get PHP directives for a domain or subdomain
domain/addPhpDirectives [options]     Add PHP directives for a domain or subdomain
domain/removePhpDirectives [options]  Remove PHP directives for a domain or subdomain
mail/getMailboxList [options]         Get a list of mailboxes on the specified domain
mail/createMailbox [options]          Create mailbox
mail/changeMailboxPassword [options]  Change password for the selected mailbox
mail/changeMailboxSettings [options]  Change mailbox settings (spam filter settings, mail forwards)
mail/dropMailbox [options]            Delete mailbox
mail/forwardListAddMailbox [options]  Add forward mailbox
mail/forwardListDelMailbox [options]  Delete forward mailbox
mail/forwardListShow [options]        Get forwarding list for selected mailbox
mail/setDomainMail [options]          Set up forwarding of emails that came to a non-existent email
mail/clearDomainMail [options]        Delete a mailbox to which emails sent to non-existent emails are forwarded
stat/getSiteListLoad [options]        Get information about the average load on the sites for the last month
stat/getDbListLoad [options]          Get information about the average load on the databases for the last month
stat/getSiteLoad [options]            Get information about the load on the selected site (load by day and hour)
stat/getDbLoad [options]              Get information about the load created by requests to the selected database (load by day and hour)
```
