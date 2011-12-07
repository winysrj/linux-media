Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57340 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755801Ab1LGNp5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Dec 2011 08:45:57 -0500
Received: from localhost.localdomain (unknown [91.178.3.157])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 3275F35AA7
	for <linux-media@vger.kernel.org>; Wed,  7 Dec 2011 13:45:56 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH v2] omap3isp: Prevent pipelines that contain a crashed entity from starting
Date: Wed,  7 Dec 2011 14:46:04 +0100
Message-Id: <1323265564-19165-1-git-send-email-laurent.pinchart@ideasonboard.com>
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
Acked-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---
 drivers/media/video/omap3isp/isp.c |   26 ++++++++++++++++++++------
 drivers/media/video/omap3isp/isp.h |    3 ++-
 2 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/drivers/media/video/omap3isp/isp.c b/drivers/media/video/omap3isp/isp.c
index b818cac..172e811 100644
--- a/drivers/media/video/omap3isp/isp.c
+++ b/drivers/media/video/omap3isp/isp.c
@@ -741,6 +741,16 @@ static int isp_pipeline_enable(struct isp_pipeline *pipe,
 	unsigned long flags;
 	int ret;
 
+	/* If the preview engine crashed it might not respond to read/write
+	 * operations on the L4 bus. This would result in a bus fault and a
+	 * kernel oops. Refuse to start streaming in that case. This check must
+	 * be performed before the loop below to avoid starting entities if the
+	 * pipeline won't start anyway (those entities would then likely fail to
+	 * stop, making the problem worse).
+	 */
+	if (isp->crashed & (1 << isp->isp_prev.subdev.entity.id))
+		return -EIO;
+
 	spin_lock_irqsave(&pipe->lock, flags);
 	pipe->state &= ~(ISP_PIPELINE_IDLE_INPUT | ISP_PIPELINE_IDLE_OUTPUT);
 	spin_unlock_irqrestore(&pipe->lock, flags);
@@ -881,13 +891,15 @@ static int isp_pipeline_disable(struct isp_pipeline *pipe)
 
 		if (ret) {
 			dev_info(isp->dev, "Unable to stop %s\n", subdev->name);
+			/* If the entity failed to stopped, assume it has
+			 * crashed. Mark it as such, the ISP will be reset when
+			 * applications will release it.
+			 */
+			isp->crashed |= 1 << subdev->entity.id;
 			failure = -ETIMEDOUT;
 		}
 	}
 
-	if (failure < 0)
-		isp->needs_reset = true;
-
 	return failure;
 }
 
@@ -1071,6 +1083,7 @@ static int isp_reset(struct isp_device *isp)
 		udelay(1);
 	}
 
+	isp->crashed = 0;
 	return 0;
 }
 
@@ -1500,10 +1513,11 @@ void omap3isp_put(struct isp_device *isp)
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
index 705946e..6c3037a 100644
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
-- 
Regards,

Laurent Pinchart

