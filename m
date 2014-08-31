Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:45377 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751237AbaHaLfj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Aug 2014 07:35:39 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org, m.chehab@samsung.com, crope@iki.fi,
	zzam@gentoo.org
Subject: [PATCH 7/7] si2165: do load firmware without extra header
Date: Sun, 31 Aug 2014 13:35:12 +0200
Message-Id: <1409484912-19300-8-git-send-email-zzam@gentoo.org>
In-Reply-To: <1409484912-19300-1-git-send-email-zzam@gentoo.org>
References: <1409484912-19300-1-git-send-email-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The new file has a different name: dvb-demod-si2165-D.fw

Count blocks instead of reading count from extra header.
Calculate CRC during upload and compare result to what chip calcuated.
Use 0x01 instead of real patch version, because this is only used to
check if something was uploaded but not to check the version of it.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/dvb-frontends/Kconfig       |   1 +
 drivers/media/dvb-frontends/si2165.c      | 105 ++++++++++++++++++------------
 drivers/media/dvb-frontends/si2165_priv.h |   2 +-
 3 files changed, 66 insertions(+), 42 deletions(-)

diff --git a/drivers/media/dvb-frontends/Kconfig b/drivers/media/dvb-frontends/Kconfig
index aa5ae22..c57ec49 100644
--- a/drivers/media/dvb-frontends/Kconfig
+++ b/drivers/media/dvb-frontends/Kconfig
@@ -66,6 +66,7 @@ config DVB_TDA18271C2DD
 config DVB_SI2165
 	tristate "Silicon Labs si2165 based"
 	depends on DVB_CORE && I2C
+	select CRC_ITU_T
 	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A DVB-C/T demodulator.
diff --git a/drivers/media/dvb-frontends/si2165.c b/drivers/media/dvb-frontends/si2165.c
index fe4e8f2..c807180 100644
--- a/drivers/media/dvb-frontends/si2165.c
+++ b/drivers/media/dvb-frontends/si2165.c
@@ -25,6 +25,7 @@
 #include <linux/string.h>
 #include <linux/slab.h>
 #include <linux/firmware.h>
+#include <linux/crc-itu-t.h>
 
 #include "dvb_frontend.h"
 #include "dvb_math.h"
@@ -327,8 +328,50 @@ static bool si2165_wait_init_done(struct si2165_state *state)
 	return ret;
 }
 
+static int si2165_count_fw_blocks(struct si2165_state *state, const u8 *data,
+				  u32 len)
+{
+	int block_count = 0;
+	u32 offset = 0;
+
+	if (len % 4 != 0) {
+		dev_warn(&state->i2c->dev, "%s: firmware size is not multiple of 4\n",
+				KBUILD_MODNAME);
+		return -EINVAL;
+	}
+
+	while (offset + 4 <= len) {
+		u8 wordcount = data[offset];
+
+		if (wordcount < 1 || data[offset+1] ||
+		    data[offset+2] || data[offset+3]) {
+			dev_warn(&state->i2c->dev,
+				 "%s: bad fw data[0..3] = %*ph at offset=%d\n",
+				KBUILD_MODNAME, 4, data, offset);
+			return -EINVAL;
+		}
+		offset += 8 + 4 * wordcount;
+		++block_count;
+	}
+	if (offset != len) {
+		dev_warn(&state->i2c->dev,
+				"%s: firmware length does not match content, len=%d, offset=%d\n",
+			KBUILD_MODNAME, len, offset);
+		return -EINVAL;
+	}
+	if (block_count < 6) {
+		dev_err(&state->i2c->dev, "%s: firmware is too short: Only %d blocks\n",
+			KBUILD_MODNAME, block_count);
+		return -EINVAL;
+	}
+	block_count -= 6;
+	dev_info(&state->i2c->dev, "%s: si2165_upload_firmware counted %d main blocks\n",
+		KBUILD_MODNAME, block_count);
+	return block_count;
+}
+
 static int si2165_upload_firmware_block(struct si2165_state *state,
-	const u8 *data, u32 len, u32 *poffset, u32 block_count)
+	const u8 *data, u32 len, u32 *poffset, u32 block_count, u16 *crc)
 {
 	int ret;
 	u8 buf_ctrl[4] = { 0x00, 0x00, 0x00, 0xc0 };
@@ -374,6 +417,10 @@ static int si2165_upload_firmware_block(struct si2165_state *state,
 		offset += 8;
 
 		while (wordcount > 0) {
+			*crc = crc_itu_t_byte(*crc, *(data+offset+3));
+			*crc = crc_itu_t_byte(*crc, *(data+offset+2));
+			*crc = crc_itu_t_byte(*crc, *(data+offset+1));
+			*crc = crc_itu_t_byte(*crc, *(data+offset+0));
 			ret = si2165_write(state, 0x36c, data+offset, 4);
 			if (ret < 0)
 				goto error;
@@ -408,10 +455,9 @@ static int si2165_upload_firmware(struct si2165_state *state)
 	u8 *fw_file;
 	const u8 *data;
 	u32 len;
-	u32 offset;
-	u8 patch_version;
-	u8 block_count;
-	u16 crc_expected;
+	u32 offset = 0;
+	int main_block_count;
+	u16 crc = 0;
 
 	switch (state->chip_revcode) {
 	case 0x03: /* revision D */
@@ -437,32 +483,13 @@ static int si2165_upload_firmware(struct si2165_state *state)
 	dev_info(&state->i2c->dev, "%s: downloading firmware from file '%s' size=%d\n",
 			KBUILD_MODNAME, fw_file, len);
 
-	if (len % 4 != 0) {
-		dev_warn(&state->i2c->dev, "%s: firmware size is not multiple of 4\n",
-				KBUILD_MODNAME);
-		ret = -EINVAL;
-		goto error;
-	}
-
-	/* check header (8 bytes) */
-	if (len < 8) {
-		dev_warn(&state->i2c->dev, "%s: firmware header is missing\n",
-				KBUILD_MODNAME);
-		ret = -EINVAL;
-		goto error;
-	}
-
-	if (data[0] != 1 || data[1] != 0) {
-		dev_warn(&state->i2c->dev, "%s: firmware file version is wrong\n",
-				KBUILD_MODNAME);
-		ret = -EINVAL;
-		goto error;
+	main_block_count = si2165_count_fw_blocks(state, data, len);
+	if (main_block_count < 0) {
+		dev_err(&state->i2c->dev, "%s: si2165_upload_firmware: cannot use firmware, skip\n",
+			KBUILD_MODNAME);
+		return main_block_count;
 	}
 
-	patch_version = data[2];
-	block_count = data[4];
-	crc_expected = data[7] << 8 | data[6];
-
 	/* start uploading fw */
 	/* boot/wdog status */
 	ret = si2165_writereg8(state, 0x0341, 0x00);
@@ -488,17 +515,12 @@ static int si2165_upload_firmware(struct si2165_state *state)
 	if (ret < 0)
 		goto error;
 
-	/* start right after the header */
-	offset = 8;
-
-	dev_info(&state->i2c->dev, "%s: si2165_upload_firmware extracted patch_version=0x%02x, block_count=0x%02x, crc_expected=0x%04x\n",
-		KBUILD_MODNAME, patch_version, block_count, crc_expected);
-
-	ret = si2165_upload_firmware_block(state, data, len, &offset, 1);
+	ret = si2165_upload_firmware_block(state, data, len, &offset, 1, &crc);
 	if (ret < 0)
 		goto error;
 
-	ret = si2165_writereg8(state, 0x0344, patch_version);
+	/* patch version, just write a number different from the default 0x00 */
+	ret = si2165_writereg8(state, 0x0344, 0x01);
 	if (ret < 0)
 		goto error;
 
@@ -506,9 +528,10 @@ static int si2165_upload_firmware(struct si2165_state *state)
 	ret = si2165_writereg8(state, 0x0379, 0x01);
 	if (ret)
 		return ret;
+	crc = 0;
 
 	ret = si2165_upload_firmware_block(state, data, len,
-					   &offset, block_count);
+					   &offset, main_block_count, &crc);
 	if (ret < 0) {
 		dev_err(&state->i2c->dev,
 			"%s: firmare could not be uploaded\n",
@@ -521,15 +544,15 @@ static int si2165_upload_firmware(struct si2165_state *state)
 	if (ret)
 		goto error;
 
-	if (val16 != crc_expected) {
+	if (val16 != crc) {
 		dev_err(&state->i2c->dev,
 			"%s: firmware crc mismatch %04x != %04x\n",
-			KBUILD_MODNAME, val16, crc_expected);
+			KBUILD_MODNAME, val16, crc);
 		ret = -EINVAL;
 		goto error;
 	}
 
-	ret = si2165_upload_firmware_block(state, data, len, &offset, 5);
+	ret = si2165_upload_firmware_block(state, data, len, &offset, 5, &crc);
 	if (ret)
 		goto error;
 
diff --git a/drivers/media/dvb-frontends/si2165_priv.h b/drivers/media/dvb-frontends/si2165_priv.h
index 2b70cf1..fd778dc 100644
--- a/drivers/media/dvb-frontends/si2165_priv.h
+++ b/drivers/media/dvb-frontends/si2165_priv.h
@@ -18,6 +18,6 @@
 #ifndef _DVB_SI2165_PRIV
 #define _DVB_SI2165_PRIV
 
-#define SI2165_FIRMWARE_REV_D "dvb-demod-si2165.fw"
+#define SI2165_FIRMWARE_REV_D "dvb-demod-si2165-D.fw"
 
 #endif /* _DVB_SI2165_PRIV */
-- 
2.1.0

