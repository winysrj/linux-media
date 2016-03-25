Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40676 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200AbcCYKoj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Mar 2016 06:44:39 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH v2 11/54] v4l: vsp1: Simplify frame end processing
Date: Fri, 25 Mar 2016 12:43:45 +0200
Message-Id: <1458902668-1141-12-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1458902668-1141-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1458902668-1141-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The DRM pipeline, as it runs in automatic restart mode, never sees the
pipeline state set to VSP1_PIPELINE_STOPPING or VSP1_PIPELINE_STOPPED
when running the frame end interrupt handler. We can thus skip the
checks various checks in the handler and return immediately.

Similarly the DRM frame end handler calls vsp1_pipeline_run()
unnecessarily, as the state there is never VSP1_PIPELINE_STOPPED. Remove
the function call and the frame end handler is it's now empty.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_drm.c  | 15 ---------------
 drivers/media/platform/vsp1/vsp1_pipe.c |  9 ++++++---
 2 files changed, 6 insertions(+), 18 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index 8cf7c19f4344..9ecba4c1332e 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -27,20 +27,6 @@
 #include "vsp1_rwpf.h"
 
 /* -----------------------------------------------------------------------------
- * Runtime Handling
- */
-
-static void vsp1_drm_pipeline_frame_end(struct vsp1_pipeline *pipe)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&pipe->irqlock, flags);
-	if (pipe->num_inputs)
-		vsp1_pipeline_run(pipe);
-	spin_unlock_irqrestore(&pipe->irqlock, flags);
-}
-
-/* -----------------------------------------------------------------------------
  * DU Driver API
  */
 
@@ -569,7 +555,6 @@ int vsp1_drm_init(struct vsp1_device *vsp1)
 	pipe = &vsp1->drm->pipe;
 
 	vsp1_pipeline_init(pipe);
-	pipe->frame_end = vsp1_drm_pipeline_frame_end;
 
 	/* The DRM pipeline is static, add entities manually. */
 	for (i = 0; i < vsp1->info->rpf_count; ++i) {
diff --git a/drivers/media/platform/vsp1/vsp1_pipe.c b/drivers/media/platform/vsp1/vsp1_pipe.c
index 6659f06b1643..78096122a22d 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.c
+++ b/drivers/media/platform/vsp1/vsp1_pipe.c
@@ -289,7 +289,8 @@ void vsp1_pipeline_frame_end(struct vsp1_pipeline *pipe)
 		vsp1_dl_irq_frame_end(pipe->dl);
 
 	/* Signal frame end to the pipeline handler. */
-	pipe->frame_end(pipe);
+	if (pipe->frame_end)
+		pipe->frame_end(pipe);
 
 	spin_lock_irqsave(&pipe->irqlock, flags);
 
@@ -298,8 +299,10 @@ void vsp1_pipeline_frame_end(struct vsp1_pipeline *pipe)
 	/* When using display lists in continuous frame mode the pipeline is
 	 * automatically restarted by the hardware.
 	 */
-	if (!pipe->dl)
-		pipe->state = VSP1_PIPELINE_STOPPED;
+	if (pipe->dl)
+		goto done;
+
+	pipe->state = VSP1_PIPELINE_STOPPED;
 
 	/* If a stop has been requested, mark the pipeline as stopped and
 	 * return.
-- 
2.7.3

