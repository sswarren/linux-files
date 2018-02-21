#!/usr/bin/env bash
getHostNames()
{
  local docker_envs=${1:-test qa prod}
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
        hosts=ulvbqsrdh{01,02,03,04,05,06}.rei.com
        ;;
      prod)
        # hosts=ulvapsrdh{01..10}.rei.com
        hosts=ulvapsrdh{01,02,03,04,05,06,07,08,09,10}.rei.com
        ;;
    esac
    local expandedHosts=$(eval "echo ${hosts}")

    echo
    #echo "** ${env} environment:"
  
  done
  echo "${expandedHosts}"
}

solrStack()
{ 
    local host=${1?Missing host name};
    local service=${2:-"findtuner|fusion"};
    local instance;
    local ssh_options='-q -o StrictHostKeyChecking=no';
    echo "* Host: $host"
    local dockerInstances=$(ssh ${ssh_options} ${host} "sudo docker ps -f name=\"$service\" --format \"{{.Names}}\" | sort");
    #echo "instances: $dockerInstances"
    for instance in $dockerInstances; do
      echo "** $instance"
      #ssh ${ssh_options} ${host} "sudo docker exec -ti $instance df"
      ssh ${ssh_options} ${host} "sudo docker exec $instance df" | head -2
    done
}

showSolrDf()
{
  local host
  local hosts=$(getHostNames $@)

  for host in $hosts; do
    solrStack $host $2
  done
}


showSolrDf $@
