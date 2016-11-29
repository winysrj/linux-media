Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f41.google.com ([74.125.83.41]:34801 "EHLO
        mail-pg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754772AbcK2X5R (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Nov 2016 18:57:17 -0500
Received: by mail-pg0-f41.google.com with SMTP id x23so74806806pgx.1
        for <linux-media@vger.kernel.org>; Tue, 29 Nov 2016 15:57:17 -0800 (PST)
From: Kevin Hilman <khilman@baylibre.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        linux-arm-kernel@lists.infradead.org, Sekhar Nori <nsekhar@ti.com>,
        Rob Herring <robh@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH v4 2/4] [media] davinci: VPIF: add basic support for DT init
Date: Tue, 29 Nov 2016 15:57:10 -0800
Message-Id: <20161129235712.29846-3-khilman@baylibre.com>
In-Reply-To: <20161129235712.29846-1-khilman@baylibre.com>
References: <20161129235712.29846-1-khilman@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add basic support for initialization via DT.

Because existing capture and display devices are implemented as separate
platform_devices, and in order to preserve that legacy support, during
DT boot, manually create capture and display platform devices to
initialize capture and display support.

Signed-off-by: Kevin Hilman <khilman@baylibre.com>
---
 drivers/media/platform/davinci/vpif.c         | 48 ++++++++++++++++++++++++++-
 drivers/media/platform/davinci/vpif_capture.c |  6 ++++
 drivers/media/platform/davinci/vpif_display.c |  6 ++++
 3 files changed, 59 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/davinci/vpif.c b/drivers/media/platform/davinci/vpif.c
index 0380cf2e5775..528b30d52208 100644
--- a/drivers/media/platform/davinci/vpif.c
+++ b/drivers/media/platform/davinci/vpif.c
@@ -420,7 +420,8 @@ EXPORT_SYMBOL(vpif_channel_getfid);
 
 static int vpif_probe(struct platform_device *pdev)
 {
-	static struct resource	*res;
+	static struct resource	*res, *res_irq;
+	struct platform_device *pdev_capture, *pdev_display;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	vpif_base = devm_ioremap_resource(&pdev->dev, res);
@@ -432,6 +433,42 @@ static int vpif_probe(struct platform_device *pdev)
 
 	spin_lock_init(&vpif_lock);
 	dev_info(&pdev->dev, "vpif probe success\n");
+
+	if (!pdev->dev.of_node)
+		return 0;
+
+	/*
+	 * For DT platforms, manually create platform_devices for
+	 * capture/display drivers.
+	 */
+	res_irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (!res_irq) {
+		dev_warn(&pdev->dev, "Missing IRQ resource.\n");
+		return -EINVAL;
+	}
+
+	pdev_capture = devm_kzalloc(&pdev->dev, sizeof(*pdev_capture),
+				    GFP_KERNEL);
+	pdev_capture->name = "vpif_capture";
+	pdev_capture->id = -1;
+	pdev_capture->resource = res_irq;
+	pdev_capture->num_resources = 1;
+	pdev_capture->dev.dma_mask = pdev->dev.dma_mask;
+	pdev_capture->dev.coherent_dma_mask = pdev->dev.coherent_dma_mask;
+	pdev_capture->dev.parent = &pdev->dev;
+	platform_device_register(pdev_capture);
+
+	pdev_display = devm_kzalloc(&pdev->dev, sizeof(*pdev_display),
+				    GFP_KERNEL);
+	pdev_display->name = "vpif_display";
+	pdev_display->id = -1;
+	pdev_display->resource = res_irq;
+	pdev_display->num_resources = 1;
+	pdev_display->dev.dma_mask = pdev->dev.dma_mask;
+	pdev_display->dev.coherent_dma_mask = pdev->dev.coherent_dma_mask;
+	pdev_display->dev.parent = &pdev->dev;
+	platform_device_register(pdev_display);
+
 	return 0;
 }
 
@@ -464,8 +501,17 @@ static const struct dev_pm_ops vpif_pm = {
 #define vpif_pm_ops NULL
 #endif
 
+#if IS_ENABLED(CONFIG_OF)
+static const struct of_device_id vpif_of_match[] = {
+	{ .compatible = "ti,da850-vpif", },
+	{ /* sentinel */ },
+};
+MODULE_DEVICE_TABLE(of, vpif_of_match);
+#endif
+
 static struct platform_driver vpif_driver = {
 	.driver = {
+		.of_match_table = of_match_ptr(vpif_of_match),
 		.name	= "vpif",
 		.pm	= vpif_pm_ops,
 	},
diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index 9f8f41c0f251..a83df07e4051 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -45,6 +45,7 @@ module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "Debug level 0-1");
 
 #define VPIF_DRIVER_NAME	"vpif_capture"
+MODULE_ALIAS("platform:" VPIF_DRIVER_NAME);
 
 /* global variables */
 static struct vpif_device vpif_obj = { {NULL} };
@@ -1438,6 +1439,11 @@ static __init int vpif_probe(struct platform_device *pdev)
 	int res_idx = 0;
 	int i, err;
 
+	if (!pdev->dev.platform_data) {
+		dev_warn(&pdev->dev, "Missing platform data.  Giving up.\n");
+		return -EINVAL;
+	}
+
 	vpif_dev = &pdev->dev;
 
 	err = initialize_vpif();
diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index 75b27233ec2f..7f632b757d32 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -42,6 +42,7 @@ module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "Debug level 0-1");
 
 #define VPIF_DRIVER_NAME	"vpif_display"
+MODULE_ALIAS("platform:" VPIF_DRIVER_NAME);
 
 /* Is set to 1 in case of SDTV formats, 2 in case of HDTV formats. */
 static int ycmux_mode;
@@ -1249,6 +1250,11 @@ static __init int vpif_probe(struct platform_device *pdev)
 	int res_idx = 0;
 	int i, err;
 
+	if (!pdev->dev.platform_data) {
+		dev_warn(&pdev->dev, "Missing platform data.  Giving up.\n");
+		return -EINVAL;
+	}
+
 	vpif_dev = &pdev->dev;
 	err = initialize_vpif();
 
-- 
2.9.3

