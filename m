Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34610 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932212AbaIRV5x (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Sep 2014 17:57:53 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [PATCH 2/3] omap3isp: Move starting the sensor from streamon IOCTL handler to VB2 QOP
Date: Fri, 19 Sep 2014 00:57:48 +0300
Message-Id: <1411077469-29178-3-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1411077469-29178-1-git-send-email-sakari.ailus@iki.fi>
References: <1411077469-29178-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move the starting of the sensor from the VIDIOC_STREAMON handler to the
videobuf2 queue op start_streaming. This avoids failing starting the stream
after vb2_streamon() has already finished.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/platform/omap3isp/ispvideo.c |   49 +++++++++++++++++-----------
 1 file changed, 30 insertions(+), 19 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index bc38c88..b233c8e 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -425,10 +425,40 @@ static void isp_video_buffer_queue(struct vb2_buffer *buf)
 	}
 }
 
+static int isp_video_start_streaming(struct vb2_queue *queue,
+				     unsigned int count)
+{
+	struct isp_video_fh *vfh = vb2_get_drv_priv(queue);
+	struct isp_video *video = vfh->video;
+	struct isp_pipeline *pipe = to_isp_pipeline(&video->video.entity);
+	unsigned long flags;
+	int ret;
+
+	/* In sensor-to-memory mode, the stream can be started synchronously
+	 * to the stream on command. In memory-to-memory mode, it will be
+	 * started when buffers are queued on both the input and output.
+	 */
+	if (pipe->input)
+		return 0;
+
+	ret = omap3isp_pipeline_set_stream(pipe,
+					   ISP_PIPELINE_STREAM_CONTINUOUS);
+	if (ret < 0)
+		return ret;
+
+	spin_lock_irqsave(&video->irqlock, flags);
+	if (list_empty(&video->dmaqueue))
+		video->dmaqueue_flags |= ISP_VIDEO_DMAQUEUE_UNDERRUN;
+	spin_unlock_irqrestore(&video->irqlock, flags);
+
+	return 0;
+}
+
 static const struct vb2_ops isp_video_queue_ops = {
 	.queue_setup = isp_video_queue_setup,
 	.buf_prepare = isp_video_buffer_prepare,
 	.buf_queue = isp_video_buffer_queue,
+	.start_streaming = isp_video_start_streaming,
 };
 
 /*
@@ -1077,28 +1107,9 @@ isp_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	if (ret < 0)
 		goto err_check_format;
 
-	/* In sensor-to-memory mode, the stream can be started synchronously
-	 * to the stream on command. In memory-to-memory mode, it will be
-	 * started when buffers are queued on both the input and output.
-	 */
-	if (pipe->input == NULL) {
-		ret = omap3isp_pipeline_set_stream(pipe,
-					      ISP_PIPELINE_STREAM_CONTINUOUS);
-		if (ret < 0)
-			goto err_set_stream;
-		spin_lock_irqsave(&video->irqlock, flags);
-		if (list_empty(&video->dmaqueue))
-			video->dmaqueue_flags |= ISP_VIDEO_DMAQUEUE_UNDERRUN;
-		spin_unlock_irqrestore(&video->irqlock, flags);
-	}
-
 	mutex_unlock(&video->stream_lock);
 	return 0;
 
-err_set_stream:
-	mutex_lock(&video->queue_lock);
-	vb2_streamoff(&vfh->queue, type);
-	mutex_unlock(&video->queue_lock);
 err_check_format:
 	media_entity_pipeline_stop(&video->video.entity);
 err_pipeline_start:
-- 
1.7.10.4

