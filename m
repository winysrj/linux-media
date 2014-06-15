Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:57572 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbaFOUR1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Jun 2014 16:17:27 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: g.liakhovetski@gmx.de, devicetree@vger.kernel.org
Cc: linux-media@vger.kernel.org,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH 2/2] media: soc_camera: pxa_camera device-tree support
Date: Sun, 15 Jun 2014 22:17:16 +0200
Message-Id: <1402863436-30311-2-git-send-email-robert.jarzmik@free.fr>
In-Reply-To: <1402863436-30311-1-git-send-email-robert.jarzmik@free.fr>
References: <1402863436-30311-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add device-tree support to pxa_camera host driver.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/media/platform/soc_camera/pxa_camera.c | 80 ++++++++++++++++++++++++++
 1 file changed, 80 insertions(+)

diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
index d4df305..e48d821 100644
--- a/drivers/media/platform/soc_camera/pxa_camera.c
+++ b/drivers/media/platform/soc_camera/pxa_camera.c
@@ -34,6 +34,7 @@
 #include <media/videobuf-dma-sg.h>
 #include <media/soc_camera.h>
 #include <media/soc_mediabus.h>
+#include <media/v4l2-of.h>
 
 #include <linux/videodev2.h>
 
@@ -1650,9 +1651,74 @@ static struct soc_camera_host_ops pxa_soc_camera_host_ops = {
 	.set_bus_param	= pxa_camera_set_bus_param,
 };
 
+static const struct of_device_id pxacamera_dt_ids[] = {
+	{ .compatible = "mrvl,pxa_camera", },
+	{ }
+};
+
+static int pxa_camera_pdata_from_dt(struct device *dev,
+				    struct pxacamera_platform_data *pdata)
+{
+	int err = 0;
+	struct device_node *np = dev->of_node;
+	struct v4l2_of_endpoint ep;
+
+	dev_info(dev, "RJK: %s()\n", __func__);
+	err = of_property_read_u32(np, "mclk_10khz",
+				   (u32 *)&pdata->mclk_10khz);
+	if (!err)
+		pdata->flags |= PXA_CAMERA_MCLK_EN;
+
+	np = of_graph_get_next_endpoint(np, NULL);
+	if (!np) {
+		dev_err(dev, "could not find endpoint\n");
+		return -EINVAL;
+	}
+
+	err = v4l2_of_parse_endpoint(np, &ep);
+	if (err) {
+		dev_err(dev, "could not parse endpoint\n");
+		return err;
+	}
+
+	switch (ep.bus.parallel.bus_width) {
+	case 4:
+		pdata->flags |= PXA_CAMERA_DATAWIDTH_4;
+		break;
+	case 5:
+		pdata->flags |= PXA_CAMERA_DATAWIDTH_5;
+		break;
+	case 8:
+		pdata->flags |= PXA_CAMERA_DATAWIDTH_8;
+		break;
+	case 9:
+		pdata->flags |= PXA_CAMERA_DATAWIDTH_9;
+		break;
+	case 10:
+		pdata->flags |= PXA_CAMERA_DATAWIDTH_10;
+		break;
+	default:
+		break;
+	};
+
+	if (ep.bus.parallel.flags & V4L2_MBUS_MASTER)
+		pdata->flags |= PXA_CAMERA_MASTER;
+	if (ep.bus.parallel.flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH)
+		pdata->flags |= PXA_CAMERA_HSP;
+	if (ep.bus.parallel.flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH)
+		pdata->flags |= PXA_CAMERA_VSP;
+	if (ep.bus.parallel.flags & V4L2_MBUS_PCLK_SAMPLE_RISING)
+		pdata->flags |= PXA_CAMERA_PCLK_EN | PXA_CAMERA_PCP;
+	if (ep.bus.parallel.flags & V4L2_MBUS_PCLK_SAMPLE_FALLING)
+		pdata->flags |= PXA_CAMERA_PCLK_EN;
+
+	return 0;
+}
+
 static int pxa_camera_probe(struct platform_device *pdev)
 {
 	struct pxa_camera_dev *pcdev;
+	struct pxacamera_platform_data pdata_dt;
 	struct resource *res;
 	void __iomem *base;
 	int irq;
@@ -1676,6 +1742,13 @@ static int pxa_camera_probe(struct platform_device *pdev)
 	pcdev->res = res;
 
 	pcdev->pdata = pdev->dev.platform_data;
+	if (&pdev->dev.of_node && !pcdev->pdata)
+		err = pxa_camera_pdata_from_dt(&pdev->dev, &pdata_dt);
+	if (err < 0)
+		return err;
+	else
+		pcdev->pdata = &pdata_dt;
+
 	pcdev->platform_flags = pcdev->pdata->flags;
 	if (!(pcdev->platform_flags & (PXA_CAMERA_DATAWIDTH_8 |
 			PXA_CAMERA_DATAWIDTH_9 | PXA_CAMERA_DATAWIDTH_10))) {
@@ -1799,10 +1872,17 @@ static const struct dev_pm_ops pxa_camera_pm = {
 	.resume		= pxa_camera_resume,
 };
 
+static const struct of_device_id pxa_camera_of_match[] = {
+	{ .compatible = "mrvl,pxa_camera", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, pxa_camera_of_match);
+
 static struct platform_driver pxa_camera_driver = {
 	.driver		= {
 		.name	= PXA_CAM_DRV_NAME,
 		.pm	= &pxa_camera_pm,
+		.of_match_table = of_match_ptr(pxa_camera_of_match),
 	},
 	.probe		= pxa_camera_probe,
 	.remove		= pxa_camera_remove,
-- 
2.0.0.rc2

