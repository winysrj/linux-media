Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35330 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777Ab2EHHxJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 May 2012 03:53:09 -0400
Received: by bkcji2 with SMTP id ji2so4332297bkc.19
        for <linux-media@vger.kernel.org>; Tue, 08 May 2012 00:53:08 -0700 (PDT)
From: "Igor M. Liplianin" <liplianin@me.by>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 1/2] TeVii DVB-S s421 and s632 cards support
Date: Tue, 08 May 2012 10:53:17 +0300
Message-ID: <15019844.cDzfOmpbjr@useri>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart7469677.AFJ2mplcgN"
Content-Transfer-Encoding: 7Bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--nextPart7469677.AFJ2mplcgN
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

DVB-S chip is Montage m88rs2000, so initial patch is simple.

Signed-off-by: Igor M. Liplianin <liplianin@me.by>
--nextPart7469677.AFJ2mplcgN
Content-Disposition: inline; filename="rs200dw2102.patch"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="utf-8"; name="rs200dw2102.patch"

diff --git a/drivers/media/dvb/dvb-usb/dw2102.c b/drivers/media/dvb/dvb-usb/dw2102.c
index 451c5a7..4b2d190 100644
--- a/drivers/media/dvb/dvb-usb/dw2102.c
+++ b/drivers/media/dvb/dvb-usb/dw2102.c
@@ -1,9 +1,9 @@
 /* DVB USB framework compliant Linux driver for the
  *	DVBWorld DVB-S 2101, 2102, DVB-S2 2104, DVB-C 3101,
- *	TeVii S600, S630, S650, S660, S480,
+ *	TeVii S600, S630, S650, S660, S480, S421, S632
  *	Prof 1100, 7500,
  *	Geniatech SU3000 Cards
- * Copyright (C) 2008-2011 Igor M. Liplianin (liplianin@me.by)
+ * Copyright (C) 2008-2012 Igor M. Liplianin (liplianin@me.by)
  *
  *	This program is free software; you can redistribute it and/or modify it
  *	under the terms of the GNU General Public License as published by the
@@ -27,6 +27,7 @@
 #include "stv6110.h"
 #include "stb6100.h"
 #include "stb6100_proc.h"
+#include "m88rs2000.h"
 
 #ifndef USB_PID_DW2102
 #define USB_PID_DW2102 0x2102
@@ -68,6 +69,14 @@
 #define USB_PID_PROF_1100 0xb012
 #endif
 
+#ifndef USB_PID_TEVII_S421
+#define USB_PID_TEVII_S421 0xd421
+#endif
+
+#ifndef USB_PID_TEVII_S632
+#define USB_PID_TEVII_S632 0xd632
+#endif
+
 #define DW210X_READ_MSG 0
 #define DW210X_WRITE_MSG 1
 
@@ -538,7 +547,7 @@ static int s6x0_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 		}
 		/*case 0x55: cx24116
 		case 0x6a: stv0903
-		case 0x68: ds3000, stv0903
+		case 0x68: ds3000, stv0903, rs2000
 		case 0x60: ts2020, stv6110, stb6100
 		case 0xa0: eeprom */
 		default: {
@@ -987,6 +996,38 @@ static struct ds3000_config su3000_ds3000_config = {
 	.ci_mode = 1,
 };
 
+static u8 m88rs2000_inittab[] = {
+	DEMOD_WRITE, 0x9a, 0x30,
+	DEMOD_WRITE, 0x00, 0x01,
+	WRITE_DELAY, 0x19, 0x00,
+	DEMOD_WRITE, 0x00, 0x00,
+	DEMOD_WRITE, 0x9a, 0xb0,
+	DEMOD_WRITE, 0x81, 0xc1,
+	TUNER_WRITE, 0x42, 0x73,
+	TUNER_WRITE, 0x05, 0x07,
+	TUNER_WRITE, 0x20, 0x27,
+	TUNER_WRITE, 0x07, 0x02,
+	TUNER_WRITE, 0x11, 0xff,
+	TUNER_WRITE, 0x60, 0xf9,
+	TUNER_WRITE, 0x08, 0x01,
+	TUNER_WRITE, 0x00, 0x41,
+	DEMOD_WRITE, 0x81, 0x81,
+	DEMOD_WRITE, 0x86, 0xc6,
+	DEMOD_WRITE, 0x9a, 0x30,
+	DEMOD_WRITE, 0xf0, 0x80,
+	DEMOD_WRITE, 0xf1, 0xbf,
+	DEMOD_WRITE, 0xb0, 0x45,
+	DEMOD_WRITE, 0xb2, 0x01,
+	DEMOD_WRITE, 0x9a, 0xb0,
+	0xff, 0xaa, 0xff
+};
+
+static struct m88rs2000_config s421_m88rs2000_config = {
+	.demod_addr = 0x68,
+	.tuner_addr = 0x60,
+	.inittab = m88rs2000_inittab,
+};
+
 static int dw2104_frontend_attach(struct dvb_usb_adapter *d)
 {
 	struct dvb_tuner_ops *tuner_ops = NULL;
@@ -1214,6 +1255,24 @@ static int su3000_frontend_attach(struct dvb_usb_adapter *d)
 	return 0;
 }
 
+static int m88rs2000_frontend_attach(struct dvb_usb_adapter *d)
+{
+	u8 obuf[] = { 0x51 };
+	u8 ibuf[] = { 0 };
+
+	if (dvb_usb_generic_rw(d->dev, obuf, 1, ibuf, 1, 0) < 0)
+		err("command 0x51 transfer failed.");
+
+	d->fe_adap[0].fe = dvb_attach(m88rs2000_attach, &s421_m88rs2000_config,
+					&d->dev->i2c_adap);
+	if (d->fe_adap[0].fe == NULL)
+		return -EIO;
+
+	info("Attached m88rs2000!\n");
+
+	return 0;
+}
+
 static int dw2102_tuner_attach(struct dvb_usb_adapter *adap)
 {
 	dvb_attach(dvb_pll_attach, adap->fe_adap[0].fe, 0x60,
@@ -1451,6 +1510,8 @@ enum dw2102_table_entry {
 	TEVII_S480_1,
 	TEVII_S480_2,
 	X3M_SPC1400HD,
+	TEVII_S421,
+	TEVII_S632,
 };
 
 static struct usb_device_id dw2102_table[] = {
@@ -1469,6 +1530,8 @@ static struct usb_device_id dw2102_table[] = {
 	[TEVII_S480_1] = {USB_DEVICE(0x9022, USB_PID_TEVII_S480_1)},
 	[TEVII_S480_2] = {USB_DEVICE(0x9022, USB_PID_TEVII_S480_2)},
 	[X3M_SPC1400HD] = {USB_DEVICE(0x1f4d, 0x3100)},
+	[TEVII_S421] = {USB_DEVICE(0x9022, USB_PID_TEVII_S421)},
+	[TEVII_S632] = {USB_DEVICE(0x9022, USB_PID_TEVII_S632)},
 	{ }
 };
 
@@ -1818,6 +1881,19 @@ static struct dvb_usb_device_description d7500 = {
 	{NULL},
 };
 
+struct dvb_usb_device_properties *s421;
+static struct dvb_usb_device_description d421 = {
+	"TeVii S421 PCI",
+	{&dw2102_table[TEVII_S421], NULL},
+	{NULL},
+};
+
+static struct dvb_usb_device_description d632 = {
+	"TeVii S632 USB",
+	{&dw2102_table[TEVII_S632], NULL},
+	{NULL},
+};
+
 static struct dvb_usb_device_properties su3000_properties = {
 	.caps = DVB_USB_IS_AN_I2C_ADAPTER,
 	.usb_ctrl = DEVICE_SPECIFIC,
@@ -1915,6 +1991,20 @@ static int dw2102_probe(struct usb_interface *intf,
 	p7500->rc.legacy.rc_map_size = ARRAY_SIZE(rc_map_tbs_table);
 	p7500->adapter->fe[0].frontend_attach = prof_7500_frontend_attach;
 
+
+	s421 = kmemdup(&su3000_properties,
+		       sizeof(struct dvb_usb_device_properties), GFP_KERNEL);
+	if (!s421) {
+		kfree(p1100);
+		kfree(s660);
+		kfree(p7500);
+		return -ENOMEM;
+	}
+	s421->num_device_descs = 2;
+	s421->devices[0] = d421;
+	s421->devices[1] = d632;
+	s421->adapter->fe[0].frontend_attach = m88rs2000_frontend_attach;
+
 	if (0 == dvb_usb_device_init(intf, &dw2102_properties,
 			THIS_MODULE, NULL, adapter_nr) ||
 	    0 == dvb_usb_device_init(intf, &dw2104_properties,
@@ -1929,6 +2019,8 @@ static int dw2102_probe(struct usb_interface *intf,
 			THIS_MODULE, NULL, adapter_nr) ||
 	    0 == dvb_usb_device_init(intf, p7500,
 			THIS_MODULE, NULL, adapter_nr) ||
+	    0 == dvb_usb_device_init(intf, s421,
+			THIS_MODULE, NULL, adapter_nr) ||
 	    0 == dvb_usb_device_init(intf, &su3000_properties,
 				     THIS_MODULE, NULL, adapter_nr))
 		return 0;
@@ -1947,9 +2039,9 @@ module_usb_driver(dw2102_driver);
 
 MODULE_AUTHOR("Igor M. Liplianin (c) liplianin@me.by");
 MODULE_DESCRIPTION("Driver for DVBWorld DVB-S 2101, 2102, DVB-S2 2104,"
-				" DVB-C 3101 USB2.0,"
-				" TeVii S600, S630, S650, S660, S480,"
-				" Prof 1100, 7500 USB2.0,"
-				" Geniatech SU3000 devices");
+			" DVB-C 3101 USB2.0,"
+			" TeVii S600, S630, S650, S660, S480, S421, S632"
+			" Prof 1100, 7500 USB2.0,"
+			" Geniatech SU3000 devices");
 MODULE_VERSION("0.1");
 MODULE_LICENSE("GPL");
--nextPart7469677.AFJ2mplcgN--

