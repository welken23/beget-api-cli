#!/usr/bin/env perl

use v5.010;
use Getopt::Long qw/:config no_ignore_case/;
use URL::Encode::PP qw/url_encode_utf8/;
use HTTP::Tiny;
use JSON::PP;

use strict;
use warnings;
no warnings 'experimental::smartmatch';

sub help {
  say "Usage:";
  say "  beget-api-cli";
  say "  beget-api-cli -h -m [command]";
  say "  beget-api-cli -m [command] [options]";
  say "";
  say "Options:";
  say "  -h, --help                            Show help for using the selected command and its options (like this \"beget-api-cli -h -m account/info\")";
  say "  -m, --method                          Select a command";
  say "";
  say "Commands:";
  say "  account/info [options]                Print customer account info";
  say "  account/ssh [options]                 Toggle ssh on/off for the main account";
  say "  account/sshFtpUser [options]          Toggle ssh on/off for an additional ftp user";
  say "  backup/list [options]                 Show a list of file backups";
  say "  backup/dbList [options]               Show a list of database backups";
  say "  backup/getFileList [options]          Show a list of files and directories from the backup by the specified path and identifier";
  say "  backup/getDbList [options]            Show a list of databases from the backup by the specified identifier";
  say "  backup/restoreFile [options]          Create a request to restore files and/or directories from the selected backup to the specified path (or paths)";
  say "  backup/restoreDb [options]            Create a request to restore database or databases from the selected backup";
  say "  backup/downloadFile [options]         Create a request to download and upload data from backup to the account";
  say "  backup/downloadDb [options]           Create a request to download and upload databases from backup to the account";
  say "  backup/status [options]               Create a request for a list of recovery task statuses from a backup";
  say "  crontab/list [options]                Show a list of all CronTab tasks";
  say "  crontab/add [options]                 Add CronTab task";
  say "  crontab/edit [options]                Edit crontab task";
  say "  crontab/delete [options]              Delete crontab task";
  say "  crontab/toggleState [options]         Enable/disable automatic start crontab task";
  say "  dns/getRecords [options]              Get domain or subdomain DNS-records by FQDN";
  say "  dns/setRecordsUsingFile [options]     Set domain or subdomain DNS-records by FQDN";
  say "  dns/saveRecordsToFile [options]       Save domain or subdomain DNS-records to file";
  say "  ftp/getListAccounts [options]         Get a list of additional FTP accounts";
  say "  ftp/addAccount [options]              Add new FTP account";
  say "  ftp/changePassword [options]          Change password of an additional FTP account";
  say "  ftp/deleteAccount [options]           Delete FTP account";
  say "  mysql/getList [options]               Get databases list";
  say "  mysql/addDb [options]                 Add new database";
  say "  mysql/addAccess [options]             Add new access to database";
  say "  mysql/deleteDb [options]              Delete database";
  say "  mysql/deleteAccess [options]          Delete access to database";
  say "  mysql/changeAccessPassword [options]  Change access password";
  say "  site/getList [options]                Get sites list";
  say "  site/add [options]                    Add new site";
  say "  site/delete [options]                 Remove site without removing site directory on server";
  say "  site/linkDomain [options]             Link domain to site folder";
  say "  site/unlinkDomain [options]           Unlink domain from site";
  say "  site/freeze [options]                 Prohibit changing site files";
  say "  site/unfreeze [options]               Allow site files to be modified";
  say "  site/isFrozen [options]               Check freeze status";
  say "  domain/getList [options]              Get domains list";
  say "  domain/getId [options]                Get domain identifier";
  say "  domain/getZoneList [options]          Get a list of domain zones, information about the cost of registration and renewal of domains in these zones";
  say "  domain/getZoneId [options]            Get domain zone identifier";
  say "  domain/add [options]                  Add domain to account";
  say "  domain/delete [options]               Delete domain from account";
  say "  domain/getSubdomainsList [options]    Get subdomains list";
  say "  domain/getSubdomainId [options]       Get subdomain identifier";
  say "  domain/addSubdomain [options]         Add subdomain";
  say "  domain/deleteSubdomain [options]      Delete subdomain";
  say "  domain/checkDomainToReg [options]     Check domain to see if it can be registered";
  say "  domain/getPhpVersion [options]        Get information about the current version of php selected for the domain, available php versions to install";
  say "  domain/changePhpVersion [options]     Change PHP version of a domain or subdomain";
  say "  domain/getPhpDirectives [options]     Get PHP directives for a domain or subdomain";
  say "  domain/addPhpDirectives [options]     Add PHP directives for a domain or subdomain";
  say "  domain/removePhpDirectives [options]  Remove PHP directives for a domain or subdomain";
  say "  mail/getMailboxList [options]         Get a list of mailboxes on the specified domain";
  say "  mail/createMailbox [options]          Create mailbox";
  say "  mail/changeMailboxPassword [options]  Change password for the selected mailbox";
  say "  mail/changeMailboxSettings [options]  Change mailbox settings (spam filter settings, mail forwards)";
  say "  mail/dropMailbox [options]            Delete mailbox";
  say "  mail/forwardListAddMailbox [options]  Add forward mailbox";
  say "  mail/forwardListDelMailbox [options]  Delete forward mailbox";
  say "  mail/forwardListShow [options]        Get forwarding list for selected mailbox";
  say "  mail/setDomainMail [options]          Set up forwarding of emails that came to a non-existent email";
  say "  mail/clearDomainMail [options]        Delete a mailbox to which emails sent to non-existent emails are forwarded";
  say "  stat/getSiteListLoad [options]        Get information about the average load on the sites for the last month";
  say "  stat/getDbListLoad [options]          Get information about the average load on the databases for the last month";
  say "  stat/getSiteLoad [options]            Get information about the load on the selected site (load by day and hour)";
  say "  stat/getDbLoad [options]              Get information about the load created by requests to the selected database (load by day and hour)";
}

sub helpAccountInfo {
  say 'Usage:';
  say '  beget-api-cli -m account/info [options]';
  say "";
  say "Print customer account info";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
}

sub helpAccountSsh {
  say 'Usage:';
  say '  beget-api-cli -m account/ssh [options]';
  say "";
  say "Toggle ssh on/off for the main account";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
  say "  -t, --toggle_ssh <type>               0|1 (0 Disabled, 1 Enabled)";
  say "";
  say "The SSH account connection slider in the CP is updated immediately";
  say "when using this method. To check, just refresh the page or try to";
  say "connect to the server via SSH.";
}

sub helpAccountSshFtpUser {
  say 'Usage:';
  say '  beget-api-cli -m account/sshFtpUser [options]';
  say "";
  say "Toggle ssh on/off for an additional ftp user";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
  say "  -t, --toggle_ssh <type>               0|1 (0 Disabled, 1 Enabled)";
  say "  -f, --ftpuser <type>                  Ftp user";
  say "";
  say "The position of the SSH connection slider of the additional FTP account";
  say "in the CP is not updated immediately, even when the page is refreshed.";
  say "To check, you need to connect to the server via SSH.";
}

sub helpBackupList {
  say 'Usage:';
  say '  beget-api-cli -m backup/list [options]';
  say "";
  say "Show a list of file backups";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
}

sub helpBackupDbList {
  say 'Usage:';
  say '  beget-api-cli -m backup/dbList [options]';
  say "";
  say "Show a list of database backups";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
}

sub helpBackupGetFileList {
  say 'Usage:';
  say '  beget-api-cli -m backup/getFileList [options]';
  say "";
  say "Show a list of files and directories from the backup by the specified path and identifier";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
  say "  --backup_id <type>                    Backup ID, if it is not set then the listing is based on the current backup";
  say "  --path <type>                         Path from the root of the home directory (e.g. \"/site.ru/public_html\")";
}

sub helpBackupGetDbList {
  say 'Usage:';
  say '  beget-api-cli -m backup/getDbList [options]';
  say "";
  say "Show a list of databases from the backup by the specified identifier";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
  say "  --backup_id <type>                    Backup ID, if it is not set then the listing is based on the current backup";
}

sub helpBackupRestoreFile {
  say 'Usage:';
  say '  beget-api-cli -m backup/restoreFile [options]';
  say "";
  say "Create a request to restore files and/or directories from the selected backup to the specified path (or paths)";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
  say "  --backup_id <type>                    Backup ID";
  say "  --paths <type>                        One or more path values to restore from the root of the home directory (e.g. \"/site.ru/public_html\")";
  say "";
  say "Examples:";
  say '  beget-api-cli -m backup/restoreFile -l login -p \'password\' --backup_id 100000000 --paths \'/site.ru/public_html\' --paths \'/site.ru/.htaccess\'';
  say '  beget-api-cli -m backup/restoreFile -l login -p \'password\' --backup_id 100000001 --paths \'/.bashrc\' --paths \'/.local\'';
  say "";
  say 'The values that are passed to the paths variable must begin with - /';
}

sub helpBackupRestoreDb {
  say 'Usage:';
  say '  beget-api-cli -m backup/restoreDb [options]';
  say "";
  say "Create a request to restore database or databases from the selected backup";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
  say "  --backup_id <type>                    Backup ID";
  say "  --databases <type>                    One or more values of MySQL database names to restore";
  say "";
  say "Example:";
  say '  beget-api-cli -m backup/restoreDb -l login -p \'password\' --backup_id 100000000 --databases login_wp1 --databases login_wp2';
}

sub helpBackupDownloadFile {
  say 'Usage:';
  say '  beget-api-cli -m backup/downloadFile [options]';
  say "";
  say "Create a request to download and upload data from the selected backup to the account";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
  say "  --backup_id <type>                    Backup ID";
  say "  --paths <type>                        One or more path values to restore from the root of the home directory (e.g. \"/site.ru/public_html\")";
  say "";
  say "Examples:";
  say '  beget-api-cli -m backup/downloadFile -l login -p \'password\' --backup_id 100000000 --paths \'/site.ru/public_html\' --paths \'/site.ru/.htaccess\'';
  say '  beget-api-cli -m backup/downloadFile -l login -p \'password\' --backup_id 100000001 --paths \'/.bashrc\' --paths \'/.local\'';
  say "";
  say 'The values that are passed to the paths variable must begin with - /';
}

sub helpBackupDownloadDb {
  say 'Usage:';
  say '  beget-api-cli -m backup/downloadDb [options]';
  say "";
  say "Create a request to download and upload databases from backup to the account";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
  say "  --backup_id <type>                    Backup ID";
  say "  --databases <type>                    One or more values of MySQL database names to restore";
  say "";
  say "Example:";
  say '  beget-api-cli -m backup/downloadDb -l login -p \'password\' --backup_id 100000000 --databases login_wp1 --databases login_wp2';
}

sub helpBackupStatus {
  say 'Usage:';
  say '  beget-api-cli -m backup/status [options]';
  say "";
  say "Create a request for a list of recovery task statuses from a backup";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
}

sub helpCronTabList {
  say 'Usage:';
  say '  beget-api-cli -m crontab/list [options]';
  say "";
  say "Show a list of all CronTab tasks";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
  say "";
  say "Sample response:";
  say "  [";
  say "    {";
  say '     "row_number": "1000",';
  say '     "minutes": "*",';
  say '     "hours": "*",';
  say '     "days": "*",';
  say '     "months": "10,11",';
  say '     "weekdays": "*",';
  say '     "command": "/usr/local/bin/php7.4 ~/site/public_html/run.php",';
  say '     "is_hidden": "1"';
  say "    }";
  say "  [";
  say "";
  say "Description:";
  say "  row_number - ID task";
  say "  is_hidden - 0|1 (0 - Enabled, 1 - Disabled)";
}

sub helpCronTabAdd {
  say 'Usage:';
  say '  beget-api-cli -m crontab/add [options]';
  say "";
  say "Add CronTab task";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
  say "  --minutes <type>                      Minutes (0 to 59)";
  say "  --hours <type>                        Hours (0 to 23)";
  say "  --days <type>                         Days (1 to 31)";
  say "  --months <type>                       Months (1 to 12)";
  say "  --weekdays <type>                     Weekdays (0 to 7; 0 or 7 - Sunday, 1 - Monday and so on)";
  say "  --command <type>                      Command that will run on a schedule";
  say "";
  say "Example:";
  say '  beget-api-cli -m crontab/add -l login -p \'password\' --minutes \'*/3\' --hours \'*\' --days 1 --months \'*\' --weekdays \'*\' --command \'/usr/local/bin/php7.4 ~/run.php\'';
  say "";
  say "Description:";
  say '  \'*/3\' - if this argument is passed to the "--minutes" option, it means that the task should start every third minute (the result will be similar';
  say '  if the argument is passed to another option, for example to the "--hours" option, i.e. the task will start every three hours and so on)';
  say '  \'*\' - same as in the previous example, passing the argument \'*\' to an option will cause the task to run every minute, hourly, daily, weekly';
  say '  or monthly, depending on the option to which the argument was passed as a parameter';
  say '  \'12,13\' - run the task in the specified minutes, hours or days (in this case, in the twelfth and thirteenth minute, hour, or day)';
}

sub helpCronTabEdit {
  say 'Usage:';
  say '  beget-api-cli -m crontab/edit [options]';
  say "";
  say "Edit CronTab task";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
  say "  --task_id <type>                      Task identifier";
  say "  --minutes <type>                      Minutes (0 to 59)";
  say "  --hours <type>                        Hours (0 to 23)";
  say "  --days <type>                         Days (1 to 31)";
  say "  --months <type>                       Months (1 to 12)";
  say "  --weekdays <type>                     Weekdays (0 to 7; 0 or 7 - Sunday, 1 - Monday and so on)";
  say "  --command <type>                      Command that will run on a schedule";
  say "";
  say "Example:";
  say '  beget-api-cli -m crontab/edit -l login -p \'password\' --task_id 1000000 --minutes 0 --hours 5 --days \'*\' --months \'*\' --weekdays \'*\' --command \'/bin/bash ~/backup.sh\'';
}

sub helpCronTabDelete {
  say 'Usage:';
  say '  beget-api-cli -m crontab/delete [options]';
  say "";
  say "Delete CronTab task";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
  say "  --task_id <type>                      Task identifier";
}

sub helpCronTabToggleState {
  say 'Usage:';
  say '  beget-api-cli -m crontab/toggleState [options]';
  say "";
  say "Enable/disable automatic start crontab task";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
  say "  --task_id <type>                      Task identifier";
  say "  --task_state <type>                   State (0 - Enabled, 1 - Disabled)";
  say "";
  say "Example:";
  say '  beget-api-cli -m crontab/toggleState -l login -p \'password\' --task_id 1000000 --task_state 0';
}

sub helpDnsGetRecords {
  say 'Usage:';
  say '  beget-api-cli -m dns/getRecords [options]';
  say "";
  say "Get domain DNS-records";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
  say "  -d, --fqdn <type>                     Fully Qualified Domain Name (FQDN domain or subdomain)";
  say "";
  say "Examples:";
  say '  beget-api-cli -m dns/getRecords -l login -p \'password\' -d example.com';
  say '  beget-api-cli -m dns/getRecords -l login -p \'password\' -d sub.example.com';
}

sub helpDnsSetRecordsUsingFile {
  say 'Usage:';
  say '  beget-api-cli -m dns/setRecordsUsingFile [options]';
  say "";
  say "Set domain or subdomain DNS-records by FQDN";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
  say "  -d, --fqdn <type>                     Fully Qualified Domain Name (FQDN domain or subdomain)";
  say "  --file_path                           Path to the file containing the DNS records to be set";
  say "";
  say "Example:";
  say '  beget-api-cli -m dns/setRecordsUsingFile -l login -p \'password\' -d example.com --file_path /home/user/file';
  say "";
  say "File Examples:";
  say "";
  say "Example 1 (For a domain or subdomain):";
  say '{';
  say '   "A":[';
  say '      {';
  say '         "priority":10,';
  say '         "value":"127.0.0.80"';
  say '      }';
  say '   ],';
  say '   "MX":[';
  say '      {';
  say '         "priority":10,';
  say '         "value":"mx1.example.com"';
  say '      },';
  say '      {';
  say '        "priority":20,';
  say '        "value":"mx2.example.com"';
  say '      }';
  say '   ],';
  say '   "TXT":[';
  say '      {';
  say '         "priority":10,';
  say '         "value":"v=spf1 redirect=example.com"';
  say '      }';
  say '   ]';
  say '}';
  say "";
  say "Example 2 (For a subdomain):";
  say '{';
  say '   "NS":[';
  say '      {';
  say '         "priority":10,';
  say '         "value":"ns1.beget.ru"';
  say '      },';
  say '      {';
  say '         "priority":20,';
  say '         "value":"ns2.beget.ru"';
  say '      }';
  say '   ]';
  say '}';
  say "";
  say "Example 3 (For a subdomain):";
  say '{';
  say '   "CNAME":[';
  say '      {';
  say '         "priority":10,';
  say '         "value":"example.com"';
  say '      }';
  say '   ]';
  say '}';
  say "";
  say "Example 4 (For a domain):";
  say '{';
  say '   "DNS":[';
  say '      {';
  say '         "priority":10,';
  say '         "value":"ns1.example.com"';
  say '      },';
  say '      {';
  say '         "priority":20,';
  say '         "value":"ns2.example.com"';
  say '      }';
  say '   ],';
  say '   "DNS_IP":[';
  say '      {';
  say '         "priority":10,';
  say '         "value":"192.168.1.2"';
  say '      },';
  say '      {';
  say '         "priority":20,';
  say '         "value":"192.168.1.3"';
  say '      }';
  say '   ]';
  say '}';
  say "";
  say "Example 4 can only be used for domains served by BeGet. Up to 4 DNS records can be transferred.";
  say "If the DNS servers are not on one of the main domain subdomains, DNS_IP section may not be used.";
}

sub helpDnsSaveRecordsToFile {
  say 'Usage:';
  say '  beget-api-cli -m dns/saveRecordsToFile [options]';
  say "";
  say "Save domain or subdomain DNS-records to file";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
  say "  -d, --fqdn <type>                     Fully Qualified Domain Name (FQDN domain or subdomain)";
  say "  --file_path                           Path to the file";
  say "";
  say "Example:";
  say '  beget-api-cli -m dns/saveRecordsToFile -l login -p \'password\' -d example.com --file_path /home/user/file';
}

sub helpFtpGetListAccounts {
  say 'Usage:';
  say '  beget-api-cli -m ftp/getListAccounts [options]';
  say "";
  say "Get a list of additional FTP accounts";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
}

sub helpFtpAddAccount {
  say 'Usage:';
  say '  beget-api-cli -m ftp/addAccount [options]';
  say "";
  say "Add new FTP account";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
  say "  --ending <type>                       Second part of login, which follows the underscore (example - \"login_ending\")";
  say "  --home_dir <type>                     Path to home directory new FTP account";
  say "  --ftp_password <type>                 Password new FTP account";
  say "";
  say "Example:";
  say "  beget-api-cli -m ftp/addAccount -l login -p \'password\' --ending test --home_dir /site/public_html --ftp_password \'password\'";
  say "";
  say "Description:";
  say "  Path to home directory must start at the root of the account, which, in this case, is indicated by the symbol - /";
}

sub helpFtpChangePassword {
  say 'Usage:';
  say '  beget-api-cli -m ftp/changePassword [options]';
  say "";
  say "Change password of an additional FTP account";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
  say "  --ending <type>                       Second part of login, which follows the underscore (example - \"login_ending\")";
  say "  --ftp_password <type>                 Password new FTP account";
  say "";
  say "Example:";
  say "  beget-api-cli -m ftp/changePassword -l login -p \'password\' --ending test --ftp_password \'newpassword\'";
}

sub helpFtpDeleteAccount {
  say 'Usage:';
  say '  beget-api-cli -m ftp/deleteAccount [options]';
  say "";
  say "Delete FTP account";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
  say "  --ending <type>                       Second part of login, which follows the underscore (example - \"login_ending\")";
  say "";
  say "Example:";
  say "  beget-api-cli -m ftp/deleteAccount -l login -p \'password\' --ending test";
}

sub helpMysqlGetList {
  say 'Usage:';
  say '  beget-api-cli -m mysql/getList [options]';
  say "";
  say "Get databases list";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
}

sub helpMysqlAddDb {
  say 'Usage:';
  say '  beget-api-cli -m mysql/addDb [options]';
  say "";
  say "Add new database";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
  say "  --ending <type>                       Second part of database name, which follows the underscore (example - \"login_ending\")";
  say "  --mysql_password <type>               Password to connect from localhost to the created database";
  say "";
  say "Example:";
  say "  beget-api-cli -m mysql/addDb -l login -p \'password\' --ending test --mysql_password \'dbpassword\'";
}

sub helpMysqlAddAccess {
  say 'Usage:';
  say '  beget-api-cli -m mysql/addAccess [options]';
  say "";
  say "Add new access to database";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
  say "  --ending <type>                       Second part of database name, which follows the underscore (example - \"login_ending\")";
  say "  --access <type>                       FQDN or IP, or \'%\', or localhost";
  say "  --mysql_password <type>               Password for the connection by created access";
  say "";
  say "Example:";
  say "  beget-api-cli -m mysql/addAccess -l login -p \'password\' --ending test --access \'%\' --mysql_password \'dbpassword\'";
  say "";
  say "Description:";
  say "  % - Access from all addresses";
  say "  localhost - Access from the hosting server and phpMyAdmin";
}

sub helpMysqlDeleteDb {
  say 'Usage:';
  say '  beget-api-cli -m mysql/deleteDb [options]';
  say "";
  say "Delete database";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
  say "  --ending <type>                       Second part of database name, which follows the underscore (example - \"login_ending\")";
  say "";
  say "Example:";
  say "  beget-api-cli -m mysql/deleteDb -l login -p \'password\' --ending test";
}

sub helpMysqlDeleteAccess {
  say 'Usage:';
  say '  beget-api-cli -m mysql/deleteAccess [options]';
  say "";
  say "Delete access to database";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
  say "  --ending <type>                       Second part of database name, which follows the underscore (example - \"login_ending\")";
  say "  --access <type>                       FQDN or IP, or \'%\', or localhost";
  say "";
  say "Example:";
  say "  beget-api-cli -m mysql/deleteAccess -l login -p \'password\' --ending test --access \'%\'";
}

sub helpMysqlChangeAccessPassword {
  say 'Usage:';
  say '  beget-api-cli -m mysql/changeAccessPassword [options]';
  say "";
  say "Change access password";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
  say "  --ending <type>                       Second part of database name, which follows the underscore (example - \"login_ending\")";
  say "  --access <type>                       FQDN or IP, or \'%\', or localhost";
  say "  --mysql_password <type>               New password for access";
  say "";
  say "Example:";
  say "  beget-api-cli -m mysql/changeAccessPassword -l login -p \'password\' --ending test --access \'%\' --mysql_password \'newpassword\'";
}

sub helpSiteGetList {
  say 'Usage:';
  say '  beget-api-cli -m site/getList [options]';
  say "";
  say "Get sites list";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
}

sub helpSiteAdd {
  say 'Usage:';
  say '  beget-api-cli -m site/add [options]';
  say "";
  say "Add new site (e.g. ~/site/public_html)";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
  say "  --name <type>                         Site directory name";
  say "";
  say "Example:";
  say "  beget-api-cli -m site/add -l login -p \'password\' --name site";
  say "";
  say "In example above, the site directory will be created - ~/site/public_html";
  say "Response returns the ID of the created site (field - \"result\")";
}

sub helpSiteDelete {
  say 'Usage:';
  say '  beget-api-cli -m site/delete [options]';
  say "";
  say "Remove site without removing site directory on server";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
  say "  --site_id <type>                      Site ID";
  say "";
  say "Example:";
  say "  beget-api-cli -m site/delete -l login -p \'password\' --site_id 600000";
}

sub helpSiteLinkDomain {
  say 'Usage:';
  say '  beget-api-cli -m site/linkDomain [options]';
  say "";
  say "Link domain to site folder";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
  say "  -i, --domain_id <type>                Domain ID";
  say "  --site_id <type>                      Site ID";
  say "";
  say "Examples:";
  say "  beget-api-cli -m site/linkDomain -l login -p \'password\' -i 7000000 --site_id 5000000";
  say "  beget-api-cli -m site/linkDomain -l login -p \'password\' --domain_id 7000000 --site_id 5000000";
}

sub helpSiteUnlinkDomain {
  say 'Usage:';
  say '  beget-api-cli -m site/unlinkDomain [options]';
  say "";
  say "Unlink domain from site";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
  say "  -i, --domain_id <type>                Domain ID";
  say "";
  say "Example:";
  say "  beget-api-cli -m site/unlinkDomain -l login -p \'password\' -i 7000000";
}

sub helpSiteFreeze {
  say 'Usage:';
  say '  beget-api-cli -m site/freeze [options]';
  say "";
  say "Prohibit changing site files";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
  say "  --site_id <type>                      Site ID";
  say "";
  say "Example:";
  say "  beget-api-cli -m site/freeze -l login -p \'password\' --site_id 5000000";
}

sub helpSiteUnfreeze {
  say 'Usage:';
  say '  beget-api-cli -m site/unfreeze [options]';
  say "";
  say "Allow site files to be modified";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
  say "  --site_id <type>                      Site ID";
  say "";
  say "Example:";
  say "  beget-api-cli -m site/unfreeze -l login -p \'password\' --site_id 5000000";
}

sub helpSiteIsFrozen {
  say 'Usage:';
  say '  beget-api-cli -m site/isFrozen [options]';
  say "";
  say "Check freeze status";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
  say "  --site_id <type>                      Site ID";
  say "";
  say "Example:";
  say "  beget-api-cli -m site/isFrozen -l login -p \'password\' --site_id 5000000";
}

sub helpDomainGetList {
  say 'Usage:';
  say '  beget-api-cli -m domain/getList [options]';
  say "";
  say "Get domains list";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
}

sub helpDomainGetId {
  say 'Usage:';
  say '  beget-api-cli -m domain/getId [options]';
  say "";
  say "Get domain identifier. This method is designed to get domain ID, it will not work if you specify a subdomain in \$fqdn.";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
  say "  -d, --fqdn <type>                     Fully Qualified Domain Name";
  say "";
  say "Example:";
  say "  beget-api-cli -m domain/getId -l login -p \'password\' -d example.com";
}

sub helpDomainGetZoneList {
  say 'Usage:';
  say '  beget-api-cli -m domain/getZoneList [options]';
  say "";
  say "Get a list of domain zones, information about the cost of registration and renewal of domains in these zones";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
  say "";
  say "Example:";
  say "  beget-api-cli -m domain/getZoneList -l login -p \'password\'";
  say "";
  say "Example response:";
  say "  {";
  say "    \"ru\":{";
  say "      \"id\" : 1,                    // zone identifier";
  say "      \"zone\" : \"ru\",               // zone name";
  say "      \"price\" : 179,               // domain registration fee in the zone (in rubles)";
  say "      \"price_renew\" : 289,         // domain renewal cost in the zone (in rubles)";
  say "      \"price_idn\" : 179,           // IDN-domain registration fee in the zone (in rubles)";
  say "      \"price_renew_idn\" : 289,     // IDN-domain renewal cost in the zone (in rubles)";
  say "      \"is_idn\" : false,            // whether the zone supports IDN-domains";
  say "      \"is_national\" : true         // whether the zone is a national";
  say "      \"min_period\" : 1,            // minimum term of domain registration (in years)";
  say "      \"max_period\" : 1,            // maximum domain registration period (in years)";
  say "    },";
  say "    \"com\":{";
  say "      \"min_period\" : 1,            // minimum term of domain registration (in years)";
  say "      \"max_period\" : 1,            // maximum domain registration period (in years)";
  say "      \"is_idn\" : true,             // whether the zone supports IDN-domains";
  say "      \"is_national\" : false,       // whether the zone is a national";
  say "      \"price_idn_renew\" : 760,     // IDN-domain renewal cost in the zone (in rubles)";
  say "      \"price_idn\" : 760,           // IDN-domain registration fee in the zone (in rubles)";
  say "      \"price_renew\" : 760,         // domain renewal cost in the zone (in rubles)";
  say "      \"id\" : 2,                    // zone identifier";
  say "      \"price\" : 760,               // domain registration fee in the zone (in rubles)";
  say "      \"zone\" : \"com\"               // zone name";
  say "    },";
  say "  }";
}

sub helpDomainGetZoneId {
  say 'Usage:';
  say '  beget-api-cli -m domain/getZoneId [options]';
  say "";
  say "Get domain zone identifier";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
  say "  -z, --zone <type>                     Zone name (ru/com/org/de etc.)";
  say "";
  say "Example:";
  say "  beget-api-cli -m domain/getZoneId -l login -p \'password\' -z com";
}

sub helpDomainAdd {
  say 'Usage:';
  say '  beget-api-cli -m domain/add [options]';
  say "";
  say "Add domain to account";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
  say "  --dnwz <type>                         Domain name, without zone (In case of the domain \"example.com\" is \"example\")";
  say "  --zone_id <type>                      Zone identifier (You can find out the zone identifier using the method \"domain/getZoneId\")";
  say "";
  say "Example:";
  say "  beget-api-cli -m domain/add -l login -p \'password\' --dnwz example --zone_id 2";
  say "";
  say "Description:";
  say "  On successful execution, ID of the added domain is returned. If the domain has already been added on another account,";
  say "  then the error message \"Failed to add virtual domain \$dnwz\" will be returned";
}

sub helpDomainDelete {
  say 'Usage:';
  say '  beget-api-cli -m domain/delete [options]';
  say "";
  say "Delete domain from account. If the domain was linked to the site, it will be unlinked away from it,";
  say "all subdomains of this domain will be deleted.";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
  say "  -i, --domain_id <type>                Domain ID";
  say "";
  say "Example:";
  say "  beget-api-cli -m domain/delete -l login -p \'password\' -i 1000";
}

sub helpDomainGetSubdomainsList {
  say 'Usage:';
  say '  beget-api-cli -m domain/getSubdomainsList [options]';
  say "";
  say "Get subdomains list";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
}

sub helpDomainGetSubdomainId {
  say 'Usage:';
  say '  beget-api-cli -m domain/getSubdomainId [options]';
  say "";
  say "Get subdomain identifier";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
  say "  -d, --fqdn <type>                     Fully Qualified Domain Name (subdomain)";
  say "";
  say "Example:";
  say "  beget-api-cli -m domain/getSubdomainId -l login -p \'password\' -d sub.example.com";
}

sub helpDomainAddSubdomain {
  say 'Usage:';
  say '  beget-api-cli -m domain/addSubdomain [options]';
  say "";
  say "Add subdomain";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
  say "  -i, --domain_id <type>                Domain ID";
  say "  -s, --subdomain <type>                Subdomain (not a FQDN)";
  say "";
  say "Example:";
  say '  beget-api-cli -m domain/addSubdomain -l login -p \'password\' -i 1000 -s sub';
  say "";
  say "If the example.com has an id of 1000 and this domain is added to your account,";
  say "then a sub.example.com subdomain will be added to your account.";
  say "";
  say "This method returns the id of the added subdomain.";
}

sub helpDomainDeleteSubdomain {
  say 'Usage:';
  say '  beget-api-cli -m domain/deleteSubdomain [options]';
  say "";
  say "Delete subdomain";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
  say "  --subdomain_id <type>                 Subdomain ID";
  say "";
  say "Example:";
  say '  beget-api-cli -m domain/deleteSubdomain -l login -p \'password\' --subdomain_id 1000';
}

sub helpDomainCheckDomainToReg {
  say 'Usage:';
  say '  beget-api-cli -m domain/checkDomainToReg [options]';
  say "";
  say "Check domain to see if it can be registered. Additionally displays information about the account balance,";
  say "number of bonus domains in this zone and the presence or absence of the domain in the system.";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
  say "  --dnwz <type>                         Domain name, without zone (In case of the domain \"example.com\" is \"example\")";
  say "  --zone_id <type>                      Zone identifier (You can find out the zone identifier using the method \"domain/getZoneId\")";
  say "  --period <type>                       Registration period (in years)";
  say "";
  say "Example:";
  say "  beget-api-cli -m domain/checkDomainToReg -l login -p \'password\' --dnwz example --zone_id 2 --period 1";
  say "";
  say "Example response:";
  say '';
  say '{';
  say '   "status" : "success",';
  say '   "answer" : {';
  say '      "result" : {';
  say '         "pay_type" : false,               // method of domain registration, possible options:';
  say '                                           // false - not enough money to register a domain';
  say '                                           // null - it is impossible to pay for the domain';
  say '                                           // money - if there is enough money on the balance, the domain can be paid from the balance';
  say '                                           // bonus_domain - domain will be paid for by the bonus domain';
  say '         "price" : 179,                    // total cost of domain registration';
  say '         "bonus_domains" : 0,              // number of bonus domains on the account in the selected zone';
  say '         "balance" : 14.95,                // current account balance';
  say '         "may_be_registered" : true,       // сan a domain be registered?';
  say '         "in_system" : false               // is this domain added to one of the accounts?';
  say '      },';
  say '      "status" : "success"';
  say '   }';
  say '}';
  say '';
  say 'The values of the following fields are important for deciding whether a domain can be registered: may_be_registered, pay_type and in_system.';
  say 'In order to register a domain, their values must be as follows:';
  say '';
  say '  may_be_registered - true';
  say '  pay_type -  money or bonus_domain';
  say '  in_system -  false';
}

sub helpDomainGetPhpVersion {
  say 'Usage:';
  say '  beget-api-cli -m domain/getPhpVersion [options]';
  say "";
  say "Get information about the current version of php selected for the domain, the available php versions to install, and whether php is enabled as a cgi or not";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
  say "  -d, --fqdn <type>                     Fully Qualified Domain Name (domain or subdomain)";
  say "";
  say "Examples:";
  say "  beget-api-cli -m domain/getPhpVersion -l login -p \'password\' -d example.com";
  say "  beget-api-cli -m domain/getPhpVersion -l login -p \'password\' -d sub.example.com";
}

sub helpDomainChangePhpVersion {
  say 'Usage:';
  say '  beget-api-cli -m domain/changePhpVersion [options]';
  say "";
  say "Change PHP version of a domain or subdomain";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
  say "  -d, --fqdn <type>                     Fully Qualified Domain Name (domain or subdomain)";
  say "  -c, --is_cgi <type>                   0|1 (0 - Disable, 1 - Enable)";
  say "  -v, --php_version <type>              PHP version (e.g. \"7.3\")";
  say "";
  say "Examples:";
  say "  beget-api-cli -m domain/changePhpVersion -l login -p \'password\' -d example.com -c 0 -v 7.3";
  say "  beget-api-cli -m domain/changePhpVersion -l login -p \'password\' -d sub.example.com -c 1 -v 7.4";
}

sub helpDomainGetPhpDirectives {
  say 'Usage:';
  say '  beget-api-cli -m domain/getPhpDirectives [options]';
  say "";
  say "Get PHP directives for a domain or subdomain";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
  say "  -d, --fqdn <type>                     Fully Qualified Domain Name (domain or subdomain)";
  say "";
  say "Example:";
  say "  beget-api-cli -m domain/getPhpDirectives -l login -p \'password\' -d example.com";
}

sub helpDomainAddPhpDirectives {
  say 'Usage:';
  say '  beget-api-cli -m domain/addPhpDirectives [options]';
  say "";
  say "Add PHP directives for a domain or subdomain";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
  say "  -d, --fqdn <type>                     Fully Qualified Domain Name";
  say "  --php_directive                       PHP directives in the format: directive__name__value";
  say "";
  say "Examples:";
  say "  beget-api-cli -m domain/addPhpDirectives -l login -p \'password\' -d example.com --php_directive php_admin_value__memory_limit__256M";
  say "  beget-api-cli -m domain/addPhpDirectives -l login -p \'password\' -d m.ex.com --php_directive php_flag__log_errors__on --php_directive php_admin_value__default_charset__UTF-8";
  say "";
  say "Description:";
  say "  \"directive\" is chosen from the options - php_admin_flag, php_admin_value, php_value, php_flag";
  say "  \"name\" can contain - log_errors, memory_limit, default_charset and so on";
  say "  \"value\" can contain - on, off, other possible values of PHP directives";
  say "";
  say "When using this method, PHP directives are written into the Apache virtual host and are not added to the PHP directives editor in";
  say "the account control panel. Changes are not applied immediately, it usually takes a few minutes. You can verify the changes made";
  say "by placing a script with a call to the function phpinfo() in the root of the site and opening it in the browser.";
}

sub helpDomainRemovePhpDirectives {
  say 'Usage:';
  say '  beget-api-cli -m domain/removePhpDirectives [options]';
  say "";
  say "Remove PHP directives for a domain or subdomain";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
  say "  -d, --fqdn <type>                     Fully Qualified Domain Name";
  say "  --php_directive                       PHP directives in the format: directive__name__value";
  say "";
  say "Examples:";
  say "  beget-api-cli -m domain/removePhpDirectives -l login -p \'password\' -d example.com --php_directive php_admin_value__memory_limit__256M";
  say "  beget-api-cli -m domain/removePhpDirectives -l login -p \'password\' -d m.ex.com --php_directive php_admin_value__default_charset__UTF-8";
  say "";
  say "Description:";
  say "  \"directive\" is chosen from the options - php_admin_flag, php_admin_value, php_value, php_flag";
  say "  \"name\" can contain - log_errors, memory_limit, default_charset and so on";
  say "  \"value\" can contain - on, off, other possible values of PHP directives";
}

sub helpMailGetMailboxList {
  say 'Usage:';
  say '  beget-api-cli -m mail/getMailboxList [options]';
  say "";
  say "Get a list of mailboxes on the specified domain";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
  say "  -d, --fqdn <type>                     Fully Qualified Domain Name";
  say "";
  say "Example:";
  say "  beget-api-cli -m mail/getMailboxList -l login -p \'password\' -d example.com";
}

sub helpMailCreateMailbox {
  say 'Usage:';
  say '  beget-api-cli -m mail/createMailbox [options]';
  say "";
  say "Create mailbox";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
  say "  -d, --fqdn <type>                     Fully Qualified Domain Name";
  say "  --mailbox <type>                      Name of the mailbox, for example \"info\"";
  say "  --mpassword <type>                    Mailbox password";
  say "";
  say "Example:";
  say "  beget-api-cli -m mail/createMailbox -l login -p \'password\' -d example.com --mailbox info --mpassword \'mailboxpassword\'";
}

sub helpMailChangeMailboxPassword {
  say 'Usage:';
  say '  beget-api-cli -m mail/changeMailboxPassword [options]';
  say "";
  say "Change password for the selected mailbox";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
  say "  -d, --fqdn <type>                     Fully Qualified Domain Name";
  say "  --mailbox <type>                      Name of the mailbox, for example \"info\"";
  say "  --mpassword <type>                    New mailbox password";
  say "";
  say "Example:";
  say "  beget-api-cli -m mail/changeMailboxPassword -l login -p \'password\' -d example.com --mailbox info --mpassword \'newpassword\'";
}

sub helpMailChangeMailboxSettings {
  say 'Usage:';
  say '  beget-api-cli -m mail/changeMailboxSettings [options]';
  say "";
  say "Change mailbox settings (spam filter settings, redirects)";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
  say "  -d, --fqdn <type>                     Fully Qualified Domain Name";
  say "  --mailbox <type>                      Name of the mailbox, for example \"info\"";
  say "  --filter_st <type>                    Turn spam filter on or off. Possible values are 0 or 1. 0 - disable, 1 - enable";
  say "  --forward_st <type>                   Forward mode for mailbox. Possible values: no_forward, forward, forward_and_delete";
  say "";
  say "Example:";
  say "  beget-api-cli -m mail/changeMailboxSettings -l login -p \'password\' -d example.com --mailbox info --filter_st 1 --forward_st no_forward";
  say "";
  say "Description:";
  say "  \"no_forward\" - emails are not forwarded";
  say "  \"forward\" - emails are also forwarded to the specified mailboxes";
  say "  \"forward_and_delete\" - emails are forwarded and deleted from the mailbox";
  say "";
  say "When the mail forwarding option is enabled, the option to disable the spam filter becomes inactive. If you want to disable the spam filter,";
  say "\"--forward_st\" option must be set to \"no_forward\"";
}

sub helpMailDropMailbox {
  say 'Usage:';
  say '  beget-api-cli -m mail/dropMailbox [options]';
  say "";
  say "Delete mailbox";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
  say "  -d, --fqdn <type>                     Fully Qualified Domain Name";
  say "  --mailbox <type>                      Name of the mailbox, for example \"info\"";
  say "";
  say "Example:";
  say "  beget-api-cli -m mail/dropMailbox -l login -p \'password\' -d example.com --mailbox info";
}

sub helpMailForwardListAddMailbox {
  say 'Usage:';
  say '  beget-api-cli -m mail/forwardListAddMailbox [options]';
  say "";
  say "Add forward mailbox";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
  say "  -d, --fqdn <type>                     Fully Qualified Domain Name";
  say "  --mailbox <type>                      Name of the mailbox, for example \"info\"";
  say "  --fmailbox <type>                     Full name of the forwarding mailbox (together with FQDN, for example \"admin\\\@domain.com\")";
  say "";
  say "Examples:";
  say "  beget-api-cli -m mail/forwardListAddMailbox -l login -p \'password\' -d example.com --mailbox info --fmailbox admin\\\@domain.com";
  say "  beget-api-cli -m mail/forwardListAddMailbox -l login -p \'password\' -d example.com --mailbox info --fmailbox \'admin\@domain.com\'";
  say "";
  say "After adding mailboxes to the forwarding list, mail forwarding from the mailbox is not automatically enabled,";
  say "you must use the \"mail/changeMailboxSettings\" method to do this:";
  say "  beget-api-cli -m mail/changeMailboxSettings -l login -p \'password\' -d example.com --mailbox info --filter_st 1 --forward_st forward";
}

sub helpMailForwardListDelMailbox {
  say 'Usage:';
  say '  beget-api-cli -m mail/forwardListDelMailbox [options]';
  say "";
  say "Delete forward mailbox";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
  say "  -d, --fqdn <type>                     Fully Qualified Domain Name";
  say "  --mailbox <type>                      Name of the mailbox, for example \"info\"";
  say "  --fmailbox <type>                     Full name of the forwarding mailbox (together with FQDN, for example \"admin\\\@domain.com\")";
  say "";
  say "Examples:";
  say "  beget-api-cli -m mail/forwardListDelMailbox -l login -p \'password\' -d example.com --mailbox info --fmailbox admin\\\@domain.com";
  say "  beget-api-cli -m mail/forwardListDelMailbox -l login -p \'password\' -d example.com --mailbox info --fmailbox \'admin\@domain.com\'";
}

sub helpMailForwardListShow {
  say 'Usage:';
  say '  beget-api-cli -m mail/forwardListShow [options]';
  say "";
  say "Get forwarding list for selected mailbox";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
  say "  -d, --fqdn <type>                     Fully Qualified Domain Name";
  say "  --mailbox <type>                      Name of the mailbox, for example \"info\"";
  say "";
  say "Example:";
  say "  beget-api-cli -m mail/forwardListShow -l login -p \'password\' -d example.com --mailbox info";
}

sub helpMailSetDomainMail {
  say 'Usage:';
  say '  beget-api-cli -m mail/setDomainMail [options]';
  say "";
  say "Set up forwarding of emails that came to a non-existent email";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
  say "  -d, --fqdn <type>                     Fully Qualified Domain Name";
  say "  --dmailbox <type>                     Full name of the mailbox (together with FQDN, for example \"admin\\\@example.com\")";
  say "";
  say "Examples:";
  say "  beget-api-cli -m mail/setDomainMail -l login -p \'password\' -d example.com --dmailbox admin\\\@example.com";
  say "  beget-api-cli -m mail/setDomainMail -l login -p \'password\' -d example.com --dmailbox \'admin\@example.com\'";
}

sub helpMailClearDomainMail {
  say 'Usage:';
  say '  beget-api-cli -m mail/clearDomainMail [options]';
  say "";
  say "Delete a mailbox to which emails sent to non-existent emails are forwarded";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
  say "  -d, --fqdn <type>                     Fully Qualified Domain Name";
  say "";
  say "Example:";
  say "  beget-api-cli -m mail/clearDomainMail -l login -p \'password\' -d example.com";
}

sub helpStatGetSiteListLoad {
  say 'Usage:';
  say '  beget-api-cli -m stat/getSiteListLoad [options]';
  say "";
  say "Get information about the average load on the sites for the last month";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
  say "";
  say "Example:";
  say "  beget-api-cli -m stat/getSiteListLoad -l login -p \'password\'";
}

sub helpStatGetDbListLoad {
  say 'Usage:';
  say '  beget-api-cli -m stat/getDbListLoad [options]';
  say "";
  say "Get information about the average load on the databases for the last month";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
  say "";
  say "Example:";
  say "  beget-api-cli -m stat/getDbListLoad -l login -p \'password\'";
}

sub helpStatGetSiteLoad {
  say 'Usage:';
  say '  beget-api-cli -m stat/getSiteLoad [options]';
  say "";
  say "Get information about the load on the selected site (load by day and hour)";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
  say "  --site_id <type>                      Site ID";
  say "";
  say "Example:";
  say "  beget-api-cli -m stat/getSiteLoad -l login -p \'password\' --site_id 1000";
}

sub helpStatGetDbLoad {
  say 'Usage:';
  say '  beget-api-cli -m stat/getDbLoad [options]';
  say "";
  say "Get information about the load created by requests to the selected database (load by day and hour)";
  say "";
  say "Options:";
  say "  -l, --login <type>                    Customer login";
  say "  -p, --password <type>                 Customer password";
  say "  -D, --disable_urlencode               Disable URL encoding for password";
  say "  --fdbname <type>                      Full database name (\"login_ending\")";
  say "";
  say "Example:";
  say "  beget-api-cli -m stat/getDbLoad -l login -p \'password\' --fdbname login_ending";
}

sub accountInfo {
  my ($login, $enc_password) = @_;
  my $method = "user/getAccountInfo";
  my ($content, $length);

  $content = "output_format=json&login=$login&passwd=$enc_password";
  $length = length($content);

  sendRequest($content, $length, $method);
}

sub accountSsh {
  my ($login, $enc_password, $toggle_ssh) = @_;
  my $method = "user/toggleSsh";
  my ($content, $length);

  $content = "login=$login&passwd=$enc_password&status=$toggle_ssh&output_format=json";
  $length = length($content);

  sendRequest($content, $length, $method);
}

sub accountSshFtpUser {
  my ($login, $enc_password, $toggle_ssh, $ftpuser) = @_;
  my $method = "user/toggleSsh";
  my ($content, $length);

  $content = "login=$login&passwd=$enc_password&status=$toggle_ssh&ftplogin=$ftpuser&output_format=json";
  $length = length($content);
  
  sendRequest($content, $length, $method);
}

sub backupList {
  my ($login, $enc_password) = @_;
  my $method = "backup/getFileBackupList";
  my ($content, $length);

  $content = "output_format=json&login=$login&passwd=$enc_password";
  $length = length($content);

  sendRequest($content, $length, $method);
}

sub backupDbList {
  my ($login, $enc_password) = @_;
  my $method = "backup/getMysqlBackupList";
  my ($content, $length);

  $content = "output_format=json&login=$login&passwd=$enc_password";
  $length = length($content);

  sendRequest($content, $length, $method);
}

sub backupGetFileList {
  my ($login, $enc_password, $backup_id, $path) = @_;
  my $method = "backup/getFileList";
  my ($content, $length);

  $content = "output_format=json&login=$login&passwd=$enc_password&backup_id=$backup_id&path=$path";
  $length = length($content);

  sendRequest($content, $length, $method);
}

sub backupGetDbList {
  my ($login, $enc_password, $backup_id) = @_;
  my $method = "backup/getMysqlList";
  my ($content, $length);

  $content = "output_format=json&login=$login&passwd=$enc_password&backup_id=$backup_id";
  $length = length($content);

  sendRequest($content, $length, $method);
}

sub backupRestoreFile {
  my ($login, $enc_password, $backup_id, @paths) = @_;
  my $method = "backup/restoreFile";
  my ($json_input_data, $enc_json_input_data, $content, $length);

  my %input_data = (backup_id => $backup_id);
  push (@{$input_data {"paths"}}, (@paths));
  $json_input_data = encode_json \%input_data;
  $enc_json_input_data = url_encode_utf8($json_input_data);
  
  $content = "login=$login&passwd=$enc_password&input_format=json&output_format=json&input_data=$enc_json_input_data";
  $length = length($content);

  sendRequest($content, $length, $method);
}

sub backupRestoreDb {
  my ($login, $enc_password, $backup_id, @databases) = @_;
  my $method = "backup/restoreMysql";
  my ($json_input_data, $enc_json_input_data, $content, $length);

  my %input_data = (backup_id => $backup_id);
  push (@{$input_data {"bases"}}, (@databases));
  $json_input_data = encode_json \%input_data;
  $enc_json_input_data = url_encode_utf8($json_input_data);
  
  $content = "login=$login&passwd=$enc_password&input_format=json&output_format=json&input_data=$enc_json_input_data";
  $length = length($content);

  sendRequest($content, $length, $method);
}

sub backupDownloadFile {
  my ($login, $enc_password, $backup_id, @paths) = @_;
  my $method = "backup/downloadFile";
  my ($json_input_data, $enc_json_input_data, $content, $length);

  my %input_data = (backup_id => $backup_id);
  push (@{$input_data {"paths"}}, (@paths));
  $json_input_data = encode_json \%input_data;
  $enc_json_input_data = url_encode_utf8($json_input_data);
  
  $content = "login=$login&passwd=$enc_password&input_format=json&output_format=json&input_data=$enc_json_input_data";
  $length = length($content);

  sendRequest($content, $length, $method);
}

sub backupDownloadDb {
  my ($login, $enc_password, $backup_id, @databases) = @_;
  my $method = "backup/downloadMysql";
  my ($json_input_data, $enc_json_input_data, $content, $length);

  my %input_data = (backup_id => $backup_id);
  push (@{$input_data {"bases"}}, (@databases));
  $json_input_data = encode_json \%input_data;
  $enc_json_input_data = url_encode_utf8($json_input_data);
  
  $content = "login=$login&passwd=$enc_password&input_format=json&output_format=json&input_data=$enc_json_input_data";
  $length = length($content);

  sendRequest($content, $length, $method);
}

sub backupStatus {
  my ($login, $enc_password) = @_;
  my $method = "backup/getLog";
  my ($content, $length);

  $content = "output_format=json&login=$login&passwd=$enc_password";
  $length = length($content);

  sendRequest($content, $length, $method);
}

sub cronTabList {
  my ($login, $enc_password) = @_;
  my $method = "cron/getList";
  my ($content, $length);

  $content = "output_format=json&login=$login&passwd=$enc_password";
  $length = length($content);

  sendRequest($content, $length, $method);
}

sub cronTabAdd {
  my ($login, $enc_password, $minutes, $hours, $days, $months, $weekdays, $command) = @_;
  my $method = "cron/add";
  my ($json_input_data, $enc_json_input_data, $content, $length);

  my %input_data = (minutes => $minutes, hours => $hours, days => $days, months => $months, weekdays => $weekdays, command => $command);
  $json_input_data = encode_json \%input_data;
  $enc_json_input_data = url_encode_utf8($json_input_data);

  $content = "login=$login&passwd=$enc_password&input_format=json&output_format=json&input_data=$enc_json_input_data";
  $length = length($content);
  
  sendRequest($content, $length, $method);
}

sub cronTabEdit {
  my ($login, $enc_password, $task_id, $minutes, $hours, $days, $months, $weekdays, $command) = @_;
  my $method = "cron/edit";
  my ($json_input_data, $enc_json_input_data, $content, $length);

  my %input_data = (id => $task_id, minutes => $minutes, hours => $hours, days => $days, months => $months, weekdays => $weekdays, command => $command);
  $json_input_data = encode_json \%input_data;
  $enc_json_input_data = url_encode_utf8($json_input_data);

  $content = "login=$login&passwd=$enc_password&input_format=json&output_format=json&input_data=$enc_json_input_data";
  $length = length($content);

  sendRequest($content, $length, $method);
}

sub cronTabDelete {
  my ($login, $enc_password, $task_id) = @_;
  my $method = "cron/delete";
  my ($json_input_data, $enc_json_input_data, $content, $length);

  my %input_data = (row_number => $task_id);
  $json_input_data = encode_json \%input_data;
  $enc_json_input_data = url_encode_utf8($json_input_data);

  $content = "login=$login&passwd=$enc_password&input_format=json&output_format=json&input_data=$enc_json_input_data";
  $length = length($content);

  sendRequest($content, $length, $method);
}

sub cronTabToggleState {
  my ($login, $enc_password, $task_id, $task_state) = @_;
  my $method = "cron/changeHiddenState";
  my ($json_input_data, $enc_json_input_data, $content, $length);

  my %input_data = (row_number => $task_id, is_hidden => $task_state);
  $json_input_data = encode_json \%input_data;
  $enc_json_input_data = url_encode_utf8($json_input_data);

  $content = "login=$login&passwd=$enc_password&input_format=json&output_format=json&input_data=$enc_json_input_data";
  $length = length($content);

  sendRequest($content, $length, $method);
}

sub dnsGetRecords {
  my ($login, $enc_password, $fqdn) = @_;
  my $method = "dns/getData";
  my ($json_input_data, $enc_json_input_data, $content, $length);

  my %input_data = (fqdn => $fqdn);
  $json_input_data = encode_json \%input_data;
  $enc_json_input_data = url_encode_utf8($json_input_data);

  $content = "login=$login&passwd=$enc_password&input_format=json&output_format=json&input_data=$enc_json_input_data";
  $length = length($content);

  sendRequest($content, $length, $method);
}

sub dnsSetRecordsUsingFile {
  my ($login, $enc_password, $fqdn, $file_path) = @_;
  my $method = "dns/changeRecords";
  my ($json_input_data, $enc_json_input_data, $content, $length);

  my $records = do {
    open(my $json_fh, "<:encoding(UTF-8)", $file_path) or die("Can't open \"$file_path\": $!\n");
    local $/;
    <$json_fh>
  };
  $records =~ s/\n|\s(?!\w)//g;
  $json_input_data = qq/{"fqdn":"$fqdn","records":/ . "$records" . "}";
  $enc_json_input_data = url_encode_utf8($json_input_data);

  $content = "login=$login&passwd=$enc_password&input_format=json&output_format=json&input_data=$enc_json_input_data";
  $length = length($content);

  sendRequest($content, $length, $method);
}

sub dnsSaveRecordsToFile {
  my ($login, $enc_password, $fqdn, $file_path) = @_;
  my $method = "dns/getData";
  my ($json_input_data, $enc_json_input_data, $content, $length, $ua, $response, $json_string, $records);

  my %input_data = (fqdn => $fqdn);
  $json_input_data = encode_json \%input_data;
  $enc_json_input_data = url_encode_utf8($json_input_data);

  $content = "login=$login&passwd=$enc_password&input_format=json&output_format=json&input_data=$enc_json_input_data";
  $length = length($content);
  $ua  = HTTP::Tiny->new( 'verify_SSL' => '1' );
  $response = $ua->request(
    'POST' => "https://api.beget.com/api/$method",
    {
      headers => {
          'Accept'         => '*/*',
          'Content-Type'   => 'application/x-www-form-urlencoded',
          'Content-Length' => "$length",
          'User-Agent'     => 'curl/7.55.1'
      },
      content => "$content"
    },
  );
  die "Failed!\n" unless $response->{success};

  $json_string = $response->{content};
  $json_string =~ m/^(?:.*)\"records\":(?<records>.*\]\}),(?:.*)$/;
  $records = "$+{records}";
  $records =~ s/(\{)/$1\n/g;
  $records =~ s/(":\[)/$1\n/g;
  $records =~ s/(,)/$1\n/g;
  $records =~ s/\}(?!,)/\n\}\n/g;
  $records =~ s/(\},)/\n$1/g;
  $records =~ s/("[A-Z_]+":\[)/    $1/g;
  $records =~ s/(\])|(\],)/    $1/g;
  $records =~ s/(?<!^)(\{)/        $1/g;
  $records =~ s/(\})(?!$)/        $1/g;
  $records =~ s/("[a-z_]+"(.*[",a-z0-9]))/            $1/g;
  open my $fh, '>:encoding(UTF-8)', "$file_path" or warn "Could not open file - $!" and exit(3);
  say $fh $records;
  close $fh;
}

sub ftpGetListAccounts {
  my ($login, $enc_password) = @_;
  my $method = "ftp/getList";
  my ($content, $length);

  $content = "output_format=json&login=$login&passwd=$enc_password";
  $length = length($content);

  sendRequest($content, $length, $method);
}

sub ftpAddAccount {
  my ($login, $enc_password, $ending, $home_dir, $ftp_password) = @_;
  my $method = "ftp/add";
  my ($json_input_data, $enc_json_input_data, $flogin, $content, $length);

  $flogin = "$login" . "_" . "$ending";
  if (length($flogin) > 17) { say "Error! You entered too long a login ending. Please note that a login with an ending can\'t be longer than 17 characters."; exit 2; }

  my %input_data = (suffix => $ending, homedir => $home_dir, password => $ftp_password);
  $json_input_data = encode_json \%input_data;
  $enc_json_input_data = url_encode_utf8($json_input_data);

  $content = "login=$login&passwd=$enc_password&input_format=json&output_format=json&input_data=$enc_json_input_data";
  $length = length($content);

  sendRequest($content, $length, $method);
}

sub ftpChangePassword {
  my ($login, $enc_password, $ending, $ftp_password) = @_;
  my $method = "ftp/changePassword";
  my ($json_input_data, $enc_json_input_data, $content, $length);

  my %input_data = (suffix => $ending, password => $ftp_password);
  $json_input_data = encode_json \%input_data;
  $enc_json_input_data = url_encode_utf8($json_input_data);

  $content = "login=$login&passwd=$enc_password&input_format=json&output_format=json&input_data=$enc_json_input_data";
  $length = length($content);

  sendRequest($content, $length, $method);
}

sub ftpDeleteAccount {
  my ($login, $enc_password, $ending) = @_;
  my $method = "ftp/delete";
  my ($json_input_data, $enc_json_input_data, $content, $length);

  my %input_data = (suffix => $ending);
  $json_input_data = encode_json \%input_data;
  $enc_json_input_data = url_encode_utf8($json_input_data);

  $content = "login=$login&passwd=$enc_password&input_format=json&output_format=json&input_data=$enc_json_input_data";
  $length = length($content);

  sendRequest($content, $length, $method);
}

sub mysqlGetList {
  my ($login, $enc_password) = @_;
  my $method = "mysql/getList";
  my ($content, $length);

  $content = "output_format=json&login=$login&passwd=$enc_password";
  $length = length($content);

  sendRequest($content, $length, $method);
}

sub mysqlAddDb {
  my ($login, $enc_password, $ending, $mysql_password) = @_;
  my $method = "mysql/addDb";
  my ($json_input_data, $enc_json_input_data, $fdbname, $content, $length);

  $fdbname = "$login" . "_" . "$ending";
  if (length($fdbname) > 16) { say "Error! You entered too long an ending for the database name. Note that the database name cannot be longer than 16 characters."; exit 2; }
  if (length($mysql_password) < 6) { say "Error! You entered too short a password to connect to the database. The password must contain at least 6 characters."; exit 2; }

  my %input_data = (suffix => $ending, password => $mysql_password);
  $json_input_data = encode_json \%input_data;
  $enc_json_input_data = url_encode_utf8($json_input_data);

  $content = "login=$login&passwd=$enc_password&input_format=json&output_format=json&input_data=$enc_json_input_data";
  $length = length($content);

  sendRequest($content, $length, $method);
}

sub mysqlAddAccess {
  my ($login, $enc_password, $ending, $access, $mysql_password) = @_;
  my $method = "mysql/addAccess";
  my ($json_input_data, $enc_json_input_data, $content, $length);

  if (length($mysql_password) < 6) { say "Error! You entered too short a password to connect to the database. The password must contain at least 6 characters."; exit 2; }
  if ("$access" eq '*') { $access = '%'; }

  my %input_data = (suffix => $ending, access => $access, password => $mysql_password);
  $json_input_data = encode_json \%input_data;
  $enc_json_input_data = url_encode_utf8($json_input_data);

  $content = "login=$login&passwd=$enc_password&input_format=json&output_format=json&input_data=$enc_json_input_data";
  $length = length($content);

  sendRequest($content, $length, $method);
}

sub mysqlDeleteDb {
  my ($login, $enc_password, $ending) = @_;
  my $method = "mysql/dropDb";
  my ($json_input_data, $enc_json_input_data, $content, $length);

  my %input_data = (suffix => $ending);
  $json_input_data = encode_json \%input_data;
  $enc_json_input_data = url_encode_utf8($json_input_data);

  $content = "login=$login&passwd=$enc_password&input_format=json&output_format=json&input_data=$enc_json_input_data";
  $length = length($content);

  sendRequest($content, $length, $method);
}

sub mysqlDeleteAccess {
  my ($login, $enc_password, $ending, $access) = @_;
  my $method = "mysql/dropAccess";
  my ($json_input_data, $enc_json_input_data, $content, $length);

  my %input_data = (suffix => $ending, access => $access);
  $json_input_data = encode_json \%input_data;
  $enc_json_input_data = url_encode_utf8($json_input_data);

  $content = "login=$login&passwd=$enc_password&input_format=json&output_format=json&input_data=$enc_json_input_data";
  $length = length($content);

  sendRequest($content, $length, $method);
}

sub mysqlChangeAccessPassword {
  my ($login, $enc_password, $ending, $access, $mysql_password) = @_;
  my $method = "mysql/changeAccessPassword";
  my ($json_input_data, $enc_json_input_data, $content, $length);

  if (length($mysql_password) < 6) { say "Error! You entered too short a password to connect to the database. The password must contain at least 6 characters."; exit 2; }
  if ("$access" eq '*') { $access = '%'; }

  my %input_data = (suffix => $ending, access => $access, password => $mysql_password);
  $json_input_data = encode_json \%input_data;
  $enc_json_input_data = url_encode_utf8($json_input_data);

  $content = "login=$login&passwd=$enc_password&input_format=json&output_format=json&input_data=$enc_json_input_data";
  $length = length($content);

  sendRequest($content, $length, $method);
}

sub siteGetList {
  my ($login, $enc_password) = @_;
  my $method = "site/getList";
  my ($content, $length);

  $content = "output_format=json&login=$login&passwd=$enc_password";
  $length = length($content);

  sendRequest($content, $length, $method);
}

sub siteAdd {
  my ($login, $enc_password, $name) = @_;
  my $method = "site/add";
  my ($json_input_data, $enc_json_input_data, $content, $length);

  my %input_data = (name => $name);
  $json_input_data = encode_json \%input_data;
  $enc_json_input_data = url_encode_utf8($json_input_data);

  $content = "login=$login&passwd=$enc_password&input_format=json&output_format=json&input_data=$enc_json_input_data";
  $length = length($content);

  sendRequest($content, $length, $method);
}

sub siteDelete {
  my ($login, $enc_password, $site_id) = @_;
  my $method = "site/delete";
  my ($json_input_data, $enc_json_input_data, $content, $length);

  my %input_data = (id => $site_id);
  $json_input_data = encode_json \%input_data;
  $enc_json_input_data = url_encode_utf8($json_input_data);

  $content = "login=$login&passwd=$enc_password&input_format=json&output_format=json&input_data=$enc_json_input_data";
  $length = length($content);

  sendRequest($content, $length, $method);
}

sub siteLinkDomain {
  my ($login, $enc_password, $domain_id, $site_id) = @_;
  my $method = "site/linkDomain";
  my ($json_input_data, $enc_json_input_data, $content, $length);

  my %input_data = (domain_id => $domain_id, site_id => $site_id);
  $json_input_data = encode_json \%input_data;
  $enc_json_input_data = url_encode_utf8($json_input_data);

  $content = "login=$login&passwd=$enc_password&input_format=json&output_format=json&input_data=$enc_json_input_data";
  $length = length($content);

  sendRequest($content, $length, $method);
}

sub siteUnlinkDomain {
  my ($login, $enc_password, $domain_id) = @_;
  my $method = "site/unlinkDomain";
  my ($json_input_data, $enc_json_input_data, $content, $length);

  my %input_data = (domain_id => $domain_id);
  $json_input_data = encode_json \%input_data;
  $enc_json_input_data = url_encode_utf8($json_input_data);

  $content = "login=$login&passwd=$enc_password&input_format=json&output_format=json&input_data=$enc_json_input_data";
  $length = length($content);

  sendRequest($content, $length, $method);
}

sub siteFreeze {
  my ($login, $enc_password, $site_id, @ex_paths) = @_;
  my $method = "site/freeze";
  my ($json_input_data, $enc_json_input_data, $content, $length);

  my %input_data = (id => $site_id, excludedPaths => \@ex_paths);
  $json_input_data = encode_json \%input_data;
  $enc_json_input_data = url_encode_utf8($json_input_data);

  $content = "login=$login&passwd=$enc_password&input_format=json&output_format=json&input_data=$enc_json_input_data";
  $length = length($content);

  sendRequest($content, $length, $method);
}

sub siteUnfreeze {
  my ($login, $enc_password, $site_id) = @_;
  my $method = "site/unfreeze";
  my ($json_input_data, $enc_json_input_data, $content, $length);

  my %input_data = (id => $site_id);
  $json_input_data = encode_json \%input_data;
  $enc_json_input_data = url_encode_utf8($json_input_data);

  $content = "login=$login&passwd=$enc_password&input_format=json&output_format=json&input_data=$enc_json_input_data";
  $length = length($content);

  sendRequest($content, $length, $method);
}

sub siteIsFrozen {
  my ($login, $enc_password, $site_id) = @_;
  my $method = "site/isSiteFrozen";
  my ($json_input_data, $enc_json_input_data, $content, $length);

  my %input_data = (site_id => $site_id);
  $json_input_data = encode_json \%input_data;
  $enc_json_input_data = url_encode_utf8($json_input_data);

  $content = "login=$login&passwd=$enc_password&input_format=json&output_format=json&input_data=$enc_json_input_data";
  $length = length($content);

  sendRequest($content, $length, $method);
}

sub domainGetList {
  my ($login, $enc_password) = @_;
  my $method = "domain/getList";
  my ($content, $length);

  $content = "output_format=json&login=$login&passwd=$enc_password";
  $length = length($content);

  sendRequest($content, $length, $method);
}

sub domainGetId {
  my ($login, $enc_password, $fqdn) = @_;
  my $method = "domain/getList";
  my ($content, $length, $json_string, $domain_id, $ua, $response);

  $content = "output_format=json&login=$login&passwd=$enc_password";
  $length = length($content);
  $ua  = HTTP::Tiny->new( 'verify_SSL' => '1' );
  $response = $ua->request(
    'POST' => "https://api.beget.com/api/$method",
    {
      headers => {
          'Accept'         => '*/*',
          'Content-Type'   => 'application/x-www-form-urlencoded',
          'Content-Length' => "$length",
          'User-Agent'     => 'curl/7.55.1'
      },
      content => "$content"
    },
  );
  die "Failed!\n" unless $response->{success};

  $json_string = $response->{content};
  $json_string =~ m/^(?:.*)\{"id":(?<domain_id>\d+),"fqdn":"$fqdn",(?:.*)$/;
  say $domain_id = "$+{domain_id}";
}

sub domainGetZoneList {
  my ($login, $enc_password) = @_;
  my $method = "domain/getZoneList";
  my ($content, $length);

  $content = "output_format=json&login=$login&passwd=$enc_password";
  $length = length($content);

  sendRequest($content, $length, $method);
}

sub domainGetZoneId {
  my ($login, $enc_password, $zone) = @_;
  my $method = "domain/getZoneList";
  my ($content, $length, $json_string, $zone_id, $ua, $response);

  $content = "output_format=json&login=$login&passwd=$enc_password";
  $length = length($content);
  $ua  = HTTP::Tiny->new( 'verify_SSL' => '1' );
  $response = $ua->request(
    'POST' => "https://api.beget.com/api/$method",
    {
      headers => {
          'Accept'         => '*/*',
          'Content-Type'   => 'application/x-www-form-urlencoded',
          'Content-Length' => "$length",
          'User-Agent'     => 'curl/7.55.1'
      },
      content => "$content"
    },
  );
  die "Failed!\n" unless $response->{success};

  $json_string = $response->{content};
  $json_string =~ m/^(?:.*)\{"id":(?<zone_id>\d+),"zone":"$zone",(?:.*)$/;
  say $zone_id = "$+{zone_id}";
}

sub domainAdd {
  my ($login, $enc_password, $dnwz, $zone_id) = @_;
  my $method = "domain/addVirtual";
  my ($json_input_data, $enc_json_input_data, $content, $length);

  my %input_data = (hostname => $dnwz, zone_id => $zone_id);
  $json_input_data = encode_json \%input_data;
  $enc_json_input_data = url_encode_utf8($json_input_data);

  $content = "login=$login&passwd=$enc_password&input_format=json&output_format=json&input_data=$enc_json_input_data";
  $length = length($content);

  sendRequest($content, $length, $method);
}

sub domainDelete {
  my ($login, $enc_password, $domain_id) = @_;
  my $method = "domain/delete";
  my ($json_input_data, $enc_json_input_data, $content, $length);

  my %input_data = (id => $domain_id);
  $json_input_data = encode_json \%input_data;
  $enc_json_input_data = url_encode_utf8($json_input_data);

  $content = "login=$login&passwd=$enc_password&input_format=json&output_format=json&input_data=$enc_json_input_data";
  $length = length($content);

  sendRequest($content, $length, $method);
}

sub domainGetSubdomainsList {
  my ($login, $enc_password) = @_;
  my $method = "domain/getSubdomainList";
  my ($content, $length);

  $content = "output_format=json&login=$login&passwd=$enc_password";
  $length = length($content);

  sendRequest($content, $length, $method);
}

sub domainGetSubdomainId {
  my ($login, $enc_password, $fqdn) = @_;
  my $method = "domain/getSubdomainList";
  my ($content, $length, $json_string, $subdomain_id, $ua, $response);

  $content = "output_format=json&login=$login&passwd=$enc_password";
  $length = length($content);
  $ua  = HTTP::Tiny->new( 'verify_SSL' => '1' );
  $response = $ua->request(
    'POST' => "https://api.beget.com/api/$method",
    {
      headers => {
          'Accept'         => '*/*',
          'Content-Type'   => 'application/x-www-form-urlencoded',
          'Content-Length' => "$length",
          'User-Agent'     => 'curl/7.55.1'
      },
      content => "$content"
    },
  );
  die "Failed!\n" unless $response->{success};

  $json_string = $response->{content};
  $json_string =~ m/^(?:.*)\{"id":(?<subdomain_id>\d+),"fqdn":"$fqdn",(?:.*)$/;
  say $subdomain_id = "$+{subdomain_id}";
}

sub domainAddSubdomain {
  my ($login, $enc_password, $domain_id, $subdomain) = @_;
  my $method = "domain/addSubdomainVirtual";
  my ($json_input_data, $enc_json_input_data, $content, $length);
  
  my %input_data = (subdomain => $subdomain, domain_id => $domain_id);
  $json_input_data = encode_json \%input_data;
  $enc_json_input_data = url_encode_utf8($json_input_data);

  $content = "login=$login&passwd=$enc_password&input_format=json&output_format=json&input_data=$enc_json_input_data";
  $length = length($content);

  sendRequest($content, $length, $method);
}

sub domainDeleteSubdomain {
  my ($login, $enc_password, $subdomain_id) = @_;
  my $method = "domain/deleteSubdomain";
  my ($json_input_data, $enc_json_input_data, $content, $length);
  
  my %input_data = (id => $subdomain_id);
  $json_input_data = encode_json \%input_data;
  $enc_json_input_data = url_encode_utf8($json_input_data);

  $content = "login=$login&passwd=$enc_password&input_format=json&output_format=json&input_data=$enc_json_input_data";
  $length = length($content);

  sendRequest($content, $length, $method);
}

sub domainCheckDomainToReg {
  my ($login, $enc_password, $dnwz, $zone_id, $period) = @_;
  my $method = "domain/checkDomainToRegister";
  my ($json_input_data, $enc_json_input_data, $content, $length);
  
  my %input_data = (hostname => $dnwz, zone_id => $zone_id, period => $period);
  $json_input_data = encode_json \%input_data;
  $enc_json_input_data = url_encode_utf8($json_input_data);

  $content = "login=$login&passwd=$enc_password&input_format=json&output_format=json&input_data=$enc_json_input_data";
  $length = length($content);

  sendRequest($content, $length, $method);
}

sub domainGetPhpVersion {
  my ($login, $enc_password, $fqdn) = @_;
  my $method = "domain/getPhpVersion";
  my ($content, $length);

  $content = "login=$login&passwd=$enc_password&full_fqdn=$fqdn&output_format=json";
  $length = length($content);

  sendRequest($content, $length, $method);
}

sub domainChangePhpVersion {
  my ($login, $enc_password, $fqdn, $is_cgi, $php_version) = @_;
  my $method = "domain/changePhpVersion";
  my ($json_input_data, $enc_json_input_data, $content, $length);
  
  my %input_data = (full_fqdn => $fqdn, php_version => $php_version, is_cgi => $is_cgi);
  $json_input_data = encode_json \%input_data;
  $enc_json_input_data = url_encode_utf8($json_input_data);

  $content = "login=$login&passwd=$enc_password&input_format=json&output_format=json&input_data=$enc_json_input_data";
  $length = length($content);

  sendRequest($content, $length, $method);
}

sub domainGetPhpDirectives {
  my ($login, $enc_password, $fqdn) = @_;
  my $method = "domain/getDirectives";
  my ($json_input_data, $enc_json_input_data, $content, $length);
  
  my %input_data = (full_fqdn => $fqdn);
  $json_input_data = encode_json \%input_data;
  $enc_json_input_data = url_encode_utf8($json_input_data);

  $content = "login=$login&passwd=$enc_password&input_format=json&output_format=json&input_data=$enc_json_input_data";
  $length = length($content);

  sendRequest($content, $length, $method);
}

sub domainAddPhpDirectives {
  my ($login, $enc_password, $fqdn, @php_directive) = @_;
  my $method = "domain/addDirectives";
  my ($content, $length);
  my $directives_list_str = "";

  for ( my $i = 0; $i < scalar @php_directive; $i++ ) {
    my @tmp = split('__', $php_directive[$i]);
    $directives_list_str = "$directives_list_str" . "&directives_list[$i][name]=$tmp[0]&directives_list[$i][value]=$tmp[1] $tmp[2]";
  }

  $content = "login=$login&passwd=$enc_password&output_format=json&full_fqdn=$fqdn" . "$directives_list_str";
  $length = length($content);

  sendRequest($content, $length, $method);
}


sub domainRemovePhpDirectives {
  my ($login, $enc_password, $fqdn, @php_directive) = @_;
  my $method = "domain/removeDirectives";
  my ($content, $length);
  my $directives_list_str = "";

  for ( my $i = 0; $i < scalar @php_directive; $i++ ) {
    my @tmp = split('__', $php_directive[$i]);
    $directives_list_str = "$directives_list_str" . "&directives_list[$i][name]=$tmp[0]&directives_list[$i][value]=$tmp[1] $tmp[2]";
  }

  $content = "login=$login&passwd=$enc_password&output_format=json&full_fqdn=$fqdn" . "$directives_list_str";
  $length = length($content);

  sendRequest($content, $length, $method);
}

sub mailGetMailboxList {
  my ($login, $enc_password, $fqdn) = @_;
  my $method = "mail/getMailboxList";
  my ($json_input_data, $enc_json_input_data, $content, $length);
  
  my %input_data = (domain => $fqdn);
  $json_input_data = encode_json \%input_data;
  $enc_json_input_data = url_encode_utf8($json_input_data);

  $content = "login=$login&passwd=$enc_password&input_format=json&output_format=json&input_data=$enc_json_input_data";
  $length = length($content);

  sendRequest($content, $length, $method);
}

sub mailCreateMailbox {
  my ($login, $enc_password, $fqdn, $mailbox, $mpassword) = @_;
  my $method = "mail/createMailbox";
  my ($json_input_data, $enc_json_input_data, $content, $length);
  
  my %input_data = (domain => $fqdn, mailbox => $mailbox, mailbox_password => $mpassword);
  $json_input_data = encode_json \%input_data;
  $enc_json_input_data = url_encode_utf8($json_input_data);

  $content = "login=$login&passwd=$enc_password&input_format=json&output_format=json&input_data=$enc_json_input_data";
  $length = length($content);

  sendRequest($content, $length, $method);
}

sub mailChangeMailboxPassword {
  my ($login, $enc_password, $fqdn, $mailbox, $mpassword) = @_;
  my $method = "mail/changeMailboxPassword";
  my ($json_input_data, $enc_json_input_data, $content, $length);
  
  my %input_data = (domain => $fqdn, mailbox => $mailbox, mailbox_password => $mpassword);
  $json_input_data = encode_json \%input_data;
  $enc_json_input_data = url_encode_utf8($json_input_data);

  $content = "login=$login&passwd=$enc_password&input_format=json&output_format=json&input_data=$enc_json_input_data";
  $length = length($content);

  sendRequest($content, $length, $method);
}

sub mailChangeMailboxSettings {
  my ($login, $enc_password, $fqdn, $mailbox, $filter_st, $forward_st) = @_;
  my $method = "mail/changeMailboxSettings";
  my ($json_input_data, $enc_json_input_data, $content, $length);
  
  my %input_data = (domain => $fqdn, mailbox => $mailbox, spam_filter_status => $filter_st, spam_filter => 20, forward_mail_status => $forward_st);
  $json_input_data = encode_json \%input_data;
  $enc_json_input_data = url_encode_utf8($json_input_data);

  $content = "login=$login&passwd=$enc_password&input_format=json&output_format=json&input_data=$enc_json_input_data";
  $length = length($content);

  sendRequest($content, $length, $method);
}

sub mailDropMailbox {
  my ($login, $enc_password, $fqdn, $mailbox) = @_;
  my $method = "mail/dropMailbox";
  my ($json_input_data, $enc_json_input_data, $content, $length);
  
  my %input_data = (domain => $fqdn, mailbox => $mailbox);
  $json_input_data = encode_json \%input_data;
  $enc_json_input_data = url_encode_utf8($json_input_data);

  $content = "login=$login&passwd=$enc_password&input_format=json&output_format=json&input_data=$enc_json_input_data";
  $length = length($content);

  sendRequest($content, $length, $method);
}

sub mailForwardListAddMailbox {
  my ($login, $enc_password, $fqdn, $mailbox, $fmailbox) = @_;
  my $method = "mail/forwardListAddMailbox";
  my ($json_input_data, $enc_json_input_data, $content, $length);
  
  my %input_data = (domain => $fqdn, mailbox => $mailbox, forward_mailbox => $fmailbox);
  $json_input_data = encode_json \%input_data;
  $enc_json_input_data = url_encode_utf8($json_input_data);

  $content = "login=$login&passwd=$enc_password&input_format=json&output_format=json&input_data=$enc_json_input_data";
  $length = length($content);

  sendRequest($content, $length, $method);
}

sub mailForwardListDelMailbox {
  my ($login, $enc_password, $fqdn, $mailbox, $fmailbox) = @_;
  my $method = "mail/forwardListDeleteMailbox";
  my ($json_input_data, $enc_json_input_data, $content, $length);
  
  my %input_data = (domain => $fqdn, mailbox => $mailbox, forward_mailbox => $fmailbox);
  $json_input_data = encode_json \%input_data;
  $enc_json_input_data = url_encode_utf8($json_input_data);

  $content = "login=$login&passwd=$enc_password&input_format=json&output_format=json&input_data=$enc_json_input_data";
  $length = length($content);

  sendRequest($content, $length, $method);
}

sub mailForwardListShow {
  my ($login, $enc_password, $fqdn, $mailbox) = @_;
  my $method = "mail/forwardListShow";
  my ($json_input_data, $enc_json_input_data, $content, $length);
  
  my %input_data = (domain => $fqdn, mailbox => $mailbox);
  $json_input_data = encode_json \%input_data;
  $enc_json_input_data = url_encode_utf8($json_input_data);

  $content = "login=$login&passwd=$enc_password&input_format=json&output_format=json&input_data=$enc_json_input_data";
  $length = length($content);

  sendRequest($content, $length, $method);
}

sub mailSetDomainMail {
  my ($login, $enc_password, $fqdn, $dmailbox) = @_;
  my $method = "mail/setDomainMail";
  my ($json_input_data, $enc_json_input_data, $content, $length);
  
  my %input_data = (domain => $fqdn, domain_mailbox => $dmailbox);
  $json_input_data = encode_json \%input_data;
  $enc_json_input_data = url_encode_utf8($json_input_data);

  $content = "login=$login&passwd=$enc_password&input_format=json&output_format=json&input_data=$enc_json_input_data";
  $length = length($content);

  sendRequest($content, $length, $method);
}

sub mailClearDomainMail {
  my ($login, $enc_password, $fqdn) = @_;
  my $method = "mail/clearDomainMail";
  my ($json_input_data, $enc_json_input_data, $content, $length);
  
  my %input_data = (domain => $fqdn);
  $json_input_data = encode_json \%input_data;
  $enc_json_input_data = url_encode_utf8($json_input_data);

  $content = "login=$login&passwd=$enc_password&input_format=json&output_format=json&input_data=$enc_json_input_data";
  $length = length($content);

  sendRequest($content, $length, $method);
}

sub statGetSiteListLoad {
  my ($login, $enc_password) = @_;
  my $method = "stat/getSitesListLoad";
  my ($content, $length);

  $content = "output_format=json&login=$login&passwd=$enc_password";
  $length = length($content);

  sendRequest($content, $length, $method);
}

sub statGetDbListLoad {
  my ($login, $enc_password) = @_;
  my $method = "stat/getDbListLoad";
  my ($content, $length);

  $content = "output_format=json&login=$login&passwd=$enc_password";
  $length = length($content);

  sendRequest($content, $length, $method);
}

sub statGetSiteLoad {
  my ($login, $enc_password, $site_id) = @_;
  my $method = "stat/getSiteLoad";
  my ($json_input_data, $enc_json_input_data, $content, $length);
  
  my %input_data = (site_id => $site_id);
  $json_input_data = encode_json \%input_data;
  $enc_json_input_data = url_encode_utf8($json_input_data);

  $content = "login=$login&passwd=$enc_password&input_format=json&output_format=json&input_data=$enc_json_input_data";
  $length = length($content);

  sendRequest($content, $length, $method);
}

sub statGetDbLoad {
  my ($login, $enc_password, $fdbname) = @_;
  my $method = "stat/getDbLoad";
  my ($json_input_data, $enc_json_input_data, $content, $length);
  
  my %input_data = (db_name => $fdbname);
  $json_input_data = encode_json \%input_data;
  $enc_json_input_data = url_encode_utf8($json_input_data);

  $content = "login=$login&passwd=$enc_password&input_format=json&output_format=json&input_data=$enc_json_input_data";
  $length = length($content);

  sendRequest($content, $length, $method);
}

sub sendRequest {
  my ($content, $length, $method) = @_;
  my ($json, $json_string);

  my $ua  = HTTP::Tiny->new( 'verify_SSL' => '1' );
  my $response = $ua->request(
    'POST' => "https://api.beget.com/api/$method",
    {
      headers => {
          'Accept'         => '*/*',
          'Content-Type'   => 'application/x-www-form-urlencoded',
          'Content-Length' => "$length",
          'User-Agent'     => 'curl/7.55.1'
      },
      content => "$content"
    },
  );
  die "Failed!\n" unless $response->{success};

  $json_string = $response->{content};
  $json = 'JSON::PP'->new->pretty;
  print $json->encode($json->decode($json_string));
}

sub main {
  my (
    $help,
    $method,
    $login,
    $password,
    $disable_urlencode,
    $enc_password,
    $fqdn,
    $domain_id,
    $subdomain,
    $is_cgi,
    $php_version,
    $toggle_ssh,
    $ftpuser,
    $backup_id,
    $path,
    @paths,
    @databases,
    $minutes,
    $hours,
    $days,
    $months,
    $weekdays,
    $command,
    $task_id,
    $task_state,
    $file_path,
    $ending,
    $home_dir,
    $ftp_password,
    $mysql_password,
    $access,
    $name,
    $site_id,
    $zone,
    $zone_id,
    $dnwz,
    $subdomain_id,
    $period,
    @php_directive,
    $mailbox,
    $mpassword,
    $filter_st,
    $forward_st,
    $fmailbox,
    $dmailbox,
    $fdbname,
  );

  GetOptions(
  'help|h' => \$help,
  'method|m=s' => \$method,
  'login|l=s' => \$login,
  'password|p=s' => \$password,
  'disable_urlencode|D' => \$disable_urlencode,
  'fqdn|d=s' => \$fqdn,
  'domain_id|i=i' => \$domain_id,
  'subdomain|s=s' => \$subdomain,
  'is_cgi|c=i' => \$is_cgi,
  'php_version|v=s' => \$php_version,
  'toggle_ssh|t=i' => \$toggle_ssh,
  'ftpuser|f=s' => \$ftpuser,
  'backup_id=i' => \$backup_id,
  'path=s' => \$path,
  'paths=s' => \@paths,
  'databases=s' => \@databases,
  'minutes=s' => \$minutes,
  'hours=s' => \$hours,
  'days=s' => \$days,
  'months=s' => \$months,
  'weekdays=s' => \$weekdays,
  'command=s' => \$command,
  'task_id=i' => \$task_id,
  'task_state=i' => \$task_state,
  'file_path=s' => \$file_path,
  'ending=s' => \$ending,
  'home_dir=s' => \$home_dir,
  'ftp_password=s' => \$ftp_password,
  'mysql_password=s' => \$mysql_password,
  'access=s' => \$access,
  'name=s' => \$name,
  'site_id=i' => \$site_id,
  'ex_paths=s' => \@paths,
  'zone|z=s' => \$zone,
  'zone_id=i' => \$zone_id,
  'dnwz=s' =>\$dnwz,
  'subdomain_id=i' => \$subdomain_id,
  'period=i' => \$period,
  'php_directive=s' => \@php_directive,
  'mailbox=s' => \$mailbox,
  'mpassword=s' => \$mpassword,
  'filter_st=i' => \$filter_st,
  'forward_st=s' => \$forward_st,
  'fmailbox=s' => \$fmailbox,
  'dmailbox=s' => \$dmailbox,
  'fdbname=s' => \$fdbname,
  );

  if (defined($password) && $password =~ m/(.*)%(.*)/ && not defined($disable_urlencode)) {
    say "Warning: Password you entered contains special characters, such as \"%\". If you get the error \"AUTH_ERROR\" when entering a correct password,";
    say "please try to repeat the request using the \"-D, --disable_urlencode\" option.";
  }
  if (defined($password) && defined($disable_urlencode)) {
    $enc_password = "$password";
  }
  elsif (defined($password)) {
    $enc_password = url_encode_utf8($password);
  }
  
  if (!defined($method)) {
    help;
  }
  elsif (defined($help) && defined($method)) {
    given ($method) {
      when ('account/info') { helpAccountInfo;}
      when ('account/ssh') { helpAccountSsh;}
      when ('account/sshFtpUser') { helpAccountSshFtpUser;}
      when ('backup/list') { helpBackupList;}
      when ('backup/dbList') { helpBackupDbList;}
      when ('backup/getFileList') { helpBackupGetFileList;}
      when ('backup/getDbList') { helpBackupGetDbList;}
      when ('backup/restoreFile') { helpBackupRestoreFile;}
      when ('backup/restoreDb') { helpBackupRestoreDb;}
      when ('backup/downloadFile') { helpBackupDownloadFile;}
      when ('backup/downloadDb') { helpBackupDownloadDb;}
      when ('backup/status') { helpBackupStatus;}
      when ('crontab/list') { helpCronTabList;}
      when ('crontab/add') { helpCronTabAdd;}
      when ('crontab/edit') { helpCronTabEdit;}
      when ('crontab/delete') { helpCronTabDelete;}
      when ('crontab/toggleState') { helpCronTabToggleState;}
      when ('dns/getRecords') { helpDnsGetRecords;}
      when ('dns/setRecordsUsingFile') { helpDnsSetRecordsUsingFile;}
      when ('dns/saveRecordsToFile') { helpDnsSaveRecordsToFile;}
      when ('ftp/getListAccounts') { helpFtpGetListAccounts;}
      when ('ftp/addAccount') { helpFtpAddAccount;}
      when ('ftp/changePassword') { helpFtpChangePassword;}
      when ('ftp/deleteAccount') { helpFtpDeleteAccount;}
      when ('mysql/getList') { helpMysqlGetList;}
      when ('mysql/addDb') { helpMysqlAddDb;}
      when ('mysql/addAccess') { helpMysqlAddAccess;}
      when ('mysql/deleteDb') { helpMysqlDeleteDb;}
      when ('mysql/deleteAccess') { helpMysqlDeleteAccess;}
      when ('mysql/changeAccessPassword') { helpMysqlChangeAccessPassword;}
      when ('site/getList') { helpSiteGetList;}
      when ('site/add') { helpSiteAdd;}
      when ('site/delete') { helpSiteDelete;}
      when ('site/linkDomain') { helpSiteLinkDomain;}
      when ('site/unlinkDomain') { helpSiteUnlinkDomain;}
      when ('site/freeze') { helpSiteFreeze;}
      when ('site/unfreeze') { helpSiteUnfreeze;}
      when ('site/isFrozen') { helpSiteIsFrozen;}
      when ('domain/getList') { helpDomainGetList;}
      when ('domain/getId') { helpDomainGetId;}
      when ('domain/getZoneList') { helpDomainGetZoneList;}
      when ('domain/getZoneId') { helpDomainGetZoneId;}
      when ('domain/add') { helpDomainAdd;}
      when ('domain/delete') { helpDomainDelete;}
      when ('domain/getSubdomainsList') { helpDomainGetSubdomainsList;}
      when ('domain/getSubdomainId') { helpDomainGetSubdomainId;}
      when ('domain/addSubdomain') { helpDomainAddSubdomain;}
      when ('domain/deleteSubdomain') { helpDomainDeleteSubdomain;}
      when ('domain/checkDomainToReg') { helpDomainCheckDomainToReg;}
      when ('domain/getPhpVersion') { helpDomainGetPhpVersion;}
      when ('domain/changePhpVersion') { helpDomainChangePhpVersion;}
      when ('domain/getPhpDirectives') { helpDomainGetPhpDirectives;}
      when ('domain/addPhpDirectives') { helpDomainAddPhpDirectives;}
      when ('domain/removePhpDirectives') { helpDomainRemovePhpDirectives;}
      when ('mail/getMailboxList') { helpMailGetMailboxList;}
      when ('mail/createMailbox') { helpMailCreateMailbox;}
      when ('mail/changeMailboxPassword') { helpMailChangeMailboxPassword;}
      when ('mail/changeMailboxSettings') { helpMailChangeMailboxSettings;}
      when ('mail/dropMailbox') { helpMailDropMailbox;}
      when ('mail/forwardListAddMailbox') { helpMailForwardListAddMailbox;}
      when ('mail/forwardListDelMailbox') { helpMailForwardListDelMailbox;}
      when ('mail/forwardListShow') { helpMailForwardListShow;}
      when ('mail/setDomainMail') { helpMailSetDomainMail;}
      when ('mail/clearDomainMail') { helpMailClearDomainMail;}
      when ('stat/getSiteListLoad') { helpStatGetSiteListLoad;}
      when ('stat/getDbListLoad') { helpStatGetDbListLoad;}
      when ('stat/getSiteLoad') { helpStatGetSiteLoad;}
      when ('stat/getDbLoad') { helpStatGetDbLoad;}
      default { say "Error! There is no API request method!"; exit 1;}
    }
  }
  else {
    given ($method) {
      when ('account/info') { accountInfo($login, $enc_password);}
      when ('account/ssh') { accountSsh($login, $enc_password, $toggle_ssh);}
      when ('account/sshFtpUser') { accountSshFtpUser($login, $enc_password, $toggle_ssh, $ftpuser);}
      when ('backup/list') { backupList($login, $enc_password);}
      when ('backup/dbList') { backupDbList($login, $enc_password);}
      when ('backup/getFileList') { backupGetFileList($login, $enc_password, $backup_id, $path);}
      when ('backup/getDbList') { backupGetDbList($login, $enc_password, $backup_id);}
      when ('backup/restoreFile') { backupRestoreFile($login, $enc_password, $backup_id, @paths);}
      when ('backup/restoreDb') { backupRestoreDb($login, $enc_password, $backup_id, @databases);}
      when ('backup/downloadFile') { backupDownloadFile($login, $enc_password, $backup_id, @paths);}
      when ('backup/downloadDb') { backupDownloadDb($login, $enc_password, $backup_id, @databases);}
      when ('backup/status') { backupStatus($login, $enc_password);}
      when ('crontab/list') { cronTabList($login, $enc_password);}
      when ('crontab/add') { cronTabAdd($login, $enc_password, $minutes, $hours, $days, $months, $weekdays, $command);}
      when ('crontab/edit') { cronTabEdit($login, $enc_password, $task_id, $minutes, $hours, $days, $months, $weekdays, $command);}
      when ('crontab/delete') { cronTabDelete($login, $enc_password, $task_id);}
      when ('crontab/toggleState') { cronTabToggleState($login, $enc_password, $task_id, $task_state);}
      when ('dns/getRecords') { dnsGetRecords($login, $enc_password, $fqdn);}
      when ('dns/setRecordsUsingFile') { dnsSetRecordsUsingFile($login, $enc_password, $fqdn, $file_path);}
      when ('dns/saveRecordsToFile') { dnsSaveRecordsToFile($login, $enc_password, $fqdn, $file_path);}
      when ('ftp/getListAccounts') { ftpGetListAccounts($login, $enc_password);}
      when ('ftp/addAccount') { ftpAddAccount($login, $enc_password, $ending, $home_dir, $ftp_password);}
      when ('ftp/changePassword') { ftpChangePassword($login, $enc_password, $ending, $ftp_password);}
      when ('ftp/deleteAccount') { ftpDeleteAccount($login, $enc_password, $ending);}
      when ('mysql/getList') { mysqlGetList($login, $enc_password);}
      when ('mysql/addDb') { mysqlAddDb($login, $enc_password, $ending, $mysql_password);}
      when ('mysql/addAccess') { mysqlAddAccess($login, $enc_password, $ending, $access, $mysql_password);}
      when ('mysql/deleteDb') { mysqlDeleteDb($login, $enc_password, $ending);}
      when ('mysql/deleteAccess') { mysqlDeleteAccess($login, $enc_password, $ending, $access);}
      when ('mysql/changeAccessPassword') { mysqlChangeAccessPassword($login, $enc_password, $ending, $access, $mysql_password);}
      when ('site/getList') { siteGetList($login, $enc_password);}
      when ('site/add') { siteAdd($login, $enc_password, $name);}
      when ('site/delete') { siteDelete($login, $enc_password, $site_id);}
      when ('site/linkDomain') { siteLinkDomain($login, $enc_password, $domain_id, $site_id);}
      when ('site/unlinkDomain') { siteUnlinkDomain($login, $enc_password, $domain_id);}
      when ('site/freeze') { siteFreeze($login, $enc_password, $site_id, @paths);}
      when ('site/unfreeze') { siteUnfreeze($login, $enc_password, $site_id);}
      when ('site/isFrozen') { siteIsFrozen($login, $enc_password, $site_id);}
      when ('domain/getList') { domainGetList($login, $enc_password);}
      when ('domain/getId') { domainGetId($login, $enc_password, $fqdn);}
      when ('domain/getZoneList') { domainGetZoneList($login, $enc_password);}
      when ('domain/getZoneId') { domainGetZoneId($login, $enc_password, $zone);}
      when ('domain/add') { domainAdd($login, $enc_password, $dnwz, $zone_id);}
      when ('domain/delete') { domainDelete($login, $enc_password, $domain_id);}
      when ('domain/getSubdomainsList') { domainGetSubdomainsList($login, $enc_password);}
      when ('domain/getSubdomainId') { domainGetSubdomainId($login, $enc_password, $fqdn);}
      when ('domain/addSubdomain') { domainAddSubdomain($login, $enc_password, $domain_id, $subdomain);}
      when ('domain/deleteSubdomain') { domainDeleteSubdomain($login, $enc_password, $subdomain_id);}
      when ('domain/checkDomainToReg') { domainCheckDomainToReg($login, $enc_password, $dnwz, $zone_id, $period);}
      when ('domain/getPhpVersion') { domainGetPhpVersion($login, $enc_password, $fqdn);}
      when ('domain/changePhpVersion') { domainChangePhpVersion($login, $enc_password, $fqdn, $is_cgi, $php_version);}
      when ('domain/getPhpDirectives') { domainGetPhpDirectives($login, $enc_password, $fqdn);}
      when ('domain/addPhpDirectives') { domainAddPhpDirectives($login, $enc_password, $fqdn, @php_directive);}
      when ('domain/removePhpDirectives') { domainRemovePhpDirectives($login, $enc_password, $fqdn, @php_directive);}
      when ('mail/getMailboxList') { mailGetMailboxList($login, $enc_password, $fqdn);}
      when ('mail/createMailbox') { mailCreateMailbox($login, $enc_password, $fqdn, $mailbox, $mpassword);}
      when ('mail/changeMailboxPassword') { mailChangeMailboxPassword($login, $enc_password, $fqdn, $mailbox, $mpassword);}
      when ('mail/changeMailboxSettings') { mailChangeMailboxSettings($login, $enc_password, $fqdn, $mailbox, $filter_st, $forward_st);}
      when ('mail/dropMailbox') { mailDropMailbox($login, $enc_password, $fqdn, $mailbox);}
      when ('mail/forwardListAddMailbox') { mailForwardListAddMailbox($login, $enc_password, $fqdn, $mailbox, $fmailbox);}
      when ('mail/forwardListDelMailbox') { mailForwardListDelMailbox($login, $enc_password, $fqdn, $mailbox, $fmailbox);}
      when ('mail/forwardListShow') { mailForwardListShow($login, $enc_password, $fqdn, $mailbox);}
      when ('mail/setDomainMail') { mailSetDomainMail($login, $enc_password, $fqdn, $dmailbox);}
      when ('mail/clearDomainMail') { mailClearDomainMail($login, $enc_password, $fqdn);}
      when ('stat/getSiteListLoad') { statGetSiteListLoad($login, $enc_password);}
      when ('stat/getDbListLoad') { statGetDbListLoad($login, $enc_password);}
      when ('stat/getSiteLoad') { statGetSiteLoad($login, $enc_password, $site_id);}
      when ('stat/getDbLoad') { statGetDbLoad($login, $enc_password, $fdbname);}
      default { say "Error! There is no API request method!"; exit 1;}
    }
  }
}

main;
