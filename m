Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:45349 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093AbaHaLf3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Aug 2014 07:35:29 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org, m.chehab@samsung.com, crope@iki.fi,
	zzam@gentoo.org
Subject: [PATCH 1/7] si2165: Load driver for all hardware revisions
Date: Sun, 31 Aug 2014 13:35:06 +0200
Message-Id: <1409484912-19300-2-git-send-email-zzam@gentoo.org>
In-Reply-To: <1409484912-19300-1-git-send-email-zzam@gentoo.org>
References: <1409484912-19300-1-git-send-email-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Current firmware is only for revision D.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/dvb-frontends/si2165.c      | 26 +++++++++++++++++---------
 drivers/media/dvb-frontends/si2165_priv.h |  2 +-
 2 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2165.c b/drivers/media/dvb-frontends/si2165.c
index 3a2d6c5..65e0dc9 100644
--- a/drivers/media/dvb-frontends/si2165.c
+++ b/drivers/media/dvb-frontends/si2165.c
@@ -44,9 +44,7 @@ struct si2165_state {
 
 	struct si2165_config config;
 
-	/* chip revision */
-	u8 revcode;
-	/* chip type */
+	u8 chip_revcode;
 	u8 chip_type;
 
 	/* calculated by xtal and div settings */
@@ -407,7 +405,7 @@ static int si2165_upload_firmware(struct si2165_state *state)
 	int ret;
 
 	const struct firmware *fw = NULL;
-	u8 *fw_file = SI2165_FIRMWARE;
+	u8 *fw_file;
 	const u8 *data;
 	u32 len;
 	u32 offset;
@@ -415,10 +413,20 @@ static int si2165_upload_firmware(struct si2165_state *state)
 	u8 block_count;
 	u16 crc_expected;
 
+	switch (state->chip_revcode) {
+	case 0x03: /* revision D */
+		fw_file = SI2165_FIRMWARE_REV_D;
+		break;
+	default:
+		dev_info(&state->i2c->dev, "%s: no firmware file for revision=%d\n",
+			KBUILD_MODNAME, state->chip_revcode);
+		return 0;
+	}
+
 	/* request the firmware, this will block and timeout */
 	ret = request_firmware(&fw, fw_file, state->i2c->dev.parent);
 	if (ret) {
-		dev_warn(&state->i2c->dev, "%s: firmare file '%s' not found\n",
+		dev_warn(&state->i2c->dev, "%s: firmware file '%s' not found\n",
 				KBUILD_MODNAME, fw_file);
 		goto error;
 	}
@@ -984,7 +992,7 @@ struct dvb_frontend *si2165_attach(const struct si2165_config *config,
 	if (val != state->config.chip_mode)
 		goto error;
 
-	io_ret = si2165_readreg8(state, 0x0023 , &state->revcode);
+	io_ret = si2165_readreg8(state, 0x0023, &state->chip_revcode);
 	if (io_ret < 0)
 		goto error;
 
@@ -998,13 +1006,13 @@ struct dvb_frontend *si2165_attach(const struct si2165_config *config,
 		goto error;
 
 	dev_info(&state->i2c->dev, "%s: hardware revision 0x%02x, chip type 0x%02x\n",
-		 KBUILD_MODNAME, state->revcode, state->chip_type);
+		 KBUILD_MODNAME, state->chip_revcode, state->chip_type);
 
 	/* It is a guess that register 0x0118 (chip type?) can be used to
 	 * differ between si2161, si2163 and si2165
 	 * Only si2165 has been tested.
 	 */
-	if (state->revcode == 0x03 && state->chip_type == 0x07) {
+	if (state->chip_type == 0x07) {
 		state->has_dvbt = true;
 		state->has_dvbc = true;
 	} else {
@@ -1037,4 +1045,4 @@ MODULE_PARM_DESC(debug, "Turn on/off frontend debugging (default:off).");
 MODULE_DESCRIPTION("Silicon Labs Si2165 DVB-C/-T Demodulator driver");
 MODULE_AUTHOR("Matthias Schwarzott <zzam@gentoo.org>");
 MODULE_LICENSE("GPL");
-MODULE_FIRMWARE(SI2165_FIRMWARE);
+MODULE_FIRMWARE(SI2165_FIRMWARE_REV_D);
diff --git a/drivers/media/dvb-frontends/si2165_priv.h b/drivers/media/dvb-frontends/si2165_priv.h
index d4cc93f..2b70cf1 100644
--- a/drivers/media/dvb-frontends/si2165_priv.h
+++ b/drivers/media/dvb-frontends/si2165_priv.h
@@ -18,6 +18,6 @@
 #ifndef _DVB_SI2165_PRIV
 #define _DVB_SI2165_PRIV
 
-#define SI2165_FIRMWARE "dvb-demod-si2165.fw"
+#define SI2165_FIRMWARE_REV_D "dvb-demod-si2165.fw"
 
 #endif /* _DVB_SI2165_PRIV */
-- 
2.1.0

