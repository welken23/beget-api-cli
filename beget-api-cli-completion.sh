#!/usr/bin/env bash

_beget_api_cli_completions () {
  COMPREPLY=()                                                           
  CURRENT_ARG="${COMP_WORDS[COMP_CWORD]}"                                       
  LIST_INIT="-h --help -m --method"                                
  LIST_HELP="-m --method"                                      
  LIST_LOGIN="-l --login"
  LIST_PASS="-p --password"
  LIST_TOGGLE_SSH="-t --toggle_ssh"
  LIST_01="0 1"
  LIST_FTPUSER="-f --ftpuser"
  LIST_FQDN="-d --fqdn"
  LIST_DID="-i --domain_id"
  LIST_ZONE="-z --zone"
  LIST_SUB="-s --subdomain"
  LIST_CGI="-c --is_cgi"
  LIST_PHP="-v --php_version"
  LIST_FORW="no_forward forward forward_and_delete"

  if [[ ${COMP_CWORD} == 1 ]] ; then                                 
    COMPREPLY=( $(compgen -W "${LIST_INIT}" -- ${CURRENT_ARG}) )
    return 0                                                        
  fi

  FIRST_ARG="${COMP_WORDS[1]}"                                      
  case "${FIRST_ARG}" in                                           
    -h | --help)    if [[ ${COMP_CWORD} == 2 ]] ; then
                      COMPREPLY=( $(compgen -W "${LIST_HELP}" -- ${CURRENT_ARG}) )
                      return 0
                    fi
                    if [[ ${COMP_CWORD} == 3 ]] ; then                        
                      COMPREPLY=($(compgen -W "$(beget-api-cli|egrep "[a-z]/[a-z](.*)op"|awk '{print $1}')" -- ${CURRENT_ARG}))
                      return 0
                    fi
                    ;;
    -m | --method)  if [[ ${COMP_CWORD} == 2 ]] ; then
                      COMPREPLY=($(compgen -W "$(beget-api-cli|egrep "[a-z]/[a-z](.*)op"|awk '{print $1}')" -- ${CURRENT_ARG}))
                      return 0
                    fi
                    SECOND_ARG="${COMP_WORDS[2]}"
                    case "${SECOND_ARG}" in
                      account/info)                if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      account/ssh)                 if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 7 ]] ; then COMPREPLY=($(compgen -W "${LIST_TOGGLE_SSH}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 8 ]] ; then COMPREPLY=($(compgen -W "${LIST_01}" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      account/sshFtpUser)          if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 7 ]] ; then COMPREPLY=($(compgen -W "${LIST_TOGGLE_SSH}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 8 ]] ; then COMPREPLY=($(compgen -W "${LIST_01}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 9 ]] ; then COMPREPLY=($(compgen -W "${LIST_FTPUSER}" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      backup/list)                 if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      backup/dblist)               if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      backup/getFileList)          if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 7 ]] ; then COMPREPLY=($(compgen -W "--backup_id" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 9 ]] ; then COMPREPLY=($(compgen -W "--path" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      backup/getDbList)            if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 7 ]] ; then COMPREPLY=($(compgen -W "--backup_id" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      backup/restoreFile)          if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 7 ]] ; then COMPREPLY=($(compgen -W "--backup_id" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 9 ]] ; then COMPREPLY=($(compgen -W "--paths" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      backup/restoreDb)            if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 7 ]] ; then COMPREPLY=($(compgen -W "--backup_id" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 9 ]] ; then COMPREPLY=($(compgen -W "--databases" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      backup/downloadFile)         if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 7 ]] ; then COMPREPLY=($(compgen -W "--backup_id" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 9 ]] ; then COMPREPLY=($(compgen -W "--paths" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      backup/downloadDb)           if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 7 ]] ; then COMPREPLY=($(compgen -W "--backup_id" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 9 ]] ; then COMPREPLY=($(compgen -W "--databases" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      backup/status)               if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      crontab/list)                if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      crontab/add)                 if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 7 ]] ; then COMPREPLY=($(compgen -W "--minutes" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 9 ]] ; then COMPREPLY=($(compgen -W "--hours" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 11 ]] ; then COMPREPLY=($(compgen -W "--days" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 13 ]] ; then COMPREPLY=($(compgen -W "--months" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 15 ]] ; then COMPREPLY=($(compgen -W "--weekdays" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 17 ]] ; then COMPREPLY=($(compgen -W "--command" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      crontab/edit)                if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 7 ]] ; then COMPREPLY=($(compgen -W "--task_id" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 9 ]] ; then COMPREPLY=($(compgen -W "--minutes" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 11 ]] ; then COMPREPLY=($(compgen -W "--hours" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 13 ]] ; then COMPREPLY=($(compgen -W "--days" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 15 ]] ; then COMPREPLY=($(compgen -W "--months" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 17 ]] ; then COMPREPLY=($(compgen -W "--weekdays" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 19 ]] ; then COMPREPLY=($(compgen -W "--command" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      crontab/delete)              if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 7 ]] ; then COMPREPLY=($(compgen -W "--task_id" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      crontab/toggleState)         if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 7 ]] ; then COMPREPLY=($(compgen -W "--task_id" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 9 ]] ; then COMPREPLY=($(compgen -W "--task_state" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      dns/getRecords)              if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 7 ]] ; then COMPREPLY=($(compgen -W "${LIST_FQDN}" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      dns/setRecordsUsingFile)     if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 7 ]] ; then COMPREPLY=($(compgen -W "${LIST_FQDN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 9 ]] ; then COMPREPLY=($(compgen -W "--file_path" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      dns/saveRecordsToFile)       if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 7 ]] ; then COMPREPLY=($(compgen -W "${LIST_FQDN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 9 ]] ; then COMPREPLY=($(compgen -W "--file_path" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      ftp/getListAccounts)         if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      ftp/addAccount)              if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 7 ]] ; then COMPREPLY=($(compgen -W "--ending" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 9 ]] ; then COMPREPLY=($(compgen -W "--home_dir" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 11 ]] ; then COMPREPLY=($(compgen -W "--ftp_password" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      ftp/changePassword)          if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 7 ]] ; then COMPREPLY=($(compgen -W "--ending" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 9 ]] ; then COMPREPLY=($(compgen -W "--ftp_password" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      ftp/deleteAccount)           if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 7 ]] ; then COMPREPLY=($(compgen -W "--ending" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      mysql/getList)               if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      mysql/addDb)                 if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 7 ]] ; then COMPREPLY=($(compgen -W "--ending" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 9 ]] ; then COMPREPLY=($(compgen -W "--mysql_password" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      mysql/addAccess)             if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 7 ]] ; then COMPREPLY=($(compgen -W "--ending" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 9 ]] ; then COMPREPLY=($(compgen -W "--access" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 11 ]] ; then COMPREPLY=($(compgen -W "--mysql_password" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      mysql/deleteDb)              if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 7 ]] ; then COMPREPLY=($(compgen -W "--ending" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      mysql/deleteAccess)          if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 7 ]] ; then COMPREPLY=($(compgen -W "--ending" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 9 ]] ; then COMPREPLY=($(compgen -W "--access" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      mysql/changeAccessPassword)  if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 7 ]] ; then COMPREPLY=($(compgen -W "--ending" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 9 ]] ; then COMPREPLY=($(compgen -W "--access" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 11 ]] ; then COMPREPLY=($(compgen -W "--mysql_password" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      site/getList)                if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      site/add)                    if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 7 ]] ; then COMPREPLY=($(compgen -W "--name" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      site/delete)                 if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 7 ]] ; then COMPREPLY=($(compgen -W "--site_id" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      site/linkDomain)             if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 7 ]] ; then COMPREPLY=($(compgen -W "${LIST_DID}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 9 ]] ; then COMPREPLY=($(compgen -W "--site_id" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      site/unlinkDomain)           if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 7 ]] ; then COMPREPLY=($(compgen -W "${LIST_DID}" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      site/freeze)                 if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 7 ]] ; then COMPREPLY=($(compgen -W "--site_id" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      site/unfreeze)               if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 7 ]] ; then COMPREPLY=($(compgen -W "--site_id" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      site/isFrozen)               if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 7 ]] ; then COMPREPLY=($(compgen -W "--site_id" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      domain/getList)              if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      domain/getId)                if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 7 ]] ; then COMPREPLY=($(compgen -W "${LIST_FQDN}" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      domain/getZoneList)          if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      domain/getZoneId)            if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 7 ]] ; then COMPREPLY=($(compgen -W "${LIST_ZONE}" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      domain/add)                  if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 7 ]] ; then COMPREPLY=($(compgen -W "--dnwz" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 9 ]] ; then COMPREPLY=($(compgen -W "--zone_id" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      domain/delete)               if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 7 ]] ; then COMPREPLY=($(compgen -W "${LIST_DID}" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      domain/getSubdomainsList)    if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      domain/getSubdomainId)       if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 7 ]] ; then COMPREPLY=($(compgen -W "${LIST_FQDN}" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      domain/addSubdomain)         if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 7 ]] ; then COMPREPLY=($(compgen -W "${LIST_DID}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 9 ]] ; then COMPREPLY=($(compgen -W "${LIST_SUB}" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      domain/deleteSubdomain)      if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 7 ]] ; then COMPREPLY=($(compgen -W "--subdomain_id" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      domain/checkDomainToReg)     if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 7 ]] ; then COMPREPLY=($(compgen -W "--dnwz" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 9 ]] ; then COMPREPLY=($(compgen -W "--zone_id" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 11 ]] ; then COMPREPLY=($(compgen -W "--period" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      domain/getPhpVersion)        if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 7 ]] ; then COMPREPLY=($(compgen -W "${LIST_FQDN}" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      domain/changePhpVersion)     if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 7 ]] ; then COMPREPLY=($(compgen -W "${LIST_FQDN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 9 ]] ; then COMPREPLY=($(compgen -W "${LIST_CGI}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 11 ]] ; then COMPREPLY=($(compgen -W "${LIST_PHP}" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      domain/getPhpDirectives)     if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 7 ]] ; then COMPREPLY=($(compgen -W "${LIST_FQDN}" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      domain/addPhpDirectives)     if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 7 ]] ; then COMPREPLY=($(compgen -W "${LIST_FQDN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 9 ]] ; then COMPREPLY=($(compgen -W "--php_directive" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      domain/removePhpDirectives)  if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 7 ]] ; then COMPREPLY=($(compgen -W "${LIST_FQDN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 9 ]] ; then COMPREPLY=($(compgen -W "--php_directive" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      mail/getMailboxList)         if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 7 ]] ; then COMPREPLY=($(compgen -W "${LIST_FQDN}" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      mail/createMailbox)          if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 7 ]] ; then COMPREPLY=($(compgen -W "${LIST_FQDN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 9 ]] ; then COMPREPLY=($(compgen -W "--mailbox" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 11 ]] ; then COMPREPLY=($(compgen -W "--mpassword" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      mail/changeMailboxPassword)  if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 7 ]] ; then COMPREPLY=($(compgen -W "${LIST_FQDN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 9 ]] ; then COMPREPLY=($(compgen -W "--mailbox" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 11 ]] ; then COMPREPLY=($(compgen -W "--mpassword" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      mail/changeMailboxSettings)  if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 7 ]] ; then COMPREPLY=($(compgen -W "${LIST_FQDN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 9 ]] ; then COMPREPLY=($(compgen -W "--mailbox" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 11 ]] ; then COMPREPLY=($(compgen -W "--filter_st" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 12 ]] ; then COMPREPLY=($(compgen -W "${LIST_01}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 13 ]] ; then COMPREPLY=($(compgen -W "--forward_st" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 14 ]] ; then COMPREPLY=($(compgen -W "${LIST_FORW}" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      mail/dropMailbox)            if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 7 ]] ; then COMPREPLY=($(compgen -W "${LIST_FQDN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 9 ]] ; then COMPREPLY=($(compgen -W "--mailbox" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      mail/forwardListAddMailbox)  if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 7 ]] ; then COMPREPLY=($(compgen -W "${LIST_FQDN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 9 ]] ; then COMPREPLY=($(compgen -W "--mailbox" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 11 ]] ; then COMPREPLY=($(compgen -W "--fmailbox" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      mail/forwardListDelMailbox)  if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 7 ]] ; then COMPREPLY=($(compgen -W "${LIST_FQDN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 9 ]] ; then COMPREPLY=($(compgen -W "--mailbox" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 11 ]] ; then COMPREPLY=($(compgen -W "--fmailbox" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      mail/forwardListShow)        if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 7 ]] ; then COMPREPLY=($(compgen -W "${LIST_FQDN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 9 ]] ; then COMPREPLY=($(compgen -W "--mailbox" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      mail/setDomainMail)          if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 7 ]] ; then COMPREPLY=($(compgen -W "${LIST_FQDN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 9 ]] ; then COMPREPLY=($(compgen -W "--dmailbox" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      mail/clearDomainMail)        if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 7 ]] ; then COMPREPLY=($(compgen -W "${LIST_FQDN}" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      stat/getSiteListLoad)        if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      stat/getDbListLoad)          if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      stat/getSiteLoad)            if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 7 ]] ; then COMPREPLY=($(compgen -W "--site_id" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                      stat/getDbLoad)              if [[ ${COMP_CWORD} == 3 ]] ; then COMPREPLY=($(compgen -W "${LIST_LOGIN}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 5 ]] ; then COMPREPLY=($(compgen -W "${LIST_PASS}" -- ${CURRENT_ARG})); return 0; fi
                                                   if [[ ${COMP_CWORD} == 7 ]] ; then COMPREPLY=($(compgen -W "--fdbname" -- ${CURRENT_ARG})); return 0; fi
                                                   ;;
                    esac

  esac
  return 0
}

complete -F _beget_api_cli_completions beget-api-cli
