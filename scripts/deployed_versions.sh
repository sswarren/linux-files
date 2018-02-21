#!/usr/bin/env bash

#echo "bash version $BASH_VERSION"

solrStack()
{ 
    local host=${1?Missing host name};
    local env;
    local ssh_options='-q -o StrictHostKeyChecking=no';
    #ssh ${ssh_options} ${host} "sudo docker ps -f name=\"_${env}_\" --format \"{{.Names}} | {{.Image}}\" | sort";
    ssh ${ssh_options} ${host} "sudo docker ps -f name=\"findtuner|fusion\" --format \"{{.Names}} | {{.Image}}\" | sort";
}

parseDeploymentToVersions()
{
  declare -A dockerPatternMap=(
     [ZooKeeper]=".*zookeeper-docker:"
     [Solr]=".*solr-docker:"
     [Fusion]=".*fusion-docker:"
     [FindTuner-Proxy]=".*findtuner-proxy_.*findtuner-proxy-docker:"
     [FindTuner-UI]=".*findtuner-jetty-docker:"
  )

  # Sample docker list
  : <<'END_COMMENT'
findtuner-jetty_test_b_2 | docker-registry.rei.com/findtuner-jetty-docker:2.7.0v18
findtuner-proxy_test_b_2 | docker-registry.rei.com/findtuner-proxy-docker:2.7.0v1
fusion-solr_test_b_2 | docker-registry.rei.com/solr-docker:6.6.0v4
fusion_test_b_2 | docker-registry.rei.com/fusion-docker:2.4.1v18
fusion-zookeeper_test_b_2 | docker-registry.rei.com/zookeeper-docker:3.4.6v12
END_COMMENT

  local solrStack==${1?Missing dockersList}
#echo "parseDeploymentToVersions.solrStack:"
#echo "$solrStack"

  local versionString=""
  local componentVersion
  for key in ZooKeeper Solr Fusion FindTuner-Proxy FindTuner-UI
  do
    local x=${dockerPatternMap[$key]}
    versionPlus=$(echo "$solrStack" | egrep -o "^$x.*\$")
    version="${versionPlus##*:}"
    if [[ -n "$version" ]]; then
      echo "component: ${key} -- version: '$version'" >&2
    fi
    versionString="$versionString${version}/"
  done

  echo "${versionString%/}"
}

versionList()
{
  local docker_envs=${1:-test qa prod};
  local hosts;
  for env in $docker_envs;
  do
    case "${env}" in 
      -h)
        echo "Usage: sh deployed_versions.sh [-h] [environment...]"
        echo "  environment: one or more of [test, qa, prod]. If absent, show all environments."
        ;;
      test)
        hosts="ulvaqsrdh01.rei.com ulvaqsrdh04.rei.com"
        ;;
      qa)
        hosts="ulvbqsrdh01.rei.com ulvbqsrdh04.rei.com"
        ;;
      prod)
        hosts="ulvapsrdh01.rei.com ulvapsrdh06.rei.com"
        ;;
    esac
    for host in ${hosts};
    do
      echo;
      echo "* ${env} - ${host} Docker processes";
      #echo "parsing service names to get versions"
      dockersList=$(solrStack $host)
      #echo "$dockersList"
      #versions=$(parseDeploymentToVersions "$dockersList")
      echo $(parseDeploymentToVersions "$dockersList")
    done
  done
}

versionList $@

