Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:46844 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756560Ab2EYTxO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 May 2012 15:53:14 -0400
Date: Fri, 25 May 2012 21:52:53 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 14/14] s5p-fimc: Add FIMC and MIPI-CSIS devices to CAM power
 domain
In-reply-to: <1337975573-27117-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	s.nawrocki@samsung.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org, b.zolnierkie@samsung.com
Message-id: <1337975573-27117-14-git-send-email-s.nawrocki@samsung.com>
Content-transfer-encoding: 7BIT
References: <4FBFE1EC.9060209@samsung.com>
 <1337975573-27117-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-core.c |   15 +++++++++++++++
 drivers/media/video/s5p-fimc/mipi-csis.c |   15 +++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index 30c6365..15c7cc6 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -19,6 +19,7 @@
 #include <linux/device.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
+#include <linux/pm_domain.h>
 #include <linux/list.h>
 #include <linux/io.h>
 #include <linux/of.h>
@@ -1057,6 +1058,17 @@ static int fimc_m2m_resume(struct fimc_dev *fimc)
 	return 0;
 }
 
+static void bus_add_dev_to_pd(struct device *dev)
+{
+	struct device_node *np;
+
+	np = of_parse_phandle(dev->of_node, "pd", 0);
+	if (np)
+		pm_genpd_of_add_device(np, dev);
+
+	of_node_put(np);
+}
+
 static int fimc_probe(struct platform_device *pdev)
 {
 	struct fimc_drvdata *drv_data = NULL;
@@ -1072,6 +1084,9 @@ static int fimc_probe(struct platform_device *pdev)
 
 	if (pdev->dev.of_node) {
 		u32 id = 0;
+
+		bus_add_dev_to_pd(&pdev->dev);
+
 		of_id = of_match_node(fimc_of_match, pdev->dev.of_node);
 		if (of_id)
 			drv_data = of_id->data;
diff --git a/drivers/media/video/s5p-fimc/mipi-csis.c b/drivers/media/video/s5p-fimc/mipi-csis.c
index ffb820e..6858c92 100644
--- a/drivers/media/video/s5p-fimc/mipi-csis.c
+++ b/drivers/media/video/s5p-fimc/mipi-csis.c
@@ -22,6 +22,7 @@
 #include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
+#include <linux/pm_domain.h>
 #include <linux/regulator/consumer.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
@@ -529,6 +530,17 @@ static int s5pcsis_get_platform_data(struct platform_device *pdev,
 	return 0;
 }
 
+static void bus_add_dev_to_pd(struct device *dev)
+{
+	struct device_node *np;
+
+	np = of_parse_phandle(dev->of_node, "pd", 0);
+	if (np)
+		pm_genpd_of_add_device(np, dev);
+
+	of_node_put(np);
+}
+
 static int __devinit s5pcsis_probe(struct platform_device *pdev)
 {
 	struct resource *mem_res;
@@ -543,6 +555,9 @@ static int __devinit s5pcsis_probe(struct platform_device *pdev)
 	mutex_init(&state->lock);
 	state->pdev = pdev;
 
+	if (pdev->dev.of_node)
+		bus_add_dev_to_pd(&pdev->dev);
+
 	ret = s5pcsis_get_platform_data(pdev, state);
 	if (ret < 0)
 		return ret;
-- 
1.7.10

