Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:35122 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764AbZIBDNn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Sep 2009 23:13:43 -0400
Received: by ewy2 with SMTP id 2so413308ewy.17
        for <linux-media@vger.kernel.org>; Tue, 01 Sep 2009 20:13:44 -0700 (PDT)
Date: Wed, 2 Sep 2009 13:13:57 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: linux-media@vger.kernel.org, video4linux-list@redhat.com
Subject: [PATCH] Change tuner type of BeholdTV cards
Message-ID: <20090902131357.1d59b541@glory.loctelecom.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/vNuSzxuWT9Up5_T3yi0_wyj"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--MP_/vNuSzxuWT9Up5_T3yi0_wyj
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi All.

Change tuner type to correct for BeholdTV cards with FM1216MK5.

diff -r be01f82499cc linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Mon Aug 31 23:14:06 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Wed Sep 02 08:03:58 2009 +1000
@@ -4203,7 +4203,7 @@
 		/*Dmitry Belimov <d.belimov@gmail.com> */
 		.name           = "Beholder BeholdTV 505 RDS",
 		.audio_clock    = 0x00200000,
-		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3, /* FIXME to MK5 */
+		.tuner_type     = TUNER_PHILIPS_FM1216MK5,
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
@@ -4268,7 +4268,7 @@
 		/*Dmitry Belimov <d.belimov@gmail.com> */
 		.name           = "Beholder BeholdTV 507 RDS",
 		.audio_clock    = 0x00187de7,
-		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3, /* FIXME to MK5 */
+		.tuner_type     = TUNER_PHILIPS_FM1216MK5,
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
@@ -4419,7 +4419,7 @@
 		/* Andrey Melnikoff <temnota@kmv.ru> */
 		.name           = "Beholder BeholdTV 607 FM",
 		.audio_clock    = 0x00187de7,
-		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3, /* FIXME to MK5 */
+		.tuner_type     = TUNER_PHILIPS_FM1216MK5,
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
@@ -4447,7 +4447,7 @@
 		/* Andrey Melnikoff <temnota@kmv.ru> */
 		.name           = "Beholder BeholdTV 609 FM",
 		.audio_clock    = 0x00187de7,
-		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3, /* FIXME to MK5 */
+		.tuner_type     = TUNER_PHILIPS_FM1216MK5,
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
@@ -4533,7 +4533,7 @@
 		/* Andrey Melnikoff <temnota@kmv.ru> */
 		.name           = "Beholder BeholdTV 607 RDS",
 		.audio_clock    = 0x00187de7,
-		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3, /* FIXME to MK5 */
+		.tuner_type     = TUNER_PHILIPS_FM1216MK5,
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
@@ -4562,7 +4562,7 @@
 		/* Andrey Melnikoff <temnota@kmv.ru> */
 		.name           = "Beholder BeholdTV 609 RDS",
 		.audio_clock    = 0x00187de7,
-		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3, /* FIXME to MK5 */
+		.tuner_type     = TUNER_PHILIPS_FM1216MK5,
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
@@ -4669,7 +4669,7 @@
 		/* Alexey Osipov <lion-simba@pridelands.ru> */
 		.name           = "Beholder BeholdTV M6 Extra",
 		.audio_clock    = 0x00187de7,
-		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3, /* FIXME to MK5 */
+		.tuner_type     = TUNER_PHILIPS_FM1216MK5,
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

With my best regards, Dmitry.

--MP_/vNuSzxuWT9Up5_T3yi0_wyj
Content-Type: application/octet-stream; name=behold_mk5.path
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=behold_mk5.path

ZGlmZiAtciBiZTAxZjgyNDk5Y2MgbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9zYWE3MTM0L3Nh
YTcxMzQtY2FyZHMuYwotLS0gYS9saW51eC9kcml2ZXJzL21lZGlhL3ZpZGVvL3NhYTcxMzQvc2Fh
NzEzNC1jYXJkcy5jCU1vbiBBdWcgMzEgMjM6MTQ6MDYgMjAwOSAtMDMwMAorKysgYi9saW51eC9k
cml2ZXJzL21lZGlhL3ZpZGVvL3NhYTcxMzQvc2FhNzEzNC1jYXJkcy5jCVdlZCBTZXAgMDIgMDg6
MDM6NTggMjAwOSArMTAwMApAQCAtNDIwMyw3ICs0MjAzLDcgQEAKIAkJLypEbWl0cnkgQmVsaW1v
diA8ZC5iZWxpbW92QGdtYWlsLmNvbT4gKi8KIAkJLm5hbWUgICAgICAgICAgID0gIkJlaG9sZGVy
IEJlaG9sZFRWIDUwNSBSRFMiLAogCQkuYXVkaW9fY2xvY2sgICAgPSAweDAwMjAwMDAwLAotCQku
dHVuZXJfdHlwZSAgICAgPSBUVU5FUl9QSElMSVBTX0ZNMTIxNk1FX01LMywgLyogRklYTUUgdG8g
TUs1ICovCisJCS50dW5lcl90eXBlICAgICA9IFRVTkVSX1BISUxJUFNfRk0xMjE2TUs1LAogCQku
cmFkaW9fdHlwZSAgICAgPSBVTlNFVCwKIAkJLnR1bmVyX2FkZHIgICAgID0gQUREUl9VTlNFVCwK
IAkJLnJhZGlvX2FkZHIgICAgID0gQUREUl9VTlNFVCwKQEAgLTQyNjgsNyArNDI2OCw3IEBACiAJ
CS8qRG1pdHJ5IEJlbGltb3YgPGQuYmVsaW1vdkBnbWFpbC5jb20+ICovCiAJCS5uYW1lICAgICAg
ICAgICA9ICJCZWhvbGRlciBCZWhvbGRUViA1MDcgUkRTIiwKIAkJLmF1ZGlvX2Nsb2NrICAgID0g
MHgwMDE4N2RlNywKLQkJLnR1bmVyX3R5cGUgICAgID0gVFVORVJfUEhJTElQU19GTTEyMTZNRV9N
SzMsIC8qIEZJWE1FIHRvIE1LNSAqLworCQkudHVuZXJfdHlwZSAgICAgPSBUVU5FUl9QSElMSVBT
X0ZNMTIxNk1LNSwKIAkJLnJhZGlvX3R5cGUgICAgID0gVU5TRVQsCiAJCS50dW5lcl9hZGRyICAg
ICA9IEFERFJfVU5TRVQsCiAJCS5yYWRpb19hZGRyICAgICA9IEFERFJfVU5TRVQsCkBAIC00NDE5
LDcgKzQ0MTksNyBAQAogCQkvKiBBbmRyZXkgTWVsbmlrb2ZmIDx0ZW1ub3RhQGttdi5ydT4gKi8K
IAkJLm5hbWUgICAgICAgICAgID0gIkJlaG9sZGVyIEJlaG9sZFRWIDYwNyBGTSIsCiAJCS5hdWRp
b19jbG9jayAgICA9IDB4MDAxODdkZTcsCi0JCS50dW5lcl90eXBlICAgICA9IFRVTkVSX1BISUxJ
UFNfRk0xMjE2TUVfTUszLCAvKiBGSVhNRSB0byBNSzUgKi8KKwkJLnR1bmVyX3R5cGUgICAgID0g
VFVORVJfUEhJTElQU19GTTEyMTZNSzUsCiAJCS5yYWRpb190eXBlICAgICA9IFVOU0VULAogCQku
dHVuZXJfYWRkciAgICAgPSBBRERSX1VOU0VULAogCQkucmFkaW9fYWRkciAgICAgPSBBRERSX1VO
U0VULApAQCAtNDQ0Nyw3ICs0NDQ3LDcgQEAKIAkJLyogQW5kcmV5IE1lbG5pa29mZiA8dGVtbm90
YUBrbXYucnU+ICovCiAJCS5uYW1lICAgICAgICAgICA9ICJCZWhvbGRlciBCZWhvbGRUViA2MDkg
Rk0iLAogCQkuYXVkaW9fY2xvY2sgICAgPSAweDAwMTg3ZGU3LAotCQkudHVuZXJfdHlwZSAgICAg
PSBUVU5FUl9QSElMSVBTX0ZNMTIxNk1FX01LMywgLyogRklYTUUgdG8gTUs1ICovCisJCS50dW5l
cl90eXBlICAgICA9IFRVTkVSX1BISUxJUFNfRk0xMjE2TUs1LAogCQkucmFkaW9fdHlwZSAgICAg
PSBVTlNFVCwKIAkJLnR1bmVyX2FkZHIgICAgID0gQUREUl9VTlNFVCwKIAkJLnJhZGlvX2FkZHIg
ICAgID0gQUREUl9VTlNFVCwKQEAgLTQ1MzMsNyArNDUzMyw3IEBACiAJCS8qIEFuZHJleSBNZWxu
aWtvZmYgPHRlbW5vdGFAa212LnJ1PiAqLwogCQkubmFtZSAgICAgICAgICAgPSAiQmVob2xkZXIg
QmVob2xkVFYgNjA3IFJEUyIsCiAJCS5hdWRpb19jbG9jayAgICA9IDB4MDAxODdkZTcsCi0JCS50
dW5lcl90eXBlICAgICA9IFRVTkVSX1BISUxJUFNfRk0xMjE2TUVfTUszLCAvKiBGSVhNRSB0byBN
SzUgKi8KKwkJLnR1bmVyX3R5cGUgICAgID0gVFVORVJfUEhJTElQU19GTTEyMTZNSzUsCiAJCS5y
YWRpb190eXBlICAgICA9IFVOU0VULAogCQkudHVuZXJfYWRkciAgICAgPSBBRERSX1VOU0VULAog
CQkucmFkaW9fYWRkciAgICAgPSBBRERSX1VOU0VULApAQCAtNDU2Miw3ICs0NTYyLDcgQEAKIAkJ
LyogQW5kcmV5IE1lbG5pa29mZiA8dGVtbm90YUBrbXYucnU+ICovCiAJCS5uYW1lICAgICAgICAg
ICA9ICJCZWhvbGRlciBCZWhvbGRUViA2MDkgUkRTIiwKIAkJLmF1ZGlvX2Nsb2NrICAgID0gMHgw
MDE4N2RlNywKLQkJLnR1bmVyX3R5cGUgICAgID0gVFVORVJfUEhJTElQU19GTTEyMTZNRV9NSzMs
IC8qIEZJWE1FIHRvIE1LNSAqLworCQkudHVuZXJfdHlwZSAgICAgPSBUVU5FUl9QSElMSVBTX0ZN
MTIxNk1LNSwKIAkJLnJhZGlvX3R5cGUgICAgID0gVU5TRVQsCiAJCS50dW5lcl9hZGRyICAgICA9
IEFERFJfVU5TRVQsCiAJCS5yYWRpb19hZGRyICAgICA9IEFERFJfVU5TRVQsCkBAIC00NjY5LDcg
KzQ2NjksNyBAQAogCQkvKiBBbGV4ZXkgT3NpcG92IDxsaW9uLXNpbWJhQHByaWRlbGFuZHMucnU+
ICovCiAJCS5uYW1lICAgICAgICAgICA9ICJCZWhvbGRlciBCZWhvbGRUViBNNiBFeHRyYSIsCiAJ
CS5hdWRpb19jbG9jayAgICA9IDB4MDAxODdkZTcsCi0JCS50dW5lcl90eXBlICAgICA9IFRVTkVS
X1BISUxJUFNfRk0xMjE2TUVfTUszLCAvKiBGSVhNRSB0byBNSzUgKi8KKwkJLnR1bmVyX3R5cGUg
ICAgID0gVFVORVJfUEhJTElQU19GTTEyMTZNSzUsCiAJCS5yYWRpb190eXBlICAgICA9IFVOU0VU
LAogCQkudHVuZXJfYWRkciAgICAgPSBBRERSX1VOU0VULAogCQkucmFkaW9fYWRkciAgICAgPSBB
RERSX1VOU0VULAoKU2lnbmVkLW9mZi1ieTogQmVob2xkZXIgSW50bC4gTHRkLiBEbWl0cnkgQmVs
aW1vdiA8ZC5iZWxpbW92QGdtYWlsLmNvbT4K

--MP_/vNuSzxuWT9Up5_T3yi0_wyj--
