Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n23EaZhl017083
	for <video4linux-list@redhat.com>; Tue, 3 Mar 2009 09:36:35 -0500
Received: from mho-02-bos.mailhop.org (mho-02-bos.mailhop.org [63.208.196.179])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n23EZYSx003940
	for <video4linux-list@redhat.com>; Tue, 3 Mar 2009 09:35:34 -0500
Received: from ip68-13-161-195.om.om.cox.net ([68.13.161.195]
	helo=yuki.tsukinokage.net)
	by mho-02-bos.mailhop.org with esmtpa (Exim 4.68)
	(envelope-from <nombrandue@tsukinokage.net>) id 1LeViX-000Cy2-AJ
	for video4linux-list@redhat.com; Tue, 03 Mar 2009 14:35:33 +0000
Received: from localhost (yuki.tsukinokage.net [127.0.0.1])
	by yuki.tsukinokage.net (Postfix) with ESMTP id 330D71A106C1
	for <video4linux-list@redhat.com>; Tue,  3 Mar 2009 08:35:31 -0600 (CST)
Received: from yuki.tsukinokage.net ([127.0.0.1])
	by localhost (yuki.tsukinokage.net [127.0.0.1]) (amavisd-new,
	port 10026)
	with ESMTP id jFvYfIS0Rd8m for <video4linux-list@redhat.com>;
	Tue,  3 Mar 2009 08:35:29 -0600 (CST)
Received: from haruhi.tsukinokage.net (haruhi.tsukinokage.net [192.168.10.2])
	by yuki.tsukinokage.net (Postfix) with ESMTP id C33961A1048E
	for <video4linux-list@redhat.com>; Tue,  3 Mar 2009 08:35:28 -0600 (CST)
Received: from [127.0.0.1]
	by haruhi.tsukinokage.net (Haruhi Mail system) with ESMTP id KFM35528
	for <video4linux-list@redhat.com>; Tue, 03 Mar 2009 08:35:28 -0600
Message-ID: <49AD402C.3050906@tsukinokage.net>
Date: Tue, 03 Mar 2009 08:35:24 -0600
From: Seann Clark <nombrandue@tsukinokage.net>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Subject: Video On Demand (VOD) server
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1318475119=="
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

This is a cryptographically signed message in MIME format.

--===============1318475119==
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature";
	micalg=sha1; boundary="------------ms060905030900080603000803"

This is a cryptographically signed message in MIME format.

--------------ms060905030900080603000803
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

All,

    I have been playing with V4L for a while since it looked like a good 
solution to an issue I have. I have a Central system with about 400GB of 
video files that I want to be able to access in a VOD style in a way I 
can select either play lists or individual shows to watch anywhere as a 
true VOD system. I haven't been able to get anything working though, and 
even if it does look like it is up and running the way I want, I still 
can't seem to get anything from it. I am wondering if anyone can help me 
understand how to get this up and running.


~Seann

--------------ms060905030900080603000803
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIRXTCC
BN0wggPFoAMCAQICEHGS++YZX6xNEoV0cTSiGKcwDQYJKoZIhvcNAQEFBQAwezELMAkGA1UE
BhMCR0IxGzAZBgNVBAgMEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBwwHU2FsZm9yZDEa
MBgGA1UECgwRQ29tb2RvIENBIExpbWl0ZWQxITAfBgNVBAMMGEFBQSBDZXJ0aWZpY2F0ZSBT
ZXJ2aWNlczAeFw0wNDAxMDEwMDAwMDBaFw0yODEyMzEyMzU5NTlaMIGuMQswCQYDVQQGEwJV
UzELMAkGA1UECBMCVVQxFzAVBgNVBAcTDlNhbHQgTGFrZSBDaXR5MR4wHAYDVQQKExVUaGUg
VVNFUlRSVVNUIE5ldHdvcmsxITAfBgNVBAsTGGh0dHA6Ly93d3cudXNlcnRydXN0LmNvbTE2
MDQGA1UEAxMtVVROLVVTRVJGaXJzdC1DbGllbnQgQXV0aGVudGljYXRpb24gYW5kIEVtYWls
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAsjmFpPJ9q0E7YkY3rs3BYHW8OWX5
ShpHornMSMxqmNVNNRm5pELlzkniii8efNIxB8dOtINknS4p1aJkxIW9hVE1eaROaJB7HHqk
kqgX8pgV8pPMyaQylbsMTzC9mKALi+VuG6JG+ni8om+rWV6lL8/K2m2qL+usobNqqrcuZzWL
eeEeaYji5kbNoKXqvgvOdjp6Dpvq/NonWz1zHyLmSGHGTPNpsaguG7bUMSAsvIKKjqQOpdeJ
Q/wWWq8dcdcRWdq6hw2v+vPhwvCkxWeM1tZUOt4KpLoDd7NlyP0e03RiqhjKaJMeoYV+9Udl
y/hNVyh00jT/MLbu9mIwFIws6wIDAQABo4IBJzCCASMwHwYDVR0jBBgwFoAUoBEKIz6W8Qfs
4q8p74Klf9AwpLQwHQYDVR0OBBYEFImCZ33EnSZwAEu0UEh83j2uBG59MA4GA1UdDwEB/wQE
AwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEFBQcDBDAR
BgNVHSAECjAIMAYGBFUdIAAwewYDVR0fBHQwcjA4oDagNIYyaHR0cDovL2NybC5jb21vZG9j
YS5jb20vQUFBQ2VydGlmaWNhdGVTZXJ2aWNlcy5jcmwwNqA0oDKGMGh0dHA6Ly9jcmwuY29t
b2RvLm5ldC9BQUFDZXJ0aWZpY2F0ZVNlcnZpY2VzLmNybDARBglghkgBhvhCAQEEBAMCAQYw
DQYJKoZIhvcNAQEFBQADggEBAJ2Vyzy4fqUJxB6/C8LHdo45PJTGEKpPDMngq4RdiVTgZTvz
bRx8NywlVF+WIfw3hJGdFdwUT4HPVB1rbEVgxy35l1FM+WbKPKCCjKbI8OLp1Er57D9Wyd12
jMOCAU9sAPMeGmF0BEcDqcZAV5G8ZSLFJ2dPV9tkWtmNH7qGL/QGrpxp7en0zykX2OBKnxog
L5dMUbtGB8SKN04g4wkxaMeexIud6H4RvDJoEJYRmETYKlFgTYjrdDrfQwYyyDlWjDoRUtNB
pEMD9O3vMyfbOeAUTibJ2PU54om4k123KSZB6rObroP8d3XK6Mq1/uJlSmM+RMTQw16Hc6mY
HK9/FX8wggY6MIIFIqADAgECAhEAtRtGsYs5otzaieXJkiVhrjANBgkqhkiG9w0BAQUFADCB
rjELMAkGA1UEBhMCVVMxCzAJBgNVBAgTAlVUMRcwFQYDVQQHEw5TYWx0IExha2UgQ2l0eTEe
MBwGA1UEChMVVGhlIFVTRVJUUlVTVCBOZXR3b3JrMSEwHwYDVQQLExhodHRwOi8vd3d3LnVz
ZXJ0cnVzdC5jb20xNjA0BgNVBAMTLVVUTi1VU0VSRmlyc3QtQ2xpZW50IEF1dGhlbnRpY2F0
aW9uIGFuZCBFbWFpbDAeFw0wODEwMTYwMDAwMDBaFw0wOTEwMTYyMzU5NTlaMIHhMTUwMwYD
VQQLEyxDb21vZG8gVHJ1c3QgTmV0d29yayAtIFBFUlNPTkEgTk9UIFZBTElEQVRFRDFGMEQG
A1UECxM9VGVybXMgYW5kIENvbmRpdGlvbnMgb2YgdXNlOiBodHRwOi8vd3d3LmNvbW9kby5u
ZXQvcmVwb3NpdG9yeTEfMB0GA1UECxMWKGMpMjAwMyBDb21vZG8gTGltaXRlZDEUMBIGA1UE
AxMLU2Vhbm4gQ2xhcmsxKTAnBgkqhkiG9w0BCQEWGm5vbWJyYW5kdWVAdHN1a2lub2thZ2Uu
bmV0MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA99/CEaL/hK7BELp+djKnwW7F
bBSoDkwJfryV4KMpyJsxSh0PtTqPDX1m0yasOMT+UiWwVvzLnCofJ61CdPv073kjxNGi+KJt
OXYQoGdOmwKGALHeQsqfE8iYoZ0lc1A6f3pVBMEb0CcrljUB/W9T9X/pwD2Mf7ejWi9qwuzn
tqmKyI//0u1sktoYqor+iezlffFmb5mgY9QWqnErtADG1bV5z0KTZDWpZsFwGhHcV+wXPXxW
wxOENlEtJV2Ubuo6kLg71Mhew6YeGV3FM6T/9pp+rDAKE8kWDwFgpLlrTDzC5jBcytWUtDox
cUT7Q7EzRa5WOeJpP8eBvedNxXHX4QIDAQABo4ICHDCCAhgwHwYDVR0jBBgwFoAUiYJnfcSd
JnAAS7RQSHzePa4Ebn0wHQYDVR0OBBYEFFaGImjc6bRuDRrfJTuNi+wxM1nyMA4GA1UdDwEB
/wQEAwIFoDAMBgNVHRMBAf8EAjAAMCAGA1UdJQQZMBcGCCsGAQUFBwMEBgsrBgEEAbIxAQMF
AjARBglghkgBhvhCAQEEBAMCBSAwRgYDVR0gBD8wPTA7BgwrBgEEAbIxAQIBAQEwKzApBggr
BgEFBQcCARYdaHR0cHM6Ly9zZWN1cmUuY29tb2RvLm5ldC9DUFMwgaUGA1UdHwSBnTCBmjBM
oEqgSIZGaHR0cDovL2NybC5jb21vZG9jYS5jb20vVVROLVVTRVJGaXJzdC1DbGllbnRBdXRo
ZW50aWNhdGlvbmFuZEVtYWlsLmNybDBKoEigRoZEaHR0cDovL2NybC5jb21vZG8ubmV0L1VU
Ti1VU0VSRmlyc3QtQ2xpZW50QXV0aGVudGljYXRpb25hbmRFbWFpbC5jcmwwbAYIKwYBBQUH
AQEEYDBeMDYGCCsGAQUFBzAChipodHRwOi8vY3J0LmNvbW9kb2NhLmNvbS9VVE5BQUFDbGll
bnRDQS5jcnQwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmNvbW9kb2NhLmNvbTAlBgNVHREE
HjAcgRpub21icmFuZHVlQHRzdWtpbm9rYWdlLm5ldDANBgkqhkiG9w0BAQUFAAOCAQEApSfz
ov5Y/18ftleg41xjycqrDF65Vt8c90hkWh3v8vaQoi9k4thQwXwKw0ZCfQPWAGHgAV7vSUXY
1zMwf2Z66k4eL0quDxuqDxl7pUv8mqV8+HBnGg79WZ9Asi4G5h+hIrp/hDwq9oOvifSxDdRz
dI6Uyj4tCKuQULn/LhkVjXM4u0jIW/W1QgcSJVZ/IAJ3+gAodPNJQwma7PGp0mDFlWe5kalR
M/bVE8AzUaZNFr96v7oSHtOOSItyXlZlNDOajC5K3LUlniPPgJFi6HYPSODHYKBxhq8TxXLx
H4p5RG5RboPB6GLJq4AHoy7JqRDJ0aurx5T1+nHvp7oNZEH4yDCCBjowggUioAMCAQICEQC1
G0axizmi3NqJ5cmSJWGuMA0GCSqGSIb3DQEBBQUAMIGuMQswCQYDVQQGEwJVUzELMAkGA1UE
CBMCVVQxFzAVBgNVBAcTDlNhbHQgTGFrZSBDaXR5MR4wHAYDVQQKExVUaGUgVVNFUlRSVVNU
IE5ldHdvcmsxITAfBgNVBAsTGGh0dHA6Ly93d3cudXNlcnRydXN0LmNvbTE2MDQGA1UEAxMt
VVROLVVTRVJGaXJzdC1DbGllbnQgQXV0aGVudGljYXRpb24gYW5kIEVtYWlsMB4XDTA4MTAx
NjAwMDAwMFoXDTA5MTAxNjIzNTk1OVowgeExNTAzBgNVBAsTLENvbW9kbyBUcnVzdCBOZXR3
b3JrIC0gUEVSU09OQSBOT1QgVkFMSURBVEVEMUYwRAYDVQQLEz1UZXJtcyBhbmQgQ29uZGl0
aW9ucyBvZiB1c2U6IGh0dHA6Ly93d3cuY29tb2RvLm5ldC9yZXBvc2l0b3J5MR8wHQYDVQQL
ExYoYykyMDAzIENvbW9kbyBMaW1pdGVkMRQwEgYDVQQDEwtTZWFubiBDbGFyazEpMCcGCSqG
SIb3DQEJARYabm9tYnJhbmR1ZUB0c3VraW5va2FnZS5uZXQwggEiMA0GCSqGSIb3DQEBAQUA
A4IBDwAwggEKAoIBAQD338IRov+ErsEQun52MqfBbsVsFKgOTAl+vJXgoynImzFKHQ+1Oo8N
fWbTJqw4xP5SJbBW/MucKh8nrUJ0+/TveSPE0aL4om05dhCgZ06bAoYAsd5Cyp8TyJihnSVz
UDp/elUEwRvQJyuWNQH9b1P1f+nAPYx/t6NaL2rC7Oe2qYrIj//S7WyS2hiqiv6J7OV98WZv
maBj1BaqcSu0AMbVtXnPQpNkNalmwXAaEdxX7Bc9fFbDE4Q2US0lXZRu6jqQuDvUyF7Dph4Z
XcUzpP/2mn6sMAoTyRYPAWCkuWtMPMLmMFzK1ZS0OjFxRPtDsTNFrlY54mk/x4G9503Fcdfh
AgMBAAGjggIcMIICGDAfBgNVHSMEGDAWgBSJgmd9xJ0mcABLtFBIfN49rgRufTAdBgNVHQ4E
FgQUVoYiaNzptG4NGt8lO42L7DEzWfIwDgYDVR0PAQH/BAQDAgWgMAwGA1UdEwEB/wQCMAAw
IAYDVR0lBBkwFwYIKwYBBQUHAwQGCysGAQQBsjEBAwUCMBEGCWCGSAGG+EIBAQQEAwIFIDBG
BgNVHSAEPzA9MDsGDCsGAQQBsjEBAgEBATArMCkGCCsGAQUFBwIBFh1odHRwczovL3NlY3Vy
ZS5jb21vZG8ubmV0L0NQUzCBpQYDVR0fBIGdMIGaMEygSqBIhkZodHRwOi8vY3JsLmNvbW9k
b2NhLmNvbS9VVE4tVVNFUkZpcnN0LUNsaWVudEF1dGhlbnRpY2F0aW9uYW5kRW1haWwuY3Js
MEqgSKBGhkRodHRwOi8vY3JsLmNvbW9kby5uZXQvVVROLVVTRVJGaXJzdC1DbGllbnRBdXRo
ZW50aWNhdGlvbmFuZEVtYWlsLmNybDBsBggrBgEFBQcBAQRgMF4wNgYIKwYBBQUHMAKGKmh0
dHA6Ly9jcnQuY29tb2RvY2EuY29tL1VUTkFBQUNsaWVudENBLmNydDAkBggrBgEFBQcwAYYY
aHR0cDovL29jc3AuY29tb2RvY2EuY29tMCUGA1UdEQQeMByBGm5vbWJyYW5kdWVAdHN1a2lu
b2thZ2UubmV0MA0GCSqGSIb3DQEBBQUAA4IBAQClJ/Oi/lj/Xx+2V6DjXGPJyqsMXrlW3xz3
SGRaHe/y9pCiL2Ti2FDBfArDRkJ9A9YAYeABXu9JRdjXMzB/ZnrqTh4vSq4PG6oPGXulS/ya
pXz4cGcaDv1Zn0CyLgbmH6Eiun+EPCr2g6+J9LEN1HN0jpTKPi0Iq5BQuf8uGRWNczi7SMhb
9bVCBxIlVn8gAnf6ACh080lDCZrs8anSYMWVZ7mRqVEz9tUTwDNRpk0Wv3q/uhIe045Ii3Je
VmU0M5qMLkrctSWeI8+AkWLodg9I4MdgoHGGrxPFcvEfinlEblFug8HoYsmrgAejLsmpEMnR
q6vHlPX6ce+nug1kQfjIMYIEUzCCBE8CAQEwgcQwga4xCzAJBgNVBAYTAlVTMQswCQYDVQQI
EwJVVDEXMBUGA1UEBxMOU2FsdCBMYWtlIENpdHkxHjAcBgNVBAoTFVRoZSBVU0VSVFJVU1Qg
TmV0d29yazEhMB8GA1UECxMYaHR0cDovL3d3dy51c2VydHJ1c3QuY29tMTYwNAYDVQQDEy1V
VE4tVVNFUkZpcnN0LUNsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgRW1haWwCEQC1G0axizmi
3NqJ5cmSJWGuMAkGBSsOAwIaBQCgggJjMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJ
KoZIhvcNAQkFMQ8XDTA5MDMwMzE0MzUyNFowIwYJKoZIhvcNAQkEMRYEFCQIype1T+oJWu2V
QthKeVK9HZ2zMFIGCSqGSIb3DQEJDzFFMEMwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCA
MA0GCCqGSIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIHVBgkrBgEEAYI3EAQx
gccwgcQwga4xCzAJBgNVBAYTAlVTMQswCQYDVQQIEwJVVDEXMBUGA1UEBxMOU2FsdCBMYWtl
IENpdHkxHjAcBgNVBAoTFVRoZSBVU0VSVFJVU1QgTmV0d29yazEhMB8GA1UECxMYaHR0cDov
L3d3dy51c2VydHJ1c3QuY29tMTYwNAYDVQQDEy1VVE4tVVNFUkZpcnN0LUNsaWVudCBBdXRo
ZW50aWNhdGlvbiBhbmQgRW1haWwCEQC1G0axizmi3NqJ5cmSJWGuMIHXBgsqhkiG9w0BCRAC
CzGBx6CBxDCBrjELMAkGA1UEBhMCVVMxCzAJBgNVBAgTAlVUMRcwFQYDVQQHEw5TYWx0IExh
a2UgQ2l0eTEeMBwGA1UEChMVVGhlIFVTRVJUUlVTVCBOZXR3b3JrMSEwHwYDVQQLExhodHRw
Oi8vd3d3LnVzZXJ0cnVzdC5jb20xNjA0BgNVBAMTLVVUTi1VU0VSRmlyc3QtQ2xpZW50IEF1
dGhlbnRpY2F0aW9uIGFuZCBFbWFpbAIRALUbRrGLOaLc2onlyZIlYa4wDQYJKoZIhvcNAQEB
BQAEggEA7zfRj8Sj0TrOD4AHEM4+H0CsaJI6DXU4Sg3MS2SGwITTCoDJfYZfVfBTu34U8RmC
ww2V0Ejns4d7UqHt1hx5b1Qqkon9Tk418blmxKwYUt5MQToauvER9JgCcf/YClQxtw6Ek+hN
hhPlyMOdylcoRZZLRXuB+dDdzM5EcVE6v0i2xYX6ibwVVaFuOQywuju2DU5G2hwVwJ9DWzQq
pzJqR7AHgHCVBNmua6jkT1VC3zrEN+EZgX41QOpOxVKUCKZXSkduGBu1kejZojx5XpMVWMRF
85Us7TfT2kA1zsnEa6ICCYI8ELf8BaOCnIbUU1OmoUTn1AFX5z6WDvoxPXt+7AAAAAAAAA==
--------------ms060905030900080603000803--


--===============1318475119==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--===============1318475119==--
