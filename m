Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:54635 "EHLO
        homiemail-a117.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932204AbeBLVpv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Feb 2018 16:45:51 -0500
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH v2 7/7] cx231xx: Add second i2c demod to Hauppauge 975
Date: Mon, 12 Feb 2018 15:45:19 -0600
Message-Id: <1518471919-29885-1-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1515773982-6411-8-git-send-email-brad@nextdimension.cc>
References: <1515773982-6411-8-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hauppauge HVR-975 is a hybrid, dual frontend, single tuner USB device.
It contains lgdt3306a and si2168 frontends and one si2157 tuner. The
lgdt3306a frontend is currently enabled. This creates the second
demodulator and attaches it to the tuner.

Enables lgdt3306a|si2168 + si2157

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
Changes since v1:
- memcpy tuner ops to frontend[1] instead of dvb attach
- remove a couple redundant dev-> spots
- moved failure messages one block up where probe would fail

 drivers/media/usb/cx231xx/cx231xx-cards.c |  1 +
 drivers/media/usb/cx231xx/cx231xx-dvb.c   | 52 +++++++++++++++++++++++++++++--
 2 files changed, 50 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index 8582568..00e88a8f 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -979,6 +979,7 @@ struct cx231xx_board cx231xx_boards[] = {
 		.demod_i2c_master = I2C_1_MUX_3,
 		.has_dvb = 1,
 		.demod_addr = 0x59, /* 0xb2 >> 1 */
+		.demod_addr2 = 0x64, /* 0xc8 >> 1 */
 		.norm = V4L2_STD_ALL,
 
 		.input = {{
diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
index ac3ad77..f1ffb57 100644
--- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
@@ -1173,14 +1173,17 @@ static int dvb_init(struct cx231xx *dev)
 	{
 		struct i2c_client *client;
 		struct i2c_adapter *adapter;
+		struct i2c_adapter *adapter2;
 		struct i2c_board_info info = {};
 		struct si2157_config si2157_config = {};
 		struct lgdt3306a_config lgdt3306a_config = {};
+		struct si2168_config si2168_config = {};
 
-		/* attach demodulator chip */
+		/* attach first demodulator chip */
 		lgdt3306a_config = hauppauge_955q_lgdt3306a_config;
 		lgdt3306a_config.fe = &dev->dvb->frontend[0];
 		lgdt3306a_config.i2c_adapter = &adapter;
+		lgdt3306a_config.deny_i2c_rptr = 0;
 
 		strlcpy(info.type, "lgdt3306a", sizeof(info.type));
 		info.addr = dev->board.demod_addr;
@@ -1202,10 +1205,43 @@ static int dvb_init(struct cx231xx *dev)
 		}
 
 		dvb->i2c_client_demod[0] = client;
-		dev->dvb->frontend[0]->ops.i2c_gate_ctrl = NULL;
+
+		/* attach second demodulator chip */
+		si2168_config.ts_mode = SI2168_TS_SERIAL;
+		si2168_config.fe = &dev->dvb->frontend[1];
+		si2168_config.i2c_adapter = &adapter2;
+		si2168_config.ts_clock_inv = true;
+
+		memset(&info, 0, sizeof(struct i2c_board_info));
+		strlcpy(info.type, "si2168", sizeof(info.type));
+		info.addr = dev->board.demod_addr2;
+		info.platform_data = &si2168_config;
+
+		request_module(info.type);
+		client = i2c_new_device(adapter, &info);
+		if (client == NULL || client->dev.driver == NULL) {
+			dev_err(dev->dev,
+				"Failed to attach %s frontend.\n", info.type);
+			module_put(dvb->i2c_client_demod[0]->dev.driver->owner);
+			i2c_unregister_device(dvb->i2c_client_demod[0]);
+			result = -ENODEV;
+			goto out_free;
+		}
+
+		if (!try_module_get(client->dev.driver->owner)) {
+			i2c_unregister_device(client);
+			module_put(dvb->i2c_client_demod[0]->dev.driver->owner);
+			i2c_unregister_device(dvb->i2c_client_demod[0]);
+			result = -ENODEV;
+			goto out_free;
+		}
+
+		dvb->i2c_client_demod[1] = client;
+		dvb->frontend[1]->id = 1;
 
 		/* define general-purpose callback pointer */
 		dvb->frontend[0]->callback = cx231xx_tuner_callback;
+		dvb->frontend[1]->callback = cx231xx_tuner_callback;
 
 		/* attach tuner */
 		si2157_config.fe = dev->dvb->frontend[0];
@@ -1225,6 +1261,8 @@ static int dvb_init(struct cx231xx *dev)
 		if (client == NULL || client->dev.driver == NULL) {
 			dev_err(dev->dev,
 				"Failed to obtain %s tuner.\n",	info.type);
+			module_put(dvb->i2c_client_demod[1]->dev.driver->owner);
+			i2c_unregister_device(dvb->i2c_client_demod[1]);
 			module_put(dvb->i2c_client_demod[0]->dev.driver->owner);
 			i2c_unregister_device(dvb->i2c_client_demod[0]);
 			result = -ENODEV;
@@ -1233,6 +1271,8 @@ static int dvb_init(struct cx231xx *dev)
 
 		if (!try_module_get(client->dev.driver->owner)) {
 			i2c_unregister_device(client);
+			module_put(dvb->i2c_client_demod[1]->dev.driver->owner);
+			i2c_unregister_device(dvb->i2c_client_demod[1]);
 			module_put(dvb->i2c_client_demod[0]->dev.driver->owner);
 			i2c_unregister_device(dvb->i2c_client_demod[0]);
 			result = -ENODEV;
@@ -1240,7 +1280,13 @@ static int dvb_init(struct cx231xx *dev)
 		}
 
 		dev->cx231xx_reset_analog_tuner = NULL;
-		dev->dvb->i2c_client_tuner = client;
+		dvb->i2c_client_tuner = client;
+
+		dvb->frontend[1]->tuner_priv = dvb->frontend[0]->tuner_priv;
+
+		memcpy(&dvb->frontend[1]->ops.tuner_ops,
+			&dvb->frontend[0]->ops.tuner_ops,
+			sizeof(struct dvb_tuner_ops));
 		break;
 	}
 	default:
-- 
2.7.4
