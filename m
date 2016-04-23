Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35898 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498AbcDWXtt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Apr 2016 19:49:49 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 04/13] v4l: vsp1: Don't handle clocks manually
Date: Sun, 24 Apr 2016 02:49:51 +0300
Message-Id: <1461455400-28767-5-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1461455400-28767-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1461455400-28767-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The power domain performs functional clock handling when using runtime
PM, there's no need to enable and disable the clock manually.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1.h     |  1 -
 drivers/media/platform/vsp1/vsp1_drv.c | 20 ++------------------
 2 files changed, 2 insertions(+), 19 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1.h b/drivers/media/platform/vsp1/vsp1.h
index 9e09bce43cf3..37cc05e34de0 100644
--- a/drivers/media/platform/vsp1/vsp1.h
+++ b/drivers/media/platform/vsp1/vsp1.h
@@ -62,7 +62,6 @@ struct vsp1_device {
 	const struct vsp1_device_info *info;
 
 	void __iomem *mmio;
-	struct clk *clock;
 
 	struct vsp1_bru *bru;
 	struct vsp1_hsit *hsi;
diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index d6abc7f1216a..13907d4f08af 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -514,10 +514,6 @@ static int vsp1_pm_resume(struct device *dev)
 
 static int vsp1_pm_runtime_suspend(struct device *dev)
 {
-	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
-
-	clk_disable_unprepare(vsp1->clock);
-
 	return 0;
 }
 
@@ -526,16 +522,10 @@ static int vsp1_pm_runtime_resume(struct device *dev)
 	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
 	int ret;
 
-	ret = clk_prepare_enable(vsp1->clock);
-	if (ret < 0)
-		return ret;
-
 	if (vsp1->info) {
 		ret = vsp1_device_init(vsp1);
-		if (ret < 0) {
-			clk_disable_unprepare(vsp1->clock);
+		if (ret < 0)
 			return ret;
-		}
 	}
 
 	return 0;
@@ -640,18 +630,12 @@ static int vsp1_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, vsp1);
 
-	/* I/O, IRQ and clock resources */
+	/* I/O and IRQ resources (clock managed by the clock PM domain) */
 	io = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	vsp1->mmio = devm_ioremap_resource(&pdev->dev, io);
 	if (IS_ERR(vsp1->mmio))
 		return PTR_ERR(vsp1->mmio);
 
-	vsp1->clock = devm_clk_get(&pdev->dev, NULL);
-	if (IS_ERR(vsp1->clock)) {
-		dev_err(&pdev->dev, "failed to get clock\n");
-		return PTR_ERR(vsp1->clock);
-	}
-
 	irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (!irq) {
 		dev_err(&pdev->dev, "missing IRQ\n");
-- 
2.7.3

