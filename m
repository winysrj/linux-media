Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:34419 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963Ab3HVRzt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Aug 2013 13:55:49 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH 2/2] v4l: vsp1: Add support for RT clock
Date: Thu, 22 Aug 2013 19:56:57 +0200
Message-Id: <1377194217-24235-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1377194217-24235-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1377194217-24235-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The VSPR and VSPS instances use two clocks, the VSP1 system clock and
the VSP1 realtime clock. Both of them need to be enabled to access the
VSP1 registers.

Add support for an optional RT clock and enable/disable it along with
the system clock.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1.h     |  1 +
 drivers/media/platform/vsp1/vsp1_drv.c | 40 +++++++++++++++++++++++++++++-----
 2 files changed, 36 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1.h b/drivers/media/platform/vsp1/vsp1.h
index 11ac94b..d6c6ecd 100644
--- a/drivers/media/platform/vsp1/vsp1.h
+++ b/drivers/media/platform/vsp1/vsp1.h
@@ -42,6 +42,7 @@ struct vsp1_device {
 
 	void __iomem *mmio;
 	struct clk *clock;
+	struct clk *rt_clock;
 
 	struct mutex lock;
 	int ref_count;
diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index 291d20f..9abe101 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -290,6 +290,33 @@ static int vsp1_device_init(struct vsp1_device *vsp1)
 	return 0;
 }
 
+static int vsp1_clocks_enable(struct vsp1_device *vsp1)
+{
+	int ret;
+
+	ret = clk_prepare_enable(vsp1->clock);
+	if (ret < 0)
+		return ret;
+
+	if (IS_ERR(vsp1->rt_clock))
+		return 0;
+
+	ret = clk_prepare_enable(vsp1->rt_clock);
+	if (ret < 0) {
+		clk_disable_unprepare(vsp1->clock);
+		return ret;
+	}
+
+	return 0;
+}
+
+static void vsp1_clocks_disable(struct vsp1_device *vsp1)
+{
+	if (!IS_ERR(vsp1->rt_clock))
+		clk_disable_unprepare(vsp1->rt_clock);
+	clk_disable_unprepare(vsp1->clock);
+}
+
 /*
  * vsp1_device_get - Acquire the VSP1 device
  *
@@ -307,7 +334,7 @@ struct vsp1_device *vsp1_device_get(struct vsp1_device *vsp1)
 	if (vsp1->ref_count > 0)
 		goto done;
 
-	ret = clk_prepare_enable(vsp1->clock);
+	ret = vsp1_clocks_enable(vsp1);
 	if (ret < 0) {
 		__vsp1 = NULL;
 		goto done;
@@ -315,7 +342,7 @@ struct vsp1_device *vsp1_device_get(struct vsp1_device *vsp1)
 
 	ret = vsp1_device_init(vsp1);
 	if (ret < 0) {
-		clk_disable_unprepare(vsp1->clock);
+		vsp1_clocks_disable(vsp1);
 		__vsp1 = NULL;
 		goto done;
 	}
@@ -339,7 +366,7 @@ void vsp1_device_put(struct vsp1_device *vsp1)
 	mutex_lock(&vsp1->lock);
 
 	if (--vsp1->ref_count == 0)
-		clk_disable_unprepare(vsp1->clock);
+		vsp1_clocks_disable(vsp1);
 
 	mutex_unlock(&vsp1->lock);
 }
@@ -358,7 +385,7 @@ static int vsp1_pm_suspend(struct device *dev)
 	if (vsp1->ref_count == 0)
 		return 0;
 
-	clk_disable_unprepare(vsp1->clock);
+	vsp1_clocks_disable(vsp1);
 	return 0;
 }
 
@@ -371,7 +398,7 @@ static int vsp1_pm_resume(struct device *dev)
 	if (vsp1->ref_count)
 		return 0;
 
-	return clk_prepare_enable(vsp1->clock);
+	return vsp1_clocks_enable(vsp1);
 }
 #endif
 
@@ -445,6 +472,9 @@ static int vsp1_probe(struct platform_device *pdev)
 		return PTR_ERR(vsp1->clock);
 	}
 
+	/* The RT clock is optional */
+	vsp1->rt_clock = devm_clk_get(&pdev->dev, "rt");
+
 	irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (!irq) {
 		dev_err(&pdev->dev, "missing IRQ\n");
-- 
1.8.1.5

