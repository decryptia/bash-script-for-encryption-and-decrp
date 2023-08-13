#!/bin/bash

mkdir systA
mkdir systB

openssl genpkey -algorithm RSA -out A_private.pem
openssl rsa -pubout -in A_private.pem -out A_public.pem
openssl genpkey -algorithm RSA -out B_private.pem
openssl rsa -pubout -in B_private.pem -out B_public.pem


dataA="Hello diya"
dataB="Hello jb"
symmetrickeys="kali"

echo "$dataA" | openssl enc -aes-256-cbc -k "$symmetrickeys" -out encryptedA.enc
echo "$dataB" | openssl enc -aes-256-cbc -k "$symmetrickeys" -out encrytptedB.enc

cp B_public.pem sysA
cp A_public.pem sysB

openssl dgst -sha256 -sign A_private.pem -out signatureA.sha encryptedA.enc
openssl dgst -sha256 -sign B_private.pem -out signatureB.sha encryptedB.enc

#SystemA decrypts Systemb's Data
openssl enc -aes-256-cbc -d -k "$symmetrickeys" -in encryptedB.enc -out decryptedB.txt
openssl dgst -sha256 -verify B_public.pem -signature signatureB.sha encryptedB.enc

#systemb decrypts systemA's Data
openssl enc -aes-256-cbc -d -k "$symmetrickeys" -in encryptedA.enc -out decryptedA.txt
opessl dgst -sha256 -verify A_public.pem -signature signatureA.sha encryptedA.enc

echo "Decrypted data from systemA: $(cat decryptedA.txt)"
echo "Decrypted data from systemB: $(cat decryptedB.txt)"      


