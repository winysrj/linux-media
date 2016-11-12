Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:32961 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753823AbcKLKey (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 Nov 2016 05:34:54 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 6/9] it913x: change driver model from i2c to platform
Date: Sat, 12 Nov 2016 12:33:58 +0200
Message-Id: <1478946841-2807-6-git-send-email-crope@iki.fi>
In-Reply-To: <1478946841-2807-1-git-send-email-crope@iki.fi>
References: <1478946841-2807-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That tuner is integrated to demodulator and communicates via
demodulators address space. We cannot register both demodulator
and tuner having same address to same I2C bus, so better to change
it platform driver in order to implement I2C adapter correctly.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/it913x.c | 89 +++++++++++++++++--------------------------
 drivers/media/tuners/it913x.h | 29 ++++++--------
 2 files changed, 48 insertions(+), 70 deletions(-)

diff --git a/drivers/media/tuners/it913x.c b/drivers/media/tuners/it913x.c
index 6c3ef21..085e33c 100644
--- a/drivers/media/tuners/it913x.c
+++ b/drivers/media/tuners/it913x.c
@@ -21,10 +21,11 @@
  */
 
 #include "it913x.h"
+#include <linux/platform_device.h>
 #include <linux/regmap.h>
 
 struct it913x_dev {
-	struct i2c_client *client;
+	struct platform_device *pdev;
 	struct regmap *regmap;
 	struct dvb_frontend *fe;
 	u8 chip_ver:2;
@@ -39,13 +40,14 @@ struct it913x_dev {
 static int it913x_init(struct dvb_frontend *fe)
 {
 	struct it913x_dev *dev = fe->tuner_priv;
+	struct platform_device *pdev = dev->pdev;
 	int ret;
 	unsigned int utmp;
 	u8 iqik_m_cal, nv_val, buf[2];
 	static const u8 nv[] = {48, 32, 24, 16, 12, 8, 6, 4, 2};
 	unsigned long timeout;
 
-	dev_dbg(&dev->client->dev, "role %u\n", dev->role);
+	dev_dbg(&pdev->dev, "role %u\n", dev->role);
 
 	ret = regmap_write(dev->regmap, 0x80ec4c, 0x68);
 	if (ret)
@@ -73,7 +75,7 @@ static int it913x_init(struct dvb_frontend *fe)
 		iqik_m_cal = 6;
 		break;
 	default:
-		dev_err(&dev->client->dev, "unknown clock identifier %d\n", utmp);
+		dev_err(&pdev->dev, "unknown clock identifier %d\n", utmp);
 		goto err;
 	}
 
@@ -98,14 +100,14 @@ static int it913x_init(struct dvb_frontend *fe)
 			break;
 	}
 
-	dev_dbg(&dev->client->dev, "r_fbc_m_bdry took %u ms, val %u\n",
+	dev_dbg(&pdev->dev, "r_fbc_m_bdry took %u ms, val %u\n",
 			jiffies_to_msecs(jiffies) -
 			(jiffies_to_msecs(timeout) - TIMEOUT), utmp);
 
 	dev->fn_min = dev->xtal * utmp;
 	dev->fn_min /= (dev->fdiv * nv_val);
 	dev->fn_min *= 1000;
-	dev_dbg(&dev->client->dev, "fn_min %u\n", dev->fn_min);
+	dev_dbg(&pdev->dev, "fn_min %u\n", dev->fn_min);
 
 	/*
 	 * Chip version BX never sets that flag so we just wait 50ms in that
@@ -125,7 +127,7 @@ static int it913x_init(struct dvb_frontend *fe)
 				break;
 		}
 
-		dev_dbg(&dev->client->dev, "p_tsm_init_mode took %u ms, val %u\n",
+		dev_dbg(&pdev->dev, "p_tsm_init_mode took %u ms, val %u\n",
 				jiffies_to_msecs(jiffies) -
 				(jiffies_to_msecs(timeout) - TIMEOUT), utmp);
 	} else {
@@ -152,16 +154,17 @@ static int it913x_init(struct dvb_frontend *fe)
 
 	return 0;
 err:
-	dev_dbg(&dev->client->dev, "failed %d\n", ret);
+	dev_dbg(&pdev->dev, "failed %d\n", ret);
 	return ret;
 }
 
 static int it913x_sleep(struct dvb_frontend *fe)
 {
 	struct it913x_dev *dev = fe->tuner_priv;
+	struct platform_device *pdev = dev->pdev;
 	int ret, len;
 
-	dev_dbg(&dev->client->dev, "role %u\n", dev->role);
+	dev_dbg(&pdev->dev, "role %u\n", dev->role);
 
 	dev->active = false;
 
@@ -178,7 +181,7 @@ static int it913x_sleep(struct dvb_frontend *fe)
 	else
 		len = 15;
 
-	dev_dbg(&dev->client->dev, "role %u, len %d\n", dev->role, len);
+	dev_dbg(&pdev->dev, "role %u, len %d\n", dev->role, len);
 
 	ret = regmap_bulk_write(dev->regmap, 0x80ec02,
 			"\x3f\x1f\x3f\x3e\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00",
@@ -210,13 +213,14 @@ static int it913x_sleep(struct dvb_frontend *fe)
 
 	return 0;
 err:
-	dev_dbg(&dev->client->dev, "failed %d\n", ret);
+	dev_dbg(&pdev->dev, "failed %d\n", ret);
 	return ret;
 }
 
 static int it913x_set_params(struct dvb_frontend *fe)
 {
 	struct it913x_dev *dev = fe->tuner_priv;
+	struct platform_device *pdev = dev->pdev;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
 	unsigned int utmp;
@@ -224,7 +228,7 @@ static int it913x_set_params(struct dvb_frontend *fe)
 	u16 iqik_m_cal, n_div;
 	u8 u8tmp, n, l_band, lna_band;
 
-	dev_dbg(&dev->client->dev, "role=%u, frequency %u, bandwidth_hz %u\n",
+	dev_dbg(&pdev->dev, "role=%u, frequency %u, bandwidth_hz %u\n",
 			dev->role, c->frequency, c->bandwidth_hz);
 
 	if (!dev->active) {
@@ -290,7 +294,7 @@ static int it913x_set_params(struct dvb_frontend *fe)
 	pre_lo_freq += (u32) n << 13;
 	/* Frequency OMEGA_IQIK_M_CAL_MID*/
 	t_cal_freq = pre_lo_freq + (u32)iqik_m_cal;
-	dev_dbg(&dev->client->dev, "t_cal_freq %u, pre_lo_freq %u\n",
+	dev_dbg(&pdev->dev, "t_cal_freq %u, pre_lo_freq %u\n",
 			t_cal_freq, pre_lo_freq);
 
 	if (c->frequency <=         440000000) {
@@ -369,7 +373,7 @@ static int it913x_set_params(struct dvb_frontend *fe)
 
 	return 0;
 err:
-	dev_dbg(&dev->client->dev, "failed %d\n", ret);
+	dev_dbg(&pdev->dev, "failed %d\n", ret);
 	return ret;
 }
 
@@ -385,40 +389,31 @@ static const struct dvb_tuner_ops it913x_tuner_ops = {
 	.set_params = it913x_set_params,
 };
 
-static int it913x_probe(struct i2c_client *client,
-		const struct i2c_device_id *id)
+static int it913x_probe(struct platform_device *pdev)
 {
-	struct it913x_config *cfg = client->dev.platform_data;
-	struct dvb_frontend *fe = cfg->fe;
+	struct it913x_platform_data *pdata = pdev->dev.platform_data;
+	struct dvb_frontend *fe = pdata->fe;
 	struct it913x_dev *dev;
 	int ret;
 	char *chip_ver_str;
-	static const struct regmap_config regmap_config = {
-		.reg_bits = 24,
-		.val_bits = 8,
-	};
 
 	dev = kzalloc(sizeof(struct it913x_dev), GFP_KERNEL);
 	if (dev == NULL) {
 		ret = -ENOMEM;
-		dev_err(&client->dev, "kzalloc() failed\n");
+		dev_err(&pdev->dev, "kzalloc() failed\n");
 		goto err;
 	}
 
-	dev->client = client;
-	dev->fe = cfg->fe;
-	dev->chip_ver = cfg->chip_ver;
-	dev->role = cfg->role;
-	dev->regmap = regmap_init_i2c(client, &regmap_config);
-	if (IS_ERR(dev->regmap)) {
-		ret = PTR_ERR(dev->regmap);
-		goto err_kfree;
-	}
+	dev->pdev = pdev;
+	dev->regmap = pdata->regmap;
+	dev->fe = pdata->fe;
+	dev->chip_ver = pdata->chip_ver;
+	dev->role = pdata->role;
 
 	fe->tuner_priv = dev;
 	memcpy(&fe->ops.tuner_ops, &it913x_tuner_ops,
 			sizeof(struct dvb_tuner_ops));
-	i2c_set_clientdata(client, dev);
+	platform_set_drvdata(pdev, dev);
 
 	if (dev->chip_ver == 1)
 		chip_ver_str = "AX";
@@ -427,51 +422,39 @@ static int it913x_probe(struct i2c_client *client,
 	else
 		chip_ver_str = "??";
 
-	dev_info(&dev->client->dev, "ITE IT913X %s successfully attached\n",
-			chip_ver_str);
-	dev_dbg(&dev->client->dev, "chip_ver %u, role %u\n",
-			dev->chip_ver, dev->role);
+	dev_info(&pdev->dev, "ITE IT913X %s successfully attached\n",
+		 chip_ver_str);
+	dev_dbg(&pdev->dev, "chip_ver %u, role %u\n", dev->chip_ver, dev->role);
 	return 0;
-
-err_kfree:
-	kfree(dev);
 err:
-	dev_dbg(&client->dev, "failed %d\n", ret);
+	dev_dbg(&pdev->dev, "failed %d\n", ret);
 	return ret;
 }
 
-static int it913x_remove(struct i2c_client *client)
+static int it913x_remove(struct platform_device *pdev)
 {
-	struct it913x_dev *dev = i2c_get_clientdata(client);
+	struct it913x_dev *dev = platform_get_drvdata(pdev);
 	struct dvb_frontend *fe = dev->fe;
 
-	dev_dbg(&client->dev, "\n");
+	dev_dbg(&pdev->dev, "\n");
 
 	memset(&fe->ops.tuner_ops, 0, sizeof(struct dvb_tuner_ops));
 	fe->tuner_priv = NULL;
-	regmap_exit(dev->regmap);
 	kfree(dev);
 
 	return 0;
 }
 
-static const struct i2c_device_id it913x_id_table[] = {
-	{"it913x", 0},
-	{}
-};
-MODULE_DEVICE_TABLE(i2c, it913x_id_table);
-
-static struct i2c_driver it913x_driver = {
+static struct platform_driver it913x_driver = {
 	.driver = {
 		.name	= "it913x",
 		.suppress_bind_attrs	= true,
 	},
 	.probe		= it913x_probe,
 	.remove		= it913x_remove,
-	.id_table	= it913x_id_table,
 };
 
-module_i2c_driver(it913x_driver);
+module_platform_driver(it913x_driver);
 
 MODULE_DESCRIPTION("ITE IT913X silicon tuner driver");
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
diff --git a/drivers/media/tuners/it913x.h b/drivers/media/tuners/it913x.h
index 33de53d..aa18862 100644
--- a/drivers/media/tuners/it913x.h
+++ b/drivers/media/tuners/it913x.h
@@ -25,30 +25,25 @@
 
 #include "dvb_frontend.h"
 
-/*
- * I2C address
- * 0x38, 0x3a, 0x3c, 0x3e
+/**
+ * struct it913x_platform_data - Platform data for the it913x driver
+ * @regmap: af9033 demod driver regmap.
+ * @dvb_frontend: af9033 demod driver DVB frontend.
+ * @chip_ver: Used chip version. 1=IT9133 AX, 2=IT9133 BX.
+ * @role: Chip role, single or dual configuration.
  */
-struct it913x_config {
-	/*
-	 * pointer to DVB frontend
-	 */
-	struct dvb_frontend *fe;
 
-	/*
-	 * chip version
-	 * 1 = IT9135 AX
-	 * 2 = IT9135 BX
-	 */
+struct it913x_platform_data {
+	struct regmap *regmap;
+	struct dvb_frontend *fe;
 	unsigned int chip_ver:2;
-
-	/*
-	 * tuner role
-	 */
 #define IT913X_ROLE_SINGLE         0
 #define IT913X_ROLE_DUAL_MASTER    1
 #define IT913X_ROLE_DUAL_SLAVE     2
 	unsigned int role:2;
 };
 
+/* Backwards compatibility */
+#define it913x_config it913x_platform_data
+
 #endif
-- 
http://palosaari.fi/

