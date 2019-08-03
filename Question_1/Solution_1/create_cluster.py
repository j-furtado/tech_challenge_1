import os
import sys
import argparse
import requests
import json

# Checks if the token is valid by making a token list get request. 
# If the reply is a 200 OK, then the token should be valid
def test_token(workspace_region: str, token: str):
    headers = {
        'content-type': 'application/json',
        'authorization': 'Bearer ' + token
    }

    response = requests.get("https://{}.azuredatabricks.net/api/2.0/token/list".format(workspace_region), headers=headers)
    
    return True if response.status_code == 200 else False

# Creates a cluster with the configuration file given
# Make sure you set the relative path to the file!
def create_cluster(workspace_region: str, token: str, cluster_config_filename: str):
    headers = {
        'content-type': 'application/json',
        'authorization': 'Bearer ' + token
    }
    if not os.path.isfile(cluster_config_filename):
        print("File {} does not exist. Make sure you pass the right filename and relative path.")
        sys.exit(-1)

    with open(cluster_config_filename, "r") as configfile:
        cluster_data = json.load(configfile)

    response = requests.post("https://{}.azuredatabricks.net/api/2.0/clusters/create".format(
        workspace_region), data=None, json=cluster_data, headers=headers)

    if response.status_code == 200:
        response_data = json.loads(response.text)
        return response_data["cluster_id"]
    else:
        print("Cluster was not properly created.\nError: {}".format(response.text))
        sys.exit(-1)
    
    return None

def main(workspace_region: str, token: str, cluster_name: str):

    if not test_token(workspace_region, token):
        print("The token does not have the right permissions. Please make sure you create one with the necessary permissions to create clusters.")
        sys.exit(-1)

    cluster_id = create_cluster(workspace_region, token, cluster_name)
    print("Cluster created with ID: {}".format(cluster_id))

if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description='Create a databricks cluster.')
    parser.add_argument("-c", "--cluster_config",
                        help="Cluster configuration filename, in JSON format.", type=str, required=True)
    parser.add_argument("-w", "--workspace_region",
                        help="Azure Databricks Workspace region", type=str, required=True)
    parser.add_argument(
        "-t", "--token", help="Access token for Azure Databricks workspace", type=str, required=True)

    args = parser.parse_args()

    main(args.workspace_region, args.token, args.cluster_config)
