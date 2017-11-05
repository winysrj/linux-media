Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:44638 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750753AbdKEOZQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 5 Nov 2017 09:25:16 -0500
From: Matthias Schwarzott <zzam@gentoo.org>
To: mchehab@kernel.org, linux-media@vger.kernel.org
Cc: Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH 02/15] si2165: Convert debug printk to dev_dbg
Date: Sun,  5 Nov 2017 15:24:58 +0100
Message-Id: <20171105142511.16563-2-zzam@gentoo.org>
In-Reply-To: <20171105142511.16563-1-zzam@gentoo.org>
References: <20171105142511.16563-1-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Removed module parameter debug and the conditions based on it.
Now it can be configured via dynamic debug.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/dvb-frontends/si2165.c | 79 +++++++-----------------------------
 1 file changed, 15 insertions(+), 64 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2165.c b/drivers/media/dvb-frontends/si2165.c
index 9471846ad424..7110b3b37f23 100644
--- a/drivers/media/dvb-frontends/si2165.c
+++ b/drivers/media/dvb-frontends/si2165.c
@@ -62,58 +62,12 @@ struct si2165_state {
 	bool firmware_loaded;
 };
 
-#define DEBUG_OTHER	0x01
-#define DEBUG_I2C_WRITE	0x02
-#define DEBUG_I2C_READ	0x04
-#define DEBUG_REG_READ	0x08
-#define DEBUG_REG_WRITE	0x10
-#define DEBUG_FW_LOAD	0x20
-
-static int debug = 0x00;
-
-#define dprintk(args...) \
-	do { \
-		if (debug & DEBUG_OTHER) \
-			printk(KERN_DEBUG "si2165: " args); \
-	} while (0)
-
-#define deb_i2c_write(args...) \
-	do { \
-		if (debug & DEBUG_I2C_WRITE) \
-			printk(KERN_DEBUG "si2165: i2c write: " args); \
-	} while (0)
-
-#define deb_i2c_read(args...) \
-	do { \
-		if (debug & DEBUG_I2C_READ) \
-			printk(KERN_DEBUG "si2165: i2c read: " args); \
-	} while (0)
-
-#define deb_readreg(args...) \
-	do { \
-		if (debug & DEBUG_REG_READ) \
-			printk(KERN_DEBUG "si2165: reg read: " args); \
-	} while (0)
-
-#define deb_writereg(args...) \
-	do { \
-		if (debug & DEBUG_REG_WRITE) \
-			printk(KERN_DEBUG "si2165: reg write: " args); \
-	} while (0)
-
-#define deb_fw_load(args...) \
-	do { \
-		if (debug & DEBUG_FW_LOAD) \
-			printk(KERN_DEBUG "si2165: fw load: " args); \
-	} while (0)
-
 static int si2165_write(struct si2165_state *state, const u16 reg,
 		       const u8 *src, const int count)
 {
 	int ret;
 
-	if (debug & DEBUG_I2C_WRITE)
-		deb_i2c_write("reg: 0x%04x, data: %*ph\n", reg, count, src);
+	dev_dbg(&state->client->dev, "i2c write: reg: 0x%04x, data: %*ph\n", reg, count, src);
 
 	ret = regmap_bulk_write(state->regmap, reg, src, count);
 
@@ -134,8 +88,7 @@ static int si2165_read(struct si2165_state *state,
 		return ret;
 	}
 
-	if (debug & DEBUG_I2C_READ)
-		deb_i2c_read("reg: 0x%04x, data: %*ph\n", reg, count, val);
+	dev_dbg(&state->client->dev, "i2c read: reg: 0x%04x, data: %*ph\n", reg, count, val);
 
 	return 0;
 }
@@ -146,7 +99,7 @@ static int si2165_readreg8(struct si2165_state *state,
 	unsigned int val_tmp;
 	int ret = regmap_read(state->regmap, reg, &val_tmp);
 	*val = (u8)val_tmp;
-	deb_readreg("R(0x%04x)=0x%02x\n", reg, *val);
+	dev_dbg(&state->client->dev, "reg read: R(0x%04x)=0x%02x\n", reg, *val);
 	return ret;
 }
 
@@ -157,7 +110,7 @@ static int si2165_readreg16(struct si2165_state *state,
 
 	int ret = si2165_read(state, reg, buf, 2);
 	*val = buf[0] | buf[1] << 8;
-	deb_readreg("R(0x%04x)=0x%04x\n", reg, *val);
+	dev_dbg(&state->client->dev, "reg read: R(0x%04x)=0x%04x\n", reg, *val);
 	return ret;
 }
 
@@ -332,12 +285,12 @@ static int si2165_upload_firmware_block(struct si2165_state *state,
 	if (len % 4 != 0)
 		return -EINVAL;
 
-	deb_fw_load(
-		"si2165_upload_firmware_block called with len=0x%x offset=0x%x blockcount=0x%x\n",
+	dev_dbg(&state->client->dev,
+		"fw load: si2165_upload_firmware_block called with len=0x%x offset=0x%x blockcount=0x%x\n",
 				len, offset, block_count);
 	while (offset+12 <= len && cur_block < block_count) {
-		deb_fw_load(
-			"si2165_upload_firmware_block in while len=0x%x offset=0x%x cur_block=0x%x blockcount=0x%x\n",
+		dev_dbg(&state->client->dev,
+			"fw load: si2165_upload_firmware_block in while len=0x%x offset=0x%x cur_block=0x%x blockcount=0x%x\n",
 					len, offset, cur_block, block_count);
 		wordcount = data[offset];
 		if (wordcount < 1 || data[offset+1] ||
@@ -376,14 +329,15 @@ static int si2165_upload_firmware_block(struct si2165_state *state,
 		cur_block++;
 	}
 
-	deb_fw_load(
-		"si2165_upload_firmware_block after while len=0x%x offset=0x%x cur_block=0x%x blockcount=0x%x\n",
+	dev_dbg(&state->client->dev,
+		"fw load: si2165_upload_firmware_block after while len=0x%x offset=0x%x cur_block=0x%x blockcount=0x%x\n",
 				len, offset, cur_block, block_count);
 
 	if (poffset)
 		*poffset = offset;
 
-	deb_fw_load("si2165_upload_firmware_block returned offset=0x%x\n",
+	dev_dbg(&state->client->dev,
+		"fw load: si2165_upload_firmware_block returned offset=0x%x\n",
 				offset);
 
 	return 0;
@@ -561,7 +515,7 @@ static int si2165_init(struct dvb_frontend *fe)
 	u8 val;
 	u8 patch_version = 0x00;
 
-	dprintk("%s: called\n", __func__);
+	dev_dbg(&state->client->dev, "%s: called\n", __func__);
 
 	/* powerup */
 	ret = si2165_writereg8(state, 0x0000, state->config.chip_mode);
@@ -722,7 +676,7 @@ static int si2165_set_oversamp(struct si2165_state *state, u32 dvb_rate)
 	do_div(oversamp, dvb_rate);
 	reg_value = oversamp & 0x3fffffff;
 
-	dprintk("%s: Write oversamp=%#x\n", __func__, reg_value);
+	dev_dbg(&state->client->dev, "Write oversamp=%#x\n", reg_value);
 	return si2165_writereg32(state, 0x00e4, reg_value);
 }
 
@@ -791,7 +745,7 @@ static int si2165_set_frontend_dvbt(struct dvb_frontend *fe)
 	u16 bw10k;
 	u32 bw_hz = p->bandwidth_hz;
 
-	dprintk("%s: called\n", __func__);
+	dev_dbg(&state->client->dev, "%s: called\n", __func__);
 
 	if (!state->has_dvbt)
 		return -EINVAL;
@@ -1166,9 +1120,6 @@ static struct i2c_driver si2165_driver = {
 
 module_i2c_driver(si2165_driver);
 
-module_param(debug, int, 0644);
-MODULE_PARM_DESC(debug, "Turn on/off frontend debugging (default:off).");
-
 MODULE_DESCRIPTION("Silicon Labs Si2165 DVB-C/-T Demodulator driver");
 MODULE_AUTHOR("Matthias Schwarzott <zzam@gentoo.org>");
 MODULE_LICENSE("GPL");
-- 
2.15.0
