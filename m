Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3.tech.numericable.fr ([82.216.111.39]:47745 "EHLO
	smtp3.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128Ab0EGHJX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 May 2010 03:09:23 -0400
Received: from ibiza.bxl.tuxicoman.be (cable-85.28.107.20.coditel.net [85.28.107.20])
	by smtp3.tech.numericable.fr (Postfix) with ESMTP id 480383E413
	for <linux-media@vger.kernel.org>; Fri,  7 May 2010 09:09:20 +0200 (CEST)
Received: from [172.22.0.10] (helo=zombie)
	by ibiza.bxl.tuxicoman.be with esmtps (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.71)
	(envelope-from <gmsoft@tuxicoman.be>)
	id 1OAHgT-0004zZ-FI
	for linux-media@vger.kernel.org; Fri, 07 May 2010 09:09:20 +0200
Date: Fri, 7 May 2010 09:09:25 +0200
From: Guy Martin <gmsoft@tuxicoman.be>
To: linux-media@vger.kernel.org
Subject: [PATCH] TT CT-3650 DVB-C support
Message-ID: <20100507090925.52f6f093@zombie>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/J91zN=A5yIQF.m7bqm7gO_D"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--MP_/J91zN=A5yIQF.m7bqm7gO_D
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


Hi linux-media,


Add support for the DVB-C frontend of the TT CT-3650.
DVB-T fe, CI and IR are not implemented.

Signed-off-by: Guy Martin <gmsoft@tuxicoman.be>


Regards,
  Guy
--MP_/J91zN=A5yIQF.m7bqm7gO_D
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=ct-3650-dvbc.patch

diff -r 4a8d6d981f07 linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
--- a/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	Wed May 05 11:58:44 2010 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	Fri May 07 08:40:10 2010 +0200
@@ -198,6 +198,7 @@
 #define USB_PID_AVERMEDIA_A850				0x850a
 #define USB_PID_AVERMEDIA_A805				0xa805
 #define USB_PID_TECHNOTREND_CONNECT_S2400               0x3006
+#define USB_PID_TECHNOTREND_CONNECT_CT3650		0x300d
 #define USB_PID_TERRATEC_CINERGY_DT_XS_DIVERSITY	0x005a
 #define USB_PID_TERRATEC_CINERGY_DT_XS_DIVERSITY_2	0x0081
 #define USB_PID_TERRATEC_CINERGY_HT_USB_XE		0x0058
diff -r 4a8d6d981f07 linux/drivers/media/dvb/dvb-usb/ttusb2.c
--- a/linux/drivers/media/dvb/dvb-usb/ttusb2.c	Wed May 05 11:58:44 2010 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/ttusb2.c	Fri May 07 08:40:10 2010 +0200
@@ -29,6 +29,8 @@
 
 #include "tda826x.h"
 #include "tda10086.h"
+#include "tda1002x.h"
+#include "tda827x.h"
 #include "lnbp21.h"
 
 /* debug */
@@ -159,7 +161,17 @@
 	.xtal_freq = TDA10086_XTAL_16M,
 };
 
-static int ttusb2_frontend_attach(struct dvb_usb_adapter *adap)
+static struct tda10023_config tda10023_config = {
+	.demod_address = 0x0c,
+	.invert = 0,
+	.xtal = 16000000,
+	.pll_m = 11,
+	.pll_p = 3,
+	.pll_n = 1,
+	.deltaf = 0xa511,
+};
+
+static int ttusb2_frontend_tda10086_attach(struct dvb_usb_adapter *adap)
 {
 	if (usb_set_interface(adap->dev->udev,0,3) < 0)
 		err("set interface to alts=3 failed");
@@ -172,7 +184,27 @@
 	return 0;
 }
 
-static int ttusb2_tuner_attach(struct dvb_usb_adapter *adap)
+static int ttusb2_frontend_tda10023_attach(struct dvb_usb_adapter *adap)
+{
+	if (usb_set_interface(adap->dev->udev,0,3) < 0)
+		err("set interface to alts=3 failed");
+	if ((adap->fe = dvb_attach(tda10023_attach, &tda10023_config, &adap->dev->i2c_adap, 0x48)) == NULL) {
+		deb_info("TDA10023 attach failed\n");
+		return -ENODEV;
+	}
+	return 0;
+}
+
+static int ttusb2_tuner_tda827x_attach(struct dvb_usb_adapter *adap) {
+
+	if (dvb_attach(tda827x_attach, adap->fe, 0x61, &adap->dev->i2c_adap, NULL) == NULL) {
+		printk(KERN_ERR "%s: No tda827x found!\n", __func__);
+		return -ENODEV;
+	}
+	return 0;
+}
+
+static int ttusb2_tuner_tda826x_attach(struct dvb_usb_adapter *adap)
 {
 	if (dvb_attach(tda826x_attach, adap->fe, 0x60, &adap->dev->i2c_adap, 0) == NULL) {
 		deb_info("TDA8263 attach failed\n");
@@ -189,6 +221,7 @@
 /* DVB USB Driver stuff */
 static struct dvb_usb_device_properties ttusb2_properties;
 static struct dvb_usb_device_properties ttusb2_properties_s2400;
+static struct dvb_usb_device_properties ttusb2_properties_ct3650;
 
 static int ttusb2_probe(struct usb_interface *intf,
 		const struct usb_device_id *id)
@@ -196,6 +229,8 @@
 	if (0 == dvb_usb_device_init(intf, &ttusb2_properties,
 				     THIS_MODULE, NULL, adapter_nr) ||
 	    0 == dvb_usb_device_init(intf, &ttusb2_properties_s2400,
+				     THIS_MODULE, NULL, adapter_nr) ||
+	    0 == dvb_usb_device_init(intf, &ttusb2_properties_ct3650,
 				     THIS_MODULE, NULL, adapter_nr))
 		return 0;
 	return -ENODEV;
@@ -206,6 +241,8 @@
 	{ USB_DEVICE(USB_VID_PINNACLE, USB_PID_PCTV_450E) },
 	{ USB_DEVICE(USB_VID_TECHNOTREND,
 		USB_PID_TECHNOTREND_CONNECT_S2400) },
+	{ USB_DEVICE(USB_VID_TECHNOTREND,
+		USB_PID_TECHNOTREND_CONNECT_CT3650) },
 	{}		/* Terminating entry */
 };
 MODULE_DEVICE_TABLE (usb, ttusb2_table);
@@ -223,8 +260,8 @@
 		{
 			.streaming_ctrl   = NULL, // ttusb2_streaming_ctrl,
 
-			.frontend_attach  = ttusb2_frontend_attach,
-			.tuner_attach     = ttusb2_tuner_attach,
+			.frontend_attach  = ttusb2_frontend_tda10086_attach,
+			.tuner_attach     = ttusb2_tuner_tda826x_attach,
 
 			/* parameter for the MPEG2-data transfer */
 			.stream = {
@@ -275,8 +312,8 @@
 		{
 			.streaming_ctrl   = NULL,
 
-			.frontend_attach  = ttusb2_frontend_attach,
-			.tuner_attach     = ttusb2_tuner_attach,
+			.frontend_attach  = ttusb2_frontend_tda10086_attach,
+			.tuner_attach     = ttusb2_tuner_tda826x_attach,
 
 			/* parameter for the MPEG2-data transfer */
 			.stream = {
@@ -310,6 +347,52 @@
 	}
 };
 
+static struct dvb_usb_device_properties ttusb2_properties_ct3650 = {
+	.caps = DVB_USB_IS_AN_I2C_ADAPTER,
+
+	.usb_ctrl = CYPRESS_FX2,
+
+	.size_of_priv = sizeof(struct ttusb2_state),
+
+	.num_adapters = 1,
+	.adapter = {
+		{
+			.streaming_ctrl   = NULL,
+
+			.frontend_attach  = ttusb2_frontend_tda10023_attach,
+			.tuner_attach = ttusb2_tuner_tda827x_attach,
+
+			/* parameter for the MPEG2-data transfer */
+			.stream = {
+				.type = USB_ISOC,
+				.count = 5,
+				.endpoint = 0x02,
+				.u = {
+					.isoc = {
+						.framesperurb = 4,
+						.framesize = 940,
+						.interval = 1,
+					}
+				}
+			}
+		},
+	},
+
+	.power_ctrl       = ttusb2_power_ctrl,
+	.identify_state   = ttusb2_identify_state,
+
+	.i2c_algo         = &ttusb2_i2c_algo,
+
+	.generic_bulk_ctrl_endpoint = 0x01,
+
+	.num_device_descs = 1,
+	.devices = {
+		{   "Technotrend TT-connect CT-3650",
+			.warm_ids = { &ttusb2_table[3], NULL }, 
+		},
+	}
+};
+
 static struct usb_driver ttusb2_driver = {
 	.name		= "dvb_usb_ttusb2",
 	.probe		= ttusb2_probe,

--MP_/J91zN=A5yIQF.m7bqm7gO_D--
