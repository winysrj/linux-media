Return-path: <linux-media-owner@vger.kernel.org>
Received: from salscheider-online.de ([46.38.239.204]:49271 "EHLO
        mail.salscheider-online.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751042AbcLYPqW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Dec 2016 10:46:22 -0500
From: Niels Ole Salscheider <niels_ole@salscheider-online.de>
To: linux-media@vger.kernel.org
Cc: Niels Ole Salscheider <niels_ole@salscheider-online.de>
Subject: [PATCH] [media] cx23885: attach md88ds3103 driver via i2c_client for DVBSky S952
Date: Sun, 25 Dec 2016 16:38:20 +0100
Message-Id: <20161225153820.20298-1-niels_ole@salscheider-online.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With this patch we use the new style to attach the frontend.

Signed-off-by: Niels Ole Salscheider <niels_ole@salscheider-online.de>
---
 drivers/media/pci/cx23885/cx23885-dvb.c | 54 +++++++++++++++++++--------------
 1 file changed, 32 insertions(+), 22 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index 818f3c2fc98d..d0af02c27a16 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -918,19 +918,6 @@ static const struct m88ds3103_config dvbsky_s950c_m88ds3103_config = {
 	.agc = 0x99,
 };
 
-static const struct m88ds3103_config dvbsky_s952_portc_m88ds3103_config = {
-	.i2c_addr = 0x68,
-	.clock = 27000000,
-	.i2c_wr_max = 33,
-	.clock_out = 0,
-	.ts_mode = M88DS3103_TS_SERIAL,
-	.ts_clk = 96000,
-	.ts_clk_pol = 0,
-	.lnb_en_pol = 1,
-	.lnb_hv_pol = 0,
-	.agc = 0x99,
-};
-
 static const struct m88ds3103_config hauppauge_hvr5525_m88ds3103_config = {
 	.i2c_addr = 0x69,
 	.clock = 27000000,
@@ -1204,11 +1191,11 @@ static int dvb_register(struct cx23885_tsport *port)
 	struct si2165_platform_data si2165_pdata;
 	struct si2157_config si2157_config;
 	struct ts2020_config ts2020_config;
+	struct m88ds3103_platform_data m88ds3103_pdata;
 	struct i2c_board_info info;
 	struct i2c_adapter *adapter;
 	struct i2c_client *client_demod = NULL, *client_tuner = NULL;
 	struct i2c_client *client_sec = NULL;
-	const struct m88ds3103_config *p_m88ds3103_config = NULL;
 	int (*p_set_voltage)(struct dvb_frontend *fe,
 			     enum fe_sec_voltage voltage) = NULL;
 	int mfe_shared = 0; /* bus not shared by default */
@@ -2103,27 +2090,50 @@ static int dvb_register(struct cx23885_tsport *port)
 		port->i2c_client_tuner = client_tuner;
 		break;
 	case CX23885_BOARD_DVBSKY_S952:
+		/* attach frontend */
+		memset(&m88ds3103_pdata, 0, sizeof(m88ds3103_pdata));
+		m88ds3103_pdata.clk = 27000000;
+		m88ds3103_pdata.i2c_wr_max = 33;
+		m88ds3103_pdata.agc = 0x99;
+		m88ds3103_pdata.clk_out = M88DS3103_CLOCK_OUT_DISABLED;
+		m88ds3103_pdata.lnb_en_pol = 1;
+
 		switch (port->nr) {
 		/* port b */
 		case 1:
 			i2c_bus = &dev->i2c_bus[1];
-			p_m88ds3103_config = &dvbsky_t9580_m88ds3103_config;
+			m88ds3103_pdata.ts_mode = M88DS3103_TS_PARALLEL;
+			m88ds3103_pdata.ts_clk = 16000;
+			m88ds3103_pdata.ts_clk_pol = 1;
 			p_set_voltage = dvbsky_t9580_set_voltage;
 			break;
 		/* port c */
 		case 2:
 			i2c_bus = &dev->i2c_bus[0];
-			p_m88ds3103_config = &dvbsky_s952_portc_m88ds3103_config;
+			m88ds3103_pdata.ts_mode = M88DS3103_TS_SERIAL;
+			m88ds3103_pdata.ts_clk = 96000;
+			m88ds3103_pdata.ts_clk_pol = 0;
 			p_set_voltage = dvbsky_s952_portc_set_voltage;
 			break;
+		default:
+			return 0;
 		}
 
-		/* attach frontend */
-		fe0->dvb.frontend = dvb_attach(m88ds3103_attach,
-				p_m88ds3103_config,
-				&i2c_bus->i2c_adap, &adapter);
-		if (fe0->dvb.frontend == NULL)
-			break;
+		memset(&info, 0, sizeof(info));
+		strlcpy(info.type, "m88ds3103", I2C_NAME_SIZE);
+		info.addr = 0x68;
+		info.platform_data = &m88ds3103_pdata;
+		request_module(info.type);
+		client_demod = i2c_new_device(&i2c_bus->i2c_adap, &info);
+		if (client_demod == NULL || client_demod->dev.driver == NULL)
+			goto frontend_detach;
+		if (!try_module_get(client_demod->dev.driver->owner)) {
+			i2c_unregister_device(client_demod);
+			goto frontend_detach;
+		}
+		port->i2c_client_demod = client_demod;
+		adapter = m88ds3103_pdata.get_i2c_adapter(client_demod);
+		fe0->dvb.frontend = m88ds3103_pdata.get_dvb_frontend(client_demod);
 
 		/* attach tuner */
 		memset(&ts2020_config, 0, sizeof(ts2020_config));
-- 
2.11.0

