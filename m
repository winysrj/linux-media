Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:49594 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932068Ab0AWNoR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Jan 2010 08:44:17 -0500
Message-ID: <4B5AFD2E.4080202@freemail.hu>
Date: Sat, 23 Jan 2010 14:44:14 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: V4L Mailing List <linux-media@vger.kernel.org>,
	mjpeg-users@lists.sourceforge.net
Subject: [PATCH] zoran: remove variable shadowing
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

The loop counter j is declared twice in function error_handler().
Remove the redundant declaration.

This will remove the following sparse warning (see "make C=1"):
 * symbol 'j' shadows an earlier one

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -r 2a50a0a1c951 linux/drivers/media/video/zoran/zoran_device.c
--- a/linux/drivers/media/video/zoran/zoran_device.c	Sat Jan 23 00:14:32 2010 -0200
+++ b/linux/drivers/media/video/zoran/zoran_device.c	Sat Jan 23 10:47:27 2010 +0100
@@ -1229,7 +1230,7 @@
 	       u32           astat,
 	       u32           stat)
 {
-	int i, j;
+	int i;

 	/* This is JPEG error handling part */
 	if (zr->codec_mode != BUZ_MODE_MOTION_COMPRESS &&
@@ -1280,6 +1281,7 @@
 	/* Report error */
 	if (zr36067_debug > 1 && zr->num_errors <= 8) {
 		long frame;
+		int j;

 		frame = zr->jpg_pend[zr->jpg_dma_tail & BUZ_MASK_FRAME];
 		printk(KERN_ERR

