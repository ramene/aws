#!/bin/sh -l

# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -exou pipefail

env 

# If the GITHUB_ACTION variable is set, we'll do some extra things to make common tasks easier.
if [ ! -z "${GITHUB_WORKFLOW}" ]; then

    env

    root_path="$GITHUB_WORKSPACE"
    echo "GITHUB_WORKSPACE path is: ${root_path}"
    pulumi_ci="$GITHUB_WORKSPACE/.pulumi"
    echo "pulumi_ci path is: ${pulumi_ci}"
fi

# Extract the base64 encoded config data and write this to the KUBECONFIG
# TODO: Pass ARGS from Dockerfile for specific version(s) of aws-auth if so inclined
# IDEA: Allow using `jq` to query `pulumi stack export`, similar to storing terraform statefile in s3 - or maybe push our stack outputs back to GitHub and query specific, tagged releases which we would need to store anyway... I think

# echo "\`curl -O https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-06-05/aws-auth-cm.yaml\`"
curl -O https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-06-05/aws-auth-cm.yaml\

ls -alF
# export EKS_WORKER_ROLE=$( $pulumi_ci/stack | jq -r '.Stacks[0].Outputs[]|select(.OutputKey=="NodeInstanceRole")|.OutputValue')
# sed -i -e "s#<ARN of instance role (not instance profile)>#${EKS_WORKER_ROLE}#g" aws-auth-cm.yaml

# TODO: `base64 --decode` here
echo "\`cat ${pulumi_ci}/kubeconfig\`"
# echo "\`cat ${pulumi_ci}/kubeconfig | base64 --decode > ${pulumi_ci}/kubeconfig\`"
# echo "\`export KUBECONFIG=${pulumi_ci}/kubeconfig\`"

# sh -c "kubectl $*"

KUBECTL_COMMAND="kubectl -f $*"
OUTPUT_FILE=$(mktemp)

echo "\`$PULUMI_COMMAND\`"
echo "\`$pulumi_ci\`"
bash -c "$KUBECTL_COMMAND" | tee $OUTPUT_FILE

EXIT_CODE=${PIPESTATUS[0]}

