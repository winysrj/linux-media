Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:43645 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830AbZGZQpr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Jul 2009 12:45:47 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] uvcvideo: Really don't apply the FIX_BANDWIDTH quirk to all ViMicro devices
Date: Sun, 26 Jul 2009 18:47:10 +0200
Cc: linux-media@vger.kernel.org, Sebastian Strand <sebstrand@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200907261847.10690.laurent.pinchart@skynet.be>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I forgot to change USB_DEVICE_ID_MATCH_VENDOR to USB_DEVICE_ID_MATCH_DEVICE in
the last commit, defeating its whole purpose. Fix this.

Signed-off-by: Laurent Pinchart <laurent.pinchart@skynet.be>

Mauro, can you merge this with the "Don't apply the FIX_BANDWIDTH quirk to all
ViMicro devices" commit (changeset 12328:da81aafb9c5d) and keep the commit
message of the first when you push them upstream ? As this is a 2.6.30
regression it would be nice to get the fix in 2.6.31.

diff -r f8f134705b65 -r 2b37d4d66c1a 
linux/drivers/media/video/uvc/uvc_driver.c
--- a/linux/drivers/media/video/uvc/uvc_driver.c	Fri Jul 24 16:19:39 2009 
-0300
+++ b/linux/drivers/media/video/uvc/uvc_driver.c	Sun Jul 26 18:30:02 2009 
+0200
@@ -1852,7 +1852,7 @@
 	  .bInterfaceProtocol	= 0,
 	  .driver_info		= UVC_QUIRK_STREAM_NO_FID },
 	/* ViMicro Vega */
-	{ .match_flags		= USB_DEVICE_ID_MATCH_VENDOR
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
 	  .idVendor		= 0x0ac8,
 	  .idProduct		= 0x332d,
@@ -1861,7 +1861,7 @@
 	  .bInterfaceProtocol	= 0,
 	  .driver_info		= UVC_QUIRK_FIX_BANDWIDTH },
 	/* ViMicro - Minoru3D */
-	{ .match_flags		= USB_DEVICE_ID_MATCH_VENDOR
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
 	  .idVendor		= 0x0ac8,
 	  .idProduct		= 0x3410,
@@ -1870,7 +1870,7 @@
 	  .bInterfaceProtocol	= 0,
 	  .driver_info		= UVC_QUIRK_FIX_BANDWIDTH },
 	/* ViMicro Venus - Minoru3D */
-	{ .match_flags		= USB_DEVICE_ID_MATCH_VENDOR
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
 	  .idVendor		= 0x0ac8,
 	  .idProduct		= 0x3420,


