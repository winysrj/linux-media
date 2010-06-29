Return-path: <linux-media-owner@vger.kernel.org>
Received: from tuxmail.imn.htwk-leipzig.de ([141.57.7.10]:48078 "EHLO
	tuxmail.imn.htwk-leipzig.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754599Ab0F2Nmd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Jun 2010 09:42:33 -0400
From: Torsten Krah <tkrah@fachschaft.imn.htwk-leipzig.de>
Reply-To: tkrah@fachschaft.imn.htwk-leipzig.de
To: linux-media@vger.kernel.org
Subject: Re: em28xx/xc3028 - kernel driver vs. Markus Rechberger's driver
Date: Tue, 29 Jun 2010 15:42:16 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Thorsten Hirsch <t.hirsch@web.de>
References: <AANLkTilP-jf0MaV82LuTz8DjoNJKQ3xGCHuFgds4b212@mail.gmail.com> <AANLkTinfZ8M_NlcQFwqRQFfLmMVKKIA3aC3o8v5u7YEF@mail.gmail.com> <4C213608.2080709@redhat.com>
In-Reply-To: <4C213608.2080709@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2859757.TmSiZeaGep";
  protocol="application/pkcs7-signature";
  micalg=sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201006291542.27655.tkrah@fachschaft.imn.htwk-leipzig.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--nextPart2859757.TmSiZeaGep
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Am Mittwoch, 23. Juni 2010, um 00:15:36 schrieb Mauro Carvalho Chehab:
> You probably damaged the contents of the device's eeprom. If you have the
> logs with the previous eeprom contents somewhere, it is possible to recov=
er
> it. There's an util at v4l-utils that allows re-writing the information at
> the eeprom.

Hi,

can you tell me which util and how it can be done.
I am too affected and damaged the eeprom (don't know how) - but my usb id d=
id=20
change too from e1ba:2870 to eb1a:2871.=20

Still need to find a old dmesg log for my stick but it should be this:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg14758.html

Is this "output" enough to rewrite the correct eeprom date back to my "bork=
ed"=20
stick or is something else needed?

thx

Torsten

=2D-=20
Bitte senden Sie mir keine Word- oder PowerPoint-Anh=E4nge.
Siehe http://www.gnu.org/philosophy/no-word-attachments.de.html

Really, I'm not out to destroy Microsoft. That will just be a=20
completely unintentional side effect."
	-- Linus Torvalds

--nextPart2859757.TmSiZeaGep
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
CSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTAwNjI5MTM0MjIyWjAjBgkqhkiG9w0BCQQxFgQU
mn5uqFrTboUVjzPHpBXEWAAExP0wKAYJKoZIhvcNAQkPMRswGTALBglghkgBZQMEAQIwCgYIKoZI
hvcNAwcwDQYJKoZIhvcNAQEBBQAEggEAdNtoCxlycuLVePmGUvvdzxfg0YI93coZq3XdoSMUuXi+
fSVWrXgyJdyx6DkvUdMVLy98qpCs5cykwdU56M8kXwqK9U0xFi2dbdaxkcBo1oUVhs4uR/Y+KJLU
5QZ9WrW+4Q3JJ5bj3QbIU+1D3OslBWkuZZX7qYar9aatEyf6unjVtnWvdsyCH5w4hS3HZaHh90ND
uoLTmIfAHif9ohH7H7wWDhdqaEJtqMBpXzTgYqAsF6og64z31XeH4E5Hz71ND9i9AyhZ7bHtIkkP
lg3bAM2bMdy57P5ubIoRh81808uI6gPe2gyRJygIGvB0kcy3IORbPKif7quVkc14jlXlSwAAAAAA
AA==

--nextPart2859757.TmSiZeaGep--
