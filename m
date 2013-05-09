Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:47222 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab3EIMku (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 May 2013 08:40:50 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MMJ00AL577PZPE0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 09 May 2013 21:40:48 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: a.hajda@samsung.com, hj210.choi@samsung.com,
	sw0312.kim@samsung.com, devicetree-discuss@lists.ozlabs.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] s5p-jpeg: Enable instantiation from device tree
Date: Thu, 09 May 2013 14:39:58 +0200
Message-id: <1368103198-16485-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds device tree support for the S5P/Exynos SoC
JPEG codec IP block.

Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 .../devicetree/bindings/media/samsung-s5p-jpeg.txt |   12 ++++++++++++
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |   13 ++++++++++++-
 2 files changed, 24 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/media/samsung-s5p-jpeg.txt

diff --git a/Documentation/devicetree/bindings/media/samsung-s5p-jpeg.txt b/Documentation/devicetree/bindings/media/samsung-s5p-jpeg.txt
new file mode 100644
index 0000000..bc0938a
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/samsung-s5p-jpeg.txt
@@ -0,0 +1,12 @@
+Samsung S5P/EXYNOS SoC series JPEG codec
+
+Required properties:
+
+- compatible	: "samsung,<soc_name>-jpeg", must be one of:
+		  "samsung,s5pv210-jpeg", "samsung,exynos4210-jpeg",
+		  "samsung,exynos4212-jpeg";
+- reg		: address and length of the JPEG codec register set;
+- interrupts	: should contain the JPEG codec interrupt; format of the
+		  interrupt specifier depends on the interrupt controller;
+- clocks	: jpeg clock specifier, as covered by common clock bindings.
+- clock-names	: must contain "jpeg" entry.
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 15d2396..cd4461c 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -17,6 +17,7 @@
 #include <linux/io.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/slab.h>
@@ -1513,10 +1514,21 @@ static const struct dev_pm_ops s5p_jpeg_pm_ops = {
 	.runtime_resume	 = s5p_jpeg_runtime_resume,
 };
 
+#ifdef CONFIG_OF
+static const struct of_device_id s5p_jpeg_of_match[] = {
+	{ .compatible = "samsung,s5pv210-jpeg" },
+	{ .compatible = "samsung,exynos4210-jpeg" },
+	{ .compatible = "samsung,exynos4212-jpeg" },
+	{ /* sentinel */ },
+};
+MODULE_DEVICE_TABLE(of, s5p_jpeg_of_match);
+#endif
+
 static struct platform_driver s5p_jpeg_driver = {
 	.probe = s5p_jpeg_probe,
 	.remove = s5p_jpeg_remove,
 	.driver = {
+		.of_match_table = of_match_ptr(s5p_jpeg_of_match),
 		.owner = THIS_MODULE,
 		.name = S5P_JPEG_M2M_NAME,
 		.pm = &s5p_jpeg_pm_ops,
@@ -1528,4 +1540,3 @@ module_platform_driver(s5p_jpeg_driver);
 MODULE_AUTHOR("Andrzej Pietrasiewicz <andrzej.p@samsung.com>");
 MODULE_DESCRIPTION("Samsung JPEG codec driver");
 MODULE_LICENSE("GPL");
-
-- 
1.7.9.5

