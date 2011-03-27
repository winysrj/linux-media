Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59769 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550Ab1C0BEG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Mar 2011 21:04:06 -0400
Received: by wya21 with SMTP id 21so2004049wya.19
        for <linux-media@vger.kernel.org>; Sat, 26 Mar 2011 18:04:04 -0700 (PDT)
Subject: [PATCH 2/2] STV0299 Register 02 on
 Opera1/Bsru6/z0194a/mantis_vp1033
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 27 Mar 2011 02:03:47 +0100
Message-ID: <1301187827.2338.1.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Bits 4 and 5 on register 02 should always be set to 1.

Opera1/Bsru6/z0194a/mantis_vp1033

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/dvb-usb/opera1.c       |    2 +-
 drivers/media/dvb/frontends/bsru6.h      |    2 +-
 drivers/media/dvb/frontends/z0194a.h     |    2 +-
 drivers/media/dvb/mantis/mantis_vp1033.c |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/opera1.c b/drivers/media/dvb/dvb-usb/opera1.c
index 7e569f4..c78f28f 100644
--- a/drivers/media/dvb/dvb-usb/opera1.c
+++ b/drivers/media/dvb/dvb-usb/opera1.c
@@ -189,7 +189,7 @@ static int opera1_stv0299_set_symbol_rate(struct dvb_frontend *fe, u32 srate,
 static u8 opera1_inittab[] = {
 	0x00, 0xa1,
 	0x01, 0x15,
-	0x02, 0x00,
+	0x02, 0x30,
 	0x03, 0x00,
 	0x04, 0x7d,
 	0x05, 0x05,
diff --git a/drivers/media/dvb/frontends/bsru6.h b/drivers/media/dvb/frontends/bsru6.h
index 45a6dfd..c480c83 100644
--- a/drivers/media/dvb/frontends/bsru6.h
+++ b/drivers/media/dvb/frontends/bsru6.h
@@ -27,7 +27,7 @@
 
 static u8 alps_bsru6_inittab[] = {
 	0x01, 0x15,
-	0x02, 0x00,
+	0x02, 0x30,
 	0x03, 0x00,
 	0x04, 0x7d,   /* F22FR = 0x7d, F22 = f_VCO / 128 / 0x7d = 22 kHz */
 	0x05, 0x35,   /* I2CT = 0, SCLT = 1, SDAT = 1 */
diff --git a/drivers/media/dvb/frontends/z0194a.h b/drivers/media/dvb/frontends/z0194a.h
index 07f3fc0..96d86d6 100644
--- a/drivers/media/dvb/frontends/z0194a.h
+++ b/drivers/media/dvb/frontends/z0194a.h
@@ -42,7 +42,7 @@ static int sharp_z0194a_set_symbol_rate(struct dvb_frontend *fe,
 
 static u8 sharp_z0194a_inittab[] = {
 	0x01, 0x15,
-	0x02, 0x00,
+	0x02, 0x30,
 	0x03, 0x00,
 	0x04, 0x7d,   /* F22FR = 0x7d, F22 = f_VCO / 128 / 0x7d = 22 kHz */
 	0x05, 0x35,   /* I2CT = 0, SCLT = 1, SDAT = 1 */
diff --git a/drivers/media/dvb/mantis/mantis_vp1033.c b/drivers/media/dvb/mantis/mantis_vp1033.c
index deec927..2ae0afa 100644
--- a/drivers/media/dvb/mantis/mantis_vp1033.c
+++ b/drivers/media/dvb/mantis/mantis_vp1033.c
@@ -37,7 +37,7 @@
 
 u8 lgtdqcs001f_inittab[] = {
 	0x01, 0x15,
-	0x02, 0x00,
+	0x02, 0x30,
 	0x03, 0x00,
 	0x04, 0x2a,
 	0x05, 0x85,
-- 
1.7.4.1

