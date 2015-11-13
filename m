Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:41607 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750872AbbKMWzq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Nov 2015 17:55:46 -0500
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, crope@iki.fi, xpert-reactos@gmx.de,
	Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH 2/4] si2165: fix checkpatch issues
Date: Fri, 13 Nov 2015 23:54:56 +0100
Message-Id: <1447455298-5562-2-git-send-email-zzam@gentoo.org>
In-Reply-To: <1447455298-5562-1-git-send-email-zzam@gentoo.org>
References: <1447455298-5562-1-git-send-email-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/dvb-frontends/si2165.c | 69 ++++++++++++++++++++----------------
 1 file changed, 39 insertions(+), 30 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2165.c b/drivers/media/dvb-frontends/si2165.c
index 7c2eeee..c5d7c0d 100644
--- a/drivers/media/dvb-frontends/si2165.c
+++ b/drivers/media/dvb-frontends/si2165.c
@@ -1,21 +1,21 @@
 /*
-    Driver for Silicon Labs Si2161 DVB-T and Si2165 DVB-C/-T Demodulator
-
-    Copyright (C) 2013-2014 Matthias Schwarzott <zzam@gentoo.org>
-
-    This program is free software; you can redistribute it and/or modify
-    it under the terms of the GNU General Public License as published by
-    the Free Software Foundation; either version 2 of the License, or
-    (at your option) any later version.
-
-    This program is distributed in the hope that it will be useful,
-    but WITHOUT ANY WARRANTY; without even the implied warranty of
-    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-    GNU General Public License for more details.
-
-    References:
-    http://www.silabs.com/Support%20Documents/TechnicalDocs/Si2165-short.pdf
-*/
+ *  Driver for Silicon Labs Si2161 DVB-T and Si2165 DVB-C/-T Demodulator
+ *
+ *  Copyright (C) 2013-2014 Matthias Schwarzott <zzam@gentoo.org>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  References:
+ *  http://www.silabs.com/Support%20Documents/TechnicalDocs/Si2165-short.pdf
+ */
 
 #include <linux/delay.h>
 #include <linux/errno.h>
@@ -31,11 +31,13 @@
 #include "si2165_priv.h"
 #include "si2165.h"
 
-/* Hauppauge WinTV-HVR-930C-HD B130 / PCTV QuatroStick 521e 1113xx
- * uses 16 MHz xtal */
-
-/* Hauppauge WinTV-HVR-930C-HD B131 / PCTV QuatroStick 522e 1114xx
- * uses 24 MHz clock provided by tuner */
+/*
+ * Hauppauge WinTV-HVR-930C-HD B130 / PCTV QuatroStick 521e 1113xx
+ * uses 16 MHz xtal
+ *
+ * Hauppauge WinTV-HVR-930C-HD B131 / PCTV QuatroStick 522e 1114xx
+ * uses 24 MHz clock provided by tuner
+ */
 
 struct si2165_state {
 	struct i2c_adapter *i2c;
@@ -258,8 +260,10 @@ static int si2165_init_pll(struct si2165_state *state)
 	u8 divl = 12;
 	u8 buf[4];
 
-	/* hardcoded values can be deleted if calculation is verified
-	 * or it yields the same values as the windows driver */
+	/*
+	 * hardcoded values can be deleted if calculation is verified
+	 * or it yields the same values as the windows driver
+	 */
 	switch (ref_freq_Hz) {
 	case 16000000u:
 		divn = 56;
@@ -274,8 +278,10 @@ static int si2165_init_pll(struct si2165_state *state)
 		if (ref_freq_Hz > 16000000u)
 			divr = 2;
 
-		/* now select divn and divp such that
-		 * fvco is in 1624..1824 MHz */
+		/*
+		 * now select divn and divp such that
+		 * fvco is in 1624..1824 MHz
+		 */
 		if (1624000000u * divr > ref_freq_Hz * 2u * 63u)
 			divp = 4;
 
@@ -341,10 +347,12 @@ static int si2165_upload_firmware_block(struct si2165_state *state,
 	if (len % 4 != 0)
 		return -EINVAL;
 
-	deb_fw_load("si2165_upload_firmware_block called with len=0x%x offset=0x%x blockcount=0x%x\n",
+	deb_fw_load(
+		"si2165_upload_firmware_block called with len=0x%x offset=0x%x blockcount=0x%x\n",
 				len, offset, block_count);
 	while (offset+12 <= len && cur_block < block_count) {
-		deb_fw_load("si2165_upload_firmware_block in while len=0x%x offset=0x%x cur_block=0x%x blockcount=0x%x\n",
+		deb_fw_load(
+			"si2165_upload_firmware_block in while len=0x%x offset=0x%x cur_block=0x%x blockcount=0x%x\n",
 					len, offset, cur_block, block_count);
 		wordcount = data[offset];
 		if (wordcount < 1 || data[offset+1] ||
@@ -383,7 +391,8 @@ static int si2165_upload_firmware_block(struct si2165_state *state,
 		cur_block++;
 	}
 
-	deb_fw_load("si2165_upload_firmware_block after while len=0x%x offset=0x%x cur_block=0x%x blockcount=0x%x\n",
+	deb_fw_load(
+		"si2165_upload_firmware_block after while len=0x%x offset=0x%x cur_block=0x%x blockcount=0x%x\n",
 				len, offset, cur_block, block_count);
 
 	if (poffset)
@@ -633,7 +642,7 @@ static int si2165_init(struct dvb_frontend *fe)
 		goto error;
 
 	/* ber_pkt */
-	ret = si2165_writereg16(state, 0x0470 , 0x7530);
+	ret = si2165_writereg16(state, 0x0470, 0x7530);
 	if (ret < 0)
 		goto error;
 
-- 
2.6.3

