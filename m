Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:5762 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbZBTTiP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Feb 2009 14:38:15 -0500
Date: Fri, 20 Feb 2009 20:38:04 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Martin Samuelsson <sam@home.se>,
	Trent Piepho <xyzzy@speakeasy.org>
Subject: [PATCH] zoran: Drop the lock_norm module parameter
Message-ID: <20090220203804.73b97b0e@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The lock_norm module parameter doesn't look terribly useful. If you
don't want to change the norm, just don't change it. As a matter of
fact, no other v4l driver has such a parameter.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Trent Piepho <xyzzy@speakeasy.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
---
Hans, this goes on top of your v4l-dvb-zoran tree, if you like it.

 linux/Documentation/video4linux/Zoran          |    3 +--
 linux/drivers/media/video/zoran/zoran_driver.c |   20 --------------------
 2 files changed, 1 insertion(+), 22 deletions(-)

--- v4l-dvb-zoran.orig/linux/Documentation/video4linux/Zoran	2009-02-20 09:42:36.000000000 +0100
+++ v4l-dvb-zoran/linux/Documentation/video4linux/Zoran	2009-02-20 09:45:42.000000000 +0100
@@ -401,8 +401,7 @@ Additional notes for software developers
    first set the correct norm. Well, it seems logically correct: TV
    standard is "more constant" for current country than geometry
    settings of a variety of TV capture cards which may work in ITU or
-   square pixel format. Remember that users now can lock the norm to
-   avoid any ambiguity.
+   square pixel format.
 --
 Please note that lavplay/lavrec are also included in the MJPEG-tools
 (http://mjpeg.sf.net/).
--- v4l-dvb-zoran.orig/linux/drivers/media/video/zoran/zoran_driver.c	2009-02-20 09:42:47.000000000 +0100
+++ v4l-dvb-zoran/linux/drivers/media/video/zoran/zoran_driver.c	2009-02-20 09:45:42.000000000 +0100
@@ -163,10 +163,6 @@ const struct zoran_format zoran_formats[
 };
 #define NUM_FORMATS ARRAY_SIZE(zoran_formats)
 
-static int lock_norm;	/* 0 = default 1 = Don't change TV standard (norm) */
-module_param(lock_norm, int, 0644);
-MODULE_PARM_DESC(lock_norm, "Prevent norm changes (1 = ignore, >1 = fail)");
-
 	/* small helper function for calculating buffersizes for v4l2
 	 * we calculate the nearest higher power-of-two, which
 	 * will be the recommended buffersize */
@@ -1497,22 +1493,6 @@ zoran_set_norm (struct zoran *zr,
 		return -EBUSY;
 	}
 
-	if (lock_norm && norm != zr->norm) {
-		if (lock_norm > 1) {
-			dprintk(1,
-				KERN_WARNING
-				"%s: set_norm() - TV standard is locked, can not switch norm\n",
-				ZR_DEVNAME(zr));
-			return -EPERM;
-		} else {
-			dprintk(1,
-				KERN_WARNING
-				"%s: set_norm() - TV standard is locked, norm was not changed\n",
-				ZR_DEVNAME(zr));
-			norm = zr->norm;
-		}
-	}
-
 	if (!(norm & zr->card.norms)) {
 		dprintk(1,
 			KERN_ERR "%s: set_norm() - unsupported norm %llx\n",


-- 
Jean Delvare
