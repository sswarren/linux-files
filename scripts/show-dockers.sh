#!/usr/bin/env bash
dockers1()
{
  local docker_envs=${1:-test qa prod}
  local ssh_options='-q -o StrictHostKeyChecking=no'
  local host
  local hosts
  local env
  
  for env in $docker_envs; do
    case "${env}" in
      test)
        # hosts=ulvaqsrdh{01..06}.rei.com
        hosts=ulvaqsrdh{01,02,03,04,05,06}.rei.com
        ;;
      qa)
        # hosts="ulvbqsrdh{01..06}.rei.com ulvaqsrdh{01..06}.rei.com"
        hosts="ulvbqsrdh{01,02,03,04,05,06}.rei.com ulvaqsrdh{01,02,03,04,05,06}.rei.com"
        ;;
      prod)
        # hosts=ulvapsrdh{01..10}.rei.com
        hosts=ulvapsrdh{01,02,03,04,05,06,07,08,09,10}.rei.com
        ;;
    esac
    local expandedHosts=$(eval "echo ${hosts}")

    echo
    echo "** ${env} environment:"
  
    for host in ${expandedHosts}; do
      echo
      echo "* ${host} Docker processes"
      ssh ${ssh_options} ${host} "sudo docker ps -f name=\"_${env}_\" --format \"{{.Names}} | {{.Image}}\" | sort"
    done
  done
}

dockers1 $@
