Return-path: <linux-media-owner@vger.kernel.org>
Received: from fb2.tech.numericable.fr ([82.216.111.50]:39511 "EHLO
	fb2.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754642AbZKIMU1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Nov 2009 07:20:27 -0500
Received: from smtp6.tech.numericable.fr (smtp6.nc.sdv.fr [10.0.0.83])
	by fb2.tech.numericable.fr (Postfix) with ESMTP id 671751B9EC8
	for <linux-media@vger.kernel.org>; Mon,  9 Nov 2009 13:10:26 +0100 (CET)
Date: Mon, 9 Nov 2009 13:09:04 +0100
From: Guy Martin <gmsoft@tuxicoman.be>
To: linux-media@vger.kernel.org
Cc: abos@hanno.de, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] What is the status of the driver TT CT-3650
Message-ID: <20091109130904.6c46e405@borg.bxl.tuxicoman.be>
In-Reply-To: <4AF7F51B.5070501@hanno.de>
References: <87fxa2uurr.fsf@musikcheck.dk>
	<4AF7F51B.5070501@hanno.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/a9JcR/ua63hUPl/xRK/4TZ6"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--MP_/a9JcR/ua63hUPl/xRK/4TZ6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


Hanno,

I've been working on having the CT-3650 supported however I didn't go
very farther than having the dvb-c frontend to work. Nothing else
works : no CI, no DVB-T, no IR.

I've attached a patch which is working for me. Again, only the dvb-c
interface works. Also this patch should definitely not go upstream.
The cold firmware should not be used but it's there because I erased
the eeprom of my card by mistake.

I'm still planning to have a better support for this card but I
unfortunately have other things to work on before.

HTH,
  Guy


On Mon, 09 Nov 2009 11:55:23 +0100
Hanno Zulla <abos@hanno.de> wrote:

> Hi,
> 
> > Anyone know how to get this working or this card is in a working
> > state under linux. Because if it not working yet I will stop
> > wasting my time
> 
> Second that request. Is anybody working on a driver for this device?
> Is it worth waiting?
> 
> Technotrend DVB products have been good for me in the past and this
> combination of DVB-C with CI is something well suited for my next vdr
> hardware setup.
> 
> Thanks,
> 
> Hanno
> 


--MP_/a9JcR/ua63hUPl/xRK/4TZ6
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=ct3650-dvbc.patch

diff -r 6f58a5d8c7c6 linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
--- a/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	Sat Aug 29 09:01:54 2009 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	Sat Nov 07 12:27:27 2009 +0100
@@ -61,7 +61,7 @@
 #define USB_VID_HUMAX_COEX			0x10b9
 
 /* Product IDs */
-#define USB_PID_ADSTECH_USB2_COLD			0xa333
+//#define USB_PID_ADSTECH_USB2_COLD			0xa333
 #define USB_PID_ADSTECH_USB2_WARM			0xa334
 #define USB_PID_AFATECH_AF9005				0x9020
 #define USB_PID_AFATECH_AF9015_9015			0x9015
@@ -178,6 +178,7 @@
 #define USB_PID_AVERMEDIA_A850				0x850a
 #define USB_PID_AVERMEDIA_A805				0xa805
 #define USB_PID_TECHNOTREND_CONNECT_S2400               0x3006
+#define USB_PID_TECHNOTREND_CONNECT_CT3650		0x300d
 #define USB_PID_TERRATEC_CINERGY_DT_XS_DIVERSITY	0x005a
 #define USB_PID_TERRATEC_CINERGY_DT_XS_DIVERSITY_2	0x0081
 #define USB_PID_TERRATEC_CINERGY_HT_USB_XE		0x0058
diff -r 6f58a5d8c7c6 linux/drivers/media/dvb/dvb-usb/ttusb2.c
--- a/linux/drivers/media/dvb/dvb-usb/ttusb2.c	Sat Aug 29 09:01:54 2009 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/ttusb2.c	Sat Nov 07 12:27:27 2009 +0100
@@ -29,6 +29,9 @@
 
 #include "tda826x.h"
 #include "tda10086.h"
+#include "tda1002x.h"
+#include "tda827x.h"
+#include "tda10048.h"
 #include "lnbp21.h"
 
 /* debug */
@@ -159,7 +162,34 @@
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
+static struct tda10048_config tda10048_config = {
+	.demod_address  = 0x8,
+	.output_mode    = TDA10048_SERIAL_OUTPUT,
+	.fwbulkwritelen = TDA10048_BULKWRITE_50,
+	.inversion      = TDA10048_INVERSION_ON,
+	.dtv6_if_freq_khz = TDA10048_IF_3300,
+	.dtv7_if_freq_khz = TDA10048_IF_3800,
+	.dtv8_if_freq_khz = TDA10048_IF_4300,
+	.clk_freq_khz	= TDA10048_CLK_16000,
+	.disable_gate_access = 1,
+};
+
+static struct tda827x_config tda827x_config = {
+	.config = 0,
+//	.switch_addr = 0x4b,
+};
+
+static int ttusb2_frontend_tda10086_attach(struct dvb_usb_adapter *adap)
 {
 	if (usb_set_interface(adap->dev->udev,0,3) < 0)
 		err("set interface to alts=3 failed");
@@ -172,7 +202,40 @@
 	return 0;
 }
 
-static int ttusb2_tuner_attach(struct dvb_usb_adapter *adap)
+static int ttusb2_frontend_tda10048_attach(struct dvb_usb_adapter *adap)
+{
+	if (usb_set_interface(adap->dev->udev,0,3) < 0)
+		err("set interface to alts=3 failed");
+
+	if ((adap->fe = dvb_attach(tda10048_attach, &tda10048_config, &adap->dev->i2c_adap)) == NULL) {
+		deb_info("TDA10048 attach failed\n");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
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
+	if (dvb_attach(tda827x_attach, adap->fe, 0x60, &adap->dev->i2c_adap, &tda827x_config) == NULL) {
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
@@ -189,6 +252,7 @@
 /* DVB USB Driver stuff */
 static struct dvb_usb_device_properties ttusb2_properties;
 static struct dvb_usb_device_properties ttusb2_properties_s2400;
+static struct dvb_usb_device_properties ttusb2_properties_ct3650;
 
 static int ttusb2_probe(struct usb_interface *intf,
 		const struct usb_device_id *id)
@@ -196,6 +260,8 @@
 	if (0 == dvb_usb_device_init(intf, &ttusb2_properties,
 				     THIS_MODULE, NULL, adapter_nr) ||
 	    0 == dvb_usb_device_init(intf, &ttusb2_properties_s2400,
+				     THIS_MODULE, NULL, adapter_nr) ||
+	    0 == dvb_usb_device_init(intf, &ttusb2_properties_ct3650,
 				     THIS_MODULE, NULL, adapter_nr))
 		return 0;
 	return -ENODEV;
@@ -206,6 +272,9 @@
 	{ USB_DEVICE(USB_VID_PINNACLE, USB_PID_PCTV_450E) },
 	{ USB_DEVICE(USB_VID_TECHNOTREND,
 		USB_PID_TECHNOTREND_CONNECT_S2400) },
+	{ USB_DEVICE(USB_VID_TECHNOTREND,
+		USB_PID_TECHNOTREND_CONNECT_CT3650) },
+	{ USB_DEVICE(0x04b4, 0x8613) },
 	{}		/* Terminating entry */
 };
 MODULE_DEVICE_TABLE (usb, ttusb2_table);
@@ -223,8 +292,8 @@
 		{
 			.streaming_ctrl   = NULL, // ttusb2_streaming_ctrl,
 
-			.frontend_attach  = ttusb2_frontend_attach,
-			.tuner_attach     = ttusb2_tuner_attach,
+			.frontend_attach  = ttusb2_frontend_tda10086_attach,
+			.tuner_attach     = ttusb2_tuner_tda826x_attach,
 
 			/* parameter for the MPEG2-data transfer */
 			.stream = {
@@ -275,8 +344,8 @@
 		{
 			.streaming_ctrl   = NULL,
 
-			.frontend_attach  = ttusb2_frontend_attach,
-			.tuner_attach     = ttusb2_tuner_attach,
+			.frontend_attach  = ttusb2_frontend_tda10086_attach,
+			.tuner_attach     = ttusb2_tuner_tda826x_attach,
 
 			/* parameter for the MPEG2-data transfer */
 			.stream = {
@@ -310,6 +379,72 @@
 	}
 };
 
+static struct dvb_usb_device_properties ttusb2_properties_ct3650 = {
+	.caps = DVB_USB_IS_AN_I2C_ADAPTER,
+
+	.usb_ctrl = CYPRESS_FX2,
+	.firmware = "dvb-usb-tt-ct3650-01.fw",
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
+/*		{
+			.streaming_ctrl   = NULL,
+
+			.frontend_attach  = ttusb2_frontend_tda10048_attach,
+			.tuner_attach = ttusb2_tuner_tda827x_attach,
+
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
+		},*/
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
+			.cold_ids = { &ttusb2_table[4], NULL },
+		},
+	}
+};
+
 static struct usb_driver ttusb2_driver = {
 	.name		= "dvb_usb_ttusb2",
 	.probe		= ttusb2_probe,

--MP_/a9JcR/ua63hUPl/xRK/4TZ6--
