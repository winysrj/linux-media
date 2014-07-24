Return-path: <linux-media-owner@vger.kernel.org>
Received: from 219-87-157-213.static.tfn.net.tw ([219.87.157.213]:48351 "EHLO
	ironport.ite.com.tw" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755259AbaGXJln (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Jul 2014 05:41:43 -0400
Received: from tpecas.internal.ite.com.tw (tpemail2.internal.ite.com.tw [192.168.15.42])
	by mse.ite.com.tw with ESMTP id s6O9VAXc031282
	for <linux-media@vger.kernel.org>; Thu, 24 Jul 2014 17:31:10 +0800 (CST)
	(envelope-from Bimow.Chen@ite.com.tw)
From: <Bimow.Chen@ite.com.tw>
To: <linux-media@vger.kernel.org>
CC: <Jason.Dong@ite.com.tw>
Subject: [PATCH] V4L/DVB: dvb-usb-v2: Update firmware and driver for
 performance of ITEtech IT9135
Date: Thu, 24 Jul 2014 09:31:08 +0000
Message-ID: <FA28ACF9E7378C4E836BE776152E0E253AF5B80A@TPEMAIL2.internal.ite.com.tw>
Content-Language: zh-TW
Content-Type: multipart/mixed;
	boundary="_002_FA28ACF9E7378C4E836BE776152E0E253AF5B80ATPEMAIL2interna_"
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--_002_FA28ACF9E7378C4E836BE776152E0E253AF5B80ATPEMAIL2interna_
Content-Type: text/plain; charset="big5"
Content-Transfer-Encoding: base64

Rml4IHBlcmZvcm1hbmNlIGlzc3VlIG9mIElUOTEzNSBBWCBhbmQgQlggY2hpcCB2ZXJzaW9ucy4N
Cg==

--_002_FA28ACF9E7378C4E836BE776152E0E253AF5B80ATPEMAIL2interna_
Content-Type: application/octet-stream;
	name="0001-Update-firmware-and-driver-for-performance-of-ITEtec.patch"
Content-Description: 0001-Update-firmware-and-driver-for-performance-of-ITEtec.patch
Content-Disposition: attachment;
	filename="0001-Update-firmware-and-driver-for-performance-of-ITEtec.patch";
	size=6906; creation-date="Thu, 24 Jul 2014 07:15:35 GMT";
	modification-date="Thu, 24 Jul 2014 05:41:44 GMT"
Content-Transfer-Encoding: base64

RnJvbSA1N2ZlMTAyNDE5ZTgzZTczMDgwYWYxNWNjM2FkM2ZlMjQxZDdmOGI0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBCaW1vdyBDaGVuIDxCaW1vdy5DaGVuQGl0ZS5jb20udHc+CkRh
dGU6IFRodSwgMjQgSnVsIDIwMTQgMTM6MjM6MzkgKzA4MDAKU3ViamVjdDogW1BBVENIIDEvMV0g
VXBkYXRlIGZpcm13YXJlIGFuZCBkcml2ZXIgZm9yIHBlcmZvcm1hbmNlIG9mIElURXRlY2ggSVQ5
MTM1CgpGaXggcGVyZm9ybWFuY2UgaXNzdWUgb2YgSVQ5MTM1IEFYIGFuZCBCWCBjaGlwIHZlcnNp
b25zLgoKU2lnbmVkLW9mZi1ieTogQmltb3cgQ2hlbiA8Ymltb3cuY2hlbkBpdGUuY29tLnR3PgpT
aWduZWQtb2ZmLWJ5OiBCaW1vdyBDaGVuIDxCaW1vdy5DaGVuQGl0ZS5jb20udHc+Ci0tLQogRG9j
dW1lbnRhdGlvbi9kdmIvZ2V0X2R2Yl9maXJtd2FyZSAgICAgICAgfCAgIDI0ICsrKysrKysrKysr
KystLS0tLS0tLS0tLQogZHJpdmVycy9tZWRpYS9kdmItZnJvbnRlbmRzL2FmOTAzMy5jICAgICAg
fCAgIDE4ICsrKysrKysrKysrKysrKysrKwogZHJpdmVycy9tZWRpYS9kdmItZnJvbnRlbmRzL2Fm
OTAzM19wcml2LmggfCAgIDIwICsrKysrKysrKy0tLS0tLS0tLS0tCiBkcml2ZXJzL21lZGlhL3R1
bmVycy90dW5lcl9pdDkxM3guYyAgICAgICB8ICAgIDYgLS0tLS0tCiBkcml2ZXJzL21lZGlhL3Vz
Yi9kdmItdXNiLXYyL2FmOTAzNS5jICAgICB8ICAgMTEgKysrKysrKysrKysKIDUgZmlsZXMgY2hh
bmdlZCwgNTEgaW5zZXJ0aW9ucygrKSwgMjggZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvRG9j
dW1lbnRhdGlvbi9kdmIvZ2V0X2R2Yl9maXJtd2FyZSBiL0RvY3VtZW50YXRpb24vZHZiL2dldF9k
dmJfZmlybXdhcmUKaW5kZXggZDkxYjhiZS4uZWZhMTAwYSAxMDA3NTUKLS0tIGEvRG9jdW1lbnRh
dGlvbi9kdmIvZ2V0X2R2Yl9maXJtd2FyZQorKysgYi9Eb2N1bWVudGF0aW9uL2R2Yi9nZXRfZHZi
X2Zpcm13YXJlCkBAIC03MDgsMjMgKzcwOCwyNSBAQCBzdWIgZHJ4a190ZXJyYXRlY19odGNfc3Rp
Y2sgewogfQogCiBzdWIgaXQ5MTM1IHsKLQlteSAkc291cmNlZmlsZSA9ICJkdmItdXNiLWl0OTEz
NS56aXAiOwotCW15ICR1cmwgPSAiaHR0cDovL3d3dy5pdGUuY29tLnR3L3VwbG9hZHMvZmlybXdh
cmUvdjMuNi4wLjAvJHNvdXJjZWZpbGUiOwotCW15ICRoYXNoID0gIjFlNTVmNmM4ODMzZjFkMGFl
MDY3YzJiYjI5NTNlNmE5IjsKLQlteSAkdG1wZGlyID0gdGVtcGRpcihESVIgPT4gIi90bXAiLCBD
TEVBTlVQID0+IDApOwotCW15ICRvdXRmaWxlID0gImR2Yi11c2ItaXQ5MTM1LmZ3IjsKKwlteSAk
dXJsID0gImh0dHA6Ly93d3cuaXRlLmNvbS50dy91cGxvYWRzL2Zpcm13YXJlL3YzLjI1LjAuMC8i
OworCW15ICRmaWxlMSA9ICJkdmItdXNiLWl0OTEzNS0wMS56aXAiOwogCW15ICRmd2ZpbGUxID0g
ImR2Yi11c2ItaXQ5MTM1LTAxLmZ3IjsKKwlteSAkaGFzaDEgPSAiMDJmY2YxMTE3NGVkYTg0NzQ1
ZGFlN2U2MWM1ZmY5YmEiOworCW15ICRmaWxlMiA9ICJkdmItdXNiLWl0OTEzNS0wMi56aXAiOwog
CW15ICRmd2ZpbGUyID0gImR2Yi11c2ItaXQ5MTM1LTAyLmZ3IjsKKwlteSAkaGFzaDIgPSAiZDVl
MTQzN2RjMjQzNTg1NzhlMDc5OTk0NzVkNGNhYzkiOwogCiAJY2hlY2tzdGFuZGFyZCgpOwogCi0J
d2dldGZpbGUoJHNvdXJjZWZpbGUsICR1cmwpOwotCXVuemlwKCRzb3VyY2VmaWxlLCAkdG1wZGly
KTsKLQl2ZXJpZnkoIiR0bXBkaXIvJG91dGZpbGUiLCAkaGFzaCk7Ci0JZXh0cmFjdCgiJHRtcGRp
ci8kb3V0ZmlsZSIsIDY0LCA4MTI4LCAiJGZ3ZmlsZTEiKTsKLQlleHRyYWN0KCIkdG1wZGlyLyRv
dXRmaWxlIiwgMTI4NjYsIDU4MTcsICIkZndmaWxlMiIpOworCXdnZXRmaWxlKCRmaWxlMSwgJHVy
bCAuICRmaWxlMSk7CisJdW56aXAoJGZpbGUxLCAiIik7CisJdmVyaWZ5KCIkZndmaWxlMSIsICRo
YXNoMSk7CisKKwl3Z2V0ZmlsZSgkZmlsZTIsICR1cmwgLiAkZmlsZTIpOworCXVuemlwKCRmaWxl
MiwgIiIpOworCXZlcmlmeSgiJGZ3ZmlsZTIiLCAkaGFzaDIpOwogCi0JIiRmd2ZpbGUxICRmd2Zp
bGUyIgorCSIkZmlsZTEgJGZpbGUyIgogfQogCiBzdWIgdGRhMTAwNzEgewpkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9tZWRpYS9kdmItZnJvbnRlbmRzL2FmOTAzMy5jIGIvZHJpdmVycy9tZWRpYS9kdmIt
ZnJvbnRlbmRzL2FmOTAzMy5jCmluZGV4IGJlNGJlYzIuLmU5NmU2NTUgMTAwNjQ0Ci0tLSBhL2Ry
aXZlcnMvbWVkaWEvZHZiLWZyb250ZW5kcy9hZjkwMzMuYworKysgYi9kcml2ZXJzL21lZGlhL2R2
Yi1mcm9udGVuZHMvYWY5MDMzLmMKQEAgLTI3NCw2ICsyNzQsMjIgQEAgc3RhdGljIGludCBhZjkw
MzNfaW5pdChzdHJ1Y3QgZHZiX2Zyb250ZW5kICpmZSkKIAkJeyAweDgwMDA0NSwgc3RhdGUtPmNm
Zy5hZGNfbXVsdGlwbGllciwgMHhmZiB9LAogCX07CiAKKwkvKiBwb3dlciB1cCB0dW5lciAtIGZv
ciBwZXJmb3JtYW5jZSAqLworCXN3aXRjaCAoc3RhdGUtPmNmZy50dW5lcikgeworCWNhc2UgQUY5
MDMzX1RVTkVSX0lUOTEzNV8zODoKKwljYXNlIEFGOTAzM19UVU5FUl9JVDkxMzVfNTE6CisJY2Fz
ZSBBRjkwMzNfVFVORVJfSVQ5MTM1XzUyOgorCWNhc2UgQUY5MDMzX1RVTkVSX0lUOTEzNV82MDoK
KwljYXNlIEFGOTAzM19UVU5FUl9JVDkxMzVfNjE6CisJY2FzZSBBRjkwMzNfVFVORVJfSVQ5MTM1
XzYyOgorCQlyZXQgPSBhZjkwMzNfd3JfcmVnKHN0YXRlLCAweDgwZWM0MCwgMHgxKTsKKwkJcmV0
IHw9IGFmOTAzM193cl9yZWcoc3RhdGUsIDB4ODBmYmE4LCAweDApOworCQlyZXQgfD0gYWY5MDMz
X3dyX3JlZyhzdGF0ZSwgMHg4MGVjNTcsIDB4MCk7CisJCXJldCB8PSBhZjkwMzNfd3JfcmVnKHN0
YXRlLCAweDgwZWM1OCwgMHgwKTsKKwkJaWYgKHJldCA8IDApCisJCQlnb3RvIGVycjsKKwl9CisK
IAkvKiBwcm9ncmFtIGNsb2NrIGNvbnRyb2wgKi8KIAljbG9ja19jdyA9IGFmOTAzM19kaXYoc3Rh
dGUsIHN0YXRlLT5jZmcuY2xvY2ssIDEwMDAwMDB1bCwgMTl1bCk7CiAJYnVmWzBdID0gKGNsb2Nr
X2N3ID4+ICAwKSAmIDB4ZmY7CkBAIC00NDAsNiArNDU2LDggQEAgc3RhdGljIGludCBhZjkwMzNf
aW5pdChzdHJ1Y3QgZHZiX2Zyb250ZW5kICpmZSkKIAljYXNlIEFGOTAzM19UVU5FUl9JVDkxMzVf
NjE6CiAJY2FzZSBBRjkwMzNfVFVORVJfSVQ5MTM1XzYyOgogCQlyZXQgPSBhZjkwMzNfd3JfcmVn
KHN0YXRlLCAweDgwMDAwMCwgMHgwMSk7CisJCXJldCB8PSBhZjkwMzNfd3JfcmVnKHN0YXRlLCAw
eDAwZDgyNywgMHgwMCk7CisJCXJldCB8PSBhZjkwMzNfd3JfcmVnKHN0YXRlLCAweDAwZDgyOSwg
MHgwMCk7CiAJCWlmIChyZXQgPCAwKQogCQkJZ290byBlcnI7CiAJfQpkaWZmIC0tZ2l0IGEvZHJp
dmVycy9tZWRpYS9kdmItZnJvbnRlbmRzL2FmOTAzM19wcml2LmggYi9kcml2ZXJzL21lZGlhL2R2
Yi1mcm9udGVuZHMvYWY5MDMzX3ByaXYuaAppbmRleCBmYzJhZDU4Li5kZWQ3YjY3IDEwMDY0NAot
LS0gYS9kcml2ZXJzL21lZGlhL2R2Yi1mcm9udGVuZHMvYWY5MDMzX3ByaXYuaAorKysgYi9kcml2
ZXJzL21lZGlhL2R2Yi1mcm9udGVuZHMvYWY5MDMzX3ByaXYuaApAQCAtMTQxOCw3ICsxNDE4LDcg
QEAgc3RhdGljIGNvbnN0IHN0cnVjdCByZWdfdmFsIHR1bmVyX2luaXRfaXQ5MTM1XzYwW10gPSB7
CiAJeyAweDgwMDA2OCwgMHgwYSB9LAogCXsgMHg4MDAwNmEsIDB4MDMgfSwKIAl7IDB4ODAwMDcw
LCAweDBhIH0sCi0JeyAweDgwMDA3MSwgMHgwNSB9LAorCXsgMHg4MDAwNzEsIDB4MGEgfSwKIAl7
IDB4ODAwMDcyLCAweDAyIH0sCiAJeyAweDgwMDA3NSwgMHg4YyB9LAogCXsgMHg4MDAwNzYsIDB4
OGMgfSwKQEAgLTE0ODQsNyArMTQ4NCw2IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgcmVnX3ZhbCB0
dW5lcl9pbml0X2l0OTEzNV82MFtdID0gewogCXsgMHg4MDAxMDQsIDB4MDIgfSwKIAl7IDB4ODAw
MTA1LCAweGJlIH0sCiAJeyAweDgwMDEwNiwgMHgwMCB9LAotCXsgMHg4MDAxMDksIDB4MDIgfSwK
IAl7IDB4ODAwMTE1LCAweDBhIH0sCiAJeyAweDgwMDExNiwgMHgwMyB9LAogCXsgMHg4MDAxMWEs
IDB4YmUgfSwKQEAgLTE1MTAsNyArMTUwOSw2IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgcmVnX3Zh
bCB0dW5lcl9pbml0X2l0OTEzNV82MFtdID0gewogCXsgMHg4MDAxNGIsIDB4OGMgfSwKIAl7IDB4
ODAwMTRkLCAweGFjIH0sCiAJeyAweDgwMDE0ZSwgMHhjNiB9LAotCXsgMHg4MDAxNGYsIDB4MDMg
fSwKIAl7IDB4ODAwMTUxLCAweDFlIH0sCiAJeyAweDgwMDE1MywgMHhiYyB9LAogCXsgMHg4MDAx
NzgsIDB4MDkgfSwKQEAgLTE1MjIsOSArMTUyMCwxMCBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IHJl
Z192YWwgdHVuZXJfaW5pdF9pdDkxMzVfNjBbXSA9IHsKIAl7IDB4ODAwMThkLCAweDVmIH0sCiAJ
eyAweDgwMDE4ZiwgMHhhMCB9LAogCXsgMHg4MDAxOTAsIDB4NWEgfSwKLQl7IDB4ODBlZDAyLCAw
eGZmIH0sCi0JeyAweDgwZWU0MiwgMHhmZiB9LAotCXsgMHg4MGVlODIsIDB4ZmYgfSwKKwl7IDB4
ODAwMTkxLCAweDAwIH0sCisJeyAweDgwZWQwMiwgMHg0MCB9LAorCXsgMHg4MGVlNDIsIDB4NDAg
fSwKKwl7IDB4ODBlZTgyLCAweDQwIH0sCiAJeyAweDgwZjAwMCwgMHgwZiB9LAogCXsgMHg4MGYw
MWYsIDB4OGMgfSwKIAl7IDB4ODBmMDIwLCAweDAwIH0sCkBAIC0xNjk5LDcgKzE2OTgsNiBAQCBz
dGF0aWMgY29uc3Qgc3RydWN0IHJlZ192YWwgdHVuZXJfaW5pdF9pdDkxMzVfNjFbXSA9IHsKIAl7
IDB4ODAwMTA0LCAweDAyIH0sCiAJeyAweDgwMDEwNSwgMHhjOCB9LAogCXsgMHg4MDAxMDYsIDB4
MDAgfSwKLQl7IDB4ODAwMTA5LCAweDAyIH0sCiAJeyAweDgwMDExNSwgMHgwYSB9LAogCXsgMHg4
MDAxMTYsIDB4MDMgfSwKIAl7IDB4ODAwMTFhLCAweGM2IH0sCkBAIC0xNzI1LDcgKzE3MjMsNiBA
QCBzdGF0aWMgY29uc3Qgc3RydWN0IHJlZ192YWwgdHVuZXJfaW5pdF9pdDkxMzVfNjFbXSA9IHsK
IAl7IDB4ODAwMTRiLCAweDhjIH0sCiAJeyAweDgwMDE0ZCwgMHhhOCB9LAogCXsgMHg4MDAxNGUs
IDB4YzYgfSwKLQl7IDB4ODAwMTRmLCAweDAzIH0sCiAJeyAweDgwMDE1MSwgMHgyOCB9LAogCXsg
MHg4MDAxNTMsIDB4Y2MgfSwKIAl7IDB4ODAwMTc4LCAweDA5IH0sCkBAIC0xNzM3LDkgKzE3MzQs
MTAgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCByZWdfdmFsIHR1bmVyX2luaXRfaXQ5MTM1XzYxW10g
PSB7CiAJeyAweDgwMDE4ZCwgMHg1ZiB9LAogCXsgMHg4MDAxOGYsIDB4ZmIgfSwKIAl7IDB4ODAw
MTkwLCAweDVjIH0sCi0JeyAweDgwZWQwMiwgMHhmZiB9LAotCXsgMHg4MGVlNDIsIDB4ZmYgfSwK
LQl7IDB4ODBlZTgyLCAweGZmIH0sCisJeyAweDgwMDE5MSwgMHgwMCB9LAorCXsgMHg4MGVkMDIs
IDB4NDAgfSwKKwl7IDB4ODBlZTQyLCAweDQwIH0sCisJeyAweDgwZWU4MiwgMHg0MCB9LAogCXsg
MHg4MGYwMDAsIDB4MGYgfSwKIAl7IDB4ODBmMDFmLCAweDhjIH0sCiAJeyAweDgwZjAyMCwgMHgw
MCB9LApkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZWRpYS90dW5lcnMvdHVuZXJfaXQ5MTN4LmMgYi9k
cml2ZXJzL21lZGlhL3R1bmVycy90dW5lcl9pdDkxM3guYwppbmRleCA2ZjMwZDdlLi5lYjdlNTg4
IDEwMDY0NAotLS0gYS9kcml2ZXJzL21lZGlhL3R1bmVycy90dW5lcl9pdDkxM3guYworKysgYi9k
cml2ZXJzL21lZGlhL3R1bmVycy90dW5lcl9pdDkxM3guYwpAQCAtMjAwLDEyICsyMDAsNiBAQCBz
dGF0aWMgaW50IGl0OTEzeF9pbml0KHN0cnVjdCBkdmJfZnJvbnRlbmQgKmZlKQogCQl9CiAJfQog
Ci0JLyogUG93ZXIgVXAgVHVuZXIgLSBjb21tb24gYWxsIHZlcnNpb25zICovCi0JcmV0ID0gaXQ5
MTN4X3dyX3JlZyhzdGF0ZSwgUFJPX0RNT0QsIDB4ZWM0MCwgMHgxKTsKLQlyZXQgfD0gaXQ5MTN4
X3dyX3JlZyhzdGF0ZSwgUFJPX0RNT0QsIDB4ZmJhOCwgMHgwKTsKLQlyZXQgfD0gaXQ5MTN4X3dy
X3JlZyhzdGF0ZSwgUFJPX0RNT0QsIDB4ZWM1NywgMHgwKTsKLQlyZXQgfD0gaXQ5MTN4X3dyX3Jl
ZyhzdGF0ZSwgUFJPX0RNT0QsIDB4ZWM1OCwgMHgwKTsKLQogCXJldHVybiBpdDkxM3hfd3JfcmVn
KHN0YXRlLCBQUk9fRE1PRCwgMHhlZDgxLCB2YWwpOwogfQogCmRpZmYgLS1naXQgYS9kcml2ZXJz
L21lZGlhL3VzYi9kdmItdXNiLXYyL2FmOTAzNS5jIGIvZHJpdmVycy9tZWRpYS91c2IvZHZiLXVz
Yi12Mi9hZjkwMzUuYwppbmRleCA3YjliNzVmLi4zZTIxMmFlIDEwMDY0NAotLS0gYS9kcml2ZXJz
L21lZGlhL3VzYi9kdmItdXNiLXYyL2FmOTAzNS5jCisrKyBiL2RyaXZlcnMvbWVkaWEvdXNiL2R2
Yi11c2ItdjIvYWY5MDM1LmMKQEAgLTYwMiw2ICs2MDIsOCBAQCBzdGF0aWMgaW50IGFmOTAzNV9k
b3dubG9hZF9maXJtd2FyZShzdHJ1Y3QgZHZiX3VzYl9kZXZpY2UgKmQsCiAJaWYgKHJldCA8IDAp
CiAJCWdvdG8gZXJyOwogCisJbXNsZWVwKDMwKTsKKwogCS8qIGZpcm13YXJlIGxvYWRlZCwgcmVx
dWVzdCBib290ICovCiAJcmVxLmNtZCA9IENNRF9GV19CT09UOwogCXJldCA9IGFmOTAzNV9jdHJs
X21zZyhkLCAmcmVxKTsKQEAgLTYyMSw2ICs2MjMsMTUgQEAgc3RhdGljIGludCBhZjkwMzVfZG93
bmxvYWRfZmlybXdhcmUoc3RydWN0IGR2Yl91c2JfZGV2aWNlICpkLAogCQlnb3RvIGVycjsKIAl9
CiAKKwkvKiB0dW5lciBSRiBpbml0aWFsICovCisJaWYgKHN0YXRlLT5jaGlwX3R5cGUgPT0gMHg5
MTM1KSB7CisJCXJldCA9IGFmOTAzNV93cl9yZWcoZCwgMHg4MGVjNGMsIDB4NjgpOworCQlpZiAo
cmV0IDwgMCkKKwkJCWdvdG8gZXJyOworCisJCW1zbGVlcCgzMCk7CisJfQorCiAJZGV2X2luZm8o
JmQtPnVkZXYtPmRldiwgIiVzOiBmaXJtd2FyZSB2ZXJzaW9uPSVkLiVkLiVkLiVkIiwKIAkJCUtC
VUlMRF9NT0ROQU1FLCByYnVmWzBdLCByYnVmWzFdLCByYnVmWzJdLCByYnVmWzNdKTsKIAotLSAK
MS43LjAuNAoK

--_002_FA28ACF9E7378C4E836BE776152E0E253AF5B80ATPEMAIL2interna_--
