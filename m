Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52678 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527Ab1KSBO5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Nov 2011 20:14:57 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH] omap3isp: Prevent pipelines that contain a crashed entity from starting
Date: Sat, 19 Nov 2011 02:15:10 +0100
Message-Id: <1321665310-25362-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The OMAP3 ISP preview engine will violate the L4 bus protocol if we try
to write some of its internal registers after it failed to stop
properly. This generates an external abort on non-linefetch fault,
triggering a fatal kernel oops.

We can't always prevent preview engine stop failures (they can for
instance be caused by a sensor crash), but we can improve the system
reliability by refusing to start streaming on a pipeline that contains
a block that failed to crash. The driver will then eventually reset the
ISP (when all applications will have closed their file handles related
to OMAP3 ISP device nodes), making the ISP usable again.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---
 drivers/media/video/omap3isp/isp.c |   24 ++++++++++++++++++------
 drivers/media/video/omap3isp/isp.h |    3 ++-
 2 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/media/video/omap3isp/isp.c b/drivers/media/video/omap3isp/isp.c
index b818cac..bad3f24 100644
--- a/drivers/media/video/omap3isp/isp.c
+++ b/drivers/media/video/omap3isp/isp.c
@@ -761,10 +761,21 @@ static int isp_pipeline_enable(struct isp_pipeline *pipe,
 		entity = pad->entity;
 		subdev = media_entity_to_v4l2_subdev(entity);
 
+		/* The entity can already be running only if it failed to stop
+		 * at the last isp_disable_pipeline() call. This is a sign that
+		 * it likely crashed, and might not respond to read/write
+		 * operations on the L4 bus. This would result in a bus fault
+		 * and a kernel oops. Refuse to start streaming in that case.
+		 */
+		if (isp->running & (1 << subdev->entity.id))
+			return -EIO;
+
 		ret = v4l2_subdev_call(subdev, video, s_stream, mode);
 		if (ret < 0 && ret != -ENOIOCTLCMD)
 			return ret;
 
+		isp->running |= 1 << subdev->entity.id;
+
 		if (subdev == &isp->isp_ccdc.subdev) {
 			v4l2_subdev_call(&isp->isp_aewb.subdev, video,
 					s_stream, mode);
@@ -882,12 +893,11 @@ static int isp_pipeline_disable(struct isp_pipeline *pipe)
 		if (ret) {
 			dev_info(isp->dev, "Unable to stop %s\n", subdev->name);
 			failure = -ETIMEDOUT;
+		} else {
+			isp->running &= ~(1 << subdev->entity.id);
 		}
 	}
 
-	if (failure < 0)
-		isp->needs_reset = true;
-
 	return failure;
 }
 
@@ -1071,6 +1081,7 @@ static int isp_reset(struct isp_device *isp)
 		udelay(1);
 	}
 
+	isp->running = 0;
 	return 0;
 }
 
@@ -1500,10 +1511,11 @@ void omap3isp_put(struct isp_device *isp)
 	if (--isp->ref_count == 0) {
 		isp_disable_interrupts(isp);
 		isp_save_ctx(isp);
-		if (isp->needs_reset) {
+		/* Reset the ISP if an entity has failed to stop. This is the
+		 * only way to recover from such conditions.
+		 */
+		if (isp->running)
 			isp_reset(isp);
-			isp->needs_reset = false;
-		}
 		isp_disable_clocks(isp);
 	}
 	mutex_unlock(&isp->isp_mutex);
diff --git a/drivers/media/video/omap3isp/isp.h b/drivers/media/video/omap3isp/isp.h
index 705946e..c958f07 100644
--- a/drivers/media/video/omap3isp/isp.h
+++ b/drivers/media/video/omap3isp/isp.h
@@ -145,6 +145,7 @@ struct isp_platform_callback {
  * @raw_dmamask: Raw DMA mask
  * @stat_lock: Spinlock for handling statistics
  * @isp_mutex: Mutex for serializing requests to ISP.
+ * @running: Bitmask of running entities (indexed by entity ID)
  * @has_context: Context has been saved at least once and can be restored.
  * @ref_count: Reference count for handling multiple ISP requests.
  * @cam_ick: Pointer to camera interface clock structure.
@@ -184,7 +185,7 @@ struct isp_device {
 	/* ISP Obj */
 	spinlock_t stat_lock;	/* common lock for statistic drivers */
 	struct mutex isp_mutex;	/* For handling ref_count field */
-	bool needs_reset;
+	u32 running;
 	int has_context;
 	int ref_count;
 	unsigned int autoidle;
-- 
Regards,

Laurent Pinchart

