Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:54335 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751967AbeDEJSl (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Apr 2018 05:18:41 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH v2 08/15] v4l: vsp1: Replace manual DRM pipeline input setup in vsp1_du_setup_lif
Date: Thu,  5 Apr 2018 12:18:33 +0300
Message-Id: <20180405091840.30728-9-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <20180405091840.30728-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20180405091840.30728-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The vsp1_du_setup_lif() function sets up the DRM pipeline input
manually. This duplicates the code from the
vsp1_du_pipeline_setup_input() function. Replace the manual
implementation by a call to the function.

As the pipeline has no enabled input in vsp1_du_setup_lif(), the
vsp1_du_pipeline_setup_input() function will not setup any RPF, and will
thus not setup formats on the BRU sink pads. This isn't a problem as all
inputs are disabled, and the BRU sink pads will be reconfigured from the
atomic commit handler when inputs will be enabled.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
--
Changes since v1:

- Fixed spelling in commit message
---
 drivers/media/platform/vsp1/vsp1_drm.c | 40 +++++-----------------------------
 1 file changed, 6 insertions(+), 34 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index 6ad8aa6c8138..00ce99bd1605 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -412,47 +412,19 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int pipe_index,
 	dev_dbg(vsp1->dev, "%s: configuring LIF%u with format %ux%u\n",
 		__func__, pipe_index, cfg->width, cfg->height);
 
-	/*
-	 * Configure the format at the BRU sinks and propagate it through the
-	 * pipeline.
-	 */
+	/* Setup formats through the pipeline. */
+	ret = vsp1_du_pipeline_setup_input(vsp1, pipe);
+	if (ret < 0)
+		return ret;
+
 	memset(&format, 0, sizeof(format));
 	format.which = V4L2_SUBDEV_FORMAT_ACTIVE;
-
-	for (i = 0; i < pipe->bru->source_pad; ++i) {
-		format.pad = i;
-
-		format.format.width = cfg->width;
-		format.format.height = cfg->height;
-		format.format.code = MEDIA_BUS_FMT_ARGB8888_1X32;
-		format.format.field = V4L2_FIELD_NONE;
-
-		ret = v4l2_subdev_call(&pipe->bru->subdev, pad,
-				       set_fmt, NULL, &format);
-		if (ret < 0)
-			return ret;
-
-		dev_dbg(vsp1->dev, "%s: set format %ux%u (%x) on %s pad %u\n",
-			__func__, format.format.width, format.format.height,
-			format.format.code, BRU_NAME(pipe->bru), i);
-	}
-
-	format.pad = pipe->bru->source_pad;
+	format.pad = RWPF_PAD_SINK;
 	format.format.width = cfg->width;
 	format.format.height = cfg->height;
 	format.format.code = MEDIA_BUS_FMT_ARGB8888_1X32;
 	format.format.field = V4L2_FIELD_NONE;
 
-	ret = v4l2_subdev_call(&pipe->bru->subdev, pad, set_fmt, NULL,
-			       &format);
-	if (ret < 0)
-		return ret;
-
-	dev_dbg(vsp1->dev, "%s: set format %ux%u (%x) on %s pad %u\n",
-		__func__, format.format.width, format.format.height,
-		format.format.code, BRU_NAME(pipe->bru), i);
-
-	format.pad = RWPF_PAD_SINK;
 	ret = v4l2_subdev_call(&pipe->output->entity.subdev, pad, set_fmt, NULL,
 			       &format);
 	if (ret < 0)
-- 
Regards,

Laurent Pinchart
