Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52683 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389Ab3LXMcX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Dec 2013 07:32:23 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH 2/3] omap3isp: Refactor modules stop failure handling
Date: Tue, 24 Dec 2013 13:32:43 +0100
Message-Id: <1387888364-21631-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1387888364-21631-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1387888364-21631-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Modules failing to stop are fatal errors for the preview engine only.
Flag that condition separately from the other stop failures to prepare
support for more fatal errors.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/isp.c | 36 +++++++++++++++++++++--------------
 drivers/media/platform/omap3isp/isp.h |  2 ++
 2 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 7e09c1d..5807185 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -873,15 +873,12 @@ static int isp_pipeline_enable(struct isp_pipeline *pipe,
 	unsigned long flags;
 	int ret;
 
-	/* If the preview engine crashed it might not respond to read/write
-	 * operations on the L4 bus. This would result in a bus fault and a
-	 * kernel oops. Refuse to start streaming in that case. This check must
-	 * be performed before the loop below to avoid starting entities if the
-	 * pipeline won't start anyway (those entities would then likely fail to
-	 * stop, making the problem worse).
+	/* Refuse to start streaming if an entity included in the pipeline has
+	 * crashed. This check must be performed before the loop below to avoid
+	 * starting entities if the pipeline won't start anyway (those entities
+	 * would then likely fail to stop, making the problem worse).
 	 */
-	if ((pipe->entities & isp->crashed) &
-	    (1U << isp->isp_prev.subdev.entity.id))
+	if (pipe->entities & isp->crashed)
 		return -EIO;
 
 	spin_lock_irqsave(&pipe->lock, flags);
@@ -1014,13 +1011,23 @@ static int isp_pipeline_disable(struct isp_pipeline *pipe)
 		else
 			ret = 0;
 
+		/* Handle stop failures. An entity that fails to stop can
+		 * usually just be restarted. Flag the stop failure nonetheless
+		 * to trigger an ISP reset the next time the device is released,
+		 * just in case.
+		 *
+		 * The preview engine is a special case. A failure to stop can
+		 * mean a hardware crash. When that happens the preview engine
+		 * won't respond to read/write operations on the L4 bus anymore,
+		 * resulting in a bus fault and a kernel oops next time it gets
+		 * accessed. Mark it as crashed to prevent pipelines including
+		 * it from being started.
+		 */
 		if (ret) {
 			dev_info(isp->dev, "Unable to stop %s\n", subdev->name);
-			/* If the entity failed to stopped, assume it has
-			 * crashed. Mark it as such, the ISP will be reset when
-			 * applications will release it.
-			 */
-			isp->crashed |= 1U << subdev->entity.id;
+			isp->stop_failure = true;
+			if (subdev == &isp->isp_prev.subdev)
+				isp->crashed |= 1U << subdev->entity.id;
 			failure = -ETIMEDOUT;
 		}
 	}
@@ -1225,6 +1232,7 @@ static int isp_reset(struct isp_device *isp)
 		udelay(1);
 	}
 
+	isp->stop_failure = false;
 	isp->crashed = 0;
 	return 0;
 }
@@ -1636,7 +1644,7 @@ void omap3isp_put(struct isp_device *isp)
 		/* Reset the ISP if an entity has failed to stop. This is the
 		 * only way to recover from such conditions.
 		 */
-		if (isp->crashed)
+		if (isp->crashed || isp->stop_failure)
 			isp_reset(isp);
 		isp_disable_clocks(isp);
 	}
diff --git a/drivers/media/platform/omap3isp/isp.h b/drivers/media/platform/omap3isp/isp.h
index 5b91f86..081f5ec 100644
--- a/drivers/media/platform/omap3isp/isp.h
+++ b/drivers/media/platform/omap3isp/isp.h
@@ -154,6 +154,7 @@ struct isp_xclk {
  *                  regions.
  * @stat_lock: Spinlock for handling statistics
  * @isp_mutex: Mutex for serializing requests to ISP.
+ * @stop_failure: Indicates that an entity failed to stop.
  * @crashed: Bitmask of crashed entities (indexed by entity ID)
  * @has_context: Context has been saved at least once and can be restored.
  * @ref_count: Reference count for handling multiple ISP requests.
@@ -191,6 +192,7 @@ struct isp_device {
 	/* ISP Obj */
 	spinlock_t stat_lock;	/* common lock for statistic drivers */
 	struct mutex isp_mutex;	/* For handling ref_count field */
+	bool stop_failure;
 	u32 crashed;
 	int has_context;
 	int ref_count;
-- 
1.8.3.2

