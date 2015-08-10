Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.uni-paderborn.de ([131.234.142.9]:58156 "EHLO
	mail.uni-paderborn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433AbbHJPco (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Aug 2015 11:32:44 -0400
MIME-Version: 1.0
Date: Mon, 10 Aug 2015 17:16:30 +0200
Message-ID: <CALcgO_6UXp-Xqwim8WpLXz7XWAEpejipR7JNQc0TdH0ETL4JYQ@mail.gmail.com>
Subject: [PATCH RFC] DT support for omap4-iss
From: Michael Allwright <michael.allwright@upb.de>
To: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Tony Lindgren <tony@atomide.com>, Arnd Bergmann <arnd@arndb.de>,
	Tero Kristo <t-kristo@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

The following PRELIMINARY patch adds DT support to the OMAP4 ISS. It
also fixes some problems a have found along the way. It is tightly
modelled after the omap3-isp media platform driver. This patch is a
work in progress as I would like feedback. It contains debugging
messages that need to be removed, as well as disgusting abuses of the
C language as required (i.e. clk_core_fake and clk_fake).

I'm working in the latest stable mainline which as far as this patch
is concerned is compatible with media tree master. I have had this
omap4-iss working on my hardware in the 3.17 kernel, however I'm
currently having the following issue in 4.1.4 stable when I start to
stream:

[  141.612609] omap4iss 52000000.iss: CSI2: CSI2_96M_FCLK reset timeout!

Any feedback regarding this issue would really be appreciated. After
resolving this issue, we still need to do a proper implementation
using syscon and also to find a solution regarding where to put the
iss_set_constraints function. I have to give up for the next couple of
weeks as I need to submit a conference paper, which I'm going to use
my 3.17 implementation for. The following is an example of how the ISS
would be instantiated in the top level device tree:

iss_csi21_pins: pinmux_iss_csi21_pins {
    pinctrl-single,pins = <
        OMAP4_IOPAD(0x0a0, PIN_INPUT | MUX_MODE0)        /*
csi21_dx0.csi21_dx0 */
        OMAP4_IOPAD(0x0a2, PIN_INPUT | MUX_MODE0)        /*
csi21_dy0.csi21_dy0 */
        OMAP4_IOPAD(0x0a4, PIN_INPUT | MUX_MODE0)        /*
csi21_dx1.csi21_dx1 */
        OMAP4_IOPAD(0x0a6, PIN_INPUT | MUX_MODE0)        /*
csi21_dy1.csi21_dy1 */
        OMAP4_IOPAD(0x0a8, PIN_INPUT | MUX_MODE0)        /*
csi21_dx2.csi21_dx2 */
        OMAP4_IOPAD(0x0aa, PIN_INPUT | MUX_MODE0)        /*
csi21_dy2.csi21_dy2 */
    >;
};

&iss {
    status = "ok";

    pinctrl-names = "default";
    pinctrl-0 = <&iss_csi21_pins>;

    ports {
        port@0 {
            reg = <0>;
            csi2a_ep: endpoint {
                remote-endpoint = <&ov5640_1_cam_ep>;
                clock-lanes = <1>;
                data-lanes = <2>;
                crc = <0>;
                lane-polarities = <0 0>;
            };
        };
    };
};

and for the connected camera:

ov5640_1_camera: ov5640@3c {
    compatible = "omnivision,ov5640";
    status = "ok";
    reg = <0x3c>;

    pwdn-gpios = <&ov5640_1_gpio 5 GPIO_ACTIVE_HIGH>;
    reset-gpios = <&ov5640_1_gpio 6 GPIO_ACTIVE_LOW>;

    avdd-supply = <&switch_ov5640_1_avdd>;
    dvdd-supply = <&switch_ov5640_1_dvdd>;

    clocks = <&ov5640_1_camera_clk>;

    port {
        ov5640_1_cam_ep: endpoint {
            clock-lanes = <0>;
            data-lanes = <1>;
            remote-endpoint = <&csi2a_ep>;
        };
    };
};

>From 919995491fb34cf7e2bd8a331c47e45cad677ce6 Mon Sep 17 00:00:00 2001
From: Michael Allwright <allsey87@gmail.com>
Date: Mon, 10 Aug 2015 16:55:57 +0200
Subject: [PATCH] omap4-iss: Add device support (WIP)

---
 arch/arm/boot/dts/omap4.dtsi                |  33 +++
 drivers/staging/media/omap4iss/iss.c        | 419 +++++++++++++++++++++-------
 drivers/staging/media/omap4iss/iss.h        |  11 +
 drivers/staging/media/omap4iss/iss_csi2.c   |   4 +-
 drivers/staging/media/omap4iss/iss_csiphy.c |  16 +-
 drivers/staging/media/omap4iss/iss_video.c  |   6 +-
 include/media/omap4iss.h                    |  18 +-
 7 files changed, 393 insertions(+), 114 deletions(-)

diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
index f884d6a..bd37437 100644
--- a/arch/arm/boot/dts/omap4.dtsi
+++ b/arch/arm/boot/dts/omap4.dtsi
@@ -923,6 +923,39 @@
             status = "disabled";
         };

+        iss: iss@52000000 {
+            compatible = "ti,omap4-iss";
+            reg = <0x52000000 0x100>, /* top */
+                  <0x52001000 0x170>, /* csi2_a_regs1 */
+                  <0x52001170 0x020>, /* camerarx_core1 */
+                  <0x52001400 0x170>, /* csi2_b_regs1 */
+                  <0x52001570 0x020>, /* camerarx_core2 */
+                  <0x52002000 0x200>, /* bte */
+                  <0x52010000 0x0a0>, /* isp_sys1 */
+                  <0x52010400 0x400>, /* isp_resizer */
+                  <0x52010800 0x800>, /* isp_ipipe */
+                  <0x52011000 0x200>, /* isp_isif */
+                  <0x52011200 0x080>; /* isp_ipipeif */
+            reg-names = "top",
+                        "csi2_a_regs1",
+                        "camerarx_core1",
+                        "csi2_b_regs1",
+                        "camerarx_core2",
+                        "bte",
+                        "isp_sys1",
+                        "isp_resizer",
+                        "isp_ipipe",
+                        "isp_isif",
+                        "isp_ipipeif";
+            status = "ok";
+            ti,hwmods = "iss";
+            interrupts = <GIC_SPI 24 IRQ_TYPE_LEVEL_HIGH>;
+            clocks = <&ducati_clk_mux_ck>, <&iss_ctrlclk>;
+            clock-names = "iss_fck", "iss_ctrlclk";
+            dmas = <&sdma 9>, <&sdma 10>, <&sdma 12>, <&sdma 13>;
+            dma-names = "1", "2", "3", "4";
+        };
+
         dss: dss@58000000 {
             compatible = "ti,omap4-dss";
             reg = <0x58000000 0x80>;
diff --git a/drivers/staging/media/omap4iss/iss.c
b/drivers/staging/media/omap4iss/iss.c
index 7ced940..0ad1206 100644
--- a/drivers/staging/media/omap4iss/iss.c
+++ b/drivers/staging/media/omap4iss/iss.c
@@ -14,6 +14,7 @@
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/device.h>
+#include <linux/of_device.h>
 #include <linux/dma-mapping.h>
 #include <linux/i2c.h>
 #include <linux/interrupt.h>
@@ -28,6 +29,8 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>

+#include <linux/pm_runtime.h>
+
 #include "iss.h"
 #include "iss_regs.h"

@@ -129,7 +132,8 @@ int omap4iss_get_external_info(struct iss_pipeline *pipe,
     struct iss_device *iss =
         container_of(pipe, struct iss_video, pipe)->iss;
     struct v4l2_subdev_format fmt;
-    struct v4l2_ctrl *ctrl;
+    struct v4l2_ext_controls ctrls;
+    struct v4l2_ext_control ctrl;
     int ret;

     if (!pipe->external)
@@ -149,15 +153,23 @@ int omap4iss_get_external_info(struct iss_pipeline *pipe,

     pipe->external_bpp = omap4iss_video_format_info(fmt.format.code)->bpp;

-    ctrl = v4l2_ctrl_find(pipe->external->ctrl_handler,
-                  V4L2_CID_PIXEL_RATE);
-    if (ctrl == NULL) {
-        dev_warn(iss->dev, "no pixel rate control in subdev %s\n",
+    memset(&ctrls, 0, sizeof(ctrls));
+    memset(&ctrl, 0, sizeof(ctrl));
+
+    ctrl.id = V4L2_CID_PIXEL_RATE;
+    ctrls.count = 1;
+    ctrls.controls = &ctrl;
+
+    ret = v4l2_g_ext_ctrls(pipe->external->ctrl_handler, &ctrls);
+    if (ret < 0) {
+        dev_warn(iss->dev, "no pixel rate control in subdev %s\n",
              pipe->external->name);
-        return -EPIPE;
+        return ret;
     }

-    pipe->external_rate = v4l2_ctrl_g_ctrl_int64(ctrl);
+    pipe->external_rate = ctrl.value64;
+    dev_info(iss->dev, "subdev %s pixel rate = %u\n",
+         pipe->external->name, pipe->external_rate);

     return 0;
 }
@@ -993,13 +1005,13 @@ static int iss_enable_clocks(struct iss_device *iss)
 {
     int ret;

-    ret = clk_enable(iss->iss_fck);
+    ret = clk_prepare_enable(iss->iss_fck);
     if (ret) {
         dev_err(iss->dev, "clk_enable iss_fck failed\n");
         return ret;
     }

-    ret = clk_enable(iss->iss_ctrlclk);
+    ret = clk_prepare_enable(iss->iss_ctrlclk);
     if (ret) {
         dev_err(iss->dev, "clk_enable iss_ctrlclk failed\n");
         clk_disable(iss->iss_fck);
@@ -1015,15 +1027,26 @@ static int iss_enable_clocks(struct iss_device *iss)
  */
 static void iss_disable_clocks(struct iss_device *iss)
 {
-    clk_disable(iss->iss_ctrlclk);
-    clk_disable(iss->iss_fck);
+    clk_disable_unprepare(iss->iss_ctrlclk);
+    clk_disable_unprepare(iss->iss_fck);
 }

+struct clk_core_fake {
+    const char        *name;
+};
+
+struct clk_fake {
+    struct clk_core_fake    *core;
+    const char *dev_id;
+    const char *con_id;
+};
+
+
 static int iss_get_clocks(struct iss_device *iss)
 {
-    iss->iss_fck = devm_clk_get(iss->dev, "iss_fck");
+    iss->iss_fck = devm_clk_get(iss->dev, "ducati_clk_mux_ck");
     if (IS_ERR(iss->iss_fck)) {
-        dev_err(iss->dev, "Unable to get iss_fck clock info\n");
+        dev_err(iss->dev, "Unable to get ducati_clk_mux_ck clock info\n");
         return PTR_ERR(iss->iss_fck);
     }

@@ -1033,6 +1056,11 @@ static int iss_get_clocks(struct iss_device *iss)
         return PTR_ERR(iss->iss_ctrlclk);
     }

+    dev_info(iss->dev, "Got clocks\n%s(%s:%s)\n%s(%s:%s)\n", ((struct
clk_core_fake*)((struct clk_fake*)iss->iss_fck)->core)->name,
+                                 ((struct
clk_fake*)iss->iss_fck)->dev_id, ((struct
clk_fake*)iss->iss_fck)->con_id,
+                                 ((struct clk_core_fake*)((struct
clk_fake*)iss->iss_ctrlclk)->core)->name,
+                                 ((struct
clk_fake*)iss->iss_ctrlclk)->dev_id, ((struct
clk_fake*)iss->iss_ctrlclk)->con_id);
+
     return 0;
 }

@@ -1125,58 +1153,221 @@ static void iss_unregister_entities(struct
iss_device *iss)
 }

 /*
- * iss_register_subdev_group - Register a group of subdevices
+ * iss_register_subdev - Register a sub-device
  * @iss: OMAP4 ISS device
- * @board_info: I2C subdevs board information array
+ * @iss_subdev: platform data related to a sub-device
  *
- * Register all I2C subdevices in the board_info array. The array must be
- * terminated by a NULL entry, and the first entry must be the sensor.
+ * Register an I2C sub-device which has not been registered by other
+ * means (such as the Device Tree).
  *
- * Return a pointer to the sensor media entity if it has been successfully
+ * Return a pointer to the sub-device if it has been successfully
  * registered, or NULL otherwise.
  */
 static struct v4l2_subdev *
-iss_register_subdev_group(struct iss_device *iss,
-             struct iss_subdev_i2c_board_info *board_info)
+iss_register_subdev(struct iss_device *iss,
+            struct iss_platform_subdev *iss_subdev)
 {
-    struct v4l2_subdev *sensor = NULL;
-    unsigned int first;
+    struct i2c_adapter *adapter;
+    struct v4l2_subdev *sd;

-    if (board_info->board_info == NULL)
+    if (iss_subdev->board_info == NULL)
         return NULL;

-    for (first = 1; board_info->board_info; ++board_info, first = 0) {
-        struct v4l2_subdev *subdev;
-        struct i2c_adapter *adapter;
+    adapter = i2c_get_adapter(iss_subdev->i2c_adapter_id);
+    if (adapter == NULL) {
+        dev_err(iss->dev,
+            "%s: Unable to get I2C adapter %d for device %s\n",
+            __func__, iss_subdev->i2c_adapter_id,
+            iss_subdev->board_info->type);
+        return NULL;
+    }

-        adapter = i2c_get_adapter(board_info->i2c_adapter_id);
-        if (adapter == NULL) {
-            dev_err(iss->dev,
-                "%s: Unable to get I2C adapter %d for device %s\n",
-                __func__, board_info->i2c_adapter_id,
-                board_info->board_info->type);
-            continue;
+    sd = v4l2_i2c_new_subdev_board(&iss->v4l2_dev, adapter,
+                       iss_subdev->board_info, NULL);
+    if (sd == NULL) {
+        dev_err(iss->dev, "%s: Unable to register subdev %s\n",
+            __func__, iss_subdev->board_info->type);
+        return NULL;
+    }
+
+    return sd;
+}
+
+
+static int iss_link_entity(
+    struct iss_device *iss, struct media_entity *entity,
+    enum iss_interface_type interface)
+{
+    struct media_entity *input;
+    unsigned int flags;
+    unsigned int pad;
+    unsigned int i;
+
+    /* Connect the sensor to the correct interface module.
+     * serial sensors are connected to the CSI2a or CSI2b
+     */
+    switch (interface) {
+
+    case ISS_INTERFACE_CSI2A_PHY1:
+        input = &iss->csi2a.subdev.entity;
+        pad = CSI2_PAD_SINK;
+        flags = MEDIA_LNK_FL_IMMUTABLE | MEDIA_LNK_FL_ENABLED;
+        break;
+
+    case ISS_INTERFACE_CSI2B_PHY2:
+        input = &iss->csi2b.subdev.entity;
+        pad = CSI2_PAD_SINK;
+        flags = MEDIA_LNK_FL_IMMUTABLE | MEDIA_LNK_FL_ENABLED;
+        break;
+
+    default:
+        dev_err(iss->dev, "%s: invalid interface type %u\n", __func__,
+            interface);
+        return -EINVAL;
+    }
+
+    for (i = 0; i < entity->num_pads; i++) {
+        if (entity->pads[i].flags & MEDIA_PAD_FL_SOURCE)
+            break;
+    }
+    if (i == entity->num_pads) {
+        dev_err(iss->dev, "%s: no source pad in external entity\n",
+            __func__);
+        return -EINVAL;
+    }
+
+    return media_entity_create_link(entity, i, input, pad, flags);
+}
+
+static int iss_of_parse_node(struct device *dev, struct device_node *node,
+                 struct iss_async_subdev *isd)
+{
+    struct iss_bus_cfg *buscfg = &isd->bus;
+    struct v4l2_of_endpoint vep;
+    unsigned int i, lanes;
+
+    v4l2_of_parse_endpoint(node, &vep);
+
+    dev_info(dev, "parsing endpoint %s, interface %u\n", node->full_name,
+        vep.base.port);
+
+    switch(vep.base.port) {
+    case ISS_INTERFACE_CSI2A_PHY1:
+        buscfg->interface = ISS_INTERFACE_CSI2A_PHY1;
+        lanes = ISS_CSIPHY1_NUM_DATA_LANES;
+        break;
+
+    case ISS_INTERFACE_CSI2B_PHY2:
+        buscfg->interface = ISS_INTERFACE_CSI2B_PHY2;
+        lanes = ISS_CSIPHY2_NUM_DATA_LANES;
+        break;
+
+    default:
+        dev_warn(dev, "%s: invalid interface %u\n", node->full_name,
+             vep.base.port);
+        return -EINVAL;
+    }
+
+    buscfg->bus.csi2.lanecfg.clk.pos = vep.bus.mipi_csi2.clock_lane;
+    buscfg->bus.csi2.lanecfg.clk.pol =
+        vep.bus.mipi_csi2.lane_polarities[0];
+    dev_info(dev, "clock lane polarity %u, pos %u\n",
+        buscfg->bus.csi2.lanecfg.clk.pol,
+        buscfg->bus.csi2.lanecfg.clk.pos);
+
+    for (i = 0; i < lanes; i++) {
+        buscfg->bus.csi2.lanecfg.data[i].pos =
+            vep.bus.mipi_csi2.data_lanes[i];
+        buscfg->bus.csi2.lanecfg.data[i].pol =
+            vep.bus.mipi_csi2.lane_polarities[i + 1];
+        dev_info(dev, "data lane %u polarity %u, pos %u\n", i,
+            buscfg->bus.csi2.lanecfg.data[i].pol,
+            buscfg->bus.csi2.lanecfg.data[i].pos);
+    }
+
+    /*
+     * FIXME: now we assume the CRC is always there.
+     * Implement a way to obtain this information from the
+     * sensor. Frame descriptors, perhaps?
+     */
+    buscfg->bus.csi2.crc = 0;
+
+    return 0;
+}
+
+static int iss_of_parse_nodes(struct device *dev,
+                  struct v4l2_async_notifier *notifier)
+{
+    struct device_node *node = NULL;
+
+    notifier->subdevs = devm_kcalloc(
+        dev, ISS_MAX_SUBDEVS, sizeof(*notifier->subdevs), GFP_KERNEL);
+    if (!notifier->subdevs)
+        return -ENOMEM;
+
+    while (notifier->num_subdevs < ISS_MAX_SUBDEVS &&
+           (node = of_graph_get_next_endpoint(dev->of_node, node))) {
+        struct iss_async_subdev *isd;
+
+        isd = devm_kzalloc(dev, sizeof(*isd), GFP_KERNEL);
+        if (!isd) {
+            of_node_put(node);
+            return -ENOMEM;
         }

-        subdev = v4l2_i2c_new_subdev_board(&iss->v4l2_dev, adapter,
-                board_info->board_info, NULL);
-        if (subdev == NULL) {
-            dev_err(iss->dev, "Unable to register subdev %s\n",
-                board_info->board_info->type);
-            continue;
+        notifier->subdevs[notifier->num_subdevs] = &isd->asd;
+
+        if (iss_of_parse_node(dev, node, isd)) {
+            of_node_put(node);
+            return -EINVAL;
         }

-        if (first)
-            sensor = subdev;
+        isd->asd.match.of.node = of_graph_get_remote_port_parent(node);
+        of_node_put(node);
+        if (!isd->asd.match.of.node) {
+            dev_warn(dev, "bad remote port parent\n");
+            return -EINVAL;
+        }
+
+        isd->asd.match_type = V4L2_ASYNC_MATCH_OF;
+        notifier->num_subdevs++;
     }

-    return sensor;
+    return notifier->num_subdevs;
+}
+
+static int iss_subdev_notifier_bound(struct v4l2_async_notifier *async,
+                     struct v4l2_subdev *subdev,
+                     struct v4l2_async_subdev *asd)
+{
+    struct iss_device *iss = container_of(async, struct iss_device,
+                          notifier);
+    struct iss_async_subdev *isd =
+        container_of(asd, struct iss_async_subdev, asd);
+    int ret;
+
+    ret = iss_link_entity(iss, &subdev->entity, isd->bus.interface);
+    if (ret < 0)
+        return ret;
+
+    isd->sd = subdev;
+    isd->sd->host_priv = &isd->bus;
+
+    return ret;
+}
+
+static int iss_subdev_notifier_complete(struct v4l2_async_notifier *async)
+{
+    struct iss_device *iss = container_of(async, struct iss_device,
+                          notifier);
+
+    return v4l2_device_register_subdev_nodes(&iss->v4l2_dev);
 }

 static int iss_register_entities(struct iss_device *iss)
 {
     struct iss_platform_data *pdata = iss->pdata;
-    struct iss_v4l2_subdevs_group *subdevs;
+    struct iss_platform_subdev *iss_subdev;
     int ret;

     iss->media_dev.dev = iss->dev;
@@ -1220,56 +1411,40 @@ static int iss_register_entities(struct iss_device *iss)
     if (ret < 0)
         goto done;

+    /*
+     * Device Tree --- the external sub-devices will be registered
+     * later. The same goes for the sub-device node registration.
+     */
+    if (iss->dev->of_node)
+        return 0;
+
     /* Register external entities */
-    for (subdevs = pdata->subdevs; subdevs && subdevs->subdevs; ++subdevs) {
-        struct v4l2_subdev *sensor;
-        struct media_entity *input;
-        unsigned int flags;
-        unsigned int pad;
-
-        sensor = iss_register_subdev_group(iss, subdevs->subdevs);
-        if (sensor == NULL)
-            continue;
+    for (iss_subdev = pdata ? pdata->subdevs : NULL;
+         iss_subdev && iss_subdev->board_info; iss_subdev++) {
+        struct v4l2_subdev *sd;

-        sensor->host_priv = subdevs;
+        sd = iss_register_subdev(iss, iss_subdev);

-        /* Connect the sensor to the correct interface module.
-         * CSI2a receiver through CSIPHY1, or
-         * CSI2b receiver through CSIPHY2
+        /*
+         * No bus information --- this is either a flash or a
+         * lens subdev.
          */
-        switch (subdevs->interface) {
-        case ISS_INTERFACE_CSI2A_PHY1:
-            input = &iss->csi2a.subdev.entity;
-            pad = CSI2_PAD_SINK;
-            flags = MEDIA_LNK_FL_IMMUTABLE
-                  | MEDIA_LNK_FL_ENABLED;
-            break;
+        if (!sd || !iss_subdev->bus)
+            continue;

-        case ISS_INTERFACE_CSI2B_PHY2:
-            input = &iss->csi2b.subdev.entity;
-            pad = CSI2_PAD_SINK;
-            flags = MEDIA_LNK_FL_IMMUTABLE
-                  | MEDIA_LNK_FL_ENABLED;
-            break;
+        sd->host_priv = iss_subdev->bus;

-        default:
-            dev_err(iss->dev, "invalid interface type %u\n",
-                subdevs->interface);
-            ret = -EINVAL;
-            goto done;
-        }
-
-        ret = media_entity_create_link(&sensor->entity, 0, input, pad,
-                           flags);
+        ret = iss_link_entity(iss, &sd->entity,
+                      iss_subdev->bus->interface);
         if (ret < 0)
             goto done;
     }

     ret = v4l2_device_register_subdev_nodes(&iss->v4l2_dev);
-
 done:
-    if (ret < 0)
+    if (ret < 0) {
         iss_unregister_entities(iss);
+    }

     return ret;
 }
@@ -1362,24 +1537,62 @@ error_csiphy:
     return ret;
 }

+
+/*
+We need a better solution for this
+*/
+#include <../arch/arm/mach-omap2/omap-pm.h>
+
+static void iss_set_constraints(struct iss_device *iss, bool enable)
+{
+    if (!iss)
+        return;
+
+    /* FIXME: Look for something more precise as a good throughtput limit */
+    omap_pm_set_min_bus_tput(iss->dev, OCP_INITIATOR_AGENT,
+                 enable ? 800000 : -1);
+}
+
+static struct iss_platform_data iss_dummy_pdata = {
+    .set_constraints = iss_set_constraints,
+};
+
 static int iss_probe(struct platform_device *pdev)
 {
-    struct iss_platform_data *pdata = pdev->dev.platform_data;
     struct iss_device *iss;
     unsigned int i;
-    int ret;
-
-    if (pdata == NULL)
-        return -EINVAL;
+    int ret, r;

     iss = devm_kzalloc(&pdev->dev, sizeof(*iss), GFP_KERNEL);
-    if (!iss)
+    if (!iss) {
+        dev_err(&pdev->dev, "could not allocate memory\n");
         return -ENOMEM;
+    }
+
+    if (IS_ENABLED(CONFIG_OF) && pdev->dev.of_node) {
+        ret = iss_of_parse_nodes(&pdev->dev, &iss->notifier);
+        if (ret < 0)
+            return ret;
+        ret = v4l2_async_notifier_register(&iss->v4l2_dev,
+                           &iss->notifier);
+        if (ret)
+            return ret;
+
+        /* use dummy pdata with set constraints function */
+        iss->pdata = &iss_dummy_pdata;
+    } else {
+        iss->pdata = pdev->dev.platform_data;
+        dev_warn(&pdev->dev,
+             "Platform data support is deprecated! Please move to DT now!\n");
+    }
+
+    pm_runtime_enable(&pdev->dev);
+    r = pm_runtime_get_sync(&pdev->dev);

     mutex_init(&iss->iss_mutex);

     iss->dev = &pdev->dev;
-    iss->pdata = pdata;
+    iss->ref_count = 0;

     iss->raw_dmamask = DMA_BIT_MASK(32);
     iss->dev->dma_mask = &iss->raw_dmamask;
@@ -1415,30 +1628,30 @@ static int iss_probe(struct platform_device *pdev)

     iss->revision = iss_reg_read(iss, OMAP4_ISS_MEM_TOP, ISS_HL_REVISION);
     dev_info(iss->dev, "Revision %08x found\n", iss->revision);
-
+dev_info(iss->dev, "A\n");
     for (i = 1; i < OMAP4_ISS_MEM_LAST; i++) {
         ret = iss_map_mem_resource(pdev, iss, i);
         if (ret)
             goto error_iss;
     }
-
+dev_info(iss->dev, "B\n");
     /* Configure BTE BW_LIMITER field to max recommended value (1 GB) */
     iss_reg_update(iss, OMAP4_ISS_MEM_BTE, BTE_CTRL,
                BTE_CTRL_BW_LIMITER_MASK,
                18 << BTE_CTRL_BW_LIMITER_SHIFT);
-
+dev_info(iss->dev, "C\n");
     /* Perform ISP reset */
     ret = omap4iss_subclk_enable(iss, OMAP4_ISS_SUBCLK_ISP);
     if (ret < 0)
         goto error_iss;
-
+dev_info(iss->dev, "D\n");
     ret = iss_isp_reset(iss);
     if (ret < 0)
         goto error_iss;
-
+dev_info(iss->dev, "E\n");
     dev_info(iss->dev, "ISP Revision %08x found\n",
          iss_reg_read(iss, OMAP4_ISS_MEM_ISP_SYS1, ISP5_REVISION));
-
+dev_info(iss->dev, "F\n");
     /* Interrupt */
     iss->irq_num = platform_get_irq(pdev, 0);
     if (iss->irq_num <= 0) {
@@ -1446,28 +1659,32 @@ static int iss_probe(struct platform_device *pdev)
         ret = -ENODEV;
         goto error_iss;
     }
-
+dev_info(iss->dev, "G\n");
     if (devm_request_irq(iss->dev, iss->irq_num, iss_isr, IRQF_SHARED,
                  "OMAP4 ISS", iss)) {
         dev_err(iss->dev, "Unable to request IRQ\n");
         ret = -EINVAL;
         goto error_iss;
     }
-
+dev_info(iss->dev, "H\n");
     /* Entities */
     ret = iss_initialize_modules(iss);
     if (ret < 0)
         goto error_iss;
+dev_info(iss->dev, "I\n");
+    iss->notifier.bound = iss_subdev_notifier_bound;
+    iss->notifier.complete = iss_subdev_notifier_complete;

     ret = iss_register_entities(iss);
     if (ret < 0)
         goto error_modules;
-
+dev_info(iss->dev, "J\n");
     omap4iss_put(iss);
-
+dev_info(iss->dev, "K\n");
     return 0;

 error_modules:
+    v4l2_async_notifier_unregister(&iss->notifier);
     iss_cleanup_modules(iss);
 error_iss:
     omap4iss_put(iss);
@@ -1495,12 +1712,20 @@ static struct platform_device_id omap4iss_id_table[] = {
 };
 MODULE_DEVICE_TABLE(platform, omap4iss_id_table);

+static struct of_device_id omap4iss_of_table[] = {
+    { .compatible = "ti,omap4-iss" },
+    { },
+};
+MODULE_DEVICE_TABLE(of, omap4iss_of_table);
+
+
 static struct platform_driver iss_driver = {
     .probe        = iss_probe,
     .remove        = iss_remove,
     .id_table    = omap4iss_id_table,
     .driver = {
         .name    = "omap4iss",
+        .of_match_table = omap4iss_of_table,
     },
 };

diff --git a/drivers/staging/media/omap4iss/iss.h
b/drivers/staging/media/omap4iss/iss.h
index 35df8b4..7830061 100644
--- a/drivers/staging/media/omap4iss/iss.h
+++ b/drivers/staging/media/omap4iss/iss.h
@@ -15,6 +15,7 @@
 #define _OMAP4_ISS_H_

 #include <media/v4l2-device.h>
+#include <media/v4l2-of.h>
 #include <linux/device.h>
 #include <linux/io.h>
 #include <linux/platform_device.h>
@@ -86,6 +87,7 @@ struct iss_reg {
  */
 struct iss_device {
     struct v4l2_device v4l2_dev;
+    struct v4l2_async_notifier notifier;
     struct media_device media_dev;
     struct device *dev;
     u32 revision;
@@ -119,6 +121,15 @@ struct iss_device {

     unsigned int subclk_resources;
     unsigned int isp_subclk_resources;
+
+#define ISS_MAX_SUBDEVS        2
+    struct v4l2_subdev *subdevs[ISS_MAX_SUBDEVS];
+};
+
+struct iss_async_subdev {
+    struct v4l2_subdev *sd;
+    struct iss_bus_cfg bus;
+    struct v4l2_async_subdev asd;
 };

 #define v4l2_dev_to_iss_device(dev) \
diff --git a/drivers/staging/media/omap4iss/iss_csi2.c
b/drivers/staging/media/omap4iss/iss_csi2.c
index d7ff769..0002869 100644
--- a/drivers/staging/media/omap4iss/iss_csi2.c
+++ b/drivers/staging/media/omap4iss/iss_csi2.c
@@ -479,6 +479,7 @@ static void csi2_irq_status_set(struct
iss_csi2_device *csi2, int enable)
         iss_reg_write(csi2->iss, csi2->regs1, CSI2_IRQENABLE, 0);
 }

+static void csi2_print_status(struct iss_csi2_device *csi2);
 /*
  * omap4iss_csi2_reset - Resets the CSI2 module.
  *
@@ -515,6 +516,7 @@ int omap4iss_csi2_reset(struct iss_csi2_device *csi2)
         REGISTER1_RESET_DONE_CTRLCLK, 10000, 100, 500);
     if (timeout) {
         dev_err(csi2->iss->dev, "CSI2: CSI2_96M_FCLK reset timeout!\n");
+csi2_print_status(csi2);
         return -EBUSY;
     }

@@ -528,7 +530,7 @@ int omap4iss_csi2_reset(struct iss_csi2_device *csi2)

 static int csi2_configure(struct iss_csi2_device *csi2)
 {
-    const struct iss_v4l2_subdevs_group *pdata;
+    const struct iss_bus_cfg *pdata;
     struct iss_csi2_timing_cfg *timing = &csi2->timing[0];
     struct v4l2_subdev *sensor;
     struct media_pad *pad;
diff --git a/drivers/staging/media/omap4iss/iss_csiphy.c
b/drivers/staging/media/omap4iss/iss_csiphy.c
index 748607f..da59dca 100644
--- a/drivers/staging/media/omap4iss/iss_csiphy.c
+++ b/drivers/staging/media/omap4iss/iss_csiphy.c
@@ -121,7 +121,7 @@ int omap4iss_csiphy_config(struct iss_device *iss,
 {
     struct iss_csi2_device *csi2 = v4l2_get_subdevdata(csi2_subdev);
     struct iss_pipeline *pipe = to_iss_pipeline(&csi2_subdev->entity);
-    struct iss_v4l2_subdevs_group *subdevs = pipe->external->host_priv;
+    struct iss_bus_cfg *buscfg = pipe->external->host_priv;
     struct iss_csiphy_dphy_cfg csi2phy;
     int csi2_ddrclk_khz;
     struct iss_csiphy_lanes_cfg *lanes;
@@ -129,7 +129,14 @@ int omap4iss_csiphy_config(struct iss_device *iss,
     u32 cam_rx_ctrl;
     unsigned int i;

-    lanes = &subdevs->bus.csi2.lanecfg;
+    if (!buscfg) {
+        struct iss_async_subdev *isd =
+            container_of(pipe->external->asd,
+                     struct iss_async_subdev, asd);
+        buscfg = &isd->bus;
+    }
+
+    lanes = &buscfg->bus.csi2.lanecfg;

     /*
      * SCM.CONTROL_CAMERA_RX
@@ -147,7 +154,8 @@ int omap4iss_csiphy_config(struct iss_device *iss,
      */
     regmap_read(iss->syscon, 0x68, &cam_rx_ctrl);

-    if (subdevs->interface == ISS_INTERFACE_CSI2A_PHY1) {
+
+    if (buscfg->interface == ISS_INTERFACE_CSI2A_PHY1) {
         cam_rx_ctrl &= ~(OMAP4_CAMERARX_CSI21_LANEENABLE_MASK |
                 OMAP4_CAMERARX_CSI21_CAMMODE_MASK);
         /* NOTE: Leave CSIPHY1 config to 0x0: D-PHY mode */
@@ -158,7 +166,7 @@ int omap4iss_csiphy_config(struct iss_device *iss,
         cam_rx_ctrl |= OMAP4_CAMERARX_CSI21_CTRLCLKEN_MASK;
     }

-    if (subdevs->interface == ISS_INTERFACE_CSI2B_PHY2) {
+    if (buscfg->interface == ISS_INTERFACE_CSI2B_PHY2) {
         cam_rx_ctrl &= ~(OMAP4_CAMERARX_CSI22_LANEENABLE_MASK |
                 OMAP4_CAMERARX_CSI22_CAMMODE_MASK);
         /* NOTE: Leave CSIPHY2 config to 0x0: D-PHY mode */
diff --git a/drivers/staging/media/omap4iss/iss_video.c
b/drivers/staging/media/omap4iss/iss_video.c
index 85c54fe..daf85c4 100644
--- a/drivers/staging/media/omap4iss/iss_video.c
+++ b/drivers/staging/media/omap4iss/iss_video.c
@@ -844,7 +844,7 @@ iss_video_streamon(struct file *file, void *fh,
enum v4l2_buf_type type)
     pipe->external_bpp = 0;
     pipe->entities = 0;

-    if (video->iss->pdata->set_constraints)
+    if (video->iss->pdata && video->iss->pdata->set_constraints)
         video->iss->pdata->set_constraints(video->iss, true);

     ret = media_entity_pipeline_start(&video->video.entity, &pipe->pipe);
@@ -932,7 +932,7 @@ err_omap4iss_set_stream:
 err_iss_video_check_format:
     media_entity_pipeline_stop(&video->video.entity);
 err_media_entity_pipeline_start:
-    if (video->iss->pdata->set_constraints)
+    if (video->iss->pdata && video->iss->pdata->set_constraints)
         video->iss->pdata->set_constraints(video->iss, false);
     video->queue = NULL;

@@ -974,7 +974,7 @@ iss_video_streamoff(struct file *file, void *fh,
enum v4l2_buf_type type)
     vb2_streamoff(&vfh->queue, type);
     video->queue = NULL;

-    if (video->iss->pdata->set_constraints)
+    if (video->iss->pdata && video->iss->pdata->set_constraints)
         video->iss->pdata->set_constraints(video->iss, false);
     media_entity_pipeline_stop(&video->video.entity);

diff --git a/include/media/omap4iss.h b/include/media/omap4iss.h
index 0d7620d..8f25cf1 100644
--- a/include/media/omap4iss.h
+++ b/include/media/omap4iss.h
@@ -6,7 +6,7 @@
 struct iss_device;

 enum iss_interface_type {
-    ISS_INTERFACE_CSI2A_PHY1,
+    ISS_INTERFACE_CSI2A_PHY1 = 0,
     ISS_INTERFACE_CSI2B_PHY2,
 };

@@ -44,21 +44,21 @@ struct iss_csi2_platform_data {
     struct iss_csiphy_lanes_cfg lanecfg;
 };

-struct iss_subdev_i2c_board_info {
-    struct i2c_board_info *board_info;
-    int i2c_adapter_id;
-};
-
-struct iss_v4l2_subdevs_group {
-    struct iss_subdev_i2c_board_info *subdevs;
+struct iss_bus_cfg {
     enum iss_interface_type interface;
     union {
         struct iss_csi2_platform_data csi2;
     } bus; /* gcc < 4.6.0 chokes on anonymous union initializers */
 };

+struct iss_platform_subdev {
+    struct i2c_board_info *board_info;
+    int i2c_adapter_id;
+    struct iss_bus_cfg *bus;
+};
+
 struct iss_platform_data {
-    struct iss_v4l2_subdevs_group *subdevs;
+    struct iss_platform_subdev *subdevs;
     void (*set_constraints)(struct iss_device *iss, bool enable);
 };

-- 
1.9.1
