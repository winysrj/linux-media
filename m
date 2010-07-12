Return-path: <linux-media-owner@vger.kernel.org>
Received: from tuxmail.imn.htwk-leipzig.de ([141.57.7.10]:33516 "EHLO
	tuxmail.imn.htwk-leipzig.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754404Ab0GLN1v (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Jul 2010 09:27:51 -0400
From: Torsten Krah <tkrah@fachschaft.imn.htwk-leipzig.de>
Reply-To: tkrah@fachschaft.imn.htwk-leipzig.de
To: Douglas Schilling Landgraf <dougsland@gmail.com>
Subject: Re: em28xx/xc3028 - kernel driver vs. Markus Rechberger's driver
Date: Mon, 12 Jul 2010 15:27:40 +0200
References: <AANLkTilP-jf0MaV82LuTz8DjoNJKQ3xGCHuFgds4b212@mail.gmail.com> <201007021547.24917.tkrah@fachschaft.imn.htwk-leipzig.de> <AANLkTilCwvUCEWLnurCvwvwRR1xdYU7D7359WBux2_7Q@mail.gmail.com>
In-Reply-To: <AANLkTilCwvUCEWLnurCvwvwRR1xdYU7D7359WBux2_7Q@mail.gmail.com>
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4480150.YOjllQhGtC";
  protocol="application/pkcs7-signature";
  micalg=sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201007121527.45279.tkrah@fachschaft.imn.htwk-leipzig.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--nextPart4480150.YOjllQhGtC
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Am Sonntag, 4. Juli 2010 schrieben Sie:
> Please try it, should be the root cause.

Did patch my v4l-dvb source tree too and modified it according to my usbid =
to=20
be a PCTV device :-)

After rewriting the eeprom it is a e1ba:2870 device again (70e) but still n=
ot=20
working with the recent kernel, but thats a know problem.

Thx for help getting the eeprom rewritten :-)  - now the stick may be usabl=
e=20
some time again.

Torsten

--nextPart4480150.YOjllQhGtC
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
CSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTAwNzEyMTMyNzQxWjAjBgkqhkiG9w0BCQQxFgQU
wDwEA3TmN5Y4fja+Ge4vokXtsSAwKAYJKoZIhvcNAQkPMRswGTALBglghkgBZQMEAQIwCgYIKoZI
hvcNAwcwDQYJKoZIhvcNAQEBBQAEggEAZFngiwCoEUSvPEiaWI6CZhVTjaOabPmLIik/zuVv8YpM
0xOnTAzD0vdPeRR/1DLaqPNCyo0qQpf8C5bvEkm0LnqQswMSZCUMOxplO2/Hjpla3c3G+J2fnPKn
XdDGU96nY4zm2yM5uNWuP4QZIj3QU+apZ+cWAlbvonWr6bEvea9/RtX4ElBuWksVmFt7K2OoHpvh
oyTRsIZXQ3VoqZxNDjyro8COmaakeYNx77kCDMip5mHJeDdjgCyKiSzwsK4JwUhi7dZy2xzc/yEj
tmMcphuHpqSKSUAEpEJGuYT2F245LAMToMqkCLGHiTT0Zl248yiw2BNCXkegaQHz9/Z5xQAAAAAA
AA==

--nextPart4480150.YOjllQhGtC--
