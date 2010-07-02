Return-path: <linux-media-owner@vger.kernel.org>
Received: from tuxmail.imn.htwk-leipzig.de ([141.57.7.10]:60176 "EHLO
	tuxmail.imn.htwk-leipzig.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753330Ab0GBNra (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Jul 2010 09:47:30 -0400
From: Torsten Krah <tkrah@fachschaft.imn.htwk-leipzig.de>
Reply-To: tkrah@fachschaft.imn.htwk-leipzig.de
To: Douglas Schilling Landgraf <dougsland@gmail.com>,
	Thorsten Hirsch <t.hirsch@web.de>
Subject: Re: em28xx/xc3028 - kernel driver vs. Markus Rechberger's driver
Date: Fri, 2 Jul 2010 15:47:21 +0200
Cc: linux-media@vger.kernel.org
References: <AANLkTilP-jf0MaV82LuTz8DjoNJKQ3xGCHuFgds4b212@mail.gmail.com> <201006302116.25893.tkrah@fachschaft.imn.htwk-leipzig.de> <AANLkTikFtWbXKxnAcfGd2LP4fDjRFwGdNarzDUh3rxt6@mail.gmail.com>
In-Reply-To: <AANLkTikFtWbXKxnAcfGd2LP4fDjRFwGdNarzDUh3rxt6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2406589.KyEaDBmfAM";
  protocol="application/pkcs7-signature";
  micalg=sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201007021547.24917.tkrah@fachschaft.imn.htwk-leipzig.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--nextPart2406589.KyEaDBmfAM
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Am Freitag, 2. Juli 2010, um 02:59:57 schrieb Douglas Schilling Landgraf:
> humm, not really :-/ Are you sure em28xx/device get loaded when your
> device is plugged?
>=20
> A good test:
>=20
> - unplug your device
> - dmesg -c  (clear the dmesg)
> - plug your device
> - check your dmesg, see if there is any error or message and please
> send to us the output.
> - lsmod could help also.
> - if it's ok, load the i2c modules

The em28xx device gets not loaded because the usb id has changed and e1ba:2=
871=20
is not associated to the em28xx-cards.
the usb id is wrong like i mentioned before - that may be the cause.
I provide you with dmesg later on.

Maybe i need the patch Thorsten did too, to patch the em28xx-cards.c to get=
=20
the "new" wrong usb id regognized as a em28xx device so that i can reflash =
the=20
eeprom of the device. I might give this a try later this day.

@Thorsten: Did you reflash the device eeprom with your patched em28xx drive=
r=20
or without the patch?

>=20
> What's the message of rewirte_eeprom.pl? The same as Throsten?

No, all ok.My distribution is lacking any i2c_smbus module - can't load thi=
s=20
one. Maybe Ubuntu does not build or 2.6.32 does not habe this one (looking=
=20
through the source i did not find it yet - maybe i missed that).

>=20
> @Thorsten, in my case never needed to load modprobed i2c-smbus also.
> That's why rewrite_eeprom failed to you, the script is not looking
> to load this module. Thanks for the feedback.


=2D-=20
Bitte senden Sie mir keine Word- oder PowerPoint-Anh=E4nge.
Siehe http://www.gnu.org/philosophy/no-word-attachments.de.html

Really, I'm not out to destroy Microsoft. That will just be a=20
completely unintentional side effect."
	-- Linus Torvalds

--nextPart2406589.KyEaDBmfAM
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
CSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTAwNzAyMTM0NzIxWjAjBgkqhkiG9w0BCQQxFgQU
AmPDXis0/XyHtmqfaIlRqcyz8LIwKAYJKoZIhvcNAQkPMRswGTALBglghkgBZQMEAQIwCgYIKoZI
hvcNAwcwDQYJKoZIhvcNAQEBBQAEggEA3vShn6myBHnqjZQ4I+z6YBMJU3SMywWjx0v2/492Y7lB
KaN/JHq0qEn1WFXKLr+8JalBD3xRmmZ37gLOB1snlLlErUvN1gAZljfI32q1VCkMKOUsSLm41pTG
6yHDq3zvSNjSQyg8BBaJOzRmcyKu+KQUHenc2J5MVf6WWc4Gk7ErEH04RJwWHkH0+cHXcAfi9yZG
UJzAmxv3pP/XE66q0DQs9DaGUjujxX093LenkdR6Hko49UL2q8WIaCDLvcTVZsklgTMg3t9wjueG
rsgHermLOVxMpspT4uVNR+ddfT3WZjjTdb0qFSE5xliDQn0IRbVivWOJ4Agb27AVz6WxlQAAAAAA
AA==

--nextPart2406589.KyEaDBmfAM--
