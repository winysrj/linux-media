Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mailout09.t-online.de ([194.25.134.84])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <yusuf.altin@t-online.de>) id 1LKsDm-0001N7-P5
	for linux-dvb@linuxtv.org; Thu, 08 Jan 2009 11:34:40 +0100
From: Yusuf Altin <yusuf.altin@t-online.de>
To: Patrick Boettcher <patrick.boettcher@desy.de>
In-Reply-To: <alpine.LRH.1.10.0901071124460.21687@pub6.ifh.de>
References: <1231284879.3619.2.camel@yusuf.laptop>
	<alpine.LRH.1.10.0901071124460.21687@pub6.ifh.de>
Content-Type: multipart/mixed; boundary="=-B3tqFAmbLnpOw2j9dKfI"
Date: Thu, 08 Jan 2009 11:34:15 +0100
Message-Id: <1231410855.2801.4.camel@yusuf.laptop>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: [linux-dvb] [PATCH] add Terratec Cinergy T Express to dibcom driver
 - attachted
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


--=-B3tqFAmbLnpOw2j9dKfI
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

This patch introduces support for dvb-t for the following dibcom based
card:
	Terratec Cinergy T Express (USB-ID: 0ccd:0062)





--=-B3tqFAmbLnpOw2j9dKfI
Content-Disposition: attachment; filename="cinergyt.patch"
Content-Type: text/x-patch; name="cinergyt.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

#This patch introduces support for dvb-t for the following dibcom based card:
#	Terratec Cinergy T Express (USB-ID: 0ccd:0062)
#		Signed-off-by: Yusuf Altin <yusuf.altin@t-online.de>
#		Signed-off-by: Albert Comerma <albert.comerma@gmail.com>

diff -r b7e7abe3e3aa linux/drivers/media/dvb/dvb-usb/dib0700_devices.c
--- a/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c	Mon Jan 05 02:42:38 2009 -0200
+++ b/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c	Wed Jan 07 00:28:13 2009 +0100
@@ -1388,16 +1388,17 @@ struct usb_device_id dib0700_usb_id_tabl
 	{ USB_DEVICE(USB_VID_LEADTEK,   USB_PID_WINFAST_DTV_DONGLE_STK7700P_2) },
 /* 35 */{ USB_DEVICE(USB_VID_HAUPPAUGE, USB_PID_HAUPPAUGE_NOVA_TD_STICK_52009) },
 	{ USB_DEVICE(USB_VID_HAUPPAUGE, USB_PID_HAUPPAUGE_NOVA_T_500_3) },
 	{ USB_DEVICE(USB_VID_GIGABYTE,  USB_PID_GIGABYTE_U8000) },
 	{ USB_DEVICE(USB_VID_YUAN,      USB_PID_YUAN_STK7700PH) },
 	{ USB_DEVICE(USB_VID_ASUS,	USB_PID_ASUS_U3000H) },
 /* 40 */{ USB_DEVICE(USB_VID_PINNACLE,  USB_PID_PINNACLE_PCTV801E) },
 	{ USB_DEVICE(USB_VID_PINNACLE,  USB_PID_PINNACLE_PCTV801E_SE) },
+	{ USB_DEVICE(USB_VID_TERRATEC,	USB_PID_TERRATEC_CINERGY_T_EXPRESS) },
 	{ 0 }		/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, dib0700_usb_id_table);
 
 #define DIB0700_DEFAULT_DEVICE_PROPERTIES \
 	.caps              = DVB_USB_IS_AN_I2C_ADAPTER, \
 	.usb_ctrl          = DEVICE_SPECIFIC, \
 	.firmware          = "dvb-usb-dib0700-1.20.fw", \
@@ -1532,17 +1533,18 @@ struct dvb_usb_device_properties dib0700
 			},
 			{   "Hauppauge Nova-TD Stick/Elgato Eye-TV Diversity",
 				{ &dib0700_usb_id_table[13], NULL },
 				{ NULL },
 			},
 			{   "DiBcom STK7700D reference design",
 				{ &dib0700_usb_id_table[14], NULL },
 				{ NULL },
-			}
+			},
+
 		},
 
 		.rc_interval      = DEFAULT_RC_INTERVAL,
 		.rc_key_map       = dib0700_rc_keys,
 		.rc_key_map_size  = ARRAY_SIZE(dib0700_rc_keys),
 		.rc_query         = dib0700_rc_query
 
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -1552,25 +1554,29 @@ struct dvb_usb_device_properties dib0700
 			{
 				.frontend_attach  = stk7700P2_frontend_attach,
 				.tuner_attach     = stk7700d_tuner_attach,
 
 				DIB0700_DEFAULT_STREAMING_CONFIG(0x02),
 			},
 		},
 
-		.num_device_descs = 2,
+		.num_device_descs = 3,
 		.devices = {
 			{   "ASUS My Cinema U3000 Mini DVBT Tuner",
 				{ &dib0700_usb_id_table[23], NULL },
 				{ NULL },
 			},
 			{   "Yuan EC372S",
 				{ &dib0700_usb_id_table[31], NULL },
 				{ NULL },
+			},
+			{   "Terratec Cinergy T Express",
+				{ &dib0700_usb_id_table[42], NULL },
+				{ NULL },
 			}
 		},
 
 		.rc_interval      = DEFAULT_RC_INTERVAL,
 		.rc_key_map       = dib0700_rc_keys,
 		.rc_key_map_size  = ARRAY_SIZE(dib0700_rc_keys),
 		.rc_query         = dib0700_rc_query
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
diff -r b7e7abe3e3aa linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
--- a/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	Mon Jan 05 02:42:38 2009 -0200
+++ b/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	Wed Jan 07 00:28:13 2009 +0100
@@ -159,16 +159,17 @@
 #define USB_PID_AVERMEDIA_HYBRID_ULTRA_USB_M039R_DVBT	0x2039
 #define USB_PID_AVERMEDIA_VOLAR_X			0xa815
 #define USB_PID_AVERMEDIA_VOLAR_X_2			0x8150
 #define USB_PID_AVERMEDIA_A309				0xa309
 #define USB_PID_TECHNOTREND_CONNECT_S2400               0x3006
 #define USB_PID_TERRATEC_CINERGY_DT_XS_DIVERSITY	0x005a
 #define USB_PID_TERRATEC_CINERGY_HT_USB_XE		0x0058
 #define USB_PID_TERRATEC_CINERGY_HT_EXPRESS		0x0060
+#define USB_PID_TERRATEC_CINERGY_T_EXPRESS		0x0062
 #define USB_PID_TERRATEC_CINERGY_T_XXS			0x0078
 #define USB_PID_PINNACLE_EXPRESSCARD_320CX		0x022e
 #define USB_PID_PINNACLE_PCTV2000E			0x022c
 #define USB_PID_PINNACLE_PCTV_DVB_T_FLASH		0x0228
 #define USB_PID_PINNACLE_PCTV_DUAL_DIVERSITY_DVB_T	0x0229
 #define USB_PID_PINNACLE_PCTV71E			0x022b
 #define USB_PID_PINNACLE_PCTV72E			0x0236
 #define USB_PID_PINNACLE_PCTV73E			0x0237

--=-B3tqFAmbLnpOw2j9dKfI
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--=-B3tqFAmbLnpOw2j9dKfI--
