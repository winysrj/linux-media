Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:51337 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751171Ab0CZHGm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Mar 2010 03:06:42 -0400
Received: from lyakh (helo=localhost)
	by axis700.grange with local-esmtp (Exim 4.63)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1Nv3cw-0001FP-9F
	for linux-media@vger.kernel.org; Fri, 26 Mar 2010 08:06:42 +0100
Date: Fri, 26 Mar 2010 08:06:42 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] V4L: fix ENUMSTD ioctl to report all supported standards
Message-ID: <Pine.LNX.4.64.1003260758550.4298@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

V4L2_STD_PAL, V4L2_STD_SECAM, and V4L2_STD_NTSC are not the only composite 
standards. Currently, e.g., if a driver supports all of V4L2_STD_PAL_B, 
V4L2_STD_PAL_B1 and V4L2_STD_PAL_G, the enumeration will report 
V4L2_STD_PAL_BG and not the single standards, which can confuse 
applications. Fix this by only clearing simple standards from the mask. 
This, of course, will only work, if composite standards are listed before 
simple ones in the standards array in v4l2-ioctl.c, which is currently 
the case.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 4b11257..2389df0 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -1065,9 +1065,7 @@ static long __video_do_ioctl(struct file *file,
 			j++;
 			if (curr_id == 0)
 				break;
-			if (curr_id != V4L2_STD_PAL &&
-			    curr_id != V4L2_STD_SECAM &&
-			    curr_id != V4L2_STD_NTSC)
+			if (is_power_of_2(curr_id))
 				id &= ~curr_id;
 		}
 		if (i <= index)
