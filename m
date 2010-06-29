Return-path: <linux-media-owner@vger.kernel.org>
Received: from tuxmail.imn.htwk-leipzig.de ([141.57.7.10]:41330 "EHLO
	tuxmail.imn.htwk-leipzig.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753558Ab0F2Tmy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Jun 2010 15:42:54 -0400
From: Torsten Krah <tkrah@fachschaft.imn.htwk-leipzig.de>
Reply-To: tkrah@fachschaft.imn.htwk-leipzig.de
To: Douglas Schilling Landgraf <dougsland@gmail.com>
Subject: Re: em28xx/xc3028 - kernel driver vs. Markus Rechberger's driver
Date: Tue, 29 Jun 2010 21:42:42 +0200
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Thorsten Hirsch <t.hirsch@web.de>
References: <AANLkTilP-jf0MaV82LuTz8DjoNJKQ3xGCHuFgds4b212@mail.gmail.com> <201006291542.27655.tkrah@fachschaft.imn.htwk-leipzig.de> <AANLkTin5iXho6LJP8mOPC-AIIJTi8myxZsy_V6msxSpa@mail.gmail.com>
In-Reply-To: <AANLkTin5iXho6LJP8mOPC-AIIJTi8myxZsy_V6msxSpa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3455493.gU4aWHY14n";
  protocol="application/pkcs7-signature";
  micalg=sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201006292142.48380.tkrah@fachschaft.imn.htwk-leipzig.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--nextPart3455493.gU4aWHY14n
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Am Dienstag, 29. Juni 2010 schrieb Douglas Schilling Landgraf:
> The rewrite_eeprom.pl is available under git.utils tree:
> http://git.linuxtv.org/v4l-utils.git
>=20
> All instructions are available into the source code. Let me know if
> you have any problem with such tool.

Hi, yes i have problems with the tool :-).

Connected my "broken" device:

lsusb:
Bus 001 Device 002: ID eb1a:2871 eMPIA Technology, Inc.

dmesg:
[  455.348172] usb 1-1: new high speed USB device using ehci_hcd and addres=
s 2
[  455.481791] usb 1-1: configuration #1 chosen from 1 choice
[  455.609668] usbcore: registered new interface driver snd-usb-audio


Running the script which does generate the recover script does work.
But running this one fails with:

Could not detect i2c bus from any device, run again ./rewrite_eeprom.pl. Di=
d=20
you forget to connect the device?
Modules supported: em28xx saa7134

Device is connected.

Anything what i can do?

thx

Torsten

--nextPart3455493.gU4aWHY14n
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIFXDCCBVgw
ggNAoAMCAQICAwefRjANBgkqhkiG9w0BAQUFADB5MRAwDgYDVQQKEwdSb290IENBMR4wHAYDVQQL
ExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmluZyBBdXRob3Jp
dHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZzAeFw0wOTEwMjAxMzQ2MzVaFw0x
MTEwMjAxMzQ2MzVaME8xGDAWBgNVBAMTD0NBY2VydCBXb1QgVXNlcjEzMDEGCSqGSIb3DQEJARYk
dGtyYWhAZmFjaHNjaGFmdC5pbW4uaHR3ay1sZWlwemlnLmRlMIIBIjANBgkqhkiG9w0BAQEFAAOC
AQ8AMIIBCgKCAQEA3y1Pu6r0+4FmfSZWO07KYv5FWDy+AqKfvQ/+trLjKHgJv1sZDKIURtVVHlgP
qsMddecGuLrcSnjbAEO9I0XNvpOaTyNIKvsfyTBc9/oNk5Oeb8XQ2PG6UM1RQiHuLwxTEquFh/xf
oTO7ZlRl3j0YzsXa7hR/slU64EVGidO3289Z6eJv2jD9E1I1ujD630ifCMhiI/HGxobGYFdI1cy1
Ne3Pc8BeWsSv8BS4fI7eMuFDI3DSCmk8mtgVSSBFLvRQ6laD7zawB+aDvvu+/NgClAEksCBRim5D
DnJ+PVZm29GUHpkP7sf2ztsotckLyet3d5rg/aVwI7iYBAoWkvwDcwIDAQABo4IBETCCAQ0wDAYD
VR0TAQH/BAIwADBWBglghkgBhvhCAQ0ESRZHVG8gZ2V0IHlvdXIgb3duIGNlcnRpZmljYXRlIGZv
ciBGUkVFIGhlYWQgb3ZlciB0byBodHRwOi8vd3d3LkNBY2VydC5vcmcwQAYDVR0lBDkwNwYIKwYB
BQUHAwQGCCsGAQUFBwMCBgorBgEEAYI3CgMEBgorBgEEAYI3CgMDBglghkgBhvhCBAEwMgYIKwYB
BQUHAQEEJjAkMCIGCCsGAQUFBzABhhZodHRwOi8vb2NzcC5jYWNlcnQub3JnMC8GA1UdEQQoMCaB
JHRrcmFoQGZhY2hzY2hhZnQuaW1uLmh0d2stbGVpcHppZy5kZTANBgkqhkiG9w0BAQUFAAOCAgEA
MMKq9NNbTFUEPdbQ4jZT9T6oY4YQTbXYuF6ymvbBXx3TKsFWGpVjln0whIoQptkBMPSoa6BAZVtO
mFiIAYwusK05xlYOknxZj/ksm2tWY5lKni4q85kDn+QIfJZ0OF9PP8r8azzw/Wsa2FGx2MUfZYqS
OeFbL0qWmwhXzGp2CSiTNPNnGSbXBe22uCjYKw+0Gpno0swfbC2iTZjv2KlXWIM0sYPs2yDsFer6
5/PHVExVEAD1Xrpu/ivADT660nx/GWDBa9zuRE+C42DwBBA6GhYCR4W8AkFiLNdz/7lgrnIax1So
REiEK7ZdAtwkB3QzyMIVd3BwtGOkJMcUa4R1MrGCmC9ixORxDxrZNUSVY32TVRs2OzIzHCjawWFw
lmDcomjU5cXj/ZKTmnGqTCpiyesaE1/1IKdyE8EBtqqVoGs7mdgjWSrrgPLVPcmSIDRsd+66Fc4x
rRnbJf/yi3v3DdJqTgX/JuJmi1gsiPnwEg807WARuLANbF6y7HX/Ssd49ovGYQQdnFYcZfcAwWBL
vEYxwIvHOnaLgaFcngdtEtdxrY2tUPllv1GhLF/cHQdEnQghZS1RJ/jCFBbmTMJ+PbTutO3JNBTn
bZ3GT5Ffipk195Tj6CGFXauMiQiUHIKwNG8W1FR0TAdZGDOYiqA3wfPgBHgLt04cnrevCd4rk8Ex
ggIyMIICLgIBATCBgDB5MRAwDgYDVQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNh
Y2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0B
CQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDB59GMAkGBSsOAwIaBQCggYcwGAYJKoZIhvcNAQkDMQsG
CSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTAwNjI5MTk0MjQzWjAjBgkqhkiG9w0BCQQxFgQU
ZkVwBz8RZoB5zS+kRbUvJqnp60EwKAYJKoZIhvcNAQkPMRswGTALBglghkgBZQMEAQIwCgYIKoZI
hvcNAwcwDQYJKoZIhvcNAQEBBQAEggEAlC6dOUdxQIi2XCzi9etlj8LRFYa+u9rlq4xL84R4iB7c
3mKiqPn3ZLnCVEVdQjw4qr9n3llpAGe+LVdvBrsDRfUSAMq+a8rHeVAjD0aG2gcMMWXg/G6hXxjz
anK3mz+UGwKnfSWI086vuhE7rS4dOqW/uwrhqW1zS9CGYVzh1RcIAOxY5BMjCSIASbmPeUj/47+7
TCnguK4KbYrP9U12A3L4dfmAQOvSmkNkCm3RS+/4/6XJipGsjTbLSwlCj2Ch6qhNcH6O8iUuKnAH
JEQATsp89VHetr+sVGg+w66gDNPLJHxWRnDciTQJnnkAVY23kWI35pcIUdt45pAoEd44ngAAAAAA
AA==

--nextPart3455493.gU4aWHY14n--
