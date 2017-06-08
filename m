Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:64133 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751512AbdFHPHC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Jun 2017 11:07:02 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org, mchehab@s-opensource.com
Subject: [PATCH 1/1] davinci: Switch from V4L2 OF to V4L2 fwnode
Date: Thu,  8 Jun 2017 18:04:07 +0300
Message-Id: <1496934247-17467-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The DaVinci VPIF capture driver V4L2 OF support was added after the V4L2
OF framework got removed. Switch VPIF capture driver to V4L2 fwnode.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/platform/davinci/Kconfig        |  1 +
 drivers/media/platform/davinci/vpif_capture.c | 21 ++++++++++++---------
 2 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/davinci/Kconfig b/drivers/media/platform/davinci/Kconfig
index 554e710..55982e6 100644
--- a/drivers/media/platform/davinci/Kconfig
+++ b/drivers/media/platform/davinci/Kconfig
@@ -22,6 +22,7 @@ config VIDEO_DAVINCI_VPIF_CAPTURE
 	depends on HAS_DMA
 	depends on I2C
 	select VIDEOBUF2_DMA_CONTIG
+	select V4L2_FWNODE
 	help
 	  Enables Davinci VPIF module used for capture devices.
 	  This module is used for capture on TI DM6467/DA850/OMAPL138
diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index 2735795..d78580f 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -18,11 +18,12 @@
 
 #include <linux/module.h>
 #include <linux/interrupt.h>
+#include <linux/of_graph.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 
+#include <media/v4l2-fwnode.h>
 #include <media/v4l2-ioctl.h>
-#include <media/v4l2-of.h>
 #include <media/i2c/tvp514x.h>
 #include <media/v4l2-mediabus.h>
 
@@ -1389,15 +1390,16 @@ static int vpif_async_bound(struct v4l2_async_notifier *notifier,
 
 	for (i = 0; i < vpif_obj.config->asd_sizes[0]; i++) {
 		struct v4l2_async_subdev *_asd = vpif_obj.config->asd[i];
-		const struct device_node *node = _asd->match.of.node;
+		const struct fwnode_handle *fwnode = _asd->match.fwnode.fwnode;
 
-		if (node == subdev->of_node) {
+		if (fwnode == subdev->fwnode) {
 			vpif_obj.sd[i] = subdev;
 			vpif_obj.config->chan_config->inputs[i].subdev_name =
-				(char *)subdev->of_node->full_name;
+				(char *)to_of_node(subdev->fwnode)->full_name;
 			vpif_dbg(2, debug,
 				 "%s: setting input %d subdev_name = %s\n",
-				 __func__, i, subdev->of_node->full_name);
+				 __func__, i,
+				 to_of_node(subdev->fwnode)->full_name);
 			return 0;
 		}
 	}
@@ -1502,7 +1504,7 @@ static struct vpif_capture_config *
 vpif_capture_get_pdata(struct platform_device *pdev)
 {
 	struct device_node *endpoint = NULL;
-	struct v4l2_of_endpoint bus_cfg;
+	struct v4l2_fwnode_endpoint bus_cfg;
 	struct vpif_capture_config *pdata;
 	struct vpif_subdev_info *sdinfo;
 	struct vpif_capture_chan_config *chan;
@@ -1549,7 +1551,8 @@ vpif_capture_get_pdata(struct platform_device *pdev)
 		chan->inputs[i].input.std = V4L2_STD_ALL;
 		chan->inputs[i].input.capabilities = V4L2_IN_CAP_STD;
 
-		err = v4l2_of_parse_endpoint(endpoint, &bus_cfg);
+		err = v4l2_fwnode_endpoint_parse(of_fwnode_handle(endpoint),
+						 &bus_cfg);
 		if (err) {
 			dev_err(&pdev->dev, "Could not parse the endpoint\n");
 			goto done;
@@ -1584,8 +1587,8 @@ vpif_capture_get_pdata(struct platform_device *pdev)
 			goto done;
 		}
 
-		pdata->asd[i]->match_type = V4L2_ASYNC_MATCH_OF;
-		pdata->asd[i]->match.of.node = rem;
+		pdata->asd[i]->match_type = V4L2_ASYNC_MATCH_FWNODE;
+		pdata->asd[i]->match.fwnode.fwnode = of_fwnode_handle(rem);
 		of_node_put(rem);
 	}
 
-- 
2.7.4
