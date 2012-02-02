Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:43182 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754659Ab2BBXzD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Feb 2012 18:55:03 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, dacohen@gmail.com,
	snjw23@gmail.com, andriy.shevchenko@linux.intel.com,
	t.stanislaws@samsung.com, tuukkat76@gmail.com,
	k.debski@samsung.com, riverful@gmail.com, hverkuil@xs4all.nl,
	teturtia@gmail.com
Subject: [PATCH v2 23/31] omap3isp: Introduce omap3isp_get_external_info()
Date: Fri,  3 Feb 2012 01:54:43 +0200
Message-Id: <1328226891-8968-23-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20120202235231.GC841@valkosipuli.localdomain>
References: <20120202235231.GC841@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

omap3isp_get_external_info() will retrieve external subdev's bits-per-pixel
and pixel rate for the use of other ISP subdevs at streamon time.
omap3isp_get_external_info() is used during pipeline validation.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/video/omap3isp/isp.c |   48 ++++++++++++++++++++++++++++++++++++
 drivers/media/video/omap3isp/isp.h |    3 ++
 2 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/omap3isp/isp.c b/drivers/media/video/omap3isp/isp.c
index d4e0905..ae67f49 100644
--- a/drivers/media/video/omap3isp/isp.c
+++ b/drivers/media/video/omap3isp/isp.c
@@ -353,6 +353,54 @@ void omap3isp_hist_dma_done(struct isp_device *isp)
 	}
 }
 
+int omap3isp_get_external_info(struct isp_pipeline *pipe,
+			       struct media_link *link)
+{
+	struct isp_device *isp =
+		container_of(pipe, struct isp_video, pipe)->isp;
+	struct v4l2_subdev_format fmt;
+	struct v4l2_ext_controls ctrls;
+	struct v4l2_ext_control ctrl;
+	int ret;
+
+	if (!pipe->external)
+		return 0;
+
+	if (pipe->external_rate)
+		return 0;
+
+	memset(&fmt, 0, sizeof(fmt));
+
+	fmt.pad = link->source->index;
+	fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+	ret = v4l2_subdev_call(media_entity_to_v4l2_subdev(link->sink->entity),
+			       pad, get_fmt, NULL, &fmt);
+	if (ret < 0)
+		return -EPIPE;
+
+	pipe->external_bpp = omap3isp_video_format_info(fmt.format.code)->bpp;
+
+	memset(&ctrls, 0, sizeof(ctrls));
+	memset(&ctrl, 0, sizeof(ctrl));
+
+	ctrl.id = V4L2_CID_IMAGE_PROC_PIXEL_RATE;
+
+	ctrls.ctrl_class = V4L2_CTRL_ID2CLASS(ctrl.id);
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
 static inline void isp_isr_dbg(struct isp_device *isp, u32 irqstatus)
 {
 	static const char *name[] = {
diff --git a/drivers/media/video/omap3isp/isp.h b/drivers/media/video/omap3isp/isp.h
index 2e78041..8b0bc2d 100644
--- a/drivers/media/video/omap3isp/isp.h
+++ b/drivers/media/video/omap3isp/isp.h
@@ -222,6 +222,9 @@ struct isp_device {
 
 void omap3isp_hist_dma_done(struct isp_device *isp);
 
+int omap3isp_get_external_info(struct isp_pipeline *pipe,
+			       struct media_link *link);
+
 void omap3isp_flush(struct isp_device *isp);
 
 int omap3isp_module_sync_idle(struct media_entity *me, wait_queue_head_t *wait,
-- 
1.7.2.5

