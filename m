Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:42342 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751388AbdFFMH6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Jun 2017 08:07:58 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, mchehab@s-opensource.com
Subject: [PATCH 1/1] v4l2: fwnode: Convert stm32-dcmi driver to V4L2 fwnode
Date: Tue,  6 Jun 2017 15:07:55 +0300
Message-Id: <1496750875-18094-1-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1491829376-14791-5-git-send-email-sakari.ailus@linux.intel.com>
References: <1491829376-14791-5-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The stm32-dcmi driver was still using V4L2 OF, convert it to V4L2 fwnode.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
I'll squash this to patch "v4l: Switch from V4L2 OF not V4L2 fwnode API"
in the pull request I'll send in a moment.

 drivers/media/platform/Kconfig            |  1 +
 drivers/media/platform/stm32/stm32-dcmi.c | 13 +++++++------
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 8d50ec8..a4b7cef 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -121,6 +121,7 @@ config VIDEO_STM32_DCMI
 	depends on VIDEO_V4L2 && OF && HAS_DMA
 	depends on ARCH_STM32 || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
+	select V4L2_FWNODE
 	---help---
 	  This module makes the STM32 Digital Camera Memory Interface (DCMI)
 	  available as a v4l2 device.
diff --git a/drivers/media/platform/stm32/stm32-dcmi.c b/drivers/media/platform/stm32/stm32-dcmi.c
index 348f025..83d32a5 100644
--- a/drivers/media/platform/stm32/stm32-dcmi.c
+++ b/drivers/media/platform/stm32/stm32-dcmi.c
@@ -21,6 +21,7 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
+#include <linux/of_graph.h>
 #include <linux/platform_device.h>
 #include <linux/reset.h>
 #include <linux/videodev2.h>
@@ -29,9 +30,9 @@
 #include <media/v4l2-dev.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-event.h>
+#include <media/v4l2-fwnode.h>
 #include <media/v4l2-image-sizes.h>
 #include <media/v4l2-ioctl.h>
-#include <media/v4l2-of.h>
 #include <media/videobuf2-dma-contig.h>
 
 #define DRV_NAME "stm32-dcmi"
@@ -139,7 +140,7 @@ struct stm32_dcmi {
 	struct mutex			lock;
 	struct vb2_queue		queue;
 
-	struct v4l2_of_bus_parallel	bus;
+	struct v4l2_fwnode_bus_parallel	bus;
 	struct completion		complete;
 	struct clk			*mclk;
 	enum state			state;
@@ -1143,8 +1144,8 @@ static int dcmi_graph_parse(struct stm32_dcmi *dcmi, struct device_node *node)
 
 		/* Remote node to connect */
 		dcmi->entity.node = remote;
-		dcmi->entity.asd.match_type = V4L2_ASYNC_MATCH_OF;
-		dcmi->entity.asd.match.of.node = remote;
+		dcmi->entity.asd.match_type = V4L2_ASYNC_MATCH_FWNODE;
+		dcmi->entity.asd.match.fwnode.fwnode = of_fwnode_handle(remote);
 		return 0;
 	}
 }
@@ -1190,7 +1191,7 @@ static int dcmi_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
 	const struct of_device_id *match = NULL;
-	struct v4l2_of_endpoint ep;
+	struct v4l2_fwnode_endpoint ep;
 	struct stm32_dcmi *dcmi;
 	struct vb2_queue *q;
 	struct dma_chan *chan;
@@ -1222,7 +1223,7 @@ static int dcmi_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	ret = v4l2_of_parse_endpoint(np, &ep);
+	ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(np), &ep);
 	if (ret) {
 		dev_err(&pdev->dev, "Could not parse the endpoint\n");
 		of_node_put(np);
-- 
2.1.4
