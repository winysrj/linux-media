Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45443 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757066AbaIDChC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Sep 2014 22:37:02 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 17/37] it913x: re-implement sleep
Date: Thu,  4 Sep 2014 05:36:25 +0300
Message-Id: <1409798205-25645-17-git-send-email-crope@iki.fi>
In-Reply-To: <1409798205-25645-1-git-send-email-crope@iki.fi>
References: <1409798205-25645-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Re-implement sleep. Based USB sniffs taken from the latest Hauppauge
windows driver version 07/10/2014, 14.6.23.32191.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/it913x.c         | 76 +++++++++++++++++++++++++++--------
 drivers/media/tuners/it913x.h         | 10 ++++-
 drivers/media/tuners/it913x_priv.h    | 27 -------------
 drivers/media/usb/dvb-usb-v2/af9035.c | 14 +++++++
 4 files changed, 83 insertions(+), 44 deletions(-)

diff --git a/drivers/media/tuners/it913x.c b/drivers/media/tuners/it913x.c
index f3e212c..11d391a 100644
--- a/drivers/media/tuners/it913x.c
+++ b/drivers/media/tuners/it913x.c
@@ -26,7 +26,8 @@ struct it913x_dev {
 	struct i2c_client *client;
 	struct regmap *regmap;
 	struct dvb_frontend *fe;
-	u8 chip_ver;
+	u8 chip_ver:2;
+	u8 role:2;
 	u8 firmware_ver;
 	u16 tun_xtal;
 	u8 tun_fdiv;
@@ -122,6 +123,62 @@ static int it913x_init(struct dvb_frontend *fe)
 	return regmap_write(dev->regmap, 0x80ed81, val);
 }
 
+static int it913x_sleep(struct dvb_frontend *fe)
+{
+	struct it913x_dev *dev = fe->tuner_priv;
+	int ret, len;
+
+	dev_dbg(&dev->client->dev, "role=%u\n", dev->role);
+
+	ret  = regmap_bulk_write(dev->regmap, 0x80ec40, "\x00", 1);
+	if (ret)
+		goto err;
+
+	/*
+	 * Writing '0x00' to master tuner register '0x80ec08' causes slave tuner
+	 * communication lost. Due to that, we cannot put master full sleep.
+	 */
+	if (dev->role == IT913X_ROLE_DUAL_MASTER)
+		len = 4;
+	else
+		len = 15;
+
+	dev_dbg(&dev->client->dev, "role=%u len=%d\n", dev->role, len);
+
+	ret = regmap_bulk_write(dev->regmap, 0x80ec02,
+			"\x3f\x1f\x3f\x3e\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00",
+			len);
+	if (ret)
+		goto err;
+
+	ret = regmap_bulk_write(dev->regmap, 0x80ec12, "\x00\x00\x00\x00", 4);
+	if (ret)
+		goto err;
+
+	ret = regmap_bulk_write(dev->regmap, 0x80ec17,
+			"\x00\x00\x00\x00\x00\x00\x00\x00\x00", 9);
+	if (ret)
+		goto err;
+
+	ret = regmap_bulk_write(dev->regmap, 0x80ec22,
+			"\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00", 10);
+	if (ret)
+		goto err;
+
+	ret = regmap_bulk_write(dev->regmap, 0x80ec20, "\x00", 1);
+	if (ret)
+		goto err;
+
+	ret = regmap_bulk_write(dev->regmap, 0x80ec3f, "\x01", 1);
+	if (ret)
+		goto err;
+
+	return 0;
+err:
+	dev_dbg(&dev->client->dev, "failed %d\n", ret);
+	return ret;
+}
+
 static int it9137_set_params(struct dvb_frontend *fe)
 {
 	struct it913x_dev *dev = fe->tuner_priv;
@@ -274,20 +331,6 @@ static int it9137_set_params(struct dvb_frontend *fe)
 	return (ret < 0) ? -ENODEV : 0;
 }
 
-/* Power sequence */
-/* Power Up	Tuner on -> Frontend suspend off -> Tuner clk on */
-/* Power Down	Frontend suspend on -> Tuner clk off -> Tuner off */
-
-static int it913x_sleep(struct dvb_frontend *fe)
-{
-	struct it913x_dev *dev = fe->tuner_priv;
-
-	if (dev->chip_ver == 0x01)
-		return it913x_script_loader(dev, it9135ax_tuner_off);
-	else
-		return it913x_script_loader(dev, it9137_tuner_off);
-}
-
 static const struct dvb_tuner_ops it913x_tuner_ops = {
 	.info = {
 		.name           = "ITE Tech IT913X",
@@ -323,6 +366,7 @@ static int it913x_probe(struct i2c_client *client,
 	dev->client = client;
 	dev->fe = cfg->fe;
 	dev->chip_ver = cfg->chip_ver;
+	dev->role = cfg->role;
 	dev->firmware_ver = 1;
 	dev->regmap = regmap_init_i2c(client, &regmap_config);
 	if (IS_ERR(dev->regmap)) {
@@ -349,7 +393,7 @@ static int it913x_probe(struct i2c_client *client,
 
 	dev_info(&dev->client->dev, "ITE IT913X %s successfully attached\n",
 			chip_ver_str);
-	dev_dbg(&dev->client->dev, "chip_ver=%02x\n", dev->chip_ver);
+	dev_dbg(&dev->client->dev, "chip_ver=%u role=%u\n", dev->chip_ver, dev->role);
 	return 0;
 
 err_regmap_exit:
diff --git a/drivers/media/tuners/it913x.h b/drivers/media/tuners/it913x.h
index 9789c4d..33de53d 100644
--- a/drivers/media/tuners/it913x.h
+++ b/drivers/media/tuners/it913x.h
@@ -40,7 +40,15 @@ struct it913x_config {
 	 * 1 = IT9135 AX
 	 * 2 = IT9135 BX
 	 */
-	u8 chip_ver:2;
+	unsigned int chip_ver:2;
+
+	/*
+	 * tuner role
+	 */
+#define IT913X_ROLE_SINGLE         0
+#define IT913X_ROLE_DUAL_MASTER    1
+#define IT913X_ROLE_DUAL_SLAVE     2
+	unsigned int role:2;
 };
 
 #endif
diff --git a/drivers/media/tuners/it913x_priv.h b/drivers/media/tuners/it913x_priv.h
index 3ed2d3c..41f9b2a 100644
--- a/drivers/media/tuners/it913x_priv.h
+++ b/drivers/media/tuners/it913x_priv.h
@@ -33,33 +33,6 @@ struct it913xset {	u32 address;
 			u8 count;
 };
 
-/* Tuner setting scripts for IT9135 AX */
-static struct it913xset it9135ax_tuner_off[] = {
-	{0x80ec40, {0x00}, 0x01}, /* Power Down Tuner */
-	{0x80ec02, {0x3f}, 0x01},
-	{0x80ec03, {0x1f}, 0x01},
-	{0x80ec04, {0x3f}, 0x01},
-	{0x80ec05, {0x3f}, 0x01},
-	{0x80ec3f, {0x01}, 0x01},
-	{0x000000, {0x00}, 0x00}, /* Terminating Entry */
-};
-
-/* Tuner setting scripts (still keeping it9137) */
-static struct it913xset it9137_tuner_off[] = {
-	{0x80ec40, {0x00}, 0x01}, /* Power Down Tuner */
-	{0x80ec02, {0x3f, 0x1f, 0x3f, 0x3f}, 0x04},
-	{0x80ec06, {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-				0x00, 0x00, 0x00, 0x00}, 0x0c},
-	{0x80ec12, {0x00, 0x00, 0x00, 0x00}, 0x04},
-	{0x80ec17, {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-				0x00}, 0x09},
-	{0x80ec22, {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-				0x00, 0x00}, 0x0a},
-	{0x80ec20, {0x00}, 0x01},
-	{0x80ec3f, {0x01}, 0x01},
-	{0x000000, {0x00}, 0x00}, /* Terminating Entry */
-};
-
 static struct it913xset set_it9135_template[] = {
 	{0x80ee06, {0x00}, 0x01},
 	{0x80ec56, {0x00}, 0x01},
diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 1a5b600..533c96e 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -1324,6 +1324,13 @@ static int af9035_tuner_attach(struct dvb_usb_adapter *adap)
 			.chip_ver = 1,
 		};
 
+		if (state->dual_mode) {
+			if (adap->id == 0)
+				it913x_config.role = IT913X_ROLE_DUAL_MASTER;
+			else
+				it913x_config.role = IT913X_ROLE_DUAL_SLAVE;
+		}
+
 		ret = af9035_add_i2c_dev(d, "it913x",
 				state->af9033_config[adap->id].i2c_addr,
 				&it913x_config);
@@ -1342,6 +1349,13 @@ static int af9035_tuner_attach(struct dvb_usb_adapter *adap)
 			.chip_ver = 2,
 		};
 
+		if (state->dual_mode) {
+			if (adap->id == 0)
+				it913x_config.role = IT913X_ROLE_DUAL_MASTER;
+			else
+				it913x_config.role = IT913X_ROLE_DUAL_SLAVE;
+		}
+
 		ret = af9035_add_i2c_dev(d, "it913x",
 				state->af9033_config[adap->id].i2c_addr,
 				&it913x_config);
-- 
http://palosaari.fi/

