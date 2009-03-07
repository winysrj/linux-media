Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:2571 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbZCGKJW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Mar 2009 05:09:22 -0500
Date: Sat, 7 Mar 2009 11:09:14 +0100
From: Jean Delvare <khali@linux-fr.org>
To: LMML <linux-media@vger.kernel.org>
Cc: Trent Piepho <xyzzy@speakeasy.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] zoran: Don't frighten users with failed buffer allocation
Message-ID: <20090307110914.5f35d4d2@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

kmalloc() can fail for large video buffers. By default the kernel
complains loudly about allocation failures, but we don't want to
frighten the user, so ask kmalloc() to keep quiet on such failures.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Trent Piepho <xyzzy@speakeasy.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
---
 linux/drivers/media/video/zoran/zoran_driver.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- v4l-dvb.orig/linux/drivers/media/video/zoran/zoran_driver.c	2009-03-02 11:19:20.000000000 +0100
+++ v4l-dvb/linux/drivers/media/video/zoran/zoran_driver.c	2009-03-02 11:19:21.000000000 +0100
@@ -212,7 +212,8 @@ v4l_fbuffer_alloc (struct file *file)
 				ZR_DEVNAME(zr), i);
 
 		//udelay(20);
-		mem = kmalloc(fh->v4l_buffers.buffer_size, GFP_KERNEL);
+		mem = kmalloc(fh->v4l_buffers.buffer_size,
+			      GFP_KERNEL | __GFP_NOWARN);
 		if (!mem) {
 			dprintk(1,
 				KERN_ERR


-- 
Jean Delvare
