Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mu-out-0910.google.com ([209.85.134.184])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <filippo.argiolas@gmail.com>) id 1KwKFI-0002dV-4z
	for linux-dvb@linuxtv.org; Sat, 01 Nov 2008 18:26:45 +0100
Received: by mu-out-0910.google.com with SMTP id g7so1742466muf.1
	for <linux-dvb@linuxtv.org>; Sat, 01 Nov 2008 10:26:39 -0700 (PDT)
From: Filippo Argiolas <filippo.argiolas@gmail.com>
To: linux-dvb@linuxtv.org
Date: Sat, 01 Nov 2008 18:26:32 +0100
Message-Id: <1225560392.3982.91.camel@tux>
Mime-Version: 1.0
Subject: [linux-dvb] [PATCH] Emtec S810 (1164:2edc) support
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1102127662=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--===============1102127662==
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-8KOWRSPrLupmTYGMahUZ"


--=-8KOWRSPrLupmTYGMahUZ
Content-Type: multipart/mixed; boundary="=-vs+rRjjIYiYmqUSY/Nz4"


--=-vs+rRjjIYiYmqUSY/Nz4
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Adds support for Emtec S810 (1164:2edc device id) dvb-t usb stick to
dib0700. Here is there relevant line from lsusb:
Bus 004 Device 003: ID 1164:2edc YUAN High-Tech Development Co., Ltd=20
Patch against latest v4l-dvb tree (pulled about half an hour ago).

Signed-off-by: Filippo Argiolas <filippo.argiolas@gmail.com>

Thanks to Luca Borore (the device owner) for the help and feedback given
on irc while testing the patch.

Best Regards,

Filippo

--=-vs+rRjjIYiYmqUSY/Nz4
Content-Disposition: attachment; filename="emtec-s810.diff"
Content-Type: text/x-patch; name="emtec-s810.diff"; charset="UTF-8"
Content-Transfer-Encoding: base64

ZGlmZiAtciA1NWY4ZmNmNzA4NDMgbGludXgvZHJpdmVycy9tZWRpYS9kdmIvZHZiLXVzYi9kaWIw
NzAwX2RldmljZXMuYw0KLS0tIGEvbGludXgvZHJpdmVycy9tZWRpYS9kdmIvZHZiLXVzYi9kaWIw
NzAwX2RldmljZXMuYwlUaHUgT2N0IDMwIDA4OjA3OjQ0IDIwMDggKzAwMDANCisrKyBiL2xpbnV4
L2RyaXZlcnMvbWVkaWEvZHZiL2R2Yi11c2IvZGliMDcwMF9kZXZpY2VzLmMJU2F0IE5vdiAwMSAx
NTozMTowMCAyMDA4ICswMTAwDQpAQCAtMTI1Niw2ICsxMjU2LDcgQEANCiAJeyBVU0JfREVWSUNF
KFVTQl9WSURfQVNVUywJVVNCX1BJRF9BU1VTX1UzMDAwSCkgfSwNCiAvKiA0MCAqL3sgVVNCX0RF
VklDRShVU0JfVklEX1BJTk5BQ0xFLCAgVVNCX1BJRF9QSU5OQUNMRV9QQ1RWODAxRSkgfSwNCiAJ
eyBVU0JfREVWSUNFKFVTQl9WSURfUElOTkFDTEUsICBVU0JfUElEX1BJTk5BQ0xFX1BDVFY4MDFF
X1NFKSB9LA0KKwl7IFVTQl9ERVZJQ0UoVVNCX1ZJRF9ZVUFOLCAgICAgIFVTQl9QSURfRU1URUNf
UzgxMCkgfSwNCiAJeyAwIH0JCS8qIFRlcm1pbmF0aW5nIGVudHJ5ICovDQogfTsNCiBNT0RVTEVf
REVWSUNFX1RBQkxFKHVzYiwgZGliMDcwMF91c2JfaWRfdGFibGUpOw0KQEAgLTE0NTAsNyArMTQ1
MSw3IEBADQogCQkJfSwNCiAJCX0sDQogDQotCQkubnVtX2RldmljZV9kZXNjcyA9IDksDQorCQku
bnVtX2RldmljZV9kZXNjcyA9IDEwLA0KIAkJLmRldmljZXMgPSB7DQogCQkJeyAgICJEaUJjb20g
U1RLNzA3MFAgcmVmZXJlbmNlIGRlc2lnbiIsDQogCQkJCXsgJmRpYjA3MDBfdXNiX2lkX3RhYmxl
WzE1XSwgTlVMTCB9LA0KQEAgLTE0ODgsNiArMTQ4OSwxMSBAQA0KIAkJCQl7ICZkaWIwNzAwX3Vz
Yl9pZF90YWJsZVszM10sIE5VTEwgfSwNCiAJCQkJeyBOVUxMIH0sDQogCQkJfSwNCisJCQl7ICAg
IkVtdGVjIFM4MTAiLA0KKwkJCQl7ICZkaWIwNzAwX3VzYl9pZF90YWJsZVs0Ml0sIE5VTEwgfSwN
CisJCQkJeyBOVUxMIH0sDQorCQkJfSwNCisNCiAJCX0sDQogDQogCQkucmNfaW50ZXJ2YWwgICAg
ICA9IERFRkFVTFRfUkNfSU5URVJWQUwsDQpkaWZmIC1yIDU1ZjhmY2Y3MDg0MyBsaW51eC9kcml2
ZXJzL21lZGlhL2R2Yi9kdmItdXNiL2R2Yi11c2ItaWRzLmgNCi0tLSBhL2xpbnV4L2RyaXZlcnMv
bWVkaWEvZHZiL2R2Yi11c2IvZHZiLXVzYi1pZHMuaAlUaHUgT2N0IDMwIDA4OjA3OjQ0IDIwMDgg
KzAwMDANCisrKyBiL2xpbnV4L2RyaXZlcnMvbWVkaWEvZHZiL2R2Yi11c2IvZHZiLXVzYi1pZHMu
aAlTYXQgTm92IDAxIDE1OjMxOjAwIDIwMDggKzAxMDANCkBAIC0yMjksNiArMjI5LDcgQEANCiAj
ZGVmaW5lIFVTQl9QSURfQVNVU19VMzEwMAkJCQkweDE3M2YNCiAjZGVmaW5lIFVTQl9QSURfWVVB
Tl9FQzM3MlMJCQkJMHgxZWRjDQogI2RlZmluZSBVU0JfUElEX1lVQU5fU1RLNzcwMFBICQkJCTB4
MWYwOA0KKyNkZWZpbmUgVVNCX1BJRF9FTVRFQ19TODEwICAgICAJCQkweDJlZGMNCiAjZGVmaW5l
IFVTQl9QSURfRFcyMTAyCQkJCQkweDIxMDINCiAjZGVmaW5lIFVTQl9QSURfWFRFTlNJT05TX1hE
XzM4MAkJCTB4MDM4MQ0KICNkZWZpbmUgVVNCX1BJRF9URUxFU1RBUl9TVEFSU1RJQ0tfMgkJCTB4
ODAwMA0KZGlmZiAtciA1NWY4ZmNmNzA4NDMgbGludXgvZHJpdmVycy9tZWRpYS9kdmIvZHZiLXVz
Yi9kdmItdXNiLmgNCi0tLSBhL2xpbnV4L2RyaXZlcnMvbWVkaWEvZHZiL2R2Yi11c2IvZHZiLXVz
Yi5oCVRodSBPY3QgMzAgMDg6MDc6NDQgMjAwOCArMDAwMA0KKysrIGIvbGludXgvZHJpdmVycy9t
ZWRpYS9kdmIvZHZiLXVzYi9kdmItdXNiLmgJU2F0IE5vdiAwMSAxNTozMTowMCAyMDA4ICswMTAw
DQpAQCAtMjI0LDcgKzIyNCw3IEBADQogCWludCBnZW5lcmljX2J1bGtfY3RybF9lbmRwb2ludDsN
CiANCiAJaW50IG51bV9kZXZpY2VfZGVzY3M7DQotCXN0cnVjdCBkdmJfdXNiX2RldmljZV9kZXNj
cmlwdGlvbiBkZXZpY2VzWzldOw0KKwlzdHJ1Y3QgZHZiX3VzYl9kZXZpY2VfZGVzY3JpcHRpb24g
ZGV2aWNlc1sxMF07DQogfTsNCiANCiAvKioNCg==


--=-vs+rRjjIYiYmqUSY/Nz4--

--=-8KOWRSPrLupmTYGMahUZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkMkUAACgkQDNBLuf7fMcEz0wCeOWFRYZkPW7FAI09Mmda0WPXG
e1EAn30DVic/hxszSN28Ymoe6az1k8uA
=5Aiz
-----END PGP SIGNATURE-----

--=-8KOWRSPrLupmTYGMahUZ--



--===============1102127662==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1102127662==--
