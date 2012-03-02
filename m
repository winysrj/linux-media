Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:37126 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932428Ab2CBRc4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Mar 2012 12:32:56 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, dacohen@gmail.com,
	snjw23@gmail.com, andriy.shevchenko@linux.intel.com,
	t.stanislaws@samsung.com, tuukkat76@gmail.com,
	k.debski@samsung.com, riverful@gmail.com, hverkuil@xs4all.nl,
	teturtia@gmail.com
Subject: [PATCH v4 23/34] omap3isp: Move setting constaints above media_entity_pipeline_start
Date: Fri,  2 Mar 2012 19:30:31 +0200
Message-Id: <1330709442-16654-23-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20120302173219.GA15695@valkosipuli.localdomain>
References: <20120302173219.GA15695@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The clock rate for l3_ick is will soon be read during pipeline validation
which is now part of media_entity_pipeline_start(). For that reason we set
constraints earlier on.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/video/omap3isp/ispvideo.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispvideo.c b/drivers/media/video/omap3isp/ispvideo.c
index c191f13..b0d541b 100644
--- a/drivers/media/video/omap3isp/ispvideo.c
+++ b/drivers/media/video/omap3isp/ispvideo.c
@@ -304,8 +304,6 @@ static int isp_video_validate_pipeline(struct isp_pipeline *pipe)
 	struct v4l2_subdev *subdev;
 	int ret;
 
-	pipe->max_rate = pipe->l3_ick;
-
 	subdev = isp_video_remote_subdev(pipe->output, NULL);
 	if (subdev == NULL)
 		return -EPIPE;
@@ -993,6 +991,12 @@ isp_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	 */
 	pipe = video->video.entity.pipe
 	     ? to_isp_pipeline(&video->video.entity) : &video->pipe;
+
+	if (video->isp->pdata->set_constraints)
+		video->isp->pdata->set_constraints(video->isp, true);
+	pipe->l3_ick = clk_get_rate(video->isp->clock[ISP_CLK_L3_ICK]);
+	pipe->max_rate = pipe->l3_ick;
+
 	media_entity_pipeline_start(&video->video.entity, &pipe->pipe);
 
 	/* Verify that the currently configured format matches the output of
@@ -1025,10 +1029,6 @@ isp_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 		pipe->output = far_end;
 	}
 
-	if (video->isp->pdata->set_constraints)
-		video->isp->pdata->set_constraints(video->isp, true);
-	pipe->l3_ick = clk_get_rate(video->isp->clock[ISP_CLK_L3_ICK]);
-
 	/* Validate the pipeline and update its state. */
 	ret = isp_video_validate_pipeline(pipe);
 	if (ret < 0)
@@ -1074,9 +1074,9 @@ isp_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 error:
 	if (ret < 0) {
 		omap3isp_video_queue_streamoff(&vfh->queue);
+		media_entity_pipeline_stop(&video->video.entity);
 		if (video->isp->pdata->set_constraints)
 			video->isp->pdata->set_constraints(video->isp, false);
-		media_entity_pipeline_stop(&video->video.entity);
 		/* The DMA queue must be emptied here, otherwise CCDC interrupts
 		 * that will get triggered the next time the CCDC is powered up
 		 * will try to access buffers that might have been freed but
-- 
1.7.2.5

