Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:58827 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752738Ab0AKXg1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jan 2010 18:36:27 -0500
From: m-karicheri2@ti.com
To: linux-media@vger.kernel.org, khilman@deeprootsystems.com,
	mchehab@infradead.org
Cc: hverkuil@xs4all.nl, davinci-linux-open-source@linux.davincidsp.com,
	Muralidharan Karicheri <m-karicheri2@ti.com>
Subject: [PATCH - v4 1/4] V4L-vpfe_capture-remove-clock and platform code
Date: Mon, 11 Jan 2010 18:36:17 -0500
Message-Id: <1263252977-27457-4-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1263252977-27457-3-git-send-email-m-karicheri2@ti.com>
References: <1263252977-27457-1-git-send-email-m-karicheri2@ti.com>
 <1263252977-27457-2-git-send-email-m-karicheri2@ti.com>
 <1263252977-27457-3-git-send-email-m-karicheri2@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Muralidharan Karicheri <m-karicheri2@ti.com>

This combines the two patches sent earlier to change the clock configuration
and converting ccdc drivers to platform drivers. This has updated comments
against v1 of these patches.

In this patch, the clock configuration is moved to ccdc driver since clocks
are configured for ccdc. Also adding proper error codes for ccdc register
function and removing the ccdc memory resource handling.

Reviewed-by: Vaibhav Hiremath <hvaibhav@ti.com>
Reviewed-by: Kevin Hilman <khilman@deeprootsystems.com>
Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
---
Rebased to latest linux-next tree
Applies to linux-next tree of v4l-dvb
 drivers/media/video/davinci/vpfe_capture.c |  131 +++-------------------------
 1 files changed, 13 insertions(+), 118 deletions(-)

diff --git a/drivers/media/video/davinci/vpfe_capture.c b/drivers/media/video/davinci/vpfe_capture.c
index de22bc9..885cd54 100644
--- a/drivers/media/video/davinci/vpfe_capture.c
+++ b/drivers/media/video/davinci/vpfe_capture.c
@@ -107,9 +107,6 @@ struct ccdc_config {
 	int vpfe_probed;
 	/* name of ccdc device */
 	char name[32];
-	/* for storing mem maps for CCDC */
-	int ccdc_addr_size;
-	void *__iomem ccdc_addr;
 };
 
 /* data structures */
@@ -229,7 +226,6 @@ int vpfe_register_ccdc_device(struct ccdc_hw_device *dev)
 	BUG_ON(!dev->hw_ops.set_image_window);
 	BUG_ON(!dev->hw_ops.get_image_window);
 	BUG_ON(!dev->hw_ops.get_line_length);
-	BUG_ON(!dev->hw_ops.setfbaddr);
 	BUG_ON(!dev->hw_ops.getfid);
 
 	mutex_lock(&ccdc_lock);
@@ -240,25 +236,23 @@ int vpfe_register_ccdc_device(struct ccdc_hw_device *dev)
 		 * walk through it during vpfe probe
 		 */
 		printk(KERN_ERR "vpfe capture not initialized\n");
-		ret = -1;
+		ret = -EFAULT;
 		goto unlock;
 	}
 
 	if (strcmp(dev->name, ccdc_cfg->name)) {
 		/* ignore this ccdc */
-		ret = -1;
+		ret = -EINVAL;
 		goto unlock;
 	}
 
 	if (ccdc_dev) {
 		printk(KERN_ERR "ccdc already registered\n");
-		ret = -1;
+		ret = -EINVAL;
 		goto unlock;
 	}
 
 	ccdc_dev = dev;
-	dev->hw_ops.set_ccdc_base(ccdc_cfg->ccdc_addr,
-				  ccdc_cfg->ccdc_addr_size);
 unlock:
 	mutex_unlock(&ccdc_lock);
 	return ret;
@@ -1786,61 +1780,6 @@ static struct vpfe_device *vpfe_initialize(void)
 	return vpfe_dev;
 }
 
-static void vpfe_disable_clock(struct vpfe_device *vpfe_dev)
-{
-	struct vpfe_config *vpfe_cfg = vpfe_dev->cfg;
-
-	clk_disable(vpfe_cfg->vpssclk);
-	clk_put(vpfe_cfg->vpssclk);
-	clk_disable(vpfe_cfg->slaveclk);
-	clk_put(vpfe_cfg->slaveclk);
-	v4l2_info(vpfe_dev->pdev->driver,
-		 "vpfe vpss master & slave clocks disabled\n");
-}
-
-static int vpfe_enable_clock(struct vpfe_device *vpfe_dev)
-{
-	struct vpfe_config *vpfe_cfg = vpfe_dev->cfg;
-	int ret = -ENOENT;
-
-	vpfe_cfg->vpssclk = clk_get(vpfe_dev->pdev, "vpss_master");
-	if (NULL == vpfe_cfg->vpssclk) {
-		v4l2_err(vpfe_dev->pdev->driver, "No clock defined for"
-			 "vpss_master\n");
-		return ret;
-	}
-
-	if (clk_enable(vpfe_cfg->vpssclk)) {
-		v4l2_err(vpfe_dev->pdev->driver,
-			"vpfe vpss master clock not enabled\n");
-		goto out;
-	}
-	v4l2_info(vpfe_dev->pdev->driver,
-		 "vpfe vpss master clock enabled\n");
-
-	vpfe_cfg->slaveclk = clk_get(vpfe_dev->pdev, "vpss_slave");
-	if (NULL == vpfe_cfg->slaveclk) {
-		v4l2_err(vpfe_dev->pdev->driver,
-			"No clock defined for vpss slave\n");
-		goto out;
-	}
-
-	if (clk_enable(vpfe_cfg->slaveclk)) {
-		v4l2_err(vpfe_dev->pdev->driver,
-			 "vpfe vpss slave clock not enabled\n");
-		goto out;
-	}
-	v4l2_info(vpfe_dev->pdev->driver, "vpfe vpss slave clock enabled\n");
-	return 0;
-out:
-	if (vpfe_cfg->vpssclk)
-		clk_put(vpfe_cfg->vpssclk);
-	if (vpfe_cfg->slaveclk)
-		clk_put(vpfe_cfg->slaveclk);
-
-	return -1;
-}
-
 /*
  * vpfe_probe : This function creates device entries by register
  * itself to the V4L2 driver and initializes fields of each
@@ -1870,7 +1809,7 @@ static __init int vpfe_probe(struct platform_device *pdev)
 
 	if (NULL == pdev->dev.platform_data) {
 		v4l2_err(pdev->dev.driver, "Unable to get vpfe config\n");
-		ret = -ENOENT;
+		ret = -ENODEV;
 		goto probe_free_dev_mem;
 	}
 
@@ -1884,18 +1823,13 @@ static __init int vpfe_probe(struct platform_device *pdev)
 		goto probe_free_dev_mem;
 	}
 
-	/* enable vpss clocks */
-	ret = vpfe_enable_clock(vpfe_dev);
-	if (ret)
-		goto probe_free_dev_mem;
-
 	mutex_lock(&ccdc_lock);
 	/* Allocate memory for ccdc configuration */
 	ccdc_cfg = kmalloc(sizeof(struct ccdc_config), GFP_KERNEL);
 	if (NULL == ccdc_cfg) {
 		v4l2_err(pdev->dev.driver,
 			 "Memory allocation failed for ccdc_cfg\n");
-		goto probe_disable_clock;
+		goto probe_free_dev_mem;
 	}
 
 	strncpy(ccdc_cfg->name, vpfe_cfg->ccdc, 32);
@@ -1904,61 +1838,34 @@ static __init int vpfe_probe(struct platform_device *pdev)
 	if (!res1) {
 		v4l2_err(pdev->dev.driver,
 			 "Unable to get interrupt for VINT0\n");
-		ret = -ENOENT;
-		goto probe_disable_clock;
+		ret = -ENODEV;
+		goto probe_free_ccdc_cfg_mem;
 	}
 	vpfe_dev->ccdc_irq0 = res1->start;
 
 	/* Get VINT1 irq resource */
-	res1 = platform_get_resource(pdev,
-				IORESOURCE_IRQ, 1);
+	res1 = platform_get_resource(pdev, IORESOURCE_IRQ, 1);
 	if (!res1) {
 		v4l2_err(pdev->dev.driver,
 			 "Unable to get interrupt for VINT1\n");
-		ret = -ENOENT;
-		goto probe_disable_clock;
+		ret = -ENODEV;
+		goto probe_free_ccdc_cfg_mem;
 	}
 	vpfe_dev->ccdc_irq1 = res1->start;
 
-	/* Get address base of CCDC */
-	res1 = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res1) {
-		v4l2_err(pdev->dev.driver,
-			"Unable to get register address map\n");
-		ret = -ENOENT;
-		goto probe_disable_clock;
-	}
-
-	ccdc_cfg->ccdc_addr_size = res1->end - res1->start + 1;
-	if (!request_mem_region(res1->start, ccdc_cfg->ccdc_addr_size,
-				pdev->dev.driver->name)) {
-		v4l2_err(pdev->dev.driver,
-			"Failed request_mem_region for ccdc base\n");
-		ret = -ENXIO;
-		goto probe_disable_clock;
-	}
-	ccdc_cfg->ccdc_addr = ioremap_nocache(res1->start,
-					     ccdc_cfg->ccdc_addr_size);
-	if (!ccdc_cfg->ccdc_addr) {
-		v4l2_err(pdev->dev.driver, "Unable to ioremap ccdc addr\n");
-		ret = -ENXIO;
-		goto probe_out_release_mem1;
-	}
-
 	ret = request_irq(vpfe_dev->ccdc_irq0, vpfe_isr, IRQF_DISABLED,
 			  "vpfe_capture0", vpfe_dev);
 
 	if (0 != ret) {
 		v4l2_err(pdev->dev.driver, "Unable to request interrupt\n");
-		goto probe_out_unmap1;
+		goto probe_free_ccdc_cfg_mem;
 	}
 
 	/* Allocate memory for video device */
 	vfd = video_device_alloc();
 	if (NULL == vfd) {
 		ret = -ENOMEM;
-		v4l2_err(pdev->dev.driver,
-			"Unable to alloc video device\n");
+		v4l2_err(pdev->dev.driver, "Unable to alloc video device\n");
 		goto probe_out_release_irq;
 	}
 
@@ -2073,12 +1980,7 @@ probe_out_video_release:
 		video_device_release(vpfe_dev->video_dev);
 probe_out_release_irq:
 	free_irq(vpfe_dev->ccdc_irq0, vpfe_dev);
-probe_out_unmap1:
-	iounmap(ccdc_cfg->ccdc_addr);
-probe_out_release_mem1:
-	release_mem_region(res1->start, res1->end - res1->start + 1);
-probe_disable_clock:
-	vpfe_disable_clock(vpfe_dev);
+probe_free_ccdc_cfg_mem:
 	mutex_unlock(&ccdc_lock);
 	kfree(ccdc_cfg);
 probe_free_dev_mem:
@@ -2092,7 +1994,6 @@ probe_free_dev_mem:
 static int __devexit vpfe_remove(struct platform_device *pdev)
 {
 	struct vpfe_device *vpfe_dev = platform_get_drvdata(pdev);
-	struct resource *res;
 
 	v4l2_info(pdev->dev.driver, "vpfe_remove\n");
 
@@ -2100,12 +2001,6 @@ static int __devexit vpfe_remove(struct platform_device *pdev)
 	kfree(vpfe_dev->sd);
 	v4l2_device_unregister(&vpfe_dev->v4l2_dev);
 	video_unregister_device(vpfe_dev->video_dev);
-	mutex_lock(&ccdc_lock);
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(res->start, res->end - res->start + 1);
-	iounmap(ccdc_cfg->ccdc_addr);
-	mutex_unlock(&ccdc_lock);
-	vpfe_disable_clock(vpfe_dev);
 	kfree(vpfe_dev);
 	kfree(ccdc_cfg);
 	return 0;
-- 
1.6.0.4

