#!/bin/bash

set +x

echo "****************************"

echo "** Step initialize-config **"

echo "****************************"

export DEBUG=True;

cd scripts

sh config.sh ${APIC_PROJECT}

cd ..
echo "***************************"
echo "** Step initialize-build **"
echo "***************************"
cd scripts
python3 initialize_apic_deploy.py

cd ..
echo "****************************"
echo "** Step download-products **"
echo "****************************"
cd scripts
python3 download_product_files_from_git.py

cd ..
echo "************************"
echo "** Step download-apis **"
echo "************************"
# Pre-req for parsing YAML files
python3 -mpip install PyYAML > /dev/null
cd scripts
python3 download_api_files_from_git.py

cd ..
echo "***************************"
echo "** Step publish-products **"
echo "***************************"
# Pre-req for parsing YAML files and create HTTP requests
export PYTHONWARNINGS="ignore:Unverified HTTPS request"
python3 -mpip install PyYAML requests > /dev/null
cd scripts
python3 apic_platform_publish_to_catalog.py

cd ..
echo "**********************"
echo "** Step print-audit **"
echo "**********************"
cd scripts
python3 print_audit.py