Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:45356 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154AbaHaLfb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Aug 2014 07:35:31 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org, m.chehab@samsung.com, crope@iki.fi,
	zzam@gentoo.org
Subject: [PATCH 2/7] si2165: enable Si2161 support
Date: Sun, 31 Aug 2014 13:35:07 +0200
Message-Id: <1409484912-19300-3-git-send-email-zzam@gentoo.org>
In-Reply-To: <1409484912-19300-1-git-send-email-zzam@gentoo.org>
References: <1409484912-19300-1-git-send-email-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Additionally print chip name with revision symbolically.
This is a preparation for supporting new Hauppauge WinTV-HVR-900-H based
on cx231xx.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/dvb-frontends/si2165.c | 39 +++++++++++++++++++++++++-----------
 1 file changed, 27 insertions(+), 12 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2165.c b/drivers/media/dvb-frontends/si2165.c
index 65e0dc9..fe4e8f2 100644
--- a/drivers/media/dvb-frontends/si2165.c
+++ b/drivers/media/dvb-frontends/si2165.c
@@ -1,5 +1,5 @@
 /*
-    Driver for Silicon Labs SI2165 DVB-C/-T Demodulator
+    Driver for Silicon Labs Si2161 DVB-T and Si2165 DVB-C/-T Demodulator
 
     Copyright (C) 2013-2014 Matthias Schwarzott <zzam@gentoo.org>
 
@@ -916,7 +916,7 @@ static void si2165_release(struct dvb_frontend *fe)
 
 static struct dvb_frontend_ops si2165_ops = {
 	.info = {
-		.name = "Silicon Labs Si2165",
+		.name = "Silicon Labs ",
 		.caps =	FE_CAN_FEC_1_2 |
 			FE_CAN_FEC_2_3 |
 			FE_CAN_FEC_3_4 |
@@ -956,6 +956,8 @@ struct dvb_frontend *si2165_attach(const struct si2165_config *config,
 	int n;
 	int io_ret;
 	u8 val;
+	char rev_char;
+	const char *chip_name;
 
 	if (config == NULL || i2c == NULL)
 		goto error;
@@ -1005,22 +1007,35 @@ struct dvb_frontend *si2165_attach(const struct si2165_config *config,
 	if (io_ret < 0)
 		goto error;
 
-	dev_info(&state->i2c->dev, "%s: hardware revision 0x%02x, chip type 0x%02x\n",
-		 KBUILD_MODNAME, state->chip_revcode, state->chip_type);
+	if (state->chip_revcode < 26)
+		rev_char = 'A' + state->chip_revcode;
+	else
+		rev_char = '?';
 
-	/* It is a guess that register 0x0118 (chip type?) can be used to
-	 * differ between si2161, si2163 and si2165
-	 * Only si2165 has been tested.
-	 */
-	if (state->chip_type == 0x07) {
+	switch (state->chip_type) {
+	case 0x06:
+		chip_name = "Si2161";
+		state->has_dvbt = true;
+		break;
+	case 0x07:
+		chip_name = "Si2165";
 		state->has_dvbt = true;
 		state->has_dvbc = true;
-	} else {
-		dev_err(&state->i2c->dev, "%s: Unsupported chip.\n",
-			KBUILD_MODNAME);
+		break;
+	default:
+		dev_err(&state->i2c->dev, "%s: Unsupported Silicon Labs chip (type %d, rev %d)\n",
+			KBUILD_MODNAME, state->chip_type, state->chip_revcode);
 		goto error;
 	}
 
+	dev_info(&state->i2c->dev,
+		"%s: Detected Silicon Labs %s-%c (type %d, rev %d)\n",
+		KBUILD_MODNAME, chip_name, rev_char, state->chip_type,
+		state->chip_revcode);
+
+	strlcat(state->frontend.ops.info.name, chip_name,
+			sizeof(state->frontend.ops.info.name));
+
 	n = 0;
 	if (state->has_dvbt) {
 		state->frontend.ops.delsys[n++] = SYS_DVBT;
-- 
2.1.0

