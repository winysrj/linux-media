Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36985 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226Ab1LJEoB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Dec 2011 23:44:01 -0500
Received: by mail-ww0-f44.google.com with SMTP id dr13so6983961wgb.1
        for <linux-media@vger.kernel.org>; Fri, 09 Dec 2011 20:44:01 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 10 Dec 2011 10:14:00 +0530
Message-ID: <CAHFNz9Jbu-Kb8+s5DmEX8NOP6K8yjwNXYucUqmUEH_LcQAvpGA@mail.gmail.com>
Subject: v4 [PATCH 08/10] TDA18271c2dd: Allow frontend to set DELSYS
From: Manu Abraham <abraham.manu@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: multipart/mixed; boundary=000e0cd59fe0e3b1d404b3b58cbe
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--000e0cd59fe0e3b1d404b3b58cbe
Content-Type: text/plain; charset=ISO-8859-1



--000e0cd59fe0e3b1d404b3b58cbe
Content-Type: text/x-patch; charset=US-ASCII;
	name="0008-TDA18271c2dd-Allow-frontend-to-set-DELSYS-rather-tha.patch"
Content-Disposition: attachment;
	filename="0008-TDA18271c2dd-Allow-frontend-to-set-DELSYS-rather-tha.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: file0

RnJvbSA3MDc4NzdmNWE2MWIzMjU5NzA0ZDQyZTdkZDVlNjQ3ZTkxOTZlOWE0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNYW51IEFicmFoYW0gPGFicmFoYW0ubWFudUBnbWFpbC5jb20+
CkRhdGU6IFRodSwgMjQgTm92IDIwMTEgMTk6NTY6MzQgKzA1MzAKU3ViamVjdDogW1BBVENIIDA4
LzEwXSBUREExODI3MWMyZGQ6IEFsbG93IGZyb250ZW5kIHRvIHNldCBERUxTWVMsIHJhdGhlciB0
aGFuIHF1ZXJ5aW5nIGZlLT5vcHMuaW5mby50eXBlCgpXaXRoIGFueSB0dW5lciB0aGF0IGNhbiB0
dW5lIHRvIG11bHRpcGxlIGRlbGl2ZXJ5IHN5c3RlbXMvc3RhbmRhcmRzLCBpdCBkb2VzCnF1ZXJ5
IGZlLT5vcHMuaW5mby50eXBlIHRvIGRldGVybWluZSBmcm9udGVuZCB0eXBlIGFuZCBzZXQgdGhl
IGRlbGl2ZXJ5CnN5c3RlbSB0eXBlLiBmZS0+b3BzLmluZm8udHlwZSBjYW4gaGFuZGxlIG9ubHkg
NCBkZWxpdmVyeSBzeXN0ZW1zLCB2aXogRkVfUVBTSywKRkVfUUFNLCBGRV9PRkRNIGFuZCBGRV9B
VFNDLgoKU2lnbmVkLW9mZi1ieTogTWFudSBBYnJhaGFtIDxhYnJhaGFtLm1hbnVAZ21haWwuY29t
PgotLS0KIGRyaXZlcnMvbWVkaWEvZHZiL2Zyb250ZW5kcy90ZGExODI3MWMyZGQuYyB8ICAgNDIg
KysrKysrKysrKysrKysrKysrKystLS0tLS0tLQogMSBmaWxlcyBjaGFuZ2VkLCAzMCBpbnNlcnRp
b25zKCspLCAxMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL21lZGlhL2R2Yi9m
cm9udGVuZHMvdGRhMTgyNzFjMmRkLmMgYi9kcml2ZXJzL21lZGlhL2R2Yi9mcm9udGVuZHMvdGRh
MTgyNzFjMmRkLmMKaW5kZXggMWIxYmYyMC4uNDNhM2RkNCAxMDA2NDQKLS0tIGEvZHJpdmVycy9t
ZWRpYS9kdmIvZnJvbnRlbmRzL3RkYTE4MjcxYzJkZC5jCisrKyBiL2RyaXZlcnMvbWVkaWEvZHZi
L2Zyb250ZW5kcy90ZGExODI3MWMyZGQuYwpAQCAtMTE0NSwyOCArMTE0NSw0NiBAQCBzdGF0aWMg
aW50IHNldF9wYXJhbXMoc3RydWN0IGR2Yl9mcm9udGVuZCAqZmUsCiAJaW50IHN0YXR1cyA9IDA7
CiAJaW50IFN0YW5kYXJkOwogCi0Jc3RhdGUtPm1fRnJlcXVlbmN5ID0gcGFyYW1zLT5mcmVxdWVu
Y3k7CisJdTMyIGJ3OworCWZlX2RlbGl2ZXJ5X3N5c3RlbV90IGRlbHN5czsKIAotCWlmIChmZS0+
b3BzLmluZm8udHlwZSA9PSBGRV9PRkRNKQotCQlzd2l0Y2ggKHBhcmFtcy0+dS5vZmRtLmJhbmR3
aWR0aCkgewotCQljYXNlIEJBTkRXSURUSF82X01IWjoKKwlkZWxzeXMJPSBmZS0+ZHR2X3Byb3Bl
cnR5X2NhY2hlLmRlbGl2ZXJ5X3N5c3RlbTsKKwlidwk9IGZlLT5kdHZfcHJvcGVydHlfY2FjaGUu
YmFuZHdpZHRoX2h6OworCisJc3RhdGUtPm1fRnJlcXVlbmN5ID0gZmUtPmR0dl9wcm9wZXJ0eV9j
YWNoZS5mcmVxdWVuY3k7CisKKwlpZiAoIWRlbHN5cyB8fCAhc3RhdGUtPm1fRnJlcXVlbmN5KSB7
CisJCXByaW50ayhLRVJOX0VSUiAiSW52YWxpZCBkZWxzeXM6JWQgZnJlcTolZFxuIiwgZGVsc3lz
LCBzdGF0ZS0+bV9GcmVxdWVuY3kpOworCQlyZXR1cm4gLUVJTlZBTDsKKwl9CisKKwlzd2l0Y2gg
KGRlbHN5cykgeworCWNhc2UgU1lTX0RWQlQ6CisJY2FzZSBTWVNfRFZCVDI6CisJCWlmICghYncp
CisJCQlyZXR1cm4gLUVJTlZBTDsKKwkJc3dpdGNoIChidykgeworCQljYXNlIDYwMDAwMDA6CiAJ
CQlTdGFuZGFyZCA9IEhGX0RWQlRfNk1IWjsKIAkJCWJyZWFrOwotCQljYXNlIEJBTkRXSURUSF83
X01IWjoKKwkJY2FzZSA3MDAwMDAwOgogCQkJU3RhbmRhcmQgPSBIRl9EVkJUXzdNSFo7CiAJCQli
cmVhazsKIAkJZGVmYXVsdDoKLQkJY2FzZSBCQU5EV0lEVEhfOF9NSFo6CisJCWNhc2UgODAwMDAw
MDoKIAkJCVN0YW5kYXJkID0gSEZfRFZCVF84TUhaOwogCQkJYnJlYWs7CiAJCX0KLQllbHNlIGlm
IChmZS0+b3BzLmluZm8udHlwZSA9PSBGRV9RQU0pIHsKLQkJaWYgKHBhcmFtcy0+dS5xYW0uc3lt
Ym9sX3JhdGUgPD0gTUFYX1NZTUJPTF9SQVRFXzZNSHopCi0JCQlTdGFuZGFyZCA9IEhGX0RWQkNf
Nk1IWjsKLQkJZWxzZQotCQkJU3RhbmRhcmQgPSBIRl9EVkJDXzhNSFo7Ci0JfSBlbHNlCisJCWJy
ZWFrOworCWNhc2UgU1lTX0RWQkNfQU5ORVhfQToKKwkJU3RhbmRhcmQgPSBIRl9EVkJDXzZNSFo7
CisJCWJyZWFrOworCWNhc2UgU1lTX0RWQkNfQU5ORVhfQzoKKwkJU3RhbmRhcmQgPSBIRl9EVkJD
XzhNSFo7CisJCWJyZWFrOworCWRlZmF1bHQ6CiAJCXJldHVybiAtRUlOVkFMOworCX0KIAlkbyB7
CiAJCXN0YXR1cyA9IFJGVHJhY2tpbmdGaWx0ZXJzQ29ycmVjdGlvbihzdGF0ZSwgcGFyYW1zLT5m
cmVxdWVuY3kpOwogCQlpZiAoc3RhdHVzIDwgMCkKLS0gCjEuNy4xCgo=
--000e0cd59fe0e3b1d404b3b58cbe--
