Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail02a.mail.t-online.hu ([84.2.40.7]:52008 "EHLO
	mail02a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760Ab0AWG60 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Jan 2010 01:58:26 -0500
Message-ID: <4B5A9E0C.8090907@freemail.hu>
Date: Sat, 23 Jan 2010 07:58:20 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: V4L Mailing List <linux-media@vger.kernel.org>,
	mjpeg-users@lists.sourceforge.net
Subject: [PATCH] zoran: match parameter signedness of g_input_status
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

The second parameter of g_input_status operation in <media/v4l2-subdev.h>
is unsigned so also call it with unsigned paramter.

This will remove the following sparse warning (see "make C=1"):
 * incorrect type in argument 2 (different signedness)
       expected unsigned int [usertype] *status
       got int *<noident>

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -r 2a50a0a1c951 linux/drivers/media/video/zoran/zoran_device.c
--- a/linux/drivers/media/video/zoran/zoran_device.c	Sat Jan 23 00:14:32 2010 -0200
+++ b/linux/drivers/media/video/zoran/zoran_device.c	Sat Jan 23 07:57:09 2010 +0100
@@ -1197,7 +1197,8 @@
 static void zoran_restart(struct zoran *zr)
 {
 	/* Now the stat_comm buffer is ready for restart */
-	int status = 0, mode;
+	unsigned int status = 0;
+	int mode;

 	if (zr->codec_mode == BUZ_MODE_MOTION_COMPRESS) {
 		decoder_call(zr, video, g_input_status, &status);
diff -r 2a50a0a1c951 linux/drivers/media/video/zoran/zoran_driver.c
--- a/linux/drivers/media/video/zoran/zoran_driver.c	Sat Jan 23 00:14:32 2010 -0200
+++ b/linux/drivers/media/video/zoran/zoran_driver.c	Sat Jan 23 07:57:09 2010 +0100
@@ -1452,7 +1452,7 @@
 	}

 	if (norm == V4L2_STD_ALL) {
-		int status = 0;
+		unsigned int status = 0;
 		v4l2_std_id std = 0;

 		decoder_call(zr, video, querystd, &std);

