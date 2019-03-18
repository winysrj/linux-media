Return-Path: <SRS0=vX6K=RV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B7F8C43381
	for <linux-media@archiver.kernel.org>; Mon, 18 Mar 2019 19:17:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01D922133F
	for <linux-media@archiver.kernel.org>; Mon, 18 Mar 2019 19:17:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727572AbfCRTQ7 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Mar 2019 15:16:59 -0400
Received: from retiisi.org.uk ([95.216.213.190]:55194 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727570AbfCRTQ6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Mar 2019 15:16:58 -0400
Received: from lanttu.localdomain (lanttu.retiisi.org.uk [IPv6:2a01:4f9:c010:4572::c1:2])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 040B3634C7D;
        Mon, 18 Mar 2019 21:15:03 +0200 (EET)
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Cc:     niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com
Subject: [RFC 1/8] v4l2-async: Use endpoint node, not device node, for fwnode match
Date:   Mon, 18 Mar 2019 21:16:46 +0200
Message-Id: <20190318191653.7197-2-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190318191653.7197-1-sakari.ailus@linux.intel.com>
References: <20190318191653.7197-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

V4L2 async framework can use both device's fwnode and endpoints's fwnode
for matching the async sub-device with the sub-device. In order to proceed
moving towards endpoint matching assign the endpoint to the async
sub-device.

As most async sub-device drivers (and the related hardware) only supports
a single endpoint, use the first endpoint found. This works for all
current drivers --- we only ever supported a single async sub-device per
device to begin with.

For async devices that have no endpoints, continue to use the fwnode
related to the device. This includes e.g. lens devices.

Depends-on: ("pxa-camera: Match with device node, not the port node")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/platform/am437x/am437x-vpfe.c   |  2 +-
 drivers/media/platform/atmel/atmel-isc.c      |  2 +-
 drivers/media/platform/atmel/atmel-isi.c      |  2 +-
 drivers/media/platform/cadence/cdns-csi2rx.c  |  2 +-
 drivers/media/platform/davinci/vpif_capture.c | 14 +-------------
 drivers/media/platform/exynos4-is/media-dev.c | 14 ++++++++++----
 drivers/media/platform/pxa_camera.c           |  2 +-
 drivers/media/platform/qcom/camss/camss.c     | 10 +++++-----
 drivers/media/platform/rcar_drif.c            |  3 ++-
 drivers/media/platform/renesas-ceu.c          |  2 +-
 drivers/media/platform/stm32/stm32-dcmi.c     |  2 +-
 drivers/media/platform/ti-vpe/cal.c           |  2 +-
 drivers/media/platform/xilinx/xilinx-vipp.c   | 13 ++++++++++---
 drivers/media/v4l2-core/v4l2-async.c          |  8 ++++++--
 drivers/media/v4l2-core/v4l2-fwnode.c         |  2 +-
 drivers/staging/media/soc_camera/soc_camera.c | 14 ++++++++------
 16 files changed, 51 insertions(+), 43 deletions(-)

diff --git a/drivers/media/platform/am437x/am437x-vpfe.c b/drivers/media/platform/am437x/am437x-vpfe.c
index 5c17624aaade..01c483a1c717 100644
--- a/drivers/media/platform/am437x/am437x-vpfe.c
+++ b/drivers/media/platform/am437x/am437x-vpfe.c
@@ -2495,7 +2495,7 @@ vpfe_get_pdata(struct vpfe_device *vpfe)
 		if (flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH)
 			sdinfo->vpfe_param.vdpol = 1;
 
-		rem = of_graph_get_remote_port_parent(endpoint);
+		rem = of_graph_get_remote_endpoint(endpoint);
 		if (!rem) {
 			dev_err(dev, "Remote device at %pOF not found\n",
 				endpoint);
diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platform/atmel/atmel-isc.c
index 50178968b8a6..d51deda7accb 100644
--- a/drivers/media/platform/atmel/atmel-isc.c
+++ b/drivers/media/platform/atmel/atmel-isc.c
@@ -2041,7 +2041,7 @@ static int isc_parse_dt(struct device *dev, struct isc_device *isc)
 		if (!epn)
 			return 0;
 
-		rem = of_graph_get_remote_port_parent(epn);
+		rem = of_graph_get_remote_endpoint(epn);
 		if (!rem) {
 			dev_notice(dev, "Remote device at %pOF not found\n",
 				   epn);
diff --git a/drivers/media/platform/atmel/atmel-isi.c b/drivers/media/platform/atmel/atmel-isi.c
index 08b8d5583080..e4e74454e016 100644
--- a/drivers/media/platform/atmel/atmel-isi.c
+++ b/drivers/media/platform/atmel/atmel-isi.c
@@ -1110,7 +1110,7 @@ static int isi_graph_parse(struct atmel_isi *isi, struct device_node *node)
 	if (!ep)
 		return -EINVAL;
 
-	remote = of_graph_get_remote_port_parent(ep);
+	remote = of_graph_get_remote_endpoint(ep);
 	of_node_put(ep);
 	if (!remote)
 		return -EINVAL;
diff --git a/drivers/media/platform/cadence/cdns-csi2rx.c b/drivers/media/platform/cadence/cdns-csi2rx.c
index 31ace114eda1..2da34b93e8f4 100644
--- a/drivers/media/platform/cadence/cdns-csi2rx.c
+++ b/drivers/media/platform/cadence/cdns-csi2rx.c
@@ -395,7 +395,7 @@ static int csi2rx_parse_dt(struct csi2rx_priv *csi2rx)
 		return -EINVAL;
 	}
 
-	csi2rx->asd.match.fwnode = fwnode_graph_get_remote_port_parent(fwh);
+	csi2rx->asd.match.fwnode = fwnode_graph_get_remote_endpoint(fwh);
 	csi2rx->asd.match_type = V4L2_ASYNC_MATCH_FWNODE;
 	of_node_put(ep);
 
diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index 6216b7ac6875..bb4c9cb9f2ad 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -1541,7 +1541,6 @@ vpif_capture_get_pdata(struct platform_device *pdev)
 
 	for (i = 0; i < VPIF_CAPTURE_NUM_CHANNELS; i++) {
 		struct v4l2_fwnode_endpoint bus_cfg = { .bus_type = 0 };
-		struct device_node *rem;
 		unsigned int flags;
 		int err;
 
@@ -1550,14 +1549,6 @@ vpif_capture_get_pdata(struct platform_device *pdev)
 		if (!endpoint)
 			break;
 
-		rem = of_graph_get_remote_port_parent(endpoint);
-		if (!rem) {
-			dev_dbg(&pdev->dev, "Remote device at %pOF not found\n",
-				endpoint);
-			of_node_put(endpoint);
-			goto done;
-		}
-
 		sdinfo = &pdata->subdev_info[i];
 		chan = &pdata->chan_config[i];
 		chan->inputs = devm_kcalloc(&pdev->dev,
@@ -1565,7 +1556,6 @@ vpif_capture_get_pdata(struct platform_device *pdev)
 					    sizeof(*chan->inputs),
 					    GFP_KERNEL);
 		if (!chan->inputs) {
-			of_node_put(rem);
 			of_node_put(endpoint);
 			goto err_cleanup;
 		}
@@ -1577,10 +1567,8 @@ vpif_capture_get_pdata(struct platform_device *pdev)
 
 		err = v4l2_fwnode_endpoint_parse(of_fwnode_handle(endpoint),
 						 &bus_cfg);
-		of_node_put(endpoint);
 		if (err) {
 			dev_err(&pdev->dev, "Could not parse the endpoint\n");
-			of_node_put(rem);
 			goto done;
 		}
 
@@ -1599,7 +1587,7 @@ vpif_capture_get_pdata(struct platform_device *pdev)
 		sdinfo->name = rem->full_name;
 
 		pdata->asd[i] = v4l2_async_notifier_add_fwnode_subdev(
-			&vpif_obj.notifier, of_fwnode_handle(rem),
+			&vpif_obj.notifier, of_fwnode_handle(endpoint),
 			sizeof(struct v4l2_async_subdev));
 		if (IS_ERR(pdata->asd[i])) {
 			of_node_put(rem);
diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index 463f2d84553e..2090a627b553 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -411,7 +411,7 @@ static int fimc_md_parse_port_node(struct fimc_md *fmd,
 
 	pd->mux_id = (endpoint.base.port - 1) & 0x1;
 
-	rem = of_graph_get_remote_port_parent(ep);
+	rem = of_graph_get_remote_endpoint(ep);
 	of_node_put(ep);
 	if (rem == NULL) {
 		v4l2_info(&fmd->v4l2_dev, "Remote device at %pOF not found\n",
@@ -1372,11 +1372,17 @@ static int subdev_notifier_bound(struct v4l2_async_notifier *notifier,
 	int i;
 
 	/* Find platform data for this sensor subdev */
-	for (i = 0; i < ARRAY_SIZE(fmd->sensor); i++)
-		if (fmd->sensor[i].asd.match.fwnode ==
-		    of_fwnode_handle(subdev->dev->of_node))
+	for (i = 0; i < ARRAY_SIZE(fmd->sensor); i++) {
+		struct fwnode_handle *fwnode =
+			fwnode_graph_get_remote_port_parent(fmd->sensor[i].asd.
+							    match.fwnode);
+
+		if (fwnode == of_fwnode_handle(subdev->dev->of_node))
 			si = &fmd->sensor[i];
 
+		fwnode_handle_put(fwnode);
+	}
+
 	if (si == NULL)
 		return -EINVAL;
 
diff --git a/drivers/media/platform/pxa_camera.c b/drivers/media/platform/pxa_camera.c
index a632f06d9fff..2a1395d4f74d 100644
--- a/drivers/media/platform/pxa_camera.c
+++ b/drivers/media/platform/pxa_camera.c
@@ -2350,7 +2350,7 @@ static int pxa_camera_pdata_from_dt(struct device *dev,
 		pcdev->platform_flags |= PXA_CAMERA_PCLK_EN;
 
 	asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
-	remote = of_graph_get_remote_port_parent(np);
+	remote = of_graph_get_remote_endpoint(np);
 	if (remote)
 		asd->match.fwnode = of_fwnode_handle(remote);
 	else
diff --git a/drivers/media/platform/qcom/camss/camss.c b/drivers/media/platform/qcom/camss/camss.c
index 63da18773d24..a979f210f441 100644
--- a/drivers/media/platform/qcom/camss/camss.c
+++ b/drivers/media/platform/qcom/camss/camss.c
@@ -466,7 +466,7 @@ static int camss_of_parse_ports(struct camss *camss)
 {
 	struct device *dev = camss->dev;
 	struct device_node *node = NULL;
-	struct device_node *remote = NULL;
+	struct fwnode_handle *remote = NULL;
 	int ret, num_subdevs = 0;
 
 	for_each_endpoint_of_node(dev->of_node, node) {
@@ -476,7 +476,8 @@ static int camss_of_parse_ports(struct camss *camss)
 		if (!of_device_is_available(node))
 			continue;
 
-		remote = of_graph_get_remote_port_parent(node);
+		remote = fwnode_graph_get_remote_endpoint(
+			of_fwnode_handle(node));
 		if (!remote) {
 			dev_err(dev, "Cannot get remote parent\n");
 			ret = -EINVAL;
@@ -484,11 +485,10 @@ static int camss_of_parse_ports(struct camss *camss)
 		}
 
 		asd = v4l2_async_notifier_add_fwnode_subdev(
-			&camss->notifier, of_fwnode_handle(remote),
-			sizeof(*csd));
+			&camss->notifier, remote, sizeof(*csd));
 		if (IS_ERR(asd)) {
 			ret = PTR_ERR(asd);
-			of_node_put(remote);
+			fwnode_handle_put(remote);
 			goto err_cleanup;
 		}
 
diff --git a/drivers/media/platform/rcar_drif.c b/drivers/media/platform/rcar_drif.c
index c417ff8f6fe5..39da118f882a 100644
--- a/drivers/media/platform/rcar_drif.c
+++ b/drivers/media/platform/rcar_drif.c
@@ -1222,7 +1222,8 @@ static int rcar_drif_parse_subdevs(struct rcar_drif_sdr *sdr)
 	if (!ep)
 		return 0;
 
-	fwnode = fwnode_graph_get_remote_port_parent(ep);
+	notifier->subdevs[notifier->num_subdevs] = &sdr->ep.asd;
+	fwnode = fwnode_graph_get_remote_endpoint(ep);
 	if (!fwnode) {
 		dev_warn(sdr->dev, "bad remote port parent\n");
 		fwnode_handle_put(ep);
diff --git a/drivers/media/platform/renesas-ceu.c b/drivers/media/platform/renesas-ceu.c
index 150196f7cf96..a9553bc928fa 100644
--- a/drivers/media/platform/renesas-ceu.c
+++ b/drivers/media/platform/renesas-ceu.c
@@ -1581,7 +1581,7 @@ static int ceu_parse_dt(struct ceu_device *ceudev)
 		ceu_sd = &ceudev->subdevs[i];
 		INIT_LIST_HEAD(&ceu_sd->asd.list);
 
-		remote = of_graph_get_remote_port_parent(ep);
+		remote = of_graph_get_remote_endpoint(ep);
 		ceu_sd->mbus_flags = fw_ep.bus.parallel.flags;
 		ceu_sd->asd.match_type = V4L2_ASYNC_MATCH_FWNODE;
 		ceu_sd->asd.match.fwnode = of_fwnode_handle(remote);
diff --git a/drivers/media/platform/stm32/stm32-dcmi.c b/drivers/media/platform/stm32/stm32-dcmi.c
index 5fe5b38fa901..1dd0e8be95d9 100644
--- a/drivers/media/platform/stm32/stm32-dcmi.c
+++ b/drivers/media/platform/stm32/stm32-dcmi.c
@@ -1576,7 +1576,7 @@ static int dcmi_graph_parse(struct stm32_dcmi *dcmi, struct device_node *node)
 	if (!ep)
 		return -EINVAL;
 
-	remote = of_graph_get_remote_port_parent(ep);
+	remote = of_graph_get_remote_endpoint(ep);
 	of_node_put(ep);
 	if (!remote)
 		return -EINVAL;
diff --git a/drivers/media/platform/ti-vpe/cal.c b/drivers/media/platform/ti-vpe/cal.c
index 8d075683e448..d7995e2f4c54 100644
--- a/drivers/media/platform/ti-vpe/cal.c
+++ b/drivers/media/platform/ti-vpe/cal.c
@@ -1693,7 +1693,7 @@ static int of_cal_create_instance(struct cal_ctx *ctx, int inst)
 		goto cleanup_exit;
 	}
 
-	sensor_node = of_graph_get_remote_port_parent(ep_node);
+	sensor_node = of_graph_get_remote_endpoint(ep_node);
 	if (!sensor_node) {
 		ctx_dbg(3, ctx, "can't get remote parent\n");
 		goto cleanup_exit;
diff --git a/drivers/media/platform/xilinx/xilinx-vipp.c b/drivers/media/platform/xilinx/xilinx-vipp.c
index edce0402155d..41df417153bd 100644
--- a/drivers/media/platform/xilinx/xilinx-vipp.c
+++ b/drivers/media/platform/xilinx/xilinx-vipp.c
@@ -14,6 +14,7 @@
 #include <linux/of.h>
 #include <linux/of_graph.h>
 #include <linux/platform_device.h>
+#include <linux/property.h>
 #include <linux/slab.h>
 
 #include <media/v4l2-async.h>
@@ -81,6 +82,8 @@ static int xvip_graph_build_one(struct xvip_composite_device *xdev,
 	dev_dbg(xdev->dev, "creating links for entity %s\n", local->name);
 
 	while (1) {
+		struct fwnode_handle *fwnode;
+
 		/* Get the next endpoint and parse its link. */
 		ep = fwnode_graph_get_next_endpoint(entity->asd.match.fwnode,
 						    ep);
@@ -116,11 +119,13 @@ static int xvip_graph_build_one(struct xvip_composite_device *xdev,
 			continue;
 		}
 
+		fwnode = fwnode_graph_get_port_parent(link.remote_node);
+		fwnode_handle_put(fwnode);
+
 		/* Skip DMA engines, they will be processed separately. */
-		if (link.remote_node == of_fwnode_handle(xdev->dev->of_node)) {
+		if (fwnode == dev_fwnode(xdev->dev)) {
 			dev_dbg(xdev->dev, "skipping DMA port %p:%u\n",
 				link.local_node, link.local_port);
-			v4l2_fwnode_put_link(&link);
 			continue;
 		}
 
@@ -374,9 +379,11 @@ static int xvip_graph_parse_one(struct xvip_composite_device *xdev,
 		}
 
 		fwnode_handle_put(ep);
+		fwnode = fwnode_graph_get_port_parent(remote);
+		fwnode_handle_put(fwnode);
 
 		/* Skip entities that we have already processed. */
-		if (remote == of_fwnode_handle(xdev->dev->of_node) ||
+		if (fwnode == dev_fwnode(xdev->dev) ||
 		    xvip_graph_find_entity(xdev, remote)) {
 			fwnode_handle_put(remote);
 			continue;
diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index 15b0c44a76e7..4cb49d5f8c03 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -670,8 +670,12 @@ int v4l2_async_register_subdev(struct v4l2_subdev *sd)
 	 * (struct v4l2_subdev.dev), and async sub-device does not
 	 * exist independently of the device at any point of time.
 	 */
-	if (!sd->fwnode && sd->dev)
-		sd->fwnode = dev_fwnode(sd->dev);
+	if (!sd->fwnode && sd->dev) {
+		sd->fwnode = fwnode_graph_get_next_endpoint(
+			dev_fwnode(sd->dev), NULL);
+		if (!sd->fwnode)
+			sd->fwnode = dev_fwnode(sd->dev);
+	}
 
 	mutex_lock(&list_lock);
 
diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index ccefa55813ad..27827842dffd 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -617,7 +617,7 @@ v4l2_async_notifier_fwnode_parse_endpoint(struct device *dev,
 
 	asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
 	asd->match.fwnode =
-		fwnode_graph_get_remote_port_parent(endpoint);
+		fwnode_graph_get_remote_endpoint(endpoint);
 	if (!asd->match.fwnode) {
 		dev_dbg(dev, "no remote endpoint found\n");
 		ret = -ENOTCONN;
diff --git a/drivers/staging/media/soc_camera/soc_camera.c b/drivers/staging/media/soc_camera/soc_camera.c
index 1ab86a7499b9..1b8344a2ea41 100644
--- a/drivers/staging/media/soc_camera/soc_camera.c
+++ b/drivers/staging/media/soc_camera/soc_camera.c
@@ -1518,6 +1518,7 @@ static int soc_of_bind(struct soc_camera_host *ici,
 	struct soc_camera_async_client *sasc;
 	struct soc_of_info *info;
 	struct i2c_client *client;
+	struct device_node *np;
 	char clk_name[V4L2_CLK_NAME_SIZE];
 	int ret;
 
@@ -1552,23 +1553,23 @@ static int soc_of_bind(struct soc_camera_host *ici,
 	v4l2_async_notifier_init(&sasc->notifier);
 
 	ret = v4l2_async_notifier_add_subdev(&sasc->notifier, info->subdev);
-	if (ret) {
-		of_node_put(remote);
+	if (ret)
 		goto eaddasd;
-	}
 
 	sasc->notifier.ops = &soc_camera_async_ops;
 
 	icd->sasc = sasc;
 	icd->parent = ici->v4l2_dev.dev;
+	np = of_graph_get_port_parent(remote);
+	of_node_put(remote);
 
-	client = of_find_i2c_device_by_node(remote);
+	client = of_find_i2c_device_by_node(np);
 
 	if (client)
 		v4l2_clk_name_i2c(clk_name, sizeof(clk_name),
 				  client->adapter->nr, client->addr);
 	else
-		v4l2_clk_name_of(clk_name, sizeof(clk_name), remote);
+		v4l2_clk_name_of(clk_name, sizeof(clk_name), np);
 
 	icd->clk = v4l2_clk_register(&soc_camera_clk_ops, clk_name, icd);
 	if (IS_ERR(icd->clk)) {
@@ -1591,6 +1592,7 @@ static int soc_of_bind(struct soc_camera_host *ici,
 eallocpdev:
 	devm_kfree(ici->v4l2_dev.dev, info);
 	dev_err(ici->v4l2_dev.dev, "group probe failed: %d\n", ret);
+	of_node_put(np);
 
 	return ret;
 }
@@ -1607,7 +1609,7 @@ static void scan_of_host(struct soc_camera_host *ici)
 		if (!epn)
 			break;
 
-		rem = of_graph_get_remote_port_parent(epn);
+		rem = of_graph_get_remote_endpoint(epn);
 		if (!rem) {
 			dev_notice(dev, "no remote for %pOF\n", epn);
 			continue;
-- 
2.11.0

