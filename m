Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:40325 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932798AbeGIWjy (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Jul 2018 18:39:54 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v6 09/17] media: imx: mipi csi-2: Register a subdev notifier
Date: Mon,  9 Jul 2018 15:39:09 -0700
Message-Id: <1531175957-1973-10-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1531175957-1973-1-git-send-email-steve_longerbeam@mentor.com>
References: <1531175957-1973-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Parse neighbor remote devices on the MIPI CSI-2 input port, add
them to a subdev notifier, and register the subdev notifier for the
MIPI CSI-2 receiver, by calling v4l2_async_register_fwnode_subdev().

csi2_parse_endpoints() is modified to be the parse_endpoint callback.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/staging/media/imx/imx6-mipi-csi2.c | 31 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/media/imx/imx6-mipi-csi2.c b/drivers/staging/media/imx/imx6-mipi-csi2.c
index ceeeb30..94eb9a1 100644
--- a/drivers/staging/media/imx/imx6-mipi-csi2.c
+++ b/drivers/staging/media/imx/imx6-mipi-csi2.c
@@ -551,35 +551,34 @@ static const struct v4l2_subdev_internal_ops csi2_internal_ops = {
 	.registered = csi2_registered,
 };
 
-static int csi2_parse_endpoints(struct csi2_dev *csi2)
+static int csi2_parse_endpoint(struct device *dev,
+			       struct v4l2_fwnode_endpoint *vep,
+			       struct v4l2_async_subdev *asd)
 {
-	struct device_node *node = csi2->dev->of_node;
-	struct device_node *epnode;
-	struct v4l2_fwnode_endpoint ep;
+	struct v4l2_subdev *sd = dev_get_drvdata(dev);
+	struct csi2_dev *csi2 = sd_to_dev(sd);
 
-	epnode = of_graph_get_endpoint_by_regs(node, 0, -1);
-	if (!epnode) {
-		v4l2_err(&csi2->sd, "failed to get sink endpoint node\n");
+	if (!fwnode_device_is_available(asd->match.fwnode)) {
+		v4l2_err(&csi2->sd, "remote is not available\n");
 		return -EINVAL;
 	}
 
-	v4l2_fwnode_endpoint_parse(of_fwnode_handle(epnode), &ep);
-	of_node_put(epnode);
-
-	if (ep.bus_type != V4L2_MBUS_CSI2) {
+	if (vep->bus_type != V4L2_MBUS_CSI2) {
 		v4l2_err(&csi2->sd, "invalid bus type, must be MIPI CSI2\n");
 		return -EINVAL;
 	}
 
-	csi2->bus = ep.bus.mipi_csi2;
+	csi2->bus = vep->bus.mipi_csi2;
 
 	dev_dbg(csi2->dev, "data lanes: %d\n", csi2->bus.num_data_lanes);
 	dev_dbg(csi2->dev, "flags: 0x%08x\n", csi2->bus.flags);
+
 	return 0;
 }
 
 static int csi2_probe(struct platform_device *pdev)
 {
+	unsigned int sink_port = 0;
 	struct csi2_dev *csi2;
 	struct resource *res;
 	int ret;
@@ -601,10 +600,6 @@ static int csi2_probe(struct platform_device *pdev)
 	csi2->sd.entity.function = MEDIA_ENT_F_VID_IF_BRIDGE;
 	csi2->sd.grp_id = IMX_MEDIA_GRP_ID_CSI2;
 
-	ret = csi2_parse_endpoints(csi2);
-	if (ret)
-		return ret;
-
 	csi2->pllref_clk = devm_clk_get(&pdev->dev, "ref");
 	if (IS_ERR(csi2->pllref_clk)) {
 		v4l2_err(&csi2->sd, "failed to get pll reference clock\n");
@@ -654,7 +649,9 @@ static int csi2_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, &csi2->sd);
 
-	ret = v4l2_async_register_subdev(&csi2->sd);
+	ret = v4l2_async_register_fwnode_subdev(
+		&csi2->sd, sizeof(struct v4l2_async_subdev),
+		&sink_port, 1, csi2_parse_endpoint);
 	if (ret)
 		goto dphy_off;
 
-- 
2.7.4
