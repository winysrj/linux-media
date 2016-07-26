Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:55126 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755133AbcGZHJn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jul 2016 03:09:43 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, crope@iki.fi,
	Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH 6/7] si2165: use i2c_client->dev instead of i2c_adapter->dev for logging
Date: Tue, 26 Jul 2016 09:09:07 +0200
Message-Id: <20160726070908.10135-6-zzam@gentoo.org>
In-Reply-To: <20160726070908.10135-1-zzam@gentoo.org>
References: <20160726070908.10135-1-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that there is a i2c_client, use the more specific dev for logging.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/dvb-frontends/si2165.c | 46 ++++++++++++++++++------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2165.c b/drivers/media/dvb-frontends/si2165.c
index e979fc0..9bf6609 100644
--- a/drivers/media/dvb-frontends/si2165.c
+++ b/drivers/media/dvb-frontends/si2165.c
@@ -114,7 +114,7 @@ static int si2165_write(struct si2165_state *state, const u16 reg,
 	u8 buf[2 + 4]; /* write a maximum of 4 bytes of data */
 
 	if (count + 2 > sizeof(buf)) {
-		dev_warn(&state->i2c->dev,
+		dev_warn(&state->client->dev,
 			  "%s: i2c wr reg=%04x: count=%d is too big!\n",
 			  KBUILD_MODNAME, reg, count);
 		return -EINVAL;
@@ -134,7 +134,7 @@ static int si2165_write(struct si2165_state *state, const u16 reg,
 	ret = i2c_transfer(state->i2c, &msg, 1);
 
 	if (ret != 1) {
-		dev_err(&state->i2c->dev, "%s: ret == %d\n", __func__, ret);
+		dev_err(&state->client->dev, "%s: ret == %d\n", __func__, ret);
 		if (ret < 0)
 			return ret;
 		else
@@ -159,7 +159,7 @@ static int si2165_read(struct si2165_state *state,
 	ret = i2c_transfer(state->i2c, msg, 2);
 
 	if (ret != 2) {
-		dev_err(&state->i2c->dev, "%s: error (addr %02x reg %04x error (ret == %i)\n",
+		dev_err(&state->client->dev, "%s: error (addr %02x reg %04x error (ret == %i)\n",
 			__func__, state->config.i2c_addr, reg, ret);
 		if (ret < 0)
 			return ret;
@@ -347,7 +347,7 @@ static int si2165_wait_init_done(struct si2165_state *state)
 			return 0;
 		usleep_range(1000, 50000);
 	}
-	dev_err(&state->i2c->dev, "%s: init_done was not set\n",
+	dev_err(&state->client->dev, "%s: init_done was not set\n",
 		KBUILD_MODNAME);
 	return ret;
 }
@@ -376,14 +376,14 @@ static int si2165_upload_firmware_block(struct si2165_state *state,
 		wordcount = data[offset];
 		if (wordcount < 1 || data[offset+1] ||
 		    data[offset+2] || data[offset+3]) {
-			dev_warn(&state->i2c->dev,
+			dev_warn(&state->client->dev,
 				 "%s: bad fw data[0..3] = %*ph\n",
 				KBUILD_MODNAME, 4, data);
 			return -EINVAL;
 		}
 
 		if (offset + 8 + wordcount * 4 > len) {
-			dev_warn(&state->i2c->dev,
+			dev_warn(&state->client->dev,
 				 "%s: len is too small for block len=%d, wordcount=%d\n",
 				KBUILD_MODNAME, len, wordcount);
 			return -EINVAL;
@@ -446,15 +446,15 @@ static int si2165_upload_firmware(struct si2165_state *state)
 		fw_file = SI2165_FIRMWARE_REV_D;
 		break;
 	default:
-		dev_info(&state->i2c->dev, "%s: no firmware file for revision=%d\n",
+		dev_info(&state->client->dev, "%s: no firmware file for revision=%d\n",
 			KBUILD_MODNAME, state->chip_revcode);
 		return 0;
 	}
 
 	/* request the firmware, this will block and timeout */
-	ret = request_firmware(&fw, fw_file, state->i2c->dev.parent);
+	ret = request_firmware(&fw, fw_file, &state->client->dev);
 	if (ret) {
-		dev_warn(&state->i2c->dev, "%s: firmware file '%s' not found\n",
+		dev_warn(&state->client->dev, "%s: firmware file '%s' not found\n",
 				KBUILD_MODNAME, fw_file);
 		goto error;
 	}
@@ -462,11 +462,11 @@ static int si2165_upload_firmware(struct si2165_state *state)
 	data = fw->data;
 	len = fw->size;
 
-	dev_info(&state->i2c->dev, "%s: downloading firmware from file '%s' size=%d\n",
+	dev_info(&state->client->dev, "%s: downloading firmware from file '%s' size=%d\n",
 			KBUILD_MODNAME, fw_file, len);
 
 	if (len % 4 != 0) {
-		dev_warn(&state->i2c->dev, "%s: firmware size is not multiple of 4\n",
+		dev_warn(&state->client->dev, "%s: firmware size is not multiple of 4\n",
 				KBUILD_MODNAME);
 		ret = -EINVAL;
 		goto error;
@@ -474,14 +474,14 @@ static int si2165_upload_firmware(struct si2165_state *state)
 
 	/* check header (8 bytes) */
 	if (len < 8) {
-		dev_warn(&state->i2c->dev, "%s: firmware header is missing\n",
+		dev_warn(&state->client->dev, "%s: firmware header is missing\n",
 				KBUILD_MODNAME);
 		ret = -EINVAL;
 		goto error;
 	}
 
 	if (data[0] != 1 || data[1] != 0) {
-		dev_warn(&state->i2c->dev, "%s: firmware file version is wrong\n",
+		dev_warn(&state->client->dev, "%s: firmware file version is wrong\n",
 				KBUILD_MODNAME);
 		ret = -EINVAL;
 		goto error;
@@ -519,7 +519,7 @@ static int si2165_upload_firmware(struct si2165_state *state)
 	/* start right after the header */
 	offset = 8;
 
-	dev_info(&state->i2c->dev, "%s: si2165_upload_firmware extracted patch_version=0x%02x, block_count=0x%02x, crc_expected=0x%04x\n",
+	dev_info(&state->client->dev, "%s: si2165_upload_firmware extracted patch_version=0x%02x, block_count=0x%02x, crc_expected=0x%04x\n",
 		KBUILD_MODNAME, patch_version, block_count, crc_expected);
 
 	ret = si2165_upload_firmware_block(state, data, len, &offset, 1);
@@ -538,7 +538,7 @@ static int si2165_upload_firmware(struct si2165_state *state)
 	ret = si2165_upload_firmware_block(state, data, len,
 					   &offset, block_count);
 	if (ret < 0) {
-		dev_err(&state->i2c->dev,
+		dev_err(&state->client->dev,
 			"%s: firmware could not be uploaded\n",
 			KBUILD_MODNAME);
 		goto error;
@@ -550,7 +550,7 @@ static int si2165_upload_firmware(struct si2165_state *state)
 		goto error;
 
 	if (val16 != crc_expected) {
-		dev_err(&state->i2c->dev,
+		dev_err(&state->client->dev,
 			"%s: firmware crc mismatch %04x != %04x\n",
 			KBUILD_MODNAME, val16, crc_expected);
 		ret = -EINVAL;
@@ -562,7 +562,7 @@ static int si2165_upload_firmware(struct si2165_state *state)
 		goto error;
 
 	if (len != offset) {
-		dev_err(&state->i2c->dev,
+		dev_err(&state->client->dev,
 			"%s: firmware len mismatch %04x != %04x\n",
 			KBUILD_MODNAME, len, offset);
 		ret = -EINVAL;
@@ -579,7 +579,7 @@ static int si2165_upload_firmware(struct si2165_state *state)
 	if (ret < 0)
 		goto error;
 
-	dev_info(&state->i2c->dev, "%s: fw load finished\n", KBUILD_MODNAME);
+	dev_info(&state->client->dev, "%s: fw load finished\n", KBUILD_MODNAME);
 
 	ret = 0;
 	state->firmware_loaded = true;
@@ -613,7 +613,7 @@ static int si2165_init(struct dvb_frontend *fe)
 	if (ret < 0)
 		goto error;
 	if (val != state->config.chip_mode) {
-		dev_err(&state->i2c->dev, "%s: could not set chip_mode\n",
+		dev_err(&state->client->dev, "%s: could not set chip_mode\n",
 			KBUILD_MODNAME);
 		return -EINVAL;
 	}
@@ -771,7 +771,7 @@ static int si2165_set_if_freq_shift(struct si2165_state *state)
 	u32 IF = 0;
 
 	if (!fe->ops.tuner_ops.get_if_frequency) {
-		dev_err(&state->i2c->dev,
+		dev_err(&state->client->dev,
 			"%s: Error: get_if_frequency() not defined at tuner. Can't work without it!\n",
 			KBUILD_MODNAME);
 		return -EINVAL;
@@ -1070,7 +1070,7 @@ static int si2165_probe(struct i2c_client *client,
 
 	if (state->config.ref_freq_Hz < 4000000
 	    || state->config.ref_freq_Hz > 27000000) {
-		dev_err(&state->i2c->dev, "%s: ref_freq of %d Hz not supported by this driver\n",
+		dev_err(&state->client->dev, "%s: ref_freq of %d Hz not supported by this driver\n",
 			 KBUILD_MODNAME, state->config.ref_freq_Hz);
 		ret = -EINVAL;
 		goto error;
@@ -1123,12 +1123,12 @@ static int si2165_probe(struct i2c_client *client,
 		state->has_dvbc = true;
 		break;
 	default:
-		dev_err(&state->i2c->dev, "%s: Unsupported Silicon Labs chip (type %d, rev %d)\n",
+		dev_err(&state->client->dev, "%s: Unsupported Silicon Labs chip (type %d, rev %d)\n",
 			KBUILD_MODNAME, state->chip_type, state->chip_revcode);
 		goto nodev_error;
 	}
 
-	dev_info(&state->i2c->dev,
+	dev_info(&state->client->dev,
 		"%s: Detected Silicon Labs %s-%c (type %d, rev %d)\n",
 		KBUILD_MODNAME, chip_name, rev_char, state->chip_type,
 		state->chip_revcode);
-- 
2.9.2

