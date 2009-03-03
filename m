Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n23GohxY024986
	for <video4linux-list@redhat.com>; Tue, 3 Mar 2009 11:50:43 -0500
Received: from mho-01-bos.mailhop.org (mho-01-bos.mailhop.org [63.208.196.178])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n23GoMEc012844
	for <video4linux-list@redhat.com>; Tue, 3 Mar 2009 11:50:22 -0500
Message-ID: <49AD5FC5.80001@tsukinokage.net>
Date: Tue, 03 Mar 2009 10:50:13 -0600
From: Seann Clark <nombrandue@tsukinokage.net>
MIME-Version: 1.0
To: Jackson Yee <jackson@gotpossum.com>
References: <49AD402C.3050906@tsukinokage.net>	<286e6b7c0903030655h794a10b3o107b768d3eb67880@mail.gmail.com>
	<26aa882f0903030842h2918c036l28fe6f2d6a6cc79b@mail.gmail.com>
In-Reply-To: <26aa882f0903030842h2918c036l28fe6f2d6a6cc79b@mail.gmail.com>
Cc: video4linux-list@redhat.com
Subject: Re: Video On Demand (VOD) server
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0509574527=="
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

This is a cryptographically signed message in MIME format.

--===============0509574527==
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature";
	micalg=sha1; boundary="------------ms090306080501070702040203"

This is a cryptographically signed message in MIME format.

--------------ms090306080501070702040203
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Jackson Yee wrote:
> I'm not quite sure what his requirements are either, but if he's
> hooking up to a TV, MythTV or FreeVO would both be excellent
> candidates.
>
> MediaTomb would be great for device playback, or a simple http server
> with the document root pointed to the media directory would work fine
> as well. I've gone as far as having a Python script doing everything
> since Python has a built-in http server.
>
> Please let us know your exact requirements if you want any other
> suggestions, Seann.
>
> Regards,
> Jackson Yee
> The Possum Company
> 540-818-4079
> me@gotpossum.com
>
> On Tue, Mar 3, 2009 at 9:55 AM, D <d.a.nstowell+v4l@gmail.com> wrote:
>   
>> I don't completely understand why you're asking here rather than on
>> the forums for the software that you couldn't get working... but just
>> in case you haven't already tried it: try mediatomb. I got it working
>> in minutes.
>>     
>
>   
The exact thing I want to do, is have a central media server, which 
serves up video streams, so I can stream content to computers, MythTV, 
Ps3, and like devices and watch/control playback in a decentralized 
fashion, where one users playback doesn't have a thing to do with a 
different user/device. I don't need recording done on my media system, 
but pure playback, like what Media Tomb seems to offer (Working on that 
right now and will test it when I get home). I have read a lot of places 
for a 'video server' for lack of better words to google for, and 90% of 
my inital relevant hits pointed to VLC. I have seen aspects of VLC that 
seem to work with it, using RTP and RTSP, but I haven't been able to get 
that to work. In the most simple terms, I am looking for a streaming 
media server (I am looking at MediaTomb as a UPnP server that I can use 
with my Ps3, maybe).

The problem is, everything but my primary media server has a 'small' 
hard drive (I use that term loosely) and most of my content is 
centralized. Using my Audio side as an example, I run my primary 'radio' 
using MPD as the source and Icecast as the streaming system. For 
different 'channels' and ShoutCast tie in, I use LiquidSoap to set up 
audio streams. This solution has worked very well for an Audio side.

I am also looking for something like that on the Video side.

~Seann

--------------ms090306080501070702040203
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
KoZIhvcNAQkFMQ8XDTA5MDMwMzE2NTAxM1owIwYJKoZIhvcNAQkEMRYEFEjqI+niUbGyICmY
e3wmuI7/lcDGMFIGCSqGSIb3DQEJDzFFMEMwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCA
MA0GCCqGSIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIHVBgkrBgEEAYI3EAQx
gccwgcQwga4xCzAJBgNVBAYTAlVTMQswCQYDVQQIEwJVVDEXMBUGA1UEBxMOU2FsdCBMYWtl
IENpdHkxHjAcBgNVBAoTFVRoZSBVU0VSVFJVU1QgTmV0d29yazEhMB8GA1UECxMYaHR0cDov
L3d3dy51c2VydHJ1c3QuY29tMTYwNAYDVQQDEy1VVE4tVVNFUkZpcnN0LUNsaWVudCBBdXRo
ZW50aWNhdGlvbiBhbmQgRW1haWwCEQC1G0axizmi3NqJ5cmSJWGuMIHXBgsqhkiG9w0BCRAC
CzGBx6CBxDCBrjELMAkGA1UEBhMCVVMxCzAJBgNVBAgTAlVUMRcwFQYDVQQHEw5TYWx0IExh
a2UgQ2l0eTEeMBwGA1UEChMVVGhlIFVTRVJUUlVTVCBOZXR3b3JrMSEwHwYDVQQLExhodHRw
Oi8vd3d3LnVzZXJ0cnVzdC5jb20xNjA0BgNVBAMTLVVUTi1VU0VSRmlyc3QtQ2xpZW50IEF1
dGhlbnRpY2F0aW9uIGFuZCBFbWFpbAIRALUbRrGLOaLc2onlyZIlYa4wDQYJKoZIhvcNAQEB
BQAEggEAhKqAlMUnxhsFKDTov1FcCAf5BrcthqGvpSpYRP5wa15tl1tZIgbKWimwDbpIsnVt
C160DDDVtwawCsowUhoDGwGMddEIrIu3Mn8SoGNm6nj8ANMIAAy4/NWyKATYqZlC4ZtPDk5W
d4Kd7aWvi1Li/XBaS9RwP/+y3uLBIiTU53IoqyPS8sMZbF39+e6Ke7zoFHPuuFdUJm4iE/sN
WG6dq+7wzCG9VwsytNQNz02zgGNOEdw1BLxqAe4qOjwwsx8TMGfx+CWnH9kkdre3bQV/2hIC
RPV0DWJU9RiSrFO2zELyGoswPHE6Fl98cz/P87XqB3oEjbxzJkac/Id3hFPWQQAAAAAAAA==
--------------ms090306080501070702040203--


--===============0509574527==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--===============0509574527==--
