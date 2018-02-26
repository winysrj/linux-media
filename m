Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:54324 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751814AbeBZVow (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Feb 2018 16:44:52 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH 08/15] v4l: vsp1: Setup BRU at atomic commit time
Date: Mon, 26 Feb 2018 23:45:09 +0200
Message-Id: <20180226214516.11559-9-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <20180226214516.11559-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20180226214516.11559-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To implement fully dynamic plane assignment to pipelines, we need to
reassign the BRU and BRS to the DRM pipelines in the atomic commit
handler. In preparation for this setup factor out the BRU source pad
code and call it both at LIF setup and atomic commit time.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_drm.c | 56 +++++++++++++++++++++++++++++++++-
 drivers/media/platform/vsp1/vsp1_drm.h |  5 +++
 2 files changed, 60 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index 7bf697ba7969..6ad8aa6c8138 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -148,12 +148,51 @@ static int vsp1_du_pipeline_setup_rpf(struct vsp1_device *vsp1,
 	return 0;
 }
 
+/* Setup the BRU source pad. */
+static int vsp1_du_pipeline_setup_bru(struct vsp1_device *vsp1,
+				      struct vsp1_pipeline *pipe)
+{
+	struct vsp1_drm_pipeline *drm_pipe = to_vsp1_drm_pipeline(pipe);
+	struct v4l2_subdev_format format = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
+	int ret;
+
+	/*
+	 * Configure the format on the BRU source and verify that it matches the
+	 * requested format. We don't set the media bus code as it is configured
+	 * on the BRU sink pad 0 and propagated inside the entity, not on the
+	 * source pad.
+	 */
+	format.pad = pipe->bru->source_pad;
+	format.format.width = drm_pipe->width;
+	format.format.height = drm_pipe->height;
+	format.format.field = V4L2_FIELD_NONE;
+
+	ret = v4l2_subdev_call(&pipe->bru->subdev, pad, set_fmt, NULL,
+			       &format);
+	if (ret < 0)
+		return ret;
+
+	dev_dbg(vsp1->dev, "%s: set format %ux%u (%x) on %s pad %u\n",
+		__func__, format.format.width, format.format.height,
+		format.format.code, BRU_NAME(pipe->bru), pipe->bru->source_pad);
+
+	if (format.format.width != drm_pipe->width ||
+	    format.format.height != drm_pipe->height) {
+		dev_dbg(vsp1->dev, "%s: format mismatch\n", __func__);
+		return -EPIPE;
+	}
+
+	return 0;
+}
+
 static unsigned int rpf_zpos(struct vsp1_device *vsp1, struct vsp1_rwpf *rpf)
 {
 	return vsp1->drm->inputs[rpf->entity.index].zpos;
 }
 
-/* Setup the input side of the pipeline (RPFs and BRU sink pads). */
+/* Setup the input side of the pipeline (RPFs and BRU). */
 static int vsp1_du_pipeline_setup_input(struct vsp1_device *vsp1,
 					struct vsp1_pipeline *pipe)
 {
@@ -191,6 +230,18 @@ static int vsp1_du_pipeline_setup_input(struct vsp1_device *vsp1,
 		inputs[j] = rpf;
 	}
 
+	/*
+	 * Setup the BRU. This must be done before setting up the RPF input
+	 * pipelines as the BRU sink compose rectangles depend on the BRU source
+	 * format.
+	 */
+	ret = vsp1_du_pipeline_setup_bru(vsp1, pipe);
+	if (ret < 0) {
+		dev_err(vsp1->dev, "%s: failed to setup %s source\n", __func__,
+			BRU_NAME(pipe->bru));
+		return ret;
+	}
+
 	/* Setup the RPF input pipeline for every enabled input. */
 	for (i = 0; i < pipe->bru->source_pad; ++i) {
 		struct vsp1_rwpf *rpf = inputs[i];
@@ -355,6 +406,9 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int pipe_index,
 		return 0;
 	}
 
+	drm_pipe->width = cfg->width;
+	drm_pipe->height = cfg->height;
+
 	dev_dbg(vsp1->dev, "%s: configuring LIF%u with format %ux%u\n",
 		__func__, pipe_index, cfg->width, cfg->height);
 
diff --git a/drivers/media/platform/vsp1/vsp1_drm.h b/drivers/media/platform/vsp1/vsp1_drm.h
index 9aa19325cbe9..c8dd75ba01f6 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.h
+++ b/drivers/media/platform/vsp1/vsp1_drm.h
@@ -20,12 +20,17 @@
 /**
  * vsp1_drm_pipeline - State for the API exposed to the DRM driver
  * @pipe: the VSP1 pipeline used for display
+ * @width: output display width
+ * @height: output display height
  * @du_complete: frame completion callback for the DU driver (optional)
  * @du_private: data to be passed to the du_complete callback
  */
 struct vsp1_drm_pipeline {
 	struct vsp1_pipeline pipe;
 
+	unsigned int width;
+	unsigned int height;
+
 	/* Frame synchronisation */
 	void (*du_complete)(void *, bool);
 	void *du_private;
-- 
Regards,

Laurent Pinchart
