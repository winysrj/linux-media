Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:56312 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420Ab3HBPCq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Aug 2013 11:02:46 -0400
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree@vger.kernel.org
Cc: s.nawrocki@samsung.com, hverkuil@xs4all.nl, a.hajda@samsung.com,
	sachin.kamat@linaro.org, shaik.ameer@samsung.com,
	kilyeon.im@samsung.com, arunkk.samsung@gmail.com
Subject: [RFC v3 01/13] [media] exynos5-is: Adding media device driver for exynos5
Date: Fri,  2 Aug 2013 20:32:30 +0530
Message-Id: <1375455762-22071-2-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1375455762-22071-1-git-send-email-arun.kk@samsung.com>
References: <1375455762-22071-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Shaik Ameer Basha <shaik.ameer@samsung.com>

This patch adds support for media device for EXYNOS5 SoCs.
The current media device supports the following ips to connect
through the media controller framework.

* MIPI-CSIS
  Support interconnection(subdev interface) between devices

* FIMC-LITE
  Support capture interface from device(Sensor, MIPI-CSIS) to memory
  Support interconnection(subdev interface) between devices

* FIMC-IS
  Camera post-processing IP having multiple sub-nodes.

G-Scaler will be added later to the current media device.

The media device creates two kinds of pipelines for connecting
the above mentioned IPs.
The pipeline0 is uses Sensor, MIPI-CSIS and FIMC-LITE which captures
image data and dumps to memory.
Pipeline1 uses FIMC-IS components for doing post-processing
operations on the captured image and give scaled YUV output.

Pipeline0
  +--------+     +-----------+     +-----------+     +--------+
  | Sensor | --> | MIPI-CSIS | --> | FIMC-LITE | --> | Memory |
  +--------+     +-----------+     +-----------+     +--------+

Pipeline1
 +--------+      +--------+     +-----------+     +-----------+
 | Memory | -->  |  ISP   | --> |    SCC    | --> |    SCP    |
 +--------+      +--------+     +-----------+     +-----------+

Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
 .../devicetree/bindings/media/exynos5-mdev.txt     |  153 ++
 drivers/media/platform/exynos5-is/exynos5-mdev.c   | 1471 ++++++++++++++++++++
 drivers/media/platform/exynos5-is/exynos5-mdev.h   |  199 +++
 3 files changed, 1823 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/exynos5-mdev.txt
 create mode 100644 drivers/media/platform/exynos5-is/exynos5-mdev.c
 create mode 100644 drivers/media/platform/exynos5-is/exynos5-mdev.h

diff --git a/Documentation/devicetree/bindings/media/exynos5-mdev.txt b/Documentation/devicetree/bindings/media/exynos5-mdev.txt
new file mode 100644
index 0000000..d7d419b
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/exynos5-mdev.txt
@@ -0,0 +1,153 @@
+Samsung EXYNOS5 SoC Camera Subsystem (FIMC)
+----------------------------------------------
+
+The Exynos5 SoC Camera subsystem comprises of multiple sub-devices
+represented by separate device tree nodes. Currently this includes: FIMC-LITE,
+MIPI CSIS and FIMC-IS.
+
+The sub-subdevices are defined as child nodes of the common 'camera' node which
+also includes common properties of the whole subsystem not really specific to
+any single sub-device, like common camera port pins or the CAMCLK clock outputs
+for external image sensors attached to an SoC.
+
+Common 'camera' node
+--------------------
+
+Required properties:
+
+- compatible	: must be "samsung,exynos5-fimc", "simple-bus"
+- clocks	: list of clock specifiers, corresponding to entries in
+		  the clock-names property;
+- clock-names	: must contain "sclk_cam0", "sclk_cam1" entries,
+		  matching entries in the clocks property.
+
+The pinctrl bindings defined in ../pinctrl/pinctrl-bindings.txt must be used
+to define a required pinctrl state named "default" and optional pinctrl states:
+"idle", "active-a", active-b". These optional states can be used to switch the
+camera port pinmux at runtime. The "idle" state should configure both the camera
+ports A and B into high impedance state, especially the CAMCLK clock output
+should be inactive. For the "active-a" state the camera port A must be activated
+and the port B deactivated and for the state "active-b" it should be the other
+way around.
+
+The 'camera' node must include at least one 'fimc-lite' child node.
+
+'parallel-ports' node
+---------------------
+
+This node should contain child 'port' nodes specifying active parallel video
+input ports. It includes camera A and camera B inputs. 'reg' property in the
+port nodes specifies data input - 0, 1 indicates input A, B respectively.
+
+Optional properties
+
+- samsung,camclk-out : specifies clock output for remote sensor,
+		       0 - CAM_A_CLKOUT, 1 - CAM_B_CLKOUT;
+
+Image sensor nodes
+------------------
+
+The sensor device nodes should be added to their control bus controller (e.g.
+I2C0) nodes and linked to a port node in the csis or the parallel-ports node,
+using the common video interfaces bindings, defined in video-interfaces.txt.
+The implementation of this bindings requires clock-frequency property to be
+present in the sensor device nodes.
+
+Example:
+
+	aliases {
+		fimc-lite0 = &fimc_lite_0
+	};
+
+	/* Parallel bus IF sensor */
+	i2c_0: i2c@13860000 {
+		s5k6aa: sensor@3c {
+			compatible = "samsung,s5k6aafx";
+			reg = <0x3c>;
+			vddio-supply = <...>;
+
+			clock-frequency = <24000000>;
+			clocks = <...>;
+			clock-names = "mclk";
+
+			port {
+				s5k6aa_ep: endpoint {
+					remote-endpoint = <&fimc0_ep>;
+					bus-width = <8>;
+					hsync-active = <0>;
+					vsync-active = <1>;
+					pclk-sample = <1>;
+				};
+			};
+		};
+	};
+
+	/* MIPI CSI-2 bus IF sensor */
+	s5c73m3: sensor@0x1a {
+		compatible = "samsung,s5c73m3";
+		reg = <0x1a>;
+		vddio-supply = <...>;
+
+		clock-frequency = <24000000>;
+		clocks = <...>;
+		clock-names = "mclk";
+
+		port {
+			s5c73m3_1: endpoint {
+				data-lanes = <1 2 3 4>;
+				remote-endpoint = <&csis0_ep>;
+			};
+		};
+	};
+
+	camera {
+		compatible = "samsung,exynos5-fimc", "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		status = "okay";
+
+		pinctrl-names = "default";
+		pinctrl-0 = <&cam_port_a_clk_active>;
+
+		/* parallel camera ports */
+		parallel-ports {
+			/* camera A input */
+			port@0 {
+				reg = <0>;
+				fimc0_ep: endpoint {
+					remote-endpoint = <&s5k6aa_ep>;
+					bus-width = <8>;
+					hsync-active = <0>;
+					vsync-active = <1>;
+					pclk-sample = <1>;
+				};
+			};
+		};
+
+		fimc_lite_0: fimc-lite@13C00000 {
+			compatible = "samsung,exynos5250-fimc-lite";
+			reg = <0x13C00000 0x1000>;
+			interrupts = <0 126 0>;
+			clocks = <&clock 129>;
+			clock-names = "flite";
+			status = "okay";
+		};
+
+		csis_0: csis@11880000 {
+			compatible = "samsung,exynos4210-csis";
+			reg = <0x11880000 0x1000>;
+			interrupts = <0 78 0>;
+			/* camera C input */
+			port@3 {
+				reg = <3>;
+				csis0_ep: endpoint {
+					remote-endpoint = <&s5c73m3_ep>;
+					data-lanes = <1 2 3 4>;
+					samsung,csis-hs-settle = <12>;
+				};
+			};
+		};
+	};
+
+MIPI-CSIS device binding is defined in samsung-mipi-csis.txt and FIMC-LITE
+device binding is defined in exynos-fimc-lite.txt.
diff --git a/drivers/media/platform/exynos5-is/exynos5-mdev.c b/drivers/media/platform/exynos5-is/exynos5-mdev.c
new file mode 100644
index 0000000..b59738f
--- /dev/null
+++ b/drivers/media/platform/exynos5-is/exynos5-mdev.c
@@ -0,0 +1,1471 @@
+/*
+ * EXYNOS5 SoC series camera host interface media device driver
+ *
+ * Copyright (C) 2013 Samsung Electronics Co., Ltd.
+ * Shaik Ameer Basha <shaik.ameer@samsung.com>
+ * Arun Kumar K <arun.kk@samsung.com>
+ *
+ * This driver is based on exynos4-is media device driver developed by
+ * Sylwester Nawrocki <s.nawrocki@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundation, either version 2 of the License,
+ * or (at your option) any later version.
+ */
+
+#include <linux/bug.h>
+#include <linux/clk.h>
+#include <linux/clk-provider.h>
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
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+#include <linux/types.h>
+#include <linux/slab.h>
+#include <media/v4l2-async.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-of.h>
+#include <media/media-device.h>
+#include <media/s5p_fimc.h>
+
+#include "exynos5-mdev.h"
+#include "fimc-is.h"
+
+#define dbg(fmt, args...) \
+	pr_debug("%s:%d: " fmt "\n", __func__, __LINE__, ##args)
+
+static int __fimc_md_set_camclk(struct fimc_md *fmd,
+				struct fimc_source_info *si,
+				bool on);
+
+/**
+ * fimc_pipeline_prepare - update pipeline information with subdevice pointers
+ * @me: media entity terminating the pipeline
+ *
+ * Caller holds the graph mutex.
+ */
+static void fimc_pipeline_prepare(struct fimc_pipeline *p,
+				  struct media_entity *me)
+{
+	struct v4l2_subdev *sd;
+	int i;
+
+	for (i = 0; i < IDX_MAX; i++)
+		p->subdevs[i] = NULL;
+
+	while (1) {
+		struct media_pad *pad = NULL;
+
+		/* Find remote source pad */
+		for (i = 0; i < me->num_pads; i++) {
+			struct media_pad *spad = &me->pads[i];
+			if (!(spad->flags & MEDIA_PAD_FL_SINK))
+				continue;
+			pad = media_entity_remote_pad(spad);
+			if (pad)
+				break;
+		}
+
+		if (pad == NULL ||
+		    media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV) {
+			break;
+		}
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
+		me = &sd->entity;
+		if (me->num_pads == 1)
+			break;
+	}
+
+	/* For using FIMC-IS firmware controlled sensors, ISP subdev
+	 * has to be initialized along with pipeline0 devices.
+	 * So an ISP subdev from a free ISP pipeline is assigned to
+	 * this pipeline
+	 */
+	if (p->subdevs[IDX_SENSOR]->grp_id == GRP_ID_FIMC_IS_SENSOR) {
+		struct fimc_pipeline_isp *p_isp;
+
+		list_for_each_entry(p_isp, p->isp_pipelines, list) {
+			if (!p_isp->in_use) {
+				p->subdevs[IDX_FIMC_IS] =
+					p_isp->subdevs[IDX_ISP];
+				p_isp->in_use = true;
+				break;
+			}
+		}
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
+static int fimc_pipeline_s_power(struct fimc_pipeline *p, bool state)
+{
+	unsigned int i;
+	int ret;
+	struct fimc_is_isp *isp_dev;
+
+	if (p->subdevs[IDX_SENSOR] == NULL)
+		return -ENXIO;
+
+	/* If sensor is firmware controlled IS-sensor,
+	 * set sensor sd to isp context
+	 */
+	if (p->subdevs[IDX_FIMC_IS]) {
+		isp_dev = v4l2_get_subdevdata(p->subdevs[IDX_FIMC_IS]);
+		isp_dev->sensor_sd = p->subdevs[IDX_SENSOR];
+	}
+
+	for (i = 0; i < IDX_MAX; i++) {
+		unsigned int idx = state ? i : (IDX_MAX - 1) - i;
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
+	struct fimc_source_info *si = v4l2_get_subdev_hostdata(sd);
+	struct fimc_md *fmd = entity_to_fimc_mdev(&sd->entity);
+
+	return __fimc_md_set_camclk(fmd, si, on);
+}
+
+/**
+ * __fimc_pipeline_open - update the pipeline information, enable power
+ *                        of all pipeline subdevs and the sensor clock
+ * @me: media entity to start graph walk with
+ * @prepare: true to walk the current pipeline and acquire all subdevs
+ *
+ * Called with the graph mutex held.
+ */
+static int __fimc_pipeline_open(struct exynos_media_pipeline *ep,
+				struct media_entity *me, bool prepare)
+{
+	struct fimc_pipeline *p = to_fimc_pipeline(ep);
+	struct v4l2_subdev *sd;
+	int ret;
+
+	if (WARN_ON(p == NULL || me == NULL))
+		return -EINVAL;
+
+	if (prepare)
+		fimc_pipeline_prepare(p, me);
+
+	sd = p->subdevs[IDX_SENSOR];
+	if (sd == NULL)
+		return -EINVAL;
+
+	ret = fimc_md_set_camclk(sd, true);
+	if (ret < 0)
+		return ret;
+
+	ret = fimc_pipeline_s_power(p, 1);
+	if (!ret)
+		return 0;
+
+	fimc_md_set_camclk(sd, false);
+	return ret;
+}
+
+/**
+ * __fimc_pipeline_close - disable the sensor clock and pipeline power
+ * @fimc: fimc device terminating the pipeline
+ *
+ * Disable power of all subdevs and turn the external sensor clock off.
+ */
+static int __fimc_pipeline_close(struct exynos_media_pipeline *ep)
+{
+	struct fimc_pipeline *p = to_fimc_pipeline(ep);
+	struct v4l2_subdev *sd = p ? p->subdevs[IDX_SENSOR] : NULL;
+	int ret = 0;
+
+	if (WARN_ON(sd == NULL))
+		return -EINVAL;
+
+	if (p->subdevs[IDX_SENSOR]) {
+		ret = fimc_pipeline_s_power(p, 0);
+		fimc_md_set_camclk(sd, false);
+	}
+
+	if (p->subdevs[IDX_SENSOR]->grp_id == GRP_ID_FIMC_IS_SENSOR) {
+		struct fimc_pipeline_isp *p_isp;
+
+		list_for_each_entry(p_isp, p->isp_pipelines, list) {
+			if (p_isp->subdevs[IDX_ISP] ==
+					p->subdevs[IDX_FIMC_IS]) {
+				p->subdevs[IDX_FIMC_IS] = NULL;
+				p_isp->in_use = false;
+				break;
+			}
+		}
+	}
+	return ret == -ENXIO ? 0 : ret;
+}
+
+/**
+ * __fimc_pipeline_s_stream - call s_stream() on pipeline subdevs
+ * @pipeline: video pipeline structure
+ * @on: passed as the s_stream() callback argument
+ */
+static int __fimc_pipeline_s_stream(struct exynos_media_pipeline *ep, bool on)
+{
+	struct fimc_pipeline *p = to_fimc_pipeline(ep);
+	int i, ret;
+
+	if (p->subdevs[IDX_SENSOR] == NULL)
+		return -ENODEV;
+
+	for (i = 0; i < IDX_MAX; i++) {
+		unsigned int idx = on ? i : (IDX_MAX - 1) - i;
+
+		ret = v4l2_subdev_call(p->subdevs[idx], video, s_stream, on);
+
+		if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
+			return ret;
+	}
+	return 0;
+}
+
+/* Media pipeline operations for the FIMC/FIMC-LITE video device driver */
+static const struct exynos_media_pipeline_ops exynos5_pipeline0_ops = {
+	.open		= __fimc_pipeline_open,
+	.close		= __fimc_pipeline_close,
+	.set_stream	= __fimc_pipeline_s_stream,
+};
+
+static struct exynos_media_pipeline *fimc_md_pipeline_create(
+						struct fimc_md *fmd)
+{
+	struct fimc_pipeline *p;
+
+	p = kzalloc(sizeof(*p), GFP_KERNEL);
+	if (!p)
+		return NULL;
+
+	list_add_tail(&p->list, &fmd->pipelines);
+
+	p->isp_pipelines = &fmd->isp_pipelines;
+	p->ep.ops = &exynos5_pipeline0_ops;
+	return &p->ep;
+}
+
+static struct exynos_media_pipeline *fimc_md_isp_pipeline_create(
+						struct fimc_md *fmd)
+{
+	struct fimc_pipeline_isp *p;
+
+	p = kzalloc(sizeof(*p), GFP_KERNEL);
+	if (!p)
+		return NULL;
+
+	list_add_tail(&p->list, &fmd->isp_pipelines);
+
+	p->in_use = false;
+	return &p->ep;
+}
+
+static void fimc_md_pipelines_free(struct fimc_md *fmd)
+{
+	while (!list_empty(&fmd->pipelines)) {
+		struct fimc_pipeline *p;
+
+		p = list_entry(fmd->pipelines.next, typeof(*p), list);
+		list_del(&p->list);
+		kfree(p);
+	}
+	while (!list_empty(&fmd->isp_pipelines)) {
+		struct fimc_pipeline_isp *p;
+
+		p = list_entry(fmd->isp_pipelines.next, typeof(*p), list);
+		list_del(&p->list);
+		kfree(p);
+	}
+}
+
+/*
+ * Sensor subdevice helper functions
+ */
+static void fimc_md_unregister_sensor(struct v4l2_subdev *sd)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct i2c_adapter *adapter;
+
+	if (!client)
+		return;
+
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
+/* Parse port node and register as a sub-device any sensor specified there. */
+static int fimc_md_parse_port_node(struct fimc_md *fmd,
+				   struct device_node *port,
+				   unsigned int index)
+{
+	struct device_node *rem, *ep, *np;
+	struct fimc_source_info *pd;
+	struct v4l2_of_endpoint endpoint;
+	u32 val;
+
+	pd = &fmd->sensor[index].pdata;
+
+	/* Assume here a port node can have only one endpoint node. */
+	ep = of_get_next_child(port, NULL);
+	if (!ep)
+		return 0;
+
+	v4l2_of_parse_endpoint(ep, &endpoint);
+	if (WARN_ON(endpoint.port == 0) || index >= FIMC_MAX_SENSORS)
+		return -EINVAL;
+
+	pd->mux_id = (endpoint.port - 1) & 0x1;
+
+	rem = v4l2_of_get_remote_port_parent(ep);
+	of_node_put(ep);
+	if (rem == NULL) {
+		v4l2_info(&fmd->v4l2_dev, "Remote device at %s not found\n",
+							ep->full_name);
+		return 0;
+	}
+	if (!of_property_read_u32(rem, "samsung,camclk-out", &val))
+		pd->clk_id = val;
+
+	if (!of_property_read_u32(rem, "clock-frequency", &val))
+		pd->clk_frequency = val;
+
+	if (pd->clk_frequency == 0) {
+		v4l2_err(&fmd->v4l2_dev, "Wrong clock frequency at node %s\n",
+			 rem->full_name);
+		of_node_put(rem);
+		return -EINVAL;
+	}
+
+	if (fimc_input_is_parallel(endpoint.port)) {
+		if (endpoint.bus_type == V4L2_MBUS_PARALLEL)
+			pd->sensor_bus_type = FIMC_BUS_TYPE_ITU_601;
+		else
+			pd->sensor_bus_type = FIMC_BUS_TYPE_ITU_656;
+		pd->flags = endpoint.bus.parallel.flags;
+	} else if (fimc_input_is_mipi_csi(endpoint.port)) {
+		/*
+		 * MIPI CSI-2: only input mux selection and
+		 * the sensor's clock frequency is needed.
+		 */
+		pd->sensor_bus_type = FIMC_BUS_TYPE_MIPI_CSI2;
+	} else {
+		v4l2_err(&fmd->v4l2_dev, "Wrong port id (%u) at node %s\n",
+			 endpoint.port, rem->full_name);
+	}
+
+	np = of_get_parent(rem);
+
+	if (np && !of_node_cmp(np->name, "i2c-isp"))
+		pd->fimc_bus_type = FIMC_BUS_TYPE_ISP_WRITEBACK;
+	else
+		pd->fimc_bus_type = pd->sensor_bus_type;
+
+	if (WARN_ON(index >= ARRAY_SIZE(fmd->sensor)))
+		return -EINVAL;
+
+	fmd->sensor[index].asd.match_type = V4L2_ASYNC_MATCH_OF;
+	fmd->sensor[index].asd.match.of.node = rem;
+	fmd->async_subdevs[index] = &fmd->sensor[index].asd;
+
+	fmd->num_sensors++;
+
+	of_node_put(rem);
+	return 0;
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
+
+static int __of_get_csis_id(struct device_node *np)
+{
+	u32 reg = 0;
+
+	np = of_get_child_by_name(np, "port");
+	if (!np)
+		return -EINVAL;
+	of_property_read_u32(np, "reg", &reg);
+	return reg - FIMC_INPUT_MIPI_CSI2_0;
+}
+#else
+#define fimc_md_of_sensors_register(fmd, np) (-ENOSYS)
+#define __of_get_csis_id(np) (-ENOSYS)
+#endif
+
+static int fimc_md_register_sensor_entities(struct fimc_md *fmd)
+{
+	struct device_node *of_node = fmd->pdev->dev.of_node;
+	int ret;
+
+	/*
+	 * Runtime resume one of the FIMC entities to make sure
+	 * the sclk_cam clocks are not globally disabled.
+	 */
+	if (!fmd->pmf)
+		return -ENXIO;
+
+	ret = pm_runtime_get_sync(fmd->pmf);
+	if (ret < 0)
+		return ret;
+
+	fmd->num_sensors = 0;
+	ret = fimc_md_of_sensors_register(fmd, of_node);
+
+	pm_runtime_put(fmd->pmf);
+	return ret;
+}
+
+/*
+ * MIPI-CSIS, FIMC-IS and FIMC-LITE platform devices registration.
+ */
+
+static int register_fimc_lite_entity(struct fimc_md *fmd,
+				     struct fimc_lite *fimc_lite)
+{
+	struct v4l2_subdev *sd;
+	struct exynos_media_pipeline *ep;
+	int ret;
+
+	if (WARN_ON(fimc_lite->index >= FIMC_LITE_MAX_DEVS ||
+		    fmd->fimc_lite[fimc_lite->index]))
+		return -EBUSY;
+
+	sd = &fimc_lite->subdev;
+	sd->grp_id = GRP_ID_FLITE;
+
+	ep = fimc_md_pipeline_create(fmd);
+	if (!ep)
+		return -ENOMEM;
+
+	v4l2_set_subdev_hostdata(sd, ep);
+
+	ret = v4l2_device_register_subdev(&fmd->v4l2_dev, sd);
+	if (!ret) {
+		fmd->fimc_lite[fimc_lite->index] = fimc_lite;
+		if (!fmd->pmf && fimc_lite->pdev)
+			fmd->pmf = &fimc_lite->pdev->dev;
+	} else {
+		v4l2_err(&fmd->v4l2_dev, "Failed to register FIMC.LITE%d\n",
+			 fimc_lite->index);
+	}
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
+	id = node ? __of_get_csis_id(node) : max(0, pdev->id);
+
+	if (WARN_ON(id < 0 || id >= CSIS_MAX_ENTITIES))
+		return -ENOENT;
+
+	if (WARN_ON(fmd->csis[id].sd))
+		return -EBUSY;
+
+	sd->grp_id = GRP_ID_CSIS;
+	ret = v4l2_device_register_subdev(&fmd->v4l2_dev, sd);
+	if (!ret)
+		fmd->csis[id].sd = sd;
+	else
+		v4l2_err(&fmd->v4l2_dev,
+			 "Failed to register MIPI-CSIS.%d (%d)\n", id, ret);
+	return ret;
+}
+
+static int register_fimc_is_entity(struct fimc_md *fmd,
+				     struct fimc_is *is)
+{
+	struct v4l2_subdev *isp, *scc, *scp;
+	struct exynos_media_pipeline *ep;
+	struct fimc_pipeline_isp *p;
+	struct video_device *vdev;
+	int ret, i;
+
+	for (i = 0; i < is->num_instance; i++) {
+		isp = fimc_is_isp_get_sd(is, i);
+		scc = fimc_is_scc_get_sd(is, i);
+		scp = fimc_is_scp_get_sd(is, i);
+		isp->grp_id = GRP_ID_FIMC_IS;
+		scc->grp_id = GRP_ID_FIMC_IS;
+		scp->grp_id = GRP_ID_FIMC_IS;
+
+		ep = fimc_md_isp_pipeline_create(fmd);
+		if (!ep)
+			return -ENOMEM;
+
+		v4l2_set_subdev_hostdata(isp, ep);
+		v4l2_set_subdev_hostdata(scc, ep);
+		v4l2_set_subdev_hostdata(scp, ep);
+
+		ret = v4l2_device_register_subdev(&fmd->v4l2_dev, isp);
+		if (ret)
+			v4l2_err(&fmd->v4l2_dev,
+					"Failed to register ISP subdev\n");
+
+		ret = v4l2_device_register_subdev(&fmd->v4l2_dev, scc);
+		if (ret)
+			v4l2_err(&fmd->v4l2_dev,
+					"Failed to register SCC subdev\n");
+
+		ret = v4l2_device_register_subdev(&fmd->v4l2_dev, scp);
+		if (ret)
+			v4l2_err(&fmd->v4l2_dev,
+					"Failed to register SCP subdev\n");
+
+		p = to_fimc_isp_pipeline(ep);
+		p->subdevs[IDX_ISP] = isp;
+		p->subdevs[IDX_SCC] = scc;
+		p->subdevs[IDX_SCP] = scp;
+
+		/* Create default links */
+		/* vdev -> ISP */
+		vdev = fimc_is_isp_get_vfd(is, i);
+		ret = media_entity_create_link(&isp->entity,
+					ISP_SD_PAD_SINK_DMA,
+					&vdev->entity, 0,
+					MEDIA_LNK_FL_IMMUTABLE |
+					MEDIA_LNK_FL_ENABLED);
+		if (ret)
+			return ret;
+
+		/* ISP -> SCC */
+		ret = media_entity_create_link(&isp->entity,
+					ISP_SD_PAD_SRC,
+					&scc->entity, SCALER_SD_PAD_SINK,
+					MEDIA_LNK_FL_IMMUTABLE |
+					MEDIA_LNK_FL_ENABLED);
+		if (ret)
+			return ret;
+
+		/* SCC -> SCP */
+		ret = media_entity_create_link(&scc->entity,
+					SCALER_SD_PAD_SRC_FIFO,
+					&scp->entity, SCALER_SD_PAD_SINK,
+					MEDIA_LNK_FL_IMMUTABLE |
+					MEDIA_LNK_FL_ENABLED);
+		if (ret)
+			return ret;
+
+		/* SCC -> vdev */
+		vdev = fimc_is_scc_get_vfd(is, i);
+		ret = media_entity_create_link(&scc->entity,
+					SCALER_SD_PAD_SRC_DMA,
+					&vdev->entity, 0,
+					MEDIA_LNK_FL_IMMUTABLE |
+					MEDIA_LNK_FL_ENABLED);
+		if (ret)
+			return ret;
+
+		/* SCP -> vdev */
+		vdev = fimc_is_scp_get_vfd(is, i);
+		ret = media_entity_create_link(&scp->entity,
+					SCALER_SD_PAD_SRC_DMA,
+					&vdev->entity, 0,
+					MEDIA_LNK_FL_IMMUTABLE |
+					MEDIA_LNK_FL_ENABLED);
+		if (ret)
+			return ret;
+	}
+	fmd->is = is;
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
+		case IDX_FIMC_IS:
+			ret = register_fimc_is_entity(fmd, drvdata);
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
+/* Register FIMC, FIMC-LITE and CSIS media entities */
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
+		else if (!strcmp(node->name, FIMC_IS_OF_NODE_NAME))
+			plat_entity = IDX_FIMC_IS;
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
+
+static void fimc_md_unregister_entities(struct fimc_md *fmd)
+{
+	int i;
+	struct fimc_is *is;
+
+	for (i = 0; i < FIMC_LITE_MAX_DEVS; i++) {
+		if (fmd->fimc_lite[i] == NULL)
+			continue;
+		v4l2_device_unregister_subdev(&fmd->fimc_lite[i]->subdev);
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
+
+	if (!fmd->is)
+		return;
+	/* Unregistering FIMC-IS entities */
+	is = fmd->is;
+	for (i = 0; i < is->num_instance; i++) {
+		struct v4l2_subdev *isp, *scc, *scp;
+
+		isp = fimc_is_isp_get_sd(is, i);
+		scc = fimc_is_scc_get_sd(is, i);
+		scp = fimc_is_scp_get_sd(is, i);
+		v4l2_device_unregister_subdev(isp);
+		v4l2_device_unregister_subdev(scc);
+		v4l2_device_unregister_subdev(scp);
+	}
+
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
+	struct fimc_source_info *si = NULL;
+	struct media_entity *sink;
+	unsigned int flags = 0;
+	int i, ret = 0;
+
+	if (sensor) {
+		si = v4l2_get_subdev_hostdata(sensor);
+		/* Skip direct FIMC links in the logical FIMC-IS sensor path */
+		if (si && si->fimc_bus_type == FIMC_BUS_TYPE_ISP_WRITEBACK)
+			ret = 1;
+	}
+
+	for (i = 0; i < FIMC_LITE_MAX_DEVS; i++) {
+		if (!fmd->fimc_lite[i])
+			continue;
+
+		flags = ((1 << i) & link_mask) ? MEDIA_LNK_FL_ENABLED : 0;
+
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
+		v4l2_info(&fmd->v4l2_dev, "created link [%s] -> [%s]\n",
+			  source->name, sink->name);
+	}
+	return 0;
+}
+
+/* Create links from FIMC-LITE source pads to other entities */
+static int __fimc_md_create_flite_source_links(struct fimc_md *fmd)
+{
+	struct media_entity *source, *sink;
+	int i, ret = 0;
+
+	for (i = 0; i < FIMC_LITE_MAX_DEVS; i++) {
+		struct fimc_lite *fimc = fmd->fimc_lite[i];
+
+		if (fimc == NULL)
+			continue;
+
+		source = &fimc->subdev.entity;
+		sink = &fimc->ve.vdev.entity;
+		/* FIMC-LITE's subdev and video node */
+		ret = media_entity_create_link(source, FLITE_SD_PAD_SOURCE_DMA,
+					       sink, 0,
+					       MEDIA_LNK_FL_IMMUTABLE |
+					       MEDIA_LNK_FL_ENABLED);
+		if (ret)
+			break;
+	}
+
+	return ret;
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
+	struct media_entity *source;
+	int i, pad, fimc_id = 0, ret = 0;
+	u32 flags, link_mask = 0;
+
+	for (i = 0; i < fmd->num_sensors; i++) {
+		if (fmd->sensor[i].subdev == NULL)
+			continue;
+
+		sensor = fmd->sensor[i].subdev;
+		pdata = v4l2_get_subdev_hostdata(sensor);
+		if (!pdata)
+			continue;
+
+		source = NULL;
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
+
+		source = &fmd->csis[i].sd->entity;
+		pad = CSIS_PAD_SOURCE;
+		sensor = csi_sensors[i];
+
+		link_mask = 1 << fimc_id++;
+		ret = __fimc_md_create_fimc_sink_links(fmd, source, sensor,
+						       pad, link_mask);
+	}
+
+	/* Create immutable links between each FIMC's subdev and video node */
+	flags = MEDIA_LNK_FL_IMMUTABLE | MEDIA_LNK_FL_ENABLED;
+
+	ret = __fimc_md_create_flite_source_links(fmd);
+	if (ret < 0)
+		return ret;
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
+	int i, ret = 0;
+
+	for (i = 0; i < FIMC_MAX_CAMCLKS; i++)
+		fmd->camclk[i].clock = ERR_PTR(-EINVAL);
+
+	if (fmd->pdev->dev.of_node)
+		dev = &fmd->pdev->dev;
+
+	for (i = 0; i < SCLK_BAYER; i++) {
+		snprintf(clk_name, sizeof(clk_name), "sclk_cam%u", i);
+		clock = clk_get(dev, clk_name);
+
+		if (IS_ERR(clock)) {
+			dev_err(&fmd->pdev->dev, "Failed to get clock: %s\n",
+								clk_name);
+			ret = PTR_ERR(clock);
+			break;
+		}
+		fmd->camclk[i].clock = clock;
+	}
+	if (ret)
+		fimc_md_put_clocks(fmd);
+
+	/* Prepare bayer clk */
+	clock = clk_get(dev, "sclk_bayer");
+
+	if (IS_ERR(clock)) {
+		dev_err(&fmd->pdev->dev, "Failed to get clock: %s\n",
+							clk_name);
+		ret = PTR_ERR(clock);
+		goto err_exit;
+	}
+	ret = clk_prepare(clock);
+	if (ret < 0) {
+		clk_put(clock);
+		fmd->camclk[SCLK_BAYER].clock = ERR_PTR(-EINVAL);
+		goto err_exit;
+	}
+	fmd->camclk[SCLK_BAYER].clock = clock;
+
+	return 0;
+err_exit:
+	fimc_md_put_clocks(fmd);
+	return ret;
+}
+
+static int __fimc_md_set_camclk(struct fimc_md *fmd,
+				struct fimc_source_info *si,
+				bool on)
+{
+	struct fimc_camclk_info *camclk;
+	int ret = 0;
+
+	if (WARN_ON(si->clk_id >= FIMC_MAX_CAMCLKS) || fmd == NULL)
+		return -EINVAL;
+
+	camclk = &fmd->camclk[si->clk_id];
+
+	dbg("camclk %d, f: %lu, use_count: %d, on: %d",
+	    si->clk_id, si->clk_frequency, camclk->use_count, on);
+
+	if (on) {
+		if (camclk->use_count > 0 &&
+		    camclk->frequency != si->clk_frequency)
+			return -EINVAL;
+
+		if (camclk->use_count++ == 0) {
+			clk_set_rate(camclk->clock, si->clk_frequency);
+			camclk->frequency = si->clk_frequency;
+			ret = pm_runtime_get_sync(fmd->pmf);
+			if (ret < 0)
+				return ret;
+			ret = clk_prepare_enable(camclk->clock);
+			dbg("Enabled camclk %d: f: %lu", si->clk_id,
+			    clk_get_rate(camclk->clock));
+		}
+		ret = clk_prepare_enable(fmd->camclk[SCLK_BAYER].clock);
+		return ret;
+	}
+
+	if (WARN_ON(camclk->use_count == 0))
+		return 0;
+
+	if (--camclk->use_count == 0) {
+		clk_disable_unprepare(camclk->clock);
+		pm_runtime_put(fmd->pmf);
+		dbg("Disabled camclk %d", si->clk_id);
+	}
+	clk_disable_unprepare(fmd->camclk[SCLK_BAYER].clock);
+	return ret;
+}
+
+static int __fimc_md_modify_pipeline(struct media_entity *entity, bool enable)
+{
+	struct exynos_video_entity *ve;
+	struct fimc_pipeline *p;
+	struct video_device *vdev;
+	int ret;
+
+	vdev = media_entity_to_video_device(entity);
+	if (vdev->entity.use_count == 0)
+		return 0;
+
+	ve = vdev_to_exynos_video_entity(vdev);
+	p = to_fimc_pipeline(ve->pipe);
+	/*
+	 * Nothing to do if we are disabling the pipeline, some link
+	 * has been disconnected and p->subdevs array is cleared now.
+	 */
+	if (!enable && p->subdevs[IDX_SENSOR] == NULL)
+		return 0;
+
+	if (enable)
+		ret = __fimc_pipeline_open(ve->pipe, entity, true);
+	else
+		ret = __fimc_pipeline_close(ve->pipe);
+
+	if (ret == 0 && !enable)
+		memset(p->subdevs, 0, sizeof(p->subdevs));
+
+	return ret;
+}
+
+/* Locking: called with entity->parent->graph_mutex mutex held. */
+static int __fimc_md_modify_pipelines(struct media_entity *entity, bool enable)
+{
+	struct media_entity *entity_err = entity;
+	struct media_entity_graph graph;
+	int ret;
+
+	/*
+	 * Walk current graph and call the pipeline open/close routine for each
+	 * opened video node that belongs to the graph of entities connected
+	 * through active links. This is needed as we cannot power on/off the
+	 * subdevs in random order.
+	 */
+	media_entity_graph_walk_start(&graph, entity);
+
+	while ((entity = media_entity_graph_walk_next(&graph))) {
+		if (media_entity_type(entity) != MEDIA_ENT_T_DEVNODE)
+			continue;
+
+		ret  = __fimc_md_modify_pipeline(entity, enable);
+
+		if (ret < 0)
+			goto err;
+	}
+
+	return 0;
+ err:
+	media_entity_graph_walk_start(&graph, entity_err);
+
+	while ((entity_err = media_entity_graph_walk_next(&graph))) {
+		if (media_entity_type(entity_err) != MEDIA_ENT_T_DEVNODE)
+			continue;
+
+		__fimc_md_modify_pipeline(entity_err, !enable);
+
+		if (entity_err == entity)
+			break;
+	}
+
+	return ret;
+}
+
+static int fimc_md_link_notify(struct media_link *link, unsigned int flags,
+				unsigned int notification)
+{
+	struct media_entity *sink = link->sink->entity;
+	int ret = 0;
+
+	/* Before link disconnection */
+	if (notification == MEDIA_DEV_NOTIFY_PRE_LINK_CH) {
+		if (!(flags & MEDIA_LNK_FL_ENABLED))
+			ret = __fimc_md_modify_pipelines(sink, false);
+		else
+			; /* TODO: Link state change validation */
+	/* After link activation */
+	} else if (notification == MEDIA_DEV_NOTIFY_POST_LINK_CH &&
+		   (link->flags & MEDIA_LNK_FL_ENABLED)) {
+		ret = __fimc_md_modify_pipelines(sink, true);
+	}
+
+	return ret ? -EPIPE : 0;
+}
+
+#ifdef CONFIG_OF
+struct cam_clk {
+	struct clk_hw hw;
+	struct fimc_md *fmd;
+};
+#define to_cam_clk(_hw) container_of(_hw, struct cam_clk, hw)
+
+static int cam_clk_prepare(struct clk_hw *hw)
+{
+	struct cam_clk *camclk = to_cam_clk(hw);
+	int ret = pm_runtime_get_sync(camclk->fmd->pmf);
+
+	return ret < 0 ? ret : 0;
+}
+
+static void cam_clk_unprepare(struct clk_hw *hw)
+{
+	struct cam_clk *camclk = to_cam_clk(hw);
+	pm_runtime_put_sync(camclk->fmd->pmf);
+}
+
+static const struct clk_ops cam_clk_ops = {
+	.prepare = cam_clk_prepare,
+	.unprepare = cam_clk_unprepare,
+};
+
+static const char *cam_clk_p_names[] = { "sclk_cam0", "sclk_cam1" };
+
+static int fimc_md_register_clk_provider(struct fimc_md *fmd)
+{
+	struct cam_clk_provider *clk_provider = &fmd->clk_provider;
+	struct device *dev = &fmd->pdev->dev;
+	struct device_node *node;
+	unsigned int nclocks;
+
+	node = of_get_child_by_name(dev->of_node, "clock-controller");
+	if (!node) {
+		dev_warn(dev, "clock-controller node at %s not found\n",
+					dev->of_node->full_name);
+		return 0;
+	}
+	/* Instantiate the clocks */
+	for (nclocks = 0; nclocks < SCLK_BAYER; nclocks++) {
+		struct clk_init_data init;
+		char clk_name[16];
+		struct clk *clk;
+		struct cam_clk *camclk;
+
+		camclk = devm_kzalloc(dev, sizeof(*camclk), GFP_KERNEL);
+		if (!camclk)
+			return -ENOMEM;
+
+		snprintf(clk_name, sizeof(clk_name), "cam_clkout%d", nclocks);
+
+		init.name = clk_name;
+		init.ops = &cam_clk_ops;
+		init.flags = CLK_SET_RATE_PARENT;
+		init.parent_names = &cam_clk_p_names[nclocks];
+		init.num_parents = 1;
+		camclk->hw.init = &init;
+		camclk->fmd = fmd;
+
+		clk = devm_clk_register(dev, &camclk->hw);
+		if (IS_ERR(clk)) {
+			kfree(camclk);
+			return PTR_ERR(clk);
+		}
+		clk_provider->clks[nclocks] = clk;
+	}
+
+	clk_provider->clk_data.clks = clk_provider->clks;
+	clk_provider->clk_data.clk_num = nclocks;
+
+	return of_clk_add_provider(node, of_clk_src_onecell_get,
+					&clk_provider->clk_data);
+}
+#else
+#define fimc_md_register_clk_provider(fmd) (0)
+#endif
+
+static int subdev_notifier_bound(struct v4l2_async_notifier *notifier,
+				 struct v4l2_subdev *subdev,
+				 struct v4l2_async_subdev *asd)
+{
+	struct fimc_md *fmd = notifier_to_fimc_md(notifier);
+	struct fimc_sensor_info *si = NULL;
+	int i;
+
+	/* Find platform data for this sensor subdev */
+	for (i = 0; i < ARRAY_SIZE(fmd->sensor); i++) {
+		if (fmd->sensor[i].asd.match.of.node == subdev->dev->of_node)
+			si = &fmd->sensor[i];
+	}
+
+	if (si == NULL)
+		return -EINVAL;
+
+	v4l2_set_subdev_hostdata(subdev, &si->pdata);
+
+	if (si->pdata.fimc_bus_type == FIMC_BUS_TYPE_ISP_WRITEBACK)
+		subdev->grp_id = GRP_ID_FIMC_IS_SENSOR;
+	else
+		subdev->grp_id = GRP_ID_SENSOR;
+
+	si->subdev = subdev;
+
+	v4l2_info(&fmd->v4l2_dev, "Registered sensor subdevice: %s (%d)\n",
+		  subdev->name, fmd->num_sensors);
+
+	fmd->num_sensors++;
+
+	return 0;
+}
+
+static int subdev_notifier_complete(struct v4l2_async_notifier *notifier)
+{
+	struct fimc_md *fmd = notifier_to_fimc_md(notifier);
+	int ret;
+
+	mutex_lock(&fmd->media_dev.graph_mutex);
+
+	ret = fimc_md_create_links(fmd);
+	if (ret < 0)
+		goto unlock;
+
+	ret = v4l2_device_register_subdev_nodes(&fmd->v4l2_dev);
+unlock:
+	mutex_unlock(&fmd->media_dev.graph_mutex);
+	return ret;
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
+	INIT_LIST_HEAD(&fmd->pipelines);
+	INIT_LIST_HEAD(&fmd->isp_pipelines);
+
+	strlcpy(fmd->media_dev.model, "SAMSUNG EXYNOS5 IS",
+		sizeof(fmd->media_dev.model));
+	fmd->media_dev.link_notify = fimc_md_link_notify;
+	fmd->media_dev.dev = dev;
+
+	v4l2_dev = &fmd->v4l2_dev;
+	v4l2_dev->mdev = &fmd->media_dev;
+	strlcpy(v4l2_dev->name, "exynos5-fimc-md", sizeof(v4l2_dev->name));
+
+	ret = fimc_md_register_clk_provider(fmd);
+	if (ret < 0) {
+		v4l2_err(v4l2_dev, "clock provider registration failed\n");
+		return ret;
+	}
+
+	ret = v4l2_device_register(dev, &fmd->v4l2_dev);
+	if (ret < 0) {
+		v4l2_err(v4l2_dev, "Failed to register v4l2_device: %d\n", ret);
+		return ret;
+	}
+
+	ret = media_device_register(&fmd->media_dev);
+	if (ret < 0) {
+		v4l2_err(v4l2_dev, "Failed to register media dev: %d\n", ret);
+		goto err_md;
+	}
+
+	ret = fimc_md_get_clocks(fmd);
+	if (ret)
+		goto err_clk;
+
+	fmd->user_subdev_api = (dev->of_node != NULL);
+
+	platform_set_drvdata(pdev, fmd);
+
+	/* Protect the media graph while we're registering entities */
+	mutex_lock(&fmd->media_dev.graph_mutex);
+
+	ret = fimc_md_register_of_platform_entities(fmd, dev->of_node);
+	if (ret)
+		goto err_unlock;
+
+	ret = fimc_md_register_sensor_entities(fmd);
+	if (ret)
+		goto err_unlock;
+
+	mutex_unlock(&fmd->media_dev.graph_mutex);
+
+	fmd->subdev_notifier.subdevs = fmd->async_subdevs;
+	fmd->subdev_notifier.num_subdevs = fmd->num_sensors;
+	fmd->subdev_notifier.bound = subdev_notifier_bound;
+	fmd->subdev_notifier.complete = subdev_notifier_complete;
+	fmd->num_sensors = 0;
+
+	ret = v4l2_async_notifier_register(&fmd->v4l2_dev,
+					   &fmd->subdev_notifier);
+	if (ret)
+		goto err_clk;
+
+	return 0;
+
+err_unlock:
+	mutex_unlock(&fmd->media_dev.graph_mutex);
+err_clk:
+	fimc_md_put_clocks(fmd);
+	fimc_md_unregister_entities(fmd);
+	media_device_unregister(&fmd->media_dev);
+err_md:
+	v4l2_device_unregister(&fmd->v4l2_dev);
+	fimc_md_unregister_clk_provider(fmd);
+	return ret;
+}
+
+static int fimc_md_remove(struct platform_device *pdev)
+{
+	struct fimc_md *fmd = platform_get_drvdata(pdev);
+
+	v4l2_async_notifier_unregister(&fmd->subdev_notifier);
+
+	fimc_md_unregister_entities(fmd);
+	fimc_md_pipelines_free(fmd);
+	media_device_unregister(&fmd->media_dev);
+	fimc_md_put_clocks(fmd);
+
+	return 0;
+}
+
+static struct platform_device_id fimc_driver_ids[] __always_unused = {
+	{ .name = "exynos5-fimc-md" },
+	{ },
+};
+MODULE_DEVICE_TABLE(platform, fimc_driver_ids);
+
+static const struct of_device_id fimc_md_of_match[] = {
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
+		.name		= "exynos5-fimc-md",
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
+MODULE_AUTHOR("Shaik Ameer Basha <shaik.ameer@samsung.com>");
+MODULE_DESCRIPTION("EXYNOS5 FIMC media device driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/platform/exynos5-is/exynos5-mdev.h b/drivers/media/platform/exynos5-is/exynos5-mdev.h
new file mode 100644
index 0000000..7fada6c
--- /dev/null
+++ b/drivers/media/platform/exynos5-is/exynos5-mdev.h
@@ -0,0 +1,199 @@
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
+#define FIMC_MAX_SENSORS	8
+
+enum fimc_subdev_index {
+	IDX_SENSOR,
+	IDX_CSIS,
+	IDX_FLITE,
+	IDX_FIMC_IS,
+	IDX_MAX,
+};
+
+enum fimc_isp_subdev_index {
+	IDX_ISP,
+	IDX_SCC,
+	IDX_SCP,
+	IDX_IS_MAX,
+};
+
+enum fimc_sensor_clks {
+	SCLK_CAM0,
+	SCLK_CAM1,
+	SCLK_BAYER,
+	FIMC_MAX_CAMCLKS,
+};
+
+struct fimc_pipeline {
+	struct exynos_media_pipeline ep;
+	struct list_head list;
+	struct media_entity *vdev_entity;
+	struct v4l2_subdev *subdevs[IDX_MAX];
+	struct list_head *isp_pipelines;
+};
+
+struct fimc_pipeline_isp {
+	struct exynos_media_pipeline ep;
+	struct list_head list;
+	struct v4l2_subdev *subdevs[IDX_IS_MAX];
+	bool in_use;
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
+ * struct fimc_sensor_info - image data source subdev information
+ * @pdata: sensor's atrributes passed as media device's platform data
+ * @asd: asynchronous subdev registration data structure
+ * @subdev: image sensor v4l2 subdev
+ * @host: fimc device the sensor is currently linked to
+ *
+ * This data structure applies to image sensor and the writeback subdevs.
+ */
+struct fimc_sensor_info {
+	struct fimc_source_info pdata;
+	struct v4l2_async_subdev asd;
+	struct v4l2_subdev *subdev;
+	struct fimc_dev *host;
+};
+
+/**
+ * struct fimc_md - fimc media device information
+ * @csis: MIPI CSIS subdevs data
+ * @sensor: array of registered sensor subdevs
+ * @num_sensors: actual number of registered sensors
+ * @camclk: external sensor clock information
+ * @fimc: array of registered fimc devices
+ * @is: fimc-is data structure
+ * @pmf: handle to the CAMCLK clock control FIMC helper device
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
+	struct fimc_is *is;
+	struct device *pmf;
+	struct media_device media_dev;
+	struct v4l2_device v4l2_dev;
+	struct platform_device *pdev;
+	struct cam_clk_provider {
+		struct clk *clks[FIMC_MAX_CAMCLKS];
+		struct clk_onecell_data clk_data;
+		struct device_node *of_node;
+	} clk_provider;
+
+	struct v4l2_async_notifier subdev_notifier;
+	struct v4l2_async_subdev *async_subdevs[FIMC_MAX_SENSORS];
+
+	bool user_subdev_api;
+	spinlock_t slock;
+	struct list_head pipelines;
+	struct list_head isp_pipelines;
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
+#define to_fimc_pipeline(_ep) container_of(_ep, struct fimc_pipeline, ep)
+#define to_fimc_isp_pipeline(_ep) \
+	container_of(_ep, struct fimc_pipeline_isp, ep)
+
+static inline struct fimc_md *entity_to_fimc_mdev(struct media_entity *me)
+{
+	return me->parent == NULL ? NULL :
+		container_of(me->parent, struct fimc_md, media_dev);
+}
+
+static inline struct fimc_md *notifier_to_fimc_md(struct v4l2_async_notifier *n)
+{
+	return container_of(n, struct fimc_md, subdev_notifier);
+}
+
+static inline void fimc_md_graph_lock(struct exynos_video_entity *ve)
+{
+	mutex_lock(&ve->vdev.entity.parent->graph_mutex);
+}
+
+static inline void fimc_md_graph_unlock(struct exynos_video_entity *ve)
+{
+	mutex_unlock(&ve->vdev.entity.parent->graph_mutex);
+}
+
+#ifdef CONFIG_OF
+static inline bool fimc_md_is_isp_available(struct device_node *node)
+{
+	node = of_get_child_by_name(node, FIMC_IS_OF_NODE_NAME);
+	return node ? of_device_is_available(node) : false;
+}
+
+static inline void fimc_md_unregister_clk_provider(struct fimc_md *fmd)
+{
+	if (fmd->clk_provider.of_node)
+		of_clk_del_provider(fmd->clk_provider.of_node);
+}
+#else
+
+#define fimc_md_is_isp_available(node) (false)
+#define fimc_md_unregister_clk_provider(fmd) (0)
+#endif /* CONFIG_OF */
+
+static inline struct v4l2_subdev *__fimc_md_get_subdev(
+				struct exynos_media_pipeline *ep,
+				unsigned int index)
+{
+	struct fimc_pipeline *p = to_fimc_pipeline(ep);
+
+	if (!p || index >= IDX_MAX)
+		return NULL;
+	else
+		return p->subdevs[index];
+}
+
+#endif
-- 
1.7.9.5

