Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:54331 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751280AbeDEJSm (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Apr 2018 05:18:42 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH v2 09/15] v4l: vsp1: Move DRM pipeline output setup code to a function
Date: Thu,  5 Apr 2018 12:18:34 +0300
Message-Id: <20180405091840.30728-10-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <20180405091840.30728-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20180405091840.30728-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In order to make the vsp1_du_setup_lif() easier to read, and for
symmetry with the DRM pipeline input setup, move the pipeline output
setup code to a separate function.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
--
Changes since v1:

- Rename vsp1_du_pipeline_setup_input() to
  vsp1_du_pipeline_setup_inputs()
- Initialize format local variable to 0 in
  vsp1_du_pipeline_setup_output()
---
 drivers/media/platform/vsp1/vsp1_drm.c | 114 ++++++++++++++++++---------------
 1 file changed, 64 insertions(+), 50 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index 00ce99bd1605..a7cccc9b05ef 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -193,8 +193,8 @@ static unsigned int rpf_zpos(struct vsp1_device *vsp1, struct vsp1_rwpf *rpf)
 }
 
 /* Setup the input side of the pipeline (RPFs and BRU). */
-static int vsp1_du_pipeline_setup_input(struct vsp1_device *vsp1,
-					struct vsp1_pipeline *pipe)
+static int vsp1_du_pipeline_setup_inputs(struct vsp1_device *vsp1,
+					 struct vsp1_pipeline *pipe)
 {
 	struct vsp1_rwpf *inputs[VSP1_MAX_RPF] = { NULL, };
 	struct vsp1_bru *bru = to_bru(&pipe->bru->subdev);
@@ -276,6 +276,65 @@ static int vsp1_du_pipeline_setup_input(struct vsp1_device *vsp1,
 	return 0;
 }
 
+/* Setup the output side of the pipeline (WPF and LIF). */
+static int vsp1_du_pipeline_setup_output(struct vsp1_device *vsp1,
+					 struct vsp1_pipeline *pipe)
+{
+	struct vsp1_drm_pipeline *drm_pipe = to_vsp1_drm_pipeline(pipe);
+	struct v4l2_subdev_format format = { 0, };
+	int ret;
+
+	format.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+	format.pad = RWPF_PAD_SINK;
+	format.format.width = drm_pipe->width;
+	format.format.height = drm_pipe->height;
+	format.format.code = MEDIA_BUS_FMT_ARGB8888_1X32;
+	format.format.field = V4L2_FIELD_NONE;
+
+	ret = v4l2_subdev_call(&pipe->output->entity.subdev, pad, set_fmt, NULL,
+			       &format);
+	if (ret < 0)
+		return ret;
+
+	dev_dbg(vsp1->dev, "%s: set format %ux%u (%x) on WPF%u sink\n",
+		__func__, format.format.width, format.format.height,
+		format.format.code, pipe->output->entity.index);
+
+	format.pad = RWPF_PAD_SOURCE;
+	ret = v4l2_subdev_call(&pipe->output->entity.subdev, pad, get_fmt, NULL,
+			       &format);
+	if (ret < 0)
+		return ret;
+
+	dev_dbg(vsp1->dev, "%s: got format %ux%u (%x) on WPF%u source\n",
+		__func__, format.format.width, format.format.height,
+		format.format.code, pipe->output->entity.index);
+
+	format.pad = LIF_PAD_SINK;
+	ret = v4l2_subdev_call(&pipe->lif->subdev, pad, set_fmt, NULL,
+			       &format);
+	if (ret < 0)
+		return ret;
+
+	dev_dbg(vsp1->dev, "%s: set format %ux%u (%x) on LIF%u sink\n",
+		__func__, format.format.width, format.format.height,
+		format.format.code, pipe->lif->index);
+
+	/*
+	 * Verify that the format at the output of the pipeline matches the
+	 * requested frame size and media bus code.
+	 */
+	if (format.format.width != drm_pipe->width ||
+	    format.format.height != drm_pipe->height ||
+	    format.format.code != MEDIA_BUS_FMT_ARGB8888_1X32) {
+		dev_dbg(vsp1->dev, "%s: format mismatch on LIF%u\n", __func__,
+			pipe->lif->index);
+		return -EPIPE;
+	}
+
+	return 0;
+}
+
 /* Configure all entities in the pipeline. */
 static void vsp1_du_pipeline_configure(struct vsp1_pipeline *pipe)
 {
@@ -356,7 +415,6 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int pipe_index,
 	struct vsp1_drm_pipeline *drm_pipe;
 	struct vsp1_pipeline *pipe;
 	struct vsp1_bru *bru;
-	struct v4l2_subdev_format format;
 	unsigned long flags;
 	unsigned int i;
 	int ret;
@@ -413,58 +471,14 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int pipe_index,
 		__func__, pipe_index, cfg->width, cfg->height);
 
 	/* Setup formats through the pipeline. */
-	ret = vsp1_du_pipeline_setup_input(vsp1, pipe);
-	if (ret < 0)
-		return ret;
-
-	memset(&format, 0, sizeof(format));
-	format.which = V4L2_SUBDEV_FORMAT_ACTIVE;
-	format.pad = RWPF_PAD_SINK;
-	format.format.width = cfg->width;
-	format.format.height = cfg->height;
-	format.format.code = MEDIA_BUS_FMT_ARGB8888_1X32;
-	format.format.field = V4L2_FIELD_NONE;
-
-	ret = v4l2_subdev_call(&pipe->output->entity.subdev, pad, set_fmt, NULL,
-			       &format);
-	if (ret < 0)
-		return ret;
-
-	dev_dbg(vsp1->dev, "%s: set format %ux%u (%x) on WPF%u sink\n",
-		__func__, format.format.width, format.format.height,
-		format.format.code, pipe->output->entity.index);
-
-	format.pad = RWPF_PAD_SOURCE;
-	ret = v4l2_subdev_call(&pipe->output->entity.subdev, pad, get_fmt, NULL,
-			       &format);
+	ret = vsp1_du_pipeline_setup_inputs(vsp1, pipe);
 	if (ret < 0)
 		return ret;
 
-	dev_dbg(vsp1->dev, "%s: got format %ux%u (%x) on WPF%u source\n",
-		__func__, format.format.width, format.format.height,
-		format.format.code, pipe->output->entity.index);
-
-	format.pad = LIF_PAD_SINK;
-	ret = v4l2_subdev_call(&pipe->lif->subdev, pad, set_fmt, NULL,
-			       &format);
+	ret = vsp1_du_pipeline_setup_output(vsp1, pipe);
 	if (ret < 0)
 		return ret;
 
-	dev_dbg(vsp1->dev, "%s: set format %ux%u (%x) on LIF%u sink\n",
-		__func__, format.format.width, format.format.height,
-		format.format.code, pipe_index);
-
-	/*
-	 * Verify that the format at the output of the pipeline matches the
-	 * requested frame size and media bus code.
-	 */
-	if (format.format.width != cfg->width ||
-	    format.format.height != cfg->height ||
-	    format.format.code != MEDIA_BUS_FMT_ARGB8888_1X32) {
-		dev_dbg(vsp1->dev, "%s: format mismatch\n", __func__);
-		return -EPIPE;
-	}
-
 	/* Enable the VSP1. */
 	ret = vsp1_device_get(vsp1);
 	if (ret < 0)
@@ -612,7 +626,7 @@ void vsp1_du_atomic_flush(struct device *dev, unsigned int pipe_index)
 	struct vsp1_drm_pipeline *drm_pipe = &vsp1->drm->pipe[pipe_index];
 	struct vsp1_pipeline *pipe = &drm_pipe->pipe;
 
-	vsp1_du_pipeline_setup_input(vsp1, pipe);
+	vsp1_du_pipeline_setup_inputs(vsp1, pipe);
 	vsp1_du_pipeline_configure(pipe);
 }
 EXPORT_SYMBOL_GPL(vsp1_du_atomic_flush);
-- 
Regards,

Laurent Pinchart
