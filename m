Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40239 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941AbaIGCAS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Sep 2014 22:00:18 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH v2 8/8] tda18212: convert to RegMap API
Date: Sun,  7 Sep 2014 05:00:00 +0300
Message-Id: <1410055200-32170-8-git-send-email-crope@iki.fi>
In-Reply-To: <1410055200-32170-1-git-send-email-crope@iki.fi>
References: <1410055200-32170-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use RegMap API to handle all the boring I2C register access
boilerplate stuff.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/Kconfig    |   1 +
 drivers/media/tuners/tda18212.c | 131 ++++++----------------------------------
 2 files changed, 18 insertions(+), 114 deletions(-)

diff --git a/drivers/media/tuners/Kconfig b/drivers/media/tuners/Kconfig
index d79fd1c..483963d 100644
--- a/drivers/media/tuners/Kconfig
+++ b/drivers/media/tuners/Kconfig
@@ -204,6 +204,7 @@ config MEDIA_TUNER_FC0013
 config MEDIA_TUNER_TDA18212
 	tristate "NXP TDA18212 silicon tuner"
 	depends on MEDIA_SUPPORT && I2C
+	select REGMAP_I2C
 	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  NXP TDA18212 silicon tuner driver.
diff --git a/drivers/media/tuners/tda18212.c b/drivers/media/tuners/tda18212.c
index 24948c7..d93e066 100644
--- a/drivers/media/tuners/tda18212.c
+++ b/drivers/media/tuners/tda18212.c
@@ -19,122 +19,16 @@
  */
 
 #include "tda18212.h"
-
-/* Max transfer size done by I2C transfer functions */
-#define MAX_XFER_SIZE  64
+#include <linux/regmap.h>
 
 struct tda18212_dev {
 	struct tda18212_config cfg;
 	struct i2c_client *client;
+	struct regmap *regmap;
 
 	u32 if_frequency;
 };
 
-/* write multiple registers */
-static int tda18212_wr_regs(struct tda18212_dev *dev, u8 reg, u8 *val, int len)
-{
-	int ret;
-	u8 buf[MAX_XFER_SIZE];
-	struct i2c_msg msg[1] = {
-		{
-			.addr = dev->client->addr,
-			.flags = 0,
-			.len = 1 + len,
-			.buf = buf,
-		}
-	};
-
-	if (1 + len > sizeof(buf)) {
-		dev_warn(&dev->client->dev,
-				"i2c wr reg=%04x: len=%d is too big!\n",
-				reg, len);
-		return -EINVAL;
-	}
-
-	buf[0] = reg;
-	memcpy(&buf[1], val, len);
-
-	ret = i2c_transfer(dev->client->adapter, msg, 1);
-	if (ret == 1) {
-		ret = 0;
-	} else {
-		dev_warn(&dev->client->dev,
-				"i2c wr failed=%d reg=%02x len=%d\n",
-				ret, reg, len);
-		ret = -EREMOTEIO;
-	}
-	return ret;
-}
-
-/* read multiple registers */
-static int tda18212_rd_regs(struct tda18212_dev *dev, u8 reg, u8 *val, int len)
-{
-	int ret;
-	u8 buf[MAX_XFER_SIZE];
-	struct i2c_msg msg[2] = {
-		{
-			.addr = dev->client->addr,
-			.flags = 0,
-			.len = 1,
-			.buf = &reg,
-		}, {
-			.addr = dev->client->addr,
-			.flags = I2C_M_RD,
-			.len = len,
-			.buf = buf,
-		}
-	};
-
-	if (len > sizeof(buf)) {
-		dev_warn(&dev->client->dev,
-				"i2c rd reg=%04x: len=%d is too big!\n",
-				reg, len);
-		return -EINVAL;
-	}
-
-	ret = i2c_transfer(dev->client->adapter, msg, 2);
-	if (ret == 2) {
-		memcpy(val, buf, len);
-		ret = 0;
-	} else {
-		dev_warn(&dev->client->dev,
-				"i2c rd failed=%d reg=%02x len=%d\n",
-				ret, reg, len);
-		ret = -EREMOTEIO;
-	}
-
-	return ret;
-}
-
-/* write single register */
-static int tda18212_wr_reg(struct tda18212_dev *dev, u8 reg, u8 val)
-{
-	return tda18212_wr_regs(dev, reg, &val, 1);
-}
-
-/* read single register */
-static int tda18212_rd_reg(struct tda18212_dev *dev, u8 reg, u8 *val)
-{
-	return tda18212_rd_regs(dev, reg, val, 1);
-}
-
-#if 0 /* keep, useful when developing driver */
-static void tda18212_dump_regs(struct tda18212_dev *dev)
-{
-	int i;
-	u8 buf[256];
-
-	#define TDA18212_RD_LEN 32
-	for (i = 0; i < sizeof(buf); i += TDA18212_RD_LEN)
-		tda18212_rd_regs(dev, i, &buf[i], TDA18212_RD_LEN);
-
-	print_hex_dump(KERN_INFO, "", DUMP_PREFIX_OFFSET, 32, 1, buf,
-		sizeof(buf), true);
-
-	return;
-}
-#endif
-
 static int tda18212_set_params(struct dvb_frontend *fe)
 {
 	struct tda18212_dev *dev = fe->tuner_priv;
@@ -231,15 +125,15 @@ static int tda18212_set_params(struct dvb_frontend *fe)
 		goto error;
 	}
 
-	ret = tda18212_wr_reg(dev, 0x23, bw_params[i][2]);
+	ret = regmap_write(dev->regmap, 0x23, bw_params[i][2]);
 	if (ret)
 		goto error;
 
-	ret = tda18212_wr_reg(dev, 0x06, 0x00);
+	ret = regmap_write(dev->regmap, 0x06, 0x00);
 	if (ret)
 		goto error;
 
-	ret = tda18212_wr_reg(dev, 0x0f, bw_params[i][0]);
+	ret = regmap_write(dev->regmap, 0x0f, bw_params[i][0]);
 	if (ret)
 		goto error;
 
@@ -252,7 +146,7 @@ static int tda18212_set_params(struct dvb_frontend *fe)
 	buf[6] = ((c->frequency / 1000) >>  0) & 0xff;
 	buf[7] = 0xc1;
 	buf[8] = 0x01;
-	ret = tda18212_wr_regs(dev, 0x12, buf, sizeof(buf));
+	ret = regmap_bulk_write(dev->regmap, 0x12, buf, sizeof(buf));
 	if (ret)
 		goto error;
 
@@ -299,8 +193,12 @@ static int tda18212_probe(struct i2c_client *client,
 	struct dvb_frontend *fe = cfg->fe;
 	struct tda18212_dev *dev;
 	int ret;
-	u8 chip_id = chip_id;
+	unsigned int chip_id;
 	char *version;
+	static const struct regmap_config regmap_config = {
+		.reg_bits = 8,
+		.val_bits = 8,
+	};
 
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
 	if (dev == NULL) {
@@ -311,12 +209,17 @@ static int tda18212_probe(struct i2c_client *client,
 
 	memcpy(&dev->cfg, cfg, sizeof(struct tda18212_config));
 	dev->client = client;
+	dev->regmap = devm_regmap_init_i2c(client, &regmap_config);
+	if (IS_ERR(dev->regmap)) {
+		ret = PTR_ERR(dev->regmap);
+		goto err;
+	}
 
 	/* check if the tuner is there */
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1); /* open I2C-gate */
 
-	ret = tda18212_rd_reg(dev, 0x00, &chip_id);
+	ret = regmap_read(dev->regmap, 0x00, &chip_id);
 	dev_dbg(&dev->client->dev, "chip_id=%02x\n", chip_id);
 
 	if (fe->ops.i2c_gate_ctrl)
-- 
http://palosaari.fi/

