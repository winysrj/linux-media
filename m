Return-path: <mchehab@pedra>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38489 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832Ab0JPTSV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Oct 2010 15:18:21 -0400
Received: by pzk33 with SMTP id 33so274223pzk.19
        for <linux-media@vger.kernel.org>; Sat, 16 Oct 2010 12:18:20 -0700 (PDT)
Message-ID: <4CB9FA77.3000501@gmail.com>
Date: Sat, 16 Oct 2010 12:18:15 -0700
From: "D. K." <user.vdr@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: alannisota@gmail.com
Subject: [PATCH] dvb-usb-gp8psk: Fix driver name
Content-Type: multipart/mixed;
 boundary="------------010307090100040305090605"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a multi-part message in MIME format.
--------------010307090100040305090605
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

 This patch updates the name of the dvb-usb-gp8psk driver
from "Genpix 8psk-to-USB2 DVB-S" to "Genpix DVB-S".
The old name doesn't reflect newer devices such as the
Skywalker line which also user this driver.

Signed-off-by: Derek Kelly <user.vdr@gmail.com <mailto:user.vdr@gmail.com>>


--------------010307090100040305090605
Content-Type: text/plain;
 name="gp8psk-fix_driver_name.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="gp8psk-fix_driver_name.diff"

diff -pruN v4l-dvb.orig/drivers/media/dvb/dvb-usb/gp8psk-fe.c v4l-dvb/drivers/media/dvb/dvb-usb/gp8psk-fe.c
--- v4l-dvb.orig/drivers/media/dvb/dvb-usb/gp8psk-fe.c	2010-10-16 09:10:18.000000000 -0700
+++ v4l-dvb/drivers/media/dvb/dvb-usb/gp8psk-fe.c	2010-10-16 11:57:57.000000000 -0700
@@ -334,7 +334,7 @@ success:
 
 static struct dvb_frontend_ops gp8psk_fe_ops = {
 	.info = {
-		.name			= "Genpix 8psk-to-USB2 DVB-S",
+		.name			= "Genpix DVB-S",
 		.type			= FE_QPSK,
 		.frequency_min		= 800000,
 		.frequency_max		= 2250000,
diff -pruN v4l-dvb.orig/drivers/media/dvb/dvb-usb/gp8psk.c v4l-dvb/drivers/media/dvb/dvb-usb/gp8psk.c
--- v4l-dvb.orig/drivers/media/dvb/dvb-usb/gp8psk.c	2010-10-16 09:10:17.000000000 -0700
+++ v4l-dvb/drivers/media/dvb/dvb-usb/gp8psk.c	2010-10-16 11:58:36.000000000 -0700
@@ -306,6 +311,6 @@ module_init(gp8psk_usb_module_init);
 module_exit(gp8psk_usb_module_exit);
 
 MODULE_AUTHOR("Alan Nisota <alannisota@gamil.com>");
-MODULE_DESCRIPTION("Driver for Genpix 8psk-to-USB2 DVB-S");
+MODULE_DESCRIPTION("Driver for Genpix DVB-S");
 MODULE_VERSION("1.1");
 MODULE_LICENSE("GPL");

--------------010307090100040305090605--
