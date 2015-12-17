Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44652 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755389AbbLQIkm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Dec 2015 03:40:42 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH/RFC 03/48] v4l: vsp1: Simplify frame end processing
Date: Thu, 17 Dec 2015 10:39:41 +0200
Message-Id: <1450341626-6695-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1450341626-6695-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1450341626-6695-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
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
index 302d02a5c1c0..1cfa8a0e43b6 100644
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
index 96f0e7d4c400..9c6d295ca843 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.c
+++ b/drivers/media/platform/vsp1/vsp1_pipe.c
@@ -268,7 +268,8 @@ void vsp1_pipeline_frame_end(struct vsp1_pipeline *pipe)
 		vsp1_dl_irq_frame_end(pipe->dl);
 
 	/* Signal frame end to the pipeline handler. */
-	pipe->frame_end(pipe);
+	if (pipe->frame_end)
+		pipe->frame_end(pipe);
 
 	spin_lock_irqsave(&pipe->irqlock, flags);
 
@@ -277,8 +278,10 @@ void vsp1_pipeline_frame_end(struct vsp1_pipeline *pipe)
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
2.4.10

