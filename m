Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36325 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756099Ab2AEL7j (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jan 2012 06:59:39 -0500
Received: by eaad14 with SMTP id d14so277938eaa.19
        for <linux-media@vger.kernel.org>; Thu, 05 Jan 2012 03:59:38 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 5 Jan 2012 12:59:38 +0100
Message-ID: <CAEN_-SDunYOjMHuReA106RRvYd0mdsgoouORDodLVp9hRax66Q@mail.gmail.com>
Subject: Fix Leadtek DTV2000H radio tuner
From: =?ISO-8859-2?Q?Miroslav_Sluge=F2?= <thunder.mmm@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary=0015175d67eca7bd8204b5c6aa9d
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--0015175d67eca7bd8204b5c6aa9d
Content-Type: text/plain; charset=ISO-8859-1

Resending signed-off version for kernel 3.2

--0015175d67eca7bd8204b5c6aa9d
Content-Type: text/x-patch; charset=US-ASCII;
	name="Leadtek-DTV2000H-J-has-Philips-FMD1216MEX-tuner-this.patch"
Content-Disposition: attachment;
	filename="Leadtek-DTV2000H-J-has-Philips-FMD1216MEX-tuner-this.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gx1q3fyf1

U2lnbmVkLW9mZi1ieTogTWlyb3NsYXYgU2x1Z2VuIDx0aHVuZGVyLm1tbUBnbWFpbC5jb20+CkZy
b20gZGFkZmE0NTY2NGY3NjUyOTdlMDNlNzNhOTA3YWMwNGJkNTVlOWIyNSBNb24gU2VwIDE3IDAw
OjAwOjAwIDIwMDEKRnJvbTogTWlyb3NsYXYgU2x1Z2VuIDx0aHVuZGVyLm1tbUBnbWFpbC5jb20+
CkRhdGU6IFR1ZSwgMTMgRGVjIDIwMTEgMTk6MzY6MTUgKzAxMDAKU3ViamVjdDogW1BBVENIXSBM
ZWFkdGVrIERUVjIwMDBIIEogaGFzIFBoaWxpcHMgRk1EMTIxNk1FWCB0dW5lciwgdGhpcyBwYXRj
aCBmaXhlZCBub3Qgd29ya2luZwogcmFkaW8gcGFydCwgYnV0IHNvbWUgc3RhdGlvbnMgYXJlIHN0
aWxsIG5vdCB2aXNpYmxlLgoKLS0tCmRpZmYgLU5hdXJwIGEvZHJpdmVycy9tZWRpYS92aWRlby9j
eDg4L2N4ODgtY2FyZHMuYyBiL2RyaXZlcnMvbWVkaWEvdmlkZW8vY3g4OC9jeDg4LWNhcmRzLmMK
LS0tIGEvZHJpdmVycy9tZWRpYS92aWRlby9jeDg4L2N4ODgtY2FyZHMuYwkyMDEyLTAxLTA1IDAw
OjU1OjQ0LjAwMDAwMDAwMCArMDEwMAorKysgYi9kcml2ZXJzL21lZGlhL3ZpZGVvL2N4ODgvY3g4
OC1jYXJkcy5jCTIwMTItMDEtMDUgMTI6Mzg6MjcuMTc3OTEwODAyICswMTAwCkBAIC0xMzA2LDcg
KzEzMDYsNyBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IGN4ODhfYm9hcmQgY3g4OF9ib2FyCiAJfSwK
IAlbQ1g4OF9CT0FSRF9XSU5GQVNUX0RUVjIwMDBIX0pdID0gewogCQkubmFtZSAgICAgICAgICAg
PSAiV2luRmFzdCBEVFYyMDAwIEggcmV2LiBKIiwKLQkJLnR1bmVyX3R5cGUgICAgID0gVFVORVJf
UEhJTElQU19GTUQxMjE2TUVfTUszLAorCQkudHVuZXJfdHlwZSAgICAgPSBUVU5FUl9QSElMSVBT
X0ZNRDEyMTZNRVhfTUszLAogCQkucmFkaW9fdHlwZSAgICAgPSBVTlNFVCwKIAkJLnR1bmVyX2Fk
ZHIgICAgID0gQUREUl9VTlNFVCwKIAkJLnJhZGlvX2FkZHIgICAgID0gQUREUl9VTlNFVCwKQEAg
LTMyMzIsNiArMzIzMiw3IEBAIHN0YXRpYyB2b2lkIGN4ODhfY2FyZF9zZXR1cF9wcmVfaTJjKHN0
cnUKIAkJY3hfc2V0KE1PX0dQMF9JTywgMHgwMDAwMTAxMCk7CiAJCWJyZWFrOwogCisJY2FzZSBD
WDg4X0JPQVJEX1dJTkZBU1RfRFRWMjAwMEhfSjoKIAljYXNlIENYODhfQk9BUkRfSEFVUFBBVUdF
X0hWUjMwMDA6CiAJY2FzZSBDWDg4X0JPQVJEX0hBVVBQQVVHRV9IVlI0MDAwOgogCQkvKiBJbml0
IEdQSU8gKi8KZGlmZiAtTmF1cnAgYS9kcml2ZXJzL21lZGlhL3ZpZGVvL2N4ODgvY3g4OC1kdmIu
YyBiL2RyaXZlcnMvbWVkaWEvdmlkZW8vY3g4OC9jeDg4LWR2Yi5jCi0tLSBhL2RyaXZlcnMvbWVk
aWEvdmlkZW8vY3g4OC9jeDg4LWR2Yi5jCTIwMTItMDEtMDUgMDA6NTU6NDQuMDAwMDAwMDAwICsw
MTAwCisrKyBiL2RyaXZlcnMvbWVkaWEvdmlkZW8vY3g4OC9jeDg4LWR2Yi5jCTIwMTItMDEtMDUg
MTI6Mzg6MjcuMTc3OTEwODAyICswMTAwCkBAIC05OTksNyArOTk5LDYgQEAgc3RhdGljIGludCBk
dmJfcmVnaXN0ZXIoc3RydWN0IGN4ODgwMl9kZQogCQl9CiAJCWJyZWFrOwogCWNhc2UgQ1g4OF9C
T0FSRF9XSU5GQVNUX0RUVjIwMDBIOgotCWNhc2UgQ1g4OF9CT0FSRF9XSU5GQVNUX0RUVjIwMDBI
X0o6CiAJY2FzZSBDWDg4X0JPQVJEX0hBVVBQQVVHRV9IVlIxMTAwOgogCWNhc2UgQ1g4OF9CT0FS
RF9IQVVQUEFVR0VfSFZSMTEwMExQOgogCWNhc2UgQ1g4OF9CT0FSRF9IQVVQUEFVR0VfSFZSMTMw
MDoKQEAgLTEwMTMsNiArMTAxMiwxNyBAQCBzdGF0aWMgaW50IGR2Yl9yZWdpc3RlcihzdHJ1Y3Qg
Y3g4ODAyX2RlCiAJCQkJZ290byBmcm9udGVuZF9kZXRhY2g7CiAJCX0KIAkJYnJlYWs7CisJY2Fz
ZSBDWDg4X0JPQVJEX1dJTkZBU1RfRFRWMjAwMEhfSjoKKwkJZmUwLT5kdmIuZnJvbnRlbmQgPSBk
dmJfYXR0YWNoKGN4MjI3MDJfYXR0YWNoLAorCQkJCQkgICAgICAgJmhhdXBwYXVnZV9odnJfY29u
ZmlnLAorCQkJCQkgICAgICAgJmNvcmUtPmkyY19hZGFwKTsKKwkJaWYgKGZlMC0+ZHZiLmZyb250
ZW5kICE9IE5VTEwpIHsKKwkJCWlmICghZHZiX2F0dGFjaChzaW1wbGVfdHVuZXJfYXR0YWNoLCBm
ZTAtPmR2Yi5mcm9udGVuZCwKKwkJCQkgICAmY29yZS0+aTJjX2FkYXAsIDB4NjEsCisJCQkJICAg
VFVORVJfUEhJTElQU19GTUQxMjE2TUVYX01LMykpCisJCQkJZ290byBmcm9udGVuZF9kZXRhY2g7
CisJCX0KKwkJYnJlYWs7CiAJY2FzZSBDWDg4X0JPQVJEX0hBVVBQQVVHRV9IVlIzMDAwOgogCQkv
KiBNRkUgZnJvbnRlbmQgMSAqLwogCQltZmVfc2hhcmVkID0gMTsKZGlmZiAtTmF1cnAgYS9kcml2
ZXJzL21lZGlhL3ZpZGVvL3R1bmVyLWNvcmUuYyBiL2RyaXZlcnMvbWVkaWEvdmlkZW8vdHVuZXIt
Y29yZS5jCi0tLSBhL2RyaXZlcnMvbWVkaWEvdmlkZW8vdHVuZXItY29yZS5jCTIwMTItMDEtMDUg
MDA6NTU6NDQuMDAwMDAwMDAwICswMTAwCisrKyBiL2RyaXZlcnMvbWVkaWEvdmlkZW8vdHVuZXIt
Y29yZS5jCTIwMTItMDEtMDUgMTI6Mzg6MjcuMTc3OTEwODAyICswMTAwCkBAIC0zMjYsNiArMzI2
LDcgQEAgc3RhdGljIHZvaWQgc2V0X3R5cGUoc3RydWN0IGkyY19jbGllbnQgKgogCQl0LT5tb2Rl
X21hc2sgPSBUX1JBRElPOwogCQlicmVhazsKIAljYXNlIFRVTkVSX1BISUxJUFNfRk1EMTIxNk1F
X01LMzoKKwljYXNlIFRVTkVSX1BISUxJUFNfRk1EMTIxNk1FWF9NSzM6CiAJCWJ1ZmZlclswXSA9
IDB4MGI7CiAJCWJ1ZmZlclsxXSA9IDB4ZGM7CiAJCWJ1ZmZlclsyXSA9IDB4OWM7Cg==
--0015175d67eca7bd8204b5c6aa9d--
