Return-path: <linux-media-owner@vger.kernel.org>
Received: from forward18.mail.yandex.net ([95.108.253.143]:36073 "EHLO
	forward18.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408Ab3KMXyH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Nov 2013 18:54:07 -0500
Received: from smtp18.mail.yandex.net (smtp18.mail.yandex.net [95.108.252.18])
	by forward18.mail.yandex.net (Yandex) with ESMTP id 85D361783405
	for <linux-media@vger.kernel.org>; Thu, 14 Nov 2013 03:54:04 +0400 (MSK)
Received: from smtp18.mail.yandex.net (localhost [127.0.0.1])
	by smtp18.mail.yandex.net (Yandex) with ESMTP id 667C918A01D5
	for <linux-media@vger.kernel.org>; Thu, 14 Nov 2013 03:54:04 +0400 (MSK)
From: CrazyCat <crazycat69@narod.ru>
To: linux-media@vger.kernel.org
Subject: [PATCH] dw2102: Geniatech T220 support
Date: Thu, 14 Nov 2013 01:53:59 +0200
Message-ID: <1526625.9agmioiQj8@ubuntu>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Support for Geniatech T220 DVB-T/T2/C USB stick.

Signed-off-by: Evgeny Plehov <EvgenyPlehov@ukr.net>
---
diff --git a/drivers/media/usb/dvb-usb/dw2102.c b/drivers/media/usb/dvb-usb/dw2102.c
index 6136a2c..12e00aa 100644
--- a/drivers/media/usb/dvb-usb/dw2102.c
+++ b/drivers/media/usb/dvb-usb/dw2102.c
@@ -2,7 +2,7 @@
  *	DVBWorld DVB-S 2101, 2102, DVB-S2 2104, DVB-C 3101,
  *	TeVii S600, S630, S650, S660, S480, S421, S632
  *	Prof 1100, 7500,
- *	Geniatech SU3000 Cards
+ *	Geniatech SU3000, T220 Cards
  * Copyright (C) 2008-2012 Igor M. Liplianin (liplianin@me.by)
  *
  *	This program is free software; you can redistribute it and/or modify it
@@ -29,6 +29,8 @@
 #include "stb6100.h"
 #include "stb6100_proc.h"
 #include "m88rs2000.h"
+#include "tda18271.h"
+#include "cxd2820r.h"
 
 #ifndef USB_PID_DW2102
 #define USB_PID_DW2102 0x2102
@@ -1025,6 +1027,16 @@ static struct ds3000_config su3000_ds3000_config = {
 	.set_lock_led = dw210x_led_ctrl,
 };
 
+static struct cxd2820r_config cxd2820r_config = {
+	.i2c_address = 0x6c, /* (0xd8 >> 1) */
+	.ts_mode = 0x38,
+};
+
+static struct tda18271_config tda18271_config = {
+	.output_opt = TDA18271_OUTPUT_LT_OFF,
+	.gate = TDA18271_GATE_DIGITAL,
+};
+
 static u8 m88rs2000_inittab[] = {
 	DEMOD_WRITE, 0x9a, 0x30,
 	DEMOD_WRITE, 0x00, 0x01,
@@ -1294,6 +1306,49 @@ static int su3000_frontend_attach(struct dvb_usb_adapter *d)
 	return -EIO;
 }
 
+static int t220_frontend_attach(struct dvb_usb_adapter *d)
+{
+	u8 obuf[3] = { 0xe, 0x80, 0 };
+	u8 ibuf[] = { 0 };
+
+	if (dvb_usb_generic_rw(d->dev, obuf, 3, ibuf, 1, 0) < 0)
+		err("command 0x0e transfer failed.");
+
+	obuf[0] = 0xe;
+	obuf[1] = 0x83;
+	obuf[2] = 0;
+
+	if (dvb_usb_generic_rw(d->dev, obuf, 3, ibuf, 1, 0) < 0)
+		err("command 0x0e transfer failed.");
+
+	msleep(100);
+
+	obuf[0] = 0xe;
+	obuf[1] = 0x80;
+	obuf[2] = 1;
+
+	if (dvb_usb_generic_rw(d->dev, obuf, 3, ibuf, 1, 0) < 0)
+		err("command 0x0e transfer failed.");
+
+	obuf[0] = 0x51;
+
+	if (dvb_usb_generic_rw(d->dev, obuf, 1, ibuf, 1, 0) < 0)
+		err("command 0x51 transfer failed.");
+
+	d->fe_adap[0].fe = dvb_attach(cxd2820r_attach, &cxd2820r_config,
+					&d->dev->i2c_adap, NULL);
+	if (d->fe_adap[0].fe != NULL) {
+		if (dvb_attach(tda18271_attach, d->fe_adap[0].fe, 0x60,
+					&d->dev->i2c_adap, &tda18271_config)) {
+			info("Attached TDA18271HD/CXD2820R!\n");
+			return 0;
+		}
+	}
+
+	info("Failed to attach TDA18271HD/CXD2820R!\n");
+	return -EIO;
+}
+
 static int m88rs2000_frontend_attach(struct dvb_usb_adapter *d)
 {
 	u8 obuf[] = { 0x51 };
@@ -1560,6 +1615,7 @@ enum dw2102_table_entry {
 	TEVII_S632,
 	TERRATEC_CINERGY_S2_R2,
 	GOTVIEW_SAT_HD,
+	GENIATECH_T220,
 };
 
 static struct usb_device_id dw2102_table[] = {
@@ -1582,6 +1638,7 @@ static struct usb_device_id dw2102_table[] = {
 	[TEVII_S632] = {USB_DEVICE(0x9022, USB_PID_TEVII_S632)},
 	[TERRATEC_CINERGY_S2_R2] = {USB_DEVICE(USB_VID_TERRATEC, 0x00b0)},
 	[GOTVIEW_SAT_HD] = {USB_DEVICE(0x1FE1, USB_PID_GOTVIEW_SAT_HD)},
+	[GENIATECH_T220] = {USB_DEVICE(0x1f4d, 0xD220)},
 	{ }
 };
 
@@ -2007,6 +2064,54 @@ static struct dvb_usb_device_properties su3000_properties = {
 	}
 };
 
+static struct dvb_usb_device_properties t220_properties = {
+	.caps = DVB_USB_IS_AN_I2C_ADAPTER,
+	.usb_ctrl = DEVICE_SPECIFIC,
+	.size_of_priv = sizeof(struct su3000_state),
+	.power_ctrl = su3000_power_ctrl,
+	.num_adapters = 1,
+	.identify_state	= su3000_identify_state,
+	.i2c_algo = &su3000_i2c_algo,
+
+	.rc.legacy = {
+		.rc_map_table = rc_map_su3000_table,
+		.rc_map_size = ARRAY_SIZE(rc_map_su3000_table),
+		.rc_interval = 150,
+		.rc_query = dw2102_rc_query,
+	},
+
+	.read_mac_address = su3000_read_mac_address,
+
+	.generic_bulk_ctrl_endpoint = 0x01,
+
+	.adapter = {
+		{
+		.num_frontends = 1,
+		.fe = { {
+			.streaming_ctrl   = su3000_streaming_ctrl,
+			.frontend_attach  = t220_frontend_attach,
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
+		{ "Geniatech T220 DVB-T/T2 USB2.0",
+			{ &dw2102_table[GENIATECH_T220], NULL },
+			{ NULL },
+		},
+	}
+};
+
 static int dw2102_probe(struct usb_interface *intf,
 		const struct usb_device_id *id)
 {
@@ -2079,7 +2184,9 @@ static int dw2102_probe(struct usb_interface *intf,
 	    0 == dvb_usb_device_init(intf, s421,
 			THIS_MODULE, NULL, adapter_nr) ||
 	    0 == dvb_usb_device_init(intf, &su3000_properties,
-				     THIS_MODULE, NULL, adapter_nr))
+			 THIS_MODULE, NULL, adapter_nr) ||
+	    0 == dvb_usb_device_init(intf, &t220_properties,
+			 THIS_MODULE, NULL, adapter_nr))
 		return 0;
 
 	return -ENODEV;
@@ -2099,7 +2206,7 @@ MODULE_DESCRIPTION("Driver for DVBWorld DVB-S 2101, 2102, DVB-S2 2104,"
 			" DVB-C 3101 USB2.0,"
 			" TeVii S600, S630, S650, S660, S480, S421, S632"
 			" Prof 1100, 7500 USB2.0,"
-			" Geniatech SU3000 devices");
+			" Geniatech SU3000, T220 devices");
 MODULE_VERSION("0.1");
 MODULE_LICENSE("GPL");
 MODULE_FIRMWARE(DW2101_FIRMWARE);
-- 
