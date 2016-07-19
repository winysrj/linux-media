Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:56033 "EHLO
	smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947AbcGSOXQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2016 10:23:16 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
To: linux-media@vger.kernel.org, ulrich.hecht@gmail.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com
Cc: linux-renesas-soc@vger.kernel.org,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCHv2 14/16] [media] rcar-vin: add shared subdevice groups
Date: Tue, 19 Jul 2016 16:21:05 +0200
Message-Id: <20160719142107.22358-15-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20160719142107.22358-1-niklas.soderlund+renesas@ragnatech.se>
References: <20160719142107.22358-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is done to prepare for Gen3 support where there are more than one
subdevice and the usage of them are complex and can be shared between
multiple rcar-vin instances. There are a few trouble areas with Gen3
that needs to be solved in order to be able to capture video.

1. There can be up to 4 CSI-2 sources, CSI20, CSI21, CSI40 and CSI41.
   Each CSI-2 source can be used simultaneously by more then one VIN
   instance, as shown below. This requires that more then one rcar-vin
   instance be able to to use the same set of subdevices at the same
   time.

2. There can be up to 8 VIN instances, VIN0-VIN7. Each instance can
   capture video simultaneous as any other instance, but they are not
   fully independent of each other. There is one register which controls
   what input source is used that is only present in VIN0 and VIN4. The
   register in VIN0 controls input source for VIN0-VIN3 and the register
   in VIN4 input source for VIN4-7.

   To further complicate input selection it is not possible to
   independently select an input for a specific VIN instance, the whole
   group of VIN0-3 or VIN4-7 are needs to be set according to these
   predetermined selections.

   - VIN0-3 controlled by chsel bits in VnCSI_IFMD register in VIN0
   chsel    VIN0        VIN1        VIN2        VIN3
   0        CSI40/VC0   CSI20/VC0   CSI21/VC0   CSI40/VC1
   1        CSI20/VC0   CSI21/VC0   CSI40/VC0   CSI20/VC1
   2        CSI21/VC0   CSI40/VC0   CSI20/VC0   CSI21/VC1
   3        CSI40/VC0   CSI40/VC1   CSI40/VC2   CSI40/VC3
   4        CSI20/VC0   CSI20/VC1   CSI20/VC2   CSI20/VC3
   5        CSI21/VC0   CSI21/VC1   CSI21/VC2   CSI21/VC3

   - VIN4-7 controlled by chsel bits in VnCSI_IFMD register in VIN4
   chsel    VIN4        VIN5        VIN6        VIN7
   0        CSI41/VC0   CSI20/VC0   CSI21/VC0   CSI41/VC1
   1        CSI20/VC0   CSI21/VC0   CSI41/VC0   CSI20/VC1
   2        CSI21/VC0   CSI41/VC0   CSI20/VC0   CSI21/VC1
   3        CSI41/VC0   CSI41/VC1   CSI41/VC2   CSI41/VC3
   4        CSI20/VC0   CSI20/VC1   CSI20/VC2   CSI20/VC3
   5        CSI21/VC0   CSI21/VC1   CSI21/VC2   CSI21/VC3

3. Some VIN instances (VIN4 and VIN5) can in addition the shared CSI-2
   sources described above have access to a private digital input
   channel.

This patch tries to solve this problem by adding a group concept to the
rcar-vin driver. One VIN instance is in DT described to be the group
master. It can be any VIN node but preferably it should be VIN0 or VIN4
since at lest one of those nodes are required to control the chsel bits.
To allow CSI-2 input for VIN0-3 the VIN0 node must be present and the
same is true for VIN4-7 and VIN4. One can even have two separate groups
one for VIN0-3 and one for VIN4-7 provided the two groups don't want to
share a CSI-2 input source.

Each rcar-vin instance will register itself as a v4l2 subdevice in
addition to a video device. This subdevice serves a few purposes:

    1. Allow for the group master to find all rcar-vin members of its
       group and bind them.

    2. Allow for the group master to control the chsel bits using the
       only operation implemented on the subdevice, s_gpio. This
       operation is only valid for VIN0 and VIN4 instances of rcar-vin.

    3. Allow for the slave rcar-vin members to access the group API
       exposed by the master by use of the subdevice v4l2_dev pointer.

The master rcar-vin instance will bind to all subdevices needed by the
group. That is all the rcar-vin slave nodes, CSI-2 nodes and the video
source subdevices which is connected to the other end of the CSI-2
nodes. It will expose an API to the slave nodes by setting the subdevice
v4l2_dev pointer.

The group API exposed by the master allows each slave rcar-vin instance
to operate on the correct set of subdevices for the current chsel value
simply by using the operation rvin_subdev_call() instead of
v4l2_subdev_call(). There is one special case for the operations
involved in input enumeration (g_input_status, g_tvnorms, dv_timings_cap
and *enum_dv_timings), where an extension is made
v4l2_subdev_call_input() which allows for the slave to specify which of
its inputs it wish to operate on.

Inside the group API there is refcounting keeping track of s_power and
s_stream calls so they are not called multiple times for the same set of
subdevices. This is needed since more then one rcar-vin slave can view
the same input. The second instance will simply join an ongoing stream.

Each rcar-vin slave can request for the input to be changed (chsel
value) for its subgroup (VIN0-3 or VIN4-7). But there are a few
restrictions on if the input changed is allowed. These restrictions
exist to prevent one rcar-vin instance from pulling the rug from
another.

    1. It is only allowed to change input if the request is coming from
       a sole user of the subgroup. That is to say if there is exactly
       one open video device in the subgroup (the one requesting the
       input change). Multiple opens of the same video device are
       treated as there are more then one user of the subgroup.

    2. A rcar-vin slave can only switch to an input source that is valid
       for itself. That is to say if the group only have access to
       CSI20 and CSI40 it is invalid for a slave instance to request a
       chsel value that would put CSI21 as its input.

A final restriction on the driver as a whole are that it's not allowed
to open a video device if the current chsel value puts its input on a
CSI-2 node that is not available. An attempt to do so will result in a
-EBUSY error.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 .../devicetree/bindings/media/rcar_vin.txt         |  218 +++-
 drivers/media/platform/rcar-vin/Makefile           |    2 +-
 drivers/media/platform/rcar-vin/rcar-core.c        |  174 +--
 drivers/media/platform/rcar-vin/rcar-dma.c         |   67 ++
 drivers/media/platform/rcar-vin/rcar-group.c       | 1250 ++++++++++++++++++++
 drivers/media/platform/rcar-vin/rcar-group.h       |  104 ++
 drivers/media/platform/rcar-vin/rcar-v4l2.c        |    5 +-
 drivers/media/platform/rcar-vin/rcar-vin.h         |   63 +-
 8 files changed, 1763 insertions(+), 120 deletions(-)
 create mode 100644 drivers/media/platform/rcar-vin/rcar-group.c
 create mode 100644 drivers/media/platform/rcar-vin/rcar-group.h

diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
index 6a4e61c..9aa81dd 100644
--- a/Documentation/devicetree/bindings/media/rcar_vin.txt
+++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
@@ -2,8 +2,13 @@ Renesas RCar Video Input driver (rcar_vin)
 ------------------------------------------
 
 The rcar_vin device provides video input capabilities for the Renesas R-Car
-family of devices. The current blocks are always slaves and suppot one input
-channel which can be either RGB, YUYV or BT656.
+family of devices.
+
+On Gen2 the current blocks are always slaves and support one input
+channel which can be either RGB, YUYV or BT656
+
+On Gen3 the current blocks are always slaves and support multiple inputs
+channels which can be ether RGB, YUVU, BT656 or CSI-2.
 
  - compatible: Must be one or more of the following
    - "renesas,vin-r8a7795" for the R8A7795 device
@@ -28,7 +33,30 @@ channel which can be either RGB, YUYV or BT656.
 Additionally, an alias named vinX will need to be created to specify
 which video input device this is.
 
-The per-board settings:
+On Gen3 additional ports can be specified to describe the CSI-2 group
+hierarchy. Port 0 are used to describe inputs (in per-board settings)
+and VIN group membership. Port 1 are used to describe CSI-2 endpoints.
+Port 2 are used to describe VIN endpoints which are part of the group.
+    - ports:
+        - port@0:
+            - reg 1: sub-node describing a endpoint connected to the VIN
+              group master.
+        - port@1: remote CSI-2 endpoints part of VIN group
+            - reg 0: sub-node describing a endpoint to CSI20
+            - reg 1: sub-node describing a endpoint to CSI21
+            - reg 3: sub-node describing a endpoint to CSI40
+            - reg 4: sub-node describing a endpoint to CSI41
+        - port@2: remote VIN endpoints part of VIN group
+            - reg 0: sub-node describing a endpoint to VIN0
+            - reg 1: sub-node describing a endpoint to VIN1
+            - reg 2: sub-node describing a endpoint to VIN2
+            - reg 3: sub-node describing a endpoint to VIN3
+            - reg 4: sub-node describing a endpoint to VIN4
+            - reg 5: sub-node describing a endpoint to VIN5
+            - reg 6: sub-node describing a endpoint to VIN6
+            - reg 7: sub-node describing a endpoint to VIN7
+
+The per-board settings Gen2:
  - port sub-node describing a single endpoint connected to the vin
    as described in video-interfaces.txt[1]. Only the first one will
    be considered as each vin interface has one input port.
@@ -36,9 +64,17 @@ The per-board settings:
    These settings are used to work out video input format and widths
    into the system.
 
+The per-board settings Gen3:
+-ports:
+    - port@0:
+        - reg 0: sub-node describing a endpoint connected to the VIN
+          private digital input as described in video-interfaces.txt[1].
+
+   These settings are used to work out video input format and widths
+   into the system.
 
-Device node example
--------------------
+Device node example Gen2
+------------------------
 
 	aliases {
 	       vin0 = &vin0;
@@ -52,8 +88,8 @@ Device node example
                 status = "disabled";
         };
 
-Board setup example (vin1 composite video input)
-------------------------------------------------
+Board setup example Gen2 (vin1 composite video input)
+-----------------------------------------------------
 
 &i2c2   {
         status = "ok";
@@ -92,6 +128,174 @@ Board setup example (vin1 composite video input)
         };
 };
 
+Device node example Gen3
+------------------------
+
+aliases {
+       vin0 = &vin0;
+       vin4 = &vin4;
+};
+
+csi21: csi2@fea90000 {
+        ...
+
+        ports {
+                #address-cells = <1>;
+                #size-cells = <0>;
+
+                port@1 {
+                        reg = <1>;
+
+                        csi21_out: endpoint@1 {
+                                remote-endpoint =  <&vin0csi21>;
+                        };
+                };
+        };
+};
+
+vin0: video@e6ef0000 {
+        compatible = "renesas,vin-r8a7795";
+        reg = <0 0xe6ef0000 0 0x1000>;
+        interrupts = <0 188 IRQ_TYPE_LEVEL_HIGH>;
+        clocks = <&cpg CPG_MOD 811>;
+        power-domains = <&cpg>;
+        status = "disabled";
+
+        ports {
+                #address-cells = <1>;
+                #size-cells = <0>;
+
+                port@0 {
+                        reg = <0>;
+                        #address-cells = <1>;
+                        #size-cells = <0>;
+
+                        vin0csi: endpoint@1 {
+                                reg = <1>;
+                                remote-endpoint= <&vin0out0>;
+                        };
+
+                };
+                port@1 {
+                        reg = <1>;
+                        #address-cells = <1>;
+                        #size-cells = <0>;
+
+                        vin0csi21: endpoint@1 {
+                                reg = <1>;
+                                remote-endpoint= <&csi21_out>;
+                        };
+                };
+                port@2 {
+                        reg = <2>;
+                        #address-cells = <1>;
+                        #size-cells = <0>;
+
+                        vin0out0: endpoint@0 {
+                                reg = <0>;
+                                remote-endpoint = <&vin0csi>;
+                        };
+                        vin0out4: endpoint@4 {
+                                reg = <4>;
+                                remote-endpoint = <&vin4csi>;
+                        };
+                };
+        };
+};
+
+vin4: video@e6ef4000 {
+        compatible = "renesas,vin-r8a7795";
+        reg = <0 0xe6ef4000 0 0x1000>;
+        interrupts = <0 174 IRQ_TYPE_LEVEL_HIGH>;
+        clocks = <&cpg CPG_MOD 807>;
+        power-domains = <&cpg>;
+        status = "disabled";
+
+        ports {
+                #address-cells = <1>;
+                #size-cells = <0>;
+
+                port@0 {
+                        reg = <0>;
+                        #address-cells = <1>;
+                        #size-cells = <0>;
+
+                        vin4csi: endpoint@1 {
+                                reg = <1>;
+                                remote-endpoint = <&vin0out4>;
+                        };
+                };
+        };
+};
+
+Board setup example Gen3
+- VIN0 and VIN4 part of CSI-2 group
+- VIN4 with local digital input
+-----------------------------------------------------
+
+&i2c2   {
+        ...
+
+        adv7482: composite-in@70 {
+                ...
+                port {
+                        adv7482_out: endpoint@1 {
+                                clock-lanes = <0>;
+                                data-lanes = <1>;
+                                remote-endpoint = <&csi21_in>;
+                        };
+                };
+        };
 
+        adv7612: composite-in@20 {
+                ...
+                port {
+                        adv7612_out: endpoint {
+                                bus-width = <8>;
+                                remote-endpoint = <&vin4ep0>;
+                        };
+                };
+        };
+};
+
+&csi21 {
+        status = "okay";
+
+        ...
+
+        ports {
+                port@0 {
+                        reg = <0>;
+
+                        csi21_in: endpoint@0 {
+                                clock-lanes = <0>;
+                                data-lanes = <1>;
+                                remote-endpoint = <&adv7482_out>;
+                        };
+                };
+        };
+};
+
+&vin0 {
+        status = "okay";
+};
+
+&vin4 {
+        status = "okay";
+
+        ports {
+                port@0 {
+                        reg = <0>;
+                        #address-cells = <1>;
+                        #size-cells = <0>;
+
+                        vin4ep0: endpoint@0 {
+                                reg = <0>;
+                                remote-endpoint= <&adv7612_out>;
+                        };
+
+                };
+        };
+};
 
 [1] video-interfaces.txt common video media interface
diff --git a/drivers/media/platform/rcar-vin/Makefile b/drivers/media/platform/rcar-vin/Makefile
index 48c5632..7af1b36 100644
--- a/drivers/media/platform/rcar-vin/Makefile
+++ b/drivers/media/platform/rcar-vin/Makefile
@@ -1,3 +1,3 @@
-rcar-vin-objs = rcar-core.o rcar-dma.o rcar-v4l2.o
+rcar-vin-objs = rcar-core.o rcar-dma.o rcar-v4l2.o rcar-group.o
 
 obj-$(CONFIG_VIDEO_RCAR_VIN) += rcar-vin.o
diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index 5171953..8842777 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -29,39 +29,76 @@
  * Subdevice group helpers
  */
 
-static unsigned int rvin_pad_idx(struct v4l2_subdev *sd, int direction)
-{
-	unsigned int pad_idx;
-
-	for (pad_idx = 0; pad_idx < sd->entity.num_pads; pad_idx++)
-		if (sd->entity.pads[pad_idx].flags == direction)
-			return pad_idx;
-
-	return 0;
-}
+#define rvin_group_call_func(v, f, args...)				\
+	(v->slave.v4l2_dev ? vin_to_group(v)->f(&v->slave, ##args) : -ENODEV)
 
+/*
+ * Rebuilds the list of possible inputs based on subdevices available local
+ * to the VIN and shared in the VIN group. Set the current input to the
+ * available one of the same type (local or group) as was last used.
+ */
 int rvin_subdev_get(struct rvin_dev *vin)
 {
-	strncpy(vin->inputs[0].name, "Digital", RVIN_INPUT_NAME_SIZE);
-	vin->inputs[0].sink_idx =
-		rvin_pad_idx(vin->digital.subdev, MEDIA_PAD_FL_SINK);
-	vin->inputs[0].source_idx =
-		rvin_pad_idx(vin->digital.subdev, MEDIA_PAD_FL_SOURCE);
+	int i, num = 0;
+
+	for (i = 0; i < RVIN_INPUT_MAX; i++) {
+		vin->inputs[i].type = RVIN_INPUT_NONE;
+		vin->inputs[i].hint = false;
+	}
+
+	/* Get inputs from CSI2 group */
+	if (vin->slave.v4l2_dev)
+		num = rvin_group_call_func(vin, get, vin->inputs);
+
+	/* Add local digital input */
+	if (num < RVIN_INPUT_MAX && vin->digital.subdev) {
+		vin->inputs[num].type = RVIN_INPUT_DIGITAL;
+		strncpy(vin->inputs[num].name, "Digital", RVIN_INPUT_NAME_SIZE);
+		vin->inputs[num].sink_idx =
+			rvin_pad_idx(vin->digital.subdev, MEDIA_PAD_FL_SINK);
+		vin->inputs[num].source_idx =
+			rvin_pad_idx(vin->digital.subdev, MEDIA_PAD_FL_SOURCE);
+		/* If last input was digital we want it again */
+		if (vin->current_input == RVIN_INPUT_DIGITAL)
+			vin->inputs[num].hint = true;
+	}
 
+	/* Make sure we have at least one input */
+	if (vin->inputs[0].type == RVIN_INPUT_NONE) {
+		vin_err(vin, "No inputs for channel with current selection\n");
+		return -EBUSY;
+	}
 	vin->current_input = 0;
 
+	/* Search for hint and prefer digital over CSI2 run over all elements */
+	for (i = 0; i < RVIN_INPUT_MAX; i++)
+		if (vin->inputs[i].hint)
+			vin->current_input = i;
+
 	return 0;
 }
 
+/*
+ * Release all inputs used for this device. Store the type of input that
+ * was used so when the input list is generated the same type can be set as
+ * default input.
+ */
 int rvin_subdev_put(struct rvin_dev *vin)
 {
-	vin->current_input = 0;
+	/* Store what type of input we used */
+	vin->current_input = vin->inputs[vin->current_input].type;
+
+	if (vin->slave.v4l2_dev)
+		rvin_group_call_func(vin, put);
 
 	return 0;
 }
 
 int rvin_subdev_set_input(struct rvin_dev *vin, struct rvin_input_item *item)
 {
+	if (rvin_input_is_csi(vin))
+		return rvin_group_call_func(vin, set_input, item);
+
 	if (vin->digital.subdev)
 		return 0;
 
@@ -70,6 +107,9 @@ int rvin_subdev_set_input(struct rvin_dev *vin, struct rvin_input_item *item)
 
 int rvin_subdev_get_code(struct rvin_dev *vin, u32 *code)
 {
+	if (rvin_input_is_csi(vin))
+		return rvin_group_call_func(vin, get_code, code);
+
 	*code = vin->digital.code;
 	return 0;
 }
@@ -77,6 +117,9 @@ int rvin_subdev_get_code(struct rvin_dev *vin, u32 *code)
 int rvin_subdev_get_mbus_cfg(struct rvin_dev *vin,
 			     struct v4l2_mbus_config *mbus_cfg)
 {
+	if (rvin_input_is_csi(vin))
+		return rvin_group_call_func(vin, get_mbus_cfg, mbus_cfg);
+
 	*mbus_cfg = vin->digital.mbus_cfg;
 	return 0;
 }
@@ -84,6 +127,14 @@ int rvin_subdev_get_mbus_cfg(struct rvin_dev *vin,
 struct v4l2_subdev_pad_config*
 rvin_subdev_alloc_pad_config(struct rvin_dev *vin)
 {
+	struct v4l2_subdev_pad_config *cfg;
+
+	if (rvin_input_is_csi(vin)) {
+		if (rvin_group_call_func(vin, alloc_pad_config, &cfg))
+			return NULL;
+		return cfg;
+	}
+
 	return v4l2_subdev_alloc_pad_config(vin->digital.subdev);
 }
 
@@ -97,6 +148,10 @@ int rvin_subdev_ctrl_add_handler(struct rvin_dev *vin)
 	if (ret < 0)
 		return ret;
 
+	if (rvin_input_is_csi(vin))
+		return rvin_group_call_func(vin, ctrl_add_handler,
+					    &vin->ctrl_handler);
+
 	return v4l2_ctrl_add_handler(&vin->ctrl_handler,
 				     vin->digital.subdev->ctrl_handler, NULL);
 }
@@ -107,66 +162,6 @@ int rvin_subdev_ctrl_add_handler(struct rvin_dev *vin)
 
 #define notifier_to_vin(n) container_of(n, struct rvin_dev, notifier)
 
-static bool rvin_mbus_supported(struct rvin_graph_entity *entity)
-{
-	struct v4l2_subdev *sd = entity->subdev;
-	struct v4l2_subdev_mbus_code_enum code = {
-		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
-	};
-	bool found;
-
-	code.index = 0;
-	while (!v4l2_subdev_call(sd, pad, enum_mbus_code, NULL, &code)) {
-		code.index++;
-		switch (code.code) {
-		case MEDIA_BUS_FMT_YUYV8_1X16:
-		case MEDIA_BUS_FMT_UYVY8_2X8:
-		case MEDIA_BUS_FMT_UYVY10_2X10:
-		case MEDIA_BUS_FMT_RGB888_1X24:
-			entity->code = code.code;
-			return true;
-		default:
-			break;
-		}
-	}
-
-	/*
-	 * Older versions where looking for the wrong media bus format.
-	 * It where looking for a YUVY format but then treated it as a
-	 * UYVY format. This was not noticed since atlest one subdevice
-	 * used for testing (adv7180) reported a YUVY media bus format
-	 * but provided UYVY data. There might be other unknown subdevices
-	 * which also do this, to not break compatibility try to use them
-	 * in legacy mode.
-	 */
-	found = false;
-	code.index = 0;
-	while (!v4l2_subdev_call(sd, pad, enum_mbus_code, NULL, &code)) {
-		code.index++;
-		switch (code.code) {
-		case MEDIA_BUS_FMT_YUYV8_2X8:
-			vin->source.code = MEDIA_BUS_FMT_UYVY8_2X8;
-			found = true;
-			break;
-		case MEDIA_BUS_FMT_YUYV10_2X10:
-			vin->source.code = MEDIA_BUS_FMT_UYVY10_2X10;
-			found = true;
-			break;
-		default:
-			break;
-		}
-
-		if (found) {
-			vin_err(vin,
-				"media bus %d not supported, trying legacy mode %d\n",
-				code.code, vin->source.code);
-			return true;
-		}
-	}
-
-	return false;
-}
-
 static int rvin_digital_notify_complete(struct v4l2_async_notifier *notifier)
 {
 	struct rvin_dev *vin = notifier_to_vin(notifier);
@@ -268,7 +263,8 @@ static int rvin_digital_graph_parse(struct rvin_dev *vin)
 	 * Port 0 id 0 is local digital input, try to get it.
 	 * Not all instances can or will have this, that is OK
 	 */
-	ep = of_graph_get_endpoint_by_regs(vin->dev->of_node, 0, 0);
+	ep = of_graph_get_endpoint_by_regs(vin->dev->of_node, RVIN_PORT_LOCAL,
+					   0);
 	if (!ep)
 		return 0;
 
@@ -302,6 +298,11 @@ static int rvin_digital_graph_init(struct rvin_dev *vin)
 
 	if (!vin->digital.asd.match.of.node) {
 		vin_dbg(vin, "No digital subdevice found\n");
+
+		/* OK for Gen3 where we can be part of a subdevice group */
+		if (vin->chip == RCAR_GEN3)
+			return 0;
+
 		return -ENODEV;
 	}
 
@@ -387,6 +388,9 @@ static int rcar_vin_probe(struct platform_device *pdev)
 	vin->dev = &pdev->dev;
 	vin->chip = (enum chip_id)match->data;
 
+	/* Prefer digital input */
+	vin->current_input = RVIN_INPUT_DIGITAL;
+
 	/* Initialize the top-level structure */
 	ret = v4l2_device_register(vin->dev, &vin->v4l2_dev);
 	if (ret)
@@ -396,6 +400,11 @@ static int rcar_vin_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_register;
 
+	if (vin->chip == RCAR_GEN3)
+		vin->api = rvin_group_probe(&pdev->dev, &vin->v4l2_dev);
+	else
+		vin->api = NULL;
+
 	ret = rvin_digital_graph_init(vin);
 	if (ret < 0)
 		goto err_dma;
@@ -406,11 +415,17 @@ static int rcar_vin_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, vin);
 
+	ret = rvin_subdev_probe(vin);
+	if (ret)
+		goto err_subdev;
+
 	pm_suspend_ignore_children(&pdev->dev, true);
 	pm_runtime_enable(&pdev->dev);
 
 	return 0;
 
+err_subdev:
+	rvin_v4l2_remove(vin);
 err_dma:
 	rvin_dma_remove(vin);
 err_register:
@@ -425,10 +440,15 @@ static int rcar_vin_remove(struct platform_device *pdev)
 
 	pm_runtime_disable(&pdev->dev);
 
+	rvin_subdev_remove(vin);
+
 	rvin_v4l2_remove(vin);
 
 	v4l2_async_notifier_unregister(&vin->notifier);
 
+	if (vin->api)
+		rvin_group_remove(vin->api);
+
 	rvin_dma_remove(vin);
 
 	v4l2_device_unregister(&vin->v4l2_dev);
diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index d63b186..c798ee7 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -16,6 +16,7 @@
 
 #include <linux/delay.h>
 #include <linux/interrupt.h>
+#include <linux/pm_runtime.h>
 
 #include <media/videobuf2-dma-contig.h>
 
@@ -1223,3 +1224,69 @@ error:
 
 	return ret;
 }
+
+/* -----------------------------------------------------------------------------
+ * Salve Subdevice
+ */
+
+static int rvin_subdev_s_gpio(struct v4l2_subdev *sd, u32 val)
+{
+	struct rvin_dev *vin = container_of(sd, struct rvin_dev, slave);
+	u32 ifmd;
+
+	if (vin->chip != RCAR_GEN3)
+		return 0;
+
+	pm_runtime_get_sync(vin->v4l2_dev.dev);
+
+	/*
+	 * Undocumented feature: Writing to VNCSI_IFMD_REG will go
+	 * through and on read back look correct but won't have
+	 * any effect if VNMC_REG is not first set to 0.
+	 */
+	rvin_write(vin, 0, VNMC_REG);
+
+	ifmd = VNCSI_IFMD_DES2 | VNCSI_IFMD_DES1 | VNCSI_IFMD_DES0 |
+		VNCSI_IFMD_CSI_CHSEL(val);
+
+	rvin_write(vin, ifmd, VNCSI_IFMD_REG);
+
+	vin_dbg(vin, "Set IFMD 0x%x\n", ifmd);
+
+	pm_runtime_put(vin->v4l2_dev.dev);
+
+	return 0;
+}
+
+static struct v4l2_subdev_core_ops rvin_subdev_core_ops = {
+	.s_gpio		= rvin_subdev_s_gpio,
+};
+
+static struct v4l2_subdev_ops rvin_subdev_ops = {
+	.core	= &rvin_subdev_core_ops,
+};
+
+int rvin_subdev_probe(struct rvin_dev *vin)
+{
+	vin->slave.v4l2_dev = NULL;
+
+	if (vin->chip != RCAR_GEN3)
+		return 0;
+
+	vin->slave.owner = THIS_MODULE;
+	vin->slave.dev = vin->dev;
+	v4l2_subdev_init(&vin->slave, &rvin_subdev_ops);
+	v4l2_set_subdevdata(&vin->slave, vin->dev);
+	snprintf(vin->slave.name, V4L2_SUBDEV_NAME_SIZE, "rcar-vin-slave.%s",
+		 dev_name(vin->dev));
+
+	return v4l2_async_register_subdev(&vin->slave);
+}
+
+void rvin_subdev_remove(struct rvin_dev *vin)
+{
+	if (vin->chip != RCAR_GEN3)
+		return;
+
+	v4l2_async_unregister_subdev(&vin->slave);
+}
diff --git a/drivers/media/platform/rcar-vin/rcar-group.c b/drivers/media/platform/rcar-vin/rcar-group.c
new file mode 100644
index 0000000..bd81516
--- /dev/null
+++ b/drivers/media/platform/rcar-vin/rcar-group.c
@@ -0,0 +1,1250 @@
+/*
+ * Driver for Renesas R-Car VIN
+ *
+ * Copyright (C) 2016 Renesas Electronics Corp.
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/of_graph.h>
+
+#include <media/v4l2-async.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-dev.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-of.h>
+
+#include "rcar-group.h"
+
+/* Max chsel supported by HW */
+#define RVIN_CHSEL_MAX 6
+
+enum rvin_csi_id {
+	RVIN_CSI20,
+	RVIN_CSI21,
+	RVIN_CSI40,
+	RVIN_CSI41,
+	RVIN_CSI_MAX,
+	RVIN_CSI_ERROR,
+};
+
+enum rvin_chan_id {
+	RVIN_CHAN0,
+	RVIN_CHAN1,
+	RVIN_CHAN2,
+	RVIN_CHAN3,
+	RVIN_CHAN4,
+	RVIN_CHAN5,
+	RVIN_CHAN6,
+	RVIN_CHAN7,
+	RVIN_CHAN_MAX,
+	RVIN_CHAN_ERROR,
+};
+
+struct rvin_group_map_item {
+	enum rvin_csi_id csi;
+	const char *name;
+};
+
+static const struct rvin_group_map_item
+rvin_group_map[RVIN_CHAN_MAX][RVIN_CHSEL_MAX] = {
+	{
+		{ .csi = RVIN_CSI40, .name = "CSI40/VC0 chsel1: 0" },
+		{ .csi = RVIN_CSI20, .name = "CSI20/VC0 chsel1: 1" },
+		{ .csi = RVIN_CSI21, .name = "CSI21/VC0 chsel1: 2" },
+		{ .csi = RVIN_CSI40, .name = "CSI40/VC0 chsel1: 3" },
+		{ .csi = RVIN_CSI20, .name = "CSI20/VC0 chsel1: 4" },
+		{ .csi = RVIN_CSI21, .name = "CSI21/VC0 chsel1: 5" },
+	}, {
+		{ .csi = RVIN_CSI20, .name = "CSI20/VC0 chsel1: 0" },
+		{ .csi = RVIN_CSI21, .name = "CSI21/VC0 chsel1: 1" },
+		{ .csi = RVIN_CSI40, .name = "CSI40/VC0 chsel1: 2" },
+		{ .csi = RVIN_CSI40, .name = "CSI40/VC1 chsel1: 3" },
+		{ .csi = RVIN_CSI20, .name = "CSI20/VC1 chsel1: 4" },
+		{ .csi = RVIN_CSI21, .name = "CSI21/VC1 chsel1: 5" },
+	}, {
+		{ .csi = RVIN_CSI21, .name = "CSI21/VC0 chsel1: 0" },
+		{ .csi = RVIN_CSI40, .name = "CSI40/VC0 chsel1: 1" },
+		{ .csi = RVIN_CSI20, .name = "CSI20/VC0 chsel1: 2" },
+		{ .csi = RVIN_CSI40, .name = "CSI40/VC2 chsel1: 3" },
+		{ .csi = RVIN_CSI20, .name = "CSI20/VC2 chsel1: 4" },
+		{ .csi = RVIN_CSI21, .name = "CSI21/VC2 chsel1: 5" },
+	}, {
+		{ .csi = RVIN_CSI40, .name = "CSI40/VC1 chsel1: 0" },
+		{ .csi = RVIN_CSI20, .name = "CSI20/VC1 chsel1: 1" },
+		{ .csi = RVIN_CSI21, .name = "CSI21/VC1 chsel1: 2" },
+		{ .csi = RVIN_CSI40, .name = "CSI40/VC3 chsel1: 3" },
+		{ .csi = RVIN_CSI20, .name = "CSI20/VC3 chsel1: 4" },
+		{ .csi = RVIN_CSI21, .name = "CSI21/VC3 chsel1: 5" },
+	}, {
+		{ .csi = RVIN_CSI41, .name = "CSI41/VC0 chsel2: 0" },
+		{ .csi = RVIN_CSI20, .name = "CSI20/VC0 chsel2: 1" },
+		{ .csi = RVIN_CSI21, .name = "CSI21/VC0 chsel2: 2" },
+		{ .csi = RVIN_CSI41, .name = "CSI41/VC0 chsel2: 3" },
+		{ .csi = RVIN_CSI20, .name = "CSI20/VC0 chsel2: 4" },
+		{ .csi = RVIN_CSI21, .name = "CSI21/VC0 chsel2: 5" },
+	}, {
+		{ .csi = RVIN_CSI20, .name = "CSI20/VC0 chsel2: 0" },
+		{ .csi = RVIN_CSI21, .name = "CSI21/VC0 chsel2: 1" },
+		{ .csi = RVIN_CSI41, .name = "CSI41/VC0 chsel2: 2" },
+		{ .csi = RVIN_CSI41, .name = "CSI41/VC1 chsel2: 3" },
+		{ .csi = RVIN_CSI20, .name = "CSI20/VC1 chsel2: 4" },
+		{ .csi = RVIN_CSI21, .name = "CSI21/VC1 chsel2: 5" },
+	}, {
+		{ .csi = RVIN_CSI21, .name = "CSI21/VC0 chsel2: 0" },
+		{ .csi = RVIN_CSI41, .name = "CSI41/VC0 chsel2: 1" },
+		{ .csi = RVIN_CSI20, .name = "CSI20/VC0 chsel2: 2" },
+		{ .csi = RVIN_CSI41, .name = "CSI41/VC2 chsel2: 3" },
+		{ .csi = RVIN_CSI20, .name = "CSI20/VC2 chsel2: 4" },
+		{ .csi = RVIN_CSI21, .name = "CSI21/VC2 chsel2: 5" },
+	}, {
+		{ .csi = RVIN_CSI41, .name = "CSI41/VC1 chsel2: 0" },
+		{ .csi = RVIN_CSI20, .name = "CSI20/VC1 chsel2: 1" },
+		{ .csi = RVIN_CSI21, .name = "CSI21/VC1 chsel2: 2" },
+		{ .csi = RVIN_CSI41, .name = "CSI41/VC3 chsel2: 3" },
+		{ .csi = RVIN_CSI20, .name = "CSI20/VC3 chsel2: 4" },
+		{ .csi = RVIN_CSI21, .name = "CSI21/VC3 chsel2: 5" },
+	},
+};
+
+struct rvin_group {
+	struct device *dev;
+	struct v4l2_device *v4l2_dev;
+	struct mutex lock;
+
+	struct rvin_group_api api;
+
+	struct v4l2_async_notifier notifier;
+
+	struct rvin_graph_entity bridge[RVIN_CSI_MAX];
+	struct rvin_graph_entity source[RVIN_CSI_MAX];
+	int stream[RVIN_CSI_MAX];
+	int power[RVIN_CSI_MAX];
+
+	struct rvin_graph_entity chan[RVIN_CHAN_MAX];
+	int users[RVIN_CHAN_MAX];
+
+	int chsel1;
+	int chsel2;
+};
+
+#define grp_dbg(d, fmt, arg...)		dev_dbg(d->dev, fmt, ##arg)
+#define grp_info(d, fmt, arg...)	dev_info(d->dev, fmt, ##arg)
+#define grp_err(d, fmt, arg...)		dev_err(d->dev, fmt, ##arg)
+
+/* -----------------------------------------------------------------------------
+ * Common - Helpers
+ */
+
+bool rvin_mbus_supported(struct rvin_graph_entity *entity)
+{
+	struct v4l2_subdev *sd = entity->subdev;
+	struct v4l2_subdev_mbus_code_enum code = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
+
+	code.index = 0;
+	code.pad = entity->source_idx;
+	while (!v4l2_subdev_call(sd, pad, enum_mbus_code, NULL, &code)) {
+		code.index++;
+		switch (code.code) {
+		case MEDIA_BUS_FMT_YUYV8_1X16:
+		case MEDIA_BUS_FMT_UYVY8_2X8:
+		case MEDIA_BUS_FMT_UYVY10_2X10:
+		case MEDIA_BUS_FMT_RGB888_1X24:
+			entity->code = code.code;
+			return true;
+		default:
+			break;
+		}
+	}
+
+	/*
+	 * Older versions where looking for the wrong media bus format.
+	 * It where looking for a YUVY format but then treated it as a
+	 * UYVY format. This was not noticed since atlest one subdevice
+	 * used for testing (adv7180) reported a YUVY media bus format
+	 * but provided UYVY data. There might be other unknown subdevices
+	 * which also do this, to not break compatibility try to use them
+	 * in legacy mode.
+	 */
+	code.index = 0;
+	while (!v4l2_subdev_call(sd, pad, enum_mbus_code, NULL, &code)) {
+		code.index++;
+		switch (code.code) {
+		case MEDIA_BUS_FMT_YUYV8_2X8:
+			entity->code = MEDIA_BUS_FMT_UYVY8_2X8;
+			return true;
+		case MEDIA_BUS_FMT_YUYV10_2X10:
+			entity->code = MEDIA_BUS_FMT_UYVY10_2X10;
+			return true;
+		default:
+			break;
+		}
+	}
+
+	return false;
+}
+
+unsigned int rvin_pad_idx(struct v4l2_subdev *sd, int direction)
+{
+	unsigned int pad_idx;
+
+	for (pad_idx = 0; pad_idx < sd->entity.num_pads; pad_idx++)
+		if (sd->entity.pads[pad_idx].flags == direction)
+			return pad_idx;
+
+	return 0;
+}
+
+/* -----------------------------------------------------------------------------
+ * Group API - Helpers
+ */
+
+static enum rvin_chan_id sd_to_chan(struct rvin_group *grp,
+				    struct v4l2_subdev *sd)
+{
+	enum rvin_chan_id chan = RVIN_CHAN_ERROR;
+	int i;
+
+	for (i = 0; i < RVIN_CHAN_MAX; i++) {
+		if (grp->chan[i].subdev == sd) {
+			chan =  i;
+			break;
+		}
+	}
+
+	/* Something is wrong, subdevice can't be resolved to channel id */
+	BUG_ON(chan == RVIN_CHAN_ERROR);
+
+	return chan;
+}
+
+static enum rvin_chan_id chan_to_master(struct rvin_group *grp,
+					enum rvin_chan_id chan)
+{
+	enum rvin_chan_id master;
+
+	switch (chan) {
+	case RVIN_CHAN0:
+	case RVIN_CHAN1:
+	case RVIN_CHAN2:
+	case RVIN_CHAN3:
+		master = RVIN_CHAN0;
+		break;
+	case RVIN_CHAN4:
+	case RVIN_CHAN5:
+	case RVIN_CHAN6:
+	case RVIN_CHAN7:
+		master = RVIN_CHAN4;
+		break;
+	default:
+		master = RVIN_CHAN_ERROR;
+		break;
+	}
+
+	/* Something is wrong, subdevice can't be resolved to channel id */
+	BUG_ON(master == RVIN_CHAN_ERROR);
+
+	return master;
+}
+
+static enum rvin_csi_id rvin_group_get_csi(struct rvin_group *grp,
+					   struct v4l2_subdev *sd, int chsel)
+{
+	enum rvin_chan_id chan;
+	enum rvin_csi_id csi;
+
+	if (chsel < 0 || chsel > RVIN_CHSEL_MAX)
+		return RVIN_CSI_ERROR;
+
+	chan = sd_to_chan(grp, sd);
+
+	csi = rvin_group_map[sd_to_chan(grp, sd)][chsel].csi;
+
+	/* Not all CSI source might be available */
+	if (!grp->bridge[csi].subdev || !grp->source[csi].subdev)
+		return RVIN_CSI_ERROR;
+
+	return csi;
+}
+
+static int rvin_group_chsel_get(struct rvin_group *grp, struct v4l2_subdev *sd)
+{
+	enum rvin_chan_id master;
+
+	master = chan_to_master(grp, sd_to_chan(grp, sd));
+
+	if (master == RVIN_CHAN0)
+		return grp->chsel1;
+
+	return grp->chsel2;
+}
+
+static void rvin_group_chsel_set(struct rvin_group *grp, struct v4l2_subdev *sd,
+				 int chsel)
+{
+	enum rvin_chan_id master;
+
+	master = chan_to_master(grp, sd_to_chan(grp, sd));
+
+	if (master == RVIN_CHAN0)
+		grp->chsel1 = chsel;
+	else
+		grp->chsel2 = chsel;
+}
+
+static enum rvin_csi_id sd_to_csi(struct rvin_group *grp,
+				  struct v4l2_subdev *sd)
+{
+	return rvin_group_get_csi(grp, sd, rvin_group_chsel_get(grp, sd));
+}
+
+/* -----------------------------------------------------------------------------
+ * Group API - logic
+ */
+
+static int rvin_group_get_sink_idx(struct media_entity *entity, int source_idx)
+{
+	unsigned int i;
+
+	/* Iterates through the pads to find a connected sink pad. */
+	for (i = 0; i < entity->num_pads; ++i) {
+		struct media_pad *sink = &entity->pads[i];
+
+		if (!(sink->flags & MEDIA_PAD_FL_SINK))
+			continue;
+
+		if (sink->index == source_idx)
+			continue;
+
+		if (media_entity_has_route(entity, sink->index, source_idx))
+			return sink->index;
+	}
+
+	/* If not found return the first pad, guaranteed to be a sink pad. */
+	return 0;
+}
+
+static int rvin_group_get(struct v4l2_subdev *sd,
+			  struct rvin_input_item *inputs)
+{
+	struct rvin_group *grp = v4l2_get_subdev_hostdata(sd);
+	enum rvin_chan_id chan, master;
+	enum rvin_csi_id csi;
+	int i, num = 0;
+
+	mutex_lock(&grp->lock);
+
+	chan = sd_to_chan(grp, sd);
+
+	/* If subgroup master is not present channel is useless */
+	master = chan_to_master(grp, chan);
+	if (!grp->chan[master].subdev) {
+		grp_err(grp, "chan%d: No group master found\n", chan);
+		goto out;
+	}
+
+	/* Make sure channel is usable with current chsel */
+	if (sd_to_csi(grp, sd) == RVIN_CSI_ERROR) {
+		grp_info(grp, "chan%d: Unavailable with current chsel\n", chan);
+		goto out;
+	}
+
+	/* Create list of valid inputs */
+	for (i = 0; i < RVIN_CHSEL_MAX; i++) {
+		csi = rvin_group_get_csi(grp, sd, i);
+		if (rvin_group_get_csi(grp, sd, i) != RVIN_CSI_ERROR) {
+			inputs[num].type = RVIN_INPUT_CSI2;
+			inputs[num].chsel = i;
+			inputs[num].hint = rvin_group_chsel_get(grp, sd) == i;
+			inputs[num].source_idx = grp->source[csi].source_idx;
+			inputs[num].sink_idx =
+				rvin_group_get_sink_idx(
+					&grp->source[csi].subdev->entity,
+					inputs[num].source_idx);
+			strlcpy(inputs[num].name, rvin_group_map[chan][i].name,
+				RVIN_INPUT_NAME_SIZE);
+			grp_dbg(grp, "chan%d: %s source pad: %d sink pad: %d\n",
+				chan, inputs[num].name, inputs[num].source_idx,
+				inputs[num].sink_idx);
+			num++;
+		}
+	}
+
+	grp->users[chan]++;
+out:
+	mutex_unlock(&grp->lock);
+
+	return num;
+}
+
+static int rvin_group_put(struct v4l2_subdev *sd)
+{
+	struct rvin_group *grp = v4l2_get_subdev_hostdata(sd);
+
+	mutex_lock(&grp->lock);
+	grp->users[sd_to_chan(grp, sd)]--;
+	mutex_unlock(&grp->lock);
+
+	return 0;
+}
+
+static int rvin_group_set_input(struct v4l2_subdev *sd,
+				struct rvin_input_item *item)
+{
+	struct rvin_group *grp = v4l2_get_subdev_hostdata(sd);
+	enum rvin_chan_id chan, master;
+	int i, chsel, ret = 0;
+
+	chan = sd_to_chan(grp, sd);
+	chsel = item->chsel;
+
+	mutex_lock(&grp->lock);
+
+	/* No need to set chsel if it's already set */
+	if (chsel == rvin_group_chsel_get(grp, sd))
+		goto out;
+
+	/* Do not allow a chsel that is not usable for channel */
+	if (rvin_group_get_csi(grp, sd, chsel) == RVIN_CSI_ERROR) {
+		grp_err(grp, "chan%d: Invalid chsel\n", chan);
+		goto out;
+	}
+
+	/* If subgroup master is not present we can't write the chsel */
+	master = chan_to_master(grp, chan);
+	if (!grp->chan[master].subdev) {
+		grp_err(grp, "chan%d: No group master found\n", chan);
+		goto out;
+	}
+
+	/*
+	 * Check that all needed resurces are free. We don't want to
+	 * change input selection if somone else uses our subgroup or
+	 * if there are another user of our channel.
+	 */
+	for (i = 0; i < RVIN_CHAN_MAX; i++) {
+
+		/* Only look in our sub group */
+		if (master != chan_to_master(grp, i))
+			continue;
+
+		/* Need to be only user of channel and subgroup to set hsel */
+		if ((i == chan && grp->users[i] != 1) ||
+		    (i != chan && grp->users[i] != 0)) {
+			grp_info(grp, "chan%d: %s in use, can't set chsel\n",
+				 chan, i == chan ? "Channel" : "Group");
+			ret = -EBUSY;
+			goto out;
+		}
+	}
+
+	ret = v4l2_subdev_call(grp->chan[master].subdev, core, s_gpio, chsel);
+	rvin_group_chsel_set(grp, sd, chsel);
+out:
+	mutex_unlock(&grp->lock);
+	return ret;
+}
+
+static int rvin_group_get_code(struct v4l2_subdev *sd, u32 *code)
+{
+	struct rvin_group *grp = v4l2_get_subdev_hostdata(sd);
+	enum rvin_csi_id csi;
+
+	csi = sd_to_csi(grp, sd);
+	if (csi == RVIN_CSI_ERROR)
+		return -ENODEV;
+
+	*code = grp->source[csi].code;
+
+	return 0;
+}
+
+static int rvin_group_get_mbus_cfg(struct v4l2_subdev *sd,
+				   struct v4l2_mbus_config *mbus_cfg)
+{
+	struct rvin_group *grp = v4l2_get_subdev_hostdata(sd);
+	enum rvin_csi_id csi;
+
+	csi = sd_to_csi(grp, sd);
+	if (csi == RVIN_CSI_ERROR)
+		return -ENODEV;
+
+	*mbus_cfg = grp->source[csi].mbus_cfg;
+
+	return 0;
+}
+
+static int rvin_group_ctrl_add_handler(struct v4l2_subdev *sd,
+				       struct v4l2_ctrl_handler *hdl)
+{
+	struct rvin_group *grp = v4l2_get_subdev_hostdata(sd);
+	enum rvin_csi_id csi;
+
+	csi = sd_to_csi(grp, sd);
+	if (csi == RVIN_CSI_ERROR)
+		return -ENODEV;
+
+	return v4l2_ctrl_add_handler(hdl, grp->source[csi].subdev->ctrl_handler,
+				     NULL);
+}
+
+static int rvin_group_alloc_pad_config(struct v4l2_subdev *sd,
+				       struct v4l2_subdev_pad_config **cfg)
+{
+	struct rvin_group *grp = v4l2_get_subdev_hostdata(sd);
+	enum rvin_csi_id csi;
+
+	csi = sd_to_csi(grp, sd);
+	if (csi == RVIN_CSI_ERROR)
+		return -ENODEV;
+
+	*cfg =  v4l2_subdev_alloc_pad_config(grp->source[csi].subdev);
+
+	return 0;
+}
+
+static int rvin_group_g_tvnorms_input(struct v4l2_subdev *sd,
+				      struct rvin_input_item *item,
+				      v4l2_std_id *std)
+{
+	struct rvin_group *grp = v4l2_get_subdev_hostdata(sd);
+	enum rvin_csi_id csi;
+
+	csi = rvin_group_get_csi(grp, sd, item->chsel);
+
+	if (csi == RVIN_CSI_ERROR)
+		return -EINVAL;
+
+	return v4l2_subdev_call(grp->source[csi].subdev, video,
+				g_tvnorms, std);
+}
+
+static int rvin_group_g_input_status(struct v4l2_subdev *sd,
+				     struct rvin_input_item *item, u32 *status)
+{
+	struct rvin_group *grp = v4l2_get_subdev_hostdata(sd);
+	enum rvin_csi_id csi;
+
+	csi = rvin_group_get_csi(grp, sd, item->chsel);
+
+	if (csi == RVIN_CSI_ERROR)
+		return -EINVAL;
+
+	return v4l2_subdev_call(grp->source[csi].subdev, video,
+				g_input_status, status);
+}
+
+static int rvin_group_dv_timings_cap(struct v4l2_subdev *sd,
+				     struct rvin_input_item *item,
+				     struct v4l2_dv_timings_cap *cap)
+{
+	struct rvin_group *grp = v4l2_get_subdev_hostdata(sd);
+	enum rvin_csi_id csi;
+
+	csi = rvin_group_get_csi(grp, sd, item->chsel);
+
+	if (csi == RVIN_CSI_ERROR)
+		return -EINVAL;
+
+	return v4l2_subdev_call(grp->source[csi].subdev, pad,
+				dv_timings_cap, cap);
+}
+
+static int rvin_group_enum_dv_timings(struct v4l2_subdev *sd,
+				      struct rvin_input_item *item,
+				      struct v4l2_enum_dv_timings *timings)
+{
+	struct rvin_group *grp = v4l2_get_subdev_hostdata(sd);
+	enum rvin_csi_id csi;
+
+	csi = rvin_group_get_csi(grp, sd, item->chsel);
+
+	if (csi == RVIN_CSI_ERROR)
+		return -EINVAL;
+
+	return v4l2_subdev_call(grp->source[csi].subdev, pad,
+				enum_dv_timings, timings);
+}
+
+static const struct rvin_group_input_ops rvin_input_ops = {
+	.g_tvnorms = &rvin_group_g_tvnorms_input,
+	.g_input_status = &rvin_group_g_input_status,
+	.dv_timings_cap = &rvin_group_dv_timings_cap,
+	.enum_dv_timings = &rvin_group_enum_dv_timings,
+};
+
+/* -----------------------------------------------------------------------------
+ * Basic group subdev operations
+ */
+
+static int rvin_group_s_power(struct v4l2_subdev *sd, int on)
+{
+	struct rvin_group *grp = v4l2_get_subdev_hostdata(sd);
+	enum rvin_csi_id csi;
+	int ret = 0;
+
+	csi = sd_to_csi(grp, sd);
+	if (csi == RVIN_CSI_ERROR)
+		return -ENODEV;
+
+	mutex_lock(&grp->lock);
+	/* If we already are powerd just increment the usage */
+	if ((on && grp->power[csi] != 0) || (!on && grp->power[csi] != 1))
+		goto unlock;
+
+	/* Important to start bridge fist, it needs a quiet bus to start */
+	ret = v4l2_subdev_call(grp->bridge[csi].subdev, core, s_power, on);
+	if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
+		goto unlock_err;
+	ret = v4l2_subdev_call(grp->source[csi].subdev, core, s_power, on);
+	if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
+		goto unlock_err;
+
+	grp_dbg(grp, "csi%d: power: %d bridge: %s source: %s\n", csi,
+		on, grp->bridge[csi].subdev->name,
+		grp->source[csi].subdev->name);
+unlock:
+	grp->power[csi] += on ? 1 : -1;
+unlock_err:
+	mutex_unlock(&grp->lock);
+	return ret;
+}
+
+static const struct v4l2_subdev_core_ops rvin_group_core_ops = {
+	.s_power	= &rvin_group_s_power,
+};
+
+static int rvin_group_g_std(struct v4l2_subdev *sd, v4l2_std_id *std)
+{
+	struct rvin_group *grp = v4l2_get_subdev_hostdata(sd);
+	enum rvin_csi_id csi;
+
+	csi = sd_to_csi(grp, sd);
+	if (csi == RVIN_CSI_ERROR)
+		return -ENODEV;
+
+	return v4l2_subdev_call(grp->source[csi].subdev, video, g_std, std);
+}
+
+static int rvin_group_s_std(struct v4l2_subdev *sd, v4l2_std_id std)
+{
+	struct rvin_group *grp = v4l2_get_subdev_hostdata(sd);
+	enum rvin_csi_id csi;
+
+	csi = sd_to_csi(grp, sd);
+	if (csi == RVIN_CSI_ERROR)
+		return -ENODEV;
+
+	return v4l2_subdev_call(grp->source[csi].subdev, video, s_std, std);
+}
+
+static int rvin_group_querystd(struct v4l2_subdev *sd, v4l2_std_id *std)
+{
+	struct rvin_group *grp = v4l2_get_subdev_hostdata(sd);
+	enum rvin_csi_id csi;
+
+	csi = sd_to_csi(grp, sd);
+	if (csi == RVIN_CSI_ERROR)
+		return -ENODEV;
+
+	return v4l2_subdev_call(grp->source[csi].subdev, video, querystd, std);
+}
+
+static int rvin_group_g_tvnorms(struct v4l2_subdev *sd, v4l2_std_id *tvnorms)
+{
+	struct rvin_group *grp = v4l2_get_subdev_hostdata(sd);
+	enum rvin_csi_id csi;
+
+	csi = sd_to_csi(grp, sd);
+	if (csi == RVIN_CSI_ERROR)
+		return -ENODEV;
+
+	return v4l2_subdev_call(grp->source[csi].subdev, video, g_tvnorms,
+				tvnorms);
+}
+
+static int rvin_group_s_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct rvin_group *grp = v4l2_get_subdev_hostdata(sd);
+	enum rvin_csi_id csi;
+	int ret = 0;
+
+	mutex_lock(&grp->lock);
+
+	csi = sd_to_csi(grp, sd);
+	if (csi == RVIN_CSI_ERROR) {
+		ret = -ENODEV;
+		goto unlock_err;
+	}
+
+	/* If we already are streaming just increment the usage */
+	if ((enable && grp->stream[csi] != 0) ||
+	    (!enable && grp->stream[csi] != 1))
+		goto unlock;
+
+	/* Important to start bridge fist, it needs a quiet bus to start */
+	ret = v4l2_subdev_call(grp->bridge[csi].subdev, video, s_stream,
+			       enable);
+	if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
+		goto unlock_err;
+	ret = v4l2_subdev_call(grp->source[csi].subdev, video, s_stream,
+			       enable);
+	if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
+		goto unlock_err;
+
+	grp_dbg(grp, "csi%d: stream: %d bridge: %s source %s\n", csi,
+		enable, grp->bridge[csi].subdev->name,
+		grp->source[csi].subdev->name);
+unlock:
+	grp->stream[csi] += enable ? 1 : -1;
+unlock_err:
+	mutex_unlock(&grp->lock);
+	return ret;
+}
+
+static int rvin_group_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *crop)
+{
+	struct rvin_group *grp = v4l2_get_subdev_hostdata(sd);
+	enum rvin_csi_id csi;
+
+	csi = sd_to_csi(grp, sd);
+	if (csi == RVIN_CSI_ERROR)
+		return -ENODEV;
+
+	return v4l2_subdev_call(grp->source[csi].subdev, video, cropcap, crop);
+}
+
+static int rvin_group_g_dv_timings(struct v4l2_subdev *sd,
+				   struct v4l2_dv_timings *timings)
+{
+	struct rvin_group *grp = v4l2_get_subdev_hostdata(sd);
+	enum rvin_csi_id csi;
+
+	csi = sd_to_csi(grp, sd);
+	if (csi == RVIN_CSI_ERROR)
+		return -ENODEV;
+
+	return v4l2_subdev_call(grp->source[csi].subdev, video,
+				g_dv_timings, timings);
+}
+
+static int rvin_group_s_dv_timings(struct v4l2_subdev *sd,
+				   struct v4l2_dv_timings *timings)
+{
+	struct rvin_group *grp = v4l2_get_subdev_hostdata(sd);
+	enum rvin_csi_id csi;
+
+	csi = sd_to_csi(grp, sd);
+	if (csi == RVIN_CSI_ERROR)
+		return -ENODEV;
+
+	return v4l2_subdev_call(grp->source[csi].subdev, video,
+				s_dv_timings, timings);
+}
+
+static int rvin_group_query_dv_timings(struct v4l2_subdev *sd,
+				       struct v4l2_dv_timings *timings)
+{
+	struct rvin_group *grp = v4l2_get_subdev_hostdata(sd);
+	enum rvin_csi_id csi;
+
+	csi = sd_to_csi(grp, sd);
+	if (csi == RVIN_CSI_ERROR)
+		return -ENODEV;
+
+	return v4l2_subdev_call(grp->source[csi].subdev, video,
+				query_dv_timings, timings);
+}
+
+static const struct v4l2_subdev_video_ops rvin_group_video_ops = {
+	.g_std			= rvin_group_g_std,
+	.s_std			= rvin_group_s_std,
+	.querystd		= rvin_group_querystd,
+	.g_tvnorms		= rvin_group_g_tvnorms,
+	.s_stream		= rvin_group_s_stream,
+	.cropcap		= rvin_group_cropcap,
+	.g_dv_timings		= rvin_group_g_dv_timings,
+	.s_dv_timings		= rvin_group_s_dv_timings,
+	.query_dv_timings	= rvin_group_query_dv_timings,
+};
+
+static int rvin_group_get_fmt(struct v4l2_subdev *sd,
+			      struct v4l2_subdev_pad_config *pad_cfg,
+			      struct v4l2_subdev_format *fmt)
+{
+	struct rvin_group *grp = v4l2_get_subdev_hostdata(sd);
+	enum rvin_csi_id csi;
+
+	csi = sd_to_csi(grp, sd);
+	if (csi == RVIN_CSI_ERROR)
+		return -ENODEV;
+
+	return v4l2_subdev_call(grp->source[csi].subdev, pad, get_fmt,
+				pad_cfg, fmt);
+}
+
+static int rvin_group_set_fmt(struct v4l2_subdev *sd,
+			      struct v4l2_subdev_pad_config *pad_cfg,
+			      struct v4l2_subdev_format *fmt)
+{
+	struct rvin_group *grp = v4l2_get_subdev_hostdata(sd);
+	enum rvin_csi_id csi;
+	int ret;
+
+	csi = sd_to_csi(grp, sd);
+	if (csi == RVIN_CSI_ERROR)
+		return -ENODEV;
+
+	/* First the source and then inform the bridge about the format. */
+	ret = v4l2_subdev_call(grp->source[csi].subdev, pad, set_fmt,
+			       pad_cfg, fmt);
+	if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
+		return ret;
+	return v4l2_subdev_call(grp->bridge[csi].subdev, pad, set_fmt,
+				NULL, fmt);
+}
+
+static const struct v4l2_subdev_pad_ops rvin_group_pad_ops = {
+	.get_fmt	= rvin_group_get_fmt,
+	.set_fmt	= rvin_group_set_fmt,
+};
+
+static const struct v4l2_subdev_ops rvin_group_ops = {
+	.core		= &rvin_group_core_ops,
+	.video		= &rvin_group_video_ops,
+	.pad		= &rvin_group_pad_ops,
+};
+
+/* -----------------------------------------------------------------------------
+ * Async notifier
+ */
+
+#define notifier_to_grp(n) container_of(n, struct rvin_group, notifier)
+
+static void __verify_source_pad(struct rvin_graph_entity *entity)
+{
+	if (entity->source_idx >= entity->subdev->entity.num_pads)
+		goto use_default;
+	if (entity->subdev->entity.pads[entity->source_idx].flags !=
+	    MEDIA_PAD_FL_SOURCE)
+		goto use_default;
+	return;
+use_default:
+	entity->source_idx = rvin_pad_idx(entity->subdev, MEDIA_PAD_FL_SOURCE);
+}
+
+
+static int rvin_graph_notify_complete(struct v4l2_async_notifier *notifier)
+{
+	struct rvin_group *grp = notifier_to_grp(notifier);
+	int i, ret;
+
+	for (i = 0; i < RVIN_CSI_MAX; i++) {
+		if (!grp->source[i].subdev)
+			continue;
+
+		__verify_source_pad(&grp->source[i]);
+
+		if (!rvin_mbus_supported(&grp->source[i])) {
+			grp_err(grp,
+				"Unsupported media bus format for %s pad %d\n",
+				grp->source[i].subdev->name,
+				grp->source[i].source_idx);
+			return -EINVAL;
+		}
+
+		grp_dbg(grp, "Found media bus format for %s pad %d: %d\n",
+			grp->source[i].subdev->name, grp->source[i].source_idx,
+			grp->source[i].code);
+	}
+
+	ret = v4l2_device_register_subdev_nodes(grp->v4l2_dev);
+	if (ret < 0) {
+		grp_err(grp, "Failed to register subdev nodes\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static void rvin_graph_notify_unbind(struct v4l2_async_notifier *notifier,
+				     struct v4l2_subdev *subdev,
+				     struct v4l2_async_subdev *asd)
+{
+	struct rvin_group *grp = notifier_to_grp(notifier);
+	bool matched = false;
+	int i;
+
+	for (i = 0; i < RVIN_CSI_MAX; i++) {
+		if (grp->bridge[i].subdev == subdev) {
+			grp_dbg(grp, "unbind bridge subdev %s\n", subdev->name);
+			grp->bridge[i].subdev = NULL;
+			matched = true;
+		}
+		if (grp->source[i].subdev == subdev) {
+			grp_dbg(grp, "unbind source subdev %s\n", subdev->name);
+			grp->source[i].subdev = NULL;
+			matched = true;
+		}
+	}
+
+	for (i = 0; i < RVIN_CHAN_MAX; i++) {
+		if (grp->chan[i].subdev == subdev) {
+			grp_dbg(grp, "unbind chan subdev %s\n", subdev->name);
+			grp->chan[i].subdev = NULL;
+			matched = true;
+		}
+	}
+
+	if (!matched)
+		grp_err(grp, "no entity for subdev %s to unbind\n",
+			subdev->name);
+}
+
+static int rvin_graph_notify_bound(struct v4l2_async_notifier *notifier,
+				   struct v4l2_subdev *subdev,
+				   struct v4l2_async_subdev *asd)
+{
+	struct rvin_group *grp = notifier_to_grp(notifier);
+	bool matched = false;
+	int i;
+
+	v4l2_set_subdev_hostdata(subdev, grp);
+
+	for (i = 0; i < RVIN_CSI_MAX; i++) {
+		if (grp->bridge[i].asd.match.of.node == subdev->dev->of_node) {
+			grp_dbg(grp, "bound bridge subdev %s\n", subdev->name);
+			grp->bridge[i].subdev = subdev;
+			matched = true;
+		}
+		if (grp->source[i].asd.match.of.node == subdev->dev->of_node) {
+			grp_dbg(grp, "bound source subdev %s\n", subdev->name);
+			grp->source[i].subdev = subdev;
+			matched = true;
+		}
+	}
+
+	for (i = 0; i < RVIN_CHAN_MAX; i++) {
+		if (grp->chan[i].asd.match.of.node == subdev->dev->of_node) {
+			grp_dbg(grp, "bound chan subdev %s\n", subdev->name);
+			grp->chan[i].subdev = subdev;
+
+			/* Write initial chsel if binding subgroup master */
+			if (i == RVIN_CHAN0)
+				v4l2_subdev_call(subdev, core, s_gpio,
+						 grp->chsel1);
+			if (i == RVIN_CHAN4)
+				v4l2_subdev_call(subdev, core, s_gpio,
+						 grp->chsel2);
+
+			matched = true;
+		}
+	}
+
+	if (matched)
+		return 0;
+
+	grp_err(grp, "no entity for subdev %s to bind\n", subdev->name);
+	return -EINVAL;
+}
+
+static int rvin_parse_v4l2_endpoint(struct rvin_group *grp,
+				    struct device_node *ep,
+				    struct v4l2_mbus_config *mbus_cfg)
+{
+	struct v4l2_of_endpoint v4l2_ep;
+	int ret;
+
+	ret = v4l2_of_parse_endpoint(ep, &v4l2_ep);
+	if (ret) {
+		grp_err(grp, "Could not parse v4l2 endpoint\n");
+		return -EINVAL;
+	}
+
+	if (v4l2_ep.bus_type != V4L2_MBUS_CSI2) {
+		grp_err(grp, "Unsupported media bus type for %s\n",
+			of_node_full_name(ep));
+		return -EINVAL;
+	}
+
+	mbus_cfg->type = v4l2_ep.bus_type;
+	mbus_cfg->flags = v4l2_ep.bus.mipi_csi2.flags;
+
+	return 0;
+}
+
+static int rvin_get_csi_source(struct rvin_group *grp, int id)
+{
+	struct device_node *ep, *np, *rp, *bridge = NULL, *source = NULL;
+	struct v4l2_mbus_config mbus_cfg;
+	struct of_endpoint endpoint;
+	int ret;
+
+	grp->bridge[id].asd.match.of.node = NULL;
+	grp->bridge[id].subdev = NULL;
+	grp->source[id].asd.match.of.node = NULL;
+	grp->source[id].subdev = NULL;
+
+	/* Not all indexes will be defined, this is OK */
+	ep = of_graph_get_endpoint_by_regs(grp->dev->of_node, RVIN_PORT_CSI,
+					   id);
+	if (!ep)
+		return 0;
+
+	/* Get bridge */
+	bridge = of_graph_get_remote_port_parent(ep);
+	of_node_put(ep);
+	if (!bridge) {
+		grp_err(grp, "No bridge found for endpoint '%s'\n",
+			of_node_full_name(ep));
+		return -EINVAL;
+	}
+
+	/* Not all bridges are available, this is OK */
+	if (!of_device_is_available(bridge)) {
+		of_node_put(bridge);
+		return 0;
+	}
+
+	/* Get source */
+	for_each_endpoint_of_node(bridge, ep) {
+		np = of_graph_get_remote_port_parent(ep);
+		if (!np) {
+			grp_err(grp, "No remote found for endpoint '%s'\n",
+				of_node_full_name(ep));
+			of_node_put(bridge);
+			of_node_put(ep);
+			return -EINVAL;
+		}
+
+		if (grp->dev->of_node == np) {
+			/* Ignore loop-back */
+		} else if (!of_device_is_available(np)) {
+			/* Not all sources are available, this is OK */
+		} else if (source) {
+			grp_err(grp, "Multiple source for %s, will use first\n",
+				of_node_full_name(bridge));
+		} else {
+			/* Get endpoint information */
+			rp = of_graph_get_remote_port(ep);
+			of_graph_parse_endpoint(rp, &endpoint);
+			of_node_put(rp);
+
+			ret = rvin_parse_v4l2_endpoint(grp, ep, &mbus_cfg);
+			if (ret) {
+				of_node_put(bridge);
+				of_node_put(ep);
+				of_node_put(np);
+				return ret;
+			}
+			source = np;
+		}
+
+		of_node_put(np);
+	}
+	of_node_put(bridge);
+
+	grp->source[id].mbus_cfg = mbus_cfg;
+	grp->source[id].source_idx = endpoint.id;
+
+	grp->bridge[id].asd.match.of.node = bridge;
+	grp->bridge[id].asd.match_type = V4L2_ASYNC_MATCH_OF;
+	grp->source[id].asd.match.of.node = source;
+	grp->source[id].asd.match_type = V4L2_ASYNC_MATCH_OF;
+
+	grp_dbg(grp, "csi%d: bridge: %s source: %s pad: %d", id,
+		of_node_full_name(grp->bridge[id].asd.match.of.node),
+		of_node_full_name(grp->source[id].asd.match.of.node),
+		grp->source[id].source_idx);
+
+	return ret;
+}
+
+static int rvin_get_remote_channels(struct rvin_group *grp, int id)
+{
+	struct device_node *ep, *remote;
+	int ret = 0;
+
+	grp->chan[id].asd.match.of.node = NULL;
+	grp->chan[id].subdev = NULL;
+
+	/* Not all indexes will be defined, this is OK */
+	ep = of_graph_get_endpoint_by_regs(grp->dev->of_node, RVIN_PORT_REMOTE,
+					   id);
+	if (!ep)
+		return 0;
+
+	/* Find remote subdevice */
+	remote = of_graph_get_remote_port_parent(ep);
+	if (!remote) {
+		grp_err(grp, "No remote parent for endpoint '%s'\n",
+			of_node_full_name(ep));
+		ret = -EINVAL;
+		goto out_ep;
+	}
+
+	/* Not all remotes will be available, this is OK */
+	if (!of_device_is_available(remote)) {
+		ret = 0;
+		goto out_remote;
+	}
+
+	grp->chan[id].asd.match.of.node = remote;
+	grp->chan[id].asd.match_type = V4L2_ASYNC_MATCH_OF;
+
+	grp_dbg(grp, "chan%d: node: '%s'\n", id,
+		of_node_full_name(grp->chan[id].asd.match.of.node));
+
+out_remote:
+	of_node_put(remote);
+out_ep:
+	of_node_put(ep);
+
+	return ret;
+}
+
+static int __node_add(struct v4l2_async_subdev **subdev, int num,
+		       struct rvin_graph_entity *entity)
+{
+	int i;
+
+	if (!entity->asd.match.of.node)
+		return 0;
+
+	for (i = 0; i < num; i++) {
+
+		if (!subdev[i]) {
+			subdev[i] = &entity->asd;
+			return 1;
+		}
+
+		if (subdev[i]->match.of.node == entity->asd.match.of.node)
+			break;
+	}
+
+	return 0;
+}
+
+static int rvin_graph_init(struct rvin_group *grp)
+{
+	struct v4l2_async_subdev **subdevs = NULL;
+	int i, ret, found = 0, matched = 0;
+
+	/* Try to get CSI2 sources */
+	for (i = 0; i < RVIN_CSI_MAX; i++) {
+		ret = rvin_get_csi_source(grp, i);
+		if (ret)
+			return ret;
+		if (grp->bridge[i].asd.match.of.node &&
+		    grp->source[i].asd.match.of.node)
+			found += 2;
+	}
+
+	/* Try to get slave channels */
+	for (i = 0; i < RVIN_CHAN_MAX; i++) {
+		ret = rvin_get_remote_channels(grp, i);
+		if (ret)
+			return ret;
+		if (grp->chan[i].asd.match.of.node)
+			found++;
+	}
+
+	if (!found)
+		return -ENODEV;
+
+	/* Register the subdevices notifier. */
+	subdevs = devm_kzalloc(grp->dev, sizeof(*subdevs) * found, GFP_KERNEL);
+	if (subdevs == NULL)
+		return -ENOMEM;
+
+	for (i = 0; i < RVIN_CSI_MAX; i++) {
+		matched += __node_add(subdevs, found, &grp->bridge[i]);
+		matched += __node_add(subdevs, found, &grp->source[i]);
+	}
+	for (i = 0; i < RVIN_CHAN_MAX; i++)
+		matched += __node_add(subdevs, found, &grp->chan[i]);
+
+	grp_dbg(grp, "found %d group subdevice(s) %d are unique\n", found,
+		matched);
+
+	grp->notifier.num_subdevs = matched;
+	grp->notifier.subdevs = subdevs;
+	grp->notifier.bound = rvin_graph_notify_bound;
+	grp->notifier.unbind = rvin_graph_notify_unbind;
+	grp->notifier.complete = rvin_graph_notify_complete;
+
+	ret = v4l2_async_notifier_register(grp->v4l2_dev, &grp->notifier);
+	if (ret < 0) {
+		grp_err(grp, "Notifier registration failed\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+/* -----------------------------------------------------------------------------
+ * Base
+ */
+
+struct rvin_group_api *rvin_group_probe(struct device *dev,
+					struct v4l2_device *v4l2_dev)
+{
+	struct rvin_group *grp;
+	int i, ret;
+
+	grp = devm_kzalloc(dev, sizeof(*grp), GFP_KERNEL);
+	if (!grp)
+		return NULL;
+
+	grp->dev = dev;
+	grp->v4l2_dev = v4l2_dev;
+	grp->chsel1 = 0;
+	grp->chsel2 = 0;
+
+	for (i = 0; i < RVIN_CSI_MAX; i++) {
+		grp->power[i] = 0;
+		grp->stream[i] = 0;
+	}
+
+	for (i = 0; i < RVIN_CHAN_MAX; i++)
+		grp->users[i] = 0;
+
+	ret = rvin_graph_init(grp);
+	if (ret) {
+		devm_kfree(dev, grp);
+		return NULL;
+	}
+
+	mutex_init(&grp->lock);
+
+	grp->api.ops = &rvin_group_ops;
+	grp->api.input_ops = &rvin_input_ops;
+
+	grp->api.get = rvin_group_get;
+	grp->api.put = rvin_group_put;
+	grp->api.set_input = rvin_group_set_input;
+	grp->api.get_code = rvin_group_get_code;
+	grp->api.get_mbus_cfg = rvin_group_get_mbus_cfg;
+	grp->api.ctrl_add_handler = rvin_group_ctrl_add_handler;
+	grp->api.alloc_pad_config = rvin_group_alloc_pad_config;
+
+	return &grp->api;
+}
+
+int rvin_group_remove(struct rvin_group_api *api)
+{
+	struct rvin_group *grp = container_of(api, struct rvin_group, api);
+
+	v4l2_async_notifier_unregister(&grp->notifier);
+
+	mutex_destroy(&grp->lock);
+
+	return 0;
+}
diff --git a/drivers/media/platform/rcar-vin/rcar-group.h b/drivers/media/platform/rcar-vin/rcar-group.h
new file mode 100644
index 0000000..b9a18b1
--- /dev/null
+++ b/drivers/media/platform/rcar-vin/rcar-group.h
@@ -0,0 +1,104 @@
+/*
+ * Driver for Renesas R-Car VIN
+ *
+ * Copyright (C) 2016 Renesas Electronics Corp.
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#ifndef __RCAR_GROUP__
+#define __RCAR_GROUP__
+
+#include <media/v4l2-dev.h>
+#include <media/v4l2-device.h>
+
+#define RVIN_PORT_LOCAL 0
+#define RVIN_PORT_CSI 1
+#define RVIN_PORT_REMOTE 2
+
+enum rvin_input_type {
+	RVIN_INPUT_NONE,
+	RVIN_INPUT_DIGITAL,
+	RVIN_INPUT_CSI2,
+};
+
+/* Max number of inputs supported */
+#define RVIN_INPUT_MAX 7
+#define RVIN_INPUT_NAME_SIZE 32
+
+/**
+ * struct rvin_input_item - One possible input for the channel
+ * @name:	User-friendly name of the input
+ * @type:	Type of the input or RVIN_INPUT_NONE if not available
+ * @chsel:	The chsel value needed to select this input
+ * @sink_idx:	Sink pad number from the subdevice associated with the input
+ * @source_idx:	Source pad number from the subdevice associated with the input
+ */
+struct rvin_input_item {
+	char name[RVIN_INPUT_NAME_SIZE];
+	enum rvin_input_type type;
+	int chsel;
+	bool hint;
+	int sink_idx;
+	int source_idx;
+};
+
+/**
+ * struct rvin_graph_entity - Video endpoint from async framework
+ * @asd:	sub-device descriptor for async framework
+ * @subdev:	subdevice matched using async framework
+ * @code:	Media bus format from source
+ * @mbus_cfg:	Media bus format from DT
+ * @source_idx:	Source pad on remote device
+ */
+struct rvin_graph_entity {
+	struct v4l2_async_subdev asd;
+	struct v4l2_subdev *subdev;
+
+	u32 code;
+	struct v4l2_mbus_config mbus_cfg;
+
+	unsigned int source_idx;
+};
+
+bool rvin_mbus_supported(struct rvin_graph_entity *entity);
+unsigned int rvin_pad_idx(struct v4l2_subdev *sd, int direction);
+
+struct rvin_group_input_ops {
+	int (*g_input_status)(struct v4l2_subdev *sd,
+			      struct rvin_input_item *item, u32 *status);
+	int (*g_tvnorms)(struct v4l2_subdev *sd,
+			 struct rvin_input_item *item, v4l2_std_id *std);
+	int (*dv_timings_cap)(struct v4l2_subdev *sd,
+			      struct rvin_input_item *item,
+			      struct v4l2_dv_timings_cap *cap);
+	int (*enum_dv_timings)(struct v4l2_subdev *sd,
+			       struct rvin_input_item *item,
+			       struct v4l2_enum_dv_timings *timings);
+};
+
+struct rvin_group_api {
+	int (*get)(struct v4l2_subdev *sd, struct rvin_input_item *inputs);
+	int (*put)(struct v4l2_subdev *sd);
+	int (*set_input)(struct v4l2_subdev *sd, struct rvin_input_item *item);
+	int (*get_code)(struct v4l2_subdev *sd, u32 *code);
+	int (*get_mbus_cfg)(struct v4l2_subdev *sd,
+			    struct v4l2_mbus_config *mbus_cfg);
+
+	int (*ctrl_add_handler)(struct v4l2_subdev *sd,
+				struct v4l2_ctrl_handler *hdl);
+	int (*alloc_pad_config)(struct v4l2_subdev *sd,
+				struct v4l2_subdev_pad_config **cfg);
+
+	const struct v4l2_subdev_ops *ops;
+	const struct rvin_group_input_ops *input_ops;
+};
+
+struct rvin_group_api *rvin_group_probe(struct device *dev,
+					struct v4l2_device *v4l2_dev);
+int rvin_group_remove(struct rvin_group_api *grp);
+
+#endif
diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index 2eb86b0..eb58ab6 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -481,7 +481,8 @@ static int rvin_enum_input(struct file *file, void *priv,
 	struct rvin_input_item *item;
 	int ret;
 
-	if (i->index >= RVIN_INPUT_MAX)
+	if (i->index >= RVIN_INPUT_MAX ||
+	    vin->inputs[i->index].type == RVIN_INPUT_NONE)
 		return -EINVAL;
 
 	item = &vin->inputs[i->index];
@@ -526,7 +527,7 @@ static int rvin_s_input(struct file *file, void *priv, unsigned int i)
 	struct rvin_dev *vin = video_drvdata(file);
 	int ret;
 
-	if (i >= RVIN_INPUT_MAX)
+	if (i >= RVIN_INPUT_MAX || vin->inputs[i].type == RVIN_INPUT_NONE)
 		return -EINVAL;
 
 	rvin_detach_subdevices(vin);
diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index 9aa29ae..b545a9c 100644
--- a/drivers/media/platform/rcar-vin/rcar-vin.h
+++ b/drivers/media/platform/rcar-vin/rcar-vin.h
@@ -23,6 +23,8 @@
 #include <media/v4l2-device.h>
 #include <media/videobuf2-v4l2.h>
 
+#include "rcar-group.h"
+
 /* Number of HW buffers */
 #define HW_BUFFER_NUM 3
 
@@ -36,21 +38,6 @@ enum chip_id {
 	RCAR_GEN3,
 };
 
-#define RVIN_INPUT_MAX 1
-#define RVIN_INPUT_NAME_SIZE 32
-
-/**
- * struct rvin_input_item - One possible input for the channel
- * @name:       User-friendly name of the input
- * @sink_idx:   Sink pad number from the subdevice associated with the input
- * @source_idx: Source pad number from the subdevice associated with the input
- */
-struct rvin_input_item {
-	char name[RVIN_INPUT_NAME_SIZE];
-	int sink_idx;
-	int source_idx;
-};
-
 /**
  * STOPPED  - No operation in progress
  * RUNNING  - Operation in progress have buffers
@@ -85,21 +72,6 @@ struct rvin_video_format {
 };
 
 /**
- * struct rvin_graph_entity - Video endpoint from async framework
- * @asd:	sub-device descriptor for async framework
- * @subdev:	subdevice matched using async framework
- * @code:	Media bus format from source
- * @mbus_cfg:	Media bus format from DT
- */
-struct rvin_graph_entity {
-	struct v4l2_async_subdev asd;
-	struct v4l2_subdev *subdev;
-
-	u32 code;
-	struct v4l2_mbus_config mbus_cfg;
-};
-
-/**
  * struct rvin_dev - Renesas VIN device structure
  * @dev:		(OF) device
  * @base:		device I/O register space remapped to virtual memory
@@ -130,6 +102,9 @@ struct rvin_graph_entity {
  * @crop:		active cropping
  * @compose:		active composing
  *
+ * @slave:		subdevice used to register with the group master
+ * @api:		group api controller (only used on master channel)
+ *
  * @current_input:	currently used input in @inputs
  * @inputs:		list of valid inputs sources
  */
@@ -162,6 +137,9 @@ struct rvin_dev {
 	struct v4l2_rect crop;
 	struct v4l2_rect compose;
 
+	struct v4l2_subdev slave;
+	struct rvin_group_api *api;
+
 	int current_input;
 	struct rvin_input_item inputs[RVIN_INPUT_MAX];
 };
@@ -175,6 +153,9 @@ struct rvin_dev {
 int rvin_dma_probe(struct rvin_dev *vin, int irq);
 void rvin_dma_remove(struct rvin_dev *vin);
 
+int rvin_subdev_probe(struct rvin_dev *vin);
+void rvin_subdev_remove(struct rvin_dev *vin);
+
 int rvin_v4l2_probe(struct rvin_dev *vin);
 void rvin_v4l2_remove(struct rvin_dev *vin);
 
@@ -186,12 +167,28 @@ void rvin_scale_try(struct rvin_dev *vin, struct v4l2_pix_format *pix,
 void rvin_crop_scale_comp(struct rvin_dev *vin);
 
 /* Subdevice group helpers */
-#define rvin_subdev_call(v, o, f, args...)				\
+#define rvin_input_is_csi(v) (v->inputs[v->current_input].type == \
+			      RVIN_INPUT_CSI2)
+#define vin_to_group(v) container_of(v->slave.v4l2_dev, struct rvin_dev, \
+				     v4l2_dev)->api
+#define rvin_subdev_call_local(v, o, f, args...)			\
 	(v->digital.subdev ?						\
 	 v4l2_subdev_call(v->digital.subdev, o, f, ##args) : -ENODEV)
+#define rvin_subdev_call_group(v, o, f, args...)			\
+	(!(v)->slave.v4l2_dev ? -ENODEV :				\
+	 (vin_to_group(v)->ops->o && vin_to_group(v)->ops->o->f) ?	\
+	 vin_to_group(v)->ops->o->f(&v->slave, ##args) : -ENOIOCTLCMD)
+#define rvin_subdev_call_group_input(v, i, f, args...)			\
+	(!(v)->slave.v4l2_dev ? -ENODEV :				\
+	 (vin_to_group(v)->input_ops->f ?				\
+	  vin_to_group(v)->input_ops->f(&v->slave, i, ##args) : -ENOIOCTLCMD))
+#define rvin_subdev_call(v, o, f, args...)				\
+	(rvin_input_is_csi(v) ? rvin_subdev_call_group(v, o, f, ##args) :\
+	 rvin_subdev_call_local(v, o, f, ##args))
 #define rvin_subdev_call_input(v, i, o, f, args...)			\
-	(v->digital.subdev ?						\
-	 v4l2_subdev_call(v->digital.subdev, o, f, ##args) : -ENODEV)
+	(v->inputs[i].type == RVIN_INPUT_CSI2 ?				\
+	 rvin_subdev_call_group_input(v, &v->inputs[i], f, ##args) :	\
+	 rvin_subdev_call_local(v, o, f, ##args))
 
 int rvin_subdev_get(struct rvin_dev *vin);
 int rvin_subdev_put(struct rvin_dev *vin);
-- 
2.9.0

