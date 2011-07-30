Return-path: <linux-media-owner@vger.kernel.org>
Received: from que21.charter.net ([209.225.8.22]:48398 "EHLO que21.charter.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419Ab1G3Pp6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Jul 2011 11:45:58 -0400
From: Greg Dietsche <Gregory.Dietsche@cuw.edu>
To: laurent.pinchart@ideasonboard.com
Cc: mchehab@infradead.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, trivial@kernel.org,
	jpiszcz@lucidpixels.com, Greg Dietsche <Gregory.Dietsche@cuw.edu>
Subject: [PATCH] uvcvideo: correct kernel version reference
Date: Sat, 30 Jul 2011 10:47:30 -0500
Message-Id: <1312040850-21475-1-git-send-email-Gregory.Dietsche@cuw.edu>
In-Reply-To: <alpine.DEB.2.02.1107301020220.4925@p34.internal.lan>
References: <alpine.DEB.2.02.1107301020220.4925@p34.internal.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

change from v2.6.42 to v3.2

Reported-by: Justin Piszcz <jpiszcz@lucidpixels.com>
Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
---
 drivers/media/video/uvc/uvc_v4l2.c |    2 +-
 drivers/media/video/uvc/uvcvideo.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_v4l2.c b/drivers/media/video/uvc/uvc_v4l2.c
index ea71d5f..6d6e3f9 100644
--- a/drivers/media/video/uvc/uvc_v4l2.c
+++ b/drivers/media/video/uvc/uvc_v4l2.c
@@ -546,7 +546,7 @@ static void uvc_v4l2_ioctl_warn(void)
 		return;
 
 	uvc_printk(KERN_INFO, "Deprecated UVCIOC_CTRL_{ADD,MAP_OLD,GET,SET} "
-		   "ioctls will be removed in 2.6.42.\n");
+		   "ioctls will be removed in 3.2.\n");
 	uvc_printk(KERN_INFO, "See http://www.ideasonboard.org/uvc/upgrade/ "
 		   "for upgrade instructions.\n");
 	warned = 1;
diff --git a/drivers/media/video/uvc/uvcvideo.h b/drivers/media/video/uvc/uvcvideo.h
index df32a43..4419c34 100644
--- a/drivers/media/video/uvc/uvcvideo.h
+++ b/drivers/media/video/uvc/uvcvideo.h
@@ -7,7 +7,7 @@
 #ifndef __KERNEL__
 /*
  * This header provides binary compatibility with applications using the private
- * uvcvideo API. This API is deprecated and will be removed in 2.6.42.
+ * uvcvideo API. This API is deprecated and will be removed in 3.2.
  * Applications should be recompiled against the public linux/uvcvideo.h header.
  */
 #warn "The uvcvideo.h header is deprecated, use linux/uvcvideo.h instead."
-- 
1.7.2.5

