Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:11285 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904AbZLOCpQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Dec 2009 21:45:16 -0500
Received: by fg-out-1718.google.com with SMTP id e21so238199fga.1
        for <linux-media@vger.kernel.org>; Mon, 14 Dec 2009 18:45:14 -0800 (PST)
Message-ID: <4B27063C.6020200@royalhat.org>
Date: Tue, 15 Dec 2009 03:45:00 +0000
From: Luis Maia <lmaia@royalhat.org>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: PATCH- gspca: added chipset revision sensor
Content-Type: multipart/mixed;
 boundary="------------090602070905010404020202"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090602070905010404020202
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

Added extra chipset revision (sensor) to fix camera zc0301 with  ID: 
0ac8:301b .
Since i own one of this cameras fixed and tested it.

Best Regards,
Luis Maia

-------------

diff -uNr linux-2.6.32.1/drivers/media/video/gspca/zc3xx.c 
linux-2.6.32.1-patch/drivers/media/video/gspca/zc3xx.c
--- linux-2.6.32.1/drivers/media/video/gspca/zc3xx.c    2009-12-14 
17:47:25.000000000 +0000
+++ linux-2.6.32.1-patch/drivers/media/video/gspca/zc3xx.c    2009-12-15 
02:42:13.000000000 +0000
@@ -6868,6 +6868,7 @@
     {0x8001, 0x13},
     {0x8000, 0x14},        /* CS2102K */
     {0x8400, 0x15},        /* TAS5130K */
+    {0xe400, 0x15},
 };
 
 static int vga_3wr_probe(struct gspca_dev *gspca_dev)
@@ -7634,7 +7635,7 @@
     {USB_DEVICE(0x0698, 0x2003)},
     {USB_DEVICE(0x0ac8, 0x0301), .driver_info = SENSOR_PAS106},
     {USB_DEVICE(0x0ac8, 0x0302), .driver_info = SENSOR_PAS106},
-    {USB_DEVICE(0x0ac8, 0x301b)},
+    {USB_DEVICE(0x0ac8, 0x301b), .driver_info = SENSOR_PB0330},
     {USB_DEVICE(0x0ac8, 0x303b)},
     {USB_DEVICE(0x0ac8, 0x305b), .driver_info = SENSOR_TAS5130C_VF0250},
     {USB_DEVICE(0x0ac8, 0x307b)},


--------------090602070905010404020202
Content-Type: text/plain;
 name="patchfile"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patchfile"

diff -uNr linux-2.6.32.1/drivers/media/video/gspca/zc3xx.c linux-2.6.32.1-patch/drivers/media/video/gspca/zc3xx.c
--- linux-2.6.32.1/drivers/media/video/gspca/zc3xx.c	2009-12-14 17:47:25.000000000 +0000
+++ linux-2.6.32.1-patch/drivers/media/video/gspca/zc3xx.c	2009-12-15 02:42:13.000000000 +0000
@@ -6868,6 +6868,7 @@
 	{0x8001, 0x13},
 	{0x8000, 0x14},		/* CS2102K */
 	{0x8400, 0x15},		/* TAS5130K */
+	{0xe400, 0x15},
 };
 
 static int vga_3wr_probe(struct gspca_dev *gspca_dev)
@@ -7634,7 +7635,7 @@
 	{USB_DEVICE(0x0698, 0x2003)},
 	{USB_DEVICE(0x0ac8, 0x0301), .driver_info = SENSOR_PAS106},
 	{USB_DEVICE(0x0ac8, 0x0302), .driver_info = SENSOR_PAS106},
-	{USB_DEVICE(0x0ac8, 0x301b)},
+	{USB_DEVICE(0x0ac8, 0x301b), .driver_info = SENSOR_PB0330},
 	{USB_DEVICE(0x0ac8, 0x303b)},
 	{USB_DEVICE(0x0ac8, 0x305b), .driver_info = SENSOR_TAS5130C_VF0250},
 	{USB_DEVICE(0x0ac8, 0x307b)},


--------------090602070905010404020202--
