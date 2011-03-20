Return-path: <mchehab@pedra>
Received: from tur.go2.pl ([193.17.41.50]:50414 "EHLO tur.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390Ab1CTTdw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Mar 2011 15:33:52 -0400
Received: from moh1-ve3.go2.pl (moh1-ve3.go2.pl [193.17.41.134])
	by tur.go2.pl (o2.pl Mailer 2.0.1) with ESMTP id ABC9C230F2A
	for <linux-media@vger.kernel.org>; Sun, 20 Mar 2011 20:33:48 +0100 (CET)
Received: from moh1-ve3.go2.pl (unknown [10.0.0.134])
	by moh1-ve3.go2.pl (Postfix) with ESMTP id 283DB6645DC
	for <linux-media@vger.kernel.org>; Sun, 20 Mar 2011 20:33:00 +0100 (CET)
Received: from unknown (unknown [10.0.0.74])
	by moh1-ve3.go2.pl (Postfix) with SMTP
	for <linux-media@vger.kernel.org>; Sun, 20 Mar 2011 20:33:00 +0100 (CET)
Message-ID: <4D86566B.9090803@tlen.pl>
Date: Sun, 20 Mar 2011 20:32:59 +0100
From: Wojciech Myrda <vojcek@tlen.pl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Prof_Revolution_DVB-S2_8000_PCI-E & Linux Kernel 2.6.38-rc8-next-20110314
Content-Type: multipart/mixed;
 boundary="------------040301080001080902060300"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a multi-part message in MIME format.
--------------040301080001080902060300
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi all,

I have purchased Prof_Revolution_DVB-S2_8000_PCI-E which is listed on
the wiki
http://linuxtv.org/wiki/index.php/Prof_Revolution_DVB-S2_8000_PCI-E as
not yet suppoorted, however I found out there is some work ongoing on
the driver for that card as the producer make the folowing patch
http://www.proftuners.com/sites/default/files/prof8000_0.patch available
on their website http://www.prof-tuners.pl/download8000.html This patch
would not apply agaist the recent Linux Kernel 2.6.38-rc8-next-20110314
so I did a few quick fixes that moved few lines (patch in the
attachment). Now that it all applies like it should it fails with the
following error


  CC [M]  kernel/configs.o
  CC [M]  drivers/media/video/cx23885/cx23885-cards.o
  CC [M]  drivers/media/video/cx23885/cx23885-video.o
  CC [M]  drivers/media/video/cx23885/cx23885-vbi.o
  CC [M]  drivers/media/video/cx23885/cx23885-core.o
drivers/media/video/cx23885/altera-ci.h:71:12: warning:
‘altera_ci_tuner_reset’ defined but not used [-Wunused-function]
  CC [M]  drivers/media/video/cx23885/cx23885-i2c.o
  CC [M]  drivers/media/video/cx23885/cx23885-dvb.o
drivers/media/video/cx23885/cx23885-dvb.c:505:15: error: variable
‘prof_8000_stb6100_config’ has initializer but incomplete type
drivers/media/video/cx23885/cx23885-dvb.c:506:2: error: unknown field
‘tuner_address’ specified in initializer
drivers/media/video/cx23885/cx23885-dvb.c:506:2: warning: excess
elements in struct initializer [enabled by default]
drivers/media/video/cx23885/cx23885-dvb.c:506:2: warning: (near
initialization for ‘prof_8000_stb6100_config’) [enabled by default]
drivers/media/video/cx23885/cx23885-dvb.c:507:2: error: unknown field
‘refclock’ specified in initializer
drivers/media/video/cx23885/cx23885-dvb.c:507:2: warning: excess
elements in struct initializer [enabled by default]
drivers/media/video/cx23885/cx23885-dvb.c:507:2: warning: (near
initialization for ‘prof_8000_stb6100_config’) [enabled by default]
drivers/media/video/cx23885/cx23885-dvb.c: In function ‘dvb_register’:
drivers/media/video/cx23885/cx23885-dvb.c:1134:8: error:
‘stb6100_attach’ undeclared (first use in this function)
drivers/media/video/cx23885/cx23885-dvb.c:1134:8: note: each undeclared
identifier is reported only once for each function it appears in
drivers/media/video/cx23885/cx23885-dvb.c:1134:8: error: called object
‘__a’ is not a function
drivers/media/video/cx23885/cx23885-dvb.c:1138:32: error:
‘stb6100_set_freq’ undeclared (first use in this function)
drivers/media/video/cx23885/cx23885-dvb.c:1139:32: error:
‘stb6100_get_freq’ undeclared (first use in this function)
drivers/media/video/cx23885/cx23885-dvb.c:1140:32: error:
‘stb6100_set_bandw’ undeclared (first use in this function)
drivers/media/video/cx23885/cx23885-dvb.c:1141:32: error:
‘stb6100_get_bandw’ undeclared (first use in this function)
drivers/media/video/cx23885/cx23885-dvb.c: At top level:
drivers/media/video/cx23885/altera-ci.h:71:12: warning:
‘altera_ci_tuner_reset’ defined but not used [-Wunused-function]
make[4]: *** [drivers/media/video/cx23885/cx23885-dvb.o] Error 1
make[3]: *** [drivers/media/video/cx23885] Error 2
make[2]: *** [drivers/media/video] Error 2
make[1]: *** [drivers/media] Error 2
make: *** [drivers] Error 2

Please help in making it work as my Kung Fu ends here

Regards,
Wojciech


--------------040301080001080902060300
Content-Type: text/plain;
 name="prof8000_1.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="prof8000_1.patch"

ZGlmZiAtciAxZGE1ZmVkNWM4YjIgbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9jeDIzODg1
L2N4MjM4ODUtY2FyZHMuYw0KLS0tIGEvbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9jeDIz
ODg1L2N4MjM4ODUtY2FyZHMuYwlTdW4gU2VwIDE5IDAyOjIzOjA5IDIwMTAgLTAzMDANCisr
KyBiL2xpbnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8vY3gyMzg4NS9jeDIzODg1LWNhcmRzLmMJ
U2F0IE9jdCAwMiAxMToxOTo1MCAyMDEwICswMzAwDQpAQCAtMTY5LDYgKzE2OSwxMCBAQA0K
IAkJLm5hbWUJCT0gIlR1cmJvU2lnaHQgVEJTIDY5MjAiLA0KIAkJLnBvcnRiCQk9IENYMjM4
ODVfTVBFR19EVkIsDQogCX0sDQorCVtDWDIzODg1X0JPQVJEX1BST0ZfODAwMF0gPSB7DQor
CQkubmFtZQkJPSAiUHJvZiBSZXZvbHV0aW9uIERWQi1TMiA4MDAwIiwNCisJCS5wb3J0YgkJ
PSBDWDIzODg1X01QRUdfRFZCLA0KKwl9LA0KIAlbQ1gyMzg4NV9CT0FSRF9URVZJSV9TNDcw
XSA9IHsNCiAJCS5uYW1lCQk9ICJUZVZpaSBTNDcwIiwNCiAJCS5wb3J0YgkJPSBDWDIzODg1
X01QRUdfRFZCLA0KQEAgLTM4OCw2ICszOTIsMTAgQEANCiAJCS5zdWJkZXZpY2UgPSAweDg4
ODgsDQogCQkuY2FyZCAgICAgID0gQ1gyMzg4NV9CT0FSRF9UQlNfNjkyMCwNCiAJfSwgew0K
KwkJLnN1YnZlbmRvciA9IDB4ODAwMCwNCisJCS5zdWJkZXZpY2UgPSAweDMwMzQsDQorCQku
Y2FyZCAgICAgID0gQ1gyMzg4NV9CT0FSRF9QUk9GXzgwMDAsDQorCX0sIHsNCiAJCS5zdWJ2
ZW5kb3IgPSAweGQ0NzAsDQogCQkuc3ViZGV2aWNlID0gMHg5MDIyLA0KIAkJLmNhcmQgICAg
ICA9IENYMjM4ODVfQk9BUkRfVEVWSUlfUzQ3MCwNCkBAIC04MTMsNiArODIxLDcgQEANCiAJ
CW1kZWxheSgyMCk7DQogCQljeF9zZXQoR1AwX0lPLCAweDAwMDQwMDA0KTsNCiAJCWJyZWFr
Ow0KKwljYXNlIENYMjM4ODVfQk9BUkRfUFJPRl84MDAwOg0KIAljYXNlIENYMjM4ODVfQk9B
UkRfVEJTXzY5MjA6DQogCQljeF93cml0ZShNQzQxN19DVEwsIDB4MDAwMDAwMzYpOw0KIAkJ
Y3hfd3JpdGUoTUM0MTdfT0VOLCAweDAwMDAxMDAwKTsNCkBAIC0xMDQzLDYgKzEwNTIsNyBA
QA0KIAkJdHMxLT50c19jbGtfZW5fdmFsID0gMHgxOyAvKiBFbmFibGUgVFNfQ0xLICovDQog
CQl0czEtPnNyY19zZWxfdmFsICAgPSBDWDIzODg1X1NSQ19TRUxfUEFSQUxMRUxfTVBFR19W
SURFTzsNCiAJCWJyZWFrOw0KKwljYXNlIENYMjM4ODVfQk9BUkRfUFJPRl84MDAwOg0KIAlj
YXNlIENYMjM4ODVfQk9BUkRfVEVWSUlfUzQ3MDoNCiAJY2FzZSBDWDIzODg1X0JPQVJEX0RW
QldPUkxEXzIwMDU6DQogCQl0czEtPmdlbl9jdHJsX3ZhbCAgPSAweDU7IC8qIFBhcmFsbGVs
ICovDQotLS0gYS9saW51eC9kcml2ZXJzL21lZGlhL3ZpZGVvL2N4MjM4ODUvY3gyMzg4NS1k
dmIuYy5vbGQJMjAxMS0wMy0yMCAwODoyMDozNy4zODQwMDEzMzggKzAxMDANCisrKyBiL2xp
bnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8vY3gyMzg4NS9jeDIzODg1LWR2Yi5jCTIwMTEtMDMt
MjAgMDg6Mjk6NTYuNzU3MDAxNDc2ICswMTAwDQpAQCAtNDcsNiArNDcsOSBAQA0KICNpbmNs
dWRlICJkaWJ4MDAwX2NvbW1vbi5oIg0KICNpbmNsdWRlICJ6bDEwMzUzLmgiDQogI2luY2x1
ZGUgInN0djA5MDAuaCINCisjaW5jbHVkZSAic3RiNjEwMC5oIg0KKyNpbmNsdWRlICJzdGI2
MTAwX3Byb2MuaCINCisjaW5jbHVkZSAic3R2MDkwMC5oIg0KICNpbmNsdWRlICJzdHYwOTAw
X3JlZy5oIg0KICNpbmNsdWRlICJzdHY2MTEwLmgiDQogI2luY2x1ZGUgImxuYmgyNC5oIg0K
QEAgLTQ3OCw2ICs0NzgsMzUgQEANCiAJLmlmX2toeiA9IDUzODAsDQogfTsNCiANCitzdGF0
aWMgaW50IHA4MDAwX3NldF92b2x0YWdlKHN0cnVjdCBkdmJfZnJvbnRlbmQgKmZlLCBmZV9z
ZWNfdm9sdGFnZV90IHZvbHRhZ2UpDQorew0KKwlzdHJ1Y3QgY3gyMzg4NV90c3BvcnQgKnBv
cnQgPSBmZS0+ZHZiLT5wcml2Ow0KKwlzdHJ1Y3QgY3gyMzg4NV9kZXYgKmRldiA9IHBvcnQt
PmRldjsNCisNCisJaWYgKHZvbHRhZ2UgPT0gU0VDX1ZPTFRBR0VfMTgpDQorCQljeF93cml0
ZShNQzQxN19SV0QsIDB4MDAwMDFlMDApOw0KKwllbHNlIGlmICh2b2x0YWdlID09IFNFQ19W
T0xUQUdFXzEzKQ0KKwkJY3hfd3JpdGUoTUM0MTdfUldELCAweDAwMDAxYTAwKTsNCisJZWxz
ZQ0KKwkJY3hfd3JpdGUoTUM0MTdfUldELCAweDAwMDAxODAwKTsNCisJcmV0dXJuIDA7DQor
fQ0KKw0KK3N0YXRpYyBzdHJ1Y3Qgc3R2MDkwMF9jb25maWcgcHJvZl84MDAwX3N0djA5MDBf
Y29uZmlnID0gew0KKwkuZGVtb2RfYWRkcmVzcyA9IDB4NmEsDQorCS54dGFsID0gMjcwMDAw
MDAsDQorCS5jbGttb2RlID0gMywNCisJLmRpc2VxY19tb2RlID0gMiwNCisJLnR1bjFfbWFk
ZHJlc3MgPSAwLA0KKwkudHVuMV9hZGMgPSAwLA0KKwkucGF0aDFfbW9kZSA9IDMsDQorfTsN
CisNCitzdGF0aWMgc3RydWN0IHN0YjYxMDBfY29uZmlnIHByb2ZfODAwMF9zdGI2MTAwX2Nv
bmZpZyA9IHsNCisJLnR1bmVyX2FkZHJlc3MgPSAweDYwLA0KKwkucmVmY2xvY2sgPSAyNzAw
MDAwMCwNCit9Ow0KKw0KIHN0YXRpYyBpbnQgY3gyMzg4NV9kdmJfc2V0X2Zyb250ZW5kKHN0
cnVjdCBkdmJfZnJvbnRlbmQgKmZlLA0KIAkJCQkgICAgc3RydWN0IGR2Yl9mcm9udGVuZF9w
YXJhbWV0ZXJzICpwYXJhbSkNCiB7DQpAQCAtMTA5NCw2ICsxMTIzLDI5IEBADQogCQkJCWdv
dG8gZnJvbnRlbmRfZGV0YWNoOw0KIAkJfQ0KIAkJYnJlYWs7DQorCWNhc2UgQ1gyMzg4NV9C
T0FSRF9QUk9GXzgwMDA6IHsNCisJCXN0cnVjdCBkdmJfdHVuZXJfb3BzICp0dW5lcl9vcHMg
PSBOVUxMOw0KKw0KKwkJaTJjX2J1cyA9ICZkZXYtPmkyY19idXNbMF07DQorCQlmZTAtPmR2
Yi5mcm9udGVuZCA9IGR2Yl9hdHRhY2goc3R2MDkwMF9hdHRhY2gsDQorCQkJCQkJJnByb2Zf
ODAwMF9zdHYwOTAwX2NvbmZpZywNCisJCQkJCQkmaTJjX2J1cy0+aTJjX2FkYXAsIDApOw0K
KwkJaWYgKGZlMC0+ZHZiLmZyb250ZW5kICE9IE5VTEwpIHsNCisJCQlpZiAoZHZiX2F0dGFj
aChzdGI2MTAwX2F0dGFjaCwgZmUwLT5kdmIuZnJvbnRlbmQsDQorCQkJCQkmcHJvZl84MDAw
X3N0YjYxMDBfY29uZmlnLA0KKwkJCQkJJmkyY19idXMtPmkyY19hZGFwKSkgew0KKwkJCQl0
dW5lcl9vcHMgPSAmZmUwLT5kdmIuZnJvbnRlbmQtPm9wcy50dW5lcl9vcHM7DQorCQkJCXR1
bmVyX29wcy0+c2V0X2ZyZXF1ZW5jeSA9IHN0YjYxMDBfc2V0X2ZyZXE7DQorCQkJCXR1bmVy
X29wcy0+Z2V0X2ZyZXF1ZW5jeSA9IHN0YjYxMDBfZ2V0X2ZyZXE7DQorCQkJCXR1bmVyX29w
cy0+c2V0X2JhbmR3aWR0aCA9IHN0YjYxMDBfc2V0X2JhbmR3Ow0KKwkJCQl0dW5lcl9vcHMt
PmdldF9iYW5kd2lkdGggPSBzdGI2MTAwX2dldF9iYW5kdzsNCisNCisJCQkJZmUwLT5kdmIu
ZnJvbnRlbmQtPm9wcy5zZXRfdm9sdGFnZSA9DQorCQkJCQkJCXA4MDAwX3NldF92b2x0YWdl
Ow0KKwkJCX0NCisJCX0NCisJCWJyZWFrOw0KKwkJfQ0KIAlkZWZhdWx0Og0KIAkJcHJpbnRr
KEtFUk5fSU5GTyAiJXM6IFRoZSBmcm9udGVuZCBvZiB5b3VyIERWQi9BVFNDIGNhcmQgIg0K
IAkJCSIgaXNuJ3Qgc3VwcG9ydGVkIHlldFxuIiwNCi0tLSBhL2xpbnV4L2RyaXZlcnMvbWVk
aWEvdmlkZW8vY3gyMzg4NS9jeDIzODg1Lmgub2xkCTIwMTEtMDMtMjAgMDg6MzM6MTUuMTU5
MDAxNTI3ICswMTAwDQorKysgYi9saW51eC9kcml2ZXJzL21lZGlhL3ZpZGVvL2N4MjM4ODUv
Y3gyMzg4NS5oCTIwMTEtMDMtMjAgMDg6MzQ6MzIuMjQ0MDAxNTQ3ICswMTAwDQpAQCAtODYs
NiArODYsNyBAQA0KICNkZWZpbmUgQ1gyMzg4NV9CT0FSRF9MRUFEVEVLX1dJTkZBU1RfUFhU
VjEyMDAgMjgNCiAjZGVmaW5lIENYMjM4ODVfQk9BUkRfR09UVklFV19YNV8zRF9IWUJSSUQg
ICAgIDI5DQogI2RlZmluZSBDWDIzODg1X0JPQVJEX05FVFVQX0RVQUxfRFZCX1RfQ19DSV9S
RiAzMA0KKyNkZWZpbmUgQ1gyMzg4NV9CT0FSRF9QUk9GXzgwMDAgICAgICAgICAgICAgICAg
MzENCiANCiAjZGVmaW5lIEdQSU9fMCAweDAwMDAwMDAxDQogI2RlZmluZSBHUElPXzEgMHgw
MDAwMDAwMg0K
--------------040301080001080902060300--
