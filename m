Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42840 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758641AbaDBOai (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Apr 2014 10:30:38 -0400
Received: from avalon.ideasonboard.com (unknown [91.178.214.76])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id E3ACB359AD
	for <linux-media@vger.kernel.org>; Wed,  2 Apr 2014 16:28:55 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] v4l: vsp1: Remove unexisting rt clocks
Date: Wed,  2 Apr 2014 16:32:37 +0200
Message-Id: <1396449157-4825-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The VSP1 has no rt clock. Remove them from the driver.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1.h     |  1 -
 drivers/media/platform/vsp1/vsp1_drv.c | 40 +++++-----------------------------
 2 files changed, 5 insertions(+), 36 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1.h b/drivers/media/platform/vsp1/vsp1.h
index 94d1b02..732400e 100644
--- a/drivers/media/platform/vsp1/vsp1.h
+++ b/drivers/media/platform/vsp1/vsp1.h
@@ -45,7 +45,6 @@ struct vsp1_device {
 
 	void __iomem *mmio;
 	struct clk *clock;
-	struct clk *rt_clock;
 
 	struct mutex lock;
 	int ref_count;
diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index 0df0a99..6f370da 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -329,33 +329,6 @@ static int vsp1_device_init(struct vsp1_device *vsp1)
 	return 0;
 }
 
-static int vsp1_clocks_enable(struct vsp1_device *vsp1)
-{
-	int ret;
-
-	ret = clk_prepare_enable(vsp1->clock);
-	if (ret < 0)
-		return ret;
-
-	if (IS_ERR(vsp1->rt_clock))
-		return 0;
-
-	ret = clk_prepare_enable(vsp1->rt_clock);
-	if (ret < 0) {
-		clk_disable_unprepare(vsp1->clock);
-		return ret;
-	}
-
-	return 0;
-}
-
-static void vsp1_clocks_disable(struct vsp1_device *vsp1)
-{
-	if (!IS_ERR(vsp1->rt_clock))
-		clk_disable_unprepare(vsp1->rt_clock);
-	clk_disable_unprepare(vsp1->clock);
-}
-
 /*
  * vsp1_device_get - Acquire the VSP1 device
  *
@@ -373,7 +346,7 @@ struct vsp1_device *vsp1_device_get(struct vsp1_device *vsp1)
 	if (vsp1->ref_count > 0)
 		goto done;
 
-	ret = vsp1_clocks_enable(vsp1);
+	ret = clk_prepare_enable(vsp1->clock);
 	if (ret < 0) {
 		__vsp1 = NULL;
 		goto done;
@@ -381,7 +354,7 @@ struct vsp1_device *vsp1_device_get(struct vsp1_device *vsp1)
 
 	ret = vsp1_device_init(vsp1);
 	if (ret < 0) {
-		vsp1_clocks_disable(vsp1);
+		clk_disable_unprepare(vsp1->clock);
 		__vsp1 = NULL;
 		goto done;
 	}
@@ -405,7 +378,7 @@ void vsp1_device_put(struct vsp1_device *vsp1)
 	mutex_lock(&vsp1->lock);
 
 	if (--vsp1->ref_count == 0)
-		vsp1_clocks_disable(vsp1);
+		clk_disable_unprepare(vsp1->clock);
 
 	mutex_unlock(&vsp1->lock);
 }
@@ -424,7 +397,7 @@ static int vsp1_pm_suspend(struct device *dev)
 	if (vsp1->ref_count == 0)
 		return 0;
 
-	vsp1_clocks_disable(vsp1);
+	clk_disable_unprepare(vsp1->clock);
 	return 0;
 }
 
@@ -437,7 +410,7 @@ static int vsp1_pm_resume(struct device *dev)
 	if (vsp1->ref_count)
 		return 0;
 
-	return vsp1_clocks_enable(vsp1);
+	return clk_prepare_enable(vsp1->clock);
 }
 #endif
 
@@ -511,9 +484,6 @@ static int vsp1_probe(struct platform_device *pdev)
 		return PTR_ERR(vsp1->clock);
 	}
 
-	/* The RT clock is optional */
-	vsp1->rt_clock = devm_clk_get(&pdev->dev, "rt");
-
 	irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (!irq) {
 		dev_err(&pdev->dev, "missing IRQ\n");
-- 
Regards,

Laurent Pinchart

