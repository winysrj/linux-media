Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43503 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752043AbbEEV67 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 May 2015 17:58:59 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 07/21] fc2580: use regmap for register I2C access
Date: Wed,  6 May 2015 00:58:28 +0300
Message-Id: <1430863122-9888-7-git-send-email-crope@iki.fi>
In-Reply-To: <1430863122-9888-1-git-send-email-crope@iki.fi>
References: <1430863122-9888-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace home made register access routines with regmap.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/Kconfig       |   1 +
 drivers/media/tuners/fc2580.c      | 216 +++++++++++--------------------------
 drivers/media/tuners/fc2580_priv.h |   4 +-
 3 files changed, 66 insertions(+), 155 deletions(-)

diff --git a/drivers/media/tuners/Kconfig b/drivers/media/tuners/Kconfig
index 983510d..e826453 100644
--- a/drivers/media/tuners/Kconfig
+++ b/drivers/media/tuners/Kconfig
@@ -220,6 +220,7 @@ config MEDIA_TUNER_E4000
 config MEDIA_TUNER_FC2580
 	tristate "FCI FC2580 silicon tuner"
 	depends on MEDIA_SUPPORT && I2C
+	select REGMAP_I2C
 	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  FCI FC2580 silicon tuner driver.
diff --git a/drivers/media/tuners/fc2580.c b/drivers/media/tuners/fc2580.c
index f4b31db5..08838b4 100644
--- a/drivers/media/tuners/fc2580.c
+++ b/drivers/media/tuners/fc2580.c
@@ -20,109 +20,13 @@
 
 #include "fc2580_priv.h"
 
-/* Max transfer size done by I2C transfer functions */
-#define MAX_XFER_SIZE  64
-
 /*
  * TODO:
  * I2C write and read works only for one single register. Multiple registers
  * could not be accessed using normal register address auto-increment.
  * There could be (very likely) register to change that behavior....
- *
- * Due to that limitation functions:
- *   fc2580_wr_regs()
- *   fc2580_rd_regs()
- * could not be used for accessing more than one register at once.
  */
 
-/* write multiple registers */
-static int fc2580_wr_regs(struct fc2580_dev *dev, u8 reg, u8 *val, int len)
-{
-	struct i2c_client *client = dev->client;
-	int ret;
-	u8 buf[MAX_XFER_SIZE];
-	struct i2c_msg msg[1] = {
-		{
-			.addr = dev->i2c_addr,
-			.flags = 0,
-			.len = 1 + len,
-			.buf = buf,
-		}
-	};
-
-	if (1 + len > sizeof(buf)) {
-		dev_warn(&client->dev,
-			 "%s: i2c wr reg=%04x: len=%d is too big!\n",
-			 KBUILD_MODNAME, reg, len);
-		return -EINVAL;
-	}
-
-	buf[0] = reg;
-	memcpy(&buf[1], val, len);
-
-	ret = i2c_transfer(dev->i2c, msg, 1);
-	if (ret == 1) {
-		ret = 0;
-	} else {
-		dev_warn(&dev->i2c->dev, "%s: i2c wr failed=%d reg=%02x len=%d\n",
-			 KBUILD_MODNAME, ret, reg, len);
-		ret = -EREMOTEIO;
-	}
-	return ret;
-}
-
-/* read multiple registers */
-static int fc2580_rd_regs(struct fc2580_dev *dev, u8 reg, u8 *val, int len)
-{
-	struct i2c_client *client = dev->client;
-	int ret;
-	u8 buf[MAX_XFER_SIZE];
-	struct i2c_msg msg[2] = {
-		{
-			.addr = dev->i2c_addr,
-			.flags = 0,
-			.len = 1,
-			.buf = &reg,
-		}, {
-			.addr = dev->i2c_addr,
-			.flags = I2C_M_RD,
-			.len = len,
-			.buf = buf,
-		}
-	};
-
-	if (len > sizeof(buf)) {
-		dev_warn(&client->dev,
-			 "%s: i2c rd reg=%04x: len=%d is too big!\n",
-			 KBUILD_MODNAME, reg, len);
-		return -EINVAL;
-	}
-
-	ret = i2c_transfer(dev->i2c, msg, 2);
-	if (ret == 2) {
-		memcpy(val, buf, len);
-		ret = 0;
-	} else {
-		dev_warn(&client->dev, "%s: i2c rd failed=%d reg=%02x len=%d\n",
-			 KBUILD_MODNAME, ret, reg, len);
-		ret = -EREMOTEIO;
-	}
-
-	return ret;
-}
-
-/* write single register */
-static int fc2580_wr_reg(struct fc2580_dev *dev, u8 reg, u8 val)
-{
-	return fc2580_wr_regs(dev, reg, &val, 1);
-}
-
-/* read single register */
-static int fc2580_rd_reg(struct fc2580_dev *dev, u8 reg, u8 *val)
-{
-	return fc2580_rd_regs(dev, reg, val, 1);
-}
-
 /* write single register conditionally only when value differs from 0xff
  * XXX: This is special routine meant only for writing fc2580_freq_regs_lut[]
  * values. Do not use for the other purposes. */
@@ -131,10 +35,9 @@ static int fc2580_wr_reg_ff(struct fc2580_dev *dev, u8 reg, u8 val)
 	if (val == 0xff)
 		return 0;
 	else
-		return fc2580_wr_regs(dev, reg, &val, 1);
+		return regmap_write(dev->regmap, reg, val);
 }
 
-
 static int fc2580_set_params(struct dvb_frontend *fe)
 {
 	struct fc2580_dev *dev = fe->tuner_priv;
@@ -206,24 +109,24 @@ static int fc2580_set_params(struct dvb_frontend *fe)
 		"frequency=%u f_vco=%llu F_REF=%u div_ref=%u div_n=%u k=%u div_out=%u k_cw=%0x\n",
 		c->frequency, f_vco, F_REF, div_ref, div_n, k, div_out, k_cw);
 
-	ret = fc2580_wr_reg(dev, 0x02, synth_config);
-	if (ret < 0)
+	ret = regmap_write(dev->regmap, 0x02, synth_config);
+	if (ret)
 		goto err;
 
-	ret = fc2580_wr_reg(dev, 0x18, div_ref_val << 0 | k_cw >> 16);
-	if (ret < 0)
+	ret = regmap_write(dev->regmap, 0x18, div_ref_val << 0 | k_cw >> 16);
+	if (ret)
 		goto err;
 
-	ret = fc2580_wr_reg(dev, 0x1a, (k_cw >> 8) & 0xff);
-	if (ret < 0)
+	ret = regmap_write(dev->regmap, 0x1a, (k_cw >> 8) & 0xff);
+	if (ret)
 		goto err;
 
-	ret = fc2580_wr_reg(dev, 0x1b, (k_cw >> 0) & 0xff);
-	if (ret < 0)
+	ret = regmap_write(dev->regmap, 0x1b, (k_cw >> 0) & 0xff);
+	if (ret)
 		goto err;
 
-	ret = fc2580_wr_reg(dev, 0x1c, div_n);
-	if (ret < 0)
+	ret = regmap_write(dev->regmap, 0x1c, div_n);
+	if (ret)
 		goto err;
 
 	/* registers */
@@ -237,99 +140,99 @@ static int fc2580_set_params(struct dvb_frontend *fe)
 	}
 
 	ret = fc2580_wr_reg_ff(dev, 0x25, fc2580_freq_regs_lut[i].r25_val);
-	if (ret < 0)
+	if (ret)
 		goto err;
 
 	ret = fc2580_wr_reg_ff(dev, 0x27, fc2580_freq_regs_lut[i].r27_val);
-	if (ret < 0)
+	if (ret)
 		goto err;
 
 	ret = fc2580_wr_reg_ff(dev, 0x28, fc2580_freq_regs_lut[i].r28_val);
-	if (ret < 0)
+	if (ret)
 		goto err;
 
 	ret = fc2580_wr_reg_ff(dev, 0x29, fc2580_freq_regs_lut[i].r29_val);
-	if (ret < 0)
+	if (ret)
 		goto err;
 
 	ret = fc2580_wr_reg_ff(dev, 0x2b, fc2580_freq_regs_lut[i].r2b_val);
-	if (ret < 0)
+	if (ret)
 		goto err;
 
 	ret = fc2580_wr_reg_ff(dev, 0x2c, fc2580_freq_regs_lut[i].r2c_val);
-	if (ret < 0)
+	if (ret)
 		goto err;
 
 	ret = fc2580_wr_reg_ff(dev, 0x2d, fc2580_freq_regs_lut[i].r2d_val);
-	if (ret < 0)
+	if (ret)
 		goto err;
 
 	ret = fc2580_wr_reg_ff(dev, 0x30, fc2580_freq_regs_lut[i].r30_val);
-	if (ret < 0)
+	if (ret)
 		goto err;
 
 	ret = fc2580_wr_reg_ff(dev, 0x44, fc2580_freq_regs_lut[i].r44_val);
-	if (ret < 0)
+	if (ret)
 		goto err;
 
 	ret = fc2580_wr_reg_ff(dev, 0x50, fc2580_freq_regs_lut[i].r50_val);
-	if (ret < 0)
+	if (ret)
 		goto err;
 
 	ret = fc2580_wr_reg_ff(dev, 0x53, fc2580_freq_regs_lut[i].r53_val);
-	if (ret < 0)
+	if (ret)
 		goto err;
 
 	ret = fc2580_wr_reg_ff(dev, 0x5f, fc2580_freq_regs_lut[i].r5f_val);
-	if (ret < 0)
+	if (ret)
 		goto err;
 
 	ret = fc2580_wr_reg_ff(dev, 0x61, fc2580_freq_regs_lut[i].r61_val);
-	if (ret < 0)
+	if (ret)
 		goto err;
 
 	ret = fc2580_wr_reg_ff(dev, 0x62, fc2580_freq_regs_lut[i].r62_val);
-	if (ret < 0)
+	if (ret)
 		goto err;
 
 	ret = fc2580_wr_reg_ff(dev, 0x63, fc2580_freq_regs_lut[i].r63_val);
-	if (ret < 0)
+	if (ret)
 		goto err;
 
 	ret = fc2580_wr_reg_ff(dev, 0x67, fc2580_freq_regs_lut[i].r67_val);
-	if (ret < 0)
+	if (ret)
 		goto err;
 
 	ret = fc2580_wr_reg_ff(dev, 0x68, fc2580_freq_regs_lut[i].r68_val);
-	if (ret < 0)
+	if (ret)
 		goto err;
 
 	ret = fc2580_wr_reg_ff(dev, 0x69, fc2580_freq_regs_lut[i].r69_val);
-	if (ret < 0)
+	if (ret)
 		goto err;
 
 	ret = fc2580_wr_reg_ff(dev, 0x6a, fc2580_freq_regs_lut[i].r6a_val);
-	if (ret < 0)
+	if (ret)
 		goto err;
 
 	ret = fc2580_wr_reg_ff(dev, 0x6b, fc2580_freq_regs_lut[i].r6b_val);
-	if (ret < 0)
+	if (ret)
 		goto err;
 
 	ret = fc2580_wr_reg_ff(dev, 0x6c, fc2580_freq_regs_lut[i].r6c_val);
-	if (ret < 0)
+	if (ret)
 		goto err;
 
 	ret = fc2580_wr_reg_ff(dev, 0x6d, fc2580_freq_regs_lut[i].r6d_val);
-	if (ret < 0)
+	if (ret)
 		goto err;
 
 	ret = fc2580_wr_reg_ff(dev, 0x6e, fc2580_freq_regs_lut[i].r6e_val);
-	if (ret < 0)
+	if (ret)
 		goto err;
 
 	ret = fc2580_wr_reg_ff(dev, 0x6f, fc2580_freq_regs_lut[i].r6f_val);
-	if (ret < 0)
+	if (ret)
 		goto err;
 
 	/* IF filters */
@@ -342,34 +245,34 @@ static int fc2580_set_params(struct dvb_frontend *fe)
 		goto err;
 	}
 
-	ret = fc2580_wr_reg(dev, 0x36, fc2580_if_filter_lut[i].r36_val);
-	if (ret < 0)
+	ret = regmap_write(dev->regmap, 0x36, fc2580_if_filter_lut[i].r36_val);
+	if (ret)
 		goto err;
 
 	u8tmp = div_u64((u64) dev->clk * fc2580_if_filter_lut[i].mul,
 			1000000000);
-	ret = fc2580_wr_reg(dev, 0x37, u8tmp);
-	if (ret < 0)
+	ret = regmap_write(dev->regmap, 0x37, u8tmp);
+	if (ret)
 		goto err;
 
-	ret = fc2580_wr_reg(dev, 0x39, fc2580_if_filter_lut[i].r39_val);
-	if (ret < 0)
+	ret = regmap_write(dev->regmap, 0x39, fc2580_if_filter_lut[i].r39_val);
+	if (ret)
 		goto err;
 
 	timeout = jiffies + msecs_to_jiffies(30);
 	for (uitmp = ~0xc0; !time_after(jiffies, timeout) && uitmp != 0xc0;) {
 		/* trigger filter */
-		ret = fc2580_wr_reg(dev, 0x2e, 0x09);
+		ret = regmap_write(dev->regmap, 0x2e, 0x09);
 		if (ret)
 			goto err;
 
 		/* locked when [7:6] are set (val: d7 6MHz, d5 7MHz, cd 8MHz) */
-		ret = fc2580_rd_reg(dev, 0x2f, &u8tmp);
+		ret = regmap_read(dev->regmap, 0x2f, &uitmp);
 		if (ret)
 			goto err;
-		uitmp = u8tmp & 0xc0;
+		uitmp &= 0xc0;
 
-		ret = fc2580_wr_reg(dev, 0x2e, 0x01);
+		ret = regmap_write(dev->regmap, 0x2e, 0x01);
 		if (ret)
 			goto err;
 	}
@@ -391,9 +294,9 @@ static int fc2580_init(struct dvb_frontend *fe)
 	dev_dbg(&client->dev, "\n");
 
 	for (i = 0; i < ARRAY_SIZE(fc2580_init_reg_vals); i++) {
-		ret = fc2580_wr_reg(dev, fc2580_init_reg_vals[i].reg,
+		ret = regmap_write(dev->regmap, fc2580_init_reg_vals[i].reg,
 				fc2580_init_reg_vals[i].val);
-		if (ret < 0)
+		if (ret)
 			goto err;
 	}
 
@@ -411,8 +314,8 @@ static int fc2580_sleep(struct dvb_frontend *fe)
 
 	dev_dbg(&client->dev, "\n");
 
-	ret = fc2580_wr_reg(dev, 0x02, 0x0a);
-	if (ret < 0)
+	ret = regmap_write(dev->regmap, 0x02, 0x0a);
+	if (ret)
 		goto err;
 
 	return 0;
@@ -454,7 +357,11 @@ static int fc2580_probe(struct i2c_client *client,
 	struct fc2580_platform_data *pdata = client->dev.platform_data;
 	struct dvb_frontend *fe = pdata->dvb_frontend;
 	int ret;
-	u8 chip_id;
+	unsigned int uitmp;
+	static const struct regmap_config regmap_config = {
+		.reg_bits = 8,
+		.val_bits = 8,
+	};
 
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
 	if (!dev) {
@@ -467,17 +374,20 @@ static int fc2580_probe(struct i2c_client *client,
 	else
 		dev->clk = 16384000; /* internal clock */
 	dev->client = client;
-	dev->i2c = client->adapter;
-	dev->i2c_addr = client->addr;
+	dev->regmap = devm_regmap_init_i2c(client, &regmap_config);
+	if (IS_ERR(dev->regmap)) {
+		ret = PTR_ERR(dev->regmap);
+		goto err_kfree;
+	}
 
 	/* check if the tuner is there */
-	ret = fc2580_rd_reg(dev, 0x01, &chip_id);
-	if (ret < 0)
+	ret = regmap_read(dev->regmap, 0x01, &uitmp);
+	if (ret)
 		goto err_kfree;
 
-	dev_dbg(&client->dev, "chip_id=%02x\n", chip_id);
+	dev_dbg(&client->dev, "chip_id=%02x\n", uitmp);
 
-	switch (chip_id) {
+	switch (uitmp) {
 	case 0x56:
 	case 0x5a:
 		break;
diff --git a/drivers/media/tuners/fc2580_priv.h b/drivers/media/tuners/fc2580_priv.h
index 16245ee..60f8f6c 100644
--- a/drivers/media/tuners/fc2580_priv.h
+++ b/drivers/media/tuners/fc2580_priv.h
@@ -22,6 +22,7 @@
 #define FC2580_PRIV_H
 
 #include "fc2580.h"
+#include <linux/regmap.h>
 #include <linux/math64.h>
 
 struct fc2580_reg_val {
@@ -130,8 +131,7 @@ static const struct fc2580_freq_regs fc2580_freq_regs_lut[] = {
 struct fc2580_dev {
 	u32 clk;
 	struct i2c_client *client;
-	struct i2c_adapter *i2c;
-	u8 i2c_addr;
+	struct regmap *regmap;
 };
 
 #endif
-- 
http://palosaari.fi/

