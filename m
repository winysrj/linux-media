Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58050 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbaDHQpD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Apr 2014 12:45:03 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v4 4.2/6] v4l: vsp1: Add DT support
Date: Tue,  8 Apr 2014 18:47:10 +0200
Message-Id: <1396975630-6657-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <4542787.8JEGs6DclK@avalon>
References: <4542787.8JEGs6DclK@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement support for the VSP1 DT bindings in the VSP1 driver. The
driver now first retrieves platform data either from the platform data
pointer or by reading the device tree node, and then validates it
regardless of the platform data source.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/platform/vsp1/vsp1_drv.c | 52 ++++++++++++++++++++++++++++------
 1 file changed, 44 insertions(+), 8 deletions(-)

Changes since v3:

- Split DT bindings documentation and support in the driver to seperate patches
- Add a more verbose commit message

Changes since v2:

- Drop of_match_ptr() as the table is always compiled in

diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index 28e1de3..c69ee06 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -16,6 +16,7 @@
 #include <linux/device.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
+#include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/videodev2.h>
 
@@ -431,34 +432,59 @@ static const struct dev_pm_ops vsp1_pm_ops = {
  * Platform Driver
  */
 
-static struct vsp1_platform_data *
-vsp1_get_platform_data(struct platform_device *pdev)
+static int vsp1_validate_platform_data(struct platform_device *pdev,
+				       struct vsp1_platform_data *pdata)
 {
-	struct vsp1_platform_data *pdata = pdev->dev.platform_data;
-
 	if (pdata == NULL) {
 		dev_err(&pdev->dev, "missing platform data\n");
-		return NULL;
+		return -EINVAL;
 	}
 
 	if (pdata->rpf_count <= 0 || pdata->rpf_count > VPS1_MAX_RPF) {
 		dev_err(&pdev->dev, "invalid number of RPF (%u)\n",
 			pdata->rpf_count);
-		return NULL;
+		return -EINVAL;
 	}
 
 	if (pdata->uds_count <= 0 || pdata->uds_count > VPS1_MAX_UDS) {
 		dev_err(&pdev->dev, "invalid number of UDS (%u)\n",
 			pdata->uds_count);
-		return NULL;
+		return -EINVAL;
 	}
 
 	if (pdata->wpf_count <= 0 || pdata->wpf_count > VPS1_MAX_WPF) {
 		dev_err(&pdev->dev, "invalid number of WPF (%u)\n",
 			pdata->wpf_count);
-		return NULL;
+		return -EINVAL;
 	}
 
+	return 0;
+}
+
+static struct vsp1_platform_data *
+vsp1_get_platform_data(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct vsp1_platform_data *pdata;
+
+	if (!IS_ENABLED(CONFIG_OF) || np == NULL)
+		return pdev->dev.platform_data;
+
+	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
+	if (pdata == NULL)
+		return NULL;
+
+	if (of_property_read_bool(np, "renesas,has-lif"))
+		pdata->features |= VSP1_HAS_LIF;
+	if (of_property_read_bool(np, "renesas,has-lut"))
+		pdata->features |= VSP1_HAS_LUT;
+	if (of_property_read_bool(np, "renesas,has-sru"))
+		pdata->features |= VSP1_HAS_SRU;
+
+	of_property_read_u32(np, "renesas,#rpf", &pdata->rpf_count);
+	of_property_read_u32(np, "renesas,#uds", &pdata->uds_count);
+	of_property_read_u32(np, "renesas,#wpf", &pdata->wpf_count);
+
 	return pdata;
 }
 
@@ -481,6 +507,10 @@ static int vsp1_probe(struct platform_device *pdev)
 	if (vsp1->pdata == NULL)
 		return -ENODEV;
 
+	ret = vsp1_validate_platform_data(pdev, vsp1->pdata);
+	if (ret < 0)
+		return ret;
+
 	/* I/O, IRQ and clock resources */
 	io = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	vsp1->mmio = devm_ioremap_resource(&pdev->dev, io);
@@ -527,6 +557,11 @@ static int vsp1_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static const struct of_device_id vsp1_of_match[] = {
+	{ .compatible = "renesas,vsp1" },
+	{ },
+};
+
 static struct platform_driver vsp1_platform_driver = {
 	.probe		= vsp1_probe,
 	.remove		= vsp1_remove,
@@ -534,6 +569,7 @@ static struct platform_driver vsp1_platform_driver = {
 		.owner	= THIS_MODULE,
 		.name	= "vsp1",
 		.pm	= &vsp1_pm_ops,
+		.of_match_table = vsp1_of_match,
 	},
 };
 
-- 
1.8.3.2

