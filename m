Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:55100 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752798AbcGZHJi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jul 2016 03:09:38 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, crope@iki.fi,
	Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH 2/7] cx23885: attach si2165 driver via i2c_client
Date: Tue, 26 Jul 2016 09:09:03 +0200
Message-Id: <20160726070908.10135-2-zzam@gentoo.org>
In-Reply-To: <20160726070908.10135-1-zzam@gentoo.org>
References: <20160726070908.10135-1-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use new style attach.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/pci/cx23885/cx23885-dvb.c | 30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index e5748a9..5d0bbe4 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -867,12 +867,6 @@ static const struct tda10071_platform_data hauppauge_tda10071_pdata = {
 	.tuner_i2c_addr = 0x54,
 };
 
-static const struct si2165_config hauppauge_hvr4400_si2165_config = {
-	.i2c_addr	= 0x64,
-	.chip_mode	= SI2165_MODE_PLL_XTAL,
-	.ref_freq_Hz	= 16000000,
-};
-
 static const struct m88ds3103_config dvbsky_t9580_m88ds3103_config = {
 	.i2c_addr = 0x68,
 	.clock = 27000000,
@@ -1182,6 +1176,7 @@ static int dvb_register(struct cx23885_tsport *port)
 	struct cx23885_i2c *i2c_bus = NULL, *i2c_bus2 = NULL;
 	struct vb2_dvb_frontend *fe0, *fe1 = NULL;
 	struct si2168_config si2168_config;
+	struct si2165_platform_data si2165_pdata;
 	struct si2157_config si2157_config;
 	struct ts2020_config ts2020_config;
 	struct i2c_board_info info;
@@ -1839,9 +1834,26 @@ static int dvb_register(struct cx23885_tsport *port)
 			break;
 		/* port c */
 		case 2:
-			fe0->dvb.frontend = dvb_attach(si2165_attach,
-					&hauppauge_hvr4400_si2165_config,
-					&i2c_bus->i2c_adap);
+			/* attach frontend */
+			memset(&si2165_pdata, 0, sizeof(si2165_pdata));
+			si2165_pdata.fe = &fe0->dvb.frontend;
+			si2165_pdata.chip_mode = SI2165_MODE_PLL_XTAL,
+			si2165_pdata.ref_freq_Hz = 16000000,
+			memset(&info, 0, sizeof(struct i2c_board_info));
+			strlcpy(info.type, "si2165", I2C_NAME_SIZE);
+			info.addr = 0x64;
+			info.platform_data = &si2165_pdata;
+			request_module(info.type);
+			client_demod = i2c_new_device(&i2c_bus->i2c_adap, &info);
+			if (client_demod == NULL ||
+					client_demod->dev.driver == NULL)
+				goto frontend_detach;
+			if (!try_module_get(client_demod->dev.driver->owner)) {
+				i2c_unregister_device(client_demod);
+				goto frontend_detach;
+			}
+			port->i2c_client_demod = client_demod;
+
 			if (fe0->dvb.frontend == NULL)
 				break;
 			fe0->dvb.frontend->ops.i2c_gate_ctrl = NULL;
-- 
2.9.2

