Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53482 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161085AbbEUVYL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2015 17:24:11 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 8/8] cx23885: Hauppauge WinTV-HVR5525 bind I2C SEC
Date: Fri, 22 May 2015 00:23:58 +0300
Message-Id: <1432243438-12225-8-git-send-email-crope@iki.fi>
In-Reply-To: <1432243438-12225-1-git-send-email-crope@iki.fi>
References: <1432243438-12225-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Bind a8293 SEC using I2C binding.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/pci/cx23885/cx23885-dvb.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index ef1ebcb..9f377ad 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -864,10 +864,6 @@ static const struct tda10071_platform_data hauppauge_tda10071_pdata = {
 	.tuner_i2c_addr = 0x54,
 };
 
-static const struct a8293_config hauppauge_a8293_config = {
-	.i2c_addr = 0x0b,
-};
-
 static const struct si2165_config hauppauge_hvr4400_si2165_config = {
 	.i2c_addr	= 0x64,
 	.chip_mode	= SI2165_MODE_PLL_XTAL,
@@ -2167,6 +2163,7 @@ static int dvb_register(struct cx23885_tsport *port)
 	case CX23885_BOARD_HAUPPAUGE_HVR5525:
 		switch (port->nr) {
 		struct m88rs6000t_config m88rs6000t_config;
+		struct a8293_platform_data a8293_pdata = {};
 
 		/* port b - satellite */
 		case 1:
@@ -2178,10 +2175,20 @@ static int dvb_register(struct cx23885_tsport *port)
 				break;
 
 			/* attach SEC */
-			if (!dvb_attach(a8293_attach, fe0->dvb.frontend,
-					&dev->i2c_bus[0].i2c_adap,
-					&hauppauge_a8293_config))
+			a8293_pdata.dvb_frontend = fe0->dvb.frontend;
+			memset(&info, 0, sizeof(info));
+			strlcpy(info.type, "a8293", I2C_NAME_SIZE);
+			info.addr = 0x0b;
+			info.platform_data = &a8293_pdata;
+			request_module("a8293");
+			client_sec = i2c_new_device(&dev->i2c_bus[0].i2c_adap, &info);
+			if (!client_sec || !client_sec->dev.driver)
 				goto frontend_detach;
+			if (!try_module_get(client_sec->dev.driver->owner)) {
+				i2c_unregister_device(client_sec);
+				goto frontend_detach;
+			}
+			port->i2c_client_sec = client_sec;
 
 			/* attach tuner */
 			memset(&m88rs6000t_config, 0, sizeof(m88rs6000t_config));
-- 
http://palosaari.fi/

