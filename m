Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:25205 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbaFUWW0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Jun 2014 18:22:26 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: g.liakhovetski@gmx.de, devicetree@vger.kernel.org
Cc: linux-media@vger.kernel.org,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH v2 2/2] media: soc_camera: pxa_camera device-tree support
Date: Sun, 22 Jun 2014 00:21:47 +0200
Message-Id: <1403389307-17489-2-git-send-email-robert.jarzmik@free.fr>
In-Reply-To: <1403389307-17489-1-git-send-email-robert.jarzmik@free.fr>
References: <1403389307-17489-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add device-tree support to pxa_camera host driver.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/media/platform/soc_camera/pxa_camera.c | 77 +++++++++++++++++++++++++-
 1 file changed, 75 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
index d4df305..8c9de9e 100644
--- a/drivers/media/platform/soc_camera/pxa_camera.c
+++ b/drivers/media/platform/soc_camera/pxa_camera.c
@@ -34,6 +34,7 @@
 #include <media/videobuf-dma-sg.h>
 #include <media/soc_camera.h>
 #include <media/soc_mediabus.h>
+#include <media/v4l2-of.h>
 
 #include <linux/videodev2.h>
 
@@ -1650,6 +1651,64 @@ static struct soc_camera_host_ops pxa_soc_camera_host_ops = {
 	.set_bus_param	= pxa_camera_set_bus_param,
 };
 
+static int pxa_camera_pdata_from_dt(struct device *dev,
+				    struct pxa_camera_dev *pcdev)
+{
+	int err = 0;
+	struct device_node *np = dev->of_node;
+	struct v4l2_of_endpoint ep;
+
+	err = of_property_read_u32(np, "clock-frequency",
+				   (u32 *)&pcdev->mclk);
+	if (!err)
+		pcdev->platform_flags |= PXA_CAMERA_MCLK_EN;
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
+		pcdev->platform_flags |= PXA_CAMERA_DATAWIDTH_4;
+		break;
+	case 5:
+		pcdev->platform_flags |= PXA_CAMERA_DATAWIDTH_5;
+		break;
+	case 8:
+		pcdev->platform_flags |= PXA_CAMERA_DATAWIDTH_8;
+		break;
+	case 9:
+		pcdev->platform_flags |= PXA_CAMERA_DATAWIDTH_9;
+		break;
+	case 10:
+		pcdev->platform_flags |= PXA_CAMERA_DATAWIDTH_10;
+		break;
+	default:
+		break;
+	};
+
+	if (ep.bus.parallel.flags & V4L2_MBUS_MASTER)
+		pcdev->platform_flags |= PXA_CAMERA_MASTER;
+	if (ep.bus.parallel.flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH)
+		pcdev->platform_flags |= PXA_CAMERA_HSP;
+	if (ep.bus.parallel.flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH)
+		pcdev->platform_flags |= PXA_CAMERA_VSP;
+	if (ep.bus.parallel.flags & V4L2_MBUS_PCLK_SAMPLE_RISING)
+		pcdev->platform_flags |= PXA_CAMERA_PCLK_EN | PXA_CAMERA_PCP;
+	if (ep.bus.parallel.flags & V4L2_MBUS_PCLK_SAMPLE_FALLING)
+		pcdev->platform_flags |= PXA_CAMERA_PCLK_EN;
+
+	return 0;
+}
+
 static int pxa_camera_probe(struct platform_device *pdev)
 {
 	struct pxa_camera_dev *pcdev;
@@ -1676,7 +1735,15 @@ static int pxa_camera_probe(struct platform_device *pdev)
 	pcdev->res = res;
 
 	pcdev->pdata = pdev->dev.platform_data;
-	pcdev->platform_flags = pcdev->pdata->flags;
+	if (&pdev->dev.of_node && !pcdev->pdata) {
+		err = pxa_camera_pdata_from_dt(&pdev->dev, pcdev);
+	} else {
+		pcdev->platform_flags = pcdev->pdata->flags;
+		pcdev->mclk = pcdev->pdata->mclk_10khz * 10000;
+	}
+	if (err < 0)
+		return err;
+
 	if (!(pcdev->platform_flags & (PXA_CAMERA_DATAWIDTH_8 |
 			PXA_CAMERA_DATAWIDTH_9 | PXA_CAMERA_DATAWIDTH_10))) {
 		/*
@@ -1693,7 +1760,6 @@ static int pxa_camera_probe(struct platform_device *pdev)
 		pcdev->width_flags |= 1 << 8;
 	if (pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_10)
 		pcdev->width_flags |= 1 << 9;
-	pcdev->mclk = pcdev->pdata->mclk_10khz * 10000;
 	if (!pcdev->mclk) {
 		dev_warn(&pdev->dev,
 			 "mclk == 0! Please, fix your platform data. "
@@ -1799,10 +1865,17 @@ static const struct dev_pm_ops pxa_camera_pm = {
 	.resume		= pxa_camera_resume,
 };
 
+static const struct of_device_id pxa_camera_of_match[] = {
+	{ .compatible = "marvell,pxa27x-qci", },
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

