Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:50519 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932580AbaGWRR2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jul 2014 13:17:28 -0400
Date: Wed, 23 Jul 2014 19:17:24 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
cc: devicetree@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
	linux-media@vger.kernel.org
Subject: [PATCH v4 1/2] media: soc_camera: pxa_camera device-tree support
In-Reply-To: <Pine.LNX.4.64.1407231126210.30243@axis700.grange>
Message-ID: <Pine.LNX.4.64.1407231915310.1526@axis700.grange>
References: <1404051600-20838-1-git-send-email-robert.jarzmik@free.fr>
 <Pine.LNX.4.64.1407231126210.30243@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add device-tree support to pxa_camera host driver.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
[g.liakhovetski@gmx.de: added of_node_put()]
Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

Robert, could you review and test this version, please?

Thanks
Guennadi

 drivers/media/platform/soc_camera/pxa_camera.c | 81 +++++++++++++++++++++++++-
 1 file changed, 79 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
index d4df305..64dc80c 100644
--- a/drivers/media/platform/soc_camera/pxa_camera.c
+++ b/drivers/media/platform/soc_camera/pxa_camera.c
@@ -34,6 +34,7 @@
 #include <media/videobuf-dma-sg.h>
 #include <media/soc_camera.h>
 #include <media/soc_mediabus.h>
+#include <media/v4l2-of.h>
 
 #include <linux/videodev2.h>
 
@@ -1650,6 +1651,68 @@ static struct soc_camera_host_ops pxa_soc_camera_host_ops = {
 	.set_bus_param	= pxa_camera_set_bus_param,
 };
 
+static int pxa_camera_pdata_from_dt(struct device *dev,
+				    struct pxa_camera_dev *pcdev)
+{
+	u32 mclk_rate;
+	struct device_node *np = dev->of_node;
+	struct v4l2_of_endpoint ep;
+	int err = of_property_read_u32(np, "clock-frequency",
+				       &mclk_rate);
+	if (!err) {
+		pcdev->platform_flags |= PXA_CAMERA_MCLK_EN;
+		pcdev->mclk = mclk_rate;
+	}
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
+		goto out;
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
+out:
+	of_node_put(np);
+
+	return err;
+}
+
 static int pxa_camera_probe(struct platform_device *pdev)
 {
 	struct pxa_camera_dev *pcdev;
@@ -1676,7 +1739,15 @@ static int pxa_camera_probe(struct platform_device *pdev)
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
@@ -1693,7 +1764,6 @@ static int pxa_camera_probe(struct platform_device *pdev)
 		pcdev->width_flags |= 1 << 8;
 	if (pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_10)
 		pcdev->width_flags |= 1 << 9;
-	pcdev->mclk = pcdev->pdata->mclk_10khz * 10000;
 	if (!pcdev->mclk) {
 		dev_warn(&pdev->dev,
 			 "mclk == 0! Please, fix your platform data. "
@@ -1799,10 +1869,17 @@ static const struct dev_pm_ops pxa_camera_pm = {
 	.resume		= pxa_camera_resume,
 };
 
+static const struct of_device_id pxa_camera_of_match[] = {
+	{ .compatible = "marvell,pxa270-qci", },
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
1.9.3

