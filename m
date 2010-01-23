Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail02d.mail.t-online.hu ([84.2.42.7]:59813 "EHLO
	mail02d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755028Ab0AWNoi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Jan 2010 08:44:38 -0500
Message-ID: <4B5AFD42.6080001@freemail.hu>
Date: Sat, 23 Jan 2010 14:44:34 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Janne Grunau <j@jannau.net>
CC: V4L Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] hdpvr-video: cleanup signedness
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

The fifth parameter of usb_bulk_msg() is a pointer to signed
(see <linux/usb.h>) so also call this function with pointer to signed.

This will remove the following sparse warning (see "make C=1"):
 * warning: incorrect type in argument 5 (different signedness)
       expected int *actual_length
       got unsigned int *<noident>

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -r 2a50a0a1c951 linux/drivers/media/video/hdpvr/hdpvr-video.c
--- a/linux/drivers/media/video/hdpvr/hdpvr-video.c	Sat Jan 23 00:14:32 2010 -0200
+++ b/linux/drivers/media/video/hdpvr/hdpvr-video.c	Sat Jan 23 11:43:17 2010 +0100
@@ -302,7 +302,8 @@
 /* function expects dev->io_mutex to be hold by caller */
 static int hdpvr_stop_streaming(struct hdpvr_device *dev)
 {
-	uint actual_length, c = 0;
+	int actual_length;
+	uint c = 0;
 	u8 *buf;

 	if (dev->status == STATUS_IDLE)

