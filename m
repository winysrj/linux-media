Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58869 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934100AbaKLETl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Nov 2014 23:19:41 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 6/9] mn88473: convert to RegMap API
Date: Wed, 12 Nov 2014 06:19:28 +0200
Message-Id: <1415765971-24378-7-git-send-email-crope@iki.fi>
In-Reply-To: <1415765971-24378-1-git-send-email-crope@iki.fi>
References: <1415765971-24378-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert driver to I2C RegMap API. That offers unified register
access routines, register value caching and more.

We need 3 register maps, one for each register page, as chips has
3 I2C address.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/Kconfig        |   1 +
 drivers/media/dvb-frontends/mn88473.c      | 233 +++++++++++------------------
 drivers/media/dvb-frontends/mn88473_priv.h |   2 +
 3 files changed, 90 insertions(+), 146 deletions(-)

diff --git a/drivers/media/dvb-frontends/Kconfig b/drivers/media/dvb-frontends/Kconfig
index 2720b8f..e60614b 100644
--- a/drivers/media/dvb-frontends/Kconfig
+++ b/drivers/media/dvb-frontends/Kconfig
@@ -474,6 +474,7 @@ config DVB_SI2168
 config DVB_MN88473
 	tristate "Panasonic MN88473"
 	depends on DVB_CORE && I2C
+	select REGMAP_I2C
 	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Say Y when you want to support this frontend.
diff --git a/drivers/media/dvb-frontends/mn88473.c b/drivers/media/dvb-frontends/mn88473.c
index ff67c4c..1659335 100644
--- a/drivers/media/dvb-frontends/mn88473.c
+++ b/drivers/media/dvb-frontends/mn88473.c
@@ -16,95 +16,6 @@
 
 #include "mn88473_priv.h"
 
-static struct dvb_frontend_ops mn88473_ops;
-
-/* write multiple registers */
-static int mn88473_wregs(struct mn88473_dev *dev, u16 reg, const u8 *val, int len)
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
-static int mn88473_rregs(struct mn88473_dev *dev, u16 reg, u8 *val, int len)
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
-static int mn88473_wreg(struct mn88473_dev *dev, u16 reg, u8 val)
-{
-	return mn88473_wregs(dev, reg, &val, 1);
-}
-
-/* read single register */
-static int mn88473_rreg(struct mn88473_dev *dev, u16 reg, u8 *val)
-{
-	return mn88473_rregs(dev, reg, val, 1);
-}
-
 static int mn88473_get_tune_settings(struct dvb_frontend *fe,
 	struct dvb_frontend_tune_settings *s)
 {
@@ -206,64 +117,64 @@ static int mn88473_set_frontend(struct dvb_frontend *fe)
 		goto err;
 	}
 
-	ret = mn88473_wregs(dev, 0x1c05, "\x00", 1);
-	ret = mn88473_wregs(dev, 0x1cfb, "\x13", 1);
-	ret = mn88473_wregs(dev, 0x1cef, "\x13", 1);
-	ret = mn88473_wregs(dev, 0x1cf9, "\x13", 1);
-	ret = mn88473_wregs(dev, 0x1c00, "\x18", 1);
-	ret = mn88473_wregs(dev, 0x1c01, "\x01", 1);
-	ret = mn88473_wregs(dev, 0x1c02, "\x21", 1);
-	ret = mn88473_wreg(dev, 0x1c03, delivery_system_val);
-	ret = mn88473_wregs(dev, 0x1c0b, "\x00", 1);
+	ret = regmap_write(dev->regmap[2], 0x05, 0x00);
+	ret = regmap_write(dev->regmap[2], 0xfb, 0x13);
+	ret = regmap_write(dev->regmap[2], 0xef, 0x13);
+	ret = regmap_write(dev->regmap[2], 0xf9, 0x13);
+	ret = regmap_write(dev->regmap[2], 0x00, 0x18);
+	ret = regmap_write(dev->regmap[2], 0x01, 0x01);
+	ret = regmap_write(dev->regmap[2], 0x02, 0x21);
+	ret = regmap_write(dev->regmap[2], 0x03, delivery_system_val);
+	ret = regmap_write(dev->regmap[2], 0x0b, 0x00);
 
 	for (i = 0; i < sizeof(if_val); i++) {
-		ret = mn88473_wreg(dev, 0x1c10 + i, if_val[i]);
+		ret = regmap_write(dev->regmap[2], 0x10 + i, if_val[i]);
 		if (ret)
 			goto err;
 	}
 
 	for (i = 0; i < sizeof(bw_val); i++) {
-		ret = mn88473_wreg(dev, 0x1c13 + i, bw_val[i]);
+		ret = regmap_write(dev->regmap[2], 0x13 + i, bw_val[i]);
 		if (ret)
 			goto err;
 	}
 
-	ret = mn88473_wregs(dev, 0x1c2d, "\x3b", 1);
-	ret = mn88473_wregs(dev, 0x1c2e, "\x00", 1);
-	ret = mn88473_wregs(dev, 0x1c56, "\x0d", 1);
-	ret = mn88473_wregs(dev, 0x1801, "\xba", 1);
-	ret = mn88473_wregs(dev, 0x1802, "\x13", 1);
-	ret = mn88473_wregs(dev, 0x1803, "\x80", 1);
-	ret = mn88473_wregs(dev, 0x1804, "\xba", 1);
-	ret = mn88473_wregs(dev, 0x1805, "\x91", 1);
-	ret = mn88473_wregs(dev, 0x1807, "\xe7", 1);
-	ret = mn88473_wregs(dev, 0x1808, "\x28", 1);
-	ret = mn88473_wregs(dev, 0x180a, "\x1a", 1);
-	ret = mn88473_wregs(dev, 0x1813, "\x1f", 1);
-	ret = mn88473_wregs(dev, 0x1819, "\x03", 1);
-	ret = mn88473_wregs(dev, 0x181d, "\xb0", 1);
-	ret = mn88473_wregs(dev, 0x182a, "\x72", 1);
-	ret = mn88473_wregs(dev, 0x182d, "\x00", 1);
-	ret = mn88473_wregs(dev, 0x183c, "\x00", 1);
-	ret = mn88473_wregs(dev, 0x183f, "\xf8", 1);
-	ret = mn88473_wregs(dev, 0x1840, "\xf4", 1);
-	ret = mn88473_wregs(dev, 0x1841, "\x08", 1);
-	ret = mn88473_wregs(dev, 0x18d2, "\x29", 1);
-	ret = mn88473_wregs(dev, 0x18d4, "\x55", 1);
-	ret = mn88473_wregs(dev, 0x1a10, "\x10", 1);
-	ret = mn88473_wregs(dev, 0x1a11, "\xab", 1);
-	ret = mn88473_wregs(dev, 0x1a12, "\x0d", 1);
-	ret = mn88473_wregs(dev, 0x1a13, "\xae", 1);
-	ret = mn88473_wregs(dev, 0x1a14, "\x1d", 1);
-	ret = mn88473_wregs(dev, 0x1a15, "\x9d", 1);
-	ret = mn88473_wregs(dev, 0x1abe, "\x08", 1);
-	ret = mn88473_wregs(dev, 0x1c09, "\x08", 1);
-	ret = mn88473_wregs(dev, 0x1c08, "\x1d", 1);
-	ret = mn88473_wregs(dev, 0x18b2, "\x37", 1);
-	ret = mn88473_wregs(dev, 0x18d7, "\x04", 1);
-	ret = mn88473_wregs(dev, 0x1c32, "\x80", 1);
-	ret = mn88473_wregs(dev, 0x1c36, "\x00", 1);
-	ret = mn88473_wregs(dev, 0x1cf8, "\x9f", 1);
+	ret = regmap_write(dev->regmap[2], 0x2d, 0x3b);
+	ret = regmap_write(dev->regmap[2], 0x2e, 0x00);
+	ret = regmap_write(dev->regmap[2], 0x56, 0x0d);
+	ret = regmap_write(dev->regmap[0], 0x01, 0xba);
+	ret = regmap_write(dev->regmap[0], 0x02, 0x13);
+	ret = regmap_write(dev->regmap[0], 0x03, 0x80);
+	ret = regmap_write(dev->regmap[0], 0x04, 0xba);
+	ret = regmap_write(dev->regmap[0], 0x05, 0x91);
+	ret = regmap_write(dev->regmap[0], 0x07, 0xe7);
+	ret = regmap_write(dev->regmap[0], 0x08, 0x28);
+	ret = regmap_write(dev->regmap[0], 0x0a, 0x1a);
+	ret = regmap_write(dev->regmap[0], 0x13, 0x1f);
+	ret = regmap_write(dev->regmap[0], 0x19, 0x03);
+	ret = regmap_write(dev->regmap[0], 0x1d, 0xb0);
+	ret = regmap_write(dev->regmap[0], 0x2a, 0x72);
+	ret = regmap_write(dev->regmap[0], 0x2d, 0x00);
+	ret = regmap_write(dev->regmap[0], 0x3c, 0x00);
+	ret = regmap_write(dev->regmap[0], 0x3f, 0xf8);
+	ret = regmap_write(dev->regmap[0], 0x40, 0xf4);
+	ret = regmap_write(dev->regmap[0], 0x41, 0x08);
+	ret = regmap_write(dev->regmap[0], 0xd2, 0x29);
+	ret = regmap_write(dev->regmap[0], 0xd4, 0x55);
+	ret = regmap_write(dev->regmap[1], 0x10, 0x10);
+	ret = regmap_write(dev->regmap[1], 0x11, 0xab);
+	ret = regmap_write(dev->regmap[1], 0x12, 0x0d);
+	ret = regmap_write(dev->regmap[1], 0x13, 0xae);
+	ret = regmap_write(dev->regmap[1], 0x14, 0x1d);
+	ret = regmap_write(dev->regmap[1], 0x15, 0x9d);
+	ret = regmap_write(dev->regmap[1], 0xbe, 0x08);
+	ret = regmap_write(dev->regmap[2], 0x09, 0x08);
+	ret = regmap_write(dev->regmap[2], 0x08, 0x1d);
+	ret = regmap_write(dev->regmap[0], 0xb2, 0x37);
+	ret = regmap_write(dev->regmap[0], 0xd7, 0x04);
+	ret = regmap_write(dev->regmap[2], 0x32, 0x80);
+	ret = regmap_write(dev->regmap[2], 0x36, 0x00);
+	ret = regmap_write(dev->regmap[2], 0xf8, 0x9f);
 	if (ret)
 		goto err;
 
@@ -320,7 +231,7 @@ static int mn88473_init(struct dvb_frontend *fe)
 	dev_info(&client->dev, "downloading firmware from file '%s'\n",
 			fw_file);
 
-	ret = mn88473_wreg(dev, 0x18f5, 0x03);
+	ret = regmap_write(dev->regmap[0], 0xf5, 0x03);
 	if (ret)
 		goto err;
 
@@ -330,7 +241,7 @@ static int mn88473_init(struct dvb_frontend *fe)
 		if (len > (dev->i2c_wr_max - 1))
 			len = (dev->i2c_wr_max - 1);
 
-		ret = mn88473_wregs(dev, 0x18f6,
+		ret = regmap_bulk_write(dev->regmap[0], 0xf6,
 				&fw->data[fw->size - remaining], len);
 		if (ret) {
 			dev_err(&client->dev, "firmware download failed=%d\n",
@@ -339,7 +250,7 @@ static int mn88473_init(struct dvb_frontend *fe)
 		}
 	}
 
-	ret = mn88473_wreg(dev, 0x18f5, 0x00);
+	ret = regmap_write(dev->regmap[0], 0xf5, 0x00);
 	if (ret)
 		goto err;
 
@@ -366,7 +277,7 @@ static int mn88473_sleep(struct dvb_frontend *fe)
 
 	dev_dbg(&client->dev, "\n");
 
-	ret = mn88473_wreg(dev, 0x1c05, 0x3e);
+	ret = regmap_write(dev->regmap[2], 0x05, 0x3e);
 	if (ret)
 		goto err;
 
@@ -419,7 +330,11 @@ static int mn88473_probe(struct i2c_client *client,
 	struct mn88473_config *config = client->dev.platform_data;
 	struct mn88473_dev *dev;
 	int ret;
-	u8 u8tmp;
+	unsigned int utmp;
+	static const struct regmap_config regmap_config = {
+		.reg_bits = 8,
+		.val_bits = 8,
+	};
 
 	dev_dbg(&client->dev, "\n");
 
@@ -436,13 +351,18 @@ static int mn88473_probe(struct i2c_client *client,
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
-	ret = mn88473_rreg(dev, 0x1c00, &u8tmp);
+	ret = regmap_read(dev->regmap[0], 0x00, &utmp);
 	if (ret)
-		goto err_kfree;
+		goto err_regmap_0_regmap_exit;
 
 	/*
 	 * Chip has three I2C addresses for different register pages. Used
@@ -454,7 +374,12 @@ static int mn88473_probe(struct i2c_client *client,
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
 
@@ -463,7 +388,12 @@ static int mn88473_probe(struct i2c_client *client,
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
 
@@ -476,8 +406,14 @@ static int mn88473_probe(struct i2c_client *client,
 	dev_info(&dev->client[0]->dev, "Panasonic MN88473 successfully attached\n");
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
@@ -491,9 +427,14 @@ static int mn88473_remove(struct i2c_client *client)
 
 	dev_dbg(&client->dev, "\n");
 
+	regmap_exit(dev->regmap[2]);
 	i2c_unregister_device(dev->client[2]);
+
+	regmap_exit(dev->regmap[1]);
 	i2c_unregister_device(dev->client[1]);
 
+	regmap_exit(dev->regmap[0]);
+
 	kfree(dev);
 
 	return 0;
diff --git a/drivers/media/dvb-frontends/mn88473_priv.h b/drivers/media/dvb-frontends/mn88473_priv.h
index 8530437..78af112 100644
--- a/drivers/media/dvb-frontends/mn88473_priv.h
+++ b/drivers/media/dvb-frontends/mn88473_priv.h
@@ -20,11 +20,13 @@
 #include "dvb_frontend.h"
 #include "mn88473.h"
 #include <linux/firmware.h>
+#include <linux/regmap.h>
 
 #define MN88473_FIRMWARE "dvb-demod-mn88473-01.fw"
 
 struct mn88473_dev {
 	struct i2c_client *client[3];
+	struct regmap *regmap[3];
 	struct dvb_frontend fe;
 	u16 i2c_wr_max;
 	fe_delivery_system_t delivery_system;
-- 
http://palosaari.fi/

