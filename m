Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:54331 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751933AbeDEJSg (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Apr 2018 05:18:36 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH v2 02/15] v4l: vsp1: Remove unused field from vsp1_drm_pipeline structure
Date: Thu,  5 Apr 2018 12:18:27 +0300
Message-Id: <20180405091840.30728-3-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <20180405091840.30728-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20180405091840.30728-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The vsp1_drm_pipeline enabled field is set but never used. Remove it.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_drm.c | 4 ----
 drivers/media/platform/vsp1/vsp1_drm.h | 2 --
 2 files changed, 6 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index a1f2ba044092..a267f12f0cc8 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -273,10 +273,6 @@ EXPORT_SYMBOL_GPL(vsp1_du_setup_lif);
  */
 void vsp1_du_atomic_begin(struct device *dev, unsigned int pipe_index)
 {
-	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
-	struct vsp1_drm_pipeline *drm_pipe = &vsp1->drm->pipe[pipe_index];
-
-	drm_pipe->enabled = drm_pipe->pipe.num_inputs != 0;
 }
 EXPORT_SYMBOL_GPL(vsp1_du_atomic_begin);
 
diff --git a/drivers/media/platform/vsp1/vsp1_drm.h b/drivers/media/platform/vsp1/vsp1_drm.h
index 1cd9db785bf7..9aa19325cbe9 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.h
+++ b/drivers/media/platform/vsp1/vsp1_drm.h
@@ -20,13 +20,11 @@
 /**
  * vsp1_drm_pipeline - State for the API exposed to the DRM driver
  * @pipe: the VSP1 pipeline used for display
- * @enabled: pipeline state at the beginning of an update
  * @du_complete: frame completion callback for the DU driver (optional)
  * @du_private: data to be passed to the du_complete callback
  */
 struct vsp1_drm_pipeline {
 	struct vsp1_pipeline pipe;
-	bool enabled;
 
 	/* Frame synchronisation */
 	void (*du_complete)(void *, bool);
-- 
Regards,

Laurent Pinchart
