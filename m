Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40783 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755319AbbCMAb2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2015 20:31:28 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH] media: omap3isp: video: Use v4l2_get_timestamp()
Date: Fri, 13 Mar 2015 02:31:27 +0200
Message-Id: <1426206687-14340-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace the open-coded copy by a function call.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/ispvideo.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index 3de8d5d..0b5967e 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -452,7 +452,6 @@ struct isp_buffer *omap3isp_video_buffer_next(struct isp_video *video)
 	enum isp_pipeline_state state;
 	struct isp_buffer *buf;
 	unsigned long flags;
-	struct timespec ts;
 
 	spin_lock_irqsave(&video->irqlock, flags);
 	if (WARN_ON(list_empty(&video->dmaqueue))) {
@@ -465,9 +464,7 @@ struct isp_buffer *omap3isp_video_buffer_next(struct isp_video *video)
 	list_del(&buf->irqlist);
 	spin_unlock_irqrestore(&video->irqlock, flags);
 
-	ktime_get_ts(&ts);
-	buf->vb.v4l2_buf.timestamp.tv_sec = ts.tv_sec;
-	buf->vb.v4l2_buf.timestamp.tv_usec = ts.tv_nsec / NSEC_PER_USEC;
+	v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
 
 	/* Do frame number propagation only if this is the output video node.
 	 * Frame number either comes from the CSI receivers or it gets
-- 
Regards,

Laurent Pinchart

