Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:35495 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932398AbbCPRO7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2015 13:14:59 -0400
Received: by labjg1 with SMTP id jg1so45792223lab.2
        for <linux-media@vger.kernel.org>; Mon, 16 Mar 2015 10:14:58 -0700 (PDT)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH 3/3] dw2102: TechnoTrend TT-connect S2-4600 DVB-S/S2 tuner
Date: Mon, 16 Mar 2015 19:14:06 +0200
Message-Id: <1426526046-2063-3-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1426526046-2063-1-git-send-email-olli.salonen@iki.fi>
References: <1426526046-2063-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

TechnoTrend TT-connect S2-4600 is a USB2.0 DVB-S/S2 tuner using the popular Montage 
M88DS3103/M88TS2022 demod/tuner.

The demodulator needs a firmware. Antti posted a firmware when releasing support for PCTV 
461e, available here: http://palosaari.fi/linux/v4l-dvb/firmware/M88DS3103/

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/dvb-core/dvb-usb-ids.h |   1 +
 drivers/media/usb/dvb-usb/Kconfig    |   6 +-
 drivers/media/usb/dvb-usb/dw2102.c   | 160 ++++++++++++++++++++++++++++++++++-
 3 files changed, 163 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-core/dvb-usb-ids.h b/drivers/media/dvb-core/dvb-usb-ids.h
index 80ab8d0..c6de073 100644
--- a/drivers/media/dvb-core/dvb-usb-ids.h
+++ b/drivers/media/dvb-core/dvb-usb-ids.h
@@ -245,6 +245,7 @@
 #define USB_PID_TECHNOTREND_CONNECT_S2400               0x3006
 #define USB_PID_TECHNOTREND_CONNECT_S2400_8KEEPROM	0x3009
 #define USB_PID_TECHNOTREND_CONNECT_CT3650		0x300d
+#define USB_PID_TECHNOTREND_CONNECT_S2_4600             0x3011
 #define USB_PID_TECHNOTREND_CONNECT_CT2_4650_CI		0x3012
 #define USB_PID_TECHNOTREND_TVSTICK_CT2_4400		0x3014
 #define USB_PID_TERRATEC_CINERGY_DT_XS_DIVERSITY	0x005a
diff --git a/drivers/media/usb/dvb-usb/Kconfig b/drivers/media/usb/dvb-usb/Kconfig
index 3364200..def1e06 100644
--- a/drivers/media/usb/dvb-usb/Kconfig
+++ b/drivers/media/usb/dvb-usb/Kconfig
@@ -278,9 +278,11 @@ config DVB_USB_DW2102
 	select DVB_STV6110 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_STV0900 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_M88RS2000 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_M88DS3103 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_TS2022 if MEDIA_SUBDRV_AUTOSELECT
 	help
-	  Say Y here to support the DvbWorld, TeVii, Prof DVB-S/S2 USB2.0
-	  receivers.
+	  Say Y here to support the DvbWorld, TeVii, Prof, TechnoTrend
+	  DVB-S/S2 USB2.0 receivers.
 
 config DVB_USB_CINERGY_T2
 	tristate "Terratec CinergyT2/qanu USB 2.0 DVB-T receiver"
diff --git a/drivers/media/usb/dvb-usb/dw2102.c b/drivers/media/usb/dvb-usb/dw2102.c
index f7dd973..1f0fdad 100644
--- a/drivers/media/usb/dvb-usb/dw2102.c
+++ b/drivers/media/usb/dvb-usb/dw2102.c
@@ -2,7 +2,8 @@
  *	DVBWorld DVB-S 2101, 2102, DVB-S2 2104, DVB-C 3101,
  *	TeVii S600, S630, S650, S660, S480, S421, S632
  *	Prof 1100, 7500,
- *	Geniatech SU3000, T220 Cards
+ *	Geniatech SU3000, T220,
+ *	TechnoTrend S2-4600 Cards
  * Copyright (C) 2008-2012 Igor M. Liplianin (liplianin@me.by)
  *
  *	This program is free software; you can redistribute it and/or modify it
@@ -31,6 +32,8 @@
 #include "m88rs2000.h"
 #include "tda18271.h"
 #include "cxd2820r.h"
+#include "m88ds3103.h"
+#include "m88ts2022.h"
 
 /* Max transfer size done by I2C transfer functions */
 #define MAX_XFER_SIZE  64
@@ -1115,6 +1118,22 @@ static struct tda18271_config tda18271_config = {
 	.gate = TDA18271_GATE_DIGITAL,
 };
 
+static const struct m88ds3103_config tt_s2_4600_m88ds3103_config = {
+	.i2c_addr = 0x68,
+	.clock = 27000000,
+	.i2c_wr_max = 33,
+	.ts_mode = M88DS3103_TS_CI,
+	.ts_clk = 16000,
+	.ts_clk_pol = 0,
+	.spec_inv = 0,
+	.agc_inv = 0,
+	.clock_out = M88DS3103_CLOCK_OUT_ENABLED,
+	.envelope_mode = 0,
+	.agc = 0x99,
+	.lnb_hv_pol = 1,
+	.lnb_en_pol = 0,
+};
+
 static u8 m88rs2000_inittab[] = {
 	DEMOD_WRITE, 0x9a, 0x30,
 	DEMOD_WRITE, 0x00, 0x01,
@@ -1459,6 +1478,88 @@ static int m88rs2000_frontend_attach(struct dvb_usb_adapter *d)
 	return -EIO;
 }
 
+static int tt_s2_4600_frontend_attach(struct dvb_usb_adapter *adap)
+{
+	struct dvb_usb_device *d = adap->dev;
+	struct dw2102_state *state = d->priv;
+	u8 obuf[3] = { 0xe, 0x80, 0 };
+	u8 ibuf[] = { 0 };
+	struct i2c_adapter *i2c_adapter;
+	struct i2c_client *client;
+	struct i2c_board_info info;
+	struct m88ts2022_config m88ts2022_config = {
+		.clock = 27000000,
+	};
+
+	if (dvb_usb_generic_rw(d, obuf, 3, ibuf, 1, 0) < 0)
+		err("command 0x0e transfer failed.");
+
+	obuf[0] = 0xe;
+	obuf[1] = 0x02;
+	obuf[2] = 1;
+
+	if (dvb_usb_generic_rw(d, obuf, 3, ibuf, 1, 0) < 0)
+		err("command 0x0e transfer failed.");
+	msleep(300);
+
+	obuf[0] = 0xe;
+	obuf[1] = 0x83;
+	obuf[2] = 0;
+
+	if (dvb_usb_generic_rw(d, obuf, 3, ibuf, 1, 0) < 0)
+		err("command 0x0e transfer failed.");
+
+	obuf[0] = 0xe;
+	obuf[1] = 0x83;
+	obuf[2] = 1;
+
+	if (dvb_usb_generic_rw(d, obuf, 3, ibuf, 1, 0) < 0)
+		err("command 0x0e transfer failed.");
+
+	obuf[0] = 0x51;
+
+	if (dvb_usb_generic_rw(d, obuf, 1, ibuf, 1, 0) < 0)
+		err("command 0x51 transfer failed.");
+
+	memset(&info, 0, sizeof(struct i2c_board_info));
+
+	adap->fe_adap[0].fe = dvb_attach(m88ds3103_attach,
+					&tt_s2_4600_m88ds3103_config,
+					&d->i2c_adap,
+					&i2c_adapter);
+	if (adap->fe_adap[0].fe == NULL)
+		return -ENODEV;
+
+	/* attach tuner */
+	m88ts2022_config.fe = adap->fe_adap[0].fe;
+	strlcpy(info.type, "m88ts2022", I2C_NAME_SIZE);
+	info.addr = 0x60;
+	info.platform_data = &m88ts2022_config;
+	request_module("m88ts2022");
+	client = i2c_new_device(i2c_adapter, &info);
+
+	info("tuner attached\n");
+
+	if (client == NULL || client->dev.driver == NULL) {
+		dvb_frontend_detach(adap->fe_adap[0].fe);
+		return -ENODEV;
+	}
+
+	if (!try_module_get(client->dev.driver->owner)) {
+		i2c_unregister_device(client);
+		dvb_frontend_detach(adap->fe_adap[0].fe);
+		return -ENODEV;
+	}
+
+	/* delegate signal strength measurement to tuner */
+	adap->fe_adap[0].fe->ops.read_signal_strength =
+			adap->fe_adap[0].fe->ops.tuner_ops.get_rf_strength;
+
+	state->i2c_client_tuner = client;
+
+	return 0;
+}
+
 static int dw2102_tuner_attach(struct dvb_usb_adapter *adap)
 {
 	dvb_attach(dvb_pll_attach, adap->fe_adap[0].fe, 0x60,
@@ -1559,6 +1660,7 @@ enum dw2102_table_entry {
 	TERRATEC_CINERGY_S2_R2,
 	GOTVIEW_SAT_HD,
 	GENIATECH_T220,
+	TECHNOTREND_S2_4600,
 };
 
 static struct usb_device_id dw2102_table[] = {
@@ -1582,6 +1684,8 @@ static struct usb_device_id dw2102_table[] = {
 	[TERRATEC_CINERGY_S2_R2] = {USB_DEVICE(USB_VID_TERRATEC, 0x00b0)},
 	[GOTVIEW_SAT_HD] = {USB_DEVICE(0x1FE1, USB_PID_GOTVIEW_SAT_HD)},
 	[GENIATECH_T220] = {USB_DEVICE(0x1f4d, 0xD220)},
+	[TECHNOTREND_S2_4600] = {USB_DEVICE(USB_VID_TECHNOTREND,
+		USB_PID_TECHNOTREND_CONNECT_S2_4600)},
 	{ }
 };
 
@@ -2059,6 +2163,55 @@ static struct dvb_usb_device_properties t220_properties = {
 	}
 };
 
+static struct dvb_usb_device_properties tt_s2_4600_properties = {
+	.caps = DVB_USB_IS_AN_I2C_ADAPTER,
+	.usb_ctrl = DEVICE_SPECIFIC,
+	.size_of_priv = sizeof(struct dw2102_state),
+	.power_ctrl = su3000_power_ctrl,
+	.num_adapters = 1,
+	.identify_state	= su3000_identify_state,
+	.i2c_algo = &su3000_i2c_algo,
+
+	.rc.core = {
+		.rc_interval = 250,
+		.rc_codes = RC_MAP_TT_1500,
+		.module_name = "dw2102",
+		.allowed_protos   = RC_BIT_RC5,
+		.rc_query = su3000_rc_query,
+	},
+
+	.read_mac_address = su3000_read_mac_address,
+
+	.generic_bulk_ctrl_endpoint = 0x01,
+
+	.adapter = {
+		{
+		.num_frontends = 1,
+		.fe = {{
+			.streaming_ctrl   = su3000_streaming_ctrl,
+			.frontend_attach  = tt_s2_4600_frontend_attach,
+			.stream = {
+				.type = USB_BULK,
+				.count = 8,
+				.endpoint = 0x82,
+				.u = {
+					.bulk = {
+						.buffersize = 4096,
+					}
+				}
+			}
+		} },
+		}
+	},
+	.num_device_descs = 1,
+	.devices = {
+		{ "TechnoTrend TT-connect S2-4600",
+			{ &dw2102_table[TECHNOTREND_S2_4600], NULL },
+			{ NULL },
+		},
+	}
+};
+
 static int dw2102_probe(struct usb_interface *intf,
 		const struct usb_device_id *id)
 {
@@ -2133,6 +2286,8 @@ static int dw2102_probe(struct usb_interface *intf,
 	    0 == dvb_usb_device_init(intf, &su3000_properties,
 			 THIS_MODULE, NULL, adapter_nr) ||
 	    0 == dvb_usb_device_init(intf, &t220_properties,
+			 THIS_MODULE, NULL, adapter_nr) ||
+	    0 == dvb_usb_device_init(intf, &tt_s2_4600_properties,
 			 THIS_MODULE, NULL, adapter_nr))
 		return 0;
 
@@ -2169,7 +2324,8 @@ MODULE_DESCRIPTION("Driver for DVBWorld DVB-S 2101, 2102, DVB-S2 2104,"
 			" DVB-C 3101 USB2.0,"
 			" TeVii S600, S630, S650, S660, S480, S421, S632"
 			" Prof 1100, 7500 USB2.0,"
-			" Geniatech SU3000, T220 devices");
+			" Geniatech SU3000, T220,"
+			" TechnoTrend S2-4600 devices");
 MODULE_VERSION("0.1");
 MODULE_LICENSE("GPL");
 MODULE_FIRMWARE(DW2101_FIRMWARE);
-- 
1.9.1

