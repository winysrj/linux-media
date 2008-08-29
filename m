Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Date: Fri, 29 Aug 2008 18:48:38 +1000 (EST)
From: Finn Thain <fthain@telegraphics.com.au>
To: v4l-dvb-maintainer@linuxtv.org
Message-ID: <Pine.LNX.4.64.0808291627340.21301@loopy.telegraphics.com.au>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: [linux-dvb] [PATCH] Add support for the Gigabyte R8000-HT USB DVB-T
	adapter
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


Add support for the Gigabyte R8000-HT USB DVB-T adapter.

Thanks to Ilia Penev for the tip-off that this device is much the same as 
(identical to?) a Terratec Cinergy HT USB XE, and for the firmware hints: 
http://linuxtv.org/pipermail/linux-dvb/2008-August/028108.html

DVB functionality tested OK with xine.

This diff is based on the linuxtv.org v4l-dvb mercurial repo.


Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

diff -ru linux/drivers/media/dvb/dvb-usb/dib0700_devices.c linux/drivers/media/dvb/dvb-usb/dib0700_devices.c
--- linux/drivers/media/dvb/dvb-usb/dib0700_devices.c	2008-08-29 00:38:14.000000000 +1000
+++ linux/drivers/media/dvb/dvb-usb/dib0700_devices.c	2008-08-29 00:54:03.000000000 +1000
@@ -1117,7 +1117,8 @@
 	{ USB_DEVICE(USB_VID_TERRATEC,	USB_PID_TERRATEC_CINERGY_HT_EXPRESS) },
 	{ USB_DEVICE(USB_VID_TERRATEC,	USB_PID_TERRATEC_CINERGY_T_XXS) },
 	{ USB_DEVICE(USB_VID_LEADTEK,   USB_PID_WINFAST_DTV_DONGLE_STK7700P_2) },
-	{ USB_DEVICE(USB_VID_HAUPPAUGE, USB_PID_HAUPPAUGE_NOVA_TD_STICK_52009) },
+/* 35 */{ USB_DEVICE(USB_VID_HAUPPAUGE, USB_PID_HAUPPAUGE_NOVA_TD_STICK_52009) },
+	{ USB_DEVICE(USB_VID_GIGABYTE,  USB_PID_GIGABYTE_U8000) },
 	{ 0 }		/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, dib0700_usb_id_table);
@@ -1125,7 +1126,7 @@
 #define DIB0700_DEFAULT_DEVICE_PROPERTIES \
 	.caps              = DVB_USB_IS_AN_I2C_ADAPTER, \
 	.usb_ctrl          = DEVICE_SPECIFIC, \
-	.firmware          = "dvb-usb-dib0700-1.10.fw", \
+	.firmware          = "dvb-usb-dib0700-03-pre1.fw", \
 	.download_firmware = dib0700_download_firmware, \
 	.no_reconnect      = 1, \
 	.size_of_priv      = sizeof(struct dib0700_state), \
@@ -1403,8 +1404,12 @@
 			},
 		},
 
-		.num_device_descs = 3,
+		.num_device_descs = 4,
 		.devices = {
+			{   "Gigabyte U8000-RH",
+				{ &dib0700_usb_id_table[36], NULL },
+				{ NULL },
+			},
 			{   "Terratec Cinergy HT USB XE",
 				{ &dib0700_usb_id_table[27], NULL },
 				{ NULL },
diff -ru linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
--- linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	2008-08-29 00:38:14.000000000 +1000
+++ linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	2008-08-29 00:39:51.000000000 +1000
@@ -204,6 +204,7 @@
 #define USB_PID_LIFEVIEW_TV_WALKER_TWIN_COLD		0x0514
 #define USB_PID_LIFEVIEW_TV_WALKER_TWIN_WARM		0x0513
 #define USB_PID_GIGABYTE_U7000				0x7001
+#define USB_PID_GIGABYTE_U8000				0x7002
 #define USB_PID_ASUS_U3000				0x171f
 #define USB_PID_ASUS_U3100				0x173f
 #define USB_PID_YUAN_EC372S				0x1edc

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
