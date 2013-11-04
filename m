Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52706 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632Ab3KDOCg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Nov 2013 09:02:36 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH v2] v4l: omap3isp: Don't check for missing get_fmt op on remote subdev
Date: Mon,  4 Nov 2013 15:03:02 +0100
Message-Id: <1383573782-3599-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The remote subdev of any video node in the OMAP3 ISP is an internal
subdev that is guaranteed to implement get_fmt. Don't check the return
value for -ENOIOCTLCMD, as this can't happen.

While at it, move non-critical code out of the mutex-protected section.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/ispvideo.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index a908d00..f6304bb 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -339,14 +339,11 @@ __isp_video_get_format(struct isp_video *video, struct v4l2_format *format)
 	if (subdev == NULL)
 		return -EINVAL;
 
-	mutex_lock(&video->mutex);
-
 	fmt.pad = pad;
 	fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
-	ret = v4l2_subdev_call(subdev, pad, get_fmt, NULL, &fmt);
-	if (ret == -ENOIOCTLCMD)
-		ret = -EINVAL;
 
+	mutex_lock(&video->mutex);
+	ret = v4l2_subdev_call(subdev, pad, get_fmt, NULL, &fmt);
 	mutex_unlock(&video->mutex);
 
 	if (ret)
-- 
Regards,

Laurent Pinchart

