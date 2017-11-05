Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:44624 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750753AbdKEOZH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 5 Nov 2017 09:25:07 -0500
From: Matthias Schwarzott <zzam@gentoo.org>
To: mchehab@kernel.org, linux-media@vger.kernel.org
Cc: Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH 01/15] si2165: Remove redundant KBUILD_MODNAME from dev_* logging
Date: Sun,  5 Nov 2017 15:24:57 +0100
Message-Id: <20171105142511.16563-1-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove redundant repeated module name from messages.

Before:
  si2165 8-0064: si2165: fw load finished

After:
  si2165 8-0064: fw load finished

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/dvb-frontends/si2165.c | 69 ++++++++++++++++--------------------
 1 file changed, 31 insertions(+), 38 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2165.c b/drivers/media/dvb-frontends/si2165.c
index 528b82a5dd46..9471846ad424 100644
--- a/drivers/media/dvb-frontends/si2165.c
+++ b/drivers/media/dvb-frontends/si2165.c
@@ -1,7 +1,7 @@
 /*
  *  Driver for Silicon Labs Si2161 DVB-T and Si2165 DVB-C/-T Demodulator
  *
- *  Copyright (C) 2013-2014 Matthias Schwarzott <zzam@gentoo.org>
+ *  Copyright (C) 2013-2017 Matthias Schwarzott <zzam@gentoo.org>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -314,8 +314,7 @@ static int si2165_wait_init_done(struct si2165_state *state)
 			return 0;
 		usleep_range(1000, 50000);
 	}
-	dev_err(&state->client->dev, "%s: init_done was not set\n",
-		KBUILD_MODNAME);
+	dev_err(&state->client->dev, "init_done was not set\n");
 	return ret;
 }
 
@@ -344,15 +343,15 @@ static int si2165_upload_firmware_block(struct si2165_state *state,
 		if (wordcount < 1 || data[offset+1] ||
 		    data[offset+2] || data[offset+3]) {
 			dev_warn(&state->client->dev,
-				 "%s: bad fw data[0..3] = %*ph\n",
-				KBUILD_MODNAME, 4, data);
+				 "bad fw data[0..3] = %*ph\n",
+				 4, data);
 			return -EINVAL;
 		}
 
 		if (offset + 8 + wordcount * 4 > len) {
 			dev_warn(&state->client->dev,
-				 "%s: len is too small for block len=%d, wordcount=%d\n",
-				KBUILD_MODNAME, len, wordcount);
+				 "len is too small for block len=%d, wordcount=%d\n",
+				len, wordcount);
 			return -EINVAL;
 		}
 
@@ -413,43 +412,40 @@ static int si2165_upload_firmware(struct si2165_state *state)
 		fw_file = SI2165_FIRMWARE_REV_D;
 		break;
 	default:
-		dev_info(&state->client->dev, "%s: no firmware file for revision=%d\n",
-			KBUILD_MODNAME, state->chip_revcode);
+		dev_info(&state->client->dev, "no firmware file for revision=%d\n",
+			state->chip_revcode);
 		return 0;
 	}
 
 	/* request the firmware, this will block and timeout */
 	ret = request_firmware(&fw, fw_file, &state->client->dev);
 	if (ret) {
-		dev_warn(&state->client->dev, "%s: firmware file '%s' not found\n",
-				KBUILD_MODNAME, fw_file);
+		dev_warn(&state->client->dev, "firmware file '%s' not found\n",
+			fw_file);
 		goto error;
 	}
 
 	data = fw->data;
 	len = fw->size;
 
-	dev_info(&state->client->dev, "%s: downloading firmware from file '%s' size=%d\n",
-			KBUILD_MODNAME, fw_file, len);
+	dev_info(&state->client->dev, "downloading firmware from file '%s' size=%d\n",
+			fw_file, len);
 
 	if (len % 4 != 0) {
-		dev_warn(&state->client->dev, "%s: firmware size is not multiple of 4\n",
-				KBUILD_MODNAME);
+		dev_warn(&state->client->dev, "firmware size is not multiple of 4\n");
 		ret = -EINVAL;
 		goto error;
 	}
 
 	/* check header (8 bytes) */
 	if (len < 8) {
-		dev_warn(&state->client->dev, "%s: firmware header is missing\n",
-				KBUILD_MODNAME);
+		dev_warn(&state->client->dev, "firmware header is missing\n");
 		ret = -EINVAL;
 		goto error;
 	}
 
 	if (data[0] != 1 || data[1] != 0) {
-		dev_warn(&state->client->dev, "%s: firmware file version is wrong\n",
-				KBUILD_MODNAME);
+		dev_warn(&state->client->dev, "firmware file version is wrong\n");
 		ret = -EINVAL;
 		goto error;
 	}
@@ -486,8 +482,8 @@ static int si2165_upload_firmware(struct si2165_state *state)
 	/* start right after the header */
 	offset = 8;
 
-	dev_info(&state->client->dev, "%s: si2165_upload_firmware extracted patch_version=0x%02x, block_count=0x%02x, crc_expected=0x%04x\n",
-		KBUILD_MODNAME, patch_version, block_count, crc_expected);
+	dev_info(&state->client->dev, "si2165_upload_firmware extracted patch_version=0x%02x, block_count=0x%02x, crc_expected=0x%04x\n",
+		patch_version, block_count, crc_expected);
 
 	ret = si2165_upload_firmware_block(state, data, len, &offset, 1);
 	if (ret < 0)
@@ -506,8 +502,7 @@ static int si2165_upload_firmware(struct si2165_state *state)
 					   &offset, block_count);
 	if (ret < 0) {
 		dev_err(&state->client->dev,
-			"%s: firmware could not be uploaded\n",
-			KBUILD_MODNAME);
+			"firmware could not be uploaded\n");
 		goto error;
 	}
 
@@ -518,8 +513,8 @@ static int si2165_upload_firmware(struct si2165_state *state)
 
 	if (val16 != crc_expected) {
 		dev_err(&state->client->dev,
-			"%s: firmware crc mismatch %04x != %04x\n",
-			KBUILD_MODNAME, val16, crc_expected);
+			"firmware crc mismatch %04x != %04x\n",
+			val16, crc_expected);
 		ret = -EINVAL;
 		goto error;
 	}
@@ -530,8 +525,8 @@ static int si2165_upload_firmware(struct si2165_state *state)
 
 	if (len != offset) {
 		dev_err(&state->client->dev,
-			"%s: firmware len mismatch %04x != %04x\n",
-			KBUILD_MODNAME, len, offset);
+			"firmware len mismatch %04x != %04x\n",
+			len, offset);
 		ret = -EINVAL;
 		goto error;
 	}
@@ -546,7 +541,7 @@ static int si2165_upload_firmware(struct si2165_state *state)
 	if (ret < 0)
 		goto error;
 
-	dev_info(&state->client->dev, "%s: fw load finished\n", KBUILD_MODNAME);
+	dev_info(&state->client->dev, "fw load finished\n");
 
 	ret = 0;
 	state->firmware_loaded = true;
@@ -580,8 +575,7 @@ static int si2165_init(struct dvb_frontend *fe)
 	if (ret < 0)
 		goto error;
 	if (val != state->config.chip_mode) {
-		dev_err(&state->client->dev, "%s: could not set chip_mode\n",
-			KBUILD_MODNAME);
+		dev_err(&state->client->dev, "could not set chip_mode\n");
 		return -EINVAL;
 	}
 
@@ -742,8 +736,7 @@ static int si2165_set_if_freq_shift(struct si2165_state *state)
 
 	if (!fe->ops.tuner_ops.get_if_frequency) {
 		dev_err(&state->client->dev,
-			"%s: Error: get_if_frequency() not defined at tuner. Can't work without it!\n",
-			KBUILD_MODNAME);
+			"Error: get_if_frequency() not defined at tuner. Can't work without it!\n");
 		return -EINVAL;
 	}
 
@@ -1054,8 +1047,8 @@ static int si2165_probe(struct i2c_client *client,
 
 	if (state->config.ref_freq_Hz < 4000000
 	    || state->config.ref_freq_Hz > 27000000) {
-		dev_err(&state->client->dev, "%s: ref_freq of %d Hz not supported by this driver\n",
-			 KBUILD_MODNAME, state->config.ref_freq_Hz);
+		dev_err(&state->client->dev, "ref_freq of %d Hz not supported by this driver\n",
+			 state->config.ref_freq_Hz);
 		ret = -EINVAL;
 		goto error;
 	}
@@ -1107,14 +1100,14 @@ static int si2165_probe(struct i2c_client *client,
 		state->has_dvbc = true;
 		break;
 	default:
-		dev_err(&state->client->dev, "%s: Unsupported Silicon Labs chip (type %d, rev %d)\n",
-			KBUILD_MODNAME, state->chip_type, state->chip_revcode);
+		dev_err(&state->client->dev, "Unsupported Silicon Labs chip (type %d, rev %d)\n",
+			state->chip_type, state->chip_revcode);
 		goto nodev_error;
 	}
 
 	dev_info(&state->client->dev,
-		"%s: Detected Silicon Labs %s-%c (type %d, rev %d)\n",
-		KBUILD_MODNAME, chip_name, rev_char, state->chip_type,
+		"Detected Silicon Labs %s-%c (type %d, rev %d)\n",
+		chip_name, rev_char, state->chip_type,
 		state->chip_revcode);
 
 	strlcat(state->fe.ops.info.name, chip_name,
-- 
2.15.0
