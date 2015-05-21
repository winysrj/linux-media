Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44794 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161088AbbEUVYL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2015 17:24:11 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 7/8] cx23885: Hauppauge WinTV-HVR4400/HVR5500 bind I2C demod and SEC
Date: Fri, 22 May 2015 00:23:57 +0300
Message-Id: <1432243438-12225-7-git-send-email-crope@iki.fi>
In-Reply-To: <1432243438-12225-1-git-send-email-crope@iki.fi>
References: <1432243438-12225-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Bind tda10071 demod and a8293 SEC using I2C binding.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/pci/cx23885/cx23885-dvb.c | 54 +++++++++++++++++++++------------
 1 file changed, 35 insertions(+), 19 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index 4c41e11..ef1ebcb 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -856,16 +856,6 @@ static struct mt2063_config terratec_mt2063_config[] = {
 	},
 };
 
-static const struct tda10071_config hauppauge_tda10071_config = {
-	.demod_i2c_addr = 0x05,
-	.tuner_i2c_addr = 0x54,
-	.i2c_wr_max = 64,
-	.ts_mode = TDA10071_TS_SERIAL,
-	.spec_inv = 0,
-	.xtal = 40444000, /* 40.444 MHz */
-	.pll_multiplier = 20,
-};
-
 static const struct tda10071_platform_data hauppauge_tda10071_pdata = {
 	.clk = 40444000, /* 40.444 MHz */
 	.i2c_wr_max = 64,
@@ -1806,21 +1796,46 @@ static int dvb_register(struct cx23885_tsport *port)
 
 		fe0->dvb.frontend->ops.set_voltage = p8000_set_voltage;
 		break;
-	case CX23885_BOARD_HAUPPAUGE_HVR4400:
+	case CX23885_BOARD_HAUPPAUGE_HVR4400: {
+		struct tda10071_platform_data tda10071_pdata = hauppauge_tda10071_pdata;
+		struct a8293_platform_data a8293_pdata = {};
+
 		i2c_bus = &dev->i2c_bus[0];
 		i2c_bus2 = &dev->i2c_bus[1];
 		switch (port->nr) {
 		/* port b */
 		case 1:
-			fe0->dvb.frontend = dvb_attach(tda10071_attach,
-						&hauppauge_tda10071_config,
-						&i2c_bus->i2c_adap);
-			if (fe0->dvb.frontend == NULL)
-				break;
-			if (!dvb_attach(a8293_attach, fe0->dvb.frontend,
-					&i2c_bus->i2c_adap,
-					&hauppauge_a8293_config))
+			/* attach demod + tuner combo */
+			memset(&info, 0, sizeof(info));
+			strlcpy(info.type, "tda10071_cx24118", I2C_NAME_SIZE);
+			info.addr = 0x05;
+			info.platform_data = &tda10071_pdata;
+			request_module("tda10071");
+			client_demod = i2c_new_device(&i2c_bus->i2c_adap, &info);
+			if (!client_demod || !client_demod->dev.driver)
+				goto frontend_detach;
+			if (!try_module_get(client_demod->dev.driver->owner)) {
+				i2c_unregister_device(client_demod);
+				goto frontend_detach;
+			}
+			fe0->dvb.frontend = tda10071_pdata.get_dvb_frontend(client_demod);
+			port->i2c_client_demod = client_demod;
+
+			/* attach SEC */
+			a8293_pdata.dvb_frontend = fe0->dvb.frontend;
+			memset(&info, 0, sizeof(info));
+			strlcpy(info.type, "a8293", I2C_NAME_SIZE);
+			info.addr = 0x0b;
+			info.platform_data = &a8293_pdata;
+			request_module("a8293");
+			client_sec = i2c_new_device(&i2c_bus->i2c_adap, &info);
+			if (!client_sec || !client_sec->dev.driver)
 				goto frontend_detach;
+			if (!try_module_get(client_sec->dev.driver->owner)) {
+				i2c_unregister_device(client_sec);
+				goto frontend_detach;
+			}
+			port->i2c_client_sec = client_sec;
 			break;
 		/* port c */
 		case 2:
@@ -1838,6 +1853,7 @@ static int dvb_register(struct cx23885_tsport *port)
 			break;
 		}
 		break;
+	}
 	case CX23885_BOARD_HAUPPAUGE_STARBURST: {
 		struct tda10071_platform_data tda10071_pdata = hauppauge_tda10071_pdata;
 		struct a8293_platform_data a8293_pdata = {};
-- 
http://palosaari.fi/

