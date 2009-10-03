Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01a.mail.t-online.hu ([84.2.40.6]:49158 "EHLO
	mail01a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754769AbZJCSMO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Oct 2009 14:12:14 -0400
Message-ID: <4AC793D5.3010305@freemail.hu>
Date: Sat, 03 Oct 2009 20:11:33 +0200
From: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>,
	Thomas Kaiser <thomas@kaiser-linux.li>
CC: V4L Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] pac7311: add comment about JPEG header
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

Add comment about the meaning of the fixed JPEG header bytes used to
create each image.

The change was tested with Labtec Webcam 2200.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -upr e/drivers/media/video/gspca/pac7311.c f/drivers/media/video/gspca/pac7311.c
--- e/drivers/media/video/gspca/pac7311.c	2009-10-03 16:23:37.000000000 +0200
+++ f/drivers/media/video/gspca/pac7311.c	2009-10-03 19:56:21.000000000 +0200
@@ -801,13 +801,32 @@ static void do_autogain(struct gspca_dev
 		sd->autogain_ignore_frames = PAC_AUTOGAIN_IGNORE_FRAMES;
 }

+/* JPEG header, part 1 */
 static const unsigned char pac7311_jpeg_header1[] = {
-  0xff, 0xd8, 0xff, 0xc0, 0x00, 0x11, 0x08
+  0xff, 0xd8,		/* SOI: Start of Image */
+
+  0xff, 0xc0,		/* SOF0: Start of Frame (Baseline DCT) */
+  0x00, 0x11,		/* length = 17 bytes (including this length field) */
+  0x08			/* Precision: 8 */
+  /* 2 bytes is placed here: number of image lines */
+  /* 2 bytes is placed here: samples per line */
 };

+/* JPEG header, continued */
 static const unsigned char pac7311_jpeg_header2[] = {
-  0x03, 0x01, 0x21, 0x00, 0x02, 0x11, 0x01, 0x03, 0x11, 0x01, 0xff, 0xda,
-  0x00, 0x0c, 0x03, 0x01, 0x00, 0x02, 0x11, 0x03, 0x11, 0x00, 0x3f, 0x00
+  0x03,			/* Number of image components: 3 */
+  0x01, 0x21, 0x00,	/* ID=1, Subsampling 1x1, Quantization table: 0 */
+  0x02, 0x11, 0x01,	/* ID=2, Subsampling 2x1, Quantization table: 1 */
+  0x03, 0x11, 0x01,	/* ID=3, Subsampling 2x1, Quantization table: 1 */
+
+  0xff, 0xda,		/* SOS: Start Of Scan */
+  0x00, 0x0c,		/* length = 12 bytes (including this length field) */
+  0x03,			/* number of components: 3 */
+  0x01, 0x00,		/* selector 1, table 0x00 */
+  0x02, 0x11,		/* selector 2, table 0x11 */
+  0x03, 0x11,		/* selector 3, table 0x11 */
+  0x00, 0x3f,		/* Spectral selection: 0 .. 63 */
+  0x00			/* Successive approximation: 0 */
 };

 /* this function is run at interrupt level */
