Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60675 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752729AbaBLR7y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Feb 2014 12:59:54 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH FOR 3.14] em28xx-dvb: fix PCTV 461e tuner I2C binding
Date: Wed, 12 Feb 2014 19:59:37 +0200
Message-Id: <1392227977-24528-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add missing m88ts2022 module reference counts as removing that module
is not allowed when it is used by em28xx-dvb module. That same module
was not unregistered correctly, fix it too.

Error cases validated by returning errors from m88ds3103, m88ts2022
and a8293 probe().

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/em28xx/em28xx-dvb.c | 27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index a0a669e..defac24 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -1374,6 +1374,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
 		{
 			/* demod I2C adapter */
 			struct i2c_adapter *i2c_adapter;
+			struct i2c_client *client;
 			struct i2c_board_info info;
 			struct m88ts2022_config m88ts2022_config = {
 				.clock = 27000000,
@@ -1396,7 +1397,19 @@ static int em28xx_dvb_init(struct em28xx *dev)
 			info.addr = 0x60;
 			info.platform_data = &m88ts2022_config;
 			request_module("m88ts2022");
-			dvb->i2c_client_tuner = i2c_new_device(i2c_adapter, &info);
+			client = i2c_new_device(i2c_adapter, &info);
+			if (client == NULL || client->dev.driver == NULL) {
+				dvb_frontend_detach(dvb->fe[0]);
+				result = -ENODEV;
+				goto out_free;
+			}
+
+			if (!try_module_get(client->dev.driver->owner)) {
+				i2c_unregister_device(client);
+				dvb_frontend_detach(dvb->fe[0]);
+				result = -ENODEV;
+				goto out_free;
+			}
 
 			/* delegate signal strength measurement to tuner */
 			dvb->fe[0]->ops.read_signal_strength =
@@ -1406,10 +1419,14 @@ static int em28xx_dvb_init(struct em28xx *dev)
 			if (!dvb_attach(a8293_attach, dvb->fe[0],
 					&dev->i2c_adap[dev->def_i2c_bus],
 					&em28xx_a8293_config)) {
+				module_put(client->dev.driver->owner);
+				i2c_unregister_device(client);
 				dvb_frontend_detach(dvb->fe[0]);
 				result = -ENODEV;
 				goto out_free;
 			}
+
+			dvb->i2c_client_tuner = client;
 		}
 		break;
 	default:
@@ -1471,6 +1488,7 @@ static int em28xx_dvb_fini(struct em28xx *dev)
 
 	if (dev->dvb) {
 		struct em28xx_dvb *dvb = dev->dvb;
+		struct i2c_client *client = dvb->i2c_client_tuner;
 
 		em28xx_uninit_usb_xfer(dev, EM28XX_DIGITAL_MODE);
 
@@ -1483,7 +1501,12 @@ static int em28xx_dvb_fini(struct em28xx *dev)
 				prevent_sleep(&dvb->fe[1]->ops);
 		}
 
-		i2c_release_client(dvb->i2c_client_tuner);
+		/* remove I2C tuner */
+		if (client) {
+			module_put(client->dev.driver->owner);
+			i2c_unregister_device(client);
+		}
+
 		em28xx_unregister_dvb(dvb);
 		kfree(dvb);
 		dev->dvb = NULL;
-- 
1.8.5.3

