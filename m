Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60141 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933526AbaKLELh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Nov 2014 23:11:37 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 07/11] mn88472: Convert driver to I2C RegMap API
Date: Wed, 12 Nov 2014 06:11:13 +0200
Message-Id: <1415765477-23153-8-git-send-email-crope@iki.fi>
In-Reply-To: <1415765477-23153-1-git-send-email-crope@iki.fi>
References: <1415765477-23153-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert driver to I2C RegMap API.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/Kconfig        |   1 +
 drivers/media/dvb-frontends/mn88472.c      | 180 ++++++++++-------------------
 drivers/media/dvb-frontends/mn88472_priv.h |   2 +
 3 files changed, 64 insertions(+), 119 deletions(-)

diff --git a/drivers/media/dvb-frontends/Kconfig b/drivers/media/dvb-frontends/Kconfig
index 02bada4..207843e 100644
--- a/drivers/media/dvb-frontends/Kconfig
+++ b/drivers/media/dvb-frontends/Kconfig
@@ -444,6 +444,7 @@ config DVB_CXD2820R
 config DVB_MN88472
 	tristate "Panasonic MN88472"
 	depends on DVB_CORE && I2C
+	select REGMAP_I2C
 	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Say Y when you want to support this frontend.
diff --git a/drivers/media/dvb-frontends/mn88472.c b/drivers/media/dvb-frontends/mn88472.c
index a65741a..c680154 100644
--- a/drivers/media/dvb-frontends/mn88472.c
+++ b/drivers/media/dvb-frontends/mn88472.c
@@ -16,95 +16,6 @@
 
 #include "mn88472_priv.h"
 
-static struct dvb_frontend_ops mn88472_ops;
-
-/* write multiple registers */
-static int mn88472_wregs(struct mn88472_dev *dev, u16 reg, const u8 *val, int len)
-{
-#define MAX_WR_LEN 21
-#define MAX_WR_XFER_LEN (MAX_WR_LEN + 1)
-	int ret;
-	u8 buf[MAX_WR_XFER_LEN];
-	struct i2c_msg msg[1] = {
-		{
-			.addr = (reg >> 8) & 0xff,
-			.flags = 0,
-			.len = 1 + len,
-			.buf = buf,
-		}
-	};
-
-	if (WARN_ON(len > MAX_WR_LEN))
-		return -EINVAL;
-
-	buf[0] = (reg >> 0) & 0xff;
-	memcpy(&buf[1], val, len);
-
-	ret = i2c_transfer(dev->client[0]->adapter, msg, 1);
-	if (ret == 1) {
-		ret = 0;
-	} else {
-		dev_warn(&dev->client[0]->dev,
-				"i2c wr failed=%d reg=%02x len=%d\n",
-				ret, reg, len);
-		ret = -EREMOTEIO;
-	}
-
-	return ret;
-}
-
-/* read multiple registers */
-static int mn88472_rregs(struct mn88472_dev *dev, u16 reg, u8 *val, int len)
-{
-#define MAX_RD_LEN 2
-#define MAX_RD_XFER_LEN (MAX_RD_LEN)
-	int ret;
-	u8 buf[MAX_RD_XFER_LEN];
-	struct i2c_msg msg[2] = {
-		{
-			.addr = (reg >> 8) & 0xff,
-			.flags = 0,
-			.len = 1,
-			.buf = buf,
-		}, {
-			.addr = (reg >> 8) & 0xff,
-			.flags = I2C_M_RD,
-			.len = len,
-			.buf = buf,
-		}
-	};
-
-	if (WARN_ON(len > MAX_RD_LEN))
-		return -EINVAL;
-
-	buf[0] = (reg >> 0) & 0xff;
-
-	ret = i2c_transfer(dev->client[0]->adapter, msg, 2);
-	if (ret == 2) {
-		memcpy(val, buf, len);
-		ret = 0;
-	} else {
-		dev_warn(&dev->client[0]->dev,
-				"i2c rd failed=%d reg=%02x len=%d\n",
-				ret, reg, len);
-		ret = -EREMOTEIO;
-	}
-
-	return ret;
-}
-
-/* write single register */
-static int mn88472_wreg(struct mn88472_dev *dev, u16 reg, u8 val)
-{
-	return mn88472_wregs(dev, reg, &val, 1);
-}
-
-/* read single register */
-static int mn88472_rreg(struct mn88472_dev *dev, u16 reg, u8 *val)
-{
-	return mn88472_rregs(dev, reg, val, 1);
-}
-
 static int mn88472_get_tune_settings(struct dvb_frontend *fe,
 	struct dvb_frontend_tune_settings *s)
 {
@@ -152,60 +63,61 @@ static int mn88472_set_frontend(struct dvb_frontend *fe)
 		goto err;
 	}
 
-	ret = mn88472_wregs(dev, 0x1c08, "\x1d", 1);
+	ret = regmap_write(dev->regmap[2], 0x08, 0x1d);
 	if (ret)
 		goto err;
 
-	ret = mn88472_wregs(dev, 0x18d9, "\xe3", 1);
+	ret = regmap_write(dev->regmap[0], 0xd9, 0xe3);
 	if (ret)
 		goto err;
 
-	ret = mn88472_wregs(dev, 0x1c83, "\x01", 1);
+	ret = regmap_write(dev->regmap[2], 0x83, 0x01);
 	if (ret)
 		goto err;
 
-	ret = mn88472_wregs(dev, 0x1c00, "\x66\x00\x01\x04\x00", 5);
+	ret = regmap_bulk_write(dev->regmap[2], 0x00,
+			"\x66\x00\x01\x04\x00", 5);
 	if (ret)
 		goto err;
 
-	ret = mn88472_wregs(dev, 0x1c10,
+	ret = regmap_bulk_write(dev->regmap[2], 0x10,
 			"\x3f\x50\x2c\x8f\x80\x00\x08\xee\x08\xee", 10);
 	if (ret)
 		goto err;
 
-	ret = mn88472_wregs(dev, 0x1846, "\x00", 1);
+	ret = regmap_write(dev->regmap[0], 0x46, 0x00);
 	if (ret)
 		goto err;
 
-	ret = mn88472_wregs(dev, 0x18ae, "\x00", 1);
+	ret = regmap_write(dev->regmap[0], 0xae, 0x00);
 	if (ret)
 		goto err;
 
-	ret = mn88472_wregs(dev, 0x18b0, "\x0b", 1);
+	ret = regmap_write(dev->regmap[0], 0xb0, 0x0b);
 	if (ret)
 		goto err;
 
-	ret = mn88472_wregs(dev, 0x18b4, "\x00", 1);
+	ret = regmap_write(dev->regmap[0], 0xb4, 0x00);
 	if (ret)
 		goto err;
 
-	ret = mn88472_wregs(dev, 0x18cd, "\x17", 1);
+	ret = regmap_write(dev->regmap[0], 0xcd, 0x17);
 	if (ret)
 		goto err;
 
-	ret = mn88472_wregs(dev, 0x18d4, "\x09", 1);
+	ret = regmap_write(dev->regmap[0], 0xd4, 0x09);
 	if (ret)
 		goto err;
 
-	ret = mn88472_wregs(dev, 0x18d6, "\x48", 1);
+	ret = regmap_write(dev->regmap[0], 0xd6, 0x48);
 	if (ret)
 		goto err;
 
-	ret = mn88472_wregs(dev, 0x1a00, "\xb0", 1);
+	ret = regmap_write(dev->regmap[1], 0x00, 0xb0);
 	if (ret)
 		goto err;
 
-	ret = mn88472_wregs(dev, 0x1cf8, "\x9f", 1);
+	ret = regmap_write(dev->regmap[2], 0xf8, 0x9f);
 	if (ret)
 		goto err;
 
@@ -222,7 +134,7 @@ static int mn88472_read_status(struct dvb_frontend *fe, fe_status_t *status)
 	struct i2c_client *client = fe->demodulator_priv;
 	struct mn88472_dev *dev = i2c_get_clientdata(client);
 	int ret;
-	u8 u8tmp;
+	unsigned int utmp;
 
 	*status = 0;
 
@@ -231,11 +143,11 @@ static int mn88472_read_status(struct dvb_frontend *fe, fe_status_t *status)
 		goto err;
 	}
 
-	ret = mn88472_rreg(dev, 0x1a84, &u8tmp);
+	ret = regmap_read(dev->regmap[1], 0x84, &utmp);
 	if (ret)
 		goto err;
 
-	if (u8tmp == 0x08)
+	if (utmp == 0x08)
 		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_VITERBI |
 				FE_HAS_SYNC | FE_HAS_LOCK;
 
@@ -259,11 +171,11 @@ static int mn88472_init(struct dvb_frontend *fe)
 	dev->warm = false;
 
 	/* power on */
-	ret = mn88472_wreg(dev, 0x1c05, 0x00);
+	ret = regmap_write(dev->regmap[2], 0x05, 0x00);
 	if (ret)
 		goto err;
 
-	ret = mn88472_wregs(dev, 0x1c0b, "\x00\x00", 2);
+	ret = regmap_bulk_write(dev->regmap[2], 0x0b, "\x00\x00", 2);
 	if (ret)
 		goto err;
 
@@ -278,7 +190,7 @@ static int mn88472_init(struct dvb_frontend *fe)
 	dev_info(&client->dev, "downloading firmware from file '%s'\n",
 			fw_file);
 
-	ret = mn88472_wreg(dev, 0x18f5, 0x03);
+	ret = regmap_write(dev->regmap[0], 0xf5, 0x03);
 	if (ret)
 		goto err;
 
@@ -288,7 +200,7 @@ static int mn88472_init(struct dvb_frontend *fe)
 		if (len > (dev->i2c_wr_max - 1))
 			len = (dev->i2c_wr_max - 1);
 
-		ret = mn88472_wregs(dev, 0x18f6,
+		ret = regmap_bulk_write(dev->regmap[0], 0xf6,
 				&fw->data[fw->size - remaining], len);
 		if (ret) {
 			dev_err(&client->dev,
@@ -297,7 +209,7 @@ static int mn88472_init(struct dvb_frontend *fe)
 		}
 	}
 
-	ret = mn88472_wreg(dev, 0x18f5, 0x00);
+	ret = regmap_write(dev->regmap[0], 0xf5, 0x00);
 	if (ret)
 		goto err;
 
@@ -325,11 +237,12 @@ static int mn88472_sleep(struct dvb_frontend *fe)
 	dev_dbg(&client->dev, "\n");
 
 	/* power off */
-	ret = mn88472_wreg(dev, 0x1c0b, 0x30);
+	ret = regmap_write(dev->regmap[2], 0x0b, 0x30);
+
 	if (ret)
 		goto err;
 
-	ret = mn88472_wreg(dev, 0x1c05, 0x3e);
+	ret = regmap_write(dev->regmap[2], 0x05, 0x3e);
 	if (ret)
 		goto err;
 
@@ -382,7 +295,11 @@ static int mn88472_probe(struct i2c_client *client,
 	struct mn88472_config *config = client->dev.platform_data;
 	struct mn88472_dev *dev;
 	int ret;
-	u8 u8tmp;
+	unsigned int utmp;
+	static const struct regmap_config regmap_config = {
+		.reg_bits = 8,
+		.val_bits = 8,
+	};
 
 	dev_dbg(&client->dev, "\n");
 
@@ -399,13 +316,18 @@ static int mn88472_probe(struct i2c_client *client,
 		goto err;
 	}
 
-	dev->client[0] = client;
 	dev->i2c_wr_max = config->i2c_wr_max;
+	dev->client[0] = client;
+	dev->regmap[0] = regmap_init_i2c(dev->client[0], &regmap_config);
+	if (IS_ERR(dev->regmap[0])) {
+		ret = PTR_ERR(dev->regmap[0]);
+		goto err_kfree;
+	}
 
 	/* check demod answers to I2C */
-	ret = mn88472_rreg(dev, 0x1c00, &u8tmp);
+	ret = regmap_read(dev->regmap[0], 0x00, &utmp);
 	if (ret)
-		goto err_kfree;
+		goto err_regmap_0_regmap_exit;
 
 	/*
 	 * Chip has three I2C addresses for different register pages. Used
@@ -417,7 +339,12 @@ static int mn88472_probe(struct i2c_client *client,
 		ret = -ENODEV;
 		dev_err(&client->dev, "I2C registration failed\n");
 		if (ret)
-			goto err_kfree;
+			goto err_regmap_0_regmap_exit;
+	}
+	dev->regmap[1] = regmap_init_i2c(dev->client[1], &regmap_config);
+	if (IS_ERR(dev->regmap[1])) {
+		ret = PTR_ERR(dev->regmap[1]);
+		goto err_client_1_i2c_unregister_device;
 	}
 	i2c_set_clientdata(dev->client[1], dev);
 
@@ -426,7 +353,12 @@ static int mn88472_probe(struct i2c_client *client,
 		ret = -ENODEV;
 		dev_err(&client->dev, "2nd I2C registration failed\n");
 		if (ret)
-			goto err_client_1_i2c_unregister_device;
+			goto err_regmap_1_regmap_exit;
+	}
+	dev->regmap[2] = regmap_init_i2c(dev->client[2], &regmap_config);
+	if (IS_ERR(dev->regmap[2])) {
+		ret = PTR_ERR(dev->regmap[2]);
+		goto err_client_2_i2c_unregister_device;
 	}
 	i2c_set_clientdata(dev->client[2], dev);
 
@@ -439,8 +371,14 @@ static int mn88472_probe(struct i2c_client *client,
 	dev_info(&client->dev, "Panasonic MN88472 successfully attached\n");
 	return 0;
 
+err_client_2_i2c_unregister_device:
+	i2c_unregister_device(dev->client[2]);
+err_regmap_1_regmap_exit:
+	regmap_exit(dev->regmap[1]);
 err_client_1_i2c_unregister_device:
 	i2c_unregister_device(dev->client[1]);
+err_regmap_0_regmap_exit:
+	regmap_exit(dev->regmap[0]);
 err_kfree:
 	kfree(dev);
 err:
@@ -454,10 +392,14 @@ static int mn88472_remove(struct i2c_client *client)
 
 	dev_dbg(&client->dev, "\n");
 
+	regmap_exit(dev->regmap[2]);
 	i2c_unregister_device(dev->client[2]);
 
+	regmap_exit(dev->regmap[1]);
 	i2c_unregister_device(dev->client[1]);
 
+	regmap_exit(dev->regmap[0]);
+
 	kfree(dev);
 
 	return 0;
diff --git a/drivers/media/dvb-frontends/mn88472_priv.h b/drivers/media/dvb-frontends/mn88472_priv.h
index 0fde80c..1095949 100644
--- a/drivers/media/dvb-frontends/mn88472_priv.h
+++ b/drivers/media/dvb-frontends/mn88472_priv.h
@@ -20,11 +20,13 @@
 #include "dvb_frontend.h"
 #include "mn88472.h"
 #include <linux/firmware.h>
+#include <linux/regmap.h>
 
 #define MN88472_FIRMWARE "dvb-demod-mn88472-02.fw"
 
 struct mn88472_dev {
 	struct i2c_client *client[3];
+	struct regmap *regmap[3];
 	struct dvb_frontend fe;
 	u16 i2c_wr_max;
 	fe_delivery_system_t delivery_system;
-- 
http://palosaari.fi/

