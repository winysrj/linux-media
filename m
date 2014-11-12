Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54590 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934139AbaKLELh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Nov 2014 23:11:37 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 09/11] mn88472: move to staging
Date: Wed, 12 Nov 2014 06:11:15 +0200
Message-Id: <1415765477-23153-10-git-send-email-crope@iki.fi>
In-Reply-To: <1415765477-23153-1-git-send-email-crope@iki.fi>
References: <1415765477-23153-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is not ready enough to be released on mainline.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/Kconfig          |   8 -
 drivers/media/dvb-frontends/Makefile         |   1 -
 drivers/media/dvb-frontends/mn88472.c        | 523 ---------------------------
 drivers/media/dvb-frontends/mn88472_priv.h   |  36 --
 drivers/staging/media/Kconfig                |   2 +
 drivers/staging/media/Makefile               |   1 +
 drivers/staging/media/mn88472/Kconfig        |   7 +
 drivers/staging/media/mn88472/Makefile       |   5 +
 drivers/staging/media/mn88472/mn88472.c      | 523 +++++++++++++++++++++++++++
 drivers/staging/media/mn88472/mn88472_priv.h |  36 ++
 10 files changed, 574 insertions(+), 568 deletions(-)
 delete mode 100644 drivers/media/dvb-frontends/mn88472.c
 delete mode 100644 drivers/media/dvb-frontends/mn88472_priv.h
 create mode 100644 drivers/staging/media/mn88472/Kconfig
 create mode 100644 drivers/staging/media/mn88472/Makefile
 create mode 100644 drivers/staging/media/mn88472/mn88472.c
 create mode 100644 drivers/staging/media/mn88472/mn88472_priv.h

diff --git a/drivers/media/dvb-frontends/Kconfig b/drivers/media/dvb-frontends/Kconfig
index 207843e..6c75418 100644
--- a/drivers/media/dvb-frontends/Kconfig
+++ b/drivers/media/dvb-frontends/Kconfig
@@ -441,14 +441,6 @@ config DVB_CXD2820R
 	help
 	  Say Y when you want to support this frontend.
 
-config DVB_MN88472
-	tristate "Panasonic MN88472"
-	depends on DVB_CORE && I2C
-	select REGMAP_I2C
-	default m if !MEDIA_SUBDRV_AUTOSELECT
-	help
-	  Say Y when you want to support this frontend.
-
 config DVB_RTL2830
 	tristate "Realtek RTL2830 DVB-T"
 	depends on DVB_CORE && I2C
diff --git a/drivers/media/dvb-frontends/Makefile b/drivers/media/dvb-frontends/Makefile
index b82225f6..ba59df6 100644
--- a/drivers/media/dvb-frontends/Makefile
+++ b/drivers/media/dvb-frontends/Makefile
@@ -103,7 +103,6 @@ obj-$(CONFIG_DVB_MB86A20S) += mb86a20s.o
 obj-$(CONFIG_DVB_IX2505V) += ix2505v.o
 obj-$(CONFIG_DVB_STV0367) += stv0367.o
 obj-$(CONFIG_DVB_CXD2820R) += cxd2820r.o
-obj-$(CONFIG_DVB_MN88472) += mn88472.o
 obj-$(CONFIG_DVB_DRXK) += drxk.o
 obj-$(CONFIG_DVB_TDA18271C2DD) += tda18271c2dd.o
 obj-$(CONFIG_DVB_SI2165) += si2165.o
diff --git a/drivers/media/dvb-frontends/mn88472.c b/drivers/media/dvb-frontends/mn88472.c
deleted file mode 100644
index 52de8f8..0000000
--- a/drivers/media/dvb-frontends/mn88472.c
+++ /dev/null
@@ -1,523 +0,0 @@
-/*
- * Panasonic MN88472 DVB-T/T2/C demodulator driver
- *
- * Copyright (C) 2013 Antti Palosaari <crope@iki.fi>
- *
- *    This program is free software; you can redistribute it and/or modify
- *    it under the terms of the GNU General Public License as published by
- *    the Free Software Foundation; either version 2 of the License, or
- *    (at your option) any later version.
- *
- *    This program is distributed in the hope that it will be useful,
- *    but WITHOUT ANY WARRANTY; without even the implied warranty of
- *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *    GNU General Public License for more details.
- */
-
-#include "mn88472_priv.h"
-
-static int mn88472_get_tune_settings(struct dvb_frontend *fe,
-	struct dvb_frontend_tune_settings *s)
-{
-	s->min_delay_ms = 400;
-	return 0;
-}
-
-static int mn88472_set_frontend(struct dvb_frontend *fe)
-{
-	struct i2c_client *client = fe->demodulator_priv;
-	struct mn88472_dev *dev = i2c_get_clientdata(client);
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	int ret, i;
-	u32 if_frequency = 0;
-	u8 delivery_system_val, if_val[3], bw_val[7], bw_val2;
-
-	dev_dbg(&client->dev,
-			"delivery_system=%d modulation=%d frequency=%d symbol_rate=%d inversion=%d\n",
-			c->delivery_system, c->modulation,
-			c->frequency, c->symbol_rate, c->inversion);
-
-	if (!dev->warm) {
-		ret = -EAGAIN;
-		goto err;
-	}
-
-	switch (c->delivery_system) {
-	case SYS_DVBT:
-		delivery_system_val = 0x02;
-		break;
-	case SYS_DVBT2:
-		delivery_system_val = 0x03;
-		break;
-	case SYS_DVBC_ANNEX_A:
-		delivery_system_val = 0x04;
-		break;
-	default:
-		ret = -EINVAL;
-		goto err;
-	}
-
-	switch (c->delivery_system) {
-	case SYS_DVBT:
-	case SYS_DVBT2:
-		if (c->bandwidth_hz <= 6000000) {
-			/* IF 3570000 Hz, BW 6000000 Hz */
-			memcpy(if_val, "\x2c\x94\xdb", 3);
-			memcpy(bw_val, "\xbf\x55\x55\x15\x6b\x15\x6b", 7);
-			bw_val2 = 0x02;
-		} else if (c->bandwidth_hz <= 7000000) {
-			/* IF 4570000 Hz, BW 7000000 Hz */
-			memcpy(if_val, "\x39\x11\xbc", 3);
-			memcpy(bw_val, "\xa4\x00\x00\x0f\x2c\x0f\x2c", 7);
-			bw_val2 = 0x01;
-		} else if (c->bandwidth_hz <= 8000000) {
-			/* IF 4570000 Hz, BW 8000000 Hz */
-			memcpy(if_val, "\x39\x11\xbc", 3);
-			memcpy(bw_val, "\x8f\x80\x00\x08\xee\x08\xee", 7);
-			bw_val2 = 0x00;
-		} else {
-			ret = -EINVAL;
-			goto err;
-		}
-		break;
-	case SYS_DVBC_ANNEX_A:
-		/* IF 5070000 Hz, BW 8000000 Hz */
-		memcpy(if_val, "\x3f\x50\x2c", 3);
-		memcpy(bw_val, "\x8f\x80\x00\x08\xee\x08\xee", 7);
-		bw_val2 = 0x00;
-		break;
-	default:
-		ret = -EINVAL;
-		goto err;
-	}
-
-	/* program tuner */
-	if (fe->ops.tuner_ops.set_params) {
-		ret = fe->ops.tuner_ops.set_params(fe);
-		if (ret)
-			goto err;
-	}
-
-	if (fe->ops.tuner_ops.get_if_frequency) {
-		ret = fe->ops.tuner_ops.get_if_frequency(fe, &if_frequency);
-		if (ret)
-			goto err;
-
-		dev_dbg(&client->dev, "get_if_frequency=%d\n", if_frequency);
-	}
-
-	switch (if_frequency) {
-	case 3570000:
-	case 4570000:
-	case 5070000:
-		break;
-	default:
-		dev_err(&client->dev, "IF frequency %d not supported\n",
-				if_frequency);
-		ret = -EINVAL;
-		goto err;
-	}
-
-	ret = regmap_write(dev->regmap[2], 0xfb, 0x13);
-	ret = regmap_write(dev->regmap[2], 0xef, 0x13);
-	ret = regmap_write(dev->regmap[2], 0xf9, 0x13);
-	if (ret)
-		goto err;
-
-	ret = regmap_write(dev->regmap[2], 0x00, 0x66);
-	if (ret)
-		goto err;
-	ret = regmap_write(dev->regmap[2], 0x01, 0x00);
-	if (ret)
-		goto err;
-	ret = regmap_write(dev->regmap[2], 0x02, 0x01);
-	if (ret)
-		goto err;
-	ret = regmap_write(dev->regmap[2], 0x03, delivery_system_val);
-	if (ret)
-		goto err;
-	ret = regmap_write(dev->regmap[2], 0x04, bw_val2);
-	if (ret)
-		goto err;
-
-	for (i = 0; i < sizeof(if_val); i++) {
-		ret = regmap_write(dev->regmap[2], 0x10 + i, if_val[i]);
-		if (ret)
-			goto err;
-	}
-
-	for (i = 0; i < sizeof(bw_val); i++) {
-		ret = regmap_write(dev->regmap[2], 0x13 + i, bw_val[i]);
-		if (ret)
-			goto err;
-	}
-
-	switch (c->delivery_system) {
-	case SYS_DVBT:
-		ret = regmap_write(dev->regmap[0], 0x07, 0x26);
-		ret = regmap_write(dev->regmap[0], 0xb0, 0x0a);
-		ret = regmap_write(dev->regmap[0], 0xb4, 0x00);
-		ret = regmap_write(dev->regmap[0], 0xcd, 0x1f);
-		ret = regmap_write(dev->regmap[0], 0xd4, 0x0a);
-		ret = regmap_write(dev->regmap[0], 0xd6, 0x48);
-		ret = regmap_write(dev->regmap[0], 0x00, 0xba);
-		ret = regmap_write(dev->regmap[0], 0x01, 0x13);
-		if (ret)
-			goto err;
-		break;
-	case SYS_DVBT2:
-		ret = regmap_write(dev->regmap[2], 0x2b, 0x13);
-		ret = regmap_write(dev->regmap[2], 0x4f, 0x05);
-		ret = regmap_write(dev->regmap[1], 0xf6, 0x05);
-		ret = regmap_write(dev->regmap[0], 0xb0, 0x0a);
-		ret = regmap_write(dev->regmap[0], 0xb4, 0xf6);
-		ret = regmap_write(dev->regmap[0], 0xcd, 0x01);
-		ret = regmap_write(dev->regmap[0], 0xd4, 0x09);
-		ret = regmap_write(dev->regmap[0], 0xd6, 0x46);
-		ret = regmap_write(dev->regmap[2], 0x30, 0x80);
-		ret = regmap_write(dev->regmap[2], 0x32, 0x00);
-		if (ret)
-			goto err;
-		break;
-	case SYS_DVBC_ANNEX_A:
-		ret = regmap_write(dev->regmap[0], 0xb0, 0x0b);
-		ret = regmap_write(dev->regmap[0], 0xb4, 0x00);
-		ret = regmap_write(dev->regmap[0], 0xcd, 0x17);
-		ret = regmap_write(dev->regmap[0], 0xd4, 0x09);
-		ret = regmap_write(dev->regmap[0], 0xd6, 0x48);
-		ret = regmap_write(dev->regmap[1], 0x00, 0xb0);
-		if (ret)
-			goto err;
-		break;
-	default:
-		ret = -EINVAL;
-		goto err;
-	}
-
-	ret = regmap_write(dev->regmap[0], 0x46, 0x00);
-	ret = regmap_write(dev->regmap[0], 0xae, 0x00);
-	ret = regmap_write(dev->regmap[2], 0x08, 0x1d);
-	ret = regmap_write(dev->regmap[0], 0xd9, 0xe3);
-	ret = regmap_write(dev->regmap[2], 0xf8, 0x9f);
-	if (ret)
-		goto err;
-
-	dev->delivery_system = c->delivery_system;
-
-	return 0;
-err:
-	dev_dbg(&client->dev, "failed=%d\n", ret);
-	return ret;
-}
-
-static int mn88472_read_status(struct dvb_frontend *fe, fe_status_t *status)
-{
-	struct i2c_client *client = fe->demodulator_priv;
-	struct mn88472_dev *dev = i2c_get_clientdata(client);
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	int ret;
-	unsigned int utmp;
-
-	*status = 0;
-
-	if (!dev->warm) {
-		ret = -EAGAIN;
-		goto err;
-	}
-
-	switch (c->delivery_system) {
-	case SYS_DVBT:
-	case SYS_DVBT2:
-		/* FIXME: implement me */
-		utmp = 0x08; /* DVB-C lock value */
-		break;
-	case SYS_DVBC_ANNEX_A:
-		ret = regmap_read(dev->regmap[1], 0x84, &utmp);
-		if (ret)
-			goto err;
-		break;
-	default:
-		ret = -EINVAL;
-		goto err;
-	}
-
-	if (utmp == 0x08)
-		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_VITERBI |
-				FE_HAS_SYNC | FE_HAS_LOCK;
-
-	return 0;
-err:
-	dev_dbg(&client->dev, "failed=%d\n", ret);
-	return ret;
-}
-
-static int mn88472_init(struct dvb_frontend *fe)
-{
-	struct i2c_client *client = fe->demodulator_priv;
-	struct mn88472_dev *dev = i2c_get_clientdata(client);
-	int ret, len, remaining;
-	const struct firmware *fw = NULL;
-	u8 *fw_file = MN88472_FIRMWARE;
-
-	dev_dbg(&client->dev, "\n");
-
-	/* set cold state by default */
-	dev->warm = false;
-
-	/* power on */
-	ret = regmap_write(dev->regmap[2], 0x05, 0x00);
-	if (ret)
-		goto err;
-
-	ret = regmap_bulk_write(dev->regmap[2], 0x0b, "\x00\x00", 2);
-	if (ret)
-		goto err;
-
-	/* request the firmware, this will block and timeout */
-	ret = request_firmware(&fw, fw_file, &client->dev);
-	if (ret) {
-		dev_err(&client->dev, "firmare file '%s' not found\n",
-				fw_file);
-		goto err;
-	}
-
-	dev_info(&client->dev, "downloading firmware from file '%s'\n",
-			fw_file);
-
-	ret = regmap_write(dev->regmap[0], 0xf5, 0x03);
-	if (ret)
-		goto err;
-
-	for (remaining = fw->size; remaining > 0;
-			remaining -= (dev->i2c_wr_max - 1)) {
-		len = remaining;
-		if (len > (dev->i2c_wr_max - 1))
-			len = (dev->i2c_wr_max - 1);
-
-		ret = regmap_bulk_write(dev->regmap[0], 0xf6,
-				&fw->data[fw->size - remaining], len);
-		if (ret) {
-			dev_err(&client->dev,
-					"firmware download failed=%d\n", ret);
-			goto err;
-		}
-	}
-
-	ret = regmap_write(dev->regmap[0], 0xf5, 0x00);
-	if (ret)
-		goto err;
-
-	release_firmware(fw);
-	fw = NULL;
-
-	/* warm state */
-	dev->warm = true;
-
-	return 0;
-err:
-	if (fw)
-		release_firmware(fw);
-
-	dev_dbg(&client->dev, "failed=%d\n", ret);
-	return ret;
-}
-
-static int mn88472_sleep(struct dvb_frontend *fe)
-{
-	struct i2c_client *client = fe->demodulator_priv;
-	struct mn88472_dev *dev = i2c_get_clientdata(client);
-	int ret;
-
-	dev_dbg(&client->dev, "\n");
-
-	/* power off */
-	ret = regmap_write(dev->regmap[2], 0x0b, 0x30);
-
-	if (ret)
-		goto err;
-
-	ret = regmap_write(dev->regmap[2], 0x05, 0x3e);
-	if (ret)
-		goto err;
-
-	dev->delivery_system = SYS_UNDEFINED;
-
-	return 0;
-err:
-	dev_dbg(&client->dev, "failed=%d\n", ret);
-	return ret;
-}
-
-static struct dvb_frontend_ops mn88472_ops = {
-	.delsys = {SYS_DVBT, SYS_DVBT2, SYS_DVBC_ANNEX_A},
-	.info = {
-		.name = "Panasonic MN88472",
-		.caps =	FE_CAN_FEC_1_2                 |
-			FE_CAN_FEC_2_3                 |
-			FE_CAN_FEC_3_4                 |
-			FE_CAN_FEC_5_6                 |
-			FE_CAN_FEC_7_8                 |
-			FE_CAN_FEC_AUTO                |
-			FE_CAN_QPSK                    |
-			FE_CAN_QAM_16                  |
-			FE_CAN_QAM_32                  |
-			FE_CAN_QAM_64                  |
-			FE_CAN_QAM_128                 |
-			FE_CAN_QAM_256                 |
-			FE_CAN_QAM_AUTO                |
-			FE_CAN_TRANSMISSION_MODE_AUTO  |
-			FE_CAN_GUARD_INTERVAL_AUTO     |
-			FE_CAN_HIERARCHY_AUTO          |
-			FE_CAN_MUTE_TS                 |
-			FE_CAN_2G_MODULATION           |
-			FE_CAN_MULTISTREAM
-	},
-
-	.get_tune_settings = mn88472_get_tune_settings,
-
-	.init = mn88472_init,
-	.sleep = mn88472_sleep,
-
-	.set_frontend = mn88472_set_frontend,
-
-	.read_status = mn88472_read_status,
-};
-
-static int mn88472_probe(struct i2c_client *client,
-		const struct i2c_device_id *id)
-{
-	struct mn88472_config *config = client->dev.platform_data;
-	struct mn88472_dev *dev;
-	int ret;
-	unsigned int utmp;
-	static const struct regmap_config regmap_config = {
-		.reg_bits = 8,
-		.val_bits = 8,
-	};
-
-	dev_dbg(&client->dev, "\n");
-
-	/* Caller really need to provide pointer for frontend we create. */
-	if (config->fe == NULL) {
-		dev_err(&client->dev, "frontend pointer not defined\n");
-		ret = -EINVAL;
-		goto err;
-	}
-
-	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
-	if (dev == NULL) {
-		ret = -ENOMEM;
-		goto err;
-	}
-
-	dev->i2c_wr_max = config->i2c_wr_max;
-	dev->client[0] = client;
-	dev->regmap[0] = regmap_init_i2c(dev->client[0], &regmap_config);
-	if (IS_ERR(dev->regmap[0])) {
-		ret = PTR_ERR(dev->regmap[0]);
-		goto err_kfree;
-	}
-
-	/* check demod answers to I2C */
-	ret = regmap_read(dev->regmap[0], 0x00, &utmp);
-	if (ret)
-		goto err_regmap_0_regmap_exit;
-
-	/*
-	 * Chip has three I2C addresses for different register pages. Used
-	 * addresses are 0x18, 0x1a and 0x1c. We register two dummy clients,
-	 * 0x1a and 0x1c, in order to get own I2C client for each register page.
-	 */
-	dev->client[1] = i2c_new_dummy(client->adapter, 0x1a);
-	if (dev->client[1] == NULL) {
-		ret = -ENODEV;
-		dev_err(&client->dev, "I2C registration failed\n");
-		if (ret)
-			goto err_regmap_0_regmap_exit;
-	}
-	dev->regmap[1] = regmap_init_i2c(dev->client[1], &regmap_config);
-	if (IS_ERR(dev->regmap[1])) {
-		ret = PTR_ERR(dev->regmap[1]);
-		goto err_client_1_i2c_unregister_device;
-	}
-	i2c_set_clientdata(dev->client[1], dev);
-
-	dev->client[2] = i2c_new_dummy(client->adapter, 0x1c);
-	if (dev->client[2] == NULL) {
-		ret = -ENODEV;
-		dev_err(&client->dev, "2nd I2C registration failed\n");
-		if (ret)
-			goto err_regmap_1_regmap_exit;
-	}
-	dev->regmap[2] = regmap_init_i2c(dev->client[2], &regmap_config);
-	if (IS_ERR(dev->regmap[2])) {
-		ret = PTR_ERR(dev->regmap[2]);
-		goto err_client_2_i2c_unregister_device;
-	}
-	i2c_set_clientdata(dev->client[2], dev);
-
-	/* create dvb_frontend */
-	memcpy(&dev->fe.ops, &mn88472_ops, sizeof(struct dvb_frontend_ops));
-	dev->fe.demodulator_priv = client;
-	*config->fe = &dev->fe;
-	i2c_set_clientdata(client, dev);
-
-	dev_info(&client->dev, "Panasonic MN88472 successfully attached\n");
-	return 0;
-
-err_client_2_i2c_unregister_device:
-	i2c_unregister_device(dev->client[2]);
-err_regmap_1_regmap_exit:
-	regmap_exit(dev->regmap[1]);
-err_client_1_i2c_unregister_device:
-	i2c_unregister_device(dev->client[1]);
-err_regmap_0_regmap_exit:
-	regmap_exit(dev->regmap[0]);
-err_kfree:
-	kfree(dev);
-err:
-	dev_dbg(&client->dev, "failed=%d\n", ret);
-	return ret;
-}
-
-static int mn88472_remove(struct i2c_client *client)
-{
-	struct mn88472_dev *dev = i2c_get_clientdata(client);
-
-	dev_dbg(&client->dev, "\n");
-
-	regmap_exit(dev->regmap[2]);
-	i2c_unregister_device(dev->client[2]);
-
-	regmap_exit(dev->regmap[1]);
-	i2c_unregister_device(dev->client[1]);
-
-	regmap_exit(dev->regmap[0]);
-
-	kfree(dev);
-
-	return 0;
-}
-
-static const struct i2c_device_id mn88472_id_table[] = {
-	{"mn88472", 0},
-	{}
-};
-MODULE_DEVICE_TABLE(i2c, mn88472_id_table);
-
-static struct i2c_driver mn88472_driver = {
-	.driver = {
-		.owner	= THIS_MODULE,
-		.name	= "mn88472",
-	},
-	.probe		= mn88472_probe,
-	.remove		= mn88472_remove,
-	.id_table	= mn88472_id_table,
-};
-
-module_i2c_driver(mn88472_driver);
-
-MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
-MODULE_DESCRIPTION("Panasonic MN88472 DVB-T/T2/C demodulator driver");
-MODULE_LICENSE("GPL");
-MODULE_FIRMWARE(MN88472_FIRMWARE);
diff --git a/drivers/media/dvb-frontends/mn88472_priv.h b/drivers/media/dvb-frontends/mn88472_priv.h
deleted file mode 100644
index 1095949..0000000
--- a/drivers/media/dvb-frontends/mn88472_priv.h
+++ /dev/null
@@ -1,36 +0,0 @@
-/*
- * Panasonic MN88472 DVB-T/T2/C demodulator driver
- *
- * Copyright (C) 2013 Antti Palosaari <crope@iki.fi>
- *
- *    This program is free software; you can redistribute it and/or modify
- *    it under the terms of the GNU General Public License as published by
- *    the Free Software Foundation; either version 2 of the License, or
- *    (at your option) any later version.
- *
- *    This program is distributed in the hope that it will be useful,
- *    but WITHOUT ANY WARRANTY; without even the implied warranty of
- *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *    GNU General Public License for more details.
- */
-
-#ifndef MN88472_PRIV_H
-#define MN88472_PRIV_H
-
-#include "dvb_frontend.h"
-#include "mn88472.h"
-#include <linux/firmware.h>
-#include <linux/regmap.h>
-
-#define MN88472_FIRMWARE "dvb-demod-mn88472-02.fw"
-
-struct mn88472_dev {
-	struct i2c_client *client[3];
-	struct regmap *regmap[3];
-	struct dvb_frontend fe;
-	u16 i2c_wr_max;
-	fe_delivery_system_t delivery_system;
-	bool warm; /* FW running */
-};
-
-#endif
diff --git a/drivers/staging/media/Kconfig b/drivers/staging/media/Kconfig
index 655cf50..c2e675a 100644
--- a/drivers/staging/media/Kconfig
+++ b/drivers/staging/media/Kconfig
@@ -27,6 +27,8 @@ source "drivers/staging/media/davinci_vpfe/Kconfig"
 
 source "drivers/staging/media/dt3155v4l/Kconfig"
 
+source "drivers/staging/media/mn88472/Kconfig"
+
 source "drivers/staging/media/omap24xx/Kconfig"
 
 source "drivers/staging/media/omap4iss/Kconfig"
diff --git a/drivers/staging/media/Makefile b/drivers/staging/media/Makefile
index 6dbe578..e174c57 100644
--- a/drivers/staging/media/Makefile
+++ b/drivers/staging/media/Makefile
@@ -6,4 +6,5 @@ obj-$(CONFIG_VIDEO_DM365_VPFE)	+= davinci_vpfe/
 obj-$(CONFIG_VIDEO_OMAP4)	+= omap4iss/
 obj-$(CONFIG_VIDEO_OMAP2)       += omap24xx/
 obj-$(CONFIG_VIDEO_TCM825X)     += omap24xx/
+obj-$(CONFIG_DVB_MN88472)       += mn88472/
 
diff --git a/drivers/staging/media/mn88472/Kconfig b/drivers/staging/media/mn88472/Kconfig
new file mode 100644
index 0000000..a85c90a
--- /dev/null
+++ b/drivers/staging/media/mn88472/Kconfig
@@ -0,0 +1,7 @@
+config DVB_MN88472
+	tristate "Panasonic MN88472"
+	depends on DVB_CORE && I2C
+	select REGMAP_I2C
+	default m if !MEDIA_SUBDRV_AUTOSELECT
+	help
+	  Say Y when you want to support this frontend.
diff --git a/drivers/staging/media/mn88472/Makefile b/drivers/staging/media/mn88472/Makefile
new file mode 100644
index 0000000..5987b7e
--- /dev/null
+++ b/drivers/staging/media/mn88472/Makefile
@@ -0,0 +1,5 @@
+obj-$(CONFIG_DVB_MN88472) += mn88472.o
+
+ccflags-y += -Idrivers/media/dvb-core/
+ccflags-y += -Idrivers/media/dvb-frontends/
+ccflags-y += -Idrivers/media/tuners/
diff --git a/drivers/staging/media/mn88472/mn88472.c b/drivers/staging/media/mn88472/mn88472.c
new file mode 100644
index 0000000..52de8f8
--- /dev/null
+++ b/drivers/staging/media/mn88472/mn88472.c
@@ -0,0 +1,523 @@
+/*
+ * Panasonic MN88472 DVB-T/T2/C demodulator driver
+ *
+ * Copyright (C) 2013 Antti Palosaari <crope@iki.fi>
+ *
+ *    This program is free software; you can redistribute it and/or modify
+ *    it under the terms of the GNU General Public License as published by
+ *    the Free Software Foundation; either version 2 of the License, or
+ *    (at your option) any later version.
+ *
+ *    This program is distributed in the hope that it will be useful,
+ *    but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *    GNU General Public License for more details.
+ */
+
+#include "mn88472_priv.h"
+
+static int mn88472_get_tune_settings(struct dvb_frontend *fe,
+	struct dvb_frontend_tune_settings *s)
+{
+	s->min_delay_ms = 400;
+	return 0;
+}
+
+static int mn88472_set_frontend(struct dvb_frontend *fe)
+{
+	struct i2c_client *client = fe->demodulator_priv;
+	struct mn88472_dev *dev = i2c_get_clientdata(client);
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	int ret, i;
+	u32 if_frequency = 0;
+	u8 delivery_system_val, if_val[3], bw_val[7], bw_val2;
+
+	dev_dbg(&client->dev,
+			"delivery_system=%d modulation=%d frequency=%d symbol_rate=%d inversion=%d\n",
+			c->delivery_system, c->modulation,
+			c->frequency, c->symbol_rate, c->inversion);
+
+	if (!dev->warm) {
+		ret = -EAGAIN;
+		goto err;
+	}
+
+	switch (c->delivery_system) {
+	case SYS_DVBT:
+		delivery_system_val = 0x02;
+		break;
+	case SYS_DVBT2:
+		delivery_system_val = 0x03;
+		break;
+	case SYS_DVBC_ANNEX_A:
+		delivery_system_val = 0x04;
+		break;
+	default:
+		ret = -EINVAL;
+		goto err;
+	}
+
+	switch (c->delivery_system) {
+	case SYS_DVBT:
+	case SYS_DVBT2:
+		if (c->bandwidth_hz <= 6000000) {
+			/* IF 3570000 Hz, BW 6000000 Hz */
+			memcpy(if_val, "\x2c\x94\xdb", 3);
+			memcpy(bw_val, "\xbf\x55\x55\x15\x6b\x15\x6b", 7);
+			bw_val2 = 0x02;
+		} else if (c->bandwidth_hz <= 7000000) {
+			/* IF 4570000 Hz, BW 7000000 Hz */
+			memcpy(if_val, "\x39\x11\xbc", 3);
+			memcpy(bw_val, "\xa4\x00\x00\x0f\x2c\x0f\x2c", 7);
+			bw_val2 = 0x01;
+		} else if (c->bandwidth_hz <= 8000000) {
+			/* IF 4570000 Hz, BW 8000000 Hz */
+			memcpy(if_val, "\x39\x11\xbc", 3);
+			memcpy(bw_val, "\x8f\x80\x00\x08\xee\x08\xee", 7);
+			bw_val2 = 0x00;
+		} else {
+			ret = -EINVAL;
+			goto err;
+		}
+		break;
+	case SYS_DVBC_ANNEX_A:
+		/* IF 5070000 Hz, BW 8000000 Hz */
+		memcpy(if_val, "\x3f\x50\x2c", 3);
+		memcpy(bw_val, "\x8f\x80\x00\x08\xee\x08\xee", 7);
+		bw_val2 = 0x00;
+		break;
+	default:
+		ret = -EINVAL;
+		goto err;
+	}
+
+	/* program tuner */
+	if (fe->ops.tuner_ops.set_params) {
+		ret = fe->ops.tuner_ops.set_params(fe);
+		if (ret)
+			goto err;
+	}
+
+	if (fe->ops.tuner_ops.get_if_frequency) {
+		ret = fe->ops.tuner_ops.get_if_frequency(fe, &if_frequency);
+		if (ret)
+			goto err;
+
+		dev_dbg(&client->dev, "get_if_frequency=%d\n", if_frequency);
+	}
+
+	switch (if_frequency) {
+	case 3570000:
+	case 4570000:
+	case 5070000:
+		break;
+	default:
+		dev_err(&client->dev, "IF frequency %d not supported\n",
+				if_frequency);
+		ret = -EINVAL;
+		goto err;
+	}
+
+	ret = regmap_write(dev->regmap[2], 0xfb, 0x13);
+	ret = regmap_write(dev->regmap[2], 0xef, 0x13);
+	ret = regmap_write(dev->regmap[2], 0xf9, 0x13);
+	if (ret)
+		goto err;
+
+	ret = regmap_write(dev->regmap[2], 0x00, 0x66);
+	if (ret)
+		goto err;
+	ret = regmap_write(dev->regmap[2], 0x01, 0x00);
+	if (ret)
+		goto err;
+	ret = regmap_write(dev->regmap[2], 0x02, 0x01);
+	if (ret)
+		goto err;
+	ret = regmap_write(dev->regmap[2], 0x03, delivery_system_val);
+	if (ret)
+		goto err;
+	ret = regmap_write(dev->regmap[2], 0x04, bw_val2);
+	if (ret)
+		goto err;
+
+	for (i = 0; i < sizeof(if_val); i++) {
+		ret = regmap_write(dev->regmap[2], 0x10 + i, if_val[i]);
+		if (ret)
+			goto err;
+	}
+
+	for (i = 0; i < sizeof(bw_val); i++) {
+		ret = regmap_write(dev->regmap[2], 0x13 + i, bw_val[i]);
+		if (ret)
+			goto err;
+	}
+
+	switch (c->delivery_system) {
+	case SYS_DVBT:
+		ret = regmap_write(dev->regmap[0], 0x07, 0x26);
+		ret = regmap_write(dev->regmap[0], 0xb0, 0x0a);
+		ret = regmap_write(dev->regmap[0], 0xb4, 0x00);
+		ret = regmap_write(dev->regmap[0], 0xcd, 0x1f);
+		ret = regmap_write(dev->regmap[0], 0xd4, 0x0a);
+		ret = regmap_write(dev->regmap[0], 0xd6, 0x48);
+		ret = regmap_write(dev->regmap[0], 0x00, 0xba);
+		ret = regmap_write(dev->regmap[0], 0x01, 0x13);
+		if (ret)
+			goto err;
+		break;
+	case SYS_DVBT2:
+		ret = regmap_write(dev->regmap[2], 0x2b, 0x13);
+		ret = regmap_write(dev->regmap[2], 0x4f, 0x05);
+		ret = regmap_write(dev->regmap[1], 0xf6, 0x05);
+		ret = regmap_write(dev->regmap[0], 0xb0, 0x0a);
+		ret = regmap_write(dev->regmap[0], 0xb4, 0xf6);
+		ret = regmap_write(dev->regmap[0], 0xcd, 0x01);
+		ret = regmap_write(dev->regmap[0], 0xd4, 0x09);
+		ret = regmap_write(dev->regmap[0], 0xd6, 0x46);
+		ret = regmap_write(dev->regmap[2], 0x30, 0x80);
+		ret = regmap_write(dev->regmap[2], 0x32, 0x00);
+		if (ret)
+			goto err;
+		break;
+	case SYS_DVBC_ANNEX_A:
+		ret = regmap_write(dev->regmap[0], 0xb0, 0x0b);
+		ret = regmap_write(dev->regmap[0], 0xb4, 0x00);
+		ret = regmap_write(dev->regmap[0], 0xcd, 0x17);
+		ret = regmap_write(dev->regmap[0], 0xd4, 0x09);
+		ret = regmap_write(dev->regmap[0], 0xd6, 0x48);
+		ret = regmap_write(dev->regmap[1], 0x00, 0xb0);
+		if (ret)
+			goto err;
+		break;
+	default:
+		ret = -EINVAL;
+		goto err;
+	}
+
+	ret = regmap_write(dev->regmap[0], 0x46, 0x00);
+	ret = regmap_write(dev->regmap[0], 0xae, 0x00);
+	ret = regmap_write(dev->regmap[2], 0x08, 0x1d);
+	ret = regmap_write(dev->regmap[0], 0xd9, 0xe3);
+	ret = regmap_write(dev->regmap[2], 0xf8, 0x9f);
+	if (ret)
+		goto err;
+
+	dev->delivery_system = c->delivery_system;
+
+	return 0;
+err:
+	dev_dbg(&client->dev, "failed=%d\n", ret);
+	return ret;
+}
+
+static int mn88472_read_status(struct dvb_frontend *fe, fe_status_t *status)
+{
+	struct i2c_client *client = fe->demodulator_priv;
+	struct mn88472_dev *dev = i2c_get_clientdata(client);
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	int ret;
+	unsigned int utmp;
+
+	*status = 0;
+
+	if (!dev->warm) {
+		ret = -EAGAIN;
+		goto err;
+	}
+
+	switch (c->delivery_system) {
+	case SYS_DVBT:
+	case SYS_DVBT2:
+		/* FIXME: implement me */
+		utmp = 0x08; /* DVB-C lock value */
+		break;
+	case SYS_DVBC_ANNEX_A:
+		ret = regmap_read(dev->regmap[1], 0x84, &utmp);
+		if (ret)
+			goto err;
+		break;
+	default:
+		ret = -EINVAL;
+		goto err;
+	}
+
+	if (utmp == 0x08)
+		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_VITERBI |
+				FE_HAS_SYNC | FE_HAS_LOCK;
+
+	return 0;
+err:
+	dev_dbg(&client->dev, "failed=%d\n", ret);
+	return ret;
+}
+
+static int mn88472_init(struct dvb_frontend *fe)
+{
+	struct i2c_client *client = fe->demodulator_priv;
+	struct mn88472_dev *dev = i2c_get_clientdata(client);
+	int ret, len, remaining;
+	const struct firmware *fw = NULL;
+	u8 *fw_file = MN88472_FIRMWARE;
+
+	dev_dbg(&client->dev, "\n");
+
+	/* set cold state by default */
+	dev->warm = false;
+
+	/* power on */
+	ret = regmap_write(dev->regmap[2], 0x05, 0x00);
+	if (ret)
+		goto err;
+
+	ret = regmap_bulk_write(dev->regmap[2], 0x0b, "\x00\x00", 2);
+	if (ret)
+		goto err;
+
+	/* request the firmware, this will block and timeout */
+	ret = request_firmware(&fw, fw_file, &client->dev);
+	if (ret) {
+		dev_err(&client->dev, "firmare file '%s' not found\n",
+				fw_file);
+		goto err;
+	}
+
+	dev_info(&client->dev, "downloading firmware from file '%s'\n",
+			fw_file);
+
+	ret = regmap_write(dev->regmap[0], 0xf5, 0x03);
+	if (ret)
+		goto err;
+
+	for (remaining = fw->size; remaining > 0;
+			remaining -= (dev->i2c_wr_max - 1)) {
+		len = remaining;
+		if (len > (dev->i2c_wr_max - 1))
+			len = (dev->i2c_wr_max - 1);
+
+		ret = regmap_bulk_write(dev->regmap[0], 0xf6,
+				&fw->data[fw->size - remaining], len);
+		if (ret) {
+			dev_err(&client->dev,
+					"firmware download failed=%d\n", ret);
+			goto err;
+		}
+	}
+
+	ret = regmap_write(dev->regmap[0], 0xf5, 0x00);
+	if (ret)
+		goto err;
+
+	release_firmware(fw);
+	fw = NULL;
+
+	/* warm state */
+	dev->warm = true;
+
+	return 0;
+err:
+	if (fw)
+		release_firmware(fw);
+
+	dev_dbg(&client->dev, "failed=%d\n", ret);
+	return ret;
+}
+
+static int mn88472_sleep(struct dvb_frontend *fe)
+{
+	struct i2c_client *client = fe->demodulator_priv;
+	struct mn88472_dev *dev = i2c_get_clientdata(client);
+	int ret;
+
+	dev_dbg(&client->dev, "\n");
+
+	/* power off */
+	ret = regmap_write(dev->regmap[2], 0x0b, 0x30);
+
+	if (ret)
+		goto err;
+
+	ret = regmap_write(dev->regmap[2], 0x05, 0x3e);
+	if (ret)
+		goto err;
+
+	dev->delivery_system = SYS_UNDEFINED;
+
+	return 0;
+err:
+	dev_dbg(&client->dev, "failed=%d\n", ret);
+	return ret;
+}
+
+static struct dvb_frontend_ops mn88472_ops = {
+	.delsys = {SYS_DVBT, SYS_DVBT2, SYS_DVBC_ANNEX_A},
+	.info = {
+		.name = "Panasonic MN88472",
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
+	.get_tune_settings = mn88472_get_tune_settings,
+
+	.init = mn88472_init,
+	.sleep = mn88472_sleep,
+
+	.set_frontend = mn88472_set_frontend,
+
+	.read_status = mn88472_read_status,
+};
+
+static int mn88472_probe(struct i2c_client *client,
+		const struct i2c_device_id *id)
+{
+	struct mn88472_config *config = client->dev.platform_data;
+	struct mn88472_dev *dev;
+	int ret;
+	unsigned int utmp;
+	static const struct regmap_config regmap_config = {
+		.reg_bits = 8,
+		.val_bits = 8,
+	};
+
+	dev_dbg(&client->dev, "\n");
+
+	/* Caller really need to provide pointer for frontend we create. */
+	if (config->fe == NULL) {
+		dev_err(&client->dev, "frontend pointer not defined\n");
+		ret = -EINVAL;
+		goto err;
+	}
+
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (dev == NULL) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	dev->i2c_wr_max = config->i2c_wr_max;
+	dev->client[0] = client;
+	dev->regmap[0] = regmap_init_i2c(dev->client[0], &regmap_config);
+	if (IS_ERR(dev->regmap[0])) {
+		ret = PTR_ERR(dev->regmap[0]);
+		goto err_kfree;
+	}
+
+	/* check demod answers to I2C */
+	ret = regmap_read(dev->regmap[0], 0x00, &utmp);
+	if (ret)
+		goto err_regmap_0_regmap_exit;
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
+			goto err_regmap_0_regmap_exit;
+	}
+	dev->regmap[1] = regmap_init_i2c(dev->client[1], &regmap_config);
+	if (IS_ERR(dev->regmap[1])) {
+		ret = PTR_ERR(dev->regmap[1]);
+		goto err_client_1_i2c_unregister_device;
+	}
+	i2c_set_clientdata(dev->client[1], dev);
+
+	dev->client[2] = i2c_new_dummy(client->adapter, 0x1c);
+	if (dev->client[2] == NULL) {
+		ret = -ENODEV;
+		dev_err(&client->dev, "2nd I2C registration failed\n");
+		if (ret)
+			goto err_regmap_1_regmap_exit;
+	}
+	dev->regmap[2] = regmap_init_i2c(dev->client[2], &regmap_config);
+	if (IS_ERR(dev->regmap[2])) {
+		ret = PTR_ERR(dev->regmap[2]);
+		goto err_client_2_i2c_unregister_device;
+	}
+	i2c_set_clientdata(dev->client[2], dev);
+
+	/* create dvb_frontend */
+	memcpy(&dev->fe.ops, &mn88472_ops, sizeof(struct dvb_frontend_ops));
+	dev->fe.demodulator_priv = client;
+	*config->fe = &dev->fe;
+	i2c_set_clientdata(client, dev);
+
+	dev_info(&client->dev, "Panasonic MN88472 successfully attached\n");
+	return 0;
+
+err_client_2_i2c_unregister_device:
+	i2c_unregister_device(dev->client[2]);
+err_regmap_1_regmap_exit:
+	regmap_exit(dev->regmap[1]);
+err_client_1_i2c_unregister_device:
+	i2c_unregister_device(dev->client[1]);
+err_regmap_0_regmap_exit:
+	regmap_exit(dev->regmap[0]);
+err_kfree:
+	kfree(dev);
+err:
+	dev_dbg(&client->dev, "failed=%d\n", ret);
+	return ret;
+}
+
+static int mn88472_remove(struct i2c_client *client)
+{
+	struct mn88472_dev *dev = i2c_get_clientdata(client);
+
+	dev_dbg(&client->dev, "\n");
+
+	regmap_exit(dev->regmap[2]);
+	i2c_unregister_device(dev->client[2]);
+
+	regmap_exit(dev->regmap[1]);
+	i2c_unregister_device(dev->client[1]);
+
+	regmap_exit(dev->regmap[0]);
+
+	kfree(dev);
+
+	return 0;
+}
+
+static const struct i2c_device_id mn88472_id_table[] = {
+	{"mn88472", 0},
+	{}
+};
+MODULE_DEVICE_TABLE(i2c, mn88472_id_table);
+
+static struct i2c_driver mn88472_driver = {
+	.driver = {
+		.owner	= THIS_MODULE,
+		.name	= "mn88472",
+	},
+	.probe		= mn88472_probe,
+	.remove		= mn88472_remove,
+	.id_table	= mn88472_id_table,
+};
+
+module_i2c_driver(mn88472_driver);
+
+MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
+MODULE_DESCRIPTION("Panasonic MN88472 DVB-T/T2/C demodulator driver");
+MODULE_LICENSE("GPL");
+MODULE_FIRMWARE(MN88472_FIRMWARE);
diff --git a/drivers/staging/media/mn88472/mn88472_priv.h b/drivers/staging/media/mn88472/mn88472_priv.h
new file mode 100644
index 0000000..1095949
--- /dev/null
+++ b/drivers/staging/media/mn88472/mn88472_priv.h
@@ -0,0 +1,36 @@
+/*
+ * Panasonic MN88472 DVB-T/T2/C demodulator driver
+ *
+ * Copyright (C) 2013 Antti Palosaari <crope@iki.fi>
+ *
+ *    This program is free software; you can redistribute it and/or modify
+ *    it under the terms of the GNU General Public License as published by
+ *    the Free Software Foundation; either version 2 of the License, or
+ *    (at your option) any later version.
+ *
+ *    This program is distributed in the hope that it will be useful,
+ *    but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *    GNU General Public License for more details.
+ */
+
+#ifndef MN88472_PRIV_H
+#define MN88472_PRIV_H
+
+#include "dvb_frontend.h"
+#include "mn88472.h"
+#include <linux/firmware.h>
+#include <linux/regmap.h>
+
+#define MN88472_FIRMWARE "dvb-demod-mn88472-02.fw"
+
+struct mn88472_dev {
+	struct i2c_client *client[3];
+	struct regmap *regmap[3];
+	struct dvb_frontend fe;
+	u16 i2c_wr_max;
+	fe_delivery_system_t delivery_system;
+	bool warm; /* FW running */
+};
+
+#endif
-- 
http://palosaari.fi/

