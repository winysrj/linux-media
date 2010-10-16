Return-path: <mchehab@pedra>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53745 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063Ab0JPRYA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Oct 2010 13:24:00 -0400
Received: by pzk33 with SMTP id 33so267662pzk.19
        for <linux-media@vger.kernel.org>; Sat, 16 Oct 2010 10:23:59 -0700 (PDT)
Message-ID: <4CB9DFA7.80208@gmail.com>
Date: Sat, 16 Oct 2010 10:23:51 -0700
From: "D. K." <user.vdr@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] gp8psk: Add support for the Genpix Skywalker-2 (against git)
Content-Type: multipart/mixed;
 boundary="------------040506010009000708010701"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a multi-part message in MIME format.
--------------040506010009000708010701
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit



gp8psk: Add support for the Genpix Skywalker-2 per user requests.

Patched against git.

Signed-off-by: Derek Kelly <user.vdr@gmail.com>


--------------040506010009000708010701
Content-Type: text/plain;
 name="gp8psk-add_skywalker-2_git.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="gp8psk-add_skywalker-2_git.diff"

diff -pruN v4l-dvb.orig/drivers/media/dvb/dvb-usb/dvb-usb-ids.h v4l-dvb/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
--- v4l-dvb.orig/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	2010-10-16 09:10:18.000000000 -0700
+++ v4l-dvb/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	2010-10-16 09:17:36.000000000 -0700
@@ -271,6 +271,7 @@
 #define USB_PID_GENPIX_8PSK_REV_2			0x0202
 #define USB_PID_GENPIX_SKYWALKER_1			0x0203
 #define USB_PID_GENPIX_SKYWALKER_CW3K			0x0204
+#define USB_PID_GENPIX_SKYWALKER_2			0x0206
 #define USB_PID_SIGMATEK_DVB_110			0x6610
 #define USB_PID_MSI_DIGI_VOX_MINI_II			0x1513
 #define USB_PID_MSI_DIGIVOX_DUO				0x8801
diff -pruN v4l-dvb.orig/drivers/media/dvb/dvb-usb/gp8psk.c v4l-dvb/drivers/media/dvb/dvb-usb/gp8psk.c
--- v4l-dvb.orig/drivers/media/dvb/dvb-usb/gp8psk.c	2010-10-16 09:10:17.000000000 -0700
+++ v4l-dvb/drivers/media/dvb/dvb-usb/gp8psk.c	2010-10-16 09:30:30.000000000 -0700
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
@@ -272,6 +273,10 @@ static struct dvb_usb_device_properties
 		  .cold_ids = { NULL },
 		  .warm_ids = { &gp8psk_usb_table[3], NULL },
 		},
+		{ .name = "Genpix SkyWalker-2 DVB-S receiver",
+		  .cold_ids = { NULL },
+		  .warm_ids = { &gp8psk_usb_table[4], NULL },
+		},
 		{ NULL },
 	}
 };

--------------040506010009000708010701--
