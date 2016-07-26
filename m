Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:55130 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755456AbcGZHJo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jul 2016 03:09:44 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, crope@iki.fi,
	Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH 7/7] si2165: switch to regmap
Date: Tue, 26 Jul 2016 09:09:08 +0200
Message-Id: <20160726070908.10135-7-zzam@gentoo.org>
In-Reply-To: <20160726070908.10135-1-zzam@gentoo.org>
References: <20160726070908.10135-1-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This avoids some low-level operations.
It has the benefit that now register values van be read from /sys/kernel/debug/regmap
The maximum register value is just a guess - all higher addresses read as zero.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/dvb-frontends/Kconfig  |  1 +
 drivers/media/dvb-frontends/si2165.c | 70 +++++++++++++-----------------------
 2 files changed, 25 insertions(+), 46 deletions(-)

diff --git a/drivers/media/dvb-frontends/Kconfig b/drivers/media/dvb-frontends/Kconfig
index c645aa8..8272c08 100644
--- a/drivers/media/dvb-frontends/Kconfig
+++ b/drivers/media/dvb-frontends/Kconfig
@@ -67,6 +67,7 @@ config DVB_TDA18271C2DD
 config DVB_SI2165
 	tristate "Silicon Labs si2165 based"
 	depends on DVB_CORE && I2C
+	select REGMAP_I2C
 	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A DVB-C/T demodulator.
diff --git a/drivers/media/dvb-frontends/si2165.c b/drivers/media/dvb-frontends/si2165.c
index 9bf6609..d63cd73 100644
--- a/drivers/media/dvb-frontends/si2165.c
+++ b/drivers/media/dvb-frontends/si2165.c
@@ -25,6 +25,7 @@
 #include <linux/string.h>
 #include <linux/slab.h>
 #include <linux/firmware.h>
+#include <linux/regmap.h>
 
 #include "dvb_frontend.h"
 #include "dvb_math.h"
@@ -42,7 +43,7 @@
 struct si2165_state {
 	struct i2c_client *client;
 
-	struct i2c_adapter *i2c;
+	struct regmap *regmap;
 
 	struct dvb_frontend fe;
 
@@ -110,61 +111,27 @@ static int si2165_write(struct si2165_state *state, const u16 reg,
 		       const u8 *src, const int count)
 {
 	int ret;
-	struct i2c_msg msg;
-	u8 buf[2 + 4]; /* write a maximum of 4 bytes of data */
-
-	if (count + 2 > sizeof(buf)) {
-		dev_warn(&state->client->dev,
-			  "%s: i2c wr reg=%04x: count=%d is too big!\n",
-			  KBUILD_MODNAME, reg, count);
-		return -EINVAL;
-	}
-	buf[0] = reg >> 8;
-	buf[1] = reg & 0xff;
-	memcpy(buf + 2, src, count);
-
-	msg.addr = state->config.i2c_addr;
-	msg.flags = 0;
-	msg.buf = buf;
-	msg.len = count + 2;
 
 	if (debug & DEBUG_I2C_WRITE)
 		deb_i2c_write("reg: 0x%04x, data: %*ph\n", reg, count, src);
 
-	ret = i2c_transfer(state->i2c, &msg, 1);
+	ret = regmap_bulk_write(state->regmap, reg, src, count);
 
-	if (ret != 1) {
+	if (ret)
 		dev_err(&state->client->dev, "%s: ret == %d\n", __func__, ret);
-		if (ret < 0)
-			return ret;
-		else
-			return -EREMOTEIO;
-	}
 
-	return 0;
+	return ret;
 }
 
 static int si2165_read(struct si2165_state *state,
 		       const u16 reg, u8 *val, const int count)
 {
-	int ret;
-	u8 reg_buf[] = { reg >> 8, reg & 0xff };
-	struct i2c_msg msg[] = {
-		{ .addr = state->config.i2c_addr,
-		  .flags = 0, .buf = reg_buf, .len = 2 },
-		{ .addr = state->config.i2c_addr,
-		  .flags = I2C_M_RD, .buf = val, .len = count },
-	};
+	int ret = regmap_bulk_read(state->regmap, reg, val, count);
 
-	ret = i2c_transfer(state->i2c, msg, 2);
-
-	if (ret != 2) {
+	if (ret) {
 		dev_err(&state->client->dev, "%s: error (addr %02x reg %04x error (ret == %i)\n",
 			__func__, state->config.i2c_addr, reg, ret);
-		if (ret < 0)
-			return ret;
-		else
-			return -EREMOTEIO;
+		return ret;
 	}
 
 	if (debug & DEBUG_I2C_READ)
@@ -176,9 +143,9 @@ static int si2165_read(struct si2165_state *state,
 static int si2165_readreg8(struct si2165_state *state,
 		       const u16 reg, u8 *val)
 {
-	int ret;
-
-	ret = si2165_read(state, reg, val, 1);
+	unsigned int val_tmp;
+	int ret = regmap_read(state->regmap, reg, &val_tmp);
+	*val = (u8)val_tmp;
 	deb_readreg("R(0x%04x)=0x%02x\n", reg, *val);
 	return ret;
 }
@@ -196,7 +163,7 @@ static int si2165_readreg16(struct si2165_state *state,
 
 static int si2165_writereg8(struct si2165_state *state, const u16 reg, u8 val)
 {
-	return si2165_write(state, reg, &val, 1);
+	return regmap_write(state->regmap, reg, val);
 }
 
 static int si2165_writereg16(struct si2165_state *state, const u16 reg, u16 val)
@@ -1052,6 +1019,11 @@ static int si2165_probe(struct i2c_client *client,
 	u8 val;
 	char rev_char;
 	const char *chip_name;
+	static const struct regmap_config regmap_config = {
+		.reg_bits = 16,
+		.val_bits = 8,
+		.max_register = 0x08ff,
+	};
 
 	/* allocate memory for the internal state */
 	state = kzalloc(sizeof(struct si2165_state), GFP_KERNEL);
@@ -1060,9 +1032,15 @@ static int si2165_probe(struct i2c_client *client,
 		goto error;
 	}
 
+	/* create regmap */
+	state->regmap = devm_regmap_init_i2c(client, &regmap_config);
+	if (IS_ERR(state->regmap)) {
+		ret = PTR_ERR(state->regmap);
+		goto error;
+	}
+
 	/* setup the state */
 	state->client = client;
-	state->i2c = client->adapter;
 	state->config.i2c_addr = client->addr;
 	state->config.chip_mode = pdata->chip_mode;
 	state->config.ref_freq_Hz = pdata->ref_freq_Hz;
-- 
2.9.2

