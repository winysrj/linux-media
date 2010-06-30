Return-path: <linux-media-owner@vger.kernel.org>
Received: from tuxmail.imn.htwk-leipzig.de ([141.57.7.10]:40381 "EHLO
	tuxmail.imn.htwk-leipzig.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752401Ab0F3TQc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jun 2010 15:16:32 -0400
From: Torsten Krah <tkrah@fachschaft.imn.htwk-leipzig.de>
Reply-To: tkrah@fachschaft.imn.htwk-leipzig.de
To: Douglas Schilling Landgraf <dougsland@gmail.com>
Subject: Re: em28xx/xc3028 - kernel driver vs. Markus Rechberger's driver
Date: Wed, 30 Jun 2010 21:16:18 +0200
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Thorsten Hirsch <t.hirsch@web.de>
References: <AANLkTilP-jf0MaV82LuTz8DjoNJKQ3xGCHuFgds4b212@mail.gmail.com> <201006292142.48380.tkrah@fachschaft.imn.htwk-leipzig.de> <AANLkTin1Bj__L4p1jEvwLO-2Wjw6-R8ICLsfb2w32jP3@mail.gmail.com>
In-Reply-To: <AANLkTin1Bj__L4p1jEvwLO-2Wjw6-R8ICLsfb2w32jP3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart8092888.IFkfR55BLe";
  protocol="application/pkcs7-signature";
  micalg=sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201006302116.25893.tkrah@fachschaft.imn.htwk-leipzig.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--nextPart8092888.IFkfR55BLe
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Am Dienstag, 29. Juni 2010 schrieben Sie:
> Could you please verify if you have  the module i2c-dev loaded?

Yes it is.

>=20
> Example:
>=20
> #lsmod | grep i2c_dev
> i2c_dev                 6976  0
> i2c_core               21104  11
> i2c_dev,lgdt330x,tuner_xc2028,tuner,tvp5150,saa7115,em28xx,v4l2_common,vi=
de
> odev,tveeprom,i2c_i801

#lsmod | grep i2c
i2c_dev                 4970  0=20
i2c_algo_bit            5028  1 radeon


>=20
> If yes, please give us the output of:
>=20
> #i2cdetect -l
> i2c-0   smbus           SMBus I801 adapter at ece0              SMBus
> adapter i2c-1   smbus           em28xx
> #0                               SMBus adapter ^ here my device/driver

Thats the output:

# i2cdetect -l
i2c-0	i2c       	                                	I2C adapter


>=20
> Basically, in your case the tool is not able to recognize your device
> by i2cdetect.This may happen because i2c_dev module was not able to
> load?

Its loaded.

> If the module is not loaded, please load it manually and give a new try.

Did that but still no success.

>=20
> I did right now a test with i2c-tools 3.0.0 and 3.0.2.
> http://dl.lm-sensors.org/i2c-tools/releases/

I am using version 3.0.2.

>=20
> Let us know the results.


Did what you told but still no success using the tool - any other hints or=
=20
things i can do?

thx


Torsten

--nextPart8092888.IFkfR55BLe
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
CSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTAwNjMwMTkxNjIwWjAjBgkqhkiG9w0BCQQxFgQU
CXEXdSzzHvaHH/xLyxTPSTZNDjkwKAYJKoZIhvcNAQkPMRswGTALBglghkgBZQMEAQIwCgYIKoZI
hvcNAwcwDQYJKoZIhvcNAQEBBQAEggEAX35LqXe7zAofeyQyImgj0neUpqhc82UiEEiUGFIDwj/k
LGhYwayfjmG8svqkz5bNWMnf1Yl/Xn+TcHZfQNWmWBQO08YwakBIQX40a4PuvfJ+47VgWNnS/yRV
GTgVKKNwLBOkn+NXNba85yF18AZ2gRzqffMvFetZiSC8RyF2Eo4fjD0jvuwMbZbkHEnErdUlcmuk
agSM6PWV7tYqTKyge2AN0V0I0bstDcAlskA5Yc3URLszjr4YVGsW8ycZtZEL0PqqrGk6sIQ2l8kn
DEN3AYh+dVGI3IX5/6Tv7EOcR8LmiEh3feo0bKgL+qmXbYH2oOdlvgvJxTRgVbO5iskl1QAAAAAA
AA==

--nextPart8092888.IFkfR55BLe--
