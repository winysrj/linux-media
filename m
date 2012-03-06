Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:22310 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756905Ab2CFQd3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Mar 2012 11:33:29 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, dacohen@gmail.com,
	snjw23@gmail.com, andriy.shevchenko@linux.intel.com,
	t.stanislaws@samsung.com, tuukkat76@gmail.com,
	k.debski@samsung.com, riverful@gmail.com, hverkuil@xs4all.nl,
	teturtia@gmail.com, pradeep.sawlani@gmail.com
Subject: [PATCH v5 23/35] omap3isp: Assume media_entity_pipeline_start may fail
Date: Tue,  6 Mar 2012 18:33:04 +0200
Message-Id: <1331051596-8261-23-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20120306163239.GN1075@valkosipuli.localdomain>
References: <20120306163239.GN1075@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since media_entity_pipeline_start() now does link validation, it may
actually fail. Perform the error handling.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/video/omap3isp/ispvideo.c |   52 ++++++++++++++++--------------
 1 files changed, 28 insertions(+), 24 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispvideo.c b/drivers/media/video/omap3isp/ispvideo.c
index b0d541b..d34f690 100644
--- a/drivers/media/video/omap3isp/ispvideo.c
+++ b/drivers/media/video/omap3isp/ispvideo.c
@@ -997,14 +997,16 @@ isp_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	pipe->l3_ick = clk_get_rate(video->isp->clock[ISP_CLK_L3_ICK]);
 	pipe->max_rate = pipe->l3_ick;
 
-	media_entity_pipeline_start(&video->video.entity, &pipe->pipe);
+	ret = media_entity_pipeline_start(&video->video.entity, &pipe->pipe);
+	if (ret < 0)
+		goto err_pipeline_start;
 
 	/* Verify that the currently configured format matches the output of
 	 * the connected subdev.
 	 */
 	ret = isp_video_check_format(video, vfh);
 	if (ret < 0)
-		goto error;
+		goto err_check_format;
 
 	video->bpl_padding = ret;
 	video->bpl_value = vfh->format.fmt.pix.bytesperline;
@@ -1021,7 +1023,7 @@ isp_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	} else {
 		if (far_end == NULL) {
 			ret = -EPIPE;
-			goto error;
+			goto err_check_format;
 		}
 
 		state = ISP_PIPELINE_STREAM_INPUT | ISP_PIPELINE_IDLE_INPUT;
@@ -1032,7 +1034,7 @@ isp_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	/* Validate the pipeline and update its state. */
 	ret = isp_video_validate_pipeline(pipe);
 	if (ret < 0)
-		goto error;
+		goto err_check_format;
 
 	pipe->error = false;
 
@@ -1054,7 +1056,7 @@ isp_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 
 	ret = omap3isp_video_queue_streamon(&vfh->queue);
 	if (ret < 0)
-		goto error;
+		goto err_check_format;
 
 	/* In sensor-to-memory mode, the stream can be started synchronously
 	 * to the stream on command. In memory-to-memory mode, it will be
@@ -1064,32 +1066,34 @@ isp_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 		ret = omap3isp_pipeline_set_stream(pipe,
 					      ISP_PIPELINE_STREAM_CONTINUOUS);
 		if (ret < 0)
-			goto error;
+			goto err_set_stream;
 		spin_lock_irqsave(&video->queue->irqlock, flags);
 		if (list_empty(&video->dmaqueue))
 			video->dmaqueue_flags |= ISP_VIDEO_DMAQUEUE_UNDERRUN;
 		spin_unlock_irqrestore(&video->queue->irqlock, flags);
 	}
 
-error:
-	if (ret < 0) {
-		omap3isp_video_queue_streamoff(&vfh->queue);
-		media_entity_pipeline_stop(&video->video.entity);
-		if (video->isp->pdata->set_constraints)
-			video->isp->pdata->set_constraints(video->isp, false);
-		/* The DMA queue must be emptied here, otherwise CCDC interrupts
-		 * that will get triggered the next time the CCDC is powered up
-		 * will try to access buffers that might have been freed but
-		 * still present in the DMA queue. This can easily get triggered
-		 * if the above omap3isp_pipeline_set_stream() call fails on a
-		 * system with a free-running sensor.
-		 */
-		INIT_LIST_HEAD(&video->dmaqueue);
-		video->queue = NULL;
-	}
+	video->streaming = 1;
+
+	mutex_unlock(&video->stream_lock);
+	return 0;
 
-	if (!ret)
-		video->streaming = 1;
+err_set_stream:
+	omap3isp_video_queue_streamoff(&vfh->queue);
+err_check_format:
+	media_entity_pipeline_stop(&video->video.entity);
+err_pipeline_start:
+	if (video->isp->pdata->set_constraints)
+		video->isp->pdata->set_constraints(video->isp, false);
+	/* The DMA queue must be emptied here, otherwise CCDC interrupts that
+	 * will get triggered the next time the CCDC is powered up will try to
+	 * access buffers that might have been freed but still present in the
+	 * DMA queue. This can easily get triggered if the above
+	 * omap3isp_pipeline_set_stream() call fails on a system with a
+	 * free-running sensor.
+	 */
+	INIT_LIST_HEAD(&video->dmaqueue);
+	video->queue = NULL;
 
 	mutex_unlock(&video->stream_lock);
 	return ret;
-- 
1.7.2.5

