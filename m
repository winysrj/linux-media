Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37224 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752636AbbEEV7A (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 May 2015 17:59:00 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 14/21] tua9001: use regmap for I2C register access
Date: Wed,  6 May 2015 00:58:35 +0300
Message-Id: <1430863122-9888-14-git-send-email-crope@iki.fi>
In-Reply-To: <1430863122-9888-1-git-send-email-crope@iki.fi>
References: <1430863122-9888-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use regmap for I2C register access.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/Kconfig        |  1 +
 drivers/media/tuners/tua9001.c      | 41 +++++++++++--------------------------
 drivers/media/tuners/tua9001_priv.h |  2 ++
 3 files changed, 15 insertions(+), 29 deletions(-)

diff --git a/drivers/media/tuners/Kconfig b/drivers/media/tuners/Kconfig
index 74973f4..bd302ff 100644
--- a/drivers/media/tuners/Kconfig
+++ b/drivers/media/tuners/Kconfig
@@ -236,6 +236,7 @@ config MEDIA_TUNER_M88RS6000T
 config MEDIA_TUNER_TUA9001
 	tristate "Infineon TUA9001 silicon tuner"
 	depends on MEDIA_SUPPORT && I2C
+	select REGMAP_I2C
 	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Infineon TUA 9001 silicon tuner driver.
diff --git a/drivers/media/tuners/tua9001.c b/drivers/media/tuners/tua9001.c
index fe778cd..09a1034 100644
--- a/drivers/media/tuners/tua9001.c
+++ b/drivers/media/tuners/tua9001.c
@@ -16,32 +16,6 @@
 
 #include "tua9001_priv.h"
 
-/* write register */
-static int tua9001_wr_reg(struct tua9001_dev *dev, u8 reg, u16 val)
-{
-	struct i2c_client *client = dev->client;
-	int ret;
-	u8 buf[3] = { reg, (val >> 8) & 0xff, (val >> 0) & 0xff };
-	struct i2c_msg msg[1] = {
-		{
-			.addr = client->addr,
-			.flags = 0,
-			.len = sizeof(buf),
-			.buf = buf,
-		}
-	};
-
-	ret = i2c_transfer(client->adapter, msg, 1);
-	if (ret == 1) {
-		ret = 0;
-	} else {
-		dev_warn(&client->dev, "i2c wr failed=%d reg=%02x\n", ret, reg);
-		ret = -EREMOTEIO;
-	}
-
-	return ret;
-}
-
 static int tua9001_init(struct dvb_frontend *fe)
 {
 	struct tua9001_dev *dev = fe->tuner_priv;
@@ -76,7 +50,7 @@ static int tua9001_init(struct dvb_frontend *fe)
 	}
 
 	for (i = 0; i < ARRAY_SIZE(data); i++) {
-		ret = tua9001_wr_reg(dev, data[i].reg, data[i].val);
+		ret = regmap_write(dev->regmap, data[i].reg, data[i].val);
 		if (ret)
 			goto err;
 	}
@@ -166,7 +140,7 @@ static int tua9001_set_params(struct dvb_frontend *fe)
 	}
 
 	for (i = 0; i < ARRAY_SIZE(data); i++) {
-		ret = tua9001_wr_reg(dev, data[i].reg, data[i].val);
+		ret = regmap_write(dev->regmap, data[i].reg, data[i].val);
 		if (ret)
 			goto err;
 	}
@@ -216,6 +190,10 @@ static int tua9001_probe(struct i2c_client *client,
 	struct tua9001_platform_data *pdata = client->dev.platform_data;
 	struct dvb_frontend *fe = pdata->dvb_frontend;
 	int ret;
+	static const struct regmap_config regmap_config = {
+		.reg_bits =  8,
+		.val_bits = 16,
+	};
 
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
 	if (!dev) {
@@ -223,8 +201,13 @@ static int tua9001_probe(struct i2c_client *client,
 		goto err;
 	}
 
-	dev->client = client;
 	dev->fe = pdata->dvb_frontend;
+	dev->client = client;
+	dev->regmap = devm_regmap_init_i2c(client, &regmap_config);
+	if (IS_ERR(dev->regmap)) {
+		ret = PTR_ERR(dev->regmap);
+		goto err_kfree;
+	}
 
 	if (fe->callback) {
 		ret = fe->callback(client->adapter,
diff --git a/drivers/media/tuners/tua9001_priv.h b/drivers/media/tuners/tua9001_priv.h
index e24d843..327ead9 100644
--- a/drivers/media/tuners/tua9001_priv.h
+++ b/drivers/media/tuners/tua9001_priv.h
@@ -18,6 +18,7 @@
 #define TUA9001_PRIV_H
 
 #include "tua9001.h"
+#include <linux/regmap.h>
 
 struct tua9001_reg_val {
 	u8 reg;
@@ -27,6 +28,7 @@ struct tua9001_reg_val {
 struct tua9001_dev {
 	struct dvb_frontend *fe;
 	struct i2c_client *client;
+	struct regmap *regmap;
 };
 
 #endif
-- 
http://palosaari.fi/

