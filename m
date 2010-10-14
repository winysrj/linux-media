Return-path: <mchehab@pedra>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:39819 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755679Ab0JNTDY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Oct 2010 15:03:24 -0400
Received: by pvc7 with SMTP id 7so615871pvc.19
        for <linux-media@vger.kernel.org>; Thu, 14 Oct 2010 12:03:24 -0700 (PDT)
Message-ID: <4CB753F2.7080009@gmail.com>
Date: Thu, 14 Oct 2010 12:03:14 -0700
From: "D. K." <user.vdr@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: alannisota@gmail.com
Subject: [PATCH] gp8psk: Add support for the Genpix Skywalker-2
Content-Type: multipart/mixed;
 boundary="------------000804020201000107090001"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a multi-part message in MIME format.
--------------000804020201000107090001
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

 gp8psk: Add support for the Genpix Skywalker-2 per user requests.

Patched against v4l-dvb hg ab433502e041 tip.  Should patch fine
against git as well.

Signed-off-by: Derek Kelly <user.vdr@gmail.com>
----------
diff -pruN v4l-dvb.orig/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h v4l-dvb/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
--- v4l-dvb.orig/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h  2010-08-17 09:53:27.000000000 -0700
+++ v4l-dvb/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h       2010-08-17 10:38:48.000000000 -0700
@@ -267,6 +267,7 @@
 #define USB_PID_GENPIX_8PSK_REV_2                      0x0202
 #define USB_PID_GENPIX_SKYWALKER_1                     0x0203
 #define USB_PID_GENPIX_SKYWALKER_CW3K                  0x0204
+#define USB_PID_GENPIX_SKYWALKER_2                     0x0206
 #define USB_PID_SIGMATEK_DVB_110                       0x6610
 #define USB_PID_MSI_DIGI_VOX_MINI_II                   0x1513
 #define USB_PID_MSI_DIGIVOX_DUO                                0x8801
diff -pruN v4l-dvb.orig/linux/drivers/media/dvb/dvb-usb/gp8psk.c v4l-dvb/linux/drivers/media/dvb/dvb-usb/gp8psk.c
--- v4l-dvb.orig/linux/drivers/media/dvb/dvb-usb/gp8psk.c       2010-08-17 09:53:27.000000000 -0700
+++ v4l-dvb/linux/drivers/media/dvb/dvb-usb/gp8psk.c    2010-08-17 10:42:33.000000000 -0700
@@ -227,6 +227,7 @@ static struct usb_device_id gp8psk_usb_t
            { USB_DEVICE(USB_VID_GENPIX, USB_PID_GENPIX_8PSK_REV_1_WARM) },
            { USB_DEVICE(USB_VID_GENPIX, USB_PID_GENPIX_8PSK_REV_2) },
            { USB_DEVICE(USB_VID_GENPIX, USB_PID_GENPIX_SKYWALKER_1) },
+           { USB_DEVICE(USB_VID_GENPIX, USB_PID_GENPIX_SKYWALKER_2) },
 /*         { USB_DEVICE(USB_VID_GENPIX, USB_PID_GENPIX_SKYWALKER_CW3K) }, */
            { 0 },
 };
@@ -258,7 +259,7 @@ static struct dvb_usb_device_properties

        .generic_bulk_ctrl_endpoint = 0x01,

-       .num_device_descs = 3,
+       .num_device_descs = 4,
        .devices = {
                { .name = "Genpix 8PSK-to-USB2 Rev.1 DVB-S receiver",
                  .cold_ids = { &gp8psk_usb_table[0], NULL },
@@ -272,10 +273,14 @@ static struct dvb_usb_device_properties
                  .cold_ids = { NULL },
                  .warm_ids = { &gp8psk_usb_table[3], NULL },
                },
+               { .name = "Genpix SkyWalker-2 DVB-S receiver",
+                 .cold_ids = { NULL },
+                 .warm_ids = { &gp8psk_usb_table[4], NULL },
+               },
 #if 0
                { .name = "Genpix SkyWalker-CW3K DVB-S receiver",
                  .cold_ids = { NULL },
-                 .warm_ids = { &gp8psk_usb_table[4], NULL },
+                 .warm_ids = { &gp8psk_usb_table[5], NULL },
                },
 #endif
                { NULL },


--------------000804020201000107090001
Content-Type: text/plain;
 name="gp8psk-add_skywalker-2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="gp8psk-add_skywalker-2.diff"

diff -pruN v4l-dvb.orig/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h v4l-dvb/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
--- v4l-dvb.orig/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	2010-08-17 09:53:27.000000000 -0700
+++ v4l-dvb/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	2010-08-17 10:38:48.000000000 -0700
@@ -267,6 +267,7 @@
 #define USB_PID_GENPIX_8PSK_REV_2			0x0202
 #define USB_PID_GENPIX_SKYWALKER_1			0x0203
 #define USB_PID_GENPIX_SKYWALKER_CW3K			0x0204
+#define USB_PID_GENPIX_SKYWALKER_2			0x0206
 #define USB_PID_SIGMATEK_DVB_110			0x6610
 #define USB_PID_MSI_DIGI_VOX_MINI_II			0x1513
 #define USB_PID_MSI_DIGIVOX_DUO				0x8801
diff -pruN v4l-dvb.orig/linux/drivers/media/dvb/dvb-usb/gp8psk.c v4l-dvb/linux/drivers/media/dvb/dvb-usb/gp8psk.c
--- v4l-dvb.orig/linux/drivers/media/dvb/dvb-usb/gp8psk.c	2010-08-17 09:53:27.000000000 -0700
+++ v4l-dvb/linux/drivers/media/dvb/dvb-usb/gp8psk.c	2010-08-17 10:42:33.000000000 -0700
@@ -227,6 +227,7 @@ static struct usb_device_id gp8psk_usb_t
 	    { USB_DEVICE(USB_VID_GENPIX, USB_PID_GENPIX_8PSK_REV_1_WARM) },
 	    { USB_DEVICE(USB_VID_GENPIX, USB_PID_GENPIX_8PSK_REV_2) },
 	    { USB_DEVICE(USB_VID_GENPIX, USB_PID_GENPIX_SKYWALKER_1) },
+	    { USB_DEVICE(USB_VID_GENPIX, USB_PID_GENPIX_SKYWALKER_2) },
 /*	    { USB_DEVICE(USB_VID_GENPIX, USB_PID_GENPIX_SKYWALKER_CW3K) }, */
 	    { 0 },
 };
@@ -258,7 +259,7 @@ static struct dvb_usb_device_properties
 
 	.generic_bulk_ctrl_endpoint = 0x01,
 
-	.num_device_descs = 3,
+	.num_device_descs = 4,
 	.devices = {
 		{ .name = "Genpix 8PSK-to-USB2 Rev.1 DVB-S receiver",
 		  .cold_ids = { &gp8psk_usb_table[0], NULL },
@@ -272,10 +273,14 @@ static struct dvb_usb_device_properties
 		  .cold_ids = { NULL },
 		  .warm_ids = { &gp8psk_usb_table[3], NULL },
 		},
+		{ .name = "Genpix SkyWalker-2 DVB-S receiver",
+		  .cold_ids = { NULL },
+		  .warm_ids = { &gp8psk_usb_table[4], NULL },
+		},
 #if 0
 		{ .name = "Genpix SkyWalker-CW3K DVB-S receiver",
 		  .cold_ids = { NULL },
-		  .warm_ids = { &gp8psk_usb_table[4], NULL },
+		  .warm_ids = { &gp8psk_usb_table[5], NULL },
 		},
 #endif
 		{ NULL },

--------------000804020201000107090001--
