Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44459 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161083AbbEUVYL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2015 17:24:11 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 4/8] em28xx: bind PCTV 460e using I2C client
Date: Fri, 22 May 2015 00:23:54 +0300
Message-Id: <1432243438-12225-4-git-send-email-crope@iki.fi>
In-Reply-To: <1432243438-12225-1-git-send-email-crope@iki.fi>
References: <1432243438-12225-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Load PCTV 460e tda10071 demod and a8293 SEC using I2C client bindings.
Remove old unused tda10071 config struct. We are using I2C platform
data now.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/em28xx/em28xx-dvb.c | 68 ++++++++++++++++++++++++++---------
 1 file changed, 51 insertions(+), 17 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index ef1bfa2..be0abca 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -808,16 +808,6 @@ static struct tda18271_config em28xx_cxd2820r_tda18271_config = {
 	.gate = TDA18271_GATE_DIGITAL,
 };
 
-static const struct tda10071_config em28xx_tda10071_config = {
-	.demod_i2c_addr = 0x55, /* (0xaa >> 1) */
-	.tuner_i2c_addr = 0x14,
-	.i2c_wr_max = 64,
-	.ts_mode = TDA10071_TS_SERIAL,
-	.spec_inv = 0,
-	.xtal = 40444000, /* 40.444 MHz */
-	.pll_multiplier = 20,
-};
-
 static const struct a8293_config em28xx_a8293_config = {
 	.i2c_addr = 0x08, /* (0x10 >> 1) */
 };
@@ -1332,16 +1322,60 @@ static int em28xx_dvb_init(struct em28xx *dev)
 				   &dev->i2c_adap[dev->def_i2c_bus],
 				   &c3tech_duo_tda18271_config);
 		break;
-	case EM28174_BOARD_PCTV_460E:
-		/* attach demod */
-		dvb->fe[0] = dvb_attach(tda10071_attach,
-			&em28xx_tda10071_config, &dev->i2c_adap[dev->def_i2c_bus]);
+	case EM28174_BOARD_PCTV_460E: {
+		struct i2c_client *client;
+		struct i2c_board_info board_info;
+		struct tda10071_platform_data tda10071_pdata = {};
+		struct a8293_platform_data a8293_pdata = {};
+
+		/* attach demod + tuner combo */
+		tda10071_pdata.clk = 40444000, /* 40.444 MHz */
+		tda10071_pdata.i2c_wr_max = 64,
+		tda10071_pdata.ts_mode = TDA10071_TS_SERIAL,
+		tda10071_pdata.pll_multiplier = 20,
+		tda10071_pdata.tuner_i2c_addr = 0x14,
+		memset(&board_info, 0, sizeof(board_info));
+		strlcpy(board_info.type, "tda10071_cx24118", I2C_NAME_SIZE);
+		board_info.addr = 0x55;
+		board_info.platform_data = &tda10071_pdata;
+		request_module("tda10071");
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
+		dvb->fe[0] = tda10071_pdata.get_dvb_frontend(client);
+		dvb->i2c_client_demod = client;
 
 		/* attach SEC */
-		if (dvb->fe[0])
-			dvb_attach(a8293_attach, dvb->fe[0], &dev->i2c_adap[dev->def_i2c_bus],
-				   &em28xx_a8293_config);
+		a8293_pdata.dvb_frontend = dvb->fe[0];
+		memset(&board_info, 0, sizeof(board_info));
+		strlcpy(board_info.type, "a8293", I2C_NAME_SIZE);
+		board_info.addr = 0x08;
+		board_info.platform_data = &a8293_pdata;
+		request_module("a8293");
+		client = i2c_new_device(&dev->i2c_adap[dev->def_i2c_bus], &board_info);
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
+		dvb->i2c_client_sec = client;
 		break;
+	}
 	case EM2874_BOARD_DELOCK_61959:
 	case EM2874_BOARD_MAXMEDIA_UB425_TC:
 		/* attach demodulator */
-- 
http://palosaari.fi/

