Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43394 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757055AbaIDChB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Sep 2014 22:37:01 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 13/37] af9035: use I2C it913x tuner driver
Date: Thu,  4 Sep 2014 05:36:21 +0300
Message-Id: <1409798205-25645-13-git-send-email-crope@iki.fi>
In-Reply-To: <1409798205-25645-1-git-send-email-crope@iki.fi>
References: <1409798205-25645-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use I2C it913x tuner driver.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 135 ++++++++++++++++++++++++++++++++--
 drivers/media/usb/dvb-usb-v2/af9035.h |   3 +-
 2 files changed, 131 insertions(+), 7 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 0ec8919..1a5b600 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -193,6 +193,93 @@ static int af9035_wr_reg_mask(struct dvb_usb_device *d, u32 reg, u8 val,
 	return af9035_wr_regs(d, reg, &val, 1);
 }
 
+static int af9035_add_i2c_dev(struct dvb_usb_device *d, char *type, u8 addr,
+		void *platform_data)
+{
+	int ret, num;
+	struct state *state = d_to_priv(d);
+	struct i2c_client *client;
+	struct i2c_adapter *adapter = &d->i2c_adap;
+	struct i2c_board_info board_info = {
+		.addr = addr,
+		.platform_data = platform_data,
+	};
+
+	strlcpy(board_info.type, type, I2C_NAME_SIZE);
+
+	/* find first free client */
+	for (num = 0; num < AF9035_I2C_CLIENT_MAX; num++) {
+		if (state->i2c_client[num] == NULL)
+			break;
+	}
+
+	dev_dbg(&d->udev->dev, "%s: num=%d\n", __func__, num);
+
+	if (num == AF9035_I2C_CLIENT_MAX) {
+		dev_err(&d->udev->dev, "%s: I2C client out of index\n",
+				KBUILD_MODNAME);
+		ret = -ENODEV;
+		goto err;
+	}
+
+	request_module(board_info.type);
+
+	/* register I2C device */
+	client = i2c_new_device(adapter, &board_info);
+	if (client == NULL || client->dev.driver == NULL) {
+		ret = -ENODEV;
+		goto err;
+	}
+
+	/* increase I2C driver usage count */
+	if (!try_module_get(client->dev.driver->owner)) {
+		i2c_unregister_device(client);
+		ret = -ENODEV;
+		goto err;
+	}
+
+	state->i2c_client[num] = client;
+	return 0;
+err:
+	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
+	return ret;
+}
+
+static void af9035_del_i2c_dev(struct dvb_usb_device *d)
+{
+	int num;
+	struct state *state = d_to_priv(d);
+	struct i2c_client *client;
+
+	/* find last used client */
+	num = AF9035_I2C_CLIENT_MAX;
+	while (num--) {
+		if (state->i2c_client[num] != NULL)
+			break;
+	}
+
+	dev_dbg(&d->udev->dev, "%s: num=%d\n", __func__, num);
+
+	if (num == -1) {
+		dev_err(&d->udev->dev, "%s: I2C client out of index\n",
+				KBUILD_MODNAME);
+		goto err;
+	}
+
+	client = state->i2c_client[num];
+
+	/* decrease I2C driver usage count */
+	module_put(client->dev.driver->owner);
+
+	/* unregister I2C device */
+	i2c_unregister_device(client);
+
+	state->i2c_client[num] = NULL;
+	return;
+err:
+	dev_dbg(&d->udev->dev, "%s: failed\n", __func__);
+}
+
 static int af9035_i2c_master_xfer(struct i2c_adapter *adap,
 		struct i2c_msg msg[], int num)
 {
@@ -1231,17 +1318,39 @@ static int af9035_tuner_attach(struct dvb_usb_adapter *adap)
 	case AF9033_TUNER_IT9135_38:
 	case AF9033_TUNER_IT9135_51:
 	case AF9033_TUNER_IT9135_52:
+	{
+		struct it913x_config it913x_config = {
+			.fe = adap->fe[0],
+			.chip_ver = 1,
+		};
+
+		ret = af9035_add_i2c_dev(d, "it913x",
+				state->af9033_config[adap->id].i2c_addr,
+				&it913x_config);
+		if (ret)
+			goto err;
+
+		fe = adap->fe[0];
+		break;
+	}
 	case AF9033_TUNER_IT9135_60:
 	case AF9033_TUNER_IT9135_61:
 	case AF9033_TUNER_IT9135_62:
-		/* attach tuner */
-		/*
-		fe = dvb_attach(it913x_attach, adap->fe[0], &d->i2c_adap,
+	{
+		struct it913x_config it913x_config = {
+			.fe = adap->fe[0],
+			.chip_ver = 2,
+		};
+
+		ret = af9035_add_i2c_dev(d, "it913x",
 				state->af9033_config[adap->id].i2c_addr,
-				state->af9033_config[0].tuner);
-		*/
-		fe = NULL;
+				&it913x_config);
+		if (ret)
+			goto err;
+
+		fe = adap->fe[0];
 		break;
+	}
 	default:
 		fe = NULL;
 	}
@@ -1306,6 +1415,19 @@ err:
 	return ret;
 }
 
+static void af9035_exit(struct dvb_usb_device *d)
+{
+	struct state *state = d_to_priv(d);
+
+	dev_dbg(&d->udev->dev, "%s:\n", __func__);
+
+	if (state->i2c_client[1])
+		af9035_del_i2c_dev(d);
+
+	if (state->i2c_client[0])
+		af9035_del_i2c_dev(d);
+}
+
 #if IS_ENABLED(CONFIG_RC_CORE)
 static int af9035_rc_query(struct dvb_usb_device *d)
 {
@@ -1482,6 +1604,7 @@ static const struct dvb_usb_device_properties af9035_props = {
 	.init = af9035_init,
 	.get_rc_config = af9035_get_rc_config,
 	.get_stream_config = af9035_get_stream_config,
+	.exit = af9035_exit,
 
 	.get_adapter_count = af9035_get_adapter_count,
 	.adapter = {
diff --git a/drivers/media/usb/dvb-usb-v2/af9035.h b/drivers/media/usb/dvb-usb-v2/af9035.h
index 70ec9c9..0911c4fc 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.h
+++ b/drivers/media/usb/dvb-usb-v2/af9035.h
@@ -62,8 +62,9 @@ struct state {
 	u8 dual_mode:1;
 	u16 eeprom_addr;
 	struct af9033_config af9033_config[2];
-
 	struct af9033_ops ops;
+	#define AF9035_I2C_CLIENT_MAX 2
+	struct i2c_client *i2c_client[AF9035_I2C_CLIENT_MAX];
 };
 
 static const u32 clock_lut_af9035[] = {
-- 
http://palosaari.fi/

