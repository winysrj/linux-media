Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56332 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388315AbeGWOsb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Jul 2018 10:48:31 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, slongerbeam@gmail.com,
        niklas.soderlund@ragnatech.se
Subject: [PATCH 15/21] v4l: fwnode: Allow setting default parameters
Date: Mon, 23 Jul 2018 16:47:00 +0300
Message-Id: <20180723134706.15334-16-sakari.ailus@linux.intel.com>
In-Reply-To: <20180723134706.15334-1-sakari.ailus@linux.intel.com>
References: <20180723134706.15334-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of allocating the V4L2 fwnode endpoint in
v4l2_fwnode_endpoint_alloc_parse, let the caller to do this. This allows
setting default parameters for the endpoint which is a very common need
for drivers.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/ov2659.c             | 14 ++++----
 drivers/media/i2c/smiapp/smiapp-core.c | 26 +++++++--------
 drivers/media/i2c/tc358743.c           | 26 ++++++++-------
 drivers/media/v4l2-core/v4l2-fwnode.c  | 59 ++++++++++++++--------------------
 include/media/v4l2-fwnode.h            |  7 ++--
 5 files changed, 65 insertions(+), 67 deletions(-)

diff --git a/drivers/media/i2c/ov2659.c b/drivers/media/i2c/ov2659.c
index 4715edc8ca33..799acce803fe 100644
--- a/drivers/media/i2c/ov2659.c
+++ b/drivers/media/i2c/ov2659.c
@@ -1347,8 +1347,9 @@ static struct ov2659_platform_data *
 ov2659_get_pdata(struct i2c_client *client)
 {
 	struct ov2659_platform_data *pdata;
-	struct v4l2_fwnode_endpoint *bus_cfg;
+	struct v4l2_fwnode_endpoint bus_cfg = { .bus_type = 0 };
 	struct device_node *endpoint;
+	int ret;
 
 	if (!IS_ENABLED(CONFIG_OF) || !client->dev.of_node)
 		return client->dev.platform_data;
@@ -1357,8 +1358,9 @@ ov2659_get_pdata(struct i2c_client *client)
 	if (!endpoint)
 		return NULL;
 
-	bus_cfg = v4l2_fwnode_endpoint_alloc_parse(of_fwnode_handle(endpoint));
-	if (IS_ERR(bus_cfg)) {
+	ret = v4l2_fwnode_endpoint_alloc_parse(of_fwnode_handle(endpoint),
+					       &bus_cfg);
+	if (ret) {
 		pdata = NULL;
 		goto done;
 	}
@@ -1367,17 +1369,17 @@ ov2659_get_pdata(struct i2c_client *client)
 	if (!pdata)
 		goto done;
 
-	if (!bus_cfg->nr_of_link_frequencies) {
+	if (!bus_cfg.nr_of_link_frequencies) {
 		dev_err(&client->dev,
 			"link-frequencies property not found or too many\n");
 		pdata = NULL;
 		goto done;
 	}
 
-	pdata->link_frequency = bus_cfg->link_frequencies[0];
+	pdata->link_frequency = bus_cfg.link_frequencies[0];
 
 done:
-	v4l2_fwnode_endpoint_free(bus_cfg);
+	v4l2_fwnode_endpoint_free(&bus_cfg);
 	of_node_put(endpoint);
 	return pdata;
 }
diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 9e33c2008ba6..048ab6cfaa97 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2761,7 +2761,7 @@ static int __maybe_unused smiapp_resume(struct device *dev)
 static struct smiapp_hwconfig *smiapp_get_hwconfig(struct device *dev)
 {
 	struct smiapp_hwconfig *hwcfg;
-	struct v4l2_fwnode_endpoint *bus_cfg;
+	struct v4l2_fwnode_endpoint bus_cfg = { .bus_type = 0 };
 	struct fwnode_handle *ep;
 	struct fwnode_handle *fwnode = dev_fwnode(dev);
 	u32 rotation;
@@ -2775,27 +2775,27 @@ static struct smiapp_hwconfig *smiapp_get_hwconfig(struct device *dev)
 	if (!ep)
 		return NULL;
 
-	bus_cfg = v4l2_fwnode_endpoint_alloc_parse(ep);
-	if (IS_ERR(bus_cfg))
+	rval = v4l2_fwnode_endpoint_alloc_parse(ep, &bus_cfg);
+	if (rval)
 		goto out_err;
 
 	hwcfg = devm_kzalloc(dev, sizeof(*hwcfg), GFP_KERNEL);
 	if (!hwcfg)
 		goto out_err;
 
-	switch (bus_cfg->bus_type) {
+	switch (bus_cfg.bus_type) {
 	case V4L2_MBUS_CSI2_DPHY:
 		hwcfg->csi_signalling_mode = SMIAPP_CSI_SIGNALLING_MODE_CSI2;
-		hwcfg->lanes = bus_cfg->bus.mipi_csi2.num_data_lanes;
+		hwcfg->lanes = bus_cfg.bus.mipi_csi2.num_data_lanes;
 		break;
 	case V4L2_MBUS_CCP2:
-		hwcfg->csi_signalling_mode = (bus_cfg->bus.mipi_csi1.strobe) ?
+		hwcfg->csi_signalling_mode = (bus_cfg.bus.mipi_csi1.strobe) ?
 		SMIAPP_CSI_SIGNALLING_MODE_CCP2_DATA_STROBE :
 		SMIAPP_CSI_SIGNALLING_MODE_CCP2_DATA_CLOCK;
 		hwcfg->lanes = 1;
 		break;
 	default:
-		dev_err(dev, "unsupported bus %u\n", bus_cfg->bus_type);
+		dev_err(dev, "unsupported bus %u\n", bus_cfg.bus_type);
 		goto out_err;
 	}
 
@@ -2827,28 +2827,28 @@ static struct smiapp_hwconfig *smiapp_get_hwconfig(struct device *dev)
 	dev_dbg(dev, "nvm %d, clk %d, mode %d\n",
 		hwcfg->nvm_size, hwcfg->ext_clk, hwcfg->csi_signalling_mode);
 
-	if (!bus_cfg->nr_of_link_frequencies) {
+	if (!bus_cfg.nr_of_link_frequencies) {
 		dev_warn(dev, "no link frequencies defined\n");
 		goto out_err;
 	}
 
 	hwcfg->op_sys_clock = devm_kcalloc(
-		dev, bus_cfg->nr_of_link_frequencies + 1 /* guardian */,
+		dev, bus_cfg.nr_of_link_frequencies + 1 /* guardian */,
 		sizeof(*hwcfg->op_sys_clock), GFP_KERNEL);
 	if (!hwcfg->op_sys_clock)
 		goto out_err;
 
-	for (i = 0; i < bus_cfg->nr_of_link_frequencies; i++) {
-		hwcfg->op_sys_clock[i] = bus_cfg->link_frequencies[i];
+	for (i = 0; i < bus_cfg.nr_of_link_frequencies; i++) {
+		hwcfg->op_sys_clock[i] = bus_cfg.link_frequencies[i];
 		dev_dbg(dev, "freq %d: %lld\n", i, hwcfg->op_sys_clock[i]);
 	}
 
-	v4l2_fwnode_endpoint_free(bus_cfg);
+	v4l2_fwnode_endpoint_free(&bus_cfg);
 	fwnode_handle_put(ep);
 	return hwcfg;
 
 out_err:
-	v4l2_fwnode_endpoint_free(bus_cfg);
+	v4l2_fwnode_endpoint_free(&bus_cfg);
 	fwnode_handle_put(ep);
 	return NULL;
 }
diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index 6a2064597124..8402d540eb8c 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -1895,11 +1895,11 @@ static void tc358743_gpio_reset(struct tc358743_state *state)
 static int tc358743_probe_of(struct tc358743_state *state)
 {
 	struct device *dev = &state->i2c_client->dev;
-	struct v4l2_fwnode_endpoint *endpoint;
+	struct v4l2_fwnode_endpoint endpoint = { .bus_type = 0 };
 	struct device_node *ep;
 	struct clk *refclk;
 	u32 bps_pr_lane;
-	int ret = -EINVAL;
+	int ret;
 
 	refclk = devm_clk_get(dev, "refclk");
 	if (IS_ERR(refclk)) {
@@ -1915,26 +1915,28 @@ static int tc358743_probe_of(struct tc358743_state *state)
 		return -EINVAL;
 	}
 
-	endpoint = v4l2_fwnode_endpoint_alloc_parse(of_fwnode_handle(ep));
-	if (IS_ERR(endpoint)) {
+	ret = v4l2_fwnode_endpoint_alloc_parse(of_fwnode_handle(ep), &endpoint);
+	if (ret) {
 		dev_err(dev, "failed to parse endpoint\n");
-		ret = PTR_ERR(endpoint);
+		ret = ret;
 		goto put_node;
 	}
 
-	if (endpoint->bus_type != V4L2_MBUS_CSI2_DPHY ||
-	    endpoint->bus.mipi_csi2.num_data_lanes == 0 ||
-	    endpoint->nr_of_link_frequencies == 0) {
+	if (endpoint.bus_type != V4L2_MBUS_CSI2_DPHY ||
+	    endpoint.bus.mipi_csi2.num_data_lanes == 0 ||
+	    endpoint.nr_of_link_frequencies == 0) {
 		dev_err(dev, "missing CSI-2 properties in endpoint\n");
+		ret = -EINVAL;
 		goto free_endpoint;
 	}
 
-	if (endpoint->bus.mipi_csi2.num_data_lanes > 4) {
+	if (endpoint.bus.mipi_csi2.num_data_lanes > 4) {
 		dev_err(dev, "invalid number of lanes\n");
+		ret = -EINVAL;
 		goto free_endpoint;
 	}
 
-	state->bus = endpoint->bus.mipi_csi2;
+	state->bus = endpoint.bus.mipi_csi2;
 
 	ret = clk_prepare_enable(refclk);
 	if (ret) {
@@ -1967,7 +1969,7 @@ static int tc358743_probe_of(struct tc358743_state *state)
 	 * The CSI bps per lane must be between 62.5 Mbps and 1 Gbps.
 	 * The default is 594 Mbps for 4-lane 1080p60 or 2-lane 720p60.
 	 */
-	bps_pr_lane = 2 * endpoint->link_frequencies[0];
+	bps_pr_lane = 2 * endpoint.link_frequencies[0];
 	if (bps_pr_lane < 62500000U || bps_pr_lane > 1000000000U) {
 		dev_err(dev, "unsupported bps per lane: %u bps\n", bps_pr_lane);
 		goto disable_clk;
@@ -2013,7 +2015,7 @@ static int tc358743_probe_of(struct tc358743_state *state)
 disable_clk:
 	clk_disable_unprepare(refclk);
 free_endpoint:
-	v4l2_fwnode_endpoint_free(endpoint);
+	v4l2_fwnode_endpoint_free(&endpoint);
 put_node:
 	of_node_put(ep);
 	return ret;
diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index 539f7ca940fd..d9d4e84c45be 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -325,6 +325,12 @@ static int __v4l2_fwnode_endpoint_parse(struct fwnode_handle *fwnode,
 	u32 bus_type = 0;
 	int rval;
 
+	if (vep->bus_type == V4L2_MBUS_UNKNOWN) {
+		/* Zero fields from bus union to until the end */
+		memset(&vep->bus, 0,
+		       sizeof(*vep) - offsetof(typeof(*vep), bus));
+	}
+
 	pr_debug("===== begin V4L2 endpoint properties\n");
 
 	/*
@@ -333,10 +339,6 @@ static int __v4l2_fwnode_endpoint_parse(struct fwnode_handle *fwnode,
 	 */
 	memset(&vep->base, 0, sizeof(vep->base));
 
-	/* Zero fields from bus_type to until the end */
-	memset(&vep->bus_type, 0, sizeof(*vep) -
-	       offsetof(typeof(*vep), bus_type));
-
 	fwnode_property_read_u32(fwnode, "bus-type", &bus_type);
 
 	switch (bus_type) {
@@ -402,23 +404,17 @@ void v4l2_fwnode_endpoint_free(struct v4l2_fwnode_endpoint *vep)
 		return;
 
 	kfree(vep->link_frequencies);
-	kfree(vep);
 }
 EXPORT_SYMBOL_GPL(v4l2_fwnode_endpoint_free);
 
-struct v4l2_fwnode_endpoint *v4l2_fwnode_endpoint_alloc_parse(
-	struct fwnode_handle *fwnode)
+int v4l2_fwnode_endpoint_alloc_parse(
+	struct fwnode_handle *fwnode, struct v4l2_fwnode_endpoint *vep)
 {
-	struct v4l2_fwnode_endpoint *vep;
 	int rval;
 
-	vep = kzalloc(sizeof(*vep), GFP_KERNEL);
-	if (!vep)
-		return ERR_PTR(-ENOMEM);
-
 	rval = __v4l2_fwnode_endpoint_parse(fwnode, vep);
 	if (rval < 0)
-		goto out_err;
+		return rval;
 
 	rval = fwnode_property_read_u64_array(fwnode, "link-frequencies",
 					      NULL, 0);
@@ -428,18 +424,18 @@ struct v4l2_fwnode_endpoint *v4l2_fwnode_endpoint_alloc_parse(
 		vep->link_frequencies =
 			kmalloc_array(rval, sizeof(*vep->link_frequencies),
 				      GFP_KERNEL);
-		if (!vep->link_frequencies) {
-			rval = -ENOMEM;
-			goto out_err;
-		}
+		if (!vep->link_frequencies)
+			return -ENOMEM;
 
 		vep->nr_of_link_frequencies = rval;
 
 		rval = fwnode_property_read_u64_array(
 			fwnode, "link-frequencies", vep->link_frequencies,
 			vep->nr_of_link_frequencies);
-		if (rval < 0)
-			goto out_err;
+		if (rval < 0) {
+			v4l2_fwnode_endpoint_free(vep);
+			return rval;
+		}
 
 		for (i = 0; i < vep->nr_of_link_frequencies; i++)
 			pr_info("link-frequencies %u value %llu\n", i,
@@ -448,11 +444,7 @@ struct v4l2_fwnode_endpoint *v4l2_fwnode_endpoint_alloc_parse(
 
 	pr_debug("===== end V4L2 endpoint properties\n");
 
-	return vep;
-
-out_err:
-	v4l2_fwnode_endpoint_free(vep);
-	return ERR_PTR(rval);
+	return 0;
 }
 EXPORT_SYMBOL_GPL(v4l2_fwnode_endpoint_alloc_parse);
 
@@ -504,9 +496,9 @@ static int v4l2_async_notifier_fwnode_parse_endpoint(
 			    struct v4l2_fwnode_endpoint *vep,
 			    struct v4l2_async_subdev *asd))
 {
+	struct v4l2_fwnode_endpoint vep = { .bus_type = V4L2_MBUS_UNKNOWN };
 	struct v4l2_async_subdev *asd;
-	struct v4l2_fwnode_endpoint *vep;
-	int ret = 0;
+	int ret;
 
 	asd = kzalloc(asd_struct_size, GFP_KERNEL);
 	if (!asd)
@@ -521,23 +513,22 @@ static int v4l2_async_notifier_fwnode_parse_endpoint(
 		goto out_err;
 	}
 
-	vep = v4l2_fwnode_endpoint_alloc_parse(endpoint);
-	if (IS_ERR(vep)) {
-		ret = PTR_ERR(vep);
+	ret = v4l2_fwnode_endpoint_alloc_parse(endpoint, &vep);
+	if (ret) {
 		dev_warn(dev, "unable to parse V4L2 fwnode endpoint (%d)\n",
 			 ret);
 		goto out_err;
 	}
 
-	ret = parse_endpoint ? parse_endpoint(dev, vep, asd) : 0;
+	ret = parse_endpoint ? parse_endpoint(dev, &vep, asd) : 0;
 	if (ret == -ENOTCONN)
-		dev_dbg(dev, "ignoring port@%u/endpoint@%u\n", vep->base.port,
-			vep->base.id);
+		dev_dbg(dev, "ignoring port@%u/endpoint@%u\n", vep.base.port,
+			vep.base.id);
 	else if (ret < 0)
 		dev_warn(dev,
 			 "driver could not parse port@%u/endpoint@%u (%d)\n",
-			 vep->base.port, vep->base.id, ret);
-	v4l2_fwnode_endpoint_free(vep);
+			 vep.base.port, vep.base.id, ret);
+	v4l2_fwnode_endpoint_free(&vep);
 	if (ret < 0)
 		goto out_err;
 
diff --git a/include/media/v4l2-fwnode.h b/include/media/v4l2-fwnode.h
index 8b4873c37098..4cef723a6ad9 100644
--- a/include/media/v4l2-fwnode.h
+++ b/include/media/v4l2-fwnode.h
@@ -161,6 +161,7 @@ void v4l2_fwnode_endpoint_free(struct v4l2_fwnode_endpoint *vep);
 /**
  * v4l2_fwnode_endpoint_alloc_parse() - parse all fwnode node properties
  * @fwnode: pointer to the endpoint's fwnode handle
+ * @vep: pointer to the V4L2 fwnode data structure
  *
  * All properties are optional. If none are found, we don't set any flags. This
  * means the port has a static configuration and no properties have to be
@@ -170,6 +171,8 @@ void v4l2_fwnode_endpoint_free(struct v4l2_fwnode_endpoint *vep);
  * set the V4L2_MBUS_CSI2_CONTINUOUS_CLOCK flag. The caller should hold a
  * reference to @fwnode.
  *
+ * The caller must set the bus_type field of @vep to zero.
+ *
  * v4l2_fwnode_endpoint_alloc_parse() has two important differences to
  * v4l2_fwnode_endpoint_parse():
  *
@@ -181,8 +184,8 @@ void v4l2_fwnode_endpoint_free(struct v4l2_fwnode_endpoint *vep);
  * Return: Pointer to v4l2_fwnode_endpoint if successful, on an error pointer
  * on error.
  */
-struct v4l2_fwnode_endpoint *v4l2_fwnode_endpoint_alloc_parse(
-	struct fwnode_handle *fwnode);
+int v4l2_fwnode_endpoint_alloc_parse(
+	struct fwnode_handle *fwnode, struct v4l2_fwnode_endpoint *vep);
 
 /**
  * v4l2_fwnode_parse_link() - parse a link between two endpoints
-- 
2.11.0
