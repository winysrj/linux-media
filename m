Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:63051 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222Ab3EIN0d (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 May 2013 09:26:33 -0400
Received: from mailout-de.gmx.net ([10.1.76.20]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0LjP2f-1TzBEm3dCZ-00dTym for
 <linux-media@vger.kernel.org>; Thu, 09 May 2013 15:26:31 +0200
Message-ID: <518BBF53.9040809@gmx.de>
Date: Thu, 09 May 2013 17:22:59 +0200
From: Ingbert Braun <ingbert.braun@gmx.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: em2870 device undetected
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms080700050101030700010505"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms080700050101030700010505
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Dear developer,
I've a pinnacle pctv usb stick which is not supported. As mentioned in=20
log, I'm sending the dmesg log to you:


hub 3-0:1.0: port 1: status 0101 change 0001
[ 1219.090245] hub 3-0:1.0: state 7 ports 4 chg 0002 evt 0000
[ 1219.090254] hub 3-0:1.0: port 1, status 0101, change 0000, 12 Mb/s
[ 1219.141055] hub 3-0:1.0: port 1 not reset yet, waiting 50ms
[ 1219.242697] usb 3-1: new high-speed USB device number 2 using xhci_hcd=

[ 1219.254611] usb 3-1: default language 0x0409
[ 1219.257510] usb 3-1: udev 2, busnum 3, minor =3D 257
[ 1219.257514] usb 3-1: New USB device found, idVendor=3Deb1a, idProduct=3D=
2870
[ 1219.257517] usb 3-1: New USB device strings: Mfr=3D0, Product=3D1,=20
SerialNumber=3D0
[ 1219.257520] usb 3-1: Product: USB 2870 Device
[ 1219.257658] usb 3-1: usb_probe_device
[ 1219.257660] usb 3-1: configuration #1 chosen from 1 choice
[ 1219.257725] usb 3-1: Successful Endpoint Configure command
[ 1219.257766] usb 3-1: adding 3-1:1.0 (config #1, interface 0)
[ 1219.277783] em28xx 3-1:1.0: usb_probe_interface
[ 1219.277786] em28xx 3-1:1.0: usb_probe_interface - got id
[ 1219.277789] em28xx: New device  USB 2870 Device @ 480 Mbps=20
(eb1a:2870, interface 0, class 0)
[ 1219.277790] em28xx: Video interface 0 found
[ 1219.277791] em28xx: DVB interface 0 found
[ 1219.277813] em28xx #0: chip ID is em2870
[ 1219.352535] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 70 28 c0 12=20
81 00 6a 22 00 00
[ 1219.352541] em28xx #0: i2c eeprom 10: 00 00 04 57 02 0d 00 00 00 00=20
00 00 00 00 00 00
[ 1219.352545] em28xx #0: i2c eeprom 20: 44 00 00 00 f0 10 02 00 00 00=20
00 00 5b 00 00 00
[ 1219.352549] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01=20
00 00 72 eb e4 49
[ 1219.352553] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00=20
00 00 00 00 00 00
[ 1219.352557] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00=20
00 00 00 00 00 00
[ 1219.352561] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00=20
22 03 55 00 53 00
[ 1219.352565] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 37 00=20
30 00 20 00 44 00
[ 1219.352569] em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00=20
00 00 00 00 00 00
[ 1219.352573] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00=20
00 00 00 00 00 00
[ 1219.352577] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00=20
00 00 00 00 00 00
[ 1219.352581] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00=20
00 00 00 00 00 00
[ 1219.352585] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00=20
00 00 00 00 00 00
[ 1219.352589] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00=20
00 00 00 00 00 00
[ 1219.352593] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00=20
00 00 00 00 00 00
[ 1219.352597] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00=20
00 00 00 00 00 00
[ 1219.352602] em28xx #0: EEPROM ID=3D 0x9567eb1a, EEPROM hash =3D 0x11fa=
5ec0
[ 1219.352604] em28xx #0: EEPROM info:
[ 1219.352604] em28xx #0:       No audio on board.
[ 1219.352605] em28xx #0:       500mA max power
[ 1219.352606] em28xx #0:       Table at 0x04, strings=3D0x226a, 0x0000, =

0x0000
[ 1219.390543] em28xx #0: found i2c device @ 0xa0 [eeprom]
[ 1219.393247] em28xx #0: found i2c device @ 0xc0 [tuner (analog)]
[ 1219.398489] em28xx #0: Your board has no unique USB ID and thus need=20
a hint to be detected.
[ 1219.398491] em28xx #0: You may try to use card=3D<n> insmod option to =

workaround that.
[ 1219.398491] em28xx #0: Please send an email with this log to:
[ 1219.398492] em28xx #0:       V4L Mailing List=20
<linux-media@vger.kernel.org>
[ 1219.398493] em28xx #0: Board eeprom hash is 0x11fa5ec0
[ 1219.398493] em28xx #0: Board i2c devicelist hash is 0x4b800080
[ 1219.398494] em28xx #0: Here is a list of valid choices for the=20
card=3D<n> insmod option:
=2E..
[ 1219.398567] em28xx #0:     card=3D86 -> PCTV QuatroStick nano (520e)
[ 1219.398568] em28xx #0: Board not discovered
[ 1219.398569] em28xx #0: Identified as Unknown EM2750/28xx video=20
grabber (card=3D1)
[ 1219.398570] em28xx #0: Your board has no unique USB ID and thus need=20
a hint to be detected.
[ 1219.398570] em28xx #0: You may try to use card=3D<n> insmod option to =

workaround that.
[ 1219.398571] em28xx #0: Please send an email with this log to:
[ 1219.398571] em28xx #0:       V4L Mailing List=20
<linux-media@vger.kernel.org>
[ 1219.398572] em28xx #0: Board eeprom hash is 0x11fa5ec0
[ 1219.398573] em28xx #0: Board i2c devicelist hash is 0x4b800080
[ 1219.398573] em28xx #0: Here is a list of valid choices for the=20
card=3D<n> insmod option:
[ 1219.398574] em28xx #0:     card=3D0 -> Unknown EM2800 video grabber
=2E..
[ 1219.398641] em28xx #0:     card=3D86 -> PCTV QuatroStick nano (520e)
[ 1219.398643] em28xx #0: v4l2 driver version 0.1.3
[ 1219.398719] usb 3-1: Successful Endpoint Configure command
[ 1219.400353] em28xx #0: V4L2 video device registered as video1
[ 1219.400490] usbcore: registered new interface driver em28xx
[ 1219.402311] usb 3-1: Successful Endpoint Configure command


kernel 3.7.10 (Gentoo)

I know this device was supported in the past by the old M. Rechberger=20
drivers. If you need any other logs, please let me know.

Best regards,

Ingbert




--------------ms080700050101030700010505
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIILGzCC
BTswggQjoAMCAQICDkdPAAEAAgjcGYitKO9HMA0GCSqGSIb3DQEBBQUAMHwxCzAJBgNVBAYT
AkRFMRwwGgYDVQQKExNUQyBUcnVzdENlbnRlciBHbWJIMSUwIwYDVQQLExxUQyBUcnVzdENl
bnRlciBDbGFzcyAxIEwxIENBMSgwJgYDVQQDEx9UQyBUcnVzdENlbnRlciBDbGFzcyAxIEwx
IENBIElYMB4XDTEyMDkwMjEzMjE1OVoXDTEzMDkwMzEzMjE1OVowJTELMAkGA1UEBhMCREUx
FjAUBgNVBAMTDUluZ2JlcnQgQnJhdW4wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
AQCsOyejaimWP6+ZY0W4+HTcw6aTTniX5fz76Yx5Svf3Z7Xup1D3fi+99vSYbFvjz0Z1TPGo
DnPA08BEj0Z+lYI5TFpjq9JpLxI8pM6l1iOpYqiD/kj7jeXTb42UrcJ2KhjQToGC7ate5y7c
xqU0eCko7SzutwDA17/kpQ8nE8Iz9eE9YZ0hDPrgRIlya219W20waM2GxdqDZ36J3SJX2JjP
1OSsfC28q16kUjCHNlE03XC9ZQ6VQa8GV+dk1sXrAyD7n9CJ4TL7yXUfQXsJLx0eLkMtdCPr
Q5yZ+5ZTdqhVg4pWTNQn0d0Ec2i1TtDy/HZb9+q9apNe5kA0mRPAludvAgMBAAGjggIQMIIC
DDCBpQYIKwYBBQUHAQEEgZgwgZUwUQYIKwYBBQUHMAKGRWh0dHA6Ly93d3cudHJ1c3RjZW50
ZXIuZGUvY2VydHNlcnZpY2VzL2NhY2VydHMvdGNfY2xhc3MxX0wxX0NBX0lYLmNydDBABggr
BgEFBQcwAYY0aHR0cDovL29jc3AuaXgudGNjbGFzczEudGN1bml2ZXJzYWwtaS50cnVzdGNl
bnRlci5kZTAfBgNVHSMEGDAWgBTpuCgdRs/8zfhOm8XuS2Dr2Ds/0TAMBgNVHRMBAf8EAjAA
MEoGA1UdIARDMEEwPwYJKoIUACwBAQEBMDIwMAYIKwYBBQUHAgEWJGh0dHA6Ly93d3cudHJ1
c3RjZW50ZXIuZGUvZ3VpZGVsaW5lczAOBgNVHQ8BAf8EBAMCBPAwHQYDVR0OBBYEFG3NZiUi
RiWGzAJPuzcTL1XvnamJMGIGA1UdHwRbMFkwV6BVoFOGUWh0dHA6Ly9jcmwuaXgudGNjbGFz
czEudGN1bml2ZXJzYWwtaS50cnVzdGNlbnRlci5kZS9jcmwvdjIvdGNfQ2xhc3MxX0wxX0NB
X0lYLmNybDAzBgNVHSUELDAqBggrBgEFBQcDAgYIKwYBBQUHAwQGCCsGAQUFBwMHBgorBgEE
AYI3FAICMB8GA1UdEQQYMBaBFGluZ2JlcnQuYnJhdW5AZ214LmRlMA0GCSqGSIb3DQEBBQUA
A4IBAQAPQxYhrI0IH3l5HjJDq3zbxu2Fj7eNwqEjvUeWahnzqVfTc/92VQv+hdbTvYcZvhGK
N+MWw/wZJR2bxTwr/K+l2zUrsqJEgOStC4GkAzaKJpgkYH32NadxCIEXrKKcLy/bFsKPhOHj
CvuE9eG+GmaUjdLpkKRSGK0eqIDkKkqMwdr6r9E8zOrvw+I50m5Gye0iqmRWbqqn6nLish8B
DXxxnBX1expCI5R/3GmRRY+MceAulxl7uIOUjaC2AowUP9J915wA6ZYf4HPqidtPkjbQu9Tz
LuopUK9sjyPetqNrtzgtQiVlSIzY0srqBH1nA7Td5TIo3hrhA19AMw6WRzfpMIIF2DCCBMCg
AwIBAgIOBugAAQACSpYtJAz+xckwDQYJKoZIhvcNAQEFBQAweTELMAkGA1UEBhMCREUxHDAa
BgNVBAoTE1RDIFRydXN0Q2VudGVyIEdtYkgxJDAiBgNVBAsTG1RDIFRydXN0Q2VudGVyIFVu
aXZlcnNhbCBDQTEmMCQGA1UEAxMdVEMgVHJ1c3RDZW50ZXIgVW5pdmVyc2FsIENBIEkwHhcN
MDkxMTAzMTQwODE5WhcNMjUxMjMxMjE1OTU5WjB8MQswCQYDVQQGEwJERTEcMBoGA1UEChMT
VEMgVHJ1c3RDZW50ZXIgR21iSDElMCMGA1UECxMcVEMgVHJ1c3RDZW50ZXIgQ2xhc3MgMSBM
MSBDQTEoMCYGA1UEAxMfVEMgVHJ1c3RDZW50ZXIgQ2xhc3MgMSBMMSBDQSBJWDCCASIwDQYJ
KoZIhvcNAQEBBQADggEPADCCAQoCggEBALvmkG7PYunpC6q2ENVH5XxdKydxmmjNVW3kou/k
/vJ6YxHCV4rIfc+OZh9lRUvrgGJpvUaOi8VuWpUYKt6n8R91GierbTJT4/tNWGIs/xnlx6AN
mi0hiFmEzR3xw8iKPrDl3ggkz/xALLpBI5S7gBKJNUi2hgTgAU+MuqmY/ByJ7R+KoceGmCYe
cmVr/s9l2QxkSxoJ9UMRYGYm4zNWmsk9PjRqeMblUEvIzYjkOWxQJp5ALLY7fDeyp/Xd3LNR
y/TcggK41zre2jBcDfVC3RNpU1TpgCZCMx6l18xuymYJn4bwPb7GimEQ89H/W+Sy2y2yZQyp
fResuidNQlzOCU8CAwEAAaOCAlkwggJVMIGaBggrBgEFBQcBAQSBjTCBijBSBggrBgEFBQcw
AoZGaHR0cDovL3d3dy50cnVzdGNlbnRlci5kZS9jZXJ0c2VydmljZXMvY2FjZXJ0cy90Y191
bml2ZXJzYWxfcm9vdF9JLmNydDA0BggrBgEFBQcwAYYoaHR0cDovL29jc3AudGN1bml2ZXJz
YWwtSS50cnVzdGNlbnRlci5kZTAfBgNVHSMEGDAWgBSSpHUspJ6+gUTrefyKxZWl6xB1czAS
BgNVHRMBAf8ECDAGAQH/AgEAMFIGA1UdIARLMEkwBgYEVR0gADA/BgkqghQALAEBAQEwMjAw
BggrBgEFBQcCARYkaHR0cDovL3d3dy50cnVzdGNlbnRlci5kZS9ndWlkZWxpbmVzMA4GA1Ud
DwEB/wQEAwIBBjAdBgNVHQ4EFgQU6bgoHUbP/M34TpvF7ktg69g7P9Ewgf0GA1UdHwSB9TCB
8jCB76CB7KCB6YZGaHR0cDovL2NybC50Y3VuaXZlcnNhbC1JLnRydXN0Y2VudGVyLmRlL2Ny
bC92Mi90Y191bml2ZXJzYWxfcm9vdF9JLmNybIaBnmxkYXA6Ly93d3cudHJ1c3RjZW50ZXIu
ZGUvQ049VEMlMjBUcnVzdENlbnRlciUyMFVuaXZlcnNhbCUyMENBJTIwSSxPPVRDJTIwVHJ1
c3RDZW50ZXIlMjBHbWJILE9VPXJvb3RjZXJ0cyxEQz10cnVzdGNlbnRlcixEQz1kZT9jZXJ0
aWZpY2F0ZVJldm9jYXRpb25MaXN0P2Jhc2U/MA0GCSqGSIb3DQEBBQUAA4IBAQA5yMSb7r6Y
7khyb43ncbYOkIzTssEVIahGkGhfSgTxOslohCHYpeYEdV2f0tTyS3dDMtyVy2C/AlXQrByw
xRSXm2UKww+lHezYSTmVtam++vQeq1bnpuUBCIg1X2cF3UQkUBIiRGN58ZtXac6r1jNRT43w
cDuOrVE6F381lmtoaGO2HArJ+N8dXs8rEaVj7czQxtMgb6r8aEh+bR64OkWqEobzx70Atev+
6hKfczN45yg5aNOlbdp20U7hVZWApuAbuM2sVu9FWUeYUts6biayMTlpdbEuJPCknZeIXjMp
xrW8B0A6DD26z3SMS056IfobOM3EQy9vtN947pmS5zocMYIDyzCCA8cCAQEwgY4wfDELMAkG
A1UEBhMCREUxHDAaBgNVBAoTE1RDIFRydXN0Q2VudGVyIEdtYkgxJTAjBgNVBAsTHFRDIFRy
dXN0Q2VudGVyIENsYXNzIDEgTDEgQ0ExKDAmBgNVBAMTH1RDIFRydXN0Q2VudGVyIENsYXNz
IDEgTDEgQ0EgSVgCDkdPAAEAAgjcGYitKO9HMAkGBSsOAwIaBQCgggIRMBgGCSqGSIb3DQEJ
AzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTEzMDUwOTE1MjI1OVowIwYJKoZIhvcN
AQkEMRYEFJsG6ymG3TDarMjQCmB+Vvmis4ItMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUD
BAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcN
AwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZ8GCSsGAQQBgjcQBDGBkTCBjjB8MQsw
CQYDVQQGEwJERTEcMBoGA1UEChMTVEMgVHJ1c3RDZW50ZXIgR21iSDElMCMGA1UECxMcVEMg
VHJ1c3RDZW50ZXIgQ2xhc3MgMSBMMSBDQTEoMCYGA1UEAxMfVEMgVHJ1c3RDZW50ZXIgQ2xh
c3MgMSBMMSBDQSBJWAIOR08AAQACCNwZiK0o70cwgaEGCyqGSIb3DQEJEAILMYGRoIGOMHwx
CzAJBgNVBAYTAkRFMRwwGgYDVQQKExNUQyBUcnVzdENlbnRlciBHbWJIMSUwIwYDVQQLExxU
QyBUcnVzdENlbnRlciBDbGFzcyAxIEwxIENBMSgwJgYDVQQDEx9UQyBUcnVzdENlbnRlciBD
bGFzcyAxIEwxIENBIElYAg5HTwABAAII3BmIrSjvRzANBgkqhkiG9w0BAQEFAASCAQCSWDzU
PswusHhhh/B/C39cXYldYCujDt6Le194RBeaWe+GE1NtS1Dg8Eweajy8SXtx4WNCWifTEeyc
8BAQaezRLjtG+b325CNdwPZVLm5fTcor9/gL1xAxcZyEWnQDRKftcDsyFnp3l0WwfpPRfGCh
JV/MP70umyQqzs9srlePkDNjP3RV6iH4QCR2rzeAfrWEvVXAhXUPcnGgLcxI4cCfiCT42k24
QCn/XedhjqMZA9sUO2dZZ32yASgCaanLnoLkRguIK8NcA138TkI8E7/oRofujGm4G984IyBx
HGsjchCuYROyBWwwdLeURrWiVf59tS/SNWMVGmOeatDPe3wsAAAAAAAA
--------------ms080700050101030700010505--
