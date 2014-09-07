Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44480 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751530AbaIGCAR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Sep 2014 22:00:17 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH v2 4/8] em28xx: convert tda18212 tuner to I2C client
Date: Sun,  7 Sep 2014 04:59:56 +0300
Message-Id: <1410055200-32170-4-git-send-email-crope@iki.fi>
In-Reply-To: <1410055200-32170-1-git-send-email-crope@iki.fi>
References: <1410055200-32170-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Used tda18212 tuner is implemented as a I2C driver. Use em28xx
tuner I2C client for tda18212 driver.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/em28xx/em28xx-dvb.c | 32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 0645793..9682c52 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -373,7 +373,6 @@ static struct tda18271_config kworld_ub435q_v2_config = {
 };
 
 static struct tda18212_config kworld_ub435q_v3_config = {
-	.i2c_address	= 0x60,
 	.if_atsc_vsb	= 3600,
 	.if_atsc_qam	= 3600,
 };
@@ -1437,6 +1436,15 @@ static int em28xx_dvb_init(struct em28xx *dev)
 		}
 		break;
 	case EM2874_BOARD_KWORLD_UB435Q_V3:
+	{
+		struct i2c_client *client;
+		struct i2c_adapter *adapter = &dev->i2c_adap[dev->def_i2c_bus];
+		struct i2c_board_info board_info = {
+			.type = "tda18212",
+			.addr = 0x60,
+			.platform_data = &kworld_ub435q_v3_config,
+		};
+
 		dvb->fe[0] = dvb_attach(lgdt3305_attach,
 					&em2874_lgdt3305_nogate_dev,
 					&dev->i2c_adap[dev->def_i2c_bus]);
@@ -1445,14 +1453,26 @@ static int em28xx_dvb_init(struct em28xx *dev)
 			goto out_free;
 		}
 
-		/* Attach the demodulator. */
-		if (!dvb_attach(tda18212_attach, dvb->fe[0],
-				&dev->i2c_adap[dev->def_i2c_bus],
-				&kworld_ub435q_v3_config)) {
-			result = -EINVAL;
+		/* attach tuner */
+		kworld_ub435q_v3_config.fe = dvb->fe[0];
+		request_module("tda18212");
+		client = i2c_new_device(adapter, &board_info);
+		if (client == NULL || client->dev.driver == NULL) {
+			dvb_frontend_detach(dvb->fe[0]);
+			result = -ENODEV;
 			goto out_free;
 		}
+
+		if (!try_module_get(client->dev.driver->owner)) {
+			i2c_unregister_device(client);
+			dvb_frontend_detach(dvb->fe[0]);
+			result = -ENODEV;
+			goto out_free;
+		}
+
+		dvb->i2c_client_tuner = client;
 		break;
+	}
 	case EM2874_BOARD_PCTV_HD_MINI_80E:
 		dvb->fe[0] = dvb_attach(drx39xxj_attach, &dev->i2c_adap[dev->def_i2c_bus]);
 		if (dvb->fe[0] != NULL) {
-- 
http://palosaari.fi/

