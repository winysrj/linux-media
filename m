Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:50949 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754743Ab2BBXzE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Feb 2012 18:55:04 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, dacohen@gmail.com,
	snjw23@gmail.com, andriy.shevchenko@linux.intel.com,
	t.stanislaws@samsung.com, tuukkat76@gmail.com,
	k.debski@samsung.com, riverful@gmail.com, hverkuil@xs4all.nl,
	teturtia@gmail.com
Subject: [PATCH v2 26/31] omap3isp: Move setting constaints above media_entity_pipeline_start
Date: Fri,  3 Feb 2012 01:54:46 +0200
Message-Id: <1328226891-8968-26-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20120202235231.GC841@valkosipuli.localdomain>
References: <20120202235231.GC841@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/video/omap3isp/ispvideo.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispvideo.c b/drivers/media/video/omap3isp/ispvideo.c
index f1c68ca..2e4786d 100644
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
@@ -997,6 +995,11 @@ isp_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	pipe->external_rate = 0;
 	pipe->external_bpp = 0;
 
+	if (video->isp->pdata->set_constraints)
+		video->isp->pdata->set_constraints(video->isp, true);
+	pipe->l3_ick = clk_get_rate(video->isp->clock[ISP_CLK_L3_ICK]);
+	pipe->max_rate = pipe->l3_ick;
+
 	ret = media_entity_pipeline_start(&video->video.entity, &pipe->pipe);
 	if (ret < 0)
 		goto err_media_entity_pipeline_start;
@@ -1031,10 +1034,6 @@ isp_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
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

