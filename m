Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:60166 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756947Ab2CFQd3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Mar 2012 11:33:29 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, dacohen@gmail.com,
	snjw23@gmail.com, andriy.shevchenko@linux.intel.com,
	t.stanislaws@samsung.com, tuukkat76@gmail.com,
	k.debski@samsung.com, riverful@gmail.com, hverkuil@xs4all.nl,
	teturtia@gmail.com, pradeep.sawlani@gmail.com
Subject: [PATCH v5 27/35] omap3isp: Introduce isp_video_check_external_subdevs()
Date: Tue,  6 Mar 2012 18:33:08 +0200
Message-Id: <1331051596-8261-27-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20120306163239.GN1075@valkosipuli.localdomain>
References: <20120306163239.GN1075@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

isp_video_check_external_subdevs() will retrieve external subdev's
bits-per-pixel and pixel rate for the use of other ISP subdevs at streamon
time. isp_video_check_external_subdevs() is called after pipeline
validation.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/video/omap3isp/ispvideo.c |   75 +++++++++++++++++++++++++++++++
 1 files changed, 75 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispvideo.c b/drivers/media/video/omap3isp/ispvideo.c
index 4bc9cca..ef5c770 100644
--- a/drivers/media/video/omap3isp/ispvideo.c
+++ b/drivers/media/video/omap3isp/ispvideo.c
@@ -934,6 +934,77 @@ isp_video_dqbuf(struct file *file, void *fh, struct v4l2_buffer *b)
 					  file->f_flags & O_NONBLOCK);
 }
 
+static int isp_video_check_external_subdevs(struct isp_pipeline *pipe)
+{
+	struct isp_device *isp =
+		container_of(pipe, struct isp_video, pipe)->isp;
+	struct media_entity *ents[] = {
+		&isp->isp_csi2a.subdev.entity,
+		&isp->isp_csi2c.subdev.entity,
+		&isp->isp_ccp2.subdev.entity,
+		&isp->isp_ccdc.subdev.entity
+	};
+	struct media_pad *source_pad;
+	struct media_entity *source = NULL;
+	struct media_entity *sink;
+	struct v4l2_subdev_format fmt;
+	struct v4l2_ext_controls ctrls;
+	struct v4l2_ext_control ctrl;
+	int i;
+	int ret = 0;
+
+	for (i = 0; i < ARRAY_SIZE(ents); i++) {
+		/* Is the entity part of the pipeline? */
+		if (!(pipe->entities & (1 << ents[i]->id)))
+			continue;
+
+		/* ISP entities have always sink pad == 0. Find source. */
+		source_pad = media_entity_remote_source(&ents[i]->pads[0]);
+
+		if (source_pad == NULL)
+			continue;
+
+		source = source_pad->entity;
+		sink = ents[i];
+		break;
+	}
+
+	if (!source || media_entity_type(source) != MEDIA_ENT_T_V4L2_SUBDEV)
+		return 0;
+
+	pipe->external = media_entity_to_v4l2_subdev(source);
+
+	fmt.pad = source_pad->index;
+	fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+	ret = v4l2_subdev_call(media_entity_to_v4l2_subdev(sink),
+			       pad, get_fmt, NULL, &fmt);
+	BUG_ON(ret < 0);
+
+	pipe->external_bpp = omap3isp_video_format_info(
+		fmt.format.code)->bpp;
+
+	memset(&ctrls, 0, sizeof(ctrls));
+	memset(&ctrl, 0, sizeof(ctrl));
+
+	ctrl.id = V4L2_CID_PIXEL_RATE;
+
+	ctrls.ctrl_class = V4L2_CTRL_ID2CLASS(ctrl.id);
+	ctrls.count = 1;
+	ctrls.controls = &ctrl;
+
+	ret = v4l2_g_ext_ctrls(pipe->external->ctrl_handler, &ctrls);
+	if (ret < 0) {
+		dev_warn(isp->dev,
+			 "no pixel rate control in subdev %s\n",
+			 pipe->external->name);
+		return ret;
+	}
+
+	pipe->external_rate = ctrl.value64;
+
+	return 0;
+}
+
 /*
  * Stream management
  *
@@ -1010,6 +1081,10 @@ isp_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	while ((entity = media_entity_graph_walk_next(&graph)))
 		pipe->entities |= 1 << entity->id;
 
+	ret = isp_video_check_external_subdevs(pipe);
+	if (ret < 0)
+		goto err_check_format;
+
 	/* Verify that the currently configured format matches the output of
 	 * the connected subdev.
 	 */
-- 
1.7.2.5

