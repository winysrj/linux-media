Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35609 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757067AbaIDChC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Sep 2014 22:37:02 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 16/37] it913x: convert to RegMap API
Date: Thu,  4 Sep 2014 05:36:24 +0300
Message-Id: <1409798205-25645-16-git-send-email-crope@iki.fi>
In-Reply-To: <1409798205-25645-1-git-send-email-crope@iki.fi>
References: <1409798205-25645-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use RegMap API to cover I2C register access routines.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/Kconfig       |   1 +
 drivers/media/tuners/it913x.c      | 137 +++++++++----------------------------
 drivers/media/tuners/it913x_priv.h |   1 +
 3 files changed, 34 insertions(+), 105 deletions(-)

diff --git a/drivers/media/tuners/Kconfig b/drivers/media/tuners/Kconfig
index d79fd1c..ca42da8 100644
--- a/drivers/media/tuners/Kconfig
+++ b/drivers/media/tuners/Kconfig
@@ -247,6 +247,7 @@ config MEDIA_TUNER_SI2157
 config MEDIA_TUNER_IT913X
 	tristate "ITE Tech IT913x silicon tuner"
 	depends on MEDIA_SUPPORT && I2C
+	select REGMAP_I2C
 	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  ITE Tech IT913x silicon tuner driver.
diff --git a/drivers/media/tuners/it913x.c b/drivers/media/tuners/it913x.c
index cc959c1..f3e212c 100644
--- a/drivers/media/tuners/it913x.c
+++ b/drivers/media/tuners/it913x.c
@@ -24,6 +24,7 @@
 
 struct it913x_dev {
 	struct i2c_client *client;
+	struct regmap *regmap;
 	struct dvb_frontend *fe;
 	u8 chip_ver;
 	u8 firmware_ver;
@@ -33,92 +34,6 @@ struct it913x_dev {
 	u32 tun_fn_min;
 };
 
-/* read multiple registers */
-static int it913x_rd_regs(struct it913x_dev *dev,
-		u32 reg, u8 *data, u8 count)
-{
-	int ret;
-	u8 b[3];
-	struct i2c_msg msg[2] = {
-		{ .addr = dev->client->addr, .flags = 0,
-			.buf = b, .len = sizeof(b) },
-		{ .addr = dev->client->addr, .flags = I2C_M_RD,
-			.buf = data, .len = count }
-	};
-
-	b[0] = (u8)(reg >> 16) & 0xff;
-	b[1] = (u8)(reg >> 8) & 0xff;
-	b[2] = (u8) reg & 0xff;
-
-	ret = i2c_transfer(dev->client->adapter, msg, 2);
-
-	return ret;
-}
-
-/* read single register */
-static int it913x_rd_reg(struct it913x_dev *dev, u32 reg, u8 *val)
-{
-	int ret;
-	u8 b[1];
-
-	ret = it913x_rd_regs(dev, reg, &b[0], sizeof(b));
-	if (ret < 0)
-		return -ENODEV;
-	*val = b[0];
-	return 0;
-}
-
-/* write multiple registers */
-static int it913x_wr_regs(struct it913x_dev *dev,
-		u32 reg, u8 buf[], u8 count)
-{
-	u8 b[256];
-	struct i2c_msg msg[1] = {
-		{ .addr = dev->client->addr, .flags = 0,
-		  .buf = b, .len = 3 + count }
-	};
-	int ret;
-
-	b[0] = (u8)(reg >> 16) & 0xff;
-	b[1] = (u8)(reg >> 8) & 0xff;
-	b[2] = (u8) reg & 0xff;
-	memcpy(&b[3], buf, count);
-
-	ret = i2c_transfer(dev->client->adapter, msg, 1);
-
-	if (ret < 0)
-		return -EIO;
-
-	return 0;
-}
-
-/* write single register */
-static int it913x_wr_reg(struct it913x_dev *dev,
-		u32 reg, u32 data)
-{
-	int ret;
-	u8 b[4];
-	u8 len;
-
-	b[0] = data >> 24;
-	b[1] = (data >> 16) & 0xff;
-	b[2] = (data >> 8) & 0xff;
-	b[3] = data & 0xff;
-	/* expand write as needed */
-	if (data < 0x100)
-		len = 3;
-	else if (data < 0x1000)
-		len = 2;
-	else if (data < 0x100000)
-		len = 1;
-	else
-		len = 0;
-
-	ret = it913x_wr_regs(dev, reg, &b[len], sizeof(b) - len);
-
-	return ret;
-}
-
 static int it913x_script_loader(struct it913x_dev *dev,
 		struct it913xset *loadscript)
 {
@@ -130,8 +45,7 @@ static int it913x_script_loader(struct it913x_dev *dev,
 	for (i = 0; i < 1000; ++i) {
 		if (loadscript[i].address == 0x000000)
 			break;
-		ret = it913x_wr_regs(dev,
-			loadscript[i].address,
+		ret = regmap_bulk_write(dev->regmap, loadscript[i].address,
 			loadscript[i].reg, loadscript[i].count);
 		if (ret < 0)
 			return -ENODEV;
@@ -143,12 +57,12 @@ static int it913x_init(struct dvb_frontend *fe)
 {
 	struct it913x_dev *dev = fe->tuner_priv;
 	int ret, i;
-	u8 reg = 0;
+	unsigned int reg;
 	u8 val, nv_val;
 	u8 nv[] = {48, 32, 24, 16, 12, 8, 6, 4, 2};
 	u8 b[2];
 
-	ret = it913x_rd_reg(dev, 0x80ec86, &reg);
+	ret = regmap_read(dev->regmap, 0x80ec86, &reg);
 	switch (reg) {
 	case 0:
 		dev->tun_clk_mode = reg;
@@ -165,7 +79,7 @@ static int it913x_init(struct dvb_frontend *fe)
 		break;
 	}
 
-	ret = it913x_rd_reg(dev, 0x80ed03,  &reg);
+	ret = regmap_read(dev->regmap, 0x80ed03,  &reg);
 
 	if (reg < 0)
 		return -ENODEV;
@@ -175,11 +89,11 @@ static int it913x_init(struct dvb_frontend *fe)
 		nv_val = 2;
 
 	for (i = 0; i < 50; i++) {
-		ret = it913x_rd_regs(dev, 0x80ed23, &b[0], sizeof(b));
+		ret = regmap_bulk_read(dev->regmap, 0x80ed23, &b[0], sizeof(b));
 		reg = (b[1] << 8) + b[0];
 		if (reg > 0)
 			break;
-		if (ret < 0)
+		if (ret)
 			return -ENODEV;
 		udelay(2000);
 	}
@@ -191,7 +105,7 @@ static int it913x_init(struct dvb_frontend *fe)
 		msleep(50);
 	else {
 		for (i = 0; i < 50; i++) {
-			ret = it913x_rd_reg(dev, 0x80ec82, &reg);
+			ret = regmap_read(dev->regmap, 0x80ec82, &reg);
 			if (ret < 0)
 				return -ENODEV;
 			if (reg > 0)
@@ -201,11 +115,11 @@ static int it913x_init(struct dvb_frontend *fe)
 	}
 
 	/* Power Up Tuner - common all versions */
-	ret = it913x_wr_reg(dev, 0x80ec40, 0x1);
-	ret |= it913x_wr_reg(dev, 0x80ec57, 0x0);
-	ret |= it913x_wr_reg(dev, 0x80ec58, 0x0);
+	ret = regmap_write(dev->regmap, 0x80ec40, 0x1);
+	ret |= regmap_write(dev->regmap, 0x80ec57, 0x0);
+	ret |= regmap_write(dev->regmap, 0x80ec58, 0x0);
 
-	return it913x_wr_reg(dev, 0x80ed81, val);
+	return regmap_write(dev->regmap, 0x80ed81, val);
 }
 
 static int it9137_set_params(struct dvb_frontend *fe)
@@ -216,7 +130,7 @@ static int it9137_set_params(struct dvb_frontend *fe)
 	u32 bandwidth = p->bandwidth_hz;
 	u32 frequency_m = p->frequency;
 	int ret;
-	u8 reg = 0;
+	unsigned int reg;
 	u32 frequency = frequency_m / 1000;
 	u32 freq, temp_f, tmp;
 	u16 iqik_m_cal;
@@ -317,7 +231,7 @@ static int it9137_set_params(struct dvb_frontend *fe)
 	} else
 		return -EINVAL;
 
-	ret = it913x_rd_reg(dev, 0x80ed81, &reg);
+	ret = regmap_read(dev->regmap, 0x80ed81, &reg);
 	iqik_m_cal = (u16)reg * n_div;
 
 	if (reg < 0x20) {
@@ -394,6 +308,10 @@ static int it913x_probe(struct i2c_client *client,
 	struct it913x_dev *dev;
 	int ret;
 	char *chip_ver_str;
+	static const struct regmap_config regmap_config = {
+		.reg_bits = 24,
+		.val_bits = 8,
+	};
 
 	dev = kzalloc(sizeof(struct it913x_dev), GFP_KERNEL);
 	if (dev == NULL) {
@@ -406,11 +324,16 @@ static int it913x_probe(struct i2c_client *client,
 	dev->fe = cfg->fe;
 	dev->chip_ver = cfg->chip_ver;
 	dev->firmware_ver = 1;
+	dev->regmap = regmap_init_i2c(client, &regmap_config);
+	if (IS_ERR(dev->regmap)) {
+		ret = PTR_ERR(dev->regmap);
+		goto err_kfree;
+	}
 
 	/* tuner RF initial */
-	ret = it913x_wr_reg(dev, 0x80ec4c, 0x68);
-	if (ret < 0)
-		goto err;
+	ret = regmap_write(dev->regmap, 0x80ec4c, 0x68);
+	if (ret)
+		goto err_regmap_exit;
 
 	fe->tuner_priv = dev;
 	memcpy(&fe->ops.tuner_ops, &it913x_tuner_ops,
@@ -428,10 +351,13 @@ static int it913x_probe(struct i2c_client *client,
 			chip_ver_str);
 	dev_dbg(&dev->client->dev, "chip_ver=%02x\n", dev->chip_ver);
 	return 0;
+
+err_regmap_exit:
+	regmap_exit(dev->regmap);
+err_kfree:
+	kfree(dev);
 err:
 	dev_dbg(&client->dev, "failed %d\n", ret);
-	kfree(dev);
-
 	return ret;
 }
 
@@ -444,6 +370,7 @@ static int it913x_remove(struct i2c_client *client)
 
 	memset(&fe->ops.tuner_ops, 0, sizeof(struct dvb_tuner_ops));
 	fe->tuner_priv = NULL;
+	regmap_exit(dev->regmap);
 	kfree(dev);
 
 	return 0;
diff --git a/drivers/media/tuners/it913x_priv.h b/drivers/media/tuners/it913x_priv.h
index 32af24c..3ed2d3c 100644
--- a/drivers/media/tuners/it913x_priv.h
+++ b/drivers/media/tuners/it913x_priv.h
@@ -24,6 +24,7 @@
 #define IT913X_PRIV_H
 
 #include "it913x.h"
+#include <linux/regmap.h>
 
 #define TRIGGER_OFSM		0x0000
 
-- 
http://palosaari.fi/

