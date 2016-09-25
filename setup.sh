#!/bin/bash

trap "exit 1" ERR

cd "$( dirname "${BASH_SOURCE[0]}" )"

CERTIFICATES_DIR="certificates"
JENKINS_KEY_NAME="jenkins_key"
NGINX_CERT_NAME="nginx-server"

createJenkinsSshKey() {
	echo -n "Generating Jenkins public key: "

	if [[ -r "${JENKINS_KEY_NAME}.pub" ]] && [[ -r "${JENKINS_KEY_NAME}" ]]; then
		echo "skipping"
		return;
	fi

	rm -f "${JENKINS_KEY_NAME}" "${JENKINS_KEY_NAME}.pub"
	ssh-keygen -N "" -f "${JENKINS_KEY_NAME}" > /dev/null 2>&1

	echo "done"
}

createNginxCertificate() {
	echo -n "Generating Nginx certificate: "
	if [[ -r "${NGINX_CERT_NAME}.crt" ]] && [[ -r "${NGINX_CERT_NAME}.key" ]]; then
		echo "skipping"
		return
	fi
	openssl req -x509 -newkey rsa:4096 -keyout "${NGINX_CERT_NAME}.key" -out "${NGINX_CERT_NAME}.crt" -days 3600 -nodes -subj '/CN=localhost/C=US/ST=Oregon/L=Portland/O=Company Name/OU=Org/CN=www.example.com' > /dev/null 2>&1
	echo "done"
}

mkdir -p "$CERTIFICATES_DIR"
cd "$CERTIFICATES_DIR"

createJenkinsSshKey
createNginxCertificate

