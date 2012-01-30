Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38757 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609Ab2A3MRz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Jan 2012 07:17:55 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH v3] omap3isp: Prevent pipelines that contain a crashed entity from starting
Date: Mon, 30 Jan 2012 13:18:10 +0100
Message-Id: <1327925890-18342-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The OMAP3 ISP preview engine will violate the L4 bus protocol if we try
to write some of its internal registers after it failed to stop
properly. This generates an external abort on non-linefetch fault,
triggering a fatal kernel oops.

We can't always prevent preview engine stop failures (they can for
instance be caused by a sensor crash), but we can improve the system
reliability by refusing to start streaming on a pipeline that contains
the preview engine if it failed to stop. The driver will then eventually
reset the ISP (when all applications will have closed their file handles
related to OMAP3 ISP device nodes), making the ISP usable again.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/video/omap3isp/isp.c      |   27 +++++++++++++++++++++------
 drivers/media/video/omap3isp/isp.h      |    3 ++-
 drivers/media/video/omap3isp/ispvideo.c |    4 ++++
 drivers/media/video/omap3isp/ispvideo.h |    2 ++
 4 files changed, 29 insertions(+), 7 deletions(-)

diff --git a/drivers/media/video/omap3isp/isp.c b/drivers/media/video/omap3isp/isp.c
index 12d5f92..3db8583 100644
--- a/drivers/media/video/omap3isp/isp.c
+++ b/drivers/media/video/omap3isp/isp.c
@@ -739,6 +739,17 @@ static int isp_pipeline_enable(struct isp_pipeline *pipe,
 	unsigned long flags;
 	int ret;
 
+	/* If the preview engine crashed it might not respond to read/write
+	 * operations on the L4 bus. This would result in a bus fault and a
+	 * kernel oops. Refuse to start streaming in that case. This check must
+	 * be performed before the loop below to avoid starting entities if the
+	 * pipeline won't start anyway (those entities would then likely fail to
+	 * stop, making the problem worse).
+	 */
+	if ((pipe->entities & isp->crashed) &
+	    (1U << isp->isp_prev.subdev.entity.id))
+		return -EIO;
+
 	spin_lock_irqsave(&pipe->lock, flags);
 	pipe->state &= ~(ISP_PIPELINE_IDLE_INPUT | ISP_PIPELINE_IDLE_OUTPUT);
 	spin_unlock_irqrestore(&pipe->lock, flags);
@@ -879,13 +890,15 @@ static int isp_pipeline_disable(struct isp_pipeline *pipe)
 
 		if (ret) {
 			dev_info(isp->dev, "Unable to stop %s\n", subdev->name);
+			/* If the entity failed to stopped, assume it has
+			 * crashed. Mark it as such, the ISP will be reset when
+			 * applications will release it.
+			 */
+			isp->crashed |= 1U << subdev->entity.id;
 			failure = -ETIMEDOUT;
 		}
 	}
 
-	if (failure < 0)
-		isp->needs_reset = true;
-
 	return failure;
 }
 
@@ -1069,6 +1082,7 @@ static int isp_reset(struct isp_device *isp)
 		udelay(1);
 	}
 
+	isp->crashed = 0;
 	return 0;
 }
 
@@ -1496,10 +1510,11 @@ void omap3isp_put(struct isp_device *isp)
 	if (--isp->ref_count == 0) {
 		isp_disable_interrupts(isp);
 		isp_save_ctx(isp);
-		if (isp->needs_reset) {
+		/* Reset the ISP if an entity has failed to stop. This is the
+		 * only way to recover from such conditions.
+		 */
+		if (isp->crashed)
 			isp_reset(isp);
-			isp->needs_reset = false;
-		}
 		isp_disable_clocks(isp);
 	}
 	mutex_unlock(&isp->isp_mutex);
diff --git a/drivers/media/video/omap3isp/isp.h b/drivers/media/video/omap3isp/isp.h
index d96603e..f8d1f10 100644
--- a/drivers/media/video/omap3isp/isp.h
+++ b/drivers/media/video/omap3isp/isp.h
@@ -145,6 +145,7 @@ struct isp_platform_callback {
  * @raw_dmamask: Raw DMA mask
  * @stat_lock: Spinlock for handling statistics
  * @isp_mutex: Mutex for serializing requests to ISP.
+ * @crashed: Bitmask of crashed entities (indexed by entity ID)
  * @has_context: Context has been saved at least once and can be restored.
  * @ref_count: Reference count for handling multiple ISP requests.
  * @cam_ick: Pointer to camera interface clock structure.
@@ -184,7 +185,7 @@ struct isp_device {
 	/* ISP Obj */
 	spinlock_t stat_lock;	/* common lock for statistic drivers */
 	struct mutex isp_mutex;	/* For handling ref_count field */
-	bool needs_reset;
+	u32 crashed;
 	int has_context;
 	int ref_count;
 	unsigned int autoidle;
diff --git a/drivers/media/video/omap3isp/ispvideo.c b/drivers/media/video/omap3isp/ispvideo.c
index b020700..2107d99 100644
--- a/drivers/media/video/omap3isp/ispvideo.c
+++ b/drivers/media/video/omap3isp/ispvideo.c
@@ -292,6 +292,7 @@ static int isp_video_validate_pipeline(struct isp_pipeline *pipe)
 	int ret;
 
 	pipe->max_rate = pipe->l3_ick;
+	pipe->entities = 0;
 
 	subdev = isp_video_remote_subdev(pipe->output, NULL);
 	if (subdev == NULL)
@@ -299,6 +300,9 @@ static int isp_video_validate_pipeline(struct isp_pipeline *pipe)
 
 	while (1) {
 		unsigned int shifter_link;
+
+		pipe->entities |= 1U << subdev->entity.id;
+
 		/* Retrieve the sink format */
 		pad = &subdev->entity.pads[0];
 		if (!(pad->flags & MEDIA_PAD_FL_SINK))
diff --git a/drivers/media/video/omap3isp/ispvideo.h b/drivers/media/video/omap3isp/ispvideo.h
index d91bdb91..c9187cb 100644
--- a/drivers/media/video/omap3isp/ispvideo.h
+++ b/drivers/media/video/omap3isp/ispvideo.h
@@ -88,6 +88,7 @@ enum isp_pipeline_state {
 /*
  * struct isp_pipeline - An ISP hardware pipeline
  * @error: A hardware error occurred during capture
+ * @entities: Bitmask of entities in the pipeline (indexed by entity ID)
  */
 struct isp_pipeline {
 	struct media_pipeline pipe;
@@ -96,6 +97,7 @@ struct isp_pipeline {
 	enum isp_pipeline_stream_state stream_state;
 	struct isp_video *input;
 	struct isp_video *output;
+	u32 entities;
 	unsigned long l3_ick;
 	unsigned int max_rate;
 	atomic_t frame_number;
-- 
Regards,

Laurent Pinchart

