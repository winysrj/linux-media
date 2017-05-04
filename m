Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:40409 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754197AbdEDNhh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 4 May 2017 09:37:37 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>, kernel@pengutronix.de,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] [media] imx: switch from V4L2 OF to V4L2 fwnode API
Date: Thu,  4 May 2017 15:37:30 +0200
Message-Id: <20170504133730.19934-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Switch from the v4l2_of_ APIs to the v4l2_fwnode_ APIs so this driver
can work if the patch "v4l: Switch from V4L2 OF not V4L2 fwnode API"
is applied before it. Tested against
https://git.linuxtv.org/sailus/media_tree.git/log/?h=v4l2-acpi-merge

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/staging/media/imx/imx-media-capture.c |  2 +-
 drivers/staging/media/imx/imx-media-csi.c     | 10 +++++-----
 drivers/staging/media/imx/imx-media-dev.c     | 19 ++++++++++---------
 drivers/staging/media/imx/imx-media-fim.c     |  1 -
 drivers/staging/media/imx/imx-media-of.c      |  6 ++++--
 drivers/staging/media/imx/imx-media.h         |  4 ++--
 drivers/staging/media/imx/imx6-mipi-csi2.c    |  9 +++++----
 7 files changed, 27 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-capture.c b/drivers/staging/media/imx/imx-media-capture.c
index 8b28dbc21566c..ddab4c249da25 100644
--- a/drivers/staging/media/imx/imx-media-capture.c
+++ b/drivers/staging/media/imx/imx-media-capture.c
@@ -21,8 +21,8 @@
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-event.h>
+#include <media/v4l2-fwnode.h>
 #include <media/v4l2-ioctl.h>
-#include <media/v4l2-of.h>
 #include <media/v4l2-mc.h>
 #include <media/v4l2-subdev.h>
 #include <media/videobuf2-dma-contig.h>
diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index 447c597111852..fdf90dc7d212e 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -17,8 +17,8 @@
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-event.h>
+#include <media/v4l2-fwnode.h>
 #include <media/v4l2-mc.h>
-#include <media/v4l2-of.h>
 #include <media/v4l2-subdev.h>
 #include <media/videobuf2-dma-contig.h>
 #include <video/imx-ipu-v3.h>
@@ -307,7 +307,7 @@ static void csi_idmac_unsetup_vb2_buf(struct csi_priv *priv,
 static int csi_idmac_setup_channel(struct csi_priv *priv)
 {
 	struct imx_media_video_dev *vdev = priv->vdev;
-	struct v4l2_of_endpoint *sensor_ep;
+	struct v4l2_fwnode_endpoint *sensor_ep;
 	struct v4l2_mbus_framefmt *infmt;
 	struct ipu_image image;
 	u32 passthrough_bits;
@@ -557,7 +557,7 @@ static int csi_setup(struct csi_priv *priv)
 {
 	struct v4l2_mbus_framefmt *infmt, *outfmt;
 	struct v4l2_mbus_config sensor_mbus_cfg;
-	struct v4l2_of_endpoint *sensor_ep;
+	struct v4l2_fwnode_endpoint *sensor_ep;
 	struct v4l2_mbus_framefmt if_fmt;
 	const struct csi_skip_desc *skip;
 
@@ -957,7 +957,7 @@ static int csi_link_validate(struct v4l2_subdev *sd,
 {
 	struct csi_priv *priv = v4l2_get_subdevdata(sd);
 	const struct imx_media_pixfmt *incc;
-	struct v4l2_of_endpoint *sensor_ep;
+	struct v4l2_fwnode_endpoint *sensor_ep;
 	struct imx_media_subdev *sensor;
 	bool is_csi2;
 	int ret;
@@ -1066,7 +1066,7 @@ static void csi_try_crop(struct csi_priv *priv,
 			 struct v4l2_mbus_framefmt *infmt,
 			 struct imx_media_subdev *sensor)
 {
-	struct v4l2_of_endpoint *sensor_ep;
+	struct v4l2_fwnode_endpoint *sensor_ep;
 
 	sensor_ep = &sensor->sensor_ep;
 
diff --git a/drivers/staging/media/imx/imx-media-dev.c b/drivers/staging/media/imx/imx-media-dev.c
index d149d2f222f10..488c4d24783d9 100644
--- a/drivers/staging/media/imx/imx-media-dev.c
+++ b/drivers/staging/media/imx/imx-media-dev.c
@@ -40,14 +40,15 @@ imx_media_find_async_subdev(struct imx_media_dev *imxmd,
 			    struct device_node *np,
 			    const char *devname)
 {
+	struct fwnode_handle *fwnode = np ? of_fwnode_handle(np) : NULL;
 	struct imx_media_subdev *imxsd;
 	int i;
 
 	for (i = 0; i < imxmd->subdev_notifier.num_subdevs; i++) {
 		imxsd = &imxmd->subdev[i];
 		switch (imxsd->asd.match_type) {
-		case V4L2_ASYNC_MATCH_OF:
-			if (np && imxsd->asd.match.of.node == np)
+		case V4L2_ASYNC_MATCH_FWNODE:
+			if (fwnode && imxsd->asd.match.fwnode.fwnode == fwnode)
 				return imxsd;
 			break;
 		case V4L2_ASYNC_MATCH_DEVNAME:
@@ -65,8 +66,8 @@ imx_media_find_async_subdev(struct imx_media_dev *imxmd,
 
 /*
  * Adds a subdev to the async subdev list. If np is non-NULL, adds
- * the async as a V4L2_ASYNC_MATCH_OF match type, otherwise as a
- * V4L2_ASYNC_MATCH_DEVNAME match type using the dev_name of the
+ * the async as a V4L2_ASYNC_MATCH_FWNODE match type, otherwise as
+ * a V4L2_ASYNC_MATCH_DEVNAME match type using the dev_name of the
  * given platform_device. This is called during driver load when
  * forming the async subdev list.
  */
@@ -101,8 +102,8 @@ imx_media_add_async_subdev(struct imx_media_dev *imxmd,
 
 	asd = &imxsd->asd;
 	if (np) {
-		asd->match_type = V4L2_ASYNC_MATCH_OF;
-		asd->match.of.node = np;
+		asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
+		asd->match.fwnode.fwnode = of_fwnode_handle(np);
 	} else {
 		asd->match_type = V4L2_ASYNC_MATCH_DEVNAME;
 		strncpy(imxsd->devname, devname, sizeof(imxsd->devname));
@@ -114,7 +115,7 @@ imx_media_add_async_subdev(struct imx_media_dev *imxmd,
 	imxmd->subdev_notifier.num_subdevs++;
 
 	dev_dbg(imxmd->md.dev, "%s: added %s, match type %s\n",
-		__func__, np ? np->name : devname, np ? "OF" : "DEVNAME");
+		__func__, np ? np->name : devname, np ? "FWNODE" : "DEVNAME");
 
 	return imxsd;
 }
@@ -194,11 +195,11 @@ static int imx_media_subdev_bound(struct v4l2_async_notifier *notifier,
 				  struct v4l2_async_subdev *asd)
 {
 	struct imx_media_dev *imxmd = notifier2dev(notifier);
+	struct device_node *np = to_of_node(dev_fwnode(sd->dev));
 	struct imx_media_subdev *imxsd;
 	int ret = -EINVAL;
 
-	imxsd = imx_media_find_async_subdev(imxmd, sd->of_node,
-					    dev_name(sd->dev));
+	imxsd = imx_media_find_async_subdev(imxmd, np, dev_name(sd->dev));
 	if (!imxsd)
 		goto out;
 
diff --git a/drivers/staging/media/imx/imx-media-fim.c b/drivers/staging/media/imx/imx-media-fim.c
index bd738ac9af8db..2cc7011cac036 100644
--- a/drivers/staging/media/imx/imx-media-fim.c
+++ b/drivers/staging/media/imx/imx-media-fim.c
@@ -13,7 +13,6 @@
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <media/v4l2-ctrls.h>
-#include <media/v4l2-of.h>
 #include <media/v4l2-subdev.h>
 #include <media/imx.h>
 #include "imx-media.h"
diff --git a/drivers/staging/media/imx/imx-media-of.c b/drivers/staging/media/imx/imx-media-of.c
index 1c7426fed979e..9e576ce8a0875 100644
--- a/drivers/staging/media/imx/imx-media-of.c
+++ b/drivers/staging/media/imx/imx-media-of.c
@@ -13,9 +13,10 @@
 #include <linux/of_platform.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
-#include <media/v4l2-of.h>
+#include <media/v4l2-fwnode.h>
 #include <media/v4l2-subdev.h>
 #include <media/videobuf2-dma-contig.h>
+#include <linux/of_graph.h>
 #include <video/imx-ipu-v3.h>
 #include "imx-media.h"
 
@@ -41,7 +42,8 @@ static void of_parse_sensor(struct imx_media_dev *imxmd,
 
 	endpoint = of_graph_get_next_endpoint(sensor_np, NULL);
 	if (endpoint) {
-		v4l2_of_parse_endpoint(endpoint, &sensor->sensor_ep);
+		v4l2_fwnode_endpoint_parse(of_fwnode_handle(endpoint),
+					   &sensor->sensor_ep);
 		of_node_put(endpoint);
 	}
 }
diff --git a/drivers/staging/media/imx/imx-media.h b/drivers/staging/media/imx/imx-media.h
index 76b3d364275b3..3d7e8bb90e239 100644
--- a/drivers/staging/media/imx/imx-media.h
+++ b/drivers/staging/media/imx/imx-media.h
@@ -13,7 +13,7 @@
 
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
-#include <media/v4l2-of.h>
+#include <media/v4l2-fwnode.h>
 #include <media/v4l2-subdev.h>
 #include <media/videobuf2-dma-contig.h>
 #include <video/imx-ipu-v3.h>
@@ -149,7 +149,7 @@ struct imx_media_subdev {
 	char devname[32];
 
 	/* if this is a sensor */
-	struct v4l2_of_endpoint sensor_ep;
+	struct v4l2_fwnode_endpoint sensor_ep;
 };
 
 struct imx_media_dev {
diff --git a/drivers/staging/media/imx/imx6-mipi-csi2.c b/drivers/staging/media/imx/imx6-mipi-csi2.c
index 4f778b7ef51c5..bb3150887ac08 100644
--- a/drivers/staging/media/imx/imx6-mipi-csi2.c
+++ b/drivers/staging/media/imx/imx6-mipi-csi2.c
@@ -14,9 +14,10 @@
 #include <linux/iopoll.h>
 #include <linux/irq.h>
 #include <linux/module.h>
+#include <linux/of_graph.h>
 #include <linux/platform_device.h>
 #include <media/v4l2-device.h>
-#include <media/v4l2-of.h>
+#include <media/v4l2-fwnode.h>
 #include <media/v4l2-subdev.h>
 #include "imx-media.h"
 
@@ -43,7 +44,7 @@ struct csi2_dev {
 	struct clk             *pllref_clk;
 	struct clk             *pix_clk; /* what is this? */
 	void __iomem           *base;
-	struct v4l2_of_bus_mipi_csi2 bus;
+	struct v4l2_fwnode_bus_mipi_csi2 bus;
 
 	/* lock to protect all members below */
 	struct mutex lock;
@@ -560,7 +561,7 @@ static int csi2_parse_endpoints(struct csi2_dev *csi2)
 {
 	struct device_node *node = csi2->dev->of_node;
 	struct device_node *epnode;
-	struct v4l2_of_endpoint ep;
+	struct v4l2_fwnode_endpoint ep;
 
 	epnode = of_graph_get_endpoint_by_regs(node, 0, -1);
 	if (!epnode) {
@@ -568,7 +569,7 @@ static int csi2_parse_endpoints(struct csi2_dev *csi2)
 		return -EINVAL;
 	}
 
-	v4l2_of_parse_endpoint(epnode, &ep);
+	v4l2_fwnode_endpoint_parse(of_fwnode_handle(epnode), &ep);
 	of_node_put(epnode);
 
 	if (ep.bus_type != V4L2_MBUS_CSI2) {
-- 
2.11.0
