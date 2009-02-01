Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1009.centrum.cz ([90.183.38.139]:38677 "EHLO
	mail1009.centrum.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224AbZBAQhR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Feb 2009 11:37:17 -0500
Received: by mail1009.centrum.cz id S738346521AbZBAQhD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Feb 2009 17:37:03 +0100
Date: Sun, 01 Feb 2009 17:37:03 +0100
From: "Miroslav =?UTF-8?Q?=20=C5=A0ustek?=" <sustmidown@centrum.cz>
To: <linux-media@vger.kernel.org>, <mchehab@redhat.com>
MIME-Version: 1.0
Message-ID: <200902011737.4646@centrum.cz>
References: <200902011729.11885@centrum.cz> <200902011730.15853@centrum.cz> <200902011731.21563@centrum.cz> <200902011732.21401@centrum.cz> <200902011733.12125@centrum.cz> <200902011734.8961@centrum.cz> <200902011735.14944@centrum.cz> <200902011736.23401@centrum.cz>
In-Reply-To: <200902011736.23401@centrum.cz>
Subject: [PATCH] Leadtek WinFast DTV-1800H and DTV-2000H
Content-Type: multipart/mixed; boundary="-------=_7AC17373.74EF5A0A"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format

---------=_7AC17373.74EF5A0A
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

Hi, few months ago I sent the patch for Leadtek WinFast DTV-1800H card, but it wasn't merged to repository yet.
Maybe it's because of the merging of mailing lists. I'm sending it again.

These are the original messages:
http://linuxtv.org/pipermail/linux-dvb/2008-October/029859.html
http://linuxtv.org/pipermail/linux-dvb/2008-November/030362.html

Briefly, patch adds support for analog tv, radio, dvb-t and remote control.
About three people already confirmed the functionality.
----

The second patch I attached (leadtek_winfast_dtv2000h.patch) is from Mirek Slugeň and it adds support for some revisions of Leadtek WinFast DTV-2000H.
I don't have any of DTV-2000H cards, so I cannot confirm its correctness.

Here is the original message from Mirek Slugeň:
http://linuxtv.org/pipermail/linux-dvb/2008-November/030644.html

(The patch is dependent on 1800H patch.)
----

I hope this is the last time I'm bothering you with this thing. ;)

- Miroslav Šustek


---------=_7AC17373.74EF5A0A
Content-Type: application/octet-stream; name="leadtek_winfast_dtv1800h.patch"
Content-Transfer-Encoding: base64

QWRkcyBzdXBwb3J0IGZvciBMZWFkdGVrIFdpbkZhc3QgRFRWLTE4MDBICgpGcm9tOiBNaXJv
c2xhdiBTdXN0ZWsgPHN1c3RtaWRvd25AY2VudHJ1bS5jej4KCkVuYWJsZXMgYW5hbG9nIHR2
IGFuZCByYWRpbywgZHZiLXQgYW5kIChncGlvKSByZW1vdGUgY29udHJvbC4KClNpZ25lZC1v
ZmYtYnk6IE1pcm9zbGF2IFN1c3RlayA8c3VzdG1pZG93bkBjZW50cnVtLmN6PgoKZGlmZiAt
ciAxZGNlOWQ0ZTIxNzkgbGludXgvRG9jdW1lbnRhdGlvbi92aWRlbzRsaW51eC9DQVJETElT
VC5jeDg4Ci0tLSBhL2xpbnV4L0RvY3VtZW50YXRpb24vdmlkZW80bGludXgvQ0FSRExJU1Qu
Y3g4OAlTdW4gRmViIDAxIDExOjQwOjI3IDIwMDkgLTAyMDAKKysrIGIvbGludXgvRG9jdW1l
bnRhdGlvbi92aWRlbzRsaW51eC9DQVJETElTVC5jeDg4CVN1biBGZWIgMDEgMTU6MjU6MzIg
MjAwOSArMDEwMApAQCAtNzcsMyArNzcsNCBAQAogIDc2IC0+IFNBVFRSQURFIFNUNDIwMCBE
VkItUy9TMiAgICAgICAgICAgICAgICAgICAgICAgICAgICBbYjIwMDo0MjAwXQogIDc3IC0+
IFRCUyA4OTEwIERWQi1TICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBb
ODkxMDo4ODg4XQogIDc4IC0+IFByb2YgNjIwMCBEVkItUyAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICBbYjAyMjozMDIyXQorIDc5IC0+IExlYWR0ZWsgV2luRmFzdCBE
VFYxODAwIEh5YnJpZCAgICAgICAgICAgICAgICAgICAgICBbMTA3ZDo2NjU0XQpkaWZmIC1y
IDFkY2U5ZDRlMjE3OSBsaW51eC9kcml2ZXJzL21lZGlhL3ZpZGVvL2N4ODgvY3g4OC1jYXJk
cy5jCi0tLSBhL2xpbnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8vY3g4OC9jeDg4LWNhcmRzLmMJ
U3VuIEZlYiAwMSAxMTo0MDoyNyAyMDA5IC0wMjAwCisrKyBiL2xpbnV4L2RyaXZlcnMvbWVk
aWEvdmlkZW8vY3g4OC9jeDg4LWNhcmRzLmMJU3VuIEZlYiAwMSAxNToyNTozMiAyMDA5ICsw
MTAwCkBAIC0xOTY3LDYgKzE5NjcsNDcgQEAKIAkJfSB9LAogCQkubXBlZyAgICAgICAgICAg
PSBDWDg4X01QRUdfRFZCLAogCX0sCisJW0NYODhfQk9BUkRfV0lORkFTVF9EVFYxODAwSF0g
PSB7CisJCS5uYW1lICAgICAgICAgICA9ICJMZWFkdGVrIFdpbkZhc3QgRFRWMTgwMCBIeWJy
aWQiLAorCQkudHVuZXJfdHlwZSAgICAgPSBUVU5FUl9YQzIwMjgsCisJCS5yYWRpb190eXBl
ICAgICA9IFRVTkVSX1hDMjAyOCwKKwkJLnR1bmVyX2FkZHIgICAgID0gMHg2MSwKKwkJLnJh
ZGlvX2FkZHIgICAgID0gMHg2MSwKKwkJLyoKKwkJICogR1BJTyBzZXR0aW5nCisJCSAqCisJ
CSAqICAyOiBtdXRlICgwPW9mZiwxPW9uKQorCQkgKiAxMjogdHVuZXIgcmVzZXQgcGluCisJ
CSAqIDEzOiBhdWRpbyBzb3VyY2UgKDA9dHVuZXIgYXVkaW8sMT1saW5lIGluKQorCQkgKiAx
NDogRk0gKDA9b24sMT1vZmYgPz8/KQorCQkgKi8KKwkJLmlucHV0ICAgICAgICAgID0ge3sK
KwkJCS50eXBlICAgPSBDWDg4X1ZNVVhfVEVMRVZJU0lPTiwKKwkJCS52bXV4ICAgPSAwLAor
CQkJLmdwaW8wICA9IDB4MDQwMCwgICAgICAgLyogcGluIDIgPSAwICovCisJCQkuZ3BpbzEg
ID0gMHg2MDQwLCAgICAgICAvKiBwaW4gMTMgPSAwLCBwaW4gMTQgPSAxICovCisJCQkuZ3Bp
bzIgID0gMHgwMDAwLAorCQl9LCB7CisJCQkudHlwZSAgID0gQ1g4OF9WTVVYX0NPTVBPU0lU
RTEsCisJCQkudm11eCAgID0gMSwKKwkJCS5ncGlvMCAgPSAweDA0MDAsICAgICAgIC8qIHBp
biAyID0gMCAqLworCQkJLmdwaW8xICA9IDB4NjA2MCwgICAgICAgLyogcGluIDEzID0gMSwg
cGluIDE0ID0gMSAqLworCQkJLmdwaW8yICA9IDB4MDAwMCwKKwkJfSwgeworCQkJLnR5cGUg
ICA9IENYODhfVk1VWF9TVklERU8sCisJCQkudm11eCAgID0gMiwKKwkJCS5ncGlvMCAgPSAw
eDA0MDAsICAgICAgIC8qIHBpbiAyID0gMCAqLworCQkJLmdwaW8xICA9IDB4NjA2MCwgICAg
ICAgLyogcGluIDEzID0gMSwgcGluIDE0ID0gMSAqLworCQkJLmdwaW8yICA9IDB4MDAwMCwK
KwkJfSB9LAorCQkucmFkaW8gPSB7CisJCQkudHlwZSAgID0gQ1g4OF9SQURJTywKKwkJCS5n
cGlvMCAgPSAweDA0MDAsICAgICAgIC8qIHBpbiAyID0gMCAqLworCQkJLmdwaW8xICA9IDB4
NjAwMCwgICAgICAgLyogcGluIDEzID0gMCwgcGluIDE0ID0gMCAqLworCQkJLmdwaW8yICA9
IDB4MDAwMCwKKwkJfSwKKwkJLm1wZWcgICAgICAgICAgID0gQ1g4OF9NUEVHX0RWQiwKKwl9
LAogfTsKIAogLyogLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tICovCkBAIC0yMzc2LDYgKzI0MTcsMTAgQEAKIAkJ
LnN1YnZlbmRvciA9IDB4YjIwMCwKIAkJLnN1YmRldmljZSA9IDB4NDIwMCwKIAkJLmNhcmQg
ICAgICA9IENYODhfQk9BUkRfU0FUVFJBREVfU1Q0MjAwLAorCX0sIHsKKwkJLnN1YnZlbmRv
ciA9IDB4MTA3ZCwKKwkJLnN1YmRldmljZSA9IDB4NjY1NCwKKwkJLmNhcmQgICAgICA9IENY
ODhfQk9BUkRfV0lORkFTVF9EVFYxODAwSCwKIAl9LAogfTsKIApAQCAtMjU3Myw2ICsyNjE4
LDIzIEBACiAJcmV0dXJuIC1FSU5WQUw7CiB9CiAKK3N0YXRpYyBpbnQgY3g4OF94YzMwMjhf
d2luZmFzdDE4MDBoX2NhbGxiYWNrKHN0cnVjdCBjeDg4X2NvcmUgKmNvcmUsCisJCQkJCSAg
ICAgaW50IGNvbW1hbmQsIGludCBhcmcpCit7CisJc3dpdGNoIChjb21tYW5kKSB7CisJY2Fz
ZSBYQzIwMjhfVFVORVJfUkVTRVQ6CisJCS8qIEdQSU8gMTIgKHhjMzAyOCB0dW5lciByZXNl
dCkgKi8KKwkJY3hfc2V0KE1PX0dQMV9JTywgMHgxMDEwKTsKKwkJbWRlbGF5KDUwKTsKKwkJ
Y3hfY2xlYXIoTU9fR1AxX0lPLCAweDEwKTsKKwkJbWRlbGF5KDUwKTsKKwkJY3hfc2V0KE1P
X0dQMV9JTywgMHgxMCk7CisJCW1kZWxheSg1MCk7CisJCXJldHVybiAwOworCX0KKwlyZXR1
cm4gLUVJTlZBTDsKK30KKwogLyogLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSAqLwogLyogc29tZSBEaXZjbyBz
cGVjaWZpYyBzdHVmZiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAqLwogc3RhdGljIGludCBjeDg4X3B2XzgwMDBndF9jYWxsYmFjayhzdHJ1Y3QgY3g4OF9j
b3JlICpjb3JlLApAQCAtMjY0NSw2ICsyNzA3LDggQEAKIAljYXNlIENYODhfQk9BUkRfRFZJ
Q09fRlVTSU9OSERUVl9EVkJfVF9QUk86CiAJY2FzZSBDWDg4X0JPQVJEX0RWSUNPX0ZVU0lP
TkhEVFZfNV9QQ0lfTkFOTzoKIAkJcmV0dXJuIGN4ODhfZHZpY29feGMyMDI4X2NhbGxiYWNr
KGNvcmUsIGNvbW1hbmQsIGFyZyk7CisJY2FzZSBDWDg4X0JPQVJEX1dJTkZBU1RfRFRWMTgw
MEg6CisJCXJldHVybiBjeDg4X3hjMzAyOF93aW5mYXN0MTgwMGhfY2FsbGJhY2soY29yZSwg
Y29tbWFuZCwgYXJnKTsKIAl9CiAKIAlzd2l0Y2ggKGNvbW1hbmQpIHsKQEAgLTI4MTksNiAr
Mjg4MywxNiBAQAogCQljeF9zZXQoTU9fR1AwX0lPLCAweDAwMDAwMDgwKTsgLyogNzAyIG91
dCBvZiByZXNldCAqLwogCQl1ZGVsYXkoMTAwMCk7CiAJCWJyZWFrOworCisJY2FzZSBDWDg4
X0JPQVJEX1dJTkZBU1RfRFRWMTgwMEg6CisJCS8qIEdQSU8gMTIgKHhjMzAyOCB0dW5lciBy
ZXNldCkgKi8KKwkJY3hfc2V0KE1PX0dQMV9JTywgMHgxMDEwKTsKKwkJbWRlbGF5KDUwKTsK
KwkJY3hfY2xlYXIoTU9fR1AxX0lPLCAweDEwKTsKKwkJbWRlbGF5KDUwKTsKKwkJY3hfc2V0
KE1PX0dQMV9JTywgMHgxMCk7CisJCW1kZWxheSg1MCk7CisJCWJyZWFrOwogCX0KIH0KIApA
QCAtMjgzOSw2ICsyOTEzLDcgQEAKIAkJCWNvcmUtPmkyY19hbGdvLnVkZWxheSA9IDE2Owog
CQlicmVhazsKIAljYXNlIENYODhfQk9BUkRfRFZJQ09fRlVTSU9OSERUVl9EVkJfVF9QUk86
CisJY2FzZSBDWDg4X0JPQVJEX1dJTkZBU1RfRFRWMTgwMEg6CiAJCWN0bC0+ZGVtb2QgPSBY
QzMwMjhfRkVfWkFSTElOSzQ1NjsKIAkJYnJlYWs7CiAJY2FzZSBDWDg4X0JPQVJEX0tXT1JM
RF9BVFNDXzEyMDoKZGlmZiAtciAxZGNlOWQ0ZTIxNzkgbGludXgvZHJpdmVycy9tZWRpYS92
aWRlby9jeDg4L2N4ODgtZHZiLmMKLS0tIGEvbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9j
eDg4L2N4ODgtZHZiLmMJU3VuIEZlYiAwMSAxMTo0MDoyNyAyMDA5IC0wMjAwCisrKyBiL2xp
bnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8vY3g4OC9jeDg4LWR2Yi5jCVN1biBGZWIgMDEgMTU6
MjU6MzIgMjAwOSArMDEwMApAQCAtMTAxNSw2ICsxMDE1LDcgQEAKIAkJfQogCQlicmVhazsK
IAkgY2FzZSBDWDg4X0JPQVJEX1BJTk5BQ0xFX0hZQlJJRF9QQ1RWOgorCWNhc2UgQ1g4OF9C
T0FSRF9XSU5GQVNUX0RUVjE4MDBIOgogCQlmZTAtPmR2Yi5mcm9udGVuZCA9IGR2Yl9hdHRh
Y2goemwxMDM1M19hdHRhY2gsCiAJCQkJCSAgICAgICAmY3g4OF9waW5uYWNsZV9oeWJyaWRf
cGN0diwKIAkJCQkJICAgICAgICZjb3JlLT5pMmNfYWRhcCk7CmRpZmYgLXIgMWRjZTlkNGUy
MTc5IGxpbnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8vY3g4OC9jeDg4LWlucHV0LmMKLS0tIGEv
bGludXgvZHJpdmVycy9tZWRpYS92aWRlby9jeDg4L2N4ODgtaW5wdXQuYwlTdW4gRmViIDAx
IDExOjQwOjI3IDIwMDkgLTAyMDAKKysrIGIvbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9j
eDg4L2N4ODgtaW5wdXQuYwlTdW4gRmViIDAxIDE1OjI1OjMyIDIwMDkgKzAxMDAKQEAgLTkz
LDYgKzkzLDcgQEAKIAkJZ3Bpbz0oZ3BpbyAmIDB4N2ZkKSArIChhdXhncGlvICYgMHhlZik7
CiAJCWJyZWFrOwogCWNhc2UgQ1g4OF9CT0FSRF9XSU5GQVNUX0RUVjEwMDA6CisJY2FzZSBD
WDg4X0JPQVJEX1dJTkZBU1RfRFRWMTgwMEg6CiAJCWdwaW8gPSAoZ3BpbyAmIDB4NmZmKSB8
ICgoY3hfcmVhZChNT19HUDFfSU8pIDw8IDgpICYgMHg5MDApOwogCQlhdXhncGlvID0gZ3Bp
bzsKIAkJYnJlYWs7CkBAIC0yNDQsNiArMjQ1LDcgQEAKIAkJaXItPnNhbXBsaW5nID0gMTsK
IAkJYnJlYWs7CiAJY2FzZSBDWDg4X0JPQVJEX1dJTkZBU1RfRFRWMjAwMEg6CisJY2FzZSBD
WDg4X0JPQVJEX1dJTkZBU1RfRFRWMTgwMEg6CiAJCWlyX2NvZGVzID0gaXJfY29kZXNfd2lu
ZmFzdDsKIAkJaXItPmdwaW9fYWRkciA9IE1PX0dQMF9JTzsKIAkJaXItPm1hc2tfa2V5Y29k
ZSA9IDB4OGY4OwpkaWZmIC1yIDFkY2U5ZDRlMjE3OSBsaW51eC9kcml2ZXJzL21lZGlhL3Zp
ZGVvL2N4ODgvY3g4OC5oCi0tLSBhL2xpbnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8vY3g4OC9j
eDg4LmgJU3VuIEZlYiAwMSAxMTo0MDoyNyAyMDA5IC0wMjAwCisrKyBiL2xpbnV4L2RyaXZl
cnMvbWVkaWEvdmlkZW8vY3g4OC9jeDg4LmgJU3VuIEZlYiAwMSAxNToyNTozMiAyMDA5ICsw
MTAwCkBAIC0yMzIsNiArMjMyLDcgQEAKICNkZWZpbmUgQ1g4OF9CT0FSRF9TQVRUUkFERV9T
VDQyMDAgICAgICAgICA3NgogI2RlZmluZSBDWDg4X0JPQVJEX1RCU184OTEwICAgICAgICAg
ICAgICAgIDc3CiAjZGVmaW5lIENYODhfQk9BUkRfUFJPRl82MjAwICAgICAgICAgICAgICAg
NzgKKyNkZWZpbmUgQ1g4OF9CT0FSRF9XSU5GQVNUX0RUVjE4MDBIICAgICAgICA3OQogCiBl
bnVtIGN4ODhfaXR5cGUgewogCUNYODhfVk1VWF9DT01QT1NJVEUxID0gMSwK

---------=_7AC17373.74EF5A0A
Content-Type: application/octet-stream; name="leadtek_winfast_dtv2000h.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtciA0MTNmM2Q3NmViZTYgbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9jeDg4L2N4
ODgtY2FyZHMuYwotLS0gYS9saW51eC9kcml2ZXJzL21lZGlhL3ZpZGVvL2N4ODgvY3g4OC1j
YXJkcy5jCVN1biBGZWIgMDEgMTY6NTE6MDIgMjAwOSArMDEwMAorKysgYi9saW51eC9kcml2
ZXJzL21lZGlhL3ZpZGVvL2N4ODgvY3g4OC1jYXJkcy5jCVN1biBGZWIgMDEgMTY6NTM6Mjkg
MjAwOSArMDEwMApAQCAtMTI2OSw4ICsxMjY5LDggQEAKIAkJCSAuZ3BpbzAgPSAweDA3NGEs
CiAJCX0sCiAJfSwKLQlbQ1g4OF9CT0FSRF9XSU5GQVNUX0RUVjIwMDBIXSA9IHsKLQkJLm5h
bWUgICAgICAgICAgID0gIldpbkZhc3QgRFRWMjAwMCBIIiwKKwlbQ1g4OF9CT0FSRF9XSU5G
QVNUX0RUVjIwMDBIX0ldID0geworCQkubmFtZSAgICAgICAgICAgPSAiV2luRmFzdCBEVFYy
MDAwIEggKHZlci4gSSkiLAogCQkudHVuZXJfdHlwZSAgICAgPSBUVU5FUl9QSElMSVBTX0ZN
RDEyMTZNRV9NSzMsCiAJCS5yYWRpb190eXBlICAgICA9IFVOU0VULAogCQkudHVuZXJfYWRk
ciAgICAgPSBBRERSX1VOU0VULApAQCAtMTMwNiwxMSArMTMwNiwxMDAgQEAKIAkJCS5ncGlv
MyAgPSAweDAyMDAwMDAwLAogCQl9fSwKIAkJLnJhZGlvID0gewotCQkJIC50eXBlICA9IENY
ODhfUkFESU8sCi0JCQkgLmdwaW8wID0gMHgwMDAxNTcwMiwKLQkJCSAuZ3BpbzEgPSAweDAw
MDBmMjA3LAotCQkJIC5ncGlvMiA9IDB4MDAwMTU3MDIsCi0JCQkgLmdwaW8zID0gMHgwMjAw
MDAwMCwKKwkJCS50eXBlICAgPSBDWDg4X1JBRElPLAorCQkJLmdwaW8wICA9IDB4MDAwMTU3
MDIsCisJCQkuZ3BpbzEgID0gMHgwMDAwZjIwNywKKwkJCS5ncGlvMiAgPSAweDAwMDE1NzAy
LAorCQkJLmdwaW8zICA9IDB4MDIwMDAwMDAsCisJCX0sCisJCS5tcGVnICAgICAgICAgICA9
IENYODhfTVBFR19EVkIsCisJfSwKKwlbQ1g4OF9CT0FSRF9XSU5GQVNUX0RUVjIwMDBIX0pd
ID0geworCQkubmFtZSAgICAgICAgICAgPSAiV2luRmFzdCBEVFYyMDAwIEggKHZlci4gSiki
LAorCQkudHVuZXJfdHlwZSAgICAgPSBUVU5FUl9QSElMSVBTX0ZNRDEyMTZNRV9NSzMsCisJ
CS5yYWRpb190eXBlICAgICA9IFVOU0VULAorCQkudHVuZXJfYWRkciAgICAgPSBBRERSX1VO
U0VULAorCQkucmFkaW9fYWRkciAgICAgPSBBRERSX1VOU0VULAorCQkudGRhOTg4N19jb25m
ICAgPSBUREE5ODg3X1BSRVNFTlQsCisJCS5pbnB1dCAgICAgICAgICA9IHt7CisJCQkudHlw
ZSAgID0gQ1g4OF9WTVVYX1RFTEVWSVNJT04sCisJCQkudm11eCAgID0gMCwKKwkJCS5ncGlv
MCAgPSAweDAwMDEzNzA0LAorCQkJLmdwaW8xICA9IDB4MDAwMDgyMDcsCisJCQkuZ3BpbzIg
ID0gMHgwMDAxMzcwNCwKKwkJCS5ncGlvMyAgPSAweDAyMDAwMDAwLAorCQl9LCB7CisJCQku
dHlwZSAgID0gQ1g4OF9WTVVYX0NBQkxFLAorCQkJLnZtdXggICA9IDAsCisJCQkuZ3BpbzAg
ID0gMHgwMDAxYjcwMSwKKwkJCS5ncGlvMSAgPSAweDAwMDA4MjA3LAorCQkJLmdwaW8yICA9
IDB4MDAwMWI3MDEsCisJCQkuZ3BpbzMgID0gMHgwMjAwMDAwMCwKKwkJfSwgeworCQkJLnR5
cGUgICA9IENYODhfVk1VWF9DT01QT1NJVEUxLAorCQkJLnZtdXggICA9IDEsCisJCQkuZ3Bp
bzAgID0gMHgwMDAxYjcwMSwKKwkJCS5ncGlvMSAgPSAweDAwMDA4MjA3LAorCQkJLmdwaW8y
ICA9IDB4MDAwMWI3MDEsCisJCQkuZ3BpbzMgID0gMHgwMjAwMDAwMCwKKwkJfSwgeworCQkJ
LnR5cGUgICA9IENYODhfVk1VWF9TVklERU8sCisJCQkudm11eCAgID0gMiwKKwkJCS5ncGlv
MCAgPSAweDAwMDFiNzAxLAorCQkJLmdwaW8xICA9IDB4MDAwMDgyMDcsCisJCQkuZ3BpbzIg
ID0gMHgwMDAxYjcwMSwKKwkJCS5ncGlvMyAgPSAweDAyMDAwMDAwLAorCQl9IH0sCisJCS5y
YWRpbyA9IHsKKwkJCS50eXBlICAgPSBDWDg4X1JBRElPLAorCQkJLmdwaW8wICA9IDB4MDAw
MWI3MDIsCisJCQkuZ3BpbzEgID0gMHgwMDAwODIwNywKKwkJCS5ncGlvMiAgPSAweDAwMDFi
NzAyLAorCQkJLmdwaW8zICA9IDB4MDIwMDAwMDAsCisJCX0sCisJCS5tcGVnICAgICAgICAg
ICA9IENYODhfTVBFR19EVkIsCisJfSwKKwlbQ1g4OF9CT0FSRF9XSU5GQVNUX0RUVjIwMDBI
X1BMVVNdID0geworCQkubmFtZSAgICAgICAgICAgPSAiV2luRmFzdCBEVFYyMDAwIEggUExV
UyIsCisJCS50dW5lcl90eXBlICAgICA9IFRVTkVSX1hDMjAyOCwKKwkJLnJhZGlvX3R5cGUg
ICAgID0gVFVORVJfWEMyMDI4LAorCQkudHVuZXJfYWRkciAgICAgPSAweDYxLAorCQkucmFk
aW9fYWRkciAgICAgPSAweDYxLAorCQkuaW5wdXQgICAgICAgICAgPSB7eworCQkJLnR5cGUg
ICA9IENYODhfVk1VWF9URUxFVklTSU9OLAorCQkJLnZtdXggICA9IDAsCisJCQkuZ3BpbzAg
ID0gMHgwNDAzLAorCQkJLmdwaW8xICA9IDB4RjBENywKKwkJCS5ncGlvMiAgPSAweDAxMDEs
CisJCQkuZ3BpbzMgID0gMHgwMDAwLAorCQl9LCB7CisJCQkudHlwZSAgID0gQ1g4OF9WTVVY
X0NBQkxFLAorCQkJLnZtdXggICA9IDAsCisJCQkuZ3BpbzAgID0gMHgwNDAzLAorCQkJLmdw
aW8xICA9IDB4RjBENywKKwkJCS5ncGlvMiAgPSAweDAxMDAsCisJCQkuZ3BpbzMgID0gMHgw
MDAwLAorCQl9LCB7CisJCQkudHlwZSAgID0gQ1g4OF9WTVVYX0NPTVBPU0lURTEsCisJCQku
dm11eCAgID0gMSwKKwkJCS5ncGlvMCAgPSAweDA0MDcsCisJCQkuZ3BpbzEgID0gMHhGMEY3
LAorCQkJLmdwaW8yICA9IDB4MDEwMSwKKwkJCS5ncGlvMyAgPSAweDAwMDAsCisJCX0sIHsK
KwkJCS50eXBlICAgPSBDWDg4X1ZNVVhfU1ZJREVPLAorCQkJLnZtdXggICA9IDIsCisJCQku
Z3BpbzAgID0gMHgwNDA3LAorCQkJLmdwaW8xICA9IDB4RjBGNywKKwkJCS5ncGlvMiAgPSAw
eDAxMDEsCisJCQkuZ3BpbzMgID0gMHgwMDAwLAorCQl9IH0sCisJCS5yYWRpbyA9IHsKKwkJ
CS50eXBlICAgPSBDWDg4X1JBRElPLAorCQkJLmdwaW8wICA9IDB4MDQwMywKKwkJCS5ncGlv
MSAgPSAweEYwOTcsCisJCQkuZ3BpbzIgID0gMHgwMTAwLAorCQkJLmdwaW8zICA9IDB4MDAw
MCwKIAkJfSwKIAkJLm1wZWcgICAgICAgICAgID0gQ1g4OF9NUEVHX0RWQiwKIAl9LApAQCAt
MjI1OSw3ICsyMzQ4LDE1IEBACiAJfSx7CiAJCS5zdWJ2ZW5kb3IgPSAweDEwN2QsCiAJCS5z
dWJkZXZpY2UgPSAweDY2NWUsCi0JCS5jYXJkICAgICAgPSBDWDg4X0JPQVJEX1dJTkZBU1Rf
RFRWMjAwMEgsCisJCS5jYXJkICAgICAgPSBDWDg4X0JPQVJEX1dJTkZBU1RfRFRWMjAwMEhf
SSwKKwl9LCB7CisJCS5zdWJ2ZW5kb3IgPSAweDEwN2QsCisJCS5zdWJkZXZpY2UgPSAweDZm
MmIsCisJCS5jYXJkICAgICAgPSBDWDg4X0JPQVJEX1dJTkZBU1RfRFRWMjAwMEhfSiwKKwl9
LCB7CisJCS5zdWJ2ZW5kb3IgPSAweDEwN2QsCisJCS5zdWJkZXZpY2UgPSAweDZmNDIsCisJ
CS5jYXJkICAgICAgPSBDWDg4X0JPQVJEX1dJTkZBU1RfRFRWMjAwMEhfUExVUywKIAl9LHsK
IAkJLnN1YnZlbmRvciA9IDB4MThhYywKIAkJLnN1YmRldmljZSA9IDB4ZDgwMCwgLyogRnVz
aW9uSERUViAzIEdvbGQgKG9yaWdpbmFsIHJldmlzaW9uKSAqLwpAQCAtMjcwOCw2ICsyODA1
LDcgQEAKIAljYXNlIENYODhfQk9BUkRfRFZJQ09fRlVTSU9OSERUVl81X1BDSV9OQU5POgog
CQlyZXR1cm4gY3g4OF9kdmljb194YzIwMjhfY2FsbGJhY2soY29yZSwgY29tbWFuZCwgYXJn
KTsKIAljYXNlIENYODhfQk9BUkRfV0lORkFTVF9EVFYxODAwSDoKKwljYXNlIENYODhfQk9B
UkRfV0lORkFTVF9EVFYyMDAwSF9QTFVTOgogCQlyZXR1cm4gY3g4OF94YzMwMjhfd2luZmFz
dDE4MDBoX2NhbGxiYWNrKGNvcmUsIGNvbW1hbmQsIGFyZyk7CiAJfQogCkBAIC0yODg1LDYg
KzI5ODMsNyBAQAogCQlicmVhazsKIAogCWNhc2UgQ1g4OF9CT0FSRF9XSU5GQVNUX0RUVjE4
MDBIOgorCWNhc2UgQ1g4OF9CT0FSRF9XSU5GQVNUX0RUVjIwMDBIX1BMVVM6CiAJCS8qIEdQ
SU8gMTIgKHhjMzAyOCB0dW5lciByZXNldCkgKi8KIAkJY3hfc2V0KE1PX0dQMV9JTywgMHgx
MDEwKTsKIAkJbWRlbGF5KDUwKTsKQEAgLTI5MTQsNiArMzAxMyw3IEBACiAJCWJyZWFrOwog
CWNhc2UgQ1g4OF9CT0FSRF9EVklDT19GVVNJT05IRFRWX0RWQl9UX1BSTzoKIAljYXNlIENY
ODhfQk9BUkRfV0lORkFTVF9EVFYxODAwSDoKKwljYXNlIENYODhfQk9BUkRfV0lORkFTVF9E
VFYyMDAwSF9QTFVTOgogCQljdGwtPmRlbW9kID0gWEMzMDI4X0ZFX1pBUkxJTks0NTY7CiAJ
CWJyZWFrOwogCWNhc2UgQ1g4OF9CT0FSRF9LV09STERfQVRTQ18xMjA6CmRpZmYgLXIgNDEz
ZjNkNzZlYmU2IGxpbnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8vY3g4OC9jeDg4LWR2Yi5jCi0t
LSBhL2xpbnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8vY3g4OC9jeDg4LWR2Yi5jCVN1biBGZWIg
MDEgMTY6NTE6MDIgMjAwOSArMDEwMAorKysgYi9saW51eC9kcml2ZXJzL21lZGlhL3ZpZGVv
L2N4ODgvY3g4OC1kdmIuYwlTdW4gRmViIDAxIDE2OjUzOjI5IDIwMDkgKzAxMDAKQEAgLTY5
NSw3ICs2OTUsOCBAQAogCQkJCWdvdG8gZnJvbnRlbmRfZGV0YWNoOwogCQl9CiAJCWJyZWFr
OwotCWNhc2UgQ1g4OF9CT0FSRF9XSU5GQVNUX0RUVjIwMDBIOgorCWNhc2UgQ1g4OF9CT0FS
RF9XSU5GQVNUX0RUVjIwMDBIX0k6CisJY2FzZSBDWDg4X0JPQVJEX1dJTkZBU1RfRFRWMjAw
MEhfSjoKIAljYXNlIENYODhfQk9BUkRfSEFVUFBBVUdFX0hWUjExMDA6CiAJY2FzZSBDWDg4
X0JPQVJEX0hBVVBQQVVHRV9IVlIxMTAwTFA6CiAJY2FzZSBDWDg4X0JPQVJEX0hBVVBQQVVH
RV9IVlIxMzAwOgpAQCAtMTAxNiw2ICsxMDE3LDcgQEAKIAkJYnJlYWs7CiAJIGNhc2UgQ1g4
OF9CT0FSRF9QSU5OQUNMRV9IWUJSSURfUENUVjoKIAljYXNlIENYODhfQk9BUkRfV0lORkFT
VF9EVFYxODAwSDoKKwljYXNlIENYODhfQk9BUkRfV0lORkFTVF9EVFYyMDAwSF9QTFVTOgog
CQlmZTAtPmR2Yi5mcm9udGVuZCA9IGR2Yl9hdHRhY2goemwxMDM1M19hdHRhY2gsCiAJCQkJ
CSAgICAgICAmY3g4OF9waW5uYWNsZV9oeWJyaWRfcGN0diwKIAkJCQkJICAgICAgICZjb3Jl
LT5pMmNfYWRhcCk7CmRpZmYgLXIgNDEzZjNkNzZlYmU2IGxpbnV4L2RyaXZlcnMvbWVkaWEv
dmlkZW8vY3g4OC9jeDg4LWlucHV0LmMKLS0tIGEvbGludXgvZHJpdmVycy9tZWRpYS92aWRl
by9jeDg4L2N4ODgtaW5wdXQuYwlTdW4gRmViIDAxIDE2OjUxOjAyIDIwMDkgKzAxMDAKKysr
IGIvbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9jeDg4L2N4ODgtaW5wdXQuYwlTdW4gRmVi
IDAxIDE2OjUzOjI5IDIwMDkgKzAxMDAKQEAgLTk0LDYgKzk0LDkgQEAKIAkJYnJlYWs7CiAJ
Y2FzZSBDWDg4X0JPQVJEX1dJTkZBU1RfRFRWMTAwMDoKIAljYXNlIENYODhfQk9BUkRfV0lO
RkFTVF9EVFYxODAwSDoKKwljYXNlIENYODhfQk9BUkRfV0lORkFTVF9EVFYyMDAwSF9JOgor
CWNhc2UgQ1g4OF9CT0FSRF9XSU5GQVNUX0RUVjIwMDBIX0o6CisJY2FzZSBDWDg4X0JPQVJE
X1dJTkZBU1RfRFRWMjAwMEhfUExVUzoKIAkJZ3BpbyA9IChncGlvICYgMHg2ZmYpIHwgKChj
eF9yZWFkKE1PX0dQMV9JTykgPDwgOCkgJiAweDkwMCk7CiAJCWF1eGdwaW8gPSBncGlvOwog
CQlicmVhazsKQEAgLTI0NCw4ICsyNDcsMTAgQEAKIAkJaXJfdHlwZSA9IElSX1RZUEVfUkM1
OwogCQlpci0+c2FtcGxpbmcgPSAxOwogCQlicmVhazsKLQljYXNlIENYODhfQk9BUkRfV0lO
RkFTVF9EVFYyMDAwSDoKIAljYXNlIENYODhfQk9BUkRfV0lORkFTVF9EVFYxODAwSDoKKwlj
YXNlIENYODhfQk9BUkRfV0lORkFTVF9EVFYyMDAwSF9JOgorCWNhc2UgQ1g4OF9CT0FSRF9X
SU5GQVNUX0RUVjIwMDBIX0o6CisJY2FzZSBDWDg4X0JPQVJEX1dJTkZBU1RfRFRWMjAwMEhf
UExVUzoKIAkJaXJfY29kZXMgPSBpcl9jb2Rlc193aW5mYXN0OwogCQlpci0+Z3Bpb19hZGRy
ID0gTU9fR1AwX0lPOwogCQlpci0+bWFza19rZXljb2RlID0gMHg4Zjg7CmRpZmYgLXIgNDEz
ZjNkNzZlYmU2IGxpbnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8vY3g4OC9jeDg4LmgKLS0tIGEv
bGludXgvZHJpdmVycy9tZWRpYS92aWRlby9jeDg4L2N4ODguaAlTdW4gRmViIDAxIDE2OjUx
OjAyIDIwMDkgKzAxMDAKKysrIGIvbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9jeDg4L2N4
ODguaAlTdW4gRmViIDAxIDE2OjUzOjI5IDIwMDkgKzAxMDAKQEAgLTIwNCw3ICsyMDQsNyBA
QAogI2RlZmluZSBDWDg4X0JPQVJEX0tXT1JMRF9NQ0UyMDBfREVMVVhFICAgIDQ4CiAjZGVm
aW5lIENYODhfQk9BUkRfUElYRUxWSUVXX1BMQVlUVl9QNzAwMCAgNDkKICNkZWZpbmUgQ1g4
OF9CT0FSRF9OUEdURUNIX1JFQUxUVl9UT1AxMEZNICA1MAotI2RlZmluZSBDWDg4X0JPQVJE
X1dJTkZBU1RfRFRWMjAwMEggICAgICAgIDUxCisjZGVmaW5lIENYODhfQk9BUkRfV0lORkFT
VF9EVFYyMDAwSF9JICAgICAgNTEKICNkZWZpbmUgQ1g4OF9CT0FSRF9HRU5JQVRFQ0hfRFZC
UyAgICAgICAgICA1MgogI2RlZmluZSBDWDg4X0JPQVJEX0hBVVBQQVVHRV9IVlIzMDAwICAg
ICAgIDUzCiAjZGVmaW5lIENYODhfQk9BUkRfTk9SV09PRF9NSUNSTyAgICAgICAgICAgNTQK
QEAgLTIzMyw2ICsyMzMsOCBAQAogI2RlZmluZSBDWDg4X0JPQVJEX1RCU184OTEwICAgICAg
ICAgICAgICAgIDc3CiAjZGVmaW5lIENYODhfQk9BUkRfUFJPRl82MjAwICAgICAgICAgICAg
ICAgNzgKICNkZWZpbmUgQ1g4OF9CT0FSRF9XSU5GQVNUX0RUVjE4MDBIICAgICAgICA3OQor
I2RlZmluZSBDWDg4X0JPQVJEX1dJTkZBU1RfRFRWMjAwMEhfSiAgICAgIDgwCisjZGVmaW5l
IENYODhfQk9BUkRfV0lORkFTVF9EVFYyMDAwSF9QTFVTICAgODEKIAogZW51bSBjeDg4X2l0
eXBlIHsKIAlDWDg4X1ZNVVhfQ09NUE9TSVRFMSA9IDEsCn==

---------=_7AC17373.74EF5A0A--
