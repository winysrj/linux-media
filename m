Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38683 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbaDUM3N (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Apr 2014 08:29:13 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v2 09/26] omap3isp: video: Set the buffer bytesused field at completion time
Date: Mon, 21 Apr 2014 14:28:55 +0200
Message-Id: <1398083352-8451-10-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1398083352-8451-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1398083352-8451-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The v4l buffer bytesused field is a value that will be returned to
userspace when the buffer gets dequeued. As such it doesn't need to be
set early at buffer queue time. Move the assignment to buffer completion
in the omap3isp_video_buffer_next() function to prepare for the video
buffers queue refactoring.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/ispvideo.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index 85b4036..e0f594f3 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -431,7 +431,6 @@ static int isp_video_buffer_prepare(struct isp_video_buffer *buf)
 		return -EINVAL;
 	}
 
-	buf->vbuf.bytesused = vfh->format.fmt.pix.sizeimage;
 	buffer->isp_addr = addr;
 	return 0;
 }
@@ -514,6 +513,8 @@ struct isp_buffer *omap3isp_video_buffer_next(struct isp_video *video)
 {
 	struct isp_pipeline *pipe = to_isp_pipeline(&video->video.entity);
 	struct isp_video_queue *queue = video->queue;
+	struct isp_video_fh *vfh =
+		container_of(queue, struct isp_video_fh, queue);
 	enum isp_pipeline_state state;
 	struct isp_video_buffer *buf;
 	unsigned long flags;
@@ -530,6 +531,8 @@ struct isp_buffer *omap3isp_video_buffer_next(struct isp_video *video)
 	list_del(&buf->irqlist);
 	spin_unlock_irqrestore(&queue->irqlock, flags);
 
+	buf->vbuf.bytesused = vfh->format.fmt.pix.sizeimage;
+
 	ktime_get_ts(&ts);
 	buf->vbuf.timestamp.tv_sec = ts.tv_sec;
 	buf->vbuf.timestamp.tv_usec = ts.tv_nsec / NSEC_PER_USEC;
-- 
1.8.3.2

