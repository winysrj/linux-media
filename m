Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb0-f194.google.com ([209.85.213.194]:32955 "EHLO
        mail-yb0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753502AbdGUT2x (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Jul 2017 15:28:53 -0400
From: Rob Herring <robh@kernel.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Minghsiu Tsai <minghsiu.tsai@mediatek.com>,
        Houlong Wei <houlong.wei@mediatek.com>,
        Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Hyun Kwon <hyun.kwon@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH v2] media: Convert to using %pOF instead of full_name
Date: Fri, 21 Jul 2017 14:28:33 -0500
Message-Id: <20170721192835.25555-2-robh@kernel.org>
In-Reply-To: <20170721192835.25555-1-robh@kernel.org>
References: <20170721192835.25555-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that we have a custom printf format specifier, convert users of
full_name to use %pOF instead. This is preparation to remove storing
of the full path string for each node.

Signed-off-by: Rob Herring <robh@kernel.org>
Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Andrzej Hajda <a.hajda@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Songjun Wu <songjun.wu@microchip.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Kukjin Kim <kgene@kernel.org>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
Cc: Houlong Wei <houlong.wei@mediatek.com>
Cc: Andrew-CT Chen <andrew-ct.chen@mediatek.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Hyun Kwon <hyun.kwon@xilinx.com>
Cc: Michal Simek <michal.simek@xilinx.com>
Cc: "Sören Brinkmann" <soren.brinkmann@xilinx.com>
Cc: linux-media@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-samsung-soc@vger.kernel.org
Cc: linux-mediatek@lists.infradead.org
Cc: linux-renesas-soc@vger.kernel.org
---
v2:
- Fix missing to_of_node() in xilinx-vipp.c
- Drop v4l2-async.c changes. Doing as revert instead.
- Add acks

 drivers/media/i2c/s5c73m3/s5c73m3-core.c       |  3 +-
 drivers/media/i2c/s5k5baf.c                    |  7 ++--
 drivers/media/platform/am437x/am437x-vpfe.c    |  4 +-
 drivers/media/platform/atmel/atmel-isc.c       |  4 +-
 drivers/media/platform/davinci/vpif_capture.c  | 16 ++++----
 drivers/media/platform/exynos4-is/fimc-is.c    |  8 ++--
 drivers/media/platform/exynos4-is/fimc-lite.c  |  3 +-
 drivers/media/platform/exynos4-is/media-dev.c  |  8 ++--
 drivers/media/platform/exynos4-is/mipi-csis.c  |  4 +-
 drivers/media/platform/mtk-mdp/mtk_mdp_comp.c  |  6 +--
 drivers/media/platform/mtk-mdp/mtk_mdp_core.c  |  8 ++--
 drivers/media/platform/omap3isp/isp.c          |  8 ++--
 drivers/media/platform/pxa_camera.c            |  2 +-
 drivers/media/platform/rcar-vin/rcar-core.c    |  4 +-
 drivers/media/platform/soc_camera/soc_camera.c |  6 +--
 drivers/media/platform/xilinx/xilinx-vipp.c    | 52 +++++++++++++-------------
 drivers/media/v4l2-core/v4l2-clk.c             |  3 +-
 include/media/v4l2-clk.h                       |  4 +-
 18 files changed, 70 insertions(+), 80 deletions(-)

diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-core.c b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
index f434fb2ee6fc..cdc4f2392ef9 100644
--- a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
+++ b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
@@ -1635,8 +1635,7 @@ static int s5c73m3_get_platform_data(struct s5c73m3 *state)
 
 	node_ep = of_graph_get_next_endpoint(node, NULL);
 	if (!node_ep) {
-		dev_warn(dev, "no endpoint defined for node: %s\n",
-						node->full_name);
+		dev_warn(dev, "no endpoint defined for node: %pOF\n", node);
 		return 0;
 	}
 
diff --git a/drivers/media/i2c/s5k5baf.c b/drivers/media/i2c/s5k5baf.c
index 962051b9939d..9c22fc963901 100644
--- a/drivers/media/i2c/s5k5baf.c
+++ b/drivers/media/i2c/s5k5baf.c
@@ -1863,8 +1863,7 @@ static int s5k5baf_parse_device_node(struct s5k5baf *state, struct device *dev)
 
 	node_ep = of_graph_get_next_endpoint(node, NULL);
 	if (!node_ep) {
-		dev_err(dev, "no endpoint defined at node %s\n",
-			node->full_name);
+		dev_err(dev, "no endpoint defined at node %pOF\n", node);
 		return -EINVAL;
 	}
 
@@ -1882,8 +1881,8 @@ static int s5k5baf_parse_device_node(struct s5k5baf *state, struct device *dev)
 	case V4L2_MBUS_PARALLEL:
 		break;
 	default:
-		dev_err(dev, "unsupported bus in endpoint defined at node %s\n",
-			node->full_name);
+		dev_err(dev, "unsupported bus in endpoint defined at node %pOF\n",
+			node);
 		return -EINVAL;
 	}
 
diff --git a/drivers/media/platform/am437x/am437x-vpfe.c b/drivers/media/platform/am437x/am437x-vpfe.c
index 466aba8b0e00..dfcc484cab89 100644
--- a/drivers/media/platform/am437x/am437x-vpfe.c
+++ b/drivers/media/platform/am437x/am437x-vpfe.c
@@ -2490,8 +2490,8 @@ vpfe_get_pdata(struct platform_device *pdev)
 
 		rem = of_graph_get_remote_port_parent(endpoint);
 		if (!rem) {
-			dev_err(&pdev->dev, "Remote device at %s not found\n",
-				endpoint->full_name);
+			dev_err(&pdev->dev, "Remote device at %pOF not found\n",
+				endpoint);
 			goto done;
 		}
 
diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platform/atmel/atmel-isc.c
index d6534252cdcd..b2c66b239cf2 100644
--- a/drivers/media/platform/atmel/atmel-isc.c
+++ b/drivers/media/platform/atmel/atmel-isc.c
@@ -1700,8 +1700,8 @@ static int isc_parse_dt(struct device *dev, struct isc_device *isc)
 
 		rem = of_graph_get_remote_port_parent(epn);
 		if (!rem) {
-			dev_notice(dev, "Remote device at %s not found\n",
-				   of_node_full_name(epn));
+			dev_notice(dev, "Remote device at %pOF not found\n",
+				   epn);
 			continue;
 		}
 
diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index d78580f9e431..0a7aefa22c67 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -1397,9 +1397,9 @@ static int vpif_async_bound(struct v4l2_async_notifier *notifier,
 			vpif_obj.config->chan_config->inputs[i].subdev_name =
 				(char *)to_of_node(subdev->fwnode)->full_name;
 			vpif_dbg(2, debug,
-				 "%s: setting input %d subdev_name = %s\n",
+				 "%s: setting input %d subdev_name = %pOF\n",
 				 __func__, i,
-				 to_of_node(subdev->fwnode)->full_name);
+				 to_of_node(subdev->fwnode));
 			return 0;
 		}
 	}
@@ -1557,8 +1557,8 @@ vpif_capture_get_pdata(struct platform_device *pdev)
 			dev_err(&pdev->dev, "Could not parse the endpoint\n");
 			goto done;
 		}
-		dev_dbg(&pdev->dev, "Endpoint %s, bus_width = %d\n",
-			endpoint->full_name, bus_cfg.bus.parallel.bus_width);
+		dev_dbg(&pdev->dev, "Endpoint %pOF, bus_width = %d\n",
+			endpoint, bus_cfg.bus.parallel.bus_width);
 		flags = bus_cfg.bus.parallel.flags;
 
 		if (flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH)
@@ -1569,13 +1569,13 @@ vpif_capture_get_pdata(struct platform_device *pdev)
 
 		rem = of_graph_get_remote_port_parent(endpoint);
 		if (!rem) {
-			dev_dbg(&pdev->dev, "Remote device at %s not found\n",
-				endpoint->full_name);
+			dev_dbg(&pdev->dev, "Remote device at %pOF not found\n",
+				endpoint);
 			goto done;
 		}
 
-		dev_dbg(&pdev->dev, "Remote device %s, %s found\n",
-			rem->name, rem->full_name);
+		dev_dbg(&pdev->dev, "Remote device %s, %pOF found\n",
+			rem->name, rem);
 		sdinfo->name = rem->full_name;
 
 		pdata->asd[i] = devm_kzalloc(&pdev->dev,
diff --git a/drivers/media/platform/exynos4-is/fimc-is.c b/drivers/media/platform/exynos4-is/fimc-is.c
index 340d906db370..5ddb2321e9e4 100644
--- a/drivers/media/platform/exynos4-is/fimc-is.c
+++ b/drivers/media/platform/exynos4-is/fimc-is.c
@@ -174,8 +174,8 @@ static int fimc_is_parse_sensor_config(struct fimc_is *is, unsigned int index,
 
 	sensor->drvdata = fimc_is_sensor_get_drvdata(node);
 	if (!sensor->drvdata) {
-		dev_err(&is->pdev->dev, "no driver data found for: %s\n",
-							 node->full_name);
+		dev_err(&is->pdev->dev, "no driver data found for: %pOF\n",
+							 node);
 		return -EINVAL;
 	}
 
@@ -191,8 +191,8 @@ static int fimc_is_parse_sensor_config(struct fimc_is *is, unsigned int index,
 	/* Use MIPI-CSIS channel id to determine the ISP I2C bus index. */
 	ret = of_property_read_u32(port, "reg", &tmp);
 	if (ret < 0) {
-		dev_err(&is->pdev->dev, "reg property not found at: %s\n",
-							 port->full_name);
+		dev_err(&is->pdev->dev, "reg property not found at: %pOF\n",
+							 port);
 		of_node_put(port);
 		return ret;
 	}
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index 7d3ec5cc6608..388a964cbf76 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -1493,8 +1493,7 @@ static int fimc_lite_probe(struct platform_device *pdev)
 
 	if (!drv_data || fimc->index >= drv_data->num_instances ||
 						fimc->index < 0) {
-		dev_err(dev, "Wrong %s node alias\n",
-					dev->of_node->full_name);
+		dev_err(dev, "Wrong %pOF node alias\n", dev->of_node);
 		return -EINVAL;
 	}
 
diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index 7d1cf78846c4..d4656d5175d7 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -412,8 +412,8 @@ static int fimc_md_parse_port_node(struct fimc_md *fmd,
 	rem = of_graph_get_remote_port_parent(ep);
 	of_node_put(ep);
 	if (rem == NULL) {
-		v4l2_info(&fmd->v4l2_dev, "Remote device at %s not found\n",
-							ep->full_name);
+		v4l2_info(&fmd->v4l2_dev, "Remote device at %pOF not found\n",
+							ep);
 		return 0;
 	}
 
@@ -430,8 +430,8 @@ static int fimc_md_parse_port_node(struct fimc_md *fmd,
 		 */
 		pd->sensor_bus_type = FIMC_BUS_TYPE_MIPI_CSI2;
 	} else {
-		v4l2_err(&fmd->v4l2_dev, "Wrong port id (%u) at node %s\n",
-			 endpoint.base.port, rem->full_name);
+		v4l2_err(&fmd->v4l2_dev, "Wrong port id (%u) at node %pOF\n",
+			 endpoint.base.port, rem);
 	}
 	/*
 	 * For FIMC-IS handled sensors, that are placed under i2c-isp device
diff --git a/drivers/media/platform/exynos4-is/mipi-csis.c b/drivers/media/platform/exynos4-is/mipi-csis.c
index 98c89873c2dc..560aadabcb11 100644
--- a/drivers/media/platform/exynos4-is/mipi-csis.c
+++ b/drivers/media/platform/exynos4-is/mipi-csis.c
@@ -730,8 +730,8 @@ static int s5pcsis_parse_dt(struct platform_device *pdev,
 
 	node = of_graph_get_next_endpoint(node, NULL);
 	if (!node) {
-		dev_err(&pdev->dev, "No port node at %s\n",
-				pdev->dev.of_node->full_name);
+		dev_err(&pdev->dev, "No port node at %pOF\n",
+				pdev->dev.of_node);
 		return -EINVAL;
 	}
 	/* Get port node and validate MIPI-CSI channel id. */
diff --git a/drivers/media/platform/mtk-mdp/mtk_mdp_comp.c b/drivers/media/platform/mtk-mdp/mtk_mdp_comp.c
index aa8f9fd1f1a2..e728d32d9408 100644
--- a/drivers/media/platform/mtk-mdp/mtk_mdp_comp.c
+++ b/drivers/media/platform/mtk-mdp/mtk_mdp_comp.c
@@ -134,15 +134,13 @@ int mtk_mdp_comp_init(struct device *dev, struct device_node *node,
 	larb_node = of_parse_phandle(node, "mediatek,larb", 0);
 	if (!larb_node) {
 		dev_err(dev,
-			"Missing mediadek,larb phandle in %s node\n",
-			node->full_name);
+			"Missing mediadek,larb phandle in %pOF node\n", node);
 		return -EINVAL;
 	}
 
 	larb_pdev = of_find_device_by_node(larb_node);
 	if (!larb_pdev) {
-		dev_warn(dev, "Waiting for larb device %s\n",
-			 larb_node->full_name);
+		dev_warn(dev, "Waiting for larb device %pOF\n", larb_node);
 		of_node_put(larb_node);
 		return -EPROBE_DEFER;
 	}
diff --git a/drivers/media/platform/mtk-mdp/mtk_mdp_core.c b/drivers/media/platform/mtk-mdp/mtk_mdp_core.c
index 81347558b24a..bbb24fb95b95 100644
--- a/drivers/media/platform/mtk-mdp/mtk_mdp_core.c
+++ b/drivers/media/platform/mtk-mdp/mtk_mdp_core.c
@@ -137,16 +137,16 @@ static int mtk_mdp_probe(struct platform_device *pdev)
 			continue;
 
 		if (!of_device_is_available(node)) {
-			dev_err(dev, "Skipping disabled component %s\n",
-				node->full_name);
+			dev_err(dev, "Skipping disabled component %pOF\n",
+				node);
 			continue;
 		}
 
 		comp_type = (enum mtk_mdp_comp_type)of_id->data;
 		comp_id = mtk_mdp_comp_get_id(dev, node, comp_type);
 		if (comp_id < 0) {
-			dev_warn(dev, "Skipping unknown component %s\n",
-				 node->full_name);
+			dev_warn(dev, "Skipping unknown component %pOF\n",
+				 node);
 			continue;
 		}
 
diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 9df64c189883..afbc5b7942f8 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2020,8 +2020,8 @@ static int isp_fwnode_parse(struct device *dev, struct fwnode_handle *fwnode,
 	if (ret)
 		return ret;
 
-	dev_dbg(dev, "parsing endpoint %s, interface %u\n",
-		to_of_node(fwnode)->full_name, vep.base.port);
+	dev_dbg(dev, "parsing endpoint %pOF, interface %u\n",
+		to_of_node(fwnode), vep.base.port);
 
 	switch (vep.base.port) {
 	case ISP_OF_PHY_PARALLEL:
@@ -2078,8 +2078,8 @@ static int isp_fwnode_parse(struct device *dev, struct fwnode_handle *fwnode,
 		break;
 
 	default:
-		dev_warn(dev, "%s: invalid interface %u\n",
-			 to_of_node(fwnode)->full_name, vep.base.port);
+		dev_warn(dev, "%pOF: invalid interface %u\n",
+			 to_of_node(fwnode), vep.base.port);
 		break;
 	}
 
diff --git a/drivers/media/platform/pxa_camera.c b/drivers/media/platform/pxa_camera.c
index 399095170b6e..787ae4c3c343 100644
--- a/drivers/media/platform/pxa_camera.c
+++ b/drivers/media/platform/pxa_camera.c
@@ -2328,7 +2328,7 @@ static int pxa_camera_pdata_from_dt(struct device *dev,
 		asd->match.fwnode.fwnode = of_fwnode_handle(remote);
 		of_node_put(remote);
 	} else {
-		dev_notice(dev, "no remote for %s\n", of_node_full_name(np));
+		dev_notice(dev, "no remote for %pOF\n", np);
 	}
 
 out:
diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index 77dff047c41c..142de447aaaa 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -222,8 +222,8 @@ static int rvin_digital_graph_init(struct rvin_dev *vin)
 
 	subdevs[0] = &vin->digital.asd;
 
-	vin_dbg(vin, "Found digital subdevice %s\n",
-		of_node_full_name(to_of_node(subdevs[0]->match.fwnode.fwnode)));
+	vin_dbg(vin, "Found digital subdevice %pOF\n",
+		to_of_node(subdevs[0]->match.fwnode.fwnode));
 
 	vin->notifier.num_subdevs = 1;
 	vin->notifier.subdevs = subdevs;
diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 45a0429d75bb..8ba0cb88df64 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -1550,8 +1550,7 @@ static int soc_of_bind(struct soc_camera_host *ici,
 		v4l2_clk_name_i2c(clk_name, sizeof(clk_name),
 				  client->adapter->nr, client->addr);
 	else
-		v4l2_clk_name_of(clk_name, sizeof(clk_name),
-				 of_node_full_name(remote));
+		v4l2_clk_name_of(clk_name, sizeof(clk_name), remote);
 
 	icd->clk = v4l2_clk_register(&soc_camera_clk_ops, clk_name, icd);
 	if (IS_ERR(icd->clk)) {
@@ -1590,8 +1589,7 @@ static void scan_of_host(struct soc_camera_host *ici)
 
 		ren = of_graph_get_remote_port(epn);
 		if (!ren) {
-			dev_notice(dev, "no remote for %s\n",
-				   of_node_full_name(epn));
+			dev_notice(dev, "no remote for %pOF\n", epn);
 			continue;
 		}
 
diff --git a/drivers/media/platform/xilinx/xilinx-vipp.c b/drivers/media/platform/xilinx/xilinx-vipp.c
index ac4704388920..ebfdf334d99c 100644
--- a/drivers/media/platform/xilinx/xilinx-vipp.c
+++ b/drivers/media/platform/xilinx/xilinx-vipp.c
@@ -90,12 +90,12 @@ static int xvip_graph_build_one(struct xvip_composite_device *xdev,
 		of_node_put(ep);
 		ep = next;
 
-		dev_dbg(xdev->dev, "processing endpoint %s\n", ep->full_name);
+		dev_dbg(xdev->dev, "processing endpoint %pOF\n", ep);
 
 		ret = v4l2_fwnode_parse_link(of_fwnode_handle(ep), &link);
 		if (ret < 0) {
-			dev_err(xdev->dev, "failed to parse link for %s\n",
-				ep->full_name);
+			dev_err(xdev->dev, "failed to parse link for %pOF\n",
+				ep);
 			continue;
 		}
 
@@ -103,9 +103,9 @@ static int xvip_graph_build_one(struct xvip_composite_device *xdev,
 		 * the link.
 		 */
 		if (link.local_port >= local->num_pads) {
-			dev_err(xdev->dev, "invalid port number %u for %s\n",
+			dev_err(xdev->dev, "invalid port number %u for %pOF\n",
 				link.local_port,
-				to_of_node(link.local_node)->full_name);
+				to_of_node(link.local_node));
 			v4l2_fwnode_put_link(&link);
 			ret = -EINVAL;
 			break;
@@ -114,8 +114,8 @@ static int xvip_graph_build_one(struct xvip_composite_device *xdev,
 		local_pad = &local->pads[link.local_port];
 
 		if (local_pad->flags & MEDIA_PAD_FL_SINK) {
-			dev_dbg(xdev->dev, "skipping sink port %s:%u\n",
-				to_of_node(link.local_node)->full_name,
+			dev_dbg(xdev->dev, "skipping sink port %pOF:%u\n",
+				to_of_node(link.local_node),
 				link.local_port);
 			v4l2_fwnode_put_link(&link);
 			continue;
@@ -123,8 +123,8 @@ static int xvip_graph_build_one(struct xvip_composite_device *xdev,
 
 		/* Skip DMA engines, they will be processed separately. */
 		if (link.remote_node == of_fwnode_handle(xdev->dev->of_node)) {
-			dev_dbg(xdev->dev, "skipping DMA port %s:%u\n",
-				to_of_node(link.local_node)->full_name,
+			dev_dbg(xdev->dev, "skipping DMA port %pOF:%u\n",
+				to_of_node(link.local_node),
 				link.local_port);
 			v4l2_fwnode_put_link(&link);
 			continue;
@@ -134,8 +134,8 @@ static int xvip_graph_build_one(struct xvip_composite_device *xdev,
 		ent = xvip_graph_find_entity(xdev,
 					     to_of_node(link.remote_node));
 		if (ent == NULL) {
-			dev_err(xdev->dev, "no entity found for %s\n",
-				to_of_node(link.remote_node)->full_name);
+			dev_err(xdev->dev, "no entity found for %pOF\n",
+				to_of_node(link.remote_node));
 			v4l2_fwnode_put_link(&link);
 			ret = -ENODEV;
 			break;
@@ -144,9 +144,8 @@ static int xvip_graph_build_one(struct xvip_composite_device *xdev,
 		remote = ent->entity;
 
 		if (link.remote_port >= remote->num_pads) {
-			dev_err(xdev->dev, "invalid port number %u on %s\n",
-				link.remote_port,
-				to_of_node(link.remote_node)->full_name);
+			dev_err(xdev->dev, "invalid port number %u on %pOF\n",
+				link.remote_port, to_of_node(link.remote_node));
 			v4l2_fwnode_put_link(&link);
 			ret = -EINVAL;
 			break;
@@ -216,12 +215,12 @@ static int xvip_graph_build_dma(struct xvip_composite_device *xdev)
 		of_node_put(ep);
 		ep = next;
 
-		dev_dbg(xdev->dev, "processing endpoint %s\n", ep->full_name);
+		dev_dbg(xdev->dev, "processing endpoint %pOF\n", ep);
 
 		ret = v4l2_fwnode_parse_link(of_fwnode_handle(ep), &link);
 		if (ret < 0) {
-			dev_err(xdev->dev, "failed to parse link for %s\n",
-				ep->full_name);
+			dev_err(xdev->dev, "failed to parse link for %pOF\n",
+				ep);
 			continue;
 		}
 
@@ -242,17 +241,17 @@ static int xvip_graph_build_dma(struct xvip_composite_device *xdev)
 		ent = xvip_graph_find_entity(xdev,
 					     to_of_node(link.remote_node));
 		if (ent == NULL) {
-			dev_err(xdev->dev, "no entity found for %s\n",
-				to_of_node(link.remote_node)->full_name);
+			dev_err(xdev->dev, "no entity found for %pOF\n",
+				to_of_node(link.remote_node));
 			v4l2_fwnode_put_link(&link);
 			ret = -ENODEV;
 			break;
 		}
 
 		if (link.remote_port >= ent->entity->num_pads) {
-			dev_err(xdev->dev, "invalid port number %u on %s\n",
+			dev_err(xdev->dev, "invalid port number %u on %pOF\n",
 				link.remote_port,
-				to_of_node(link.remote_node)->full_name);
+				to_of_node(link.remote_node));
 			v4l2_fwnode_put_link(&link);
 			ret = -EINVAL;
 			break;
@@ -337,8 +336,8 @@ static int xvip_graph_notify_bound(struct v4l2_async_notifier *notifier,
 			continue;
 
 		if (entity->subdev) {
-			dev_err(xdev->dev, "duplicate subdev for node %s\n",
-				entity->node->full_name);
+			dev_err(xdev->dev, "duplicate subdev for node %pOF\n",
+				entity->node);
 			return -EINVAL;
 		}
 
@@ -360,14 +359,14 @@ static int xvip_graph_parse_one(struct xvip_composite_device *xdev,
 	struct device_node *ep = NULL;
 	int ret = 0;
 
-	dev_dbg(xdev->dev, "parsing node %s\n", node->full_name);
+	dev_dbg(xdev->dev, "parsing node %pOF\n", node);
 
 	while (1) {
 		ep = of_graph_get_next_endpoint(node, ep);
 		if (ep == NULL)
 			break;
 
-		dev_dbg(xdev->dev, "handling endpoint %s\n", ep->full_name);
+		dev_dbg(xdev->dev, "handling endpoint %pOF\n", ep);
 
 		remote = of_graph_get_remote_port_parent(ep);
 		if (remote == NULL) {
@@ -452,8 +451,7 @@ static int xvip_graph_dma_init_one(struct xvip_composite_device *xdev,
 
 	ret = xvip_dma_init(xdev, dma, type, index);
 	if (ret < 0) {
-		dev_err(xdev->dev, "%s initialization failed\n",
-			node->full_name);
+		dev_err(xdev->dev, "%pOF initialization failed\n", node);
 		return ret;
 	}
 
diff --git a/drivers/media/v4l2-core/v4l2-clk.c b/drivers/media/v4l2-core/v4l2-clk.c
index 297e10e69898..90628d7a04de 100644
--- a/drivers/media/v4l2-core/v4l2-clk.c
+++ b/drivers/media/v4l2-core/v4l2-clk.c
@@ -61,8 +61,7 @@ struct v4l2_clk *v4l2_clk_get(struct device *dev, const char *id)
 
 	/* if dev_name is not found, try use the OF name to find again  */
 	if (PTR_ERR(clk) == -ENODEV && dev->of_node) {
-		v4l2_clk_name_of(clk_name, sizeof(clk_name),
-				 of_node_full_name(dev->of_node));
+		v4l2_clk_name_of(clk_name, sizeof(clk_name), dev->of_node);
 		clk = v4l2_clk_find(clk_name);
 	}
 
diff --git a/include/media/v4l2-clk.h b/include/media/v4l2-clk.h
index 2b94662d005c..7ec857f805a6 100644
--- a/include/media/v4l2-clk.h
+++ b/include/media/v4l2-clk.h
@@ -70,7 +70,7 @@ static inline struct v4l2_clk *v4l2_clk_register_fixed(const char *dev_id,
 #define v4l2_clk_name_i2c(name, size, adap, client) snprintf(name, size, \
 			  "%d-%04x", adap, client)
 
-#define v4l2_clk_name_of(name, size, of_full_name) snprintf(name, size, \
-			  "of-%s", of_full_name)
+#define v4l2_clk_name_of(name, size, node) snprintf(name, size, \
+			  "of-%pOF", node)
 
 #endif
-- 
2.11.0
