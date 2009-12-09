Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:38389 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754418AbZLIKKq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Dec 2009 05:10:46 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] Use dev->bus_id instead of dev_name in pre 2.6.26 kernels
Date: Wed, 9 Dec 2009 11:12:16 +0100
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200912091112.16352.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

dev_name() is not available before 2.6.26. Daily builds get particularly
noisy due to the function being called in include/media/v4l2-dev.h. Fix
this with a kernel version check instead of including compat.h as that
would increase compilation time.

Priority: normal
kernel-sync

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

diff -r 065f9e34e07b linux/include/media/v4l2-dev.h
--- a/linux/include/media/v4l2-dev.h	Mon Dec 07 10:08:33 2009 -0200
+++ b/linux/include/media/v4l2-dev.h	Wed Dec 09 11:04:51 2009 +0100
@@ -156,8 +156,12 @@
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 19)
 	return vdev->dev.class_id;
 #else
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 26)
+	return vdev->dev.bus_id;
+#else
 	return dev_name(&vdev->dev);
 #endif
+#endif
 }
 
 static inline int video_is_registered(struct video_device *vdev)

-- 
Laurent Pinchart
