Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40962 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728261AbeIMCgL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Sep 2018 22:36:11 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, slongerbeam@gmail.com,
        niklas.soderlund@ragnatech.se, jacopo@jmondi.org,
        p.zabel@pengutronix.de, dri-devel@lists.freedesktop.org
Subject: [PATCH v3 16/23] v4l: fwnode: Initialise the V4L2 fwnode endpoints to zero
Date: Thu, 13 Sep 2018 00:29:35 +0300
Message-Id: <20180912212942.19641-17-sakari.ailus@linux.intel.com>
In-Reply-To: <20180912212942.19641-1-sakari.ailus@linux.intel.com>
References: <20180912212942.19641-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Initialise the V4L2 fwnode endpoints to zero in all drivers using
v4l2_fwnode_endpoint_parse(). This prepares for setting default endpoint
flags as well as the bus type. Setting bus type to zero will continue to
guess the bus among the guessable set (parallel, Bt.656 and CSI-2 D-PHY).

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Tested-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/media/i2c/adv7604.c                   | 2 +-
 drivers/media/i2c/mt9v032.c                   | 2 +-
 drivers/media/i2c/ov5647.c                    | 2 +-
 drivers/media/i2c/ov7670.c                    | 2 +-
 drivers/media/i2c/s5c73m3/s5c73m3-core.c      | 2 +-
 drivers/media/i2c/s5k5baf.c                   | 2 +-
 drivers/media/i2c/tda1997x.c                  | 2 +-
 drivers/media/i2c/tvp514x.c                   | 2 +-
 drivers/media/i2c/tvp5150.c                   | 2 +-
 drivers/media/i2c/tvp7002.c                   | 2 +-
 drivers/media/platform/am437x/am437x-vpfe.c   | 2 +-
 drivers/media/platform/atmel/atmel-isc.c      | 3 ++-
 drivers/media/platform/atmel/atmel-isi.c      | 2 +-
 drivers/media/platform/cadence/cdns-csi2rx.c  | 2 +-
 drivers/media/platform/cadence/cdns-csi2tx.c  | 2 +-
 drivers/media/platform/davinci/vpif_capture.c | 2 +-
 drivers/media/platform/exynos4-is/media-dev.c | 2 +-
 drivers/media/platform/exynos4-is/mipi-csis.c | 2 +-
 drivers/media/platform/pxa_camera.c           | 2 +-
 drivers/media/platform/rcar-vin/rcar-csi2.c   | 2 +-
 drivers/media/platform/renesas-ceu.c          | 3 ++-
 drivers/media/platform/stm32/stm32-dcmi.c     | 2 +-
 drivers/staging/media/imx/imx-media-csi.c     | 8 ++++----
 include/media/v4l2-fwnode.h                   | 2 ++
 24 files changed, 30 insertions(+), 26 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 668be2bca57a..413578dc23a3 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -3093,7 +3093,7 @@ MODULE_DEVICE_TABLE(of, adv76xx_of_id);
 
 static int adv76xx_parse_dt(struct adv76xx_state *state)
 {
-	struct v4l2_fwnode_endpoint bus_cfg;
+	struct v4l2_fwnode_endpoint bus_cfg = { .bus_type = 0 };
 	struct device_node *endpoint;
 	struct device_node *np;
 	unsigned int flags;
diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
index f74730d24d8f..67f69ad6ecf4 100644
--- a/drivers/media/i2c/mt9v032.c
+++ b/drivers/media/i2c/mt9v032.c
@@ -989,7 +989,7 @@ static struct mt9v032_platform_data *
 mt9v032_get_pdata(struct i2c_client *client)
 {
 	struct mt9v032_platform_data *pdata = NULL;
-	struct v4l2_fwnode_endpoint endpoint;
+	struct v4l2_fwnode_endpoint endpoint = { .bus_type = 0 };
 	struct device_node *np;
 	struct property *prop;
 
diff --git a/drivers/media/i2c/ov5647.c b/drivers/media/i2c/ov5647.c
index da39c49de503..4589631798c9 100644
--- a/drivers/media/i2c/ov5647.c
+++ b/drivers/media/i2c/ov5647.c
@@ -532,7 +532,7 @@ static const struct v4l2_subdev_internal_ops ov5647_subdev_internal_ops = {
 
 static int ov5647_parse_dt(struct device_node *np)
 {
-	struct v4l2_fwnode_endpoint bus_cfg;
+	struct v4l2_fwnode_endpoint bus_cfg = { .bus_type = 0 };
 	struct device_node *ep;
 
 	int ret;
diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index 31bf577b0bd3..92f59ae1b624 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -1728,7 +1728,7 @@ static int ov7670_parse_dt(struct device *dev,
 			   struct ov7670_info *info)
 {
 	struct fwnode_handle *fwnode = dev_fwnode(dev);
-	struct v4l2_fwnode_endpoint bus_cfg;
+	struct v4l2_fwnode_endpoint bus_cfg = { .bus_type = 0 };
 	struct fwnode_handle *ep;
 	int ret;
 
diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-core.c b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
index 479c9753e863..9bb28faad1b3 100644
--- a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
+++ b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
@@ -1603,7 +1603,7 @@ static int s5c73m3_get_platform_data(struct s5c73m3 *state)
 	const struct s5c73m3_platform_data *pdata = dev->platform_data;
 	struct device_node *node = dev->of_node;
 	struct device_node *node_ep;
-	struct v4l2_fwnode_endpoint ep;
+	struct v4l2_fwnode_endpoint ep = { .bus_type = 0 };
 	int ret;
 
 	if (!node) {
diff --git a/drivers/media/i2c/s5k5baf.c b/drivers/media/i2c/s5k5baf.c
index 4c41a770b132..727db7c0670a 100644
--- a/drivers/media/i2c/s5k5baf.c
+++ b/drivers/media/i2c/s5k5baf.c
@@ -1841,7 +1841,7 @@ static int s5k5baf_parse_device_node(struct s5k5baf *state, struct device *dev)
 {
 	struct device_node *node = dev->of_node;
 	struct device_node *node_ep;
-	struct v4l2_fwnode_endpoint ep;
+	struct v4l2_fwnode_endpoint ep = { .bus_type = 0 };
 	int ret;
 
 	if (!node) {
diff --git a/drivers/media/i2c/tda1997x.c b/drivers/media/i2c/tda1997x.c
index d114ac5243ec..c4c2a6134e1e 100644
--- a/drivers/media/i2c/tda1997x.c
+++ b/drivers/media/i2c/tda1997x.c
@@ -2265,7 +2265,7 @@ MODULE_DEVICE_TABLE(of, tda1997x_of_id);
 static int tda1997x_parse_dt(struct tda1997x_state *state)
 {
 	struct tda1997x_platform_data *pdata = &state->pdata;
-	struct v4l2_fwnode_endpoint bus_cfg;
+	struct v4l2_fwnode_endpoint bus_cfg = { .bus_type = 0 };
 	struct device_node *ep;
 	struct device_node *np;
 	unsigned int flags;
diff --git a/drivers/media/i2c/tvp514x.c b/drivers/media/i2c/tvp514x.c
index 675b9ae212ab..1cc83cb934e2 100644
--- a/drivers/media/i2c/tvp514x.c
+++ b/drivers/media/i2c/tvp514x.c
@@ -989,7 +989,7 @@ static struct tvp514x_platform_data *
 tvp514x_get_pdata(struct i2c_client *client)
 {
 	struct tvp514x_platform_data *pdata = NULL;
-	struct v4l2_fwnode_endpoint bus_cfg;
+	struct v4l2_fwnode_endpoint bus_cfg = { .bus_type = 0 };
 	struct device_node *endpoint;
 	unsigned int flags;
 
diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 76e6bed5a1da..a305c3022c9d 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -1362,7 +1362,7 @@ static int tvp5150_init(struct i2c_client *c)
 
 static int tvp5150_parse_dt(struct tvp5150 *decoder, struct device_node *np)
 {
-	struct v4l2_fwnode_endpoint bus_cfg;
+	struct v4l2_fwnode_endpoint bus_cfg = { .bus_type = 0 };
 	struct device_node *ep;
 #ifdef CONFIG_MEDIA_CONTROLLER
 	struct device_node *connectors, *child;
diff --git a/drivers/media/i2c/tvp7002.c b/drivers/media/i2c/tvp7002.c
index 4f5c627579c7..cab2f2bd0aa9 100644
--- a/drivers/media/i2c/tvp7002.c
+++ b/drivers/media/i2c/tvp7002.c
@@ -889,7 +889,7 @@ static const struct v4l2_subdev_ops tvp7002_ops = {
 static struct tvp7002_config *
 tvp7002_get_pdata(struct i2c_client *client)
 {
-	struct v4l2_fwnode_endpoint bus_cfg;
+	struct v4l2_fwnode_endpoint bus_cfg = { .bus_type = 0 };
 	struct tvp7002_config *pdata = NULL;
 	struct device_node *endpoint;
 	unsigned int flags;
diff --git a/drivers/media/platform/am437x/am437x-vpfe.c b/drivers/media/platform/am437x/am437x-vpfe.c
index 0b1a03b64b19..e13d2b3a7168 100644
--- a/drivers/media/platform/am437x/am437x-vpfe.c
+++ b/drivers/media/platform/am437x/am437x-vpfe.c
@@ -2426,7 +2426,6 @@ static struct vpfe_config *
 vpfe_get_pdata(struct vpfe_device *vpfe)
 {
 	struct device_node *endpoint = NULL;
-	struct v4l2_fwnode_endpoint bus_cfg;
 	struct device *dev = vpfe->pdev;
 	struct vpfe_subdev_info *sdinfo;
 	struct vpfe_config *pdata;
@@ -2446,6 +2445,7 @@ vpfe_get_pdata(struct vpfe_device *vpfe)
 		return NULL;
 
 	for (i = 0; ; i++) {
+		struct v4l2_fwnode_endpoint bus_cfg = { .bus_type = 0 };
 		struct device_node *rem;
 
 		endpoint = of_graph_get_next_endpoint(dev->of_node, endpoint);
diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platform/atmel/atmel-isc.c
index 334de0f2e36a..50178968b8a6 100644
--- a/drivers/media/platform/atmel/atmel-isc.c
+++ b/drivers/media/platform/atmel/atmel-isc.c
@@ -2028,7 +2028,6 @@ static int isc_parse_dt(struct device *dev, struct isc_device *isc)
 {
 	struct device_node *np = dev->of_node;
 	struct device_node *epn = NULL, *rem;
-	struct v4l2_fwnode_endpoint v4l2_epn;
 	struct isc_subdev_entity *subdev_entity;
 	unsigned int flags;
 	int ret;
@@ -2036,6 +2035,8 @@ static int isc_parse_dt(struct device *dev, struct isc_device *isc)
 	INIT_LIST_HEAD(&isc->subdev_entities);
 
 	while (1) {
+		struct v4l2_fwnode_endpoint v4l2_epn = { .bus_type = 0 };
+
 		epn = of_graph_get_next_endpoint(np, epn);
 		if (!epn)
 			return 0;
diff --git a/drivers/media/platform/atmel/atmel-isi.c b/drivers/media/platform/atmel/atmel-isi.c
index c4d5f05786e8..fdb255e4a956 100644
--- a/drivers/media/platform/atmel/atmel-isi.c
+++ b/drivers/media/platform/atmel/atmel-isi.c
@@ -790,7 +790,7 @@ static int atmel_isi_parse_dt(struct atmel_isi *isi,
 			struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
-	struct v4l2_fwnode_endpoint ep;
+	struct v4l2_fwnode_endpoint ep = { .bus_type = 0 };
 	int err;
 
 	/* Default settings for ISI */
diff --git a/drivers/media/platform/cadence/cdns-csi2rx.c b/drivers/media/platform/cadence/cdns-csi2rx.c
index 0776a34f28ee..31ace114eda1 100644
--- a/drivers/media/platform/cadence/cdns-csi2rx.c
+++ b/drivers/media/platform/cadence/cdns-csi2rx.c
@@ -361,7 +361,7 @@ static int csi2rx_get_resources(struct csi2rx_priv *csi2rx,
 
 static int csi2rx_parse_dt(struct csi2rx_priv *csi2rx)
 {
-	struct v4l2_fwnode_endpoint v4l2_ep;
+	struct v4l2_fwnode_endpoint v4l2_ep = { .bus_type = 0 };
 	struct fwnode_handle *fwh;
 	struct device_node *ep;
 	int ret;
diff --git a/drivers/media/platform/cadence/cdns-csi2tx.c b/drivers/media/platform/cadence/cdns-csi2tx.c
index 6224daf891d7..5042d053b94e 100644
--- a/drivers/media/platform/cadence/cdns-csi2tx.c
+++ b/drivers/media/platform/cadence/cdns-csi2tx.c
@@ -432,7 +432,7 @@ static int csi2tx_get_resources(struct csi2tx_priv *csi2tx,
 
 static int csi2tx_check_lanes(struct csi2tx_priv *csi2tx)
 {
-	struct v4l2_fwnode_endpoint v4l2_ep;
+	struct v4l2_fwnode_endpoint v4l2_ep = { .bus_type = 0 };
 	struct device_node *ep;
 	int ret;
 
diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index 23e237a5ea1a..69fec88031fd 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -1511,7 +1511,6 @@ static struct vpif_capture_config *
 vpif_capture_get_pdata(struct platform_device *pdev)
 {
 	struct device_node *endpoint = NULL;
-	struct v4l2_fwnode_endpoint bus_cfg;
 	struct vpif_capture_config *pdata;
 	struct vpif_subdev_info *sdinfo;
 	struct vpif_capture_chan_config *chan;
@@ -1541,6 +1540,7 @@ vpif_capture_get_pdata(struct platform_device *pdev)
 		return NULL;
 
 	for (i = 0; i < VPIF_CAPTURE_NUM_CHANNELS; i++) {
+		struct v4l2_fwnode_endpoint bus_cfg = { .bus_type = 0 };
 		struct device_node *rem;
 		unsigned int flags;
 		int err;
diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index fbad0635c6b5..870501b0f351 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -390,7 +390,7 @@ static int fimc_md_parse_port_node(struct fimc_md *fmd,
 {
 	struct fimc_source_info *pd = &fmd->sensor[index].pdata;
 	struct device_node *rem, *ep, *np;
-	struct v4l2_fwnode_endpoint endpoint;
+	struct v4l2_fwnode_endpoint endpoint = { .bus_type = 0 };
 	int ret;
 
 	/* Assume here a port node can have only one endpoint node. */
diff --git a/drivers/media/platform/exynos4-is/mipi-csis.c b/drivers/media/platform/exynos4-is/mipi-csis.c
index b4e28a299e26..35cb0162085b 100644
--- a/drivers/media/platform/exynos4-is/mipi-csis.c
+++ b/drivers/media/platform/exynos4-is/mipi-csis.c
@@ -718,7 +718,7 @@ static int s5pcsis_parse_dt(struct platform_device *pdev,
 			    struct csis_state *state)
 {
 	struct device_node *node = pdev->dev.of_node;
-	struct v4l2_fwnode_endpoint endpoint;
+	struct v4l2_fwnode_endpoint endpoint = { .bus_type = 0 };
 	int ret;
 
 	if (of_property_read_u32(node, "clock-frequency",
diff --git a/drivers/media/platform/pxa_camera.c b/drivers/media/platform/pxa_camera.c
index a47be1242cf4..d16ca667ec44 100644
--- a/drivers/media/platform/pxa_camera.c
+++ b/drivers/media/platform/pxa_camera.c
@@ -2298,7 +2298,7 @@ static int pxa_camera_pdata_from_dt(struct device *dev,
 {
 	u32 mclk_rate;
 	struct device_node *remote, *np = dev->of_node;
-	struct v4l2_fwnode_endpoint ep;
+	struct v4l2_fwnode_endpoint ep = { .bus_type = 0 };
 	int err = of_property_read_u32(np, "clock-frequency",
 				       &mclk_rate);
 	if (!err) {
diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
index 25edc2edd197..b0044a08e71e 100644
--- a/drivers/media/platform/rcar-vin/rcar-csi2.c
+++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
@@ -743,7 +743,7 @@ static int rcsi2_parse_v4l2(struct rcar_csi2 *priv,
 static int rcsi2_parse_dt(struct rcar_csi2 *priv)
 {
 	struct device_node *ep;
-	struct v4l2_fwnode_endpoint v4l2_ep;
+	struct v4l2_fwnode_endpoint v4l2_ep = { .bus_type = 0 };
 	int ret;
 
 	ep = of_graph_get_endpoint_by_regs(priv->dev->of_node, 0, 0);
diff --git a/drivers/media/platform/renesas-ceu.c b/drivers/media/platform/renesas-ceu.c
index eee4ae7234be..035f1d3f10e5 100644
--- a/drivers/media/platform/renesas-ceu.c
+++ b/drivers/media/platform/renesas-ceu.c
@@ -1536,7 +1536,6 @@ static int ceu_parse_platform_data(struct ceu_device *ceudev,
 static int ceu_parse_dt(struct ceu_device *ceudev)
 {
 	struct device_node *of = ceudev->dev->of_node;
-	struct v4l2_fwnode_endpoint fw_ep;
 	struct device_node *ep, *remote;
 	struct ceu_subdev *ceu_sd;
 	unsigned int i;
@@ -1552,6 +1551,8 @@ static int ceu_parse_dt(struct ceu_device *ceudev)
 		return ret;
 
 	for (i = 0; i < num_ep; i++) {
+		struct v4l2_fwnode_endpoint fw_ep = { .bus_type = 0 };
+
 		ep = of_graph_get_endpoint_by_regs(of, 0, i);
 		if (!ep) {
 			dev_err(ceudev->dev,
diff --git a/drivers/media/platform/stm32/stm32-dcmi.c b/drivers/media/platform/stm32/stm32-dcmi.c
index da296a2afc2e..07d154024183 100644
--- a/drivers/media/platform/stm32/stm32-dcmi.c
+++ b/drivers/media/platform/stm32/stm32-dcmi.c
@@ -1621,7 +1621,7 @@ static int dcmi_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
 	const struct of_device_id *match = NULL;
-	struct v4l2_fwnode_endpoint ep;
+	struct v4l2_fwnode_endpoint ep = { .bus_type = 0 };
 	struct stm32_dcmi *dcmi;
 	struct vb2_queue *q;
 	struct dma_chan *chan;
diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index 539159d9af6b..ac9d718d7ff0 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -1050,7 +1050,7 @@ static int csi_link_validate(struct v4l2_subdev *sd,
 			     struct v4l2_subdev_format *sink_fmt)
 {
 	struct csi_priv *priv = v4l2_get_subdevdata(sd);
-	struct v4l2_fwnode_endpoint upstream_ep = {};
+	struct v4l2_fwnode_endpoint upstream_ep = { .bus_type = 0 };
 	bool is_csi2;
 	int ret;
 
@@ -1164,7 +1164,7 @@ static int csi_enum_mbus_code(struct v4l2_subdev *sd,
 			      struct v4l2_subdev_mbus_code_enum *code)
 {
 	struct csi_priv *priv = v4l2_get_subdevdata(sd);
-	struct v4l2_fwnode_endpoint upstream_ep;
+	struct v4l2_fwnode_endpoint upstream_ep = { .bus_type = 0 };
 	const struct imx_media_pixfmt *incc;
 	struct v4l2_mbus_framefmt *infmt;
 	int ret = 0;
@@ -1403,7 +1403,7 @@ static int csi_set_fmt(struct v4l2_subdev *sd,
 {
 	struct csi_priv *priv = v4l2_get_subdevdata(sd);
 	struct imx_media_video_dev *vdev = priv->vdev;
-	struct v4l2_fwnode_endpoint upstream_ep;
+	struct v4l2_fwnode_endpoint upstream_ep = { .bus_type = 0 };
 	const struct imx_media_pixfmt *cc;
 	struct v4l2_pix_format vdev_fmt;
 	struct v4l2_mbus_framefmt *fmt;
@@ -1542,7 +1542,7 @@ static int csi_set_selection(struct v4l2_subdev *sd,
 			     struct v4l2_subdev_selection *sel)
 {
 	struct csi_priv *priv = v4l2_get_subdevdata(sd);
-	struct v4l2_fwnode_endpoint upstream_ep;
+	struct v4l2_fwnode_endpoint upstream_ep = { .bus_type = 0 };
 	struct v4l2_mbus_framefmt *infmt;
 	struct v4l2_rect *crop, *compose;
 	int pad, ret;
diff --git a/include/media/v4l2-fwnode.h b/include/media/v4l2-fwnode.h
index 4a371c3ad86c..1ea1a3ecf6d5 100644
--- a/include/media/v4l2-fwnode.h
+++ b/include/media/v4l2-fwnode.h
@@ -139,6 +139,8 @@ struct v4l2_fwnode_link {
  * set the V4L2_MBUS_CSI2_CONTINUOUS_CLOCK flag. The caller should hold a
  * reference to @fwnode.
  *
+ * The caller must set the bus_type field of @vep to zero.
+ *
  * NOTE: This function does not parse properties the size of which is variable
  * without a low fixed limit. Please use v4l2_fwnode_endpoint_alloc_parse() in
  * new drivers instead.
-- 
2.11.0
