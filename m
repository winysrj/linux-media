Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from cable-85.28.84.48.coditel.net ([85.28.84.48]
	helo=ibiza.bxl.tuxicoman.be)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gmsoft@tuxicoman.be>) id 1KTDfJ-0008DS-Ek
	for linux-dvb@linuxtv.org; Wed, 13 Aug 2008 12:33:19 +0200
Received: from bleh.bxl.tuxicoman.be ([2001:6f8:310:300:213:d4ff:fe5c:bd4f])
	by ibiza.bxl.tuxicoman.be with esmtps (TLSv1:AES256-SHA:256)
	(Exim 4.69) (envelope-from <gmsoft@tuxicoman.be>) id 1KTDek-0007mP-FU
	for linux-dvb@linuxtv.org; Wed, 13 Aug 2008 12:32:42 +0200
Date: Wed, 13 Aug 2008 12:32:41 +0200
From: Guy Martin <gmsoft@tuxicoman.be>
To: linux-dvb@linuxtv.org
Message-ID: <20080813123241.0f7cffca@bleh.bxl.tuxicoman.be>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/VGCPI+ks1ZnQZHc5NziDmWF"
Subject: [linux-dvb] CT-3650 driver effort
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--MP_/VGCPI+ks1ZnQZHc5NziDmWF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


Hi all,

I'm currently trying to get the CT-3650 working.
It has the following chips :
 - TDA8264 (tuner)
 - TDA10023 (DVB-C demod)
 - TDA10048 (DVB-T demod)


I'm able to get the DVB-C frontend working using the attached patch.
However I can't test the DVB-T nor the CI.

To test the DVB-T frontend, I'm missing dvb-fe-tda10048-1.0.fw which I
can't find anywhere.

Regarding the CI, I'm only watching FTA so I won't be able to test that.


Please review the attached patch. If I'm given the tda10048 firmware I
should probably get it to work. 


Regards,
  Guy

-- 
Guy Martin
Gentoo Linux - HPPA port lead

--MP_/VGCPI+ks1ZnQZHc5NziDmWF
Content-Type: text/x-patch; name=ct-3650.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=ct-3650.patch

diff -r cbfa05ad2711 linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
--- a/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	Fri Aug 01 08:23:41 2008 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	Fri Aug 01 17:29:55 2008 +0200
@@ -144,6 +144,7 @@
 #define USB_PID_AVERMEDIA_HYBRID_ULTRA_USB_M039R_ATSC	0x1039
 #define USB_PID_AVERMEDIA_HYBRID_ULTRA_USB_M039R_DVBT	0x2039
 #define USB_PID_TECHNOTREND_CONNECT_S2400               0x3006
+#define USB_PID_TECHNOTREND_CONNECT_CT3650		0x300d
 #define USB_PID_TERRATEC_CINERGY_DT_XS_DIVERSITY	0x005a
 #define USB_PID_TERRATEC_CINERGY_HT_USB_XE		0x0058
 #define USB_PID_TERRATEC_CINERGY_HT_EXPRESS		0x0060
diff -r cbfa05ad2711 linux/drivers/media/dvb/dvb-usb/ttusb2.c
--- a/linux/drivers/media/dvb/dvb-usb/ttusb2.c	Fri Aug 01 08:23:41 2008 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/ttusb2.c	Wed Aug 13 15:54:12 2008 +0200
@@ -29,6 +29,9 @@
 
 #include "tda826x.h"
 #include "tda10086.h"
+#include "tda1002x.h"
+#include "tda827x.h"
+#include "tda10048.h"
 #include "lnbp21.h"
 
 /* debug */
@@ -156,7 +159,24 @@ static struct tda10086_config tda10086_c
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
+	.output_mode    = TDA10048_PARALLEL_OUTPUT,
+	.fwbulkwritelen = TDA10048_BULKWRITE_50,
+	.inversion      = TDA10048_INVERSION_ON,
+};
+
+static int ttusb2_frontend_tda10086_attach(struct dvb_usb_adapter *adap)
 {
 	if (usb_set_interface(adap->dev->udev,0,3) < 0)
 		err("set interface to alts=3 failed");
@@ -169,7 +189,49 @@ static int ttusb2_frontend_attach(struct
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
+static int ttusb2_tuner_tda827x_61_attach(struct dvb_usb_adapter *adap) {
+
+	if (dvb_attach(tda827x_attach, adap->fe, 0x61, &adap->dev->i2c_adap, NULL) == NULL) {
+		printk(KERN_ERR "%s: No tda827x found!\n", __func__);
+		return -ENODEV;
+	}
+	return 0;
+}
+
+static int ttusb2_tuner_tda827x_62_attach(struct dvb_usb_adapter *adap) {
+
+	if (dvb_attach(tda827x_attach, adap->fe, 0x62, &adap->dev->i2c_adap, NULL) == NULL) {
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
@@ -186,6 +248,7 @@ static int ttusb2_tuner_attach(struct dv
 /* DVB USB Driver stuff */
 static struct dvb_usb_device_properties ttusb2_properties;
 static struct dvb_usb_device_properties ttusb2_properties_s2400;
+static struct dvb_usb_device_properties ttusb2_properties_ct3650;
 
 static int ttusb2_probe(struct usb_interface *intf,
 		const struct usb_device_id *id)
@@ -193,6 +256,8 @@ static int ttusb2_probe(struct usb_inter
 	if (0 == dvb_usb_device_init(intf, &ttusb2_properties,
 				     THIS_MODULE, NULL, adapter_nr) ||
 	    0 == dvb_usb_device_init(intf, &ttusb2_properties_s2400,
+				     THIS_MODULE, NULL, adapter_nr) ||
+	    0 == dvb_usb_device_init(intf, &ttusb2_properties_ct3650,
 				     THIS_MODULE, NULL, adapter_nr))
 		return 0;
 	return -ENODEV;
@@ -203,6 +268,8 @@ static struct usb_device_id ttusb2_table
 	{ USB_DEVICE(USB_VID_PINNACLE, USB_PID_PCTV_450E) },
 	{ USB_DEVICE(USB_VID_TECHNOTREND,
 		USB_PID_TECHNOTREND_CONNECT_S2400) },
+	{ USB_DEVICE(USB_VID_TECHNOTREND,
+		USB_PID_TECHNOTREND_CONNECT_CT3650) },
 	{}		/* Terminating entry */
 };
 MODULE_DEVICE_TABLE (usb, ttusb2_table);
@@ -220,8 +287,8 @@ static struct dvb_usb_device_properties 
 		{
 			.streaming_ctrl   = NULL, // ttusb2_streaming_ctrl,
 
-			.frontend_attach  = ttusb2_frontend_attach,
-			.tuner_attach     = ttusb2_tuner_attach,
+			.frontend_attach  = ttusb2_frontend_tda10086_attach,
+			.tuner_attach     = ttusb2_tuner_tda826x_attach,
 
 			/* parameter for the MPEG2-data transfer */
 			.stream = {
@@ -272,8 +339,8 @@ static struct dvb_usb_device_properties 
 		{
 			.streaming_ctrl   = NULL,
 
-			.frontend_attach  = ttusb2_frontend_attach,
-			.tuner_attach     = ttusb2_tuner_attach,
+			.frontend_attach  = ttusb2_frontend_tda10086_attach,
+			.tuner_attach     = ttusb2_tuner_tda826x_attach,
 
 			/* parameter for the MPEG2-data transfer */
 			.stream = {
@@ -307,6 +374,73 @@ static struct dvb_usb_device_properties 
 	}
 };
 
+static struct dvb_usb_device_properties ttusb2_properties_ct3650 = {
+	.caps = DVB_USB_IS_AN_I2C_ADAPTER,
+
+	.usb_ctrl = CYPRESS_FX2,
+
+	.size_of_priv = sizeof(struct ttusb2_state),
+
+	.num_adapters = 2,
+	.adapter = {
+		{
+			.streaming_ctrl   = NULL,
+
+			.frontend_attach  = ttusb2_frontend_tda10023_attach,
+			.tuner_attach = ttusb2_tuner_tda827x_61_attach,
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
+		{
+			.streaming_ctrl   = NULL,
+
+			.frontend_attach  = ttusb2_frontend_tda10048_attach,
+			.tuner_attach = ttusb2_tuner_tda827x_62_attach,
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
+		}
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
+			{ &ttusb2_table[3], NULL },
+			{ NULL },
+		},
+	}
+};
+
 static struct usb_driver ttusb2_driver = {
 	.name		= "dvb_usb_ttusb2",
 	.probe		= ttusb2_probe,

--MP_/VGCPI+ks1ZnQZHc5NziDmWF
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--MP_/VGCPI+ks1ZnQZHc5NziDmWF--
