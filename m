Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:38974 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757602Ab3DXHme (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Apr 2013 03:42:34 -0400
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org
Cc: s.nawrocki@samsung.com, shaik.samsung@gmail.com,
	arunkk.samsung@gmail.com
Subject: [RFC v2 6/6] media: exynos5-is: Adding media device driver for exynos5
Date: Wed, 24 Apr 2013 13:11:13 +0530
Message-Id: <1366789273-30184-7-git-send-email-shaik.ameer@samsung.com>
In-Reply-To: <1366789273-30184-1-git-send-email-shaik.ameer@samsung.com>
References: <1366789273-30184-1-git-send-email-shaik.ameer@samsung.com>
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
 .../devicetree/bindings/media/exynos5-mdev.txt     |  153 +++
 drivers/media/platform/Kconfig                     |    1 +
 drivers/media/platform/Makefile                    |    1 +
 drivers/media/platform/exynos5-is/Kconfig          |    7 +
 drivers/media/platform/exynos5-is/Makefile         |    4 +
 drivers/media/platform/exynos5-is/exynos5-mdev.c   | 1131 ++++++++++++++++++++
 drivers/media/platform/exynos5-is/exynos5-mdev.h   |  120 +++
 7 files changed, 1417 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/exynos5-mdev.txt
 create mode 100644 drivers/media/platform/exynos5-is/Kconfig
 create mode 100644 drivers/media/platform/exynos5-is/Makefile
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
diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index d25f044..66fbb41 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -123,6 +123,7 @@ config VIDEO_S3C_CAMIF
 
 source "drivers/media/platform/soc_camera/Kconfig"
 source "drivers/media/platform/exynos4-is/Kconfig"
+source "drivers/media/platform/exynos5-is/Kconfig"
 source "drivers/media/platform/s5p-tv/Kconfig"
 
 endif # V4L_PLATFORM_DRIVERS
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index eee28dd..b1225e5 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -37,6 +37,7 @@ obj-$(CONFIG_VIDEO_SAMSUNG_S5P_TV)	+= s5p-tv/
 
 obj-$(CONFIG_VIDEO_SAMSUNG_S5P_G2D)	+= s5p-g2d/
 obj-$(CONFIG_VIDEO_SAMSUNG_EXYNOS_GSC)	+= exynos-gsc/
+obj-$(CONFIG_VIDEO_SAMSUNG_EXYNOS5_MDEV)	+= exynos5-is/
 
 obj-$(CONFIG_BLACKFIN)                  += blackfin/
 
diff --git a/drivers/media/platform/exynos5-is/Kconfig b/drivers/media/platform/exynos5-is/Kconfig
new file mode 100644
index 0000000..de02d90
--- /dev/null
+++ b/drivers/media/platform/exynos5-is/Kconfig
@@ -0,0 +1,7 @@
+config VIDEO_SAMSUNG_EXYNOS5_MDEV
+	bool "Samsung Exynos5 Media Device driver"
+	depends on VIDEO_DEV && VIDEO_V4L2 && ARCH_EXYNOS5 && OF
+	help
+	  This is a v4l2 based media controller driver for
+	  Exynos5 SoC.
+
diff --git a/drivers/media/platform/exynos5-is/Makefile b/drivers/media/platform/exynos5-is/Makefile
new file mode 100644
index 0000000..002e137
--- /dev/null
+++ b/drivers/media/platform/exynos5-is/Makefile
@@ -0,0 +1,4 @@
+ccflags-y += -Idrivers/media/platform/exynos4-is
+exynos-mdevice-objs := exynos5-mdev.o
+
+obj-$(CONFIG_VIDEO_SAMSUNG_EXYNOS5_MDEV) += exynos-mdevice.o
diff --git a/drivers/media/platform/exynos5-is/exynos5-mdev.c b/drivers/media/platform/exynos5-is/exynos5-mdev.c
new file mode 100644
index 0000000..ac3e85e
--- /dev/null
+++ b/drivers/media/platform/exynos5-is/exynos5-mdev.c
@@ -0,0 +1,1131 @@
+/*
+ * EXYNOS5 SoC series camera host interface media device driver
+ *
+ * Copyright (C) 2013 Samsung Electronics Co., Ltd.
+ * Shaik Ameer Basha <shaik.ameer@samsung.com>
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
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-of.h>
+#include <media/media-device.h>
+
+#include "exynos5-mdev.h"
+
+#define dbg(fmt, args...) \
+	pr_debug("%s:%d: " fmt "\n", __func__, __LINE__, ##args)
+
+static int fimc_md_set_camclk(struct v4l2_subdev *sd, bool on);
+static int __fimc_md_set_camclk(struct fimc_md *fmd,
+				struct fimc_source_info *si,
+				bool on);
+/**
+ * fimc_pipeline_prepare - update pipeline information with subdevice pointers
+ * @me: media entity terminating the pipeline
+ *
+ * Caller holds the graph mutex.
+ */
+static void fimc_pipeline_prepare(struct exynos5_pipeline0 *p,
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
+			pad = media_entity_remote_source(spad);
+			if (pad)
+				break;
+		}
+
+		if (pad == NULL ||
+		    media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
+			break;
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
+ * __fimc_pipeline_init - allocate the fimc_pipeline structure and do the
+ *                        basic initialization.
+ * @p: Pointer to fimc_pipeline structure
+ *
+ * Initializes the 'is_init' variable to indicate the pipeline structure
+ * is valid.
+ */
+static int __fimc_pipeline_init(struct fimc_pipeline *p)
+{
+	struct exynos5_pipeline0 *ep;
+
+	ep = kzalloc(sizeof(*ep), GFP_KERNEL);
+	if (!ep)
+		return -ENOMEM;
+
+	ep->is_init = true;
+	p->priv = (void *)ep;
+	return 0;
+}
+
+/**
+ * __fimc_pipeline_free - free the allocated resources for fimc_pipeline
+ * @p: Pointer to fimc_pipeline structure
+ *
+ * sets the 'is_init' variable to false, to indicate the pipeline structure
+ * is not valid.
+ *
+ * RETURNS:
+ * Zero in case of success and -EINVAL in case of failure.
+ */
+static int __fimc_pipeline_free(struct fimc_pipeline *p)
+{
+	struct exynos5_pipeline0 *ep0 = (struct exynos5_pipeline0 *)p->priv;
+
+	if (!ep0 || !ep0->is_init)
+		return -EINVAL;
+
+	ep0->is_init = false;
+	kfree(ep0);
+
+	return 0;
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
+static int __fimc_pipeline_open(struct fimc_pipeline *p,
+				struct media_entity *me, bool prepare)
+{
+	struct exynos5_pipeline0 *ep = (struct exynos5_pipeline0 *)p->priv;
+	struct v4l2_subdev *sd;
+	int ret;
+
+	if (WARN_ON(p == NULL || me == NULL))
+		return -EINVAL;
+
+	if (!ep || !ep->is_init)
+		return -EINVAL;
+
+	if (prepare)
+		fimc_pipeline_prepare(ep, me);
+
+	sd = ep->subdevs[IDX_SENSOR];
+	if (sd == NULL)
+		return -EINVAL;
+
+	ret = fimc_md_set_camclk(sd, true);
+	if (ret < 0)
+		return ret;
+
+	ret = fimc_pipeline_s_power(ep, 1);
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
+static int __fimc_pipeline_close(struct fimc_pipeline *p)
+{
+	struct exynos5_pipeline0 *ep = (struct exynos5_pipeline0 *)p->priv;
+	struct v4l2_subdev *sd = ep ? ep->subdevs[IDX_SENSOR] : NULL;
+	int ret = 0;
+
+	if (WARN_ON(sd == NULL))
+		return -EINVAL;
+
+	if (ep->subdevs[IDX_SENSOR]) {
+		ret = fimc_pipeline_s_power(ep, 0);
+		fimc_md_set_camclk(sd, false);
+	}
+	return ret == -ENXIO ? 0 : ret;
+}
+
+/**
+ * __fimc_pipeline_s_stream - call s_stream() on pipeline subdevs
+ * @pipeline: video pipeline structure
+ * @on: passed as the s_stream() callback argument
+ */
+static int __fimc_pipeline_s_stream(struct fimc_pipeline *p, bool on)
+{
+	struct exynos5_pipeline0 *ep = (struct exynos5_pipeline0 *)p->priv;
+	int i, ret;
+
+	if (ep->subdevs[IDX_SENSOR] == NULL)
+		return -ENODEV;
+
+	for (i = 0; i < IDX_MAX; i++) {
+		unsigned int idx = on ? (IDX_MAX - 1) - i : i;
+
+		ret = v4l2_subdev_call(ep->subdevs[idx], video, s_stream, on);
+
+		if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
+			return ret;
+	}
+
+	return 0;
+
+}
+
+/**
+ * __fimc_pipeline_get_subdev_sensor - if valid pipeline, returns the sensor
+ *                                     subdev pointer else returns NULL
+ * @p: Pointer to fimc_pipeline structure
+ * @sd_idx: Index of the subdev associated with the current pipeline
+ *
+ * RETURNS:
+ * If success, returns valid subdev pointer or NULL in case of sudbev not found
+ */
+static struct v4l2_subdev *__fimc_pipeline_get_subdev(struct fimc_pipeline *p,
+					enum exynos_subdev_index sd_idx)
+{
+	struct exynos5_pipeline0 *ep = (struct exynos5_pipeline0 *)p->priv;
+	struct v4l2_subdev *sd;
+
+	if (!ep || !ep->is_init)
+		return NULL;
+
+	switch (sd_idx) {
+	case EXYNOS_SD_SENSOR:
+		sd = ep->subdevs[IDX_SENSOR];
+		break;
+	case EXYNOS_SD_CSIS:
+		sd = ep->subdevs[IDX_CSIS];
+		break;
+	case EXYNOS_SD_FLITE:
+		sd = ep->subdevs[IDX_FLITE];
+		break;
+	default:
+		sd = NULL;
+		break;
+	}
+	return sd;
+}
+
+static void __fimc_pipeline_register_notify_callback(
+		struct fimc_pipeline *p,
+		void (*notify_cb)(struct v4l2_subdev *sd,
+				unsigned int notification, void *arg))
+{
+	struct exynos5_pipeline0 *ep = (struct exynos5_pipeline0 *)p->priv;
+
+	if (!notify_cb)
+		return;
+
+	ep->sensor_notify = notify_cb;
+}
+
+/* Media pipeline operations for the FIMC/FIMC-LITE video device driver */
+static const struct fimc_pipeline_ops exynos5_pipeline0_ops = {
+	.init		= __fimc_pipeline_init,
+	.free		= __fimc_pipeline_free,
+	.open		= __fimc_pipeline_open,
+	.close		= __fimc_pipeline_close,
+	.set_stream	= __fimc_pipeline_s_stream,
+	.get_subdev	= __fimc_pipeline_get_subdev,
+	.register_notify_cb	= __fimc_pipeline_register_notify_callback,
+};
+
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
+		v4l2_info(&fmd->v4l2_dev, "No driver found for %s\n",
+						node->full_name);
+		goto dev_put;
+	}
+
+	/* Enable sensor's master clock */
+	ret = __fimc_md_set_camclk(fmd, &si->pdata, true);
+	if (ret < 0)
+		goto mod_put;
+	sd = i2c_get_clientdata(client);
+
+	ret = v4l2_device_register_subdev(&fmd->v4l2_dev, sd);
+	__fimc_md_set_camclk(fmd, &si->pdata, false);
+	if (ret < 0)
+		goto mod_put;
+
+	v4l2_set_subdev_hostdata(sd, &si->pdata);
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
+	struct device_node *rem, *ep;
+	struct fimc_source_info *pd;
+	struct v4l2_of_endpoint endpoint;
+	int ret;
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
+		v4l2_device_unregister_subdev(fmd->sensor[i].subdev);
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
+	int i, ret = 0;
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
+	struct media_entity *source, *sink;
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
+			ret = clk_enable(camclk->clock);
+			dbg("Enabled camclk %d: f: %lu", si->clk_id,
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
+		dbg("Disabled camclk %d", si->clk_id);
+	}
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
+	struct fimc_source_info *si = v4l2_get_subdev_hostdata(sd);
+	struct fimc_md *fmd = entity_to_fimc_mdev(&sd->entity);
+
+	return __fimc_md_set_camclk(fmd, si, on);
+}
+
+static int fimc_md_link_notify(struct media_pad *source,
+			       struct media_pad *sink, u32 flags)
+{
+	struct fimc_lite *fimc_lite = NULL;
+	struct fimc_pipeline *pipeline;
+	struct exynos5_pipeline0 *ep;
+	struct v4l2_subdev *sd;
+	struct mutex *lock;
+	int ret = 0, i;
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
+	mutex_lock(lock);
+	ref_count = fimc_lite->ref_count;
+
+	ep = (struct exynos5_pipeline0 *)pipeline->priv;
+	if (!ep || !ep->is_init)
+		return -EINVAL;
+
+	if (!(flags & MEDIA_LNK_FL_ENABLED)) {
+		if (ref_count > 0)
+			ret = __fimc_pipeline_close(pipeline);
+		for (i = 0; i < IDX_MAX; i++)
+			ep->subdevs[i] = NULL;
+	} else if (ref_count > 0) {
+		/*
+		 * Link activation. Enable power of pipeline elements only if
+		 * the pipeline is already in use, i.e. its video node is open.
+		 */
+		ret = __fimc_pipeline_open(pipeline,
+					   source->entity, true);
+	}
+
+	mutex_unlock(lock);
+	return ret ? -EPIPE : ret;
+}
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
+	struct exynos5_pipeline0 *ep;
+	struct fimc_pipeline *p;
+	unsigned long flags;
+
+	fmd = entity_to_fimc_mdev(&sd->entity);
+
+	if (sd == NULL)
+		return;
+
+	p = media_pipe_to_fimc_pipeline(sd->entity.pipe);
+	ep = (struct exynos5_pipeline0 *)p->priv;
+
+	spin_lock_irqsave(&fmd->slock, flags);
+
+	if (ep->sensor_notify)
+		ep->sensor_notify(sd, notification, arg);
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
+	strlcpy(fmd->media_dev.model, "SAMSUNG EXYNOS5 IS",
+		sizeof(fmd->media_dev.model));
+	fmd->media_dev.link_notify = fimc_md_link_notify;
+	fmd->media_dev.dev = dev;
+
+	v4l2_dev = &fmd->v4l2_dev;
+	v4l2_dev->mdev = &fmd->media_dev;
+	v4l2_dev->notify = fimc_md_sensor_notify;
+	strlcpy(v4l2_dev->name, "exynos5-fimc-md", sizeof(v4l2_dev->name));
+
+	ret = v4l2_device_register(dev, &fmd->v4l2_dev);
+	if (ret < 0) {
+		v4l2_err(v4l2_dev, "Failed to register v4l2_device: %d\n", ret);
+		return ret;
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
+	/* Protect the media graph while we're registering entities */
+	mutex_lock(&fmd->media_dev.graph_mutex);
+
+	ret = fimc_md_register_of_platform_entities(fmd, dev->of_node);
+	if (ret)
+		goto err_unlock;
+
+	fmd->num_sensors = 0;
+	ret = fimc_md_of_sensors_register(fmd, dev->of_node);
+	if (ret)
+		goto err_unlock;
+
+	ret = fimc_md_create_links(fmd);
+	if (ret)
+		goto err_unlock;
+	ret = v4l2_device_register_subdev_nodes(&fmd->v4l2_dev);
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
+	fimc_md_unregister_entities(fmd);
+	media_device_unregister(&fmd->media_dev);
+	fimc_md_put_clocks(fmd);
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
index 0000000..43621b6
--- /dev/null
+++ b/drivers/media/platform/exynos5-is/exynos5-mdev.h
@@ -0,0 +1,120 @@
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
+ * struct fimc_sensor_info - image data source subdev information
+ * @pdata: sensor's atrributes passed as media device's platform data
+ * @subdev: image sensor v4l2 subdev
+ * @host: fimc device the sensor is currently linked to
+ *
+ * This data structure applies to image sensor and the writeback subdevs.
+ */
+struct fimc_sensor_info {
+	struct fimc_source_info pdata;
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

