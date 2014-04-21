Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38682 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326AbaDUM3W (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Apr 2014 08:29:22 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v2 23/26] omap3isp: Cancel all queued buffers when stopping the video stream
Date: Mon, 21 Apr 2014 14:29:09 +0200
Message-Id: <1398083352-8451-24-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1398083352-8451-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1398083352-8451-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When stopping a video stream the driver waits for ongoing DMA opeations
to complete for the currently active buffer, but doesn't release the
non-active queued buffers. This isn't a problem in most cases as the
video device is usually closed after the stream is stopped, which will
release all the buffers. However the problem would generate a warning
when switching to videobuf2. Fix it by cancelling all buffers after DMA
operations have completed.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/ispvideo.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index e1f9983..ffe56ad 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -1115,6 +1115,8 @@ isp_video_streamoff(struct file *file, void *fh, enum v4l2_buf_type type)
 
 	/* Stop the stream. */
 	omap3isp_pipeline_set_stream(pipe, ISP_PIPELINE_STREAM_STOPPED);
+	omap3isp_video_cancel_stream(video);
+
 	mutex_lock(&video->queue_lock);
 	omap3isp_video_queue_streamoff(&vfh->queue);
 	mutex_unlock(&video->queue_lock);
-- 
1.8.3.2

