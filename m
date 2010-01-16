Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:49322 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361Ab0APRIr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jan 2010 12:08:47 -0500
Message-ID: <4B51F297.7020405@freemail.hu>
Date: Sat, 16 Jan 2010 18:08:39 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Mike Bernson <mike@mlb.org>, Serguei Miridonov <mirsev@cicese.mx>,
	Ronald Bultje <rbultje@ronald.bitfreak.net>
CC: V4L Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] bt819: cleanup v4l2_subdev_notify() parameters
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

The 3rd parameter v4l2_subdev_notify() is passed to the notify() callback
which is a pointer, see <media/v4l2-subdev.h> and <media/v4l2-device.h>.

This will remove the following sparse warning (see "make C=1"):
 * Using plain integer as NULL pointer

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -r 5bcdcc072b6d linux/drivers/media/video/bt819.c
--- a/linux/drivers/media/video/bt819.c	Sat Jan 16 07:25:43 2010 +0100
+++ b/linux/drivers/media/video/bt819.c	Sat Jan 16 18:04:27 2010 +0100
@@ -260,7 +260,7 @@
 		v4l2_err(sd, "no notify found!\n");

 	if (std & V4L2_STD_NTSC) {
-		v4l2_subdev_notify(sd, BT819_FIFO_RESET_LOW, 0);
+		v4l2_subdev_notify(sd, BT819_FIFO_RESET_LOW, NULL);
 		bt819_setbit(decoder, 0x01, 0, 1);
 		bt819_setbit(decoder, 0x01, 1, 0);
 		bt819_setbit(decoder, 0x01, 5, 0);
@@ -269,7 +269,7 @@
 		/* bt819_setbit(decoder, 0x1a,  5, 1); */
 		timing = &timing_data[1];
 	} else if (std & V4L2_STD_PAL) {
-		v4l2_subdev_notify(sd, BT819_FIFO_RESET_LOW, 0);
+		v4l2_subdev_notify(sd, BT819_FIFO_RESET_LOW, NULL);
 		bt819_setbit(decoder, 0x01, 0, 1);
 		bt819_setbit(decoder, 0x01, 1, 1);
 		bt819_setbit(decoder, 0x01, 5, 1);
@@ -294,7 +294,7 @@
 	bt819_write(decoder, 0x08, (timing->hscale >> 8) & 0xff);
 	bt819_write(decoder, 0x09, timing->hscale & 0xff);
 	decoder->norm = std;
-	v4l2_subdev_notify(sd, BT819_FIFO_RESET_HIGH, 0);
+	v4l2_subdev_notify(sd, BT819_FIFO_RESET_HIGH, NULL);
 	return 0;
 }

@@ -312,7 +312,7 @@
 		v4l2_err(sd, "no notify found!\n");

 	if (decoder->input != input) {
-		v4l2_subdev_notify(sd, BT819_FIFO_RESET_LOW, 0);
+		v4l2_subdev_notify(sd, BT819_FIFO_RESET_LOW, NULL);
 		decoder->input = input;
 		/* select mode */
 		if (decoder->input == 0) {
@@ -322,7 +322,7 @@
 			bt819_setbit(decoder, 0x0b, 6, 1);
 			bt819_setbit(decoder, 0x1a, 1, 0);
 		}
-		v4l2_subdev_notify(sd, BT819_FIFO_RESET_HIGH, 0);
+		v4l2_subdev_notify(sd, BT819_FIFO_RESET_HIGH, NULL);
 	}
 	return 0;
 }
