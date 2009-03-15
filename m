Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:3785 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835AbZCOJU4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2009 05:20:56 -0400
Date: Sun, 15 Mar 2009 10:20:45 +0100
From: Jean Delvare <khali@linux-fr.org>
To: LMML <linux-media@vger.kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Trent Piepho <xyzzy@speakeasy.org>
Subject: [PATCH] Fix notify callback prototype
Message-ID: <20090315102045.5ea33d34@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I see the following warning when building the zoran driver:
v4l/zoran_card.c: In function 'zoran_probe':
v4l/zoran_card.c:1243: warning: assignment from incompatible pointer type

Fixing the notify callback prototype solves it.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Trent Piepho <xyzzy@speakeasy.org>
---
 linux/drivers/media/video/zoran/zoran_card.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- v4l-dvb.orig/linux/drivers/media/video/zoran/zoran_card.c	2009-03-15 10:09:47.000000000 +0100
+++ v4l-dvb/linux/drivers/media/video/zoran/zoran_card.c	2009-03-15 10:17:26.000000000 +0100
@@ -1197,7 +1197,7 @@ zoran_setup_videocodec (struct zoran *zr
 	return m;
 }
 
-static int zoran_subdev_notify(struct v4l2_subdev *sd, unsigned int cmd, void *arg)
+static void zoran_subdev_notify(struct v4l2_subdev *sd, unsigned int cmd, void *arg)
 {
 	struct zoran *zr = to_zoran(sd->v4l2_dev);
 
@@ -1207,7 +1207,6 @@ static int zoran_subdev_notify(struct v4
 		GPIO(zr, 7, 0);
 	else if (cmd == BT819_FIFO_RESET_HIGH)
 		GPIO(zr, 7, 1);
-	return 0;
 }
 
 /*


-- 
Jean Delvare
