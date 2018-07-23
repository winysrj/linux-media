Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56340 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388132AbeGWOsa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Jul 2018 10:48:30 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, slongerbeam@gmail.com,
        niklas.soderlund@ragnatech.se
Subject: [PATCH 07/21] v4l: mediabus: Recognise CSI-2 D-PHY and C-PHY
Date: Mon, 23 Jul 2018 16:46:52 +0300
Message-Id: <20180723134706.15334-8-sakari.ailus@linux.intel.com>
In-Reply-To: <20180723134706.15334-1-sakari.ailus@linux.intel.com>
References: <20180723134706.15334-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The CSI-2 bus may use either D-PHY or C-PHY. Make this visible in media
bus enum.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/gpu/ipu-v3/ipu-csi.c                     | 2 +-
 drivers/media/i2c/adv7180.c                      | 2 +-
 drivers/media/i2c/ov5640.c                       | 4 ++--
 drivers/media/i2c/ov5645.c                       | 2 +-
 drivers/media/i2c/ov7251.c                       | 4 ++--
 drivers/media/i2c/s5c73m3/s5c73m3-core.c         | 2 +-
 drivers/media/i2c/s5k5baf.c                      | 4 ++--
 drivers/media/i2c/s5k6aa.c                       | 2 +-
 drivers/media/i2c/smiapp/smiapp-core.c           | 2 +-
 drivers/media/i2c/soc_camera/ov5642.c            | 2 +-
 drivers/media/i2c/tc358743.c                     | 4 ++--
 drivers/media/pci/intel/ipu3/ipu3-cio2.c         | 2 +-
 drivers/media/platform/cadence/cdns-csi2rx.c     | 2 +-
 drivers/media/platform/cadence/cdns-csi2tx.c     | 2 +-
 drivers/media/platform/marvell-ccic/mcam-core.c  | 4 ++--
 drivers/media/platform/marvell-ccic/mmp-driver.c | 2 +-
 drivers/media/platform/omap3isp/isp.c            | 2 +-
 drivers/media/platform/pxa_camera.c              | 2 +-
 drivers/media/platform/rcar-vin/rcar-csi2.c      | 2 +-
 drivers/media/platform/soc_camera/soc_mediabus.c | 2 +-
 drivers/media/platform/stm32/stm32-dcmi.c        | 2 +-
 drivers/media/platform/ti-vpe/cal.c              | 2 +-
 drivers/media/v4l2-core/v4l2-fwnode.c            | 2 +-
 drivers/staging/media/imx/imx-media-csi.c        | 2 +-
 drivers/staging/media/imx/imx6-mipi-csi2.c       | 2 +-
 drivers/staging/media/imx074/imx074.c            | 2 +-
 include/media/v4l2-mediabus.h                    | 6 ++++--
 27 files changed, 35 insertions(+), 33 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-csi.c b/drivers/gpu/ipu-v3/ipu-csi.c
index caa05b0702e1..4bc12d7b0b49 100644
--- a/drivers/gpu/ipu-v3/ipu-csi.c
+++ b/drivers/gpu/ipu-v3/ipu-csi.c
@@ -344,7 +344,7 @@ static void fill_csi_bus_cfg(struct ipu_csi_bus_config *csicfg,
 		else
 			csicfg->clk_mode = IPU_CSI_CLK_MODE_CCIR656_PROGRESSIVE;
 		break;
-	case V4L2_MBUS_CSI2:
+	case V4L2_MBUS_CSI2_DPHY:
 		/*
 		 * MIPI CSI-2 requires non gated clock mode, all other
 		 * parameters are not applicable for MIPI CSI-2 bus.
diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index 25d24a3f10a7..8241eb0c095d 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -742,7 +742,7 @@ static int adv7180_g_mbus_config(struct v4l2_subdev *sd,
 	struct adv7180_state *state = to_state(sd);
 
 	if (state->chip_info->flags & ADV7180_FLAG_MIPI_CSI2) {
-		cfg->type = V4L2_MBUS_CSI2;
+		cfg->type = V4L2_MBUS_CSI2_DPHY;
 		cfg->flags = V4L2_MBUS_CSI2_1_LANE |
 				V4L2_MBUS_CSI2_CHANNEL_0 |
 				V4L2_MBUS_CSI2_CONTINUOUS_CLOCK;
diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 071f4bc240ca..942531aaae92 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -1786,7 +1786,7 @@ static int ov5640_set_power(struct ov5640_dev *sensor, bool on)
 		if (ret)
 			goto power_off;
 
-		if (sensor->ep.bus_type == V4L2_MBUS_CSI2) {
+		if (sensor->ep.bus_type == V4L2_MBUS_CSI2_DPHY) {
 			/*
 			 * start streaming briefly followed by stream off in
 			 * order to coax the clock lane into LP-11 state.
@@ -2550,7 +2550,7 @@ static int ov5640_s_stream(struct v4l2_subdev *sd, int enable)
 				goto out;
 		}
 
-		if (sensor->ep.bus_type == V4L2_MBUS_CSI2)
+		if (sensor->ep.bus_type == V4L2_MBUS_CSI2_DPHY)
 			ret = ov5640_set_stream_mipi(sensor, enable);
 		else
 			ret = ov5640_set_stream_dvp(sensor, enable);
diff --git a/drivers/media/i2c/ov5645.c b/drivers/media/i2c/ov5645.c
index 1722cdab0daf..5eba8dd7222b 100644
--- a/drivers/media/i2c/ov5645.c
+++ b/drivers/media/i2c/ov5645.c
@@ -1127,7 +1127,7 @@ static int ov5645_probe(struct i2c_client *client,
 		return ret;
 	}
 
-	if (ov5645->ep.bus_type != V4L2_MBUS_CSI2) {
+	if (ov5645->ep.bus_type != V4L2_MBUS_CSI2_DPHY) {
 		dev_err(dev, "invalid bus type, must be CSI2\n");
 		return -EINVAL;
 	}
diff --git a/drivers/media/i2c/ov7251.c b/drivers/media/i2c/ov7251.c
index d3ebb7529fca..0c10203f822b 100644
--- a/drivers/media/i2c/ov7251.c
+++ b/drivers/media/i2c/ov7251.c
@@ -1279,9 +1279,9 @@ static int ov7251_probe(struct i2c_client *client)
 		return ret;
 	}
 
-	if (ov7251->ep.bus_type != V4L2_MBUS_CSI2) {
+	if (ov7251->ep.bus_type != V4L2_MBUS_CSI2_DPHY) {
 		dev_err(dev, "invalid bus type (%u), must be CSI2 (%u)\n",
-			ov7251->ep.bus_type, V4L2_MBUS_CSI2);
+			ov7251->ep.bus_type, V4L2_MBUS_CSI2_DPHY);
 		return -EINVAL;
 	}
 
diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-core.c b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
index ce196b60f917..9d5739cafec3 100644
--- a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
+++ b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
@@ -1644,7 +1644,7 @@ static int s5c73m3_get_platform_data(struct s5c73m3 *state)
 	if (ret)
 		return ret;
 
-	if (ep.bus_type != V4L2_MBUS_CSI2) {
+	if (ep.bus_type != V4L2_MBUS_CSI2_DPHY) {
 		dev_err(dev, "unsupported bus type\n");
 		return -EINVAL;
 	}
diff --git a/drivers/media/i2c/s5k5baf.c b/drivers/media/i2c/s5k5baf.c
index 5007c9659342..4c41a770b132 100644
--- a/drivers/media/i2c/s5k5baf.c
+++ b/drivers/media/i2c/s5k5baf.c
@@ -766,7 +766,7 @@ static int s5k5baf_hw_set_video_bus(struct s5k5baf *state)
 {
 	u16 en_pkts;
 
-	if (state->bus_type == V4L2_MBUS_CSI2)
+	if (state->bus_type == V4L2_MBUS_CSI2_DPHY)
 		en_pkts = EN_PACKETS_CSI2;
 	else
 		en_pkts = 0;
@@ -1875,7 +1875,7 @@ static int s5k5baf_parse_device_node(struct s5k5baf *state, struct device *dev)
 	state->bus_type = ep.bus_type;
 
 	switch (state->bus_type) {
-	case V4L2_MBUS_CSI2:
+	case V4L2_MBUS_CSI2_DPHY:
 		state->nlanes = ep.bus.mipi_csi2.num_data_lanes;
 		break;
 	case V4L2_MBUS_PARALLEL:
diff --git a/drivers/media/i2c/s5k6aa.c b/drivers/media/i2c/s5k6aa.c
index 13c10b5e2b45..5f097ae7a5b1 100644
--- a/drivers/media/i2c/s5k6aa.c
+++ b/drivers/media/i2c/s5k6aa.c
@@ -688,7 +688,7 @@ static int s5k6aa_configure_video_bus(struct s5k6aa *s5k6aa,
 	 * but there is nothing indicating how to switch between both
 	 * in the datasheet. For now default BT.601 interface is assumed.
 	 */
-	if (bus_type == V4L2_MBUS_CSI2)
+	if (bus_type == V4L2_MBUS_CSI2_DPHY)
 		cfg = nlanes;
 	else if (bus_type != V4L2_MBUS_PARALLEL)
 		return -EINVAL;
diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 1236683da8f7..9e33c2008ba6 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2784,7 +2784,7 @@ static struct smiapp_hwconfig *smiapp_get_hwconfig(struct device *dev)
 		goto out_err;
 
 	switch (bus_cfg->bus_type) {
-	case V4L2_MBUS_CSI2:
+	case V4L2_MBUS_CSI2_DPHY:
 		hwcfg->csi_signalling_mode = SMIAPP_CSI_SIGNALLING_MODE_CSI2;
 		hwcfg->lanes = bus_cfg->bus.mipi_csi2.num_data_lanes;
 		break;
diff --git a/drivers/media/i2c/soc_camera/ov5642.c b/drivers/media/i2c/soc_camera/ov5642.c
index 39f420db9c70..bc045259510d 100644
--- a/drivers/media/i2c/soc_camera/ov5642.c
+++ b/drivers/media/i2c/soc_camera/ov5642.c
@@ -913,7 +913,7 @@ static int ov5642_get_selection(struct v4l2_subdev *sd,
 static int ov5642_g_mbus_config(struct v4l2_subdev *sd,
 				struct v4l2_mbus_config *cfg)
 {
-	cfg->type = V4L2_MBUS_CSI2;
+	cfg->type = V4L2_MBUS_CSI2_DPHY;
 	cfg->flags = V4L2_MBUS_CSI2_2_LANE | V4L2_MBUS_CSI2_CHANNEL_0 |
 					V4L2_MBUS_CSI2_CONTINUOUS_CLOCK;
 
diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index 44c41933415a..6a2064597124 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -1607,7 +1607,7 @@ static int tc358743_g_mbus_config(struct v4l2_subdev *sd,
 {
 	struct tc358743_state *state = to_state(sd);
 
-	cfg->type = V4L2_MBUS_CSI2;
+	cfg->type = V4L2_MBUS_CSI2_DPHY;
 
 	/* Support for non-continuous CSI-2 clock is missing in the driver */
 	cfg->flags = V4L2_MBUS_CSI2_CONTINUOUS_CLOCK;
@@ -1922,7 +1922,7 @@ static int tc358743_probe_of(struct tc358743_state *state)
 		goto put_node;
 	}
 
-	if (endpoint->bus_type != V4L2_MBUS_CSI2 ||
+	if (endpoint->bus_type != V4L2_MBUS_CSI2_DPHY ||
 	    endpoint->bus.mipi_csi2.num_data_lanes == 0 ||
 	    endpoint->nr_of_link_frequencies == 0) {
 		dev_err(dev, "missing CSI-2 properties in endpoint\n");
diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.c b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
index 4a5f7c3360bc..f2e1942d2979 100644
--- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
+++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
@@ -1484,7 +1484,7 @@ static int cio2_fwnode_parse(struct device *dev,
 	struct sensor_async_subdev *s_asd =
 			container_of(asd, struct sensor_async_subdev, asd);
 
-	if (vep->bus_type != V4L2_MBUS_CSI2) {
+	if (vep->bus_type != V4L2_MBUS_CSI2_DPHY) {
 		dev_err(dev, "Only CSI2 bus type is currently supported\n");
 		return -EINVAL;
 	}
diff --git a/drivers/media/platform/cadence/cdns-csi2rx.c b/drivers/media/platform/cadence/cdns-csi2rx.c
index 43e43c7b3e98..0a1fcb76cf34 100644
--- a/drivers/media/platform/cadence/cdns-csi2rx.c
+++ b/drivers/media/platform/cadence/cdns-csi2rx.c
@@ -378,7 +378,7 @@ static int csi2rx_parse_dt(struct csi2rx_priv *csi2rx)
 		return ret;
 	}
 
-	if (v4l2_ep.bus_type != V4L2_MBUS_CSI2) {
+	if (v4l2_ep.bus_type != V4L2_MBUS_CSI2_DPHY) {
 		dev_err(csi2rx->dev, "Unsupported media bus type: 0x%x\n",
 			v4l2_ep.bus_type);
 		of_node_put(ep);
diff --git a/drivers/media/platform/cadence/cdns-csi2tx.c b/drivers/media/platform/cadence/cdns-csi2tx.c
index 40d0de690ff4..6224daf891d7 100644
--- a/drivers/media/platform/cadence/cdns-csi2tx.c
+++ b/drivers/media/platform/cadence/cdns-csi2tx.c
@@ -446,7 +446,7 @@ static int csi2tx_check_lanes(struct csi2tx_priv *csi2tx)
 		goto out;
 	}
 
-	if (v4l2_ep.bus_type != V4L2_MBUS_CSI2) {
+	if (v4l2_ep.bus_type != V4L2_MBUS_CSI2_DPHY) {
 		dev_err(csi2tx->dev, "Unsupported media bus type: 0x%x\n",
 			v4l2_ep.bus_type);
 		ret = -EINVAL;
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index dfdbd4354b74..5e20427aeca2 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -794,7 +794,7 @@ static void mcam_ctlr_image(struct mcam_camera *cam)
 	/*
 	 * This field controls the generation of EOF(DVP only)
 	 */
-	if (cam->bus_type != V4L2_MBUS_CSI2)
+	if (cam->bus_type != V4L2_MBUS_CSI2_DPHY)
 		mcam_reg_set_bit(cam, REG_CTRL0,
 				C0_EOF_VSYNC | C0_VEDGE_CTRL);
 }
@@ -1023,7 +1023,7 @@ static int mcam_read_setup(struct mcam_camera *cam)
 		cam->calc_dphy(cam);
 	cam_dbg(cam, "camera: DPHY sets: dphy3=0x%x, dphy5=0x%x, dphy6=0x%x\n",
 			cam->dphy[0], cam->dphy[1], cam->dphy[2]);
-	if (cam->bus_type == V4L2_MBUS_CSI2)
+	if (cam->bus_type == V4L2_MBUS_CSI2_DPHY)
 		mcam_enable_mipi(cam);
 	else
 		mcam_disable_mipi(cam);
diff --git a/drivers/media/platform/marvell-ccic/mmp-driver.c b/drivers/media/platform/marvell-ccic/mmp-driver.c
index 6d9f0abb2660..25ce31b71a45 100644
--- a/drivers/media/platform/marvell-ccic/mmp-driver.c
+++ b/drivers/media/platform/marvell-ccic/mmp-driver.c
@@ -362,7 +362,7 @@ static int mmpcam_probe(struct platform_device *pdev)
 	mcam->mclk_div = pdata->mclk_div;
 	mcam->bus_type = pdata->bus_type;
 	mcam->dphy = pdata->dphy;
-	if (mcam->bus_type == V4L2_MBUS_CSI2) {
+	if (mcam->bus_type == V4L2_MBUS_CSI2_DPHY) {
 		cam->mipi_clk = devm_clk_get(mcam->dev, "mipi");
 		if ((IS_ERR(cam->mipi_clk) && mcam->dphy[2] == 0))
 			return PTR_ERR(cam->mipi_clk);
diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 1211bfe9cda1..a7fde7fc00b2 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2054,7 +2054,7 @@ static int isp_fwnode_parse(struct device *dev,
 			dev_dbg(dev, "CSI-1/CCP-2 configuration\n");
 			csi1 = true;
 			break;
-		case V4L2_MBUS_CSI2:
+		case V4L2_MBUS_CSI2_DPHY:
 			dev_dbg(dev, "CSI-2 configuration\n");
 			csi1 = false;
 			break;
diff --git a/drivers/media/platform/pxa_camera.c b/drivers/media/platform/pxa_camera.c
index d85ffbfb7c1f..bbb7a77eeb78 100644
--- a/drivers/media/platform/pxa_camera.c
+++ b/drivers/media/platform/pxa_camera.c
@@ -633,7 +633,7 @@ static unsigned int pxa_mbus_config_compatible(const struct v4l2_mbus_config *cf
 		mode = common_flags & (V4L2_MBUS_MASTER | V4L2_MBUS_SLAVE);
 		return (!hsync || !vsync || !pclk || !data || !mode) ?
 			0 : common_flags;
-	case V4L2_MBUS_CSI2:
+	case V4L2_MBUS_CSI2_DPHY:
 		mipi_lanes = common_flags & V4L2_MBUS_CSI2_LANES;
 		mipi_clock = common_flags & (V4L2_MBUS_CSI2_NONCONTINUOUS_CLOCK |
 					     V4L2_MBUS_CSI2_CONTINUOUS_CLOCK);
diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
index daef72d410a3..45aa10d23dc3 100644
--- a/drivers/media/platform/rcar-vin/rcar-csi2.c
+++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
@@ -706,7 +706,7 @@ static int rcsi2_parse_v4l2(struct rcar_csi2 *priv,
 	if (vep->base.port || vep->base.id)
 		return -ENOTCONN;
 
-	if (vep->bus_type != V4L2_MBUS_CSI2) {
+	if (vep->bus_type != V4L2_MBUS_CSI2_DPHY) {
 		dev_err(priv->dev, "Unsupported bus: %u\n", vep->bus_type);
 		return -EINVAL;
 	}
diff --git a/drivers/media/platform/soc_camera/soc_mediabus.c b/drivers/media/platform/soc_camera/soc_mediabus.c
index 0ad4b28266e4..be74008ec0ca 100644
--- a/drivers/media/platform/soc_camera/soc_mediabus.c
+++ b/drivers/media/platform/soc_camera/soc_mediabus.c
@@ -503,7 +503,7 @@ unsigned int soc_mbus_config_compatible(const struct v4l2_mbus_config *cfg,
 		mode = common_flags & (V4L2_MBUS_MASTER | V4L2_MBUS_SLAVE);
 		return (!hsync || !vsync || !pclk || !data || !mode) ?
 			0 : common_flags;
-	case V4L2_MBUS_CSI2:
+	case V4L2_MBUS_CSI2_DPHY:
 		mipi_lanes = common_flags & V4L2_MBUS_CSI2_LANES;
 		mipi_clock = common_flags & (V4L2_MBUS_CSI2_NONCONTINUOUS_CLOCK |
 					     V4L2_MBUS_CSI2_CONTINUOUS_CLOCK);
diff --git a/drivers/media/platform/stm32/stm32-dcmi.c b/drivers/media/platform/stm32/stm32-dcmi.c
index 721564176d8c..56a331392769 100644
--- a/drivers/media/platform/stm32/stm32-dcmi.c
+++ b/drivers/media/platform/stm32/stm32-dcmi.c
@@ -1663,7 +1663,7 @@ static int dcmi_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	if (ep.bus_type == V4L2_MBUS_CSI2) {
+	if (ep.bus_type == V4L2_MBUS_CSI2_DPHY) {
 		dev_err(&pdev->dev, "CSI bus not supported\n");
 		return -ENODEV;
 	}
diff --git a/drivers/media/platform/ti-vpe/cal.c b/drivers/media/platform/ti-vpe/cal.c
index d1febe5baa6d..887af872b0fd 100644
--- a/drivers/media/platform/ti-vpe/cal.c
+++ b/drivers/media/platform/ti-vpe/cal.c
@@ -1711,7 +1711,7 @@ static int of_cal_create_instance(struct cal_ctx *ctx, int inst)
 	}
 	v4l2_fwnode_endpoint_parse(of_fwnode_handle(remote_ep), endpoint);
 
-	if (endpoint->bus_type != V4L2_MBUS_CSI2) {
+	if (endpoint->bus_type != V4L2_MBUS_CSI2_DPHY) {
 		ctx_err(ctx, "Port:%d sub-device %s is not a CSI2 device\n",
 			inst, sensor_node->name);
 		goto cleanup_exit;
diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index 4c98d17ab124..85f409808042 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -117,7 +117,7 @@ static int v4l2_fwnode_endpoint_parse_csi2_bus(struct fwnode_handle *fwnode,
 	if (lanes_used || have_clk_lane ||
 	    (flags & ~V4L2_MBUS_CSI2_CONTINUOUS_CLOCK)) {
 		bus->flags = flags;
-		vep->bus_type = V4L2_MBUS_CSI2;
+		vep->bus_type = V4L2_MBUS_CSI2_DPHY;
 	}
 
 	return 0;
diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index 19ef3771b7b1..7f5932618ab1 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -124,7 +124,7 @@ static inline struct csi_priv *sd_to_dev(struct v4l2_subdev *sdev)
 
 static inline bool is_parallel_bus(struct v4l2_fwnode_endpoint *ep)
 {
-	return ep->bus_type != V4L2_MBUS_CSI2;
+	return ep->bus_type != V4L2_MBUS_CSI2_DPHY;
 }
 
 static inline bool is_parallel_16bit_bus(struct v4l2_fwnode_endpoint *ep)
diff --git a/drivers/staging/media/imx/imx6-mipi-csi2.c b/drivers/staging/media/imx/imx6-mipi-csi2.c
index 94eb9a1f38bb..74438a4c1267 100644
--- a/drivers/staging/media/imx/imx6-mipi-csi2.c
+++ b/drivers/staging/media/imx/imx6-mipi-csi2.c
@@ -563,7 +563,7 @@ static int csi2_parse_endpoint(struct device *dev,
 		return -EINVAL;
 	}
 
-	if (vep->bus_type != V4L2_MBUS_CSI2) {
+	if (vep->bus_type != V4L2_MBUS_CSI2_DPHY) {
 		v4l2_err(&csi2->sd, "invalid bus type, must be MIPI CSI2\n");
 		return -EINVAL;
 	}
diff --git a/drivers/staging/media/imx074/imx074.c b/drivers/staging/media/imx074/imx074.c
index 77f1e0243d6e..0eee9f0def4d 100644
--- a/drivers/staging/media/imx074/imx074.c
+++ b/drivers/staging/media/imx074/imx074.c
@@ -263,7 +263,7 @@ static int imx074_s_power(struct v4l2_subdev *sd, int on)
 static int imx074_g_mbus_config(struct v4l2_subdev *sd,
 				struct v4l2_mbus_config *cfg)
 {
-	cfg->type = V4L2_MBUS_CSI2;
+	cfg->type = V4L2_MBUS_CSI2_DPHY;
 	cfg->flags = V4L2_MBUS_CSI2_2_LANE |
 		V4L2_MBUS_CSI2_CHANNEL_0 |
 		V4L2_MBUS_CSI2_CONTINUOUS_CLOCK;
diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
index 66d74c813f53..df1d552e9df6 100644
--- a/include/media/v4l2-mediabus.h
+++ b/include/media/v4l2-mediabus.h
@@ -76,7 +76,8 @@
  *			also be used for BT.1120
  * @V4L2_MBUS_CSI1:	MIPI CSI-1 serial interface
  * @V4L2_MBUS_CCP2:	CCP2 (Compact Camera Port 2)
- * @V4L2_MBUS_CSI2:	MIPI CSI-2 serial interface
+ * @V4L2_MBUS_CSI2_DPHY: MIPI CSI-2 serial interface, with D-PHY
+ * @V4L2_MBUS_CSI2_CPHY: MIPI CSI-2 serial interface, with C-PHY
  */
 enum v4l2_mbus_type {
 	V4L2_MBUS_UNKNOWN,
@@ -84,7 +85,8 @@ enum v4l2_mbus_type {
 	V4L2_MBUS_BT656,
 	V4L2_MBUS_CSI1,
 	V4L2_MBUS_CCP2,
-	V4L2_MBUS_CSI2,
+	V4L2_MBUS_CSI2_DPHY,
+	V4L2_MBUS_CSI2_CPHY,
 };
 
 /**
-- 
2.11.0
