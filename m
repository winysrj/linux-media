Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34613 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932706AbaIRV5x (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Sep 2014 17:57:53 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [PATCH 3/3] omap3isp: Return buffers back to videobuf2 if pipeline streamon fails
Date: Fri, 19 Sep 2014 00:57:49 +0300
Message-Id: <1411077469-29178-4-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1411077469-29178-1-git-send-email-sakari.ailus@iki.fi>
References: <1411077469-29178-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When the video buffer queue was stopped before the stream source was started
in omap3isp_streamon(), the buffers were not returned back to videobuf2.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/platform/omap3isp/isp.c      |    4 ++--
 drivers/media/platform/omap3isp/ispvideo.c |   16 ++++++++++------
 drivers/media/platform/omap3isp/ispvideo.h |    3 ++-
 3 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 72265e5..2aa0a8e 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -1062,9 +1062,9 @@ int omap3isp_pipeline_set_stream(struct isp_pipeline *pipe,
 void omap3isp_pipeline_cancel_stream(struct isp_pipeline *pipe)
 {
 	if (pipe->input)
-		omap3isp_video_cancel_stream(pipe->input);
+		omap3isp_video_cancel_stream(pipe->input, VB2_BUF_STATE_ERROR);
 	if (pipe->output)
-		omap3isp_video_cancel_stream(pipe->output);
+		omap3isp_video_cancel_stream(pipe->output, VB2_BUF_STATE_ERROR);
 }
 
 /*
diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index b233c8e..73c0194 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -443,8 +443,10 @@ static int isp_video_start_streaming(struct vb2_queue *queue,
 
 	ret = omap3isp_pipeline_set_stream(pipe,
 					   ISP_PIPELINE_STREAM_CONTINUOUS);
-	if (ret < 0)
+	if (ret < 0) {
+		omap3isp_video_cancel_stream(video, VB2_BUF_STATE_QUEUED);
 		return ret;
+	}
 
 	spin_lock_irqsave(&video->irqlock, flags);
 	if (list_empty(&video->dmaqueue))
@@ -566,10 +568,12 @@ struct isp_buffer *omap3isp_video_buffer_next(struct isp_video *video)
  * omap3isp_video_cancel_stream - Cancel stream on a video node
  * @video: ISP video object
  *
- * Cancelling a stream mark all buffers on the video node as erroneous and makes
- * sure no new buffer can be queued.
+ * Cancelling a stream mark all buffers on the video node as erroneous
+ * and makes sure no new buffer can be queued. Buffers are returned
+ * back to videobuf2 in the given state.
  */
-void omap3isp_video_cancel_stream(struct isp_video *video)
+void omap3isp_video_cancel_stream(struct isp_video *video,
+				  enum vb2_buffer_state state)
 {
 	unsigned long flags;
 
@@ -581,7 +585,7 @@ void omap3isp_video_cancel_stream(struct isp_video *video)
 		buf = list_first_entry(&video->dmaqueue,
 				       struct isp_buffer, irqlist);
 		list_del(&buf->irqlist);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb, state);
 	}
 
 	video->error = true;
@@ -1166,7 +1170,7 @@ isp_video_streamoff(struct file *file, void *fh, enum v4l2_buf_type type)
 
 	/* Stop the stream. */
 	omap3isp_pipeline_set_stream(pipe, ISP_PIPELINE_STREAM_STOPPED);
-	omap3isp_video_cancel_stream(video);
+	omap3isp_video_cancel_stream(video, VB2_BUF_STATE_ERROR);
 
 	mutex_lock(&video->queue_lock);
 	vb2_streamoff(&vfh->queue, type);
diff --git a/drivers/media/platform/omap3isp/ispvideo.h b/drivers/media/platform/omap3isp/ispvideo.h
index 0b7efed..7e4732a 100644
--- a/drivers/media/platform/omap3isp/ispvideo.h
+++ b/drivers/media/platform/omap3isp/ispvideo.h
@@ -201,7 +201,8 @@ int omap3isp_video_register(struct isp_video *video,
 			    struct v4l2_device *vdev);
 void omap3isp_video_unregister(struct isp_video *video);
 struct isp_buffer *omap3isp_video_buffer_next(struct isp_video *video);
-void omap3isp_video_cancel_stream(struct isp_video *video);
+void omap3isp_video_cancel_stream(struct isp_video *video,
+				  enum vb2_buffer_state state);
 void omap3isp_video_resume(struct isp_video *video, int continuous);
 struct media_pad *omap3isp_video_remote_pad(struct isp_video *video);
 
-- 
1.7.10.4

