Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:21589 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933994Ab2AKV1U (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jan 2012 16:27:20 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	teturtia@gmail.com, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@gmail.com, riverful@gmail.com
Subject: [PATCH 19/23] omap3isp: Default error handling for ccp2, csi2, preview and resizer
Date: Wed, 11 Jan 2012 23:26:56 +0200
Message-Id: <1326317220-15339-19-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <4F0DFE92.80102@iki.fi>
References: <4F0DFE92.80102@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/video/omap3isp/ispccp2.c    |    2 ++
 drivers/media/video/omap3isp/ispcsi2.c    |    2 ++
 drivers/media/video/omap3isp/isppreview.c |    2 ++
 drivers/media/video/omap3isp/ispresizer.c |    2 ++
 drivers/media/video/omap3isp/ispvideo.c   |   18 ++++++++----------
 5 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispccp2.c b/drivers/media/video/omap3isp/ispccp2.c
index 904ca8c..ab0b4db 100644
--- a/drivers/media/video/omap3isp/ispccp2.c
+++ b/drivers/media/video/omap3isp/ispccp2.c
@@ -933,6 +933,7 @@ static const struct v4l2_subdev_pad_ops ccp2_sd_pad_ops = {
 	.enum_frame_size = ccp2_enum_frame_size,
 	.get_fmt = ccp2_get_format,
 	.set_fmt = ccp2_set_format,
+	.link_validate = v4l2_subdev_link_validate_default,
 };
 
 /* subdev operations */
@@ -1029,6 +1030,7 @@ static int ccp2_link_setup(struct media_entity *entity,
 /* media operations */
 static const struct media_entity_operations ccp2_media_ops = {
 	.link_setup = ccp2_link_setup,
+	.link_validate = v4l2_subdev_link_validate,
 };
 
 /*
diff --git a/drivers/media/video/omap3isp/ispcsi2.c b/drivers/media/video/omap3isp/ispcsi2.c
index 0b3e705..ab6ae76 100644
--- a/drivers/media/video/omap3isp/ispcsi2.c
+++ b/drivers/media/video/omap3isp/ispcsi2.c
@@ -1151,6 +1151,7 @@ static const struct v4l2_subdev_pad_ops csi2_pad_ops = {
 	.enum_frame_size = csi2_enum_frame_size,
 	.get_fmt = csi2_get_format,
 	.set_fmt = csi2_set_format,
+	.link_validate = v4l2_subdev_link_validate_default,
 };
 
 /* subdev operations */
@@ -1225,6 +1226,7 @@ static int csi2_link_setup(struct media_entity *entity,
 /* media operations */
 static const struct media_entity_operations csi2_media_ops = {
 	.link_setup = csi2_link_setup,
+	.link_validate = v4l2_subdev_link_validate,
 };
 
 void omap3isp_csi2_unregister_entities(struct isp_csi2_device *csi2)
diff --git a/drivers/media/video/omap3isp/isppreview.c b/drivers/media/video/omap3isp/isppreview.c
index ccb876f..62c49d6 100644
--- a/drivers/media/video/omap3isp/isppreview.c
+++ b/drivers/media/video/omap3isp/isppreview.c
@@ -1986,6 +1986,7 @@ static const struct v4l2_subdev_pad_ops preview_v4l2_pad_ops = {
 	.set_fmt = preview_set_format,
 	.get_crop = preview_get_crop,
 	.set_crop = preview_set_crop,
+	.link_validate = v4l2_subdev_link_validate_default,
 };
 
 /* subdev operations */
@@ -2081,6 +2082,7 @@ static int preview_link_setup(struct media_entity *entity,
 /* media operations */
 static const struct media_entity_operations preview_media_ops = {
 	.link_setup = preview_link_setup,
+	.link_validate = v4l2_subdev_link_validate,
 };
 
 void omap3isp_preview_unregister_entities(struct isp_prev_device *prev)
diff --git a/drivers/media/video/omap3isp/ispresizer.c b/drivers/media/video/omap3isp/ispresizer.c
index 50e593b..ecc377b 100644
--- a/drivers/media/video/omap3isp/ispresizer.c
+++ b/drivers/media/video/omap3isp/ispresizer.c
@@ -1535,6 +1535,7 @@ static const struct v4l2_subdev_pad_ops resizer_v4l2_pad_ops = {
 	.set_fmt = resizer_set_format,
 	.get_crop = resizer_g_crop,
 	.set_crop = resizer_s_crop,
+	.link_validate = v4l2_subdev_link_validate_default,
 };
 
 /* subdev operations */
@@ -1606,6 +1607,7 @@ static int resizer_link_setup(struct media_entity *entity,
 /* media operations */
 static const struct media_entity_operations resizer_media_ops = {
 	.link_setup = resizer_link_setup,
+	.link_validate = v4l2_subdev_link_validate,
 };
 
 void omap3isp_resizer_unregister_entities(struct isp_res_device *res)
diff --git a/drivers/media/video/omap3isp/ispvideo.c b/drivers/media/video/omap3isp/ispvideo.c
index 2ff7f91..12b4d99 100644
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
@@ -988,11 +986,15 @@ isp_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	 */
 	pipe = video->video.entity.pipe
 	     ? to_isp_pipeline(&video->video.entity) : &video->pipe;
+
+	if (video->isp->pdata->set_constraints)
+		video->isp->pdata->set_constraints(video->isp, true);
+	pipe->l3_ick = clk_get_rate(video->isp->clock[ISP_CLK_L3_ICK]);
+	pipe->max_rate = pipe->l3_ick;
+
 	ret = media_entity_pipeline_start(&video->video.entity, &pipe->pipe);
-	if (ret < 0) {
-		mutex_unlock(&video->stream_lock);
-		return ret;
-	}
+	if (ret < 0)
+		goto error;
 
 	/* Verify that the currently configured format matches the output of
 	 * the connected subdev.
@@ -1024,10 +1026,6 @@ isp_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 		pipe->output = far_end;
 	}
 
-	if (video->isp->pdata->set_constraints)
-		video->isp->pdata->set_constraints(video->isp, true);
-	pipe->l3_ick = clk_get_rate(video->isp->clock[ISP_CLK_L3_ICK]);
-
 	/* Validate the pipeline and update its state. */
 	ret = isp_video_validate_pipeline(pipe);
 	if (ret < 0)
-- 
1.7.2.5

