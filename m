Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:30668 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288AbZCaPQT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Mar 2009 11:16:19 -0400
Received: by fg-out-1718.google.com with SMTP id e12so31586fga.17
        for <linux-media@vger.kernel.org>; Tue, 31 Mar 2009 08:16:16 -0700 (PDT)
Message-ID: <49D2338C.7040703@gmail.com>
Date: Tue, 31 Mar 2009 08:15:24 -0700
From: Alan Nisota <alannisota@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] Remove support for Genpix-CW3K (damages hardware)
Content-Type: multipart/mixed;
 boundary="------------020801080305070504050404"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020801080305070504050404
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

I have been informed by the manufacturer that the patch currently in the 
v4l tree to support the Genpix-CW3K version of the hardware will 
actually damage the firmware on recent units.  As he seems to not want 
this hardware supported in Linux, and I do not know how to detect the 
difference between affected and not-affected units, I am requesting the 
immediate removal of support for this device.  This patch removes a 
portion of the changeset dce7e08ed2b1 applied 2007-08-18 relating to 
this specific device.

Signed off by: Alan Nisota <anisota@gmail.com>

--------------020801080305070504050404
Content-Type: text/plain;
 name="drop_cw3k"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="drop_cw3k"

diff -r 5567e82c34a0 linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
--- a/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	Tue Mar 31 07:24:14 2009 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	Tue Mar 31 07:48:00 2009 -0700
@@ -225,7 +225,6 @@
 #define USB_PID_GENPIX_8PSK_REV_1_WARM			0x0201
 #define USB_PID_GENPIX_8PSK_REV_2			0x0202
 #define USB_PID_GENPIX_SKYWALKER_1			0x0203
-#define USB_PID_GENPIX_SKYWALKER_CW3K			0x0204
 #define USB_PID_SIGMATEK_DVB_110			0x6610
 #define USB_PID_MSI_DIGI_VOX_MINI_II			0x1513
 #define USB_PID_MSI_DIGIVOX_DUO				0x8801
diff -r 5567e82c34a0 linux/drivers/media/dvb/dvb-usb/gp8psk.c
--- a/linux/drivers/media/dvb/dvb-usb/gp8psk.c	Tue Mar 31 07:24:14 2009 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/gp8psk.c	Tue Mar 31 07:48:00 2009 -0700
@@ -138,8 +138,6 @@ static int gp8psk_power_ctrl(struct dvb_
 	if (onoff) {
 		gp8psk_usb_in_op(d, GET_8PSK_CONFIG,0,0,&status,1);
 		if (! (status & bm8pskStarted)) {  /* started */
-			if(gp_product_id == USB_PID_GENPIX_SKYWALKER_CW3K)
-				gp8psk_usb_out_op(d, CW3K_INIT, 1, 0, NULL, 0);
 			if (gp8psk_usb_in_op(d, BOOT_8PSK, 1, 0, &buf, 1))
 				return -EINVAL;
 		}
@@ -168,8 +166,6 @@ static int gp8psk_power_ctrl(struct dvb_
 		/* Turn off 8psk power */
 		if (gp8psk_usb_in_op(d, BOOT_8PSK, 0, 0, &buf, 1))
 			return -EINVAL;
-		if(gp_product_id == USB_PID_GENPIX_SKYWALKER_CW3K)
-			gp8psk_usb_out_op(d, CW3K_INIT, 0, 0, NULL, 0);
 	}
 	return 0;
 }
@@ -223,7 +219,6 @@ static struct usb_device_id gp8psk_usb_t
 	    { USB_DEVICE(USB_VID_GENPIX, USB_PID_GENPIX_8PSK_REV_1_WARM) },
 	    { USB_DEVICE(USB_VID_GENPIX, USB_PID_GENPIX_8PSK_REV_2) },
 	    { USB_DEVICE(USB_VID_GENPIX, USB_PID_GENPIX_SKYWALKER_1) },
-	    { USB_DEVICE(USB_VID_GENPIX, USB_PID_GENPIX_SKYWALKER_CW3K) },
 	    { 0 },
 };
 MODULE_DEVICE_TABLE(usb, gp8psk_usb_table);
@@ -254,7 +249,7 @@ static struct dvb_usb_device_properties 
 
 	.generic_bulk_ctrl_endpoint = 0x01,
 
-	.num_device_descs = 4,
+	.num_device_descs = 3,
 	.devices = {
 		{ .name = "Genpix 8PSK-to-USB2 Rev.1 DVB-S receiver",
 		  .cold_ids = { &gp8psk_usb_table[0], NULL },
@@ -267,10 +262,6 @@ static struct dvb_usb_device_properties 
 		{ .name = "Genpix SkyWalker-1 DVB-S receiver",
 		  .cold_ids = { NULL },
 		  .warm_ids = { &gp8psk_usb_table[3], NULL },
-		},
-		{ .name = "Genpix SkyWalker-CW3K DVB-S receiver",
-		  .cold_ids = { NULL },
-		  .warm_ids = { &gp8psk_usb_table[4], NULL },
 		},
 		{ NULL },
 	}
diff -r 5567e82c34a0 linux/drivers/media/dvb/dvb-usb/gp8psk.h
--- a/linux/drivers/media/dvb/dvb-usb/gp8psk.h	Tue Mar 31 07:24:14 2009 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/gp8psk.h	Tue Mar 31 07:48:00 2009 -0700
@@ -51,7 +51,6 @@ extern int dvb_usb_gp8psk_debug;
 #define GET_SIGNAL_LOCK                 0x90    /* in */
 #define GET_SERIAL_NUMBER               0x93    /* in */
 #define USE_EXTRA_VOLT                  0x94
-#define CW3K_INIT			0x9d
 
 /* PSK_configuration bits */
 #define bm8pskStarted                   0x01

--------------020801080305070504050404--
