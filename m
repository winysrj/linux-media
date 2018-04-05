Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:54322 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751928AbeDEJSe (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Apr 2018 05:18:34 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH v2 01/15] v4l: vsp1: Don't start/stop media pipeline for DRM
Date: Thu,  5 Apr 2018 12:18:26 +0300
Message-Id: <20180405091840.30728-2-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <20180405091840.30728-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20180405091840.30728-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The DRM support code manages a pipeline of VSP entities, each backed by
a media entity. When starting or stopping the pipeline, it starts and
stops the media pipeline through the media API in order to store the
pipeline pointer in every entity.

The driver doesn't use the pipe pointer in media entities, neither does
it rely on the other effects of the media_pipeline_start() and
media_pipeline_stop() functions. Furthermore, as the media links for the
DRM pipeline are never set up correctly, and as the pipeline can be
modified dynamically when enabling or disabling planes, the current
implementation is not correct. Remove the incorrect and unneeded code.

While at it remove the outdated comment that states that entities are
not started when the LIF is setup, as they now are.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
--
Changes since v1:

- Remove outdated comment
---
 drivers/media/platform/vsp1/vsp1_drm.c | 18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index b8fee1834253..a1f2ba044092 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -109,8 +109,6 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int pipe_index,
 		if (ret == -ETIMEDOUT)
 			dev_err(vsp1->dev, "DRM pipeline stop timeout\n");
 
-		media_pipeline_stop(&pipe->output->entity.subdev.entity);
-
 		for (i = 0; i < ARRAY_SIZE(pipe->inputs); ++i) {
 			struct vsp1_rwpf *rpf = pipe->inputs[i];
 
@@ -223,13 +221,7 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int pipe_index,
 		return -EPIPE;
 	}
 
-	/*
-	 * Mark the pipeline as streaming and enable the VSP1. This will store
-	 * the pipeline pointer in all entities, which the s_stream handlers
-	 * will need. We don't start the entities themselves right at this point
-	 * as there's no plane configured yet, so we can't start processing
-	 * buffers.
-	 */
+	/* Enable the VSP1. */
 	ret = vsp1_device_get(vsp1);
 	if (ret < 0)
 		return ret;
@@ -241,14 +233,6 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int pipe_index,
 	drm_pipe->du_complete = cfg->callback;
 	drm_pipe->du_private = cfg->callback_data;
 
-	ret = media_pipeline_start(&pipe->output->entity.subdev.entity,
-					  &pipe->pipe);
-	if (ret < 0) {
-		dev_dbg(vsp1->dev, "%s: pipeline start failed\n", __func__);
-		vsp1_device_put(vsp1);
-		return ret;
-	}
-
 	/* Disable the display interrupts. */
 	vsp1_write(vsp1, VI6_DISP_IRQ_STA, 0);
 	vsp1_write(vsp1, VI6_DISP_IRQ_ENB, 0);
-- 
Regards,

Laurent Pinchart
