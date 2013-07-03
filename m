Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:52014 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753804Ab3GCF5l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Jul 2013 01:57:41 -0400
From: Libin Yang <lbyang@marvell.com>
To: <corbet@lwn.net>, <g.liakhovetski@gmx.de>
CC: <linux-media@vger.kernel.org>, <albert.v.wang@gmail.com>,
	Libin Yang <lbyang@marvell.com>,
	Albert Wang <twang13@marvell.com>
Subject: [PATCH v3 7/7] marvell-ccic: switch to resource managed allocation and request
Date: Wed, 3 Jul 2013 13:56:04 +0800
Message-ID: <1372830964-22323-8-git-send-email-lbyang@marvell.com>
In-Reply-To: <1372830964-22323-1-git-send-email-lbyang@marvell.com>
References: <1372830964-22323-1-git-send-email-lbyang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch switchs to resource managed allocation and request in mmp-driver.
It can remove free resource operations.

Signed-off-by: Albert Wang <twang13@marvell.com>
Signed-off-by: Libin Yang <lbyang@marvell.com>
---
 drivers/media/platform/marvell-ccic/mmp-driver.c |   60 ++++++++--------------
 1 file changed, 22 insertions(+), 38 deletions(-)

diff --git a/drivers/media/platform/marvell-ccic/mmp-driver.c b/drivers/media/platform/marvell-ccic/mmp-driver.c
index 7503983..94f7e5a 100644
--- a/drivers/media/platform/marvell-ccic/mmp-driver.c
+++ b/drivers/media/platform/marvell-ccic/mmp-driver.c
@@ -368,7 +368,7 @@ static int mmpcam_probe(struct platform_device *pdev)
 	if (!pdata)
 		return -ENODEV;
 
-	cam = kzalloc(sizeof(*cam), GFP_KERNEL);
+	cam = devm_kzalloc(&pdev->dev, sizeof(*cam), GFP_KERNEL);
 	if (cam == NULL)
 		return -ENOMEM;
 	cam->pdev = pdev;
@@ -399,15 +399,11 @@ static int mmpcam_probe(struct platform_device *pdev)
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (res == NULL) {
 		dev_err(&pdev->dev, "no iomem resource!\n");
-		ret = -ENODEV;
-		goto out_free;
-	}
-	mcam->regs = ioremap(res->start, resource_size(res));
-	if (mcam->regs == NULL) {
-		dev_err(&pdev->dev, "MMIO ioremap fail\n");
-		ret = -ENODEV;
-		goto out_free;
+		return -ENODEV;
 	}
+	mcam->regs = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(mcam->regs))
+		return PTR_ERR(mcam->regs);
 	/*
 	 * Power/clock memory is elsewhere; get it too.  Perhaps this
 	 * should really be managed outside of this driver?
@@ -415,40 +411,37 @@ static int mmpcam_probe(struct platform_device *pdev)
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
 	if (res == NULL) {
 		dev_err(&pdev->dev, "no power resource!\n");
-		ret = -ENODEV;
-		goto out_unmap1;
-	}
-	cam->power_regs = ioremap(res->start, resource_size(res));
-	if (cam->power_regs == NULL) {
-		dev_err(&pdev->dev, "power MMIO ioremap fail\n");
-		ret = -ENODEV;
-		goto out_unmap1;
+		return -ENODEV;
 	}
+	cam->power_regs = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(cam->power_regs))
+		return PTR_ERR(cam->power_regs);
 	/*
 	 * Find the i2c adapter.  This assumes, of course, that the
 	 * i2c bus is already up and functioning.
 	 */
 	mcam->i2c_adapter = platform_get_drvdata(pdata->i2c_device);
 	if (mcam->i2c_adapter == NULL) {
-		ret = -ENODEV;
 		dev_err(&pdev->dev, "No i2c adapter\n");
-		goto out_unmap2;
+		return -ENODEV;
 	}
 	/*
 	 * Sensor GPIO pins.
 	 */
-	ret = gpio_request(pdata->sensor_power_gpio, "cam-power");
+	ret = devm_gpio_request(&pdev->dev, pdata->sensor_power_gpio,
+							"cam-power");
 	if (ret) {
 		dev_err(&pdev->dev, "Can't get sensor power gpio %d",
 				pdata->sensor_power_gpio);
-		goto out_unmap2;
+		return ret;
 	}
 	gpio_direction_output(pdata->sensor_power_gpio, 0);
-	ret = gpio_request(pdata->sensor_reset_gpio, "cam-reset");
+	ret = devm_gpio_request(&pdev->dev, pdata->sensor_reset_gpio,
+							"cam-reset");
 	if (ret) {
 		dev_err(&pdev->dev, "Can't get sensor reset gpio %d",
 				pdata->sensor_reset_gpio);
-		goto out_gpio;
+		return ret;
 	}
 	gpio_direction_output(pdata->sensor_reset_gpio, 0);
 
@@ -459,10 +452,10 @@ static int mmpcam_probe(struct platform_device *pdev)
 	 */
 	ret = mmpcam_power_up(mcam);
 	if (ret)
-		goto out_gpio2;
+		goto out_deinit_clk;
 	ret = mccic_register(mcam);
 	if (ret)
-		goto out_pwdn;
+		goto out_power_down;
 	/*
 	 * Finally, set up our IRQ now that the core is ready to
 	 * deal with it.
@@ -473,8 +466,8 @@ static int mmpcam_probe(struct platform_device *pdev)
 		goto out_unregister;
 	}
 	cam->irq = res->start;
-	ret = request_irq(cam->irq, mmpcam_irq, IRQF_SHARED,
-			"mmp-camera", mcam);
+	ret = devm_request_irq(&pdev->dev, cam->irq, mmpcam_irq, IRQF_SHARED,
+					"mmp-camera", mcam);
 	if (ret == 0) {
 		mmpcam_add_device(cam);
 		return 0;
@@ -482,19 +475,10 @@ static int mmpcam_probe(struct platform_device *pdev)
 
 out_unregister:
 	mccic_shutdown(mcam);
-out_pwdn:
+out_power_down:
 	mmpcam_power_down(mcam);
-out_gpio2:
+out_deinit_clk:
 	mcam_deinit_clk(mcam);
-	gpio_free(pdata->sensor_reset_gpio);
-out_gpio:
-	gpio_free(pdata->sensor_power_gpio);
-out_unmap2:
-	iounmap(cam->power_regs);
-out_unmap1:
-	iounmap(mcam->regs);
-out_free:
-	kfree(cam);
 	return ret;
 }
 
-- 
1.7.9.5

