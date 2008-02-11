Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from fmmailgate02.web.de ([217.72.192.227])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Andre.Weidemann@web.de>) id 1JOea6-0004Sk-AM
	for linux-dvb@linuxtv.org; Mon, 11 Feb 2008 20:44:46 +0100
Received: from smtp08.web.de (fmsmtp08.dlan.cinetic.de [172.20.5.216])
	by fmmailgate02.web.de (Postfix) with ESMTP id 28B2DD04CA66
	for <linux-dvb@linuxtv.org>; Mon, 11 Feb 2008 20:44:16 +0100 (CET)
Received: from [84.184.112.111] (helo=[192.168.0.1])
	by smtp08.web.de with asmtp (WEB.DE 4.109 #226) id 1JOeZb-0006xT-00
	for linux-dvb@linuxtv.org; Mon, 11 Feb 2008 20:44:16 +0100
Message-ID: <47B0A591.9030408@web.de>
Date: Mon, 11 Feb 2008 20:44:17 +0100
From: =?ISO-8859-1?Q?Andr=E9_Weidemann?= <Andre.Weidemann@web.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Content-Type: multipart/mixed; boundary="------------090605080403080406060900"
Subject: [linux-dvb] [PATCH] reworked patch to support TT connect S-2400
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--------------090605080403080406060900
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Hi all,
thanks to Patrick Boettcher I finally managed to get both, the Pinnacle=20
400e and the TT connect S-2400 working on the same machine.

I attached a patch which should apply cleanly against current HG.
Please test the attached patch.
I extracted the necessary firmware file from the TT driver and put it=20
here: http://ilpss8.dyndns.org/dvb-usb-tt-s2400-01.fw

Any comments on the patch are welcome.

Thank you.
  Andr=E9

--------------090605080403080406060900
Content-Type: text/x-patch;
 name="patch-TT_connect_S-2400.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch-TT_connect_S-2400.diff"

diff -Nru v4l-dvb/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h v4l-dvb-patched-for-TT-connect-S2400/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
--- v4l-dvb/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	2008-02-11 20:30:06.370186430 +0100
+++ v4l-dvb-patched-for-TT-connect-S2400/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	2008-02-11 20:30:57.605106142 +0100
@@ -40,6 +40,7 @@
 #define USB_VID_MSI				0x0db0
 #define USB_VID_OPERA1				0x695c
 #define USB_VID_PINNACLE			0x2304
+#define USB_VID_TECHNOTREND			0x0b48
 #define USB_VID_TERRATEC			0x0ccd
 #define USB_VID_VISIONPLUS			0x13d3
 #define USB_VID_TWINHAN				0x1822
@@ -134,6 +135,7 @@
 #define USB_PID_AVERMEDIA_EXPRESS			0xb568
 #define USB_PID_AVERMEDIA_VOLAR				0xa807
 #define USB_PID_AVERMEDIA_VOLAR_2			0xb808
+#define USB_PID_TECHNOTREND_CONNECT_S2400               0x3006
 #define USB_PID_TERRATEC_CINERGY_DT_XS_DIVERSITY	0x005a
 #define USB_PID_PINNACLE_PCTV2000E			0x022c
 #define USB_PID_PINNACLE_PCTV_DVB_T_FLASH		0x0228
diff -Nru v4l-dvb/linux/drivers/media/dvb/dvb-usb/ttusb2.c v4l-dvb-patched-for-TT-connect-S2400/linux/drivers/media/dvb/dvb-usb/ttusb2.c
--- v4l-dvb/linux/drivers/media/dvb/dvb-usb/ttusb2.c	2008-02-11 20:30:06.382187114 +0100
+++ v4l-dvb-patched-for-TT-connect-S2400/linux/drivers/media/dvb/dvb-usb/ttusb2.c	2008-02-11 20:30:57.609106370 +0100
@@ -182,16 +182,26 @@
 
 /* DVB USB Driver stuff */
 static struct dvb_usb_device_properties ttusb2_properties;
+static struct dvb_usb_device_properties ttusb2_properties_s2400;
 
 static int ttusb2_probe(struct usb_interface *intf,
 		const struct usb_device_id *id)
 {
-	return dvb_usb_device_init(intf,&ttusb2_properties,THIS_MODULE,NULL);
+        int ret=-ENOMEM;
+        if ((ret = dvb_usb_device_init(intf,&ttusb2_properties,THIS_MODULE,NULL)) == 0) {
+                return ret;
+        }
+        if ((ret = dvb_usb_device_init(intf,&ttusb2_properties_s2400,THIS_MODULE,NULL)) == 0) {
+                return ret;
+        }
+        return ret;
+
 }
 
 static struct usb_device_id ttusb2_table [] = {
 		{ USB_DEVICE(USB_VID_PINNACLE, USB_PID_PCTV_400E) },
 		{ USB_DEVICE(USB_VID_PINNACLE, USB_PID_PCTV_450E) },
+		{ USB_DEVICE(USB_VID_TECHNOTREND, USB_PID_TECHNOTREND_CONNECT_S2400) },
 		{}		/* Terminating entry */
 };
 MODULE_DEVICE_TABLE (usb, ttusb2_table);
@@ -248,6 +258,54 @@
 	}
 };
 
+static struct dvb_usb_device_properties ttusb2_properties_s2400 = {
+	.caps = DVB_USB_IS_AN_I2C_ADAPTER,
+
+	.usb_ctrl = CYPRESS_FX2,
+	.firmware = "dvb-usb-tt-s2400-01.fw",
+
+	.size_of_priv = sizeof(struct ttusb2_state),
+
+	.num_adapters = 1,
+	.adapter = {
+		{
+			.streaming_ctrl   = NULL, // ttusb2_streaming_ctrl,
+
+			.frontend_attach  = ttusb2_frontend_attach,
+			.tuner_attach     = ttusb2_tuner_attach,
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
+		{   "Technotrend TT-connect S-2400",
+			{ &ttusb2_table[2], NULL },
+			{ NULL },
+		},
+	}
+};
+
 static struct usb_driver ttusb2_driver = {
 	.name		= "dvb_usb_ttusb2",
 	.probe		= ttusb2_probe,

--------------090605080403080406060900
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------090605080403080406060900--
