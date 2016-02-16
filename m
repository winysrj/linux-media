Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:34594 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755619AbcBPRxy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Feb 2016 12:53:54 -0500
Received: by mail-lb0-f177.google.com with SMTP id of3so9665847lbc.1
        for <linux-media@vger.kernel.org>; Tue, 16 Feb 2016 09:53:53 -0800 (PST)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH] dw2102: convert TechnoTrend S2-4600 to use I2C binding for demod
Date: Tue, 16 Feb 2016 19:53:45 +0200
Message-Id: <1455645225-26770-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert the TT S2-4600 USB tuner to use the I2C binding for attaching
the demodulator instead of the old m88ds3103_attach method.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/usb/dvb-usb/dw2102.c | 71 +++++++++++++++++++++++---------------
 1 file changed, 43 insertions(+), 28 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/dw2102.c b/drivers/media/usb/dvb-usb/dw2102.c
index dd46d6c..4d2c71b 100644
--- a/drivers/media/usb/dvb-usb/dw2102.c
+++ b/drivers/media/usb/dvb-usb/dw2102.c
@@ -118,6 +118,7 @@
 struct dw2102_state {
 	u8 initialized;
 	u8 last_lock;
+	struct i2c_client *i2c_client_demod;
 	struct i2c_client *i2c_client_tuner;
 
 	/* fe hook functions*/
@@ -1141,22 +1142,6 @@ static struct tda18271_config tda18271_config = {
 	.gate = TDA18271_GATE_DIGITAL,
 };
 
-static const struct m88ds3103_config tt_s2_4600_m88ds3103_config = {
-	.i2c_addr = 0x68,
-	.clock = 27000000,
-	.i2c_wr_max = 33,
-	.ts_mode = M88DS3103_TS_CI,
-	.ts_clk = 16000,
-	.ts_clk_pol = 0,
-	.spec_inv = 0,
-	.agc_inv = 0,
-	.clock_out = M88DS3103_CLOCK_OUT_ENABLED,
-	.envelope_mode = 0,
-	.agc = 0x99,
-	.lnb_hv_pol = 1,
-	.lnb_en_pol = 0,
-};
-
 static u8 m88rs2000_inittab[] = {
 	DEMOD_WRITE, 0x9a, 0x30,
 	DEMOD_WRITE, 0x00, 0x01,
@@ -1509,7 +1494,8 @@ static int tt_s2_4600_frontend_attach(struct dvb_usb_adapter *adap)
 	u8 ibuf[] = { 0 };
 	struct i2c_adapter *i2c_adapter;
 	struct i2c_client *client;
-	struct i2c_board_info info;
+	struct i2c_board_info board_info;
+	struct m88ds3103_platform_data m88ds3103_pdata = {};
 	struct ts2020_config ts2020_config = {};
 
 	if (dvb_usb_generic_rw(d, obuf, 3, ibuf, 1, 0) < 0)
@@ -1542,22 +1528,44 @@ static int tt_s2_4600_frontend_attach(struct dvb_usb_adapter *adap)
 	if (dvb_usb_generic_rw(d, obuf, 1, ibuf, 1, 0) < 0)
 		err("command 0x51 transfer failed.");
 
-	memset(&info, 0, sizeof(struct i2c_board_info));
-
-	adap->fe_adap[0].fe = dvb_attach(m88ds3103_attach,
-					&tt_s2_4600_m88ds3103_config,
-					&d->i2c_adap,
-					&i2c_adapter);
-	if (adap->fe_adap[0].fe == NULL)
+	/* attach demod */
+	m88ds3103_pdata.clk = 27000000;
+	m88ds3103_pdata.i2c_wr_max = 33;
+	m88ds3103_pdata.ts_mode = M88DS3103_TS_CI;
+	m88ds3103_pdata.ts_clk = 16000;
+	m88ds3103_pdata.ts_clk_pol = 0;
+	m88ds3103_pdata.spec_inv = 0;
+	m88ds3103_pdata.agc = 0x99;
+	m88ds3103_pdata.agc_inv = 0;
+	m88ds3103_pdata.clk_out = M88DS3103_CLOCK_OUT_ENABLED;
+	m88ds3103_pdata.envelope_mode = 0;
+	m88ds3103_pdata.lnb_hv_pol = 1;
+	m88ds3103_pdata.lnb_en_pol = 0;
+	memset(&board_info, 0, sizeof(board_info));
+	strlcpy(board_info.type, "m88ds3103", I2C_NAME_SIZE);
+	board_info.addr = 0x68;
+	board_info.platform_data = &m88ds3103_pdata;
+	request_module("m88ds3103");
+	client = i2c_new_device(&d->i2c_adap, &board_info);
+	if (client == NULL || client->dev.driver == NULL)
 		return -ENODEV;
+	if (!try_module_get(client->dev.driver->owner)) {
+		i2c_unregister_device(client);
+		return -ENODEV;
+	}
+	adap->fe_adap[0].fe = m88ds3103_pdata.get_dvb_frontend(client);
+	i2c_adapter = m88ds3103_pdata.get_i2c_adapter(client);
+
+	state->i2c_client_demod = client;
 
 	/* attach tuner */
 	ts2020_config.fe = adap->fe_adap[0].fe;
-	strlcpy(info.type, "ts2022", I2C_NAME_SIZE);
-	info.addr = 0x60;
-	info.platform_data = &ts2020_config;
+	memset(&board_info, 0, sizeof(board_info));
+	strlcpy(board_info.type, "ts2022", I2C_NAME_SIZE);
+	board_info.addr = 0x60;
+	board_info.platform_data = &ts2020_config;
 	request_module("ts2020");
-	client = i2c_new_device(i2c_adapter, &info);
+	client = i2c_new_device(i2c_adapter, &board_info);
 
 	if (client == NULL || client->dev.driver == NULL) {
 		dvb_frontend_detach(adap->fe_adap[0].fe);
@@ -2350,6 +2358,13 @@ static void dw2102_disconnect(struct usb_interface *intf)
 		i2c_unregister_device(client);
 	}
 
+	/* remove I2C client for demodulator */
+	client = st->i2c_client_demod;
+	if (client) {
+		module_put(client->dev.driver->owner);
+		i2c_unregister_device(client);
+	}
+
 	dvb_usb_device_exit(intf);
 }
 
-- 
1.9.1

