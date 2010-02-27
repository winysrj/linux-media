Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay01.digicable.hu ([92.249.128.189]:48322 "EHLO
	relay01.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966663Ab0B0AVG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Feb 2010 19:21:06 -0500
Message-ID: <4B88656D.1040902@freemail.hu>
Date: Sat, 27 Feb 2010 01:21:01 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>,
	Richard Purdie <rpurdie@rpsys.net>
CC: V4L Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/2] gspca pac7302: remove LED blinking when switching stream
 on and off
References: <4B84CCCB.1050908@freemail.hu>
In-Reply-To: <4B84CCCB.1050908@freemail.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

The init sequences for PAC7302 contained register settings affecting
the LED state which can result blinking of the LED when it is set to
always on or always off. The blinking happened when the stream was
switched on or off.

Remove the register changes from the init sequence and handle it with
the function set_streaming_led().

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
--- a/linux/drivers/media/video/gspca/pac7302.c.orig	2010-02-27 01:00:30.000000000 +0100
+++ b/linux/drivers/media/video/gspca/pac7302.c	2010-02-27 01:00:49.000000000 +0100
@@ -322,13 +322,6 @@
 #define END_OF_SEQUENCE		0

 /* pac 7302 */
-static const __u8 init_7302[] = {
-/*	index,value */
-	0xff, 0x01,		/* page 1 */
-	0x78, 0x00,		/* deactivate */
-	0xff, 0x01,
-	0x78, 0x40,		/* led off */
-};
 static const __u8 start_7302[] = {
 /*	index, len, [value]* */
 	0xff, 1,	0x00,		/* page 0 */
@@ -364,7 +357,8 @@
 	0xff, 1,	0x01,		/* page 1 */
 	0x12, 3,	0x02, 0x00, 0x01,
 	0x3e, 2,	0x00, 0x00,
-	0x76, 5,	0x01, 0x20, 0x40, 0x00, 0xf2,
+	0x76, 2,	0x01, 0x20,
+	0x79, 2,	0x00, 0xf2,
 	0x7c, 1,	0x00,
 	0x7f, 10,	0x4b, 0x0f, 0x01, 0x2c, 0x02, 0x58, 0x03, 0x20,
 			0x02, 0x00,
@@ -388,8 +382,6 @@
 	0x2a, 5,	0xc8, 0x00, 0x18, 0x12, 0x22,
 	0x64, 8,	0x00, 0x00, 0xf0, 0x01, 0x14, 0x44, 0x44, 0x44,
 	0x6e, 1,	0x08,
-	0xff, 1,	0x01,		/* page 1 */
-	0x78, 1,	0x00,
 	0, END_OF_SEQUENCE		/* end of sequence */
 };

@@ -487,15 +479,6 @@
 	}
 }

-static void reg_w_seq(struct gspca_dev *gspca_dev,
-		const __u8 *seq, int len)
-{
-	while (--len >= 0) {
-		reg_w(gspca_dev, seq[0], seq[1]);
-		seq += 2;
-	}
-}
-
 /* load the beginning of a page */
 static void reg_w_page(struct gspca_dev *gspca_dev,
 			const __u8 *page, int len)
@@ -787,7 +770,7 @@
 /* this function is called at probe and resume time for pac7302 */
 static int sd_init(struct gspca_dev *gspca_dev)
 {
-	reg_w_seq(gspca_dev, init_7302, sizeof(init_7302)/2);
+	set_streaming_led(gspca_dev, 0);
 	return gspca_dev->usb_err;
 }


