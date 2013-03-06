Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:33182 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757879Ab3CFLyw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2013 06:54:52 -0500
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org
Cc: s.nawrocki@samsung.com, shaik.samsung@gmail.com
Subject: [RFC 07/12] media: exynos5-is: Adding media device driver for exynos5
Date: Wed,  6 Mar 2013 17:23:53 +0530
Message-Id: <1362570838-4737-8-git-send-email-shaik.ameer@samsung.com>
In-Reply-To: <1362570838-4737-1-git-send-email-shaik.ameer@samsung.com>
References: <1362570838-4737-1-git-send-email-shaik.ameer@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for media device for EXYNOS5 SoCs.
The current media device supports the following ips to connect
through the media controller framework.

* MIPI-CSIS
  Support interconnection(subdev interface) between devices

* FIMC-LITE
  Support capture interface from device(Sensor, MIPI-CSIS) to memory
  Support interconnection(subdev interface) between devices

G-Scaler will be added later to the current media device.

* Gscaler: general scaler
  Support memory to memory interface
  Support output interface from memory to display device(LCD, TV)
  Support capture interface from device(FIMC-LITE, FIMD) to memory

--> media 0
  Camera Capture path consists of MIPI-CSIS, FIMC-LITE and G-Scaler
  +--------+     +-----------+     +-----------------+
  | Sensor | --> | FIMC-LITE | --> | G-Scaler-capture |
  +--------+     +-----------+     +-----------------+

  +--------+     +-----------+     +-----------+     +-----------------+
  | Sensor | --> | MIPI-CSIS | --> | FIMC-LITE | --> | G-Scaler-capture |
  +--------+     +-----------+     +-----------+     +-----------------+

Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
---
 drivers/media/platform/Kconfig                   |    1 +
 drivers/media/platform/Makefile                  |    1 +
 drivers/media/platform/exynos5-is/Kconfig        |    7 +
 drivers/media/platform/exynos5-is/Makefile       |    4 +
 drivers/media/platform/exynos5-is/exynos5-mdev.c | 1309 ++++++++++++++++++++++
 drivers/media/platform/exynos5-is/exynos5-mdev.h |  107 ++
 6 files changed, 1429 insertions(+)
 create mode 100644 drivers/media/platform/exynos5-is/Kconfig
 create mode 100644 drivers/media/platform/exynos5-is/Makefile
 create mode 100644 drivers/media/platform/exynos5-is/exynos5-mdev.c
 create mode 100644 drivers/media/platform/exynos5-is/exynos5-mdev.h

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 2433e2b..f74bd92 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -123,6 +123,7 @@ config VIDEO_S3C_CAMIF
 
 source "drivers/media/platform/soc_camera/Kconfig"
 source "drivers/media/platform/s5p-fimc/Kconfig"
+source "drivers/media/platform/exynos5-is/Kconfig"
 source "drivers/media/platform/s5p-tv/Kconfig"
 
 endif # V4L_PLATFORM_DRIVERS
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index 42089ba..43da7ab 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -37,6 +37,7 @@ obj-$(CONFIG_VIDEO_SAMSUNG_S5P_TV)	+= s5p-tv/
 
 obj-$(CONFIG_VIDEO_SAMSUNG_S5P_G2D)	+= s5p-g2d/
 obj-$(CONFIG_VIDEO_SAMSUNG_EXYNOS_GSC)	+= exynos-gsc/
+obj-$(CONFIG_VIDEO_SAMSUNG_EXYNOS5_MDEV)	+= exynos5-is/
 
 obj-$(CONFIG_BLACKFIN)                  += blackfin/
 
diff --git a/drivers/media/platform/exynos5-is/Kconfig b/drivers/media/platform/exynos5-is/Kconfig
new file mode 100644
index 0000000..7aacf3b
--- /dev/null
+++ b/drivers/media/platform/exynos5-is/Kconfig
@@ -0,0 +1,7 @@
+config VIDEO_SAMSUNG_EXYNOS5_MDEV
+	bool "Samsung Exynos5 Media Device driver"
+	depends on VIDEO_DEV && VIDEO_V4L2 && ARCH_EXYNOS5
+	help
+	  This is a v4l2 based media controller driver for
+	  Exynos5 SoC.
+
diff --git a/drivers/media/platform/exynos5-is/Makefile b/drivers/media/platform/exynos5-is/Makefile
new file mode 100644
index 0000000..472d8e1
--- /dev/null
+++ b/drivers/media/platform/exynos5-is/Makefile
@@ -0,0 +1,4 @@
+ccflags-y += -Idrivers/media/platform/s5p-fimc
+exynos-mdevice-objs := exynos5-mdev.o
+
+obj-$(CONFIG_VIDEO_SAMSUNG_EXYNOS5_MDEV) += exynos-mdevice.o
diff --git a/drivers/media/platform/exynos5-is/exynos5-mdev.c b/drivers/media/platform/exynos5-is/exynos5-mdev.c
new file mode 100644
index 0000000..1158696
--- /dev/null
+++ b/drivers/media/platform/exynos5-is/exynos5-mdev.c
@@ -0,0 +1,1309 @@
+/*
+ * S5P/EXYNOS4 SoC series camera host interface media device driver
+ *
+ * Copyright (C) 2011 - 2012 Samsung Electronics Co., Ltd.
+ * Sylwester Nawrocki <s.nawrocki@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundation, either version 2 of the License,
+ * or (at your option) any later version.
+ */
+
+#include <linux/bug.h>
+#include <linux/device.h>
+#include <linux/errno.h>
+#include <linux/i2c.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
+#include <linux/of_device.h>
+#include <linux/of_i2c.h>
+#include <linux/pinctrl/consumer.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+#include <linux/types.h>
+#include <linux/slab.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-of.h>
+#include <media/media-device.h>
+
+#include "exynos5-mdev.h"
+
+#define dbg(fmt, args...) \
+	pr_debug("%s:%d: " fmt "\n", __func__, __LINE__, ##args)
+
+static struct fimc_md *g_exynos_mdev;
+
+static int fimc_md_set_camclk(struct v4l2_subdev *sd, bool on);
+static int __fimc_md_set_camclk(struct fimc_md *fmd,
+				struct fimc_sensor_info *s_info,
+				bool on);
+/**
+ * fimc_pipeline_prepare - update pipeline information with subdevice pointers
+ * @fimc: fimc device terminating the pipeline
+ *
+ * Caller holds the graph mutex.
+ */
+static void fimc_pipeline_prepare(struct exynos5_pipeline0 *p,
+				  struct media_entity *me)
+{
+	struct media_pad *pad = &me->pads[0];
+	struct v4l2_subdev *sd;
+	int i;
+
+	for (i = 0; i < IDX_MAX; i++)
+		p->subdevs[i] = NULL;
+
+	while (1) {
+
+		if (!(pad->flags & MEDIA_PAD_FL_SINK))
+			break;
+
+		/* source pad */
+		pad = media_entity_remote_source(pad);
+
+		if (pad != NULL)
+			pr_err("entity type: %d, entity name: %s\n",
+			    media_entity_type(pad->entity), pad->entity->name);
+
+		if (pad == NULL ||
+		    media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
+			break;
+
+		sd = media_entity_to_v4l2_subdev(pad->entity);
+
+		switch (sd->grp_id) {
+		case GRP_ID_FIMC_IS_SENSOR:
+		case GRP_ID_SENSOR:
+			p->subdevs[IDX_SENSOR] = sd;
+			break;
+		case GRP_ID_CSIS:
+			p->subdevs[IDX_CSIS] = sd;
+			break;
+		case GRP_ID_FLITE:
+			p->subdevs[IDX_FLITE] = sd;
+			break;
+		default:
+			pr_warn("%s: Unknown subdev grp_id: %#x\n",
+				__func__, sd->grp_id);
+		}
+
+		/* sink pad */
+		pad = &sd->entity.pads[0];
+	}
+}
+
+/**
+ * __subdev_set_power - change power state of a single subdev
+ * @sd: subdevice to change power state for
+ * @on: 1 to enable power or 0 to disable
+ *
+ * Return result of s_power subdev operation or -ENXIO if sd argument
+ * is NULL. Return 0 if the subdevice does not implement s_power.
+ */
+static int __subdev_set_power(struct v4l2_subdev *sd, int on)
+{
+	int *use_count;
+	int ret;
+
+	if (sd == NULL)
+		return -ENXIO;
+
+	use_count = &sd->entity.use_count;
+	if (on && (*use_count)++ > 0)
+		return 0;
+	else if (!on && (*use_count == 0 || --(*use_count) > 0))
+		return 0;
+
+	ret = v4l2_subdev_call(sd, core, s_power, on);
+
+	return ret != -ENOIOCTLCMD ? ret : 0;
+}
+
+/**
+ * fimc_pipeline_s_power - change power state of all pipeline subdevs
+ * @fimc: fimc device terminating the pipeline
+ * @state: true to power on, false to power off
+ *
+ * Needs to be called with the graph mutex held.
+ */
+static int fimc_pipeline_s_power(struct exynos5_pipeline0 *p, bool state)
+{
+	unsigned int i;
+	int ret;
+
+	if (p->subdevs[IDX_SENSOR] == NULL)
+		return -ENXIO;
+
+	for (i = 0; i < IDX_MAX; i++) {
+		unsigned int idx = state ? (IDX_MAX - 1) - i : i;
+
+		ret = __subdev_set_power(p->subdevs[idx], state);
+		if (ret < 0 && ret != -ENXIO)
+			return ret;
+	}
+
+	return 0;
+}
+
+/**
+ * __fimc_pipeline_init
+ *    allocate the fimc_pipeline structure and do the basic initialization
+ */
+static int __fimc_pipeline_init(struct exynos_pipeline *ep)
+{
+	struct exynos5_pipeline0 *p;
+
+	p = kzalloc(sizeof(*p), GFP_KERNEL);
+	if (!p)
+		return -ENOMEM;
+
+	p->is_init = true;
+	p->fmd = g_exynos_mdev;
+	ep->priv = (void *)p;
+	return 0;
+}
+
+/**
+ * __fimc_pipeline_deinit
+ *    free the allocated resources for fimc_pipeline
+ */
+static int __fimc_pipeline_deinit(struct exynos_pipeline *ep)
+{
+	struct exynos5_pipeline0 *p = (struct exynos5_pipeline0 *)ep->priv;
+
+	if (!p || !p->is_init)
+		return -EINVAL;
+
+	p->is_init = false;
+	kfree(p);
+
+	return 0;
+}
+
+/**
+ * __fimc_pipeline_get_subdev_sensor
+ *     if valid pipeline, returns the sensor subdev pointer
+ *     else returns NULL
+ */
+static struct v4l2_subdev *__fimc_pipeline_get_subdev_sensor(
+					struct exynos_pipeline *ep)
+{
+	struct exynos5_pipeline0 *p = (struct exynos5_pipeline0 *)ep->priv;
+
+	if (!p || !p->is_init)
+		return NULL;
+
+	return p->subdevs[IDX_SENSOR];
+}
+
+/**
+ * __fimc_pipeline_get_subdev_csis
+ *      if valid pipeline, returns the csis subdev pointer
+ *      else returns NULL
+ */
+static struct v4l2_subdev *__fimc_pipeline_get_subdev_csis(
+					struct exynos_pipeline *ep)
+{
+	struct exynos5_pipeline0 *p = (struct exynos5_pipeline0 *)ep->priv;
+
+	if (!p || !p->is_init)
+		return NULL;
+
+	return p->subdevs[IDX_CSIS];
+}
+/**
+ * __fimc_pipeline_open - update the pipeline information, enable power
+ *                        of all pipeline subdevs and the sensor clock
+ * @me: media entity to start graph walk with
+ * @prep: true to acquire sensor (and csis) subdevs
+ *
+ * Called with the graph mutex held.
+ */
+static int __fimc_pipeline_open(struct exynos_pipeline *ep,
+				struct media_entity *me, bool prep)
+{
+	struct exynos5_pipeline0 *p = (struct exynos5_pipeline0 *)ep->priv;
+	int ret;
+
+	if (prep)
+		fimc_pipeline_prepare(p, me);
+
+	if (p->subdevs[IDX_SENSOR] == NULL)
+		return -EINVAL;
+
+	ret = fimc_md_set_camclk(p->subdevs[IDX_SENSOR], true);
+	if (ret)
+		return ret;
+
+	return fimc_pipeline_s_power(p, 1);
+}
+
+/**
+ * __fimc_pipeline_close - disable the sensor clock and pipeline power
+ * @fimc: fimc device terminating the pipeline
+ *
+ * Disable power of all subdevs and turn the external sensor clock off.
+ */
+static int __fimc_pipeline_close(struct exynos_pipeline *ep)
+{
+	struct exynos5_pipeline0 *p = (struct exynos5_pipeline0 *)ep->priv;
+	int ret = 0;
+
+	if (!p || !p->subdevs[IDX_SENSOR])
+		return -EINVAL;
+
+	if (p->subdevs[IDX_SENSOR]) {
+		ret = fimc_pipeline_s_power(p, 0);
+		fimc_md_set_camclk(p->subdevs[IDX_SENSOR], false);
+	}
+	return ret == -ENXIO ? 0 : ret;
+}
+
+/**
+ * __fimc_pipeline_s_stream - invoke s_stream on pipeline subdevs
+ * @pipeline: video pipeline structure
+ * @on: passed as the s_stream call argument
+ */
+static int __fimc_pipeline_s_stream(struct exynos_pipeline *ep, bool on)
+{
+	struct exynos5_pipeline0 *p = (struct exynos5_pipeline0 *)ep->priv;
+	int i, ret;
+
+	if (p->subdevs[IDX_SENSOR] == NULL)
+		return -ENODEV;
+
+	for (i = 0; i < IDX_MAX; i++) {
+		unsigned int idx = on ? (IDX_MAX - 1) - i : i;
+
+		ret = v4l2_subdev_call(p->subdevs[idx], video, s_stream, on);
+
+		if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
+			return ret;
+	}
+
+	return 0;
+
+}
+
+static void __fimc_pipeline_graph_lock(struct exynos_pipeline *ep)
+{
+	struct exynos5_pipeline0 *p = (struct exynos5_pipeline0 *)ep->priv;
+	struct fimc_md *fmd = p->fmd;
+
+	mutex_lock(&fmd->media_dev.graph_mutex);
+}
+
+static void __fimc_pipeline_graph_unlock(struct exynos_pipeline *ep)
+{
+	struct exynos5_pipeline0 *p = (struct exynos5_pipeline0 *)ep->priv;
+	struct fimc_md *fmd = p->fmd;
+
+	mutex_unlock(&fmd->media_dev.graph_mutex);
+}
+
+static void __fimc_pipeline_register_notify_callback(
+		struct exynos_pipeline *ep,
+		void (*notify_cb)(struct v4l2_subdev *sd,
+				unsigned int notification, void *arg))
+{
+	struct exynos5_pipeline0 *p = (struct exynos5_pipeline0 *)ep->priv;
+
+	if (!notify_cb)
+		return;
+
+	p->sensor_notify = notify_cb;
+}
+
+/* Media pipeline operations for the FIMC/FIMC-LITE video device driver */
+static const struct exynos_pipeline_ops exynos5_pipeline0_ops = {
+	.init			= __fimc_pipeline_init,
+	.deinit			= __fimc_pipeline_deinit,
+	.open			= __fimc_pipeline_open,
+	.close			= __fimc_pipeline_close,
+	.set_stream		= __fimc_pipeline_s_stream,
+	.get_subdev_sensor	= __fimc_pipeline_get_subdev_sensor,
+	.get_subdev_csis	= __fimc_pipeline_get_subdev_csis,
+	.graph_lock		= __fimc_pipeline_graph_lock,
+	.graph_unlock		= __fimc_pipeline_graph_unlock,
+	.register_notify_cb	= __fimc_pipeline_register_notify_callback,
+};
+
+/*
+ * Sensor subdevice helper functions
+ */
+static struct v4l2_subdev *fimc_md_register_sensor(struct fimc_md *fmd,
+				   struct fimc_sensor_info *s_info)
+{
+	struct i2c_adapter *adapter;
+	struct v4l2_subdev *sd = NULL;
+
+	if (!s_info || !fmd)
+		return NULL;
+
+	adapter = i2c_get_adapter(s_info->pdata.i2c_bus_num);
+	if (!adapter) {
+		v4l2_warn(&fmd->v4l2_dev,
+			  "Failed to get I2C adapter %d, deferring probe\n",
+			  s_info->pdata.i2c_bus_num);
+		return ERR_PTR(-EPROBE_DEFER);
+	}
+	sd = v4l2_i2c_new_subdev_board(&fmd->v4l2_dev, adapter,
+				       s_info->pdata.board_info, NULL);
+	if (IS_ERR_OR_NULL(sd)) {
+		i2c_put_adapter(adapter);
+		v4l2_warn(&fmd->v4l2_dev,
+			  "Failed to acquire subdev %s, deferring probe\n",
+			  s_info->pdata.board_info->type);
+		return ERR_PTR(-EPROBE_DEFER);
+	}
+	v4l2_set_subdev_hostdata(sd, s_info);
+	sd->grp_id = GRP_ID_SENSOR;
+
+	v4l2_info(&fmd->v4l2_dev, "Registered sensor subdevice %s\n",
+		  sd->name);
+	return sd;
+}
+
+static void fimc_md_unregister_sensor(struct v4l2_subdev *sd)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct i2c_adapter *adapter;
+
+	if (!client)
+		return;
+	v4l2_device_unregister_subdev(sd);
+
+	if (!client->dev.of_node) {
+		adapter = client->adapter;
+		i2c_unregister_device(client);
+		if (adapter)
+			i2c_put_adapter(adapter);
+	}
+}
+
+#ifdef CONFIG_OF
+/* Register I2C client subdev associated with @node. */
+static int fimc_md_of_add_sensor(struct fimc_md *fmd,
+				 struct device_node *node, int index)
+{
+	struct fimc_sensor_info *si;
+	struct i2c_client *client;
+	struct v4l2_subdev *sd;
+	int ret;
+
+	if (WARN_ON(index >= ARRAY_SIZE(fmd->sensor)))
+		return -EINVAL;
+
+	si = &fmd->sensor[index];
+
+	client = of_find_i2c_device_by_node(node);
+	if (!client)
+		return -EPROBE_DEFER;
+
+	device_lock(&client->dev);
+
+	if (!client->driver ||
+	    !try_module_get(client->driver->driver.owner)) {
+		ret = -EPROBE_DEFER;
+		goto dev_put;
+	}
+
+	/* Enable sensor's master clock */
+	ret = __fimc_md_set_camclk(fmd, si, true);
+	if (ret < 0)
+		goto mod_put;
+
+	sd = i2c_get_clientdata(client);
+
+	ret = v4l2_device_register_subdev(&fmd->v4l2_dev, sd);
+	__fimc_md_set_camclk(fmd, si, false);
+	if (ret < 0)
+		goto mod_put;
+
+	v4l2_set_subdev_hostdata(sd, si);
+	sd->grp_id = GRP_ID_SENSOR;
+	si->subdev = sd;
+	v4l2_info(&fmd->v4l2_dev, "Registered sensor subdevice: %s (%d)\n",
+		  sd->name, fmd->num_sensors);
+	fmd->num_sensors++;
+
+mod_put:
+	module_put(client->driver->driver.owner);
+dev_put:
+	device_unlock(&client->dev);
+	put_device(&client->dev);
+	return ret;
+}
+
+/* Parse port node and register as a sub-device any sensor specified there. */
+static int fimc_md_parse_port_node(struct fimc_md *fmd,
+				   struct device_node *port,
+				   unsigned int index)
+{
+	struct device_node *rem, *endpoint;
+	struct fimc_source_info *pd;
+	struct v4l2_of_endpoint bus_cfg;
+	u32 tmp, reg = 0;
+	int ret;
+
+	if (WARN_ON(of_property_read_u32(port, "reg", &reg) ||
+	    reg >= FIMC_MAX_SENSORS))
+		return -EINVAL;
+
+	pd = &fmd->sensor[index].pdata;
+	pd->mux_id = (reg - 1) & 0x1;
+
+	/* Assume here a port node can have only one endpoint node. */
+	endpoint = of_get_next_child(port, NULL);
+	if (!endpoint)
+		return 0;
+
+	rem = v4l2_of_get_remote_port_parent(endpoint);
+	of_node_put(endpoint);
+	if (rem == NULL) {
+		v4l2_info(&fmd->v4l2_dev, "Remote device at %s not found\n",
+			  endpoint->full_name);
+		return 0;
+	}
+
+	if (!of_property_read_u32(rem, "samsung,camclk-out", &tmp))
+		pd->clk_id = tmp;
+
+	if (!of_property_read_u32(rem, "clock-frequency", &tmp))
+		pd->clk_frequency = tmp;
+
+	if (pd->clk_frequency == 0) {
+		v4l2_err(&fmd->v4l2_dev, "Wrong clock frequency at node %s\n",
+			 rem->full_name);
+		of_node_put(rem);
+		return -EINVAL;
+	}
+
+	if (fimc_input_is_parallel(reg)) {
+		v4l2_of_parse_parallel_bus(endpoint, &bus_cfg);
+		if (bus_cfg.mbus.type == V4L2_MBUS_PARALLEL)
+			pd->sensor_bus_type = FIMC_BUS_TYPE_ITU_601;
+		else
+			pd->sensor_bus_type = FIMC_BUS_TYPE_ITU_656;
+		pd->flags = bus_cfg.mbus.flags;
+	} else if (fimc_input_is_mipi_csi(reg)) {
+		/*
+		 * MIPI CSI-2: only input mux selection
+		 * and sensor's clock frequency is needed.
+		 */
+		pd->sensor_bus_type = FIMC_BUS_TYPE_MIPI_CSI2;
+	} else {
+		v4l2_err(&fmd->v4l2_dev, "Wrong port id (%u) at node %s\n",
+			 reg, rem->full_name);
+	}
+
+	ret = fimc_md_of_add_sensor(fmd, rem, index);
+	of_node_put(rem);
+
+	return ret;
+}
+
+/* Register all SoC external sub-devices */
+static int fimc_md_of_sensors_register(struct fimc_md *fmd,
+				       struct device_node *np)
+{
+	struct device_node *parent = fmd->pdev->dev.of_node;
+	struct device_node *node, *ports;
+	int index = 0;
+	int ret;
+
+	/* Attach sensors linked to MIPI CSI-2 receivers */
+	for_each_available_child_of_node(parent, node) {
+		struct device_node *port;
+
+		if (of_node_cmp(node->name, "csis"))
+			continue;
+
+		/* The csis node can have only port subnode. */
+		port = of_get_next_child(node, NULL);
+		if (!port)
+			continue;
+
+		ret = fimc_md_parse_port_node(fmd, port, index);
+		if (ret < 0)
+			return ret;
+		index++;
+	}
+
+	/* Attach sensors listed in the parallel-ports node */
+	ports = of_get_child_by_name(parent, "parallel-ports");
+	if (!ports)
+		return 0;
+
+	for_each_child_of_node(ports, node) {
+		ret = fimc_md_parse_port_node(fmd, node, index);
+		if (ret < 0)
+			break;
+		index++;
+	}
+
+	return 0;
+}
+#else
+#define fimc_md_of_sensors_register(fmd, np) (-ENOSYS)
+#endif
+
+static int fimc_md_register_sensor_entities(struct fimc_md *fmd)
+{
+	struct s5p_platform_fimc *pdata = fmd->pdev->dev.platform_data;
+	struct device_node *of_node = fmd->pdev->dev.of_node;
+	int num_clients = 0;
+	int ret, i;
+
+	if (of_node) {
+		fmd->num_sensors = 0;
+		ret = fimc_md_of_sensors_register(fmd, of_node);
+	} else if (pdata) {
+		WARN_ON(pdata->num_clients > ARRAY_SIZE(fmd->sensor));
+		num_clients = min_t(u32, pdata->num_clients,
+				    ARRAY_SIZE(fmd->sensor));
+		fmd->num_sensors = num_clients;
+
+		fmd->num_sensors = num_clients;
+		for (i = 0; i < num_clients; i++) {
+			struct v4l2_subdev *sd;
+
+			fmd->sensor[i].pdata = pdata->source_info[i];
+			ret = __fimc_md_set_camclk(fmd, &fmd->sensor[i], true);
+			if (ret)
+				break;
+			sd = fimc_md_register_sensor(fmd, &fmd->sensor[i]);
+			ret = __fimc_md_set_camclk(fmd, &fmd->sensor[i], false);
+
+			if (IS_ERR(sd)) {
+				fmd->sensor[i].subdev = NULL;
+				ret = PTR_ERR(sd);
+				break;
+			}
+			fmd->sensor[i].subdev = sd;
+			if (ret)
+				break;
+		}
+	}
+
+	return ret;
+}
+
+/*
+ * MIPI-CSIS, FIMC and FIMC-LITE platform devices registration.
+ */
+
+static int register_fimc_lite_entity(struct fimc_md *fmd,
+				     struct fimc_lite *fimc_lite)
+{
+	struct v4l2_subdev *sd;
+	int ret;
+
+	if (WARN_ON(fimc_lite->index >= FIMC_LITE_MAX_DEVS ||
+		    fmd->fimc_lite[fimc_lite->index]))
+		return -EBUSY;
+
+	sd = &fimc_lite->subdev;
+	sd->grp_id = GRP_ID_FLITE;
+	v4l2_set_subdev_hostdata(sd, (void *)&exynos5_pipeline0_ops);
+
+	ret = v4l2_device_register_subdev(&fmd->v4l2_dev, sd);
+	if (!ret)
+		fmd->fimc_lite[fimc_lite->index] = fimc_lite;
+	else
+		v4l2_err(&fmd->v4l2_dev, "Failed to register FIMC.LITE%d\n",
+			 fimc_lite->index);
+	return ret;
+}
+
+static int register_csis_entity(struct fimc_md *fmd,
+				struct platform_device *pdev,
+				struct v4l2_subdev *sd)
+{
+	struct device_node *node = pdev->dev.of_node;
+	int id, ret;
+
+	id = node ? of_alias_get_id(node, "csis") : max(0, pdev->id);
+
+	if (WARN_ON(id >= CSIS_MAX_ENTITIES || fmd->csis[id].sd))
+		return -EBUSY;
+
+	if (WARN_ON(id >= CSIS_MAX_ENTITIES))
+		return 0;
+
+	sd->grp_id = GRP_ID_CSIS;
+	ret = v4l2_device_register_subdev(&fmd->v4l2_dev, sd);
+	if (!ret)
+		fmd->csis[id].sd = sd;
+	else
+		v4l2_err(&fmd->v4l2_dev,
+			 "Failed to register MIPI-CSIS.%d (%d)\n", id, ret);
+
+	return ret;
+}
+
+static int fimc_md_register_platform_entity(struct fimc_md *fmd,
+					    struct platform_device *pdev,
+					    int plat_entity)
+{
+	struct device *dev = &pdev->dev;
+	int ret = -EPROBE_DEFER;
+	void *drvdata;
+
+	/* Lock to ensure dev->driver won't change. */
+	device_lock(dev);
+
+	if (!dev->driver || !try_module_get(dev->driver->owner))
+		goto dev_unlock;
+
+	drvdata = dev_get_drvdata(dev);
+	/* Some subdev didn't probe succesfully id drvdata is NULL */
+	if (drvdata) {
+		switch (plat_entity) {
+		case IDX_FLITE:
+			ret = register_fimc_lite_entity(fmd, drvdata);
+			break;
+		case IDX_CSIS:
+			ret = register_csis_entity(fmd, pdev, drvdata);
+			break;
+		default:
+			ret = -ENODEV;
+		}
+	}
+
+	module_put(dev->driver->owner);
+dev_unlock:
+	device_unlock(dev);
+	if (ret == -EPROBE_DEFER)
+		dev_info(&fmd->pdev->dev, "deferring %s device registration\n",
+			dev_name(dev));
+	else if (ret < 0)
+		dev_err(&fmd->pdev->dev, "%s device registration failed (%d)\n",
+			dev_name(dev), ret);
+	return ret;
+}
+
+static int fimc_md_pdev_match(struct device *dev, void *data)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	int plat_entity = -1;
+	int ret;
+
+	if (!get_device(dev))
+		return -ENODEV;
+
+	if (!strcmp(pdev->name, CSIS_DRIVER_NAME))
+		plat_entity = IDX_CSIS;
+	else if (!strcmp(pdev->name, FIMC_LITE_DRV_NAME))
+		plat_entity = IDX_FLITE;
+
+	if (plat_entity >= 0)
+		ret = fimc_md_register_platform_entity(data, pdev,
+						       plat_entity);
+	put_device(dev);
+	return 0;
+}
+
+/* Register FIMC, FIMC-LITE and CSIS media entities */
+#ifdef CONFIG_OF
+static int fimc_md_register_of_platform_entities(struct fimc_md *fmd,
+						 struct device_node *parent)
+{
+	struct device_node *node;
+	int ret = 0;
+
+	for_each_available_child_of_node(parent, node) {
+		struct platform_device *pdev;
+		int plat_entity = -1;
+
+		pdev = of_find_device_by_node(node);
+		if (!pdev)
+			continue;
+
+		/* If driver of any entity isn't ready try all again later. */
+		if (!strcmp(node->name, CSIS_OF_NODE_NAME))
+			plat_entity = IDX_CSIS;
+		else if (!strcmp(node->name, FIMC_LITE_OF_NODE_NAME))
+			plat_entity = IDX_FLITE;
+
+		if (plat_entity >= 0)
+			ret = fimc_md_register_platform_entity(fmd, pdev,
+							plat_entity);
+		put_device(&pdev->dev);
+		if (ret < 0)
+			break;
+	}
+
+	return ret;
+}
+#else
+#define fimc_md_register_platform_entities(fmd) (-ENOSYS)
+#endif
+
+static void fimc_md_unregister_entities(struct fimc_md *fmd)
+{
+	int i;
+
+	for (i = 0; i < FIMC_LITE_MAX_DEVS; i++) {
+		if (fmd->fimc_lite[i] == NULL)
+			continue;
+		v4l2_device_unregister_subdev(&fmd->fimc_lite[i]->subdev);
+		fmd->fimc_lite[i]->pipeline_ops = NULL;
+		fmd->fimc_lite[i] = NULL;
+	}
+	for (i = 0; i < CSIS_MAX_ENTITIES; i++) {
+		if (fmd->csis[i].sd == NULL)
+			continue;
+		v4l2_device_unregister_subdev(fmd->csis[i].sd);
+		module_put(fmd->csis[i].sd->owner);
+		fmd->csis[i].sd = NULL;
+	}
+	for (i = 0; i < fmd->num_sensors; i++) {
+		if (fmd->sensor[i].subdev == NULL)
+			continue;
+		fimc_md_unregister_sensor(fmd->sensor[i].subdev);
+		fmd->sensor[i].subdev = NULL;
+	}
+	v4l2_info(&fmd->v4l2_dev, "Unregistered all entities\n");
+}
+
+/**
+ * __fimc_md_create_fimc_links - create links to all FIMC entities
+ * @fmd: fimc media device
+ * @source: the source entity to create links to all fimc entities from
+ * @sensor: sensor subdev linked to FIMC[fimc_id] entity, may be null
+ * @pad: the source entity pad index
+ * @link_mask: bitmask of the fimc devices for which link should be enabled
+ */
+static int __fimc_md_create_fimc_sink_links(struct fimc_md *fmd,
+					    struct media_entity *source,
+					    struct v4l2_subdev *sensor,
+					    int pad, int link_mask)
+{
+	struct media_entity *sink;
+	unsigned int flags = 0;
+	int ret, i;
+
+	for (i = 0; i < FIMC_LITE_MAX_DEVS; i++) {
+		if (!fmd->fimc_lite[i])
+			continue;
+
+		flags = ((1 << i) & link_mask) ? MEDIA_LNK_FL_ENABLED : 0;
+		sink = &fmd->fimc_lite[i]->subdev.entity;
+		ret = media_entity_create_link(source, pad, sink,
+					       FLITE_SD_PAD_SINK, flags);
+		if (ret)
+			return ret;
+
+		/* Notify FIMC-LITE subdev entity */
+		ret = media_entity_call(sink, link_setup, &sink->pads[0],
+					&source->pads[pad], flags);
+		if (ret)
+			break;
+
+		v4l2_info(&fmd->v4l2_dev, "created link [%s] %c> [%s]\n",
+			  source->name, flags ? '=' : '-', sink->name);
+	}
+	return 0;
+}
+
+/**
+ * fimc_md_create_links - create default links between registered entities
+ *
+ * Parallel interface sensor entities are connected directly to FIMC capture
+ * entities. The sensors using MIPI CSIS bus are connected through immutable
+ * link with CSI receiver entity specified by mux_id. Any registered CSIS
+ * entity has a link to each registered FIMC capture entity. Enabled links
+ * are created by default between each subsequent registered sensor and
+ * subsequent FIMC capture entity. The number of default active links is
+ * determined by the number of available sensors or FIMC entities,
+ * whichever is less.
+ */
+static int fimc_md_create_links(struct fimc_md *fmd)
+{
+	struct v4l2_subdev *csi_sensors[CSIS_MAX_ENTITIES] = { NULL };
+	struct v4l2_subdev *sensor, *csis;
+	struct fimc_source_info *pdata;
+	struct fimc_sensor_info *s_info;
+	struct media_entity *source, *sink;
+	int i, pad, fimc_id = 0, ret = 0;
+	u32 flags, link_mask = 0;
+
+	for (i = 0; i < fmd->num_sensors; i++) {
+		if (fmd->sensor[i].subdev == NULL)
+			continue;
+
+		sensor = fmd->sensor[i].subdev;
+		s_info = v4l2_get_subdev_hostdata(sensor);
+		if (!s_info)
+			continue;
+
+		source = NULL;
+		pdata = &s_info->pdata;
+
+		switch (pdata->sensor_bus_type) {
+		case FIMC_BUS_TYPE_MIPI_CSI2:
+			if (WARN(pdata->mux_id >= CSIS_MAX_ENTITIES,
+				"Wrong CSI channel id: %d\n", pdata->mux_id))
+				return -EINVAL;
+
+			csis = fmd->csis[pdata->mux_id].sd;
+			if (WARN(csis == NULL,
+				 "MIPI-CSI interface specified "
+				 "but s5p-csis module is not loaded!\n"))
+				return -EINVAL;
+
+			pad = sensor->entity.num_pads - 1;
+			ret = media_entity_create_link(&sensor->entity, pad,
+					      &csis->entity, CSIS_PAD_SINK,
+					      MEDIA_LNK_FL_IMMUTABLE |
+					      MEDIA_LNK_FL_ENABLED);
+			if (ret)
+				return ret;
+
+			v4l2_info(&fmd->v4l2_dev, "created link [%s] => [%s]\n",
+				  sensor->entity.name, csis->entity.name);
+
+			source = NULL;
+			csi_sensors[pdata->mux_id] = sensor;
+			break;
+
+		case FIMC_BUS_TYPE_ITU_601...FIMC_BUS_TYPE_ITU_656:
+			source = &sensor->entity;
+			pad = 0;
+			break;
+
+		default:
+			v4l2_err(&fmd->v4l2_dev, "Wrong bus_type: %x\n",
+				 pdata->sensor_bus_type);
+			return -EINVAL;
+		}
+		if (source == NULL)
+			continue;
+
+		link_mask = 1 << fimc_id++;
+		ret = __fimc_md_create_fimc_sink_links(fmd, source, sensor,
+						       pad, link_mask);
+	}
+
+	for (i = 0; i < CSIS_MAX_ENTITIES; i++) {
+		if (fmd->csis[i].sd == NULL)
+			continue;
+		source = &fmd->csis[i].sd->entity;
+		pad = CSIS_PAD_SOURCE;
+		sensor = csi_sensors[i];
+
+		link_mask = 1 << fimc_id++;
+		ret = __fimc_md_create_fimc_sink_links(fmd, source, sensor,
+						       pad, link_mask);
+	}
+
+	/* Create immutable links b/w each FIMC-LITE's subdev and video node */
+	flags = MEDIA_LNK_FL_IMMUTABLE | MEDIA_LNK_FL_ENABLED;
+	for (i = 0; i < FIMC_LITE_MAX_DEVS; i++) {
+		if (!fmd->fimc_lite[i])
+			continue;
+		source = &fmd->fimc_lite[i]->subdev.entity;
+		sink = &fmd->fimc_lite[i]->vfd.entity;
+		ret = media_entity_create_link(source, FLITE_SD_PAD_SOURCE_DMA,
+					      sink, 0, flags);
+		if (ret)
+			break;
+	}
+
+	return 0;
+}
+
+/*
+ * The peripheral sensor clock management.
+ */
+static void fimc_md_put_clocks(struct fimc_md *fmd)
+{
+	int i = FIMC_MAX_CAMCLKS;
+
+	while (--i >= 0) {
+		if (IS_ERR(fmd->camclk[i].clock))
+			continue;
+		clk_unprepare(fmd->camclk[i].clock);
+		clk_put(fmd->camclk[i].clock);
+		fmd->camclk[i].clock = ERR_PTR(-EINVAL);
+	}
+}
+
+static int fimc_md_get_clocks(struct fimc_md *fmd)
+{
+	struct device *dev = NULL;
+	char clk_name[32];
+	struct clk *clock;
+	int ret, i;
+
+	for (i = 0; i < FIMC_MAX_CAMCLKS; i++)
+		fmd->camclk[i].clock = ERR_PTR(-EINVAL);
+
+	if (fmd->pdev->dev.of_node)
+		dev = &fmd->pdev->dev;
+
+	for (i = 0; i < FIMC_MAX_CAMCLKS; i++) {
+		snprintf(clk_name, sizeof(clk_name), "sclk_cam%u", i);
+		clock = clk_get(dev, clk_name);
+
+		if (IS_ERR(clock)) {
+			dev_err(&fmd->pdev->dev, "Failed to get clock: %s\n",
+								clk_name);
+			ret = PTR_ERR(clock);
+			break;
+		}
+		ret = clk_prepare(clock);
+		if (ret < 0) {
+			clk_put(clock);
+			fmd->camclk[i].clock = ERR_PTR(-EINVAL);
+			break;
+		}
+		fmd->camclk[i].clock = clock;
+	}
+	if (ret)
+		fimc_md_put_clocks(fmd);
+
+	return ret;
+}
+
+static int __fimc_md_set_camclk(struct fimc_md *fmd,
+				struct fimc_sensor_info *s_info,
+				bool on)
+{
+	struct fimc_source_info *pdata = &s_info->pdata;
+	struct fimc_camclk_info *camclk;
+	int ret = 0;
+
+	if (WARN_ON(pdata->clk_id >= FIMC_MAX_CAMCLKS) || fmd == NULL)
+		return -EINVAL;
+
+	camclk = &fmd->camclk[pdata->clk_id];
+
+	dbg("camclk %d, f: %lu, use_count: %d, on: %d",
+	    pdata->clk_id, pdata->clk_frequency, camclk->use_count, on);
+
+	if (on) {
+		if (camclk->use_count > 0 &&
+		    camclk->frequency != pdata->clk_frequency)
+			return -EINVAL;
+
+		if (camclk->use_count++ == 0) {
+			clk_set_rate(camclk->clock, pdata->clk_frequency);
+			camclk->frequency = pdata->clk_frequency;
+			ret = clk_enable(camclk->clock);
+			dbg("Enabled camclk %d: f: %lu", pdata->clk_id,
+			    clk_get_rate(camclk->clock));
+		}
+		return ret;
+	}
+
+	if (WARN_ON(camclk->use_count == 0))
+		return 0;
+
+	if (--camclk->use_count == 0) {
+		clk_disable(camclk->clock);
+		dbg("Disabled camclk %d", pdata->clk_id);
+	}
+
+	return ret;
+}
+
+/**
+ * fimc_md_set_camclk - peripheral sensor clock setup
+ * @sd: sensor subdev to configure sclk_cam clock for
+ * @on: 1 to enable or 0 to disable the clock
+ *
+ * There are 2 separate clock outputs available in the SoC for external
+ * image processors. These clocks are shared between all registered FIMC
+ * devices to which sensors can be attached, either directly or through
+ * the MIPI CSI receiver. The clock is allowed here to be used by
+ * multiple sensors concurrently if they use same frequency.
+ * This function should only be called when the graph mutex is held.
+ */
+static int fimc_md_set_camclk(struct v4l2_subdev *sd, bool on)
+{
+	struct fimc_sensor_info *s_info = v4l2_get_subdev_hostdata(sd);
+	struct fimc_md *fmd = entity_to_fimc_mdev(&sd->entity);
+
+	return __fimc_md_set_camclk(fmd, s_info, on);
+}
+
+static int fimc_md_link_notify(struct media_pad *source,
+			       struct media_pad *sink, u32 flags)
+{
+	struct fimc_lite *fimc_lite = NULL;
+	struct exynos_pipeline *pipeline;
+	struct exynos5_pipeline0 *p;
+	struct v4l2_subdev *sd;
+	struct mutex *lock;
+	int ret = 0;
+	int ref_count;
+
+	if (media_entity_type(sink->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
+		return 0;
+
+	sd = media_entity_to_v4l2_subdev(sink->entity);
+
+	switch (sd->grp_id) {
+	case GRP_ID_FLITE:
+		fimc_lite = v4l2_get_subdevdata(sd);
+		if (WARN_ON(fimc_lite == NULL))
+			return 0;
+		pipeline = &fimc_lite->pipeline;
+		lock = &fimc_lite->lock;
+		break;
+	default:
+		return 0;
+	}
+
+	p = (struct exynos5_pipeline0 *)pipeline->priv;
+	if (!p || !p->is_init)
+		return -EINVAL;
+
+	if (!(flags & MEDIA_LNK_FL_ENABLED)) {
+		int i;
+		mutex_lock(lock);
+		ret = __fimc_pipeline_close(pipeline);
+		for (i = 0; i < IDX_MAX; i++)
+			p->subdevs[i] = NULL;
+		mutex_unlock(lock);
+		return ret;
+	}
+	/*
+	 * Link activation. Enable power of pipeline elements only if the
+	 * pipeline is already in use, i.e. its video node is opened.
+	 * Recreate the controls destroyed during the link deactivation.
+	 */
+	mutex_lock(lock);
+
+	ref_count = fimc_lite->ref_count;
+	if (ref_count > 0)
+		ret = __fimc_pipeline_open(pipeline, source->entity, true);
+
+	mutex_unlock(lock);
+	return ret ? -EPIPE : ret;
+}
+
+static ssize_t fimc_md_sysfs_show(struct device *dev,
+				  struct device_attribute *attr, char *buf)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct fimc_md *fmd = platform_get_drvdata(pdev);
+
+	if (fmd->user_subdev_api)
+		return strlcpy(buf, "Sub-device API (sub-dev)\n", PAGE_SIZE);
+
+	return strlcpy(buf, "V4L2 video node only API (vid-dev)\n", PAGE_SIZE);
+}
+
+static ssize_t fimc_md_sysfs_store(struct device *dev,
+				   struct device_attribute *attr,
+				   const char *buf, size_t count)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct fimc_md *fmd = platform_get_drvdata(pdev);
+	bool subdev_api;
+	int i;
+
+	if (!strcmp(buf, "vid-dev\n"))
+		subdev_api = false;
+	else if (!strcmp(buf, "sub-dev\n"))
+		subdev_api = true;
+	else
+		return count;
+
+	fmd->user_subdev_api = subdev_api;
+	for (i = 0; i < FIMC_LITE_MAX_DEVS; i++)
+		if (fmd->fimc_lite[i])
+			fmd->fimc_lite[i]->user_subdev_api = subdev_api;
+
+	return count;
+}
+/*
+ * This device attribute is to select video pipeline configuration method.
+ * There are following valid values:
+ *  vid-dev - for V4L2 video node API only, subdevice will be configured
+ *  by the host driver.
+ *  sub-dev - for media controller API, subdevs must be configured in user
+ *  space before starting streaming.
+ */
+static DEVICE_ATTR(subdev_conf_mode, S_IWUSR | S_IRUGO,
+		   fimc_md_sysfs_show, fimc_md_sysfs_store);
+
+/**
+ * fimc_md_sensor_notify - v4l2_device notification from a sensor subdev
+ * @sd: pointer to a subdev generating the notification
+ * @notification: the notification type, must be S5P_FIMC_TX_END_NOTIFY
+ * @arg: pointer to an u32 type integer that stores the frame payload value
+ *
+ * Passes the sensor notification to the capture device
+ */
+static void fimc_md_sensor_notify(struct v4l2_subdev *sd,
+				unsigned int notification, void *arg)
+{
+	struct fimc_md *fmd;
+	struct exynos_pipeline *ep;
+	struct exynos5_pipeline0 *p;
+	unsigned long flags;
+
+	if (sd == NULL)
+		return;
+
+	ep = media_pipe_to_exynos_pipeline(sd->entity.pipe);
+	p = (struct exynos5_pipeline0 *)ep->priv;
+
+	spin_lock_irqsave(&fmd->slock, flags);
+
+	if (p->sensor_notify)
+		p->sensor_notify(sd, notification, arg);
+
+	spin_unlock_irqrestore(&fmd->slock, flags);
+}
+
+static int fimc_md_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct v4l2_device *v4l2_dev;
+	struct fimc_md *fmd;
+	int ret;
+
+	fmd = devm_kzalloc(dev, sizeof(*fmd), GFP_KERNEL);
+	if (!fmd)
+		return -ENOMEM;
+
+	spin_lock_init(&fmd->slock);
+	fmd->pdev = pdev;
+
+	strlcpy(fmd->media_dev.model, "SAMSUNG S5P FIMC",
+		sizeof(fmd->media_dev.model));
+	fmd->media_dev.link_notify = fimc_md_link_notify;
+	fmd->media_dev.dev = dev;
+
+	v4l2_dev = &fmd->v4l2_dev;
+	v4l2_dev->mdev = &fmd->media_dev;
+	v4l2_dev->notify = fimc_md_sensor_notify;
+	strlcpy(v4l2_dev->name, "s5p-fimc-md", sizeof(v4l2_dev->name));
+
+	ret = v4l2_device_register(dev, &fmd->v4l2_dev);
+	if (ret < 0) {
+		v4l2_err(v4l2_dev, "Failed to register v4l2_device: %d\n", ret);
+
+		return ret;
+
+	}
+	ret = media_device_register(&fmd->media_dev);
+	if (ret < 0) {
+		v4l2_err(v4l2_dev, "Failed to register media dev: %d\n", ret);
+		goto err_md;
+	}
+	ret = fimc_md_get_clocks(fmd);
+	if (ret)
+		goto err_clk;
+
+	fmd->user_subdev_api = (dev->of_node != NULL);
+	g_exynos_mdev = fmd;
+
+	/* Protect the media graph while we're registering entities */
+	mutex_lock(&fmd->media_dev.graph_mutex);
+
+	if (fmd->pdev->dev.of_node)
+		ret = fimc_md_register_of_platform_entities(fmd, dev->of_node);
+	else
+		ret = bus_for_each_dev(&platform_bus_type, NULL, fmd,
+						fimc_md_pdev_match);
+
+	if (ret)
+		goto err_unlock;
+
+	if (dev->platform_data || dev->of_node) {
+		ret = fimc_md_register_sensor_entities(fmd);
+		if (ret)
+			goto err_unlock;
+	}
+
+	ret = fimc_md_create_links(fmd);
+	if (ret)
+		goto err_unlock;
+
+	ret = v4l2_device_register_subdev_nodes(&fmd->v4l2_dev);
+	if (ret)
+		goto err_unlock;
+
+	ret = device_create_file(&pdev->dev, &dev_attr_subdev_conf_mode);
+	if (ret)
+		goto err_unlock;
+
+	platform_set_drvdata(pdev, fmd);
+	mutex_unlock(&fmd->media_dev.graph_mutex);
+	return 0;
+
+err_unlock:
+	mutex_unlock(&fmd->media_dev.graph_mutex);
+err_clk:
+	media_device_unregister(&fmd->media_dev);
+	fimc_md_put_clocks(fmd);
+	fimc_md_unregister_entities(fmd);
+err_md:
+	v4l2_device_unregister(&fmd->v4l2_dev);
+	return ret;
+}
+
+static int fimc_md_remove(struct platform_device *pdev)
+{
+	struct fimc_md *fmd = platform_get_drvdata(pdev);
+
+	if (!fmd)
+		return 0;
+	g_exynos_mdev = NULL;
+	device_remove_file(&pdev->dev, &dev_attr_subdev_conf_mode);
+	fimc_md_unregister_entities(fmd);
+	media_device_unregister(&fmd->media_dev);
+	fimc_md_put_clocks(fmd);
+	return 0;
+}
+
+static struct platform_device_id fimc_driver_ids[] __always_unused = {
+	{ .name = "exynos-fimc-md" },
+	{ },
+};
+MODULE_DEVICE_TABLE(platform, fimc_driver_ids);
+
+static const struct of_device_id fimc_md_of_match[] __initconst = {
+	{ .compatible = "samsung,exynos5-fimc" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, fimc_md_of_match);
+
+static struct platform_driver fimc_md_driver = {
+	.probe		= fimc_md_probe,
+	.remove		= fimc_md_remove,
+	.driver = {
+		.of_match_table = fimc_md_of_match,
+		.name		= "exynos-fimc-md",
+		.owner		= THIS_MODULE,
+	}
+};
+
+static int __init fimc_md_init(void)
+{
+	request_module("s5p-csis");
+	return platform_driver_register(&fimc_md_driver);
+}
+
+static void __exit fimc_md_exit(void)
+{
+	platform_driver_unregister(&fimc_md_driver);
+}
+
+module_init(fimc_md_init);
+module_exit(fimc_md_exit);
+
+MODULE_AUTHOR("Sylwester Nawrocki <s.nawrocki@samsung.com>");
+MODULE_AUTHOR("Shaik Ameer Basha <shaik.ameer@samsung.com>");
+MODULE_DESCRIPTION("EXYNOS5 FIMC camera host interface/video postprocessor driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/platform/exynos5-is/exynos5-mdev.h b/drivers/media/platform/exynos5-is/exynos5-mdev.h
new file mode 100644
index 0000000..de0ad11
--- /dev/null
+++ b/drivers/media/platform/exynos5-is/exynos5-mdev.h
@@ -0,0 +1,107 @@
+/*
+ * Copyright (C) 2011 - 2012 Samsung Electronics Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef EXYNOS5_MDEVICE_H_
+#define EXYNOS5_MDEVICE_H_
+
+#include <linux/clk.h>
+#include <linux/platform_device.h>
+#include <linux/mutex.h>
+#include <media/media-device.h>
+#include <media/media-entity.h>
+#include <media/s5p_fimc.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-subdev.h>
+
+#include "fimc-lite.h"
+#include "mipi-csis.h"
+
+#define FIMC_OF_NODE_NAME	"fimc"
+#define FIMC_LITE_OF_NODE_NAME	"fimc-lite"
+#define CSIS_OF_NODE_NAME	"csis"
+#define FIMC_IS_OF_NODE_NAME	"fimc-is"
+
+/* Group IDs of sensor, MIPI-CSIS, FIMC-LITE and the writeback subdevs. */
+#define GRP_ID_SENSOR		(1 << 8)
+#define GRP_ID_FIMC_IS_SENSOR	(1 << 9)
+#define GRP_ID_WRITEBACK	(1 << 10)
+#define GRP_ID_CSIS		(1 << 11)
+#define GRP_ID_FLITE		(1 << 13)
+#define GRP_ID_FIMC_IS		(1 << 14)
+
+#define FIMC_MAX_SENSORS	8
+#define FIMC_MAX_CAMCLKS	2
+
+enum fimc_subdev_index {
+	IDX_SENSOR,
+	IDX_CSIS,
+	IDX_FLITE,
+	IDX_FIMC,
+	IDX_MAX,
+};
+
+struct fimc_csis_info {
+	struct v4l2_subdev *sd;
+	int id;
+};
+
+struct fimc_camclk_info {
+	struct clk *clock;
+	int use_count;
+	unsigned long frequency;
+};
+
+/**
+ * struct fimc_md - fimc media device information
+ * @csis: MIPI CSIS subdevs data
+ * @sensor: array of registered sensor subdevs
+ * @num_sensors: actual number of registered sensors
+ * @camclk: external sensor clock information
+ * @fimc: array of registered fimc devices
+ * @media_dev: top level media device
+ * @v4l2_dev: top level v4l2_device holding up the subdevs
+ * @pdev: platform device this media device is hooked up into
+ * @user_subdev_api: true if subdevs are not configured by the host driver
+ * @slock: spinlock protecting @sensor array
+ */
+struct fimc_md {
+	struct fimc_csis_info csis[CSIS_MAX_ENTITIES];
+	struct fimc_sensor_info sensor[FIMC_MAX_SENSORS];
+	int num_sensors;
+	struct fimc_camclk_info camclk[FIMC_MAX_CAMCLKS];
+	struct fimc_lite *fimc_lite[FIMC_LITE_MAX_DEVS];
+	struct media_device media_dev;
+	struct v4l2_device v4l2_dev;
+	struct platform_device *pdev;
+	bool user_subdev_api;
+	spinlock_t slock;
+};
+
+struct exynos5_pipeline0 {
+	int is_init;
+	struct fimc_md *fmd;
+	struct v4l2_subdev *subdevs[IDX_MAX];
+	void (*sensor_notify)(struct v4l2_subdev *sd,
+			unsigned int notification, void *arg);
+};
+
+#define is_subdev_pad(pad) (pad == NULL || \
+	media_entity_type(pad->entity) == MEDIA_ENT_T_V4L2_SUBDEV)
+
+#define me_subtype(me) \
+	((me->type) & (MEDIA_ENT_TYPE_MASK | MEDIA_ENT_SUBTYPE_MASK))
+
+#define subdev_has_devnode(__sd) (__sd->flags & V4L2_SUBDEV_FL_HAS_DEVNODE)
+
+static inline struct fimc_md *entity_to_fimc_mdev(struct media_entity *me)
+{
+	return me->parent == NULL ? NULL :
+		container_of(me->parent, struct fimc_md, media_dev);
+}
+
+#endif /* EXYNOS5_MDEVICE_H_ */
-- 
1.7.9.5

