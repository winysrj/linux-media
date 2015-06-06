Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54546 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752588AbbFFL7J (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Jun 2015 07:59:09 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 8/8] em28xx: PCTV 461e use I2C client for demod and SEC
Date: Sat,  6 Jun 2015 14:58:48 +0300
Message-Id: <1433591928-30915-8-git-send-email-crope@iki.fi>
In-Reply-To: <1433591928-30915-1-git-send-email-crope@iki.fi>
References: <1433591928-30915-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use I2C client binding for demod and SEC.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/em28xx/em28xx-dvb.c | 136 +++++++++++++++++++++-------------
 1 file changed, 83 insertions(+), 53 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index be0abca..a382483 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -1521,64 +1521,94 @@ static int em28xx_dvb_init(struct em28xx *dev)
 			}
 		}
 		break;
-	case EM28178_BOARD_PCTV_461E:
-		{
-			/* demod I2C adapter */
-			struct i2c_adapter *i2c_adapter;
-			struct i2c_client *client;
-			struct i2c_board_info info;
-			struct ts2020_config ts2020_config = {
-			};
-			memset(&info, 0, sizeof(struct i2c_board_info));
-
-			/* attach demod */
-			dvb->fe[0] = dvb_attach(m88ds3103_attach,
-					&pctv_461e_m88ds3103_config,
-					&dev->i2c_adap[dev->def_i2c_bus],
-					&i2c_adapter);
-			if (dvb->fe[0] == NULL) {
-				result = -ENODEV;
-				goto out_free;
-			}
-
-			/* attach tuner */
-			ts2020_config.fe = dvb->fe[0];
-			strlcpy(info.type, "ts2022", I2C_NAME_SIZE);
-			info.addr = 0x60;
-			info.platform_data = &ts2020_config;
-			request_module("ts2020");
-			client = i2c_new_device(i2c_adapter, &info);
-			if (client == NULL || client->dev.driver == NULL) {
-				dvb_frontend_detach(dvb->fe[0]);
-				result = -ENODEV;
-				goto out_free;
-			}
-
-			if (!try_module_get(client->dev.driver->owner)) {
-				i2c_unregister_device(client);
-				dvb_frontend_detach(dvb->fe[0]);
-				result = -ENODEV;
-				goto out_free;
-			}
+	case EM28178_BOARD_PCTV_461E: {
+		struct i2c_client *client;
+		struct i2c_adapter *i2c_adapter;
+		struct i2c_board_info board_info;
+		struct m88ds3103_platform_data m88ds3103_pdata = {};
+		struct ts2020_config ts2020_config = {};
+		struct a8293_platform_data a8293_pdata = {};
 
-			/* delegate signal strength measurement to tuner */
-			dvb->fe[0]->ops.read_signal_strength =
-					dvb->fe[0]->ops.tuner_ops.get_rf_strength;
+		/* attach demod */
+		m88ds3103_pdata.clk = 27000000;
+		m88ds3103_pdata.i2c_wr_max = 33;
+		m88ds3103_pdata.ts_mode = M88DS3103_TS_PARALLEL;
+		m88ds3103_pdata.ts_clk = 16000;
+		m88ds3103_pdata.ts_clk_pol = 1;
+		m88ds3103_pdata.agc = 0x99;
+		memset(&board_info, 0, sizeof(board_info));
+		strlcpy(board_info.type, "m88ds3103", I2C_NAME_SIZE);
+		board_info.addr = 0x68;
+		board_info.platform_data = &m88ds3103_pdata;
+		request_module("m88ds3103");
+		client = i2c_new_device(&dev->i2c_adap[dev->def_i2c_bus], &board_info);
+		if (client == NULL || client->dev.driver == NULL) {
+			result = -ENODEV;
+			goto out_free;
+		}
+		if (!try_module_get(client->dev.driver->owner)) {
+			i2c_unregister_device(client);
+			result = -ENODEV;
+			goto out_free;
+		}
+		dvb->fe[0] = m88ds3103_pdata.get_dvb_frontend(client);
+		i2c_adapter = m88ds3103_pdata.get_i2c_adapter(client);
+		dvb->i2c_client_demod = client;
 
-			/* attach SEC */
-			if (!dvb_attach(a8293_attach, dvb->fe[0],
-					&dev->i2c_adap[dev->def_i2c_bus],
-					&em28xx_a8293_config)) {
-				module_put(client->dev.driver->owner);
-				i2c_unregister_device(client);
-				dvb_frontend_detach(dvb->fe[0]);
-				result = -ENODEV;
-				goto out_free;
-			}
+		/* attach tuner */
+		ts2020_config.fe = dvb->fe[0];
+		memset(&board_info, 0, sizeof(board_info));
+		strlcpy(board_info.type, "ts2022", I2C_NAME_SIZE);
+		board_info.addr = 0x60;
+		board_info.platform_data = &ts2020_config;
+		request_module("ts2020");
+		client = i2c_new_device(i2c_adapter, &board_info);
+		if (client == NULL || client->dev.driver == NULL) {
+			module_put(dvb->i2c_client_demod->dev.driver->owner);
+			i2c_unregister_device(dvb->i2c_client_demod);
+			result = -ENODEV;
+			goto out_free;
+		}
+		if (!try_module_get(client->dev.driver->owner)) {
+			i2c_unregister_device(client);
+			module_put(dvb->i2c_client_demod->dev.driver->owner);
+			i2c_unregister_device(dvb->i2c_client_demod);
+			result = -ENODEV;
+			goto out_free;
+		}
+		dvb->i2c_client_tuner = client;
+		/* delegate signal strength measurement to tuner */
+		dvb->fe[0]->ops.read_signal_strength =
+				dvb->fe[0]->ops.tuner_ops.get_rf_strength;
 
-			dvb->i2c_client_tuner = client;
+		/* attach SEC */
+		a8293_pdata.dvb_frontend = dvb->fe[0];
+		memset(&board_info, 0, sizeof(board_info));
+		strlcpy(board_info.type, "a8293", I2C_NAME_SIZE);
+		board_info.addr = 0x08;
+		board_info.platform_data = &a8293_pdata;
+		request_module("a8293");
+		client = i2c_new_device(&dev->i2c_adap[dev->def_i2c_bus], &board_info);
+		if (client == NULL || client->dev.driver == NULL) {
+			module_put(dvb->i2c_client_tuner->dev.driver->owner);
+			i2c_unregister_device(dvb->i2c_client_tuner);
+			module_put(dvb->i2c_client_demod->dev.driver->owner);
+			i2c_unregister_device(dvb->i2c_client_demod);
+			result = -ENODEV;
+			goto out_free;
+		}
+		if (!try_module_get(client->dev.driver->owner)) {
+			i2c_unregister_device(client);
+			module_put(dvb->i2c_client_tuner->dev.driver->owner);
+			i2c_unregister_device(dvb->i2c_client_tuner);
+			module_put(dvb->i2c_client_demod->dev.driver->owner);
+			i2c_unregister_device(dvb->i2c_client_demod);
+			result = -ENODEV;
+			goto out_free;
 		}
+		dvb->i2c_client_sec = client;
 		break;
+	}
 	case EM28178_BOARD_PCTV_292E:
 		{
 			struct i2c_adapter *adapter;
-- 
http://palosaari.fi/

