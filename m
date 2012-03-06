Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:60156 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756865Ab2CFQd3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Mar 2012 11:33:29 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, dacohen@gmail.com,
	snjw23@gmail.com, andriy.shevchenko@linux.intel.com,
	t.stanislaws@samsung.com, tuukkat76@gmail.com,
	k.debski@samsung.com, riverful@gmail.com, hverkuil@xs4all.nl,
	teturtia@gmail.com, pradeep.sawlani@gmail.com
Subject: [PATCH v5 25/35] omap3isp: Collect entities that are part of the pipeline
Date: Tue,  6 Mar 2012 18:33:06 +0200
Message-Id: <1331051596-8261-25-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20120306163239.GN1075@valkosipuli.localdomain>
References: <20120306163239.GN1075@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Collect entities which are part of the pipeline into a single bit mask.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/video/omap3isp/ispvideo.c |    9 +++++++++
 drivers/media/video/omap3isp/ispvideo.h |    1 +
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispvideo.c b/drivers/media/video/omap3isp/ispvideo.c
index d34f690..4bc9cca 100644
--- a/drivers/media/video/omap3isp/ispvideo.c
+++ b/drivers/media/video/omap3isp/ispvideo.c
@@ -970,6 +970,8 @@ isp_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 {
 	struct isp_video_fh *vfh = to_isp_video_fh(fh);
 	struct isp_video *video = video_drvdata(file);
+	struct media_entity_graph graph;
+	struct media_entity *entity;
 	enum isp_pipeline_state state;
 	struct isp_pipeline *pipe;
 	struct isp_video *far_end;
@@ -992,6 +994,8 @@ isp_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	pipe = video->video.entity.pipe
 	     ? to_isp_pipeline(&video->video.entity) : &video->pipe;
 
+	pipe->entities = 0;
+
 	if (video->isp->pdata->set_constraints)
 		video->isp->pdata->set_constraints(video->isp, true);
 	pipe->l3_ick = clk_get_rate(video->isp->clock[ISP_CLK_L3_ICK]);
@@ -1001,6 +1005,11 @@ isp_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	if (ret < 0)
 		goto err_pipeline_start;
 
+	entity = &video->video.entity;
+	media_entity_graph_walk_start(&graph, entity);
+	while ((entity = media_entity_graph_walk_next(&graph)))
+		pipe->entities |= 1 << entity->id;
+
 	/* Verify that the currently configured format matches the output of
 	 * the connected subdev.
 	 */
diff --git a/drivers/media/video/omap3isp/ispvideo.h b/drivers/media/video/omap3isp/ispvideo.h
index d91bdb91..0423c9d 100644
--- a/drivers/media/video/omap3isp/ispvideo.h
+++ b/drivers/media/video/omap3isp/ispvideo.h
@@ -96,6 +96,7 @@ struct isp_pipeline {
 	enum isp_pipeline_stream_state stream_state;
 	struct isp_video *input;
 	struct isp_video *output;
+	u32 entities;
 	unsigned long l3_ick;
 	unsigned int max_rate;
 	atomic_t frame_number;
-- 
1.7.2.5

