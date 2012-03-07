Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:27744 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932468Ab2CGSOz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Mar 2012 13:14:55 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, dacohen@gmail.com,
	snjw23@gmail.com, andriy.shevchenko@linux.intel.com,
	t.stanislaws@samsung.com, tuukkat76@gmail.com,
	k.debski@samsung.com, riverful@gmail.com, hverkuil@xs4all.nl,
	teturtia@gmail.com, pradeep.sawlani@gmail.com
Subject: [PATCH v5.1 27/35] omap3isp: Introduce isp_video_check_external_subdevs()
Date: Wed,  7 Mar 2012 20:14:45 +0200
Message-Id: <1331144085-12190-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <51199527.ynQze3IDdP@avalon>
References: <51199527.ynQze3IDdP@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

isp_video_check_external_subdevs() will retrieve external subdev's
bits-per-pixel and pixel rate for the use of other ISP subdevs at streamon
time. isp_video_check_external_subdevs() is called after pipeline
validation.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/video/omap3isp/ispvideo.c |   79 +++++++++++++++++++++++++++++++
 1 files changed, 79 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispvideo.c b/drivers/media/video/omap3isp/ispvideo.c
index 7411076..f3b82cae4 100644
--- a/drivers/media/video/omap3isp/ispvideo.c
+++ b/drivers/media/video/omap3isp/ispvideo.c
@@ -951,6 +951,81 @@ isp_video_dqbuf(struct file *file, void *fh, struct v4l2_buffer *b)
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
+	unsigned int i;
+	int ret = 0;
+
+	for (i = 0; i < ARRAY_SIZE(ents); i++) {
+		/* Is the entity part of the pipeline? */
+		if (!(pipe->entities & (1 << ents[i]->id)))
+			continue;
+
+		/* ISP entities have always sink pad == 0. Find source. */
+		source_pad = media_entity_remote_source(&ents[i]->pads[0]);
+		if (source_pad == NULL)
+			continue;
+
+		source = source_pad->entity;
+		sink = ents[i];
+		break;
+	}
+
+	if (!source) {
+		dev_warn(isp->dev, "can't find source, failing now\n");
+		return ret;
+	}
+
+	if (media_entity_type(source) != MEDIA_ENT_T_V4L2_SUBDEV)
+		return 0;
+
+	pipe->external = media_entity_to_v4l2_subdev(source);
+
+	fmt.pad = source_pad->index;
+	fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+	ret = v4l2_subdev_call(media_entity_to_v4l2_subdev(sink),
+			       pad, get_fmt, NULL, &fmt);
+	if (unlikely(ret < 0)) {
+		dev_warn(isp->dev, "get_fmt returned null!\n");
+		return ret;
+	}
+
+	pipe->external_bpp = omap3isp_video_format_info(fmt.format.code)->bpp;
+
+	memset(&ctrls, 0, sizeof(ctrls));
+	memset(&ctrl, 0, sizeof(ctrl));
+
+	ctrl.id = V4L2_CID_PIXEL_RATE;
+
+	ctrls.count = 1;
+	ctrls.controls = &ctrl;
+
+	ret = v4l2_g_ext_ctrls(pipe->external->ctrl_handler, &ctrls);
+	if (ret < 0) {
+		dev_warn(isp->dev, "no pixel rate control in subdev %s\n",
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
@@ -1033,6 +1108,10 @@ isp_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	if (ret < 0)
 		goto err_check_format;
 
+	ret = isp_video_check_external_subdevs(pipe);
+	if (ret < 0)
+		goto err_check_format;
+
 	/* Validate the pipeline and update its state. */
 	ret = isp_video_validate_pipeline(pipe);
 	if (ret < 0)
-- 
1.7.2.5

