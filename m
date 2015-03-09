Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:36335 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbbCIGjl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Mar 2015 02:39:41 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Josh Wu <josh.wu@atmel.com>
Subject: [PATCH 2/4] soc-camera: Make clock_start and clock_stop operations optional
Date: Mon,  9 Mar 2015 08:39:34 +0200
Message-Id: <1425883176-29859-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1425883176-29859-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1425883176-29859-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of forcing drivers to implement empty clock operations, make
them optional.

v4l2 clock registration in the soc-camera core should probably be
conditionned on the availability of those operations, but careful
review and/or testing of all drivers would be needed, so that should be
a separate step.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/soc_camera/soc_camera.c | 62 ++++++++++++++------------
 1 file changed, 33 insertions(+), 29 deletions(-)

diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 4376172..0943125 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -177,6 +177,30 @@ static int __soc_camera_power_off(struct soc_camera_device *icd)
 	return 0;
 }
 
+static int soc_camera_clock_start(struct soc_camera_host *ici)
+{
+	int ret;
+
+	if (!ici->ops->clock_start)
+		return 0;
+
+	mutex_lock(&ici->clk_lock);
+	ret = ici->ops->clock_start(ici);
+	mutex_unlock(&ici->clk_lock);
+
+	return ret;
+}
+
+static void soc_camera_clock_stop(struct soc_camera_host *ici)
+{
+	if (!ici->ops->clock_stop)
+		return;
+
+	mutex_lock(&ici->clk_lock);
+	ici->ops->clock_stop(ici);
+	mutex_unlock(&ici->clk_lock);
+}
+
 const struct soc_camera_format_xlate *soc_camera_xlate_by_fourcc(
 	struct soc_camera_device *icd, unsigned int fourcc)
 {
@@ -584,9 +608,7 @@ static int soc_camera_add_device(struct soc_camera_device *icd)
 		return -EBUSY;
 
 	if (!icd->clk) {
-		mutex_lock(&ici->clk_lock);
-		ret = ici->ops->clock_start(ici);
-		mutex_unlock(&ici->clk_lock);
+		ret = soc_camera_clock_start(ici);
 		if (ret < 0)
 			return ret;
 	}
@@ -602,11 +624,8 @@ static int soc_camera_add_device(struct soc_camera_device *icd)
 	return 0;
 
 eadd:
-	if (!icd->clk) {
-		mutex_lock(&ici->clk_lock);
-		ici->ops->clock_stop(ici);
-		mutex_unlock(&ici->clk_lock);
-	}
+	if (!icd->clk)
+		soc_camera_clock_stop(ici);
 	return ret;
 }
 
@@ -619,11 +638,8 @@ static void soc_camera_remove_device(struct soc_camera_device *icd)
 
 	if (ici->ops->remove)
 		ici->ops->remove(icd);
-	if (!icd->clk) {
-		mutex_lock(&ici->clk_lock);
-		ici->ops->clock_stop(ici);
-		mutex_unlock(&ici->clk_lock);
-	}
+	if (!icd->clk)
+		soc_camera_clock_stop(ici);
 	ici->icd = NULL;
 }
 
@@ -1178,7 +1194,6 @@ static int soc_camera_clk_enable(struct v4l2_clk *clk)
 {
 	struct soc_camera_device *icd = clk->priv;
 	struct soc_camera_host *ici;
-	int ret;
 
 	if (!icd || !icd->parent)
 		return -ENODEV;
@@ -1192,10 +1207,7 @@ static int soc_camera_clk_enable(struct v4l2_clk *clk)
 	 * If a different client is currently being probed, the host will tell
 	 * you to go
 	 */
-	mutex_lock(&ici->clk_lock);
-	ret = ici->ops->clock_start(ici);
-	mutex_unlock(&ici->clk_lock);
-	return ret;
+	return soc_camera_clock_start(ici);
 }
 
 static void soc_camera_clk_disable(struct v4l2_clk *clk)
@@ -1208,9 +1220,7 @@ static void soc_camera_clk_disable(struct v4l2_clk *clk)
 
 	ici = to_soc_camera_host(icd->parent);
 
-	mutex_lock(&ici->clk_lock);
-	ici->ops->clock_stop(ici);
-	mutex_unlock(&ici->clk_lock);
+	soc_camera_clock_stop(ici);
 
 	module_put(ici->ops->owner);
 }
@@ -1752,9 +1762,7 @@ static int soc_camera_probe(struct soc_camera_host *ici,
 		ret = -EINVAL;
 		goto eadd;
 	} else {
-		mutex_lock(&ici->clk_lock);
-		ret = ici->ops->clock_start(ici);
-		mutex_unlock(&ici->clk_lock);
+		ret = soc_camera_clock_start(ici);
 		if (ret < 0)
 			goto eadd;
 
@@ -1794,9 +1802,7 @@ efinish:
 		module_put(control->driver->owner);
 enodrv:
 eadddev:
-		mutex_lock(&ici->clk_lock);
-		ici->ops->clock_stop(ici);
-		mutex_unlock(&ici->clk_lock);
+		soc_camera_clock_stop(ici);
 	}
 eadd:
 	if (icd->vdev) {
@@ -1922,8 +1928,6 @@ int soc_camera_host_register(struct soc_camera_host *ici)
 	    ((!ici->ops->init_videobuf ||
 	      !ici->ops->reqbufs) &&
 	     !ici->ops->init_videobuf2) ||
-	    !ici->ops->clock_start ||
-	    !ici->ops->clock_stop ||
 	    !ici->ops->poll ||
 	    !ici->v4l2_dev.dev)
 		return -EINVAL;
-- 
2.0.5

