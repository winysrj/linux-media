Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:59755 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934380AbZKXXgo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Nov 2009 18:36:44 -0500
From: m-karicheri2@ti.com
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	khilman@deeprootsystems.com
Cc: davinci-linux-open-source@linux.davincidsp.com,
	Muralidharan Karicheri <m-karicheri2@ti.com>
Subject: [PATCH - v0 1/2] V4L - vpfe capture  - make clocks configurable
Date: Tue, 24 Nov 2009 18:36:48 -0500
Message-Id: <1259105809-22041-1-git-send-email-m-karicheri2@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Muralidharan Karicheri <m-karicheri2@ti.com>

On DM365 we use only vpss master clock, where as on DM355 and
DM6446, we use vpss master and slave clocks for vpfe capture. So this
patch makes it configurable on a per platform basis. This is
needed for supporting DM365 for which patches will be available
soon.

This is for review only. For merge to upstream, it will be
re-crated against the v4l-dbv tree.

Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
---
 drivers/media/video/davinci/vpfe_capture.c |   98 +++++++++++++++++----------
 include/media/davinci/vpfe_capture.h       |   11 ++-
 2 files changed, 70 insertions(+), 39 deletions(-)

diff --git a/drivers/media/video/davinci/vpfe_capture.c b/drivers/media/video/davinci/vpfe_capture.c
index cad60e3..1ba9d07 100644
--- a/drivers/media/video/davinci/vpfe_capture.c
+++ b/drivers/media/video/davinci/vpfe_capture.c
@@ -1743,61 +1743,87 @@ static struct vpfe_device *vpfe_initialize(void)
 	return vpfe_dev;
 }
 
+/**
+ * vpfe_disable_clock() - Disable clocks for vpfe capture driver
+ * @vpfe_dev - ptr to vpfe capture device
+ *
+ * Disables clocks defined in vpfe configuration.
+ */
 static void vpfe_disable_clock(struct vpfe_device *vpfe_dev)
 {
 	struct vpfe_config *vpfe_cfg = vpfe_dev->cfg;
+	int i;
 
-	clk_disable(vpfe_cfg->vpssclk);
-	clk_put(vpfe_cfg->vpssclk);
-	clk_disable(vpfe_cfg->slaveclk);
-	clk_put(vpfe_cfg->slaveclk);
-	v4l2_info(vpfe_dev->pdev->driver,
-		 "vpfe vpss master & slave clocks disabled\n");
+	for (i = 0; i < vpfe_cfg->num_clocks; i++) {
+		clk_disable(vpfe_dev->clks[i]);
+		clk_put(vpfe_dev->clks[i]);
+	}
+	kfree(vpfe_dev->clks);
+	v4l2_info(vpfe_dev->pdev->driver, "vpfe capture clocks disabled\n");
 }
 
+/**
+ * vpfe_enable_clock() - Enable clocks for vpfe capture driver
+ * @vpfe_dev - ptr to vpfe capture device
+ *
+ * Enables clocks defined in vpfe configuration. The function
+ * assumes that at least one clock is to be defined which is
+ * true as of now. re-visit this if this assumption is not true
+ */
 static int vpfe_enable_clock(struct vpfe_device *vpfe_dev)
 {
 	struct vpfe_config *vpfe_cfg = vpfe_dev->cfg;
-	int ret = -ENOENT;
+	int ret = -EFAULT, i;
 
-	vpfe_cfg->vpssclk = clk_get(vpfe_dev->pdev, "vpss_master");
-	if (NULL == vpfe_cfg->vpssclk) {
-		v4l2_err(vpfe_dev->pdev->driver, "No clock defined for"
-			 "vpss_master\n");
-		return ret;
-	}
+	if (!vpfe_cfg->num_clocks)
+		return 0;
 
-	if (clk_enable(vpfe_cfg->vpssclk)) {
-		v4l2_err(vpfe_dev->pdev->driver,
-			"vpfe vpss master clock not enabled\n");
-		goto out;
-	}
-	v4l2_info(vpfe_dev->pdev->driver,
-		 "vpfe vpss master clock enabled\n");
+	vpfe_dev->clks = kzalloc(vpfe_cfg->num_clocks *
+				   sizeof(struct clock *), GFP_KERNEL);
 
-	vpfe_cfg->slaveclk = clk_get(vpfe_dev->pdev, "vpss_slave");
-	if (NULL == vpfe_cfg->slaveclk) {
-		v4l2_err(vpfe_dev->pdev->driver,
-			"No clock defined for vpss slave\n");
-		goto out;
+	if (NULL == vpfe_dev->clks) {
+		v4l2_err(vpfe_dev->pdev->driver, "Memory allocation failed\n");
+		return -ENOMEM;
 	}
 
-	if (clk_enable(vpfe_cfg->slaveclk)) {
-		v4l2_err(vpfe_dev->pdev->driver,
-			 "vpfe vpss slave clock not enabled\n");
-		goto out;
+	for (i = 0; i < vpfe_cfg->num_clocks; i++) {
+		if (NULL == vpfe_cfg->clocks[i]) {
+			v4l2_err(vpfe_dev->pdev->driver,
+				"clock %s is not defined in vpfe config\n",
+				vpfe_cfg->clocks[i]);
+			goto out;
+		}
+
+		vpfe_dev->clks[i] = clk_get(vpfe_dev->pdev,
+					      vpfe_cfg->clocks[i]);
+		if (NULL == vpfe_dev->clks[i]) {
+			v4l2_err(vpfe_dev->pdev->driver,
+				"Failed to get clock %s\n",
+				vpfe_cfg->clocks[i]);
+			goto out;
+		}
+
+		if (clk_enable(vpfe_dev->clks[i])) {
+			v4l2_err(vpfe_dev->pdev->driver,
+				"vpfe clock %s not enabled\n",
+				vpfe_cfg->clocks[i]);
+			goto out;
+		}
+
+		v4l2_info(vpfe_dev->pdev->driver, "vpss clock %s enabled",
+			  vpfe_cfg->clocks[i]);
 	}
-	v4l2_info(vpfe_dev->pdev->driver, "vpfe vpss slave clock enabled\n");
 	return 0;
 out:
-	if (vpfe_cfg->vpssclk)
-		clk_put(vpfe_cfg->vpssclk);
-	if (vpfe_cfg->slaveclk)
-		clk_put(vpfe_cfg->slaveclk);
-
-	return -1;
+	for (i = 0; i < vpfe_cfg->num_clocks; i++) {
+		if (vpfe_dev->clks[i])
+			clk_put(vpfe_dev->clks[i]);
+	}
+	kfree(vpfe_dev->clks);
+	return ret;
 }
 
+
 /*
  * vpfe_probe : This function creates device entries by register
  * itself to the V4L2 driver and initializes fields of each
diff --git a/include/media/davinci/vpfe_capture.h b/include/media/davinci/vpfe_capture.h
index 71d8982..d669e85 100644
--- a/include/media/davinci/vpfe_capture.h
+++ b/include/media/davinci/vpfe_capture.h
@@ -31,8 +31,6 @@
 #include <media/videobuf-dma-contig.h>
 #include <media/davinci/vpfe_types.h>
 
-#define VPFE_CAPTURE_NUM_DECODERS        5
-
 /* Macros */
 #define VPFE_MAJOR_RELEASE              0
 #define VPFE_MINOR_RELEASE              0
@@ -89,9 +87,14 @@ struct vpfe_config {
 	char *card_name;
 	/* ccdc name */
 	char *ccdc;
-	/* vpfe clock */
+	/* vpfe clock. Obsolete! Will be removed in next patch */
 	struct clk *vpssclk;
+	/* Obsolete! Will be removed in next patch */
 	struct clk *slaveclk;
+	/* number of clocks */
+	int num_clocks;
+	/* clocks used for vpfe capture */
+	char *clocks[];
 };
 
 struct vpfe_device {
@@ -102,6 +105,8 @@ struct vpfe_device {
 	struct v4l2_subdev **sd;
 	/* vpfe cfg */
 	struct vpfe_config *cfg;
+	/* clock ptrs for vpfe capture */
+	struct clk **clks;
 	/* V4l2 device */
 	struct v4l2_device v4l2_dev;
 	/* parent device */
-- 
1.6.0.4

