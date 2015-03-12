Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52667 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754976AbbCLUtz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2015 16:49:55 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: prabhakar.csengg@gmail.com, laurent.pinchart@ideasonboard.com
Subject: [PATCH v1.1 3/3] v4l: of: Add link-frequencies array to struct v4l2_of_endpoint
Date: Thu, 12 Mar 2015 22:49:14 +0200
Message-Id: <1426193354-17830-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <CA+V-a8u3o7fouVF5=cD=jsVdg0HGzP-ibU34mDW=q81ERknAaQ@mail.gmail.com>
References: <CA+V-a8u3o7fouVF5=cD=jsVdg0HGzP-ibU34mDW=q81ERknAaQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Parse and read the link-frequencies property in v4l2_of_parse_endpoint().
The property is an u64 array of undefined length, thus the memory allocation
may fail, leading

- v4l2_of_parse_endpoint() to return an error in such a case (as well as
  when failing to parse the property) and
- to requiring releasing the memory reserved for the array
  (v4l2_of_release_endpoint()).

If a driver does not need to access properties that require memory
allocation (such as link-frequencies), it may choose to call
v4l2_of_release_endpoint() right after calling v4l2_of_parse_endpoint().

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
since v1:

- Set the link_frequencies pointer to NULL and set nr_of_link_frequencies to
  zero if link-frequencies property cannot be found by changing memset
  arguments. Thanks to Prabhakar for spotting this!

 drivers/media/i2c/adv7604.c                    |    1 +
 drivers/media/i2c/s5c73m3/s5c73m3-core.c       |    1 +
 drivers/media/i2c/s5k5baf.c                    |    1 +
 drivers/media/i2c/smiapp/smiapp-core.c         |   32 +++++++--------
 drivers/media/i2c/tvp514x.c                    |    1 +
 drivers/media/i2c/tvp7002.c                    |    1 +
 drivers/media/platform/am437x/am437x-vpfe.c    |    1 +
 drivers/media/platform/exynos4-is/media-dev.c  |    1 +
 drivers/media/platform/exynos4-is/mipi-csis.c  |    1 +
 drivers/media/platform/soc_camera/atmel-isi.c  |    1 +
 drivers/media/platform/soc_camera/pxa_camera.c |    1 +
 drivers/media/platform/soc_camera/rcar_vin.c   |    1 +
 drivers/media/v4l2-core/v4l2-of.c              |   51 +++++++++++++++++++++++-
 include/media/v4l2-of.h                        |    9 +++++
 14 files changed, 84 insertions(+), 19 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index aaab9c9..9c6c2a5 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -2624,6 +2624,7 @@ static int adv76xx_parse_dt(struct adv76xx_state *state)
 		return -EINVAL;
 
 	v4l2_of_parse_endpoint(endpoint, &bus_cfg);
+	v4l2_of_release_endpoint(&bus_cfg);
 	of_node_put(endpoint);
 
 	flags = bus_cfg.bus.parallel.flags;
diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-core.c b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
index ee0f57e..f248a47 100644
--- a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
+++ b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
@@ -1624,6 +1624,7 @@ static int s5c73m3_get_platform_data(struct s5c73m3 *state)
 	}
 
 	v4l2_of_parse_endpoint(node_ep, &ep);
+	v4l2_of_release_endpoint(&ep);
 	of_node_put(node_ep);
 
 	if (ep.bus_type != V4L2_MBUS_CSI2) {
diff --git a/drivers/media/i2c/s5k5baf.c b/drivers/media/i2c/s5k5baf.c
index a3d7d03..222cd62 100644
--- a/drivers/media/i2c/s5k5baf.c
+++ b/drivers/media/i2c/s5k5baf.c
@@ -1867,6 +1867,7 @@ static int s5k5baf_parse_device_node(struct s5k5baf *state, struct device *dev)
 	}
 
 	v4l2_of_parse_endpoint(node_ep, &ep);
+	v4l2_of_release_endpoint(&ep);
 	of_node_put(node_ep);
 	state->bus_type = ep.bus_type;
 
diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index ecae76b..2b3cd9e 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2977,7 +2977,7 @@ static struct smiapp_platform_data *smiapp_get_pdata(struct device *dev)
 	struct smiapp_platform_data *pdata;
 	struct v4l2_of_endpoint bus_cfg;
 	struct device_node *ep;
-	uint32_t asize;
+	int i;
 	int rval;
 
 	if (!dev->of_node)
@@ -2987,12 +2987,14 @@ static struct smiapp_platform_data *smiapp_get_pdata(struct device *dev)
 	if (!ep)
 		return NULL;
 
+	rval = v4l2_of_parse_endpoint(ep, &bus_cfg);
+	if (rval < 0)
+		goto out_err;
+
 	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
 		goto out_err;
 
-	v4l2_of_parse_endpoint(ep, &bus_cfg);
-
 	switch (bus_cfg.bus_type) {
 	case V4L2_MBUS_CSI2:
 		pdata->csi_signalling_mode = SMIAPP_CSI_SIGNALLING_MODE_CSI2;
@@ -3022,34 +3024,30 @@ static struct smiapp_platform_data *smiapp_get_pdata(struct device *dev)
 	dev_dbg(dev, "reset %d, nvm %d, clk %d, csi %d\n", pdata->xshutdown,
 		pdata->nvm_size, pdata->ext_clk, pdata->csi_signalling_mode);
 
-	rval = of_get_property(ep, "link-frequencies", &asize) ? 0 : -ENOENT;
-	if (rval) {
-		dev_warn(dev, "can't get link-frequencies array size\n");
+	if (!bus_cfg.nr_of_link_frequencies) {
+		dev_warn(dev, "no link frequencies defined\n");
 		goto out_err;
 	}
 
-	pdata->op_sys_clock = devm_kzalloc(dev, asize, GFP_KERNEL);
+	pdata->op_sys_clock = devm_kmalloc_array(
+		dev, bus_cfg.nr_of_link_frequencies + 1 /* guardian */,
+		sizeof(*bus_cfg.link_frequencies), GFP_KERNEL);
 	if (!pdata->op_sys_clock) {
 		rval = -ENOMEM;
 		goto out_err;
 	}
 
-	asize /= sizeof(*pdata->op_sys_clock);
-	rval = of_property_read_u64_array(
-		ep, "link-frequencies", pdata->op_sys_clock, asize);
-	if (rval) {
-		dev_warn(dev, "can't get link-frequencies\n");
-		goto out_err;
+	for (i = 0; i < bus_cfg.nr_of_link_frequencies; i++) {
+		pdata->op_sys_clock[i] = bus_cfg.link_frequencies[i];
+		dev_dbg(dev, "freq %d: %lld\n", i, pdata->op_sys_clock[i]);
 	}
 
-	for (; asize > 0; asize--)
-		dev_dbg(dev, "freq %d: %lld\n", asize - 1,
-			pdata->op_sys_clock[asize - 1]);
-
+	v4l2_of_release_endpoint(&bus_cfg);
 	of_node_put(ep);
 	return pdata;
 
 out_err:
+	v4l2_of_release_endpoint(&bus_cfg);
 	of_node_put(ep);
 	return NULL;
 }
diff --git a/drivers/media/i2c/tvp514x.c b/drivers/media/i2c/tvp514x.c
index c6b3dc5..91d7dc9 100644
--- a/drivers/media/i2c/tvp514x.c
+++ b/drivers/media/i2c/tvp514x.c
@@ -1078,6 +1078,7 @@ tvp514x_get_pdata(struct i2c_client *client)
 		goto done;
 
 	v4l2_of_parse_endpoint(endpoint, &bus_cfg);
+	v4l2_of_release_endpoint(&bus_cfg);
 	flags = bus_cfg.bus.parallel.flags;
 
 	if (flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH)
diff --git a/drivers/media/i2c/tvp7002.c b/drivers/media/i2c/tvp7002.c
index 9233194..70119ea 100644
--- a/drivers/media/i2c/tvp7002.c
+++ b/drivers/media/i2c/tvp7002.c
@@ -965,6 +965,7 @@ tvp7002_get_pdata(struct i2c_client *client)
 		goto done;
 
 	v4l2_of_parse_endpoint(endpoint, &bus_cfg);
+	v4l2_of_release_endpoint(&bus_cfg);
 	flags = bus_cfg.bus.parallel.flags;
 
 	if (flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH)
diff --git a/drivers/media/platform/am437x/am437x-vpfe.c b/drivers/media/platform/am437x/am437x-vpfe.c
index 56a5cb0..19ec20a 100644
--- a/drivers/media/platform/am437x/am437x-vpfe.c
+++ b/drivers/media/platform/am437x/am437x-vpfe.c
@@ -2469,6 +2469,7 @@ vpfe_get_pdata(struct platform_device *pdev)
 		}
 
 		err = v4l2_of_parse_endpoint(endpoint, &bus_cfg);
+		v4l2_of_release_endpoint(&bus_cfg);
 		if (err) {
 			dev_err(&pdev->dev, "Could not parse the endpoint\n");
 			goto done;
diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index f315ef9..4d28305 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -340,6 +340,7 @@ static int fimc_md_parse_port_node(struct fimc_md *fmd,
 		return 0;
 
 	v4l2_of_parse_endpoint(ep, &endpoint);
+	v4l2_of_release_endpoint(&endpoint);
 	if (WARN_ON(endpoint.base.port == 0) || index >= FIMC_MAX_SENSORS)
 		return -EINVAL;
 
diff --git a/drivers/media/platform/exynos4-is/mipi-csis.c b/drivers/media/platform/exynos4-is/mipi-csis.c
index 2504aa8..03bf468 100644
--- a/drivers/media/platform/exynos4-is/mipi-csis.c
+++ b/drivers/media/platform/exynos4-is/mipi-csis.c
@@ -751,6 +751,7 @@ static int s5pcsis_parse_dt(struct platform_device *pdev,
 	}
 	/* Get port node and validate MIPI-CSI channel id. */
 	v4l2_of_parse_endpoint(node, &endpoint);
+	v4l2_of_release_endpoint(&endpoint);
 
 	state->index = endpoint.base.port - FIMC_INPUT_MIPI_CSI2_0;
 	if (state->index >= CSIS_MAX_ENTITIES)
diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index 8526bf5..245e3a4 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -900,6 +900,7 @@ static int atmel_isi_probe_dt(struct atmel_isi *isi,
 	}
 
 	err = v4l2_of_parse_endpoint(np, &ep);
+	v4l2_of_release_endpoint(&ep);
 	if (err) {
 		dev_err(&pdev->dev, "Could not parse the endpoint\n");
 		goto err_probe_dt;
diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
index 8d6e343..1e37b9b 100644
--- a/drivers/media/platform/soc_camera/pxa_camera.c
+++ b/drivers/media/platform/soc_camera/pxa_camera.c
@@ -1672,6 +1672,7 @@ static int pxa_camera_pdata_from_dt(struct device *dev,
 	}
 
 	err = v4l2_of_parse_endpoint(np, &ep);
+	v4l2_of_release_endpoint(&ep);
 	if (err) {
 		dev_err(dev, "could not parse endpoint\n");
 		goto out;
diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index 279ab9f..cf0a328 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -1863,6 +1863,7 @@ static int rcar_vin_probe(struct platform_device *pdev)
 		}
 
 		ret = v4l2_of_parse_endpoint(np, &ep);
+		v4l2_of_release_endpoint(&ep);
 		if (ret) {
 			dev_err(&pdev->dev, "could not parse endpoint\n");
 			return ret;
diff --git a/drivers/media/v4l2-core/v4l2-of.c b/drivers/media/v4l2-core/v4l2-of.c
index b4ed9a9..9043eea 100644
--- a/drivers/media/v4l2-core/v4l2-of.c
+++ b/drivers/media/v4l2-core/v4l2-of.c
@@ -14,6 +14,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/of.h>
+#include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/types.h>
 
@@ -109,6 +110,26 @@ static void v4l2_of_parse_parallel_bus(const struct device_node *node,
 }
 
 /**
+ * v4l2_of_release_endpoint() - release resources acquired by
+ * v4l2_of_parse_endpoint()
+ * @endpoint - the endpoint the resources of which are to be released
+ *
+ * It is safe to call this function on an endpoint which is not parsed or
+ * and endpoint the parsing of which failed. However in the former case the
+ * argument must point to a struct the memory of which has been set to zero.
+ *
+ * Values in the struct v4l2_of_endpoint that are not connected to resources
+ * acquired by v4l2_of_parse_endpoint() are guaranteed to remain untouched.
+ */
+void v4l2_of_release_endpoint(struct v4l2_of_endpoint *endpoint)
+{
+	kfree(endpoint->link_frequencies);
+	endpoint->link_frequencies = NULL;
+	endpoint->nr_of_link_frequencies = 0;
+}
+EXPORT_SYMBOL(v4l2_of_parse_endpoint);
+
+/**
  * v4l2_of_parse_endpoint() - parse all endpoint node properties
  * @node: pointer to endpoint device_node
  * @endpoint: pointer to the V4L2 OF endpoint data structure
@@ -122,14 +143,40 @@ static void v4l2_of_parse_parallel_bus(const struct device_node *node,
  * V4L2_MBUS_CSI2_CONTINUOUS_CLOCK flag.
  * The caller should hold a reference to @node.
  *
+ * An endpoint parsed using v4l2_of_parse_endpoint() must be released using
+ * v4l2_of_release_endpoint().
+ *
  * Return: 0.
  */
 int v4l2_of_parse_endpoint(const struct device_node *node,
 			   struct v4l2_of_endpoint *endpoint)
 {
+	int len;
+
 	of_graph_parse_endpoint(node, &endpoint->base);
 	endpoint->bus_type = 0;
-	memset(&endpoint->bus, 0, sizeof(endpoint->bus));
+	/* Zero fields from bus to until head (excluding) */
+	memset(&endpoint->bus, 0, offsetof(typeof(*endpoint), head) -
+	       offsetof(typeof(*endpoint), bus));
+
+	if (of_get_property(node, "link-frequencies", &len)) {
+		int rval;
+
+		endpoint->link_frequencies = kmalloc(len, GFP_KERNEL);
+		if (!endpoint->link_frequencies)
+			return -ENOMEM;
+
+		endpoint->nr_of_link_frequencies =
+			len / sizeof(*endpoint->link_frequencies);
+
+		rval = of_property_read_u64_array(
+			node, "link-frequencies", endpoint->link_frequencies,
+			endpoint->nr_of_link_frequencies);
+		if (rval < 0) {
+			v4l2_of_release_endpoint(endpoint);
+			return rval;
+		}
+	}
 
 	v4l2_of_parse_csi_bus(node, endpoint);
 	/*
@@ -141,4 +188,4 @@ int v4l2_of_parse_endpoint(const struct device_node *node,
 
 	return 0;
 }
-EXPORT_SYMBOL(v4l2_of_parse_endpoint);
+EXPORT_SYMBOL(v4l2_of_release_endpoint);
diff --git a/include/media/v4l2-of.h b/include/media/v4l2-of.h
index 70fa7b7..8c123ff 100644
--- a/include/media/v4l2-of.h
+++ b/include/media/v4l2-of.h
@@ -54,6 +54,8 @@ struct v4l2_of_bus_parallel {
  * @base: struct of_endpoint containing port, id, and local of_node
  * @bus_type: bus type
  * @bus: bus configuration data structure
+ * @link_frequencies: array of supported link frequencies
+ * @nr_of_link_frequencies: number of elements in link_frequenccies array
  * @head: list head for this structure
  */
 struct v4l2_of_endpoint {
@@ -63,12 +65,15 @@ struct v4l2_of_endpoint {
 		struct v4l2_of_bus_parallel parallel;
 		struct v4l2_of_bus_mipi_csi2 mipi_csi2;
 	} bus;
+	u64 *link_frequencies;
+	unsigned int nr_of_link_frequencies;
 	struct list_head head;
 };
 
 #ifdef CONFIG_OF
 int v4l2_of_parse_endpoint(const struct device_node *node,
 			   struct v4l2_of_endpoint *endpoint);
+void v4l2_of_release_endpoint(struct v4l2_of_endpoint *endpoint);
 #else /* CONFIG_OF */
 
 static inline int v4l2_of_parse_endpoint(const struct device_node *node,
@@ -77,6 +82,10 @@ static inline int v4l2_of_parse_endpoint(const struct device_node *node,
 	return -ENOSYS;
 }
 
+static void v4l2_of_release_endpoint(struct v4l2_of_endpoint *endpoint)
+{
+}
+
 #endif /* CONFIG_OF */
 
 #endif /* _V4L2_OF_H */
-- 
1.7.10.4

