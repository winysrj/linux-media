Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39098 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934099AbaKLETl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Nov 2014 23:19:41 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 5/9] mn88473: convert driver to I2C binding
Date: Wed, 12 Nov 2014 06:19:27 +0200
Message-Id: <1415765971-24378-6-git-send-email-crope@iki.fi>
In-Reply-To: <1415765971-24378-1-git-send-email-crope@iki.fi>
References: <1415765971-24378-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Driver was using DVB proprietary binding model. As it is I2C
device, we could change it to normal kernel I2C driver.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/mn88473.c      | 238 ++++++++++++++++++-----------
 drivers/media/dvb-frontends/mn88473.h      |  30 ++--
 drivers/media/dvb-frontends/mn88473_priv.h |   4 +-
 3 files changed, 162 insertions(+), 110 deletions(-)

diff --git a/drivers/media/dvb-frontends/mn88473.c b/drivers/media/dvb-frontends/mn88473.c
index 2c81a83..ff67c4c 100644
--- a/drivers/media/dvb-frontends/mn88473.c
+++ b/drivers/media/dvb-frontends/mn88473.c
@@ -40,13 +40,13 @@ static int mn88473_wregs(struct mn88473_dev *dev, u16 reg, const u8 *val, int le
 	buf[0] = (reg >> 0) & 0xff;
 	memcpy(&buf[1], val, len);
 
-	ret = i2c_transfer(dev->i2c, msg, 1);
+	ret = i2c_transfer(dev->client[0]->adapter, msg, 1);
 	if (ret == 1) {
 		ret = 0;
 	} else {
-		dev_warn(&dev->i2c->dev,
-				"%s: i2c wr failed=%d reg=%02x len=%d\n",
-				KBUILD_MODNAME, ret, reg, len);
+		dev_warn(&dev->client[0]->dev,
+				"i2c wr failed=%d reg=%02x len=%d\n",
+				ret, reg, len);
 		ret = -EREMOTEIO;
 	}
 
@@ -79,14 +79,14 @@ static int mn88473_rregs(struct mn88473_dev *dev, u16 reg, u8 *val, int len)
 
 	buf[0] = (reg >> 0) & 0xff;
 
-	ret = i2c_transfer(dev->i2c, msg, 2);
+	ret = i2c_transfer(dev->client[0]->adapter, msg, 2);
 	if (ret == 2) {
 		memcpy(val, buf, len);
 		ret = 0;
 	} else {
-		dev_warn(&dev->i2c->dev,
-				"%s: i2c rd failed=%d reg=%02x len=%d\n",
-				KBUILD_MODNAME, ret, reg, len);
+		dev_warn(&dev->client[0]->dev,
+				"i2c rd failed=%d reg=%02x len=%d\n",
+				ret, reg, len);
 		ret = -EREMOTEIO;
 	}
 
@@ -114,15 +114,16 @@ static int mn88473_get_tune_settings(struct dvb_frontend *fe,
 
 static int mn88473_set_frontend(struct dvb_frontend *fe)
 {
-	struct mn88473_dev *dev = fe->demodulator_priv;
+	struct i2c_client *client = fe->demodulator_priv;
+	struct mn88473_dev *dev = i2c_get_clientdata(client);
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret, i;
 	u32 if_frequency;
 	u8 delivery_system_val, if_val[3], bw_val[7];
 
-	dev_dbg(&dev->i2c->dev,
-			"%s: delivery_system=%u modulation=%u frequency=%u bandwidth_hz=%u symbol_rate=%u inversion=%d stream_id=%d\n",
-			__func__, c->delivery_system, c->modulation,
+	dev_dbg(&client->dev,
+			"delivery_system=%u modulation=%u frequency=%u bandwidth_hz=%u symbol_rate=%u inversion=%d stream_id=%d\n",
+			c->delivery_system, c->modulation,
 			c->frequency, c->bandwidth_hz, c->symbol_rate,
 			c->inversion, c->stream_id);
 
@@ -188,8 +189,7 @@ static int mn88473_set_frontend(struct dvb_frontend *fe)
 		if (ret)
 			goto err;
 
-		dev_dbg(&dev->i2c->dev, "%s: get_if_frequency=%d\n",
-				__func__, if_frequency);
+		dev_dbg(&client->dev, "get_if_frequency=%d\n", if_frequency);
 	} else {
 		if_frequency = 0;
 	}
@@ -200,8 +200,8 @@ static int mn88473_set_frontend(struct dvb_frontend *fe)
 	case 5070000:
 		break;
 	default:
-		dev_err(&dev->i2c->dev, "%s: IF frequency %d not supported\n",
-				KBUILD_MODNAME, if_frequency);
+		dev_err(&client->dev, "IF frequency %d not supported\n",
+				if_frequency);
 		ret = -EINVAL;
 		goto err;
 	}
@@ -271,13 +271,14 @@ static int mn88473_set_frontend(struct dvb_frontend *fe)
 
 	return 0;
 err:
-	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 static int mn88473_read_status(struct dvb_frontend *fe, fe_status_t *status)
 {
-	struct mn88473_dev *dev = fe->demodulator_priv;
+	struct i2c_client *client = fe->demodulator_priv;
+	struct mn88473_dev *dev = i2c_get_clientdata(client);
 	int ret;
 
 	*status = 0;
@@ -292,49 +293,48 @@ static int mn88473_read_status(struct dvb_frontend *fe, fe_status_t *status)
 
 	return 0;
 err:
-	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 static int mn88473_init(struct dvb_frontend *fe)
 {
-	struct mn88473_dev *dev = fe->demodulator_priv;
+	struct i2c_client *client = fe->demodulator_priv;
+	struct mn88473_dev *dev = i2c_get_clientdata(client);
 	int ret, len, remaining;
 	const struct firmware *fw = NULL;
 	u8 *fw_file = MN88473_FIRMWARE;
 
-	dev_dbg(&dev->i2c->dev, "%s:\n", __func__);
+	dev_dbg(&client->dev, "\n");
 
 	if (dev->warm)
 		return 0;
 
 	/* request the firmware, this will block and timeout */
-	ret = request_firmware(&fw, fw_file, dev->i2c->dev.parent);
+	ret = request_firmware(&fw, fw_file, &client->dev);
 	if (ret) {
-		dev_err(&dev->i2c->dev, "%s: firmare file '%s' not found\n",
-				KBUILD_MODNAME, fw_file);
+		dev_err(&client->dev, "firmare file '%s' not found\n", fw_file);
 		goto err;
 	}
 
-	dev_info(&dev->i2c->dev, "%s: downloading firmware from file '%s'\n",
-			KBUILD_MODNAME, fw_file);
+	dev_info(&client->dev, "downloading firmware from file '%s'\n",
+			fw_file);
 
 	ret = mn88473_wreg(dev, 0x18f5, 0x03);
 	if (ret)
 		goto err;
 
 	for (remaining = fw->size; remaining > 0;
-			remaining -= (dev->cfg->i2c_wr_max - 1)) {
+			remaining -= (dev->i2c_wr_max - 1)) {
 		len = remaining;
-		if (len > (dev->cfg->i2c_wr_max - 1))
-			len = (dev->cfg->i2c_wr_max - 1);
+		if (len > (dev->i2c_wr_max - 1))
+			len = (dev->i2c_wr_max - 1);
 
 		ret = mn88473_wregs(dev, 0x18f6,
 				&fw->data[fw->size - remaining], len);
 		if (ret) {
-			dev_err(&dev->i2c->dev,
-					"%s: firmware download failed=%d\n",
-					KBUILD_MODNAME, ret);
+			dev_err(&client->dev, "firmware download failed=%d\n",
+					ret);
 			goto err;
 		}
 	}
@@ -354,16 +354,17 @@ err:
 	if (fw)
 		release_firmware(fw);
 
-	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 static int mn88473_sleep(struct dvb_frontend *fe)
 {
-	struct mn88473_dev *dev = fe->demodulator_priv;
+	struct i2c_client *client = fe->demodulator_priv;
+	struct mn88473_dev *dev = i2c_get_clientdata(client);
 	int ret;
 
-	dev_dbg(&dev->i2c->dev, "%s:\n", __func__);
+	dev_dbg(&client->dev, "\n");
 
 	ret = mn88473_wreg(dev, 0x1c05, 0x3e);
 	if (ret)
@@ -373,90 +374,149 @@ static int mn88473_sleep(struct dvb_frontend *fe)
 
 	return 0;
 err:
-	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
-static void mn88473_release(struct dvb_frontend *fe)
-{
-	struct mn88473_dev *dev = fe->demodulator_priv;
-	kfree(dev);
-}
+static struct dvb_frontend_ops mn88473_ops = {
+	.delsys = {SYS_DVBT, SYS_DVBT2, SYS_DVBC_ANNEX_AC},
+	.info = {
+		.name = "Panasonic MN88473",
+		.caps =	FE_CAN_FEC_1_2                 |
+			FE_CAN_FEC_2_3                 |
+			FE_CAN_FEC_3_4                 |
+			FE_CAN_FEC_5_6                 |
+			FE_CAN_FEC_7_8                 |
+			FE_CAN_FEC_AUTO                |
+			FE_CAN_QPSK                    |
+			FE_CAN_QAM_16                  |
+			FE_CAN_QAM_32                  |
+			FE_CAN_QAM_64                  |
+			FE_CAN_QAM_128                 |
+			FE_CAN_QAM_256                 |
+			FE_CAN_QAM_AUTO                |
+			FE_CAN_TRANSMISSION_MODE_AUTO  |
+			FE_CAN_GUARD_INTERVAL_AUTO     |
+			FE_CAN_HIERARCHY_AUTO          |
+			FE_CAN_MUTE_TS                 |
+			FE_CAN_2G_MODULATION           |
+			FE_CAN_MULTISTREAM
+	},
+
+	.get_tune_settings = mn88473_get_tune_settings,
+
+	.init = mn88473_init,
+	.sleep = mn88473_sleep,
 
-struct dvb_frontend *mn88473_attach(const struct mn88473_config *cfg,
-		struct i2c_adapter *i2c)
+	.set_frontend = mn88473_set_frontend,
+
+	.read_status = mn88473_read_status,
+};
+
+static int mn88473_probe(struct i2c_client *client,
+		const struct i2c_device_id *id)
 {
-	int ret;
+	struct mn88473_config *config = client->dev.platform_data;
 	struct mn88473_dev *dev;
+	int ret;
 	u8 u8tmp;
 
-	dev_dbg(&i2c->dev, "%s:\n", __func__);
+	dev_dbg(&client->dev, "\n");
 
-	/* allocate memory for the internal state */
-	dev = kzalloc(sizeof(struct mn88473_dev), GFP_KERNEL);
-	if (!dev) {
+	/* Caller really need to provide pointer for frontend we create. */
+	if (config->fe == NULL) {
+		dev_err(&client->dev, "frontend pointer not defined\n");
+		ret = -EINVAL;
+		goto err;
+	}
+
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (dev == NULL) {
 		ret = -ENOMEM;
-		dev_err(&i2c->dev, "%s: kzalloc() failed\n", KBUILD_MODNAME);
 		goto err;
 	}
 
-	dev->cfg = cfg;
-	dev->i2c = i2c;
+	dev->client[0] = client;
+	dev->i2c_wr_max = config->i2c_wr_max;
 
-	/* check demod responds to I2C */
+	/* check demod answers to I2C */
 	ret = mn88473_rreg(dev, 0x1c00, &u8tmp);
 	if (ret)
-		goto err;
+		goto err_kfree;
+
+	/*
+	 * Chip has three I2C addresses for different register pages. Used
+	 * addresses are 0x18, 0x1a and 0x1c. We register two dummy clients,
+	 * 0x1a and 0x1c, in order to get own I2C client for each register page.
+	 */
+	dev->client[1] = i2c_new_dummy(client->adapter, 0x1a);
+	if (dev->client[1] == NULL) {
+		ret = -ENODEV;
+		dev_err(&client->dev, "I2C registration failed\n");
+		if (ret)
+			goto err_kfree;
+	}
+	i2c_set_clientdata(dev->client[1], dev);
+
+	dev->client[2] = i2c_new_dummy(client->adapter, 0x1c);
+	if (dev->client[2] == NULL) {
+		ret = -ENODEV;
+		dev_err(&client->dev, "2nd I2C registration failed\n");
+		if (ret)
+			goto err_client_1_i2c_unregister_device;
+	}
+	i2c_set_clientdata(dev->client[2], dev);
 
 	/* create dvb_frontend */
 	memcpy(&dev->fe.ops, &mn88473_ops, sizeof(struct dvb_frontend_ops));
-	dev->fe.demodulator_priv = dev;
+	dev->fe.demodulator_priv = client;
+	*config->fe = &dev->fe;
+	i2c_set_clientdata(client, dev);
 
-	return &dev->fe;
-err:
-	dev_dbg(&i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_info(&dev->client[0]->dev, "Panasonic MN88473 successfully attached\n");
+	return 0;
+
+err_client_1_i2c_unregister_device:
+	i2c_unregister_device(dev->client[1]);
+err_kfree:
 	kfree(dev);
-	return NULL;
+err:
+	dev_dbg(&client->dev, "failed=%d\n", ret);
+	return ret;
 }
-EXPORT_SYMBOL(mn88473_attach);
 
-static struct dvb_frontend_ops mn88473_ops = {
-	.delsys = {SYS_DVBT, SYS_DVBT2, SYS_DVBC_ANNEX_AC},
-	.info = {
-		.name = "Panasonic MN88473",
-		.caps =	FE_CAN_FEC_1_2			|
-			FE_CAN_FEC_2_3			|
-			FE_CAN_FEC_3_4			|
-			FE_CAN_FEC_5_6			|
-			FE_CAN_FEC_7_8			|
-			FE_CAN_FEC_AUTO			|
-			FE_CAN_QPSK			|
-			FE_CAN_QAM_16			|
-			FE_CAN_QAM_32			|
-			FE_CAN_QAM_64			|
-			FE_CAN_QAM_128			|
-			FE_CAN_QAM_256			|
-			FE_CAN_QAM_AUTO			|
-			FE_CAN_TRANSMISSION_MODE_AUTO	|
-			FE_CAN_GUARD_INTERVAL_AUTO	|
-			FE_CAN_HIERARCHY_AUTO		|
-			FE_CAN_MUTE_TS			|
-			FE_CAN_2G_MODULATION		|
-			FE_CAN_MULTISTREAM
-	},
+static int mn88473_remove(struct i2c_client *client)
+{
+	struct mn88473_dev *dev = i2c_get_clientdata(client);
 
-	.release = mn88473_release,
+	dev_dbg(&client->dev, "\n");
 
-	.get_tune_settings = mn88473_get_tune_settings,
+	i2c_unregister_device(dev->client[2]);
+	i2c_unregister_device(dev->client[1]);
 
-	.init = mn88473_init,
-	.sleep = mn88473_sleep,
+	kfree(dev);
 
-	.set_frontend = mn88473_set_frontend,
+	return 0;
+}
 
-	.read_status = mn88473_read_status,
+static const struct i2c_device_id mn88473_id_table[] = {
+	{"mn88473", 0},
+	{}
+};
+MODULE_DEVICE_TABLE(i2c, mn88473_id_table);
+
+static struct i2c_driver mn88473_driver = {
+	.driver = {
+		.owner	= THIS_MODULE,
+		.name	= "mn88473",
+	},
+	.probe		= mn88473_probe,
+	.remove		= mn88473_remove,
+	.id_table	= mn88473_id_table,
 };
 
+module_i2c_driver(mn88473_driver);
+
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
 MODULE_DESCRIPTION("Panasonic MN88473 DVB-T/T2/C demodulator driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/dvb-frontends/mn88473.h b/drivers/media/dvb-frontends/mn88473.h
index 13b51b6..a373ec9 100644
--- a/drivers/media/dvb-frontends/mn88473.h
+++ b/drivers/media/dvb-frontends/mn88473.h
@@ -21,26 +21,18 @@
 
 struct mn88473_config {
 	/*
-	 * max bytes I2C client could write
-	 * Value must be set.
+	 * Max num of bytes given I2C adapter could write at once.
+	 * Default: none
 	 */
-	int i2c_wr_max;
-};
+	u16 i2c_wr_max;
 
-#if IS_ENABLED(CONFIG_DVB_MN88473)
-extern struct dvb_frontend *mn88473_attach(
-	const struct mn88473_config *cfg,
-	struct i2c_adapter *i2c
-);
-#else
-static inline struct dvb_frontend *mn88473_attach(
-	const struct mn88473_config *cfg,
-	struct i2c_adapter *i2c
-)
-{
-	dev_warn(&i2c->dev, "%s: driver disabled by Kconfig\n", __func__);
-	return NULL;
-}
-#endif
+
+	/* Everything after that is returned by the driver. */
+
+	/*
+	 * DVB frontend.
+	 */
+	struct dvb_frontend **fe;
+};
 
 #endif
diff --git a/drivers/media/dvb-frontends/mn88473_priv.h b/drivers/media/dvb-frontends/mn88473_priv.h
index c40b3a5..8530437 100644
--- a/drivers/media/dvb-frontends/mn88473_priv.h
+++ b/drivers/media/dvb-frontends/mn88473_priv.h
@@ -24,9 +24,9 @@
 #define MN88473_FIRMWARE "dvb-demod-mn88473-01.fw"
 
 struct mn88473_dev {
-	struct i2c_adapter *i2c;
-	const struct mn88473_config *cfg;
+	struct i2c_client *client[3];
 	struct dvb_frontend fe;
+	u16 i2c_wr_max;
 	fe_delivery_system_t delivery_system;
 	bool warm; /* FW running */
 };
-- 
http://palosaari.fi/

