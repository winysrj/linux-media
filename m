Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:48219 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727234AbeIET6H (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Sep 2018 15:58:07 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: laurent.pinchart@ideasonboard.com,
        kieran.bingham+renesas@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH v2 0/5] media: adv748x: Allow probe with a single output endpoint
Date: Wed,  5 Sep 2018 17:27:06 +0200
Message-Id: <1536161231-25221-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Laurent, Kieran, Niklas,
   to address the Ebisu board use case, this series allows the adv748x driver
to probe with a single output connection defined.

Compared to v1, which included only 2 patches this series is slighly bigger,
as it addresses a few more issues.

The first two patches are similar in intent to the v1's one. I have included
when possible, Kieran's comments.

Patch 3 implements what we have discussed offline: only active CSI-2 output
should be powered up.

Patch 4 makes sure the HDMI or AFE subdevice registration only happens if
the corresponding input port is described in device tree.

Finally, patch 5 addresses a design choiche which becomes problematics if
an output port might be disabled, as the corresponding input subdevice never
gets registered. While as long as we have fixed routing in place this is a
minor thing, worth to be fixed anyhow imo, but becomes more relevant if we
aim to implement dynamic routing of adv748x input/outputs.

I have tested in 3 conditions on Salvator-X M3-W:
- AFE input not registered
- TXB not registered (Ebisu use case)
- AFE and TXB not registered

Pasted here below, the adv748x media graph for each test.

1)  AFE input not registered
----------------------------- HOST --------------------------------------------
$git diff
diff --git a/arch/arm64/boot/dts/renesas/salvator-common.dtsi b/arch/arm64/boot/dts/renesas/salvator-common.dtsi
index 7d3d866..06c20ba 100644
--- a/arch/arm64/boot/dts/renesas/salvator-common.dtsi
+++ b/arch/arm64/boot/dts/renesas/salvator-common.dtsi
@@ -69,7 +69,6 @@

                port {
                        cvbs_con: endpoint {
-                               remote-endpoint = <&adv7482_ain7>;
                        };
                };
        };
@@ -430,14 +429,6 @@
                interrupts = <30 IRQ_TYPE_LEVEL_LOW>,
                             <31 IRQ_TYPE_LEVEL_LOW>;

-               port@7 {
-                       reg = <7>;
-
-                       adv7482_ain7: endpoint {
-                               remote-endpoint = <&cvbs_con>;
-                       };
-               };
-
                port@8 {
                        reg = <8>;


-------------------------- TARGET ---------------------------------------------
[root@alarm ~]# media-ctl -p -d /dev/media2
...
- entity 7: adv748x 4-0070 txa (2 pads, 2 links)
            type V4L2 subdev subtype Unknown flags 0
            device node name /dev/v4l-subdev21
        pad0: Sink
                [fmt:unknown/0x0]
                <- "adv748x 4-0070 hdmi":1 [ENABLED,IMMUTABLE]
        pad1: Source
                [fmt:unknown/0x0]
                -> "rcar_csi2 feaa0000.csi2":0 [ENABLED,IMMUTABLE]

- entity 10: adv748x 4-0070 hdmi (2 pads, 1 link)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev20
        pad0: Sink
                [dv.caps:BT.656/1120 min:640x480@13000000 max:1920x1200@162000000 stds:CEA-861,DMT caps:progressive]
        pad1: Source
                [fmt:RGB888_1X24/1280x720 field:none colorspace:srgb]
                [dv.caps:BT.656/1120 min:640x480@13000000 max:1920x1200@162000000 stds:CEA-861,DMT caps:progressive]
                [dv.query:no-link]
                [dv.current:BT.656/1120 1280x720p30 (3300x750) stds:CEA-861 flags:can-reduce-fps,CE-video,has-cea861-vic]
                -> "adv748x 4-0070 txa":0 [ENABLED,IMMUTABLE]

- entity 23: adv748x 4-0070 txb (2 pads, 1 link)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev23
        pad0: Sink
                [fmt:unknown/0x0]
        pad1: Source
                [fmt:unknown/0x0]
                -> "rcar_csi2 fea80000.csi2":0 [ENABLED,IMMUTABLE]
...

2) TXB not registered (Ebisu use case)
----------------------------- HOST --------------------------------------------
$git diff
diff --git a/arch/arm64/boot/dts/renesas/salvator-common.dtsi b/arch/arm64/boot/dts/renesas/salvator-common.dtsi
index 7d3d866..3123633 100644
--- a/arch/arm64/boot/dts/renesas/salvator-common.dtsi
+++ b/arch/arm64/boot/dts/renesas/salvator-common.dtsi
@@ -281,7 +281,7 @@
 };

 &csi20 {
-       status = "okay";
+       status = "disabled";

        ports {
                port@0 {
@@ -289,7 +289,6 @@
                        csi20_in: endpoint {
                                clock-lanes = <0>;
                                data-lanes = <1>;
-                               remote-endpoint = <&adv7482_txb>;
                        };
                };
        };
@@ -455,16 +454,6 @@
                                remote-endpoint = <&csi40_in>;
                        };
                };
-
-               port@b {
-                       reg = <11>;
-
-                       adv7482_txb: endpoint {
-                               clock-lanes = <0>;
-                               data-lanes = <1>;
-                               remote-endpoint = <&csi20_in>;
-                       };
-               };
        };
 };

-------------------------- TARGET ---------------------------------------------
[root@alarm ~]# media-ctl -p -d /dev/media2
...
- entity 7: adv748x 4-0070 txa (2 pads, 2 links)
            type V4L2 subdev subtype Unknown flags 0
            device node name /dev/v4l-subdev22
        pad0: Sink
                [fmt:unknown/0x0]
                <- "adv748x 4-0070 hdmi":1 [ENABLED,IMMUTABLE]
        pad1: Source
                [fmt:unknown/0x0]
                -> "rcar_csi2 feaa0000.csi2":0 [ENABLED,IMMUTABLE]

- entity 10: adv748x 4-0070 hdmi (2 pads, 1 link)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev20
        pad0: Sink
                [dv.caps:BT.656/1120 min:640x480@13000000 max:1920x1200@162000000 stds:CEA-861,DMT caps:progressive]
        pad1: Source
                [fmt:RGB888_1X24/1280x720 field:none colorspace:srgb]
                [dv.caps:BT.656/1120 min:640x480@13000000 max:1920x1200@162000000 stds:CEA-861,DMT caps:progressive]
                [dv.query:no-link]
                [dv.current:BT.656/1120 1280x720p30 (3300x750) stds:CEA-861 flags:can-reduce-fps,CE-video,has-cea861-vic]
                -> "adv748x 4-0070 txa":0 [ENABLED,IMMUTABLE]

- entity 13: adv748x 4-0070 afe (9 pads, 0 link)
             type V4L2 subdev subtype Decoder flags 0
             device node name /dev/v4l-subdev21
        pad0: Sink
        pad1: Sink
        pad2: Sink
        pad3: Sink
        pad4: Sink
        pad5: Sink
        pad6: Sink
        pad7: Sink
        pad8: Source
                [fmt:UYVY8_2X8/720x240 field:alternate colorspace:smpte170m]
...

3) AFE and TXB not registered
----------------------------- HOST --------------------------------------------
$git diff
diff --git a/arch/arm64/boot/dts/renesas/salvator-common.dtsi b/arch/arm64/boot/dts/renesas/salvator-common.dtsi
index 7d3d866..9f1b079 100644
--- a/arch/arm64/boot/dts/renesas/salvator-common.dtsi
+++ b/arch/arm64/boot/dts/renesas/salvator-common.dtsi
@@ -69,7 +69,6 @@

                port {
                        cvbs_con: endpoint {
-                               remote-endpoint = <&adv7482_ain7>;
                        };
                };
        };
@@ -281,7 +280,7 @@
 };

 &csi20 {
-       status = "okay";
+       status = "disabled";

        ports {
                port@0 {
@@ -289,7 +288,6 @@
                        csi20_in: endpoint {
                                clock-lanes = <0>;
                                data-lanes = <1>;
-                               remote-endpoint = <&adv7482_txb>;
                        };
                };
        };
@@ -430,14 +428,6 @@
                interrupts = <30 IRQ_TYPE_LEVEL_LOW>,
                             <31 IRQ_TYPE_LEVEL_LOW>;

-               port@7 {
-                       reg = <7>;
-
-                       adv7482_ain7: endpoint {
-                               remote-endpoint = <&cvbs_con>;
-                       };
-               };
-
                port@8 {
                        reg = <8>;

@@ -455,16 +445,6 @@
                                remote-endpoint = <&csi40_in>;
                        };
                };
-
-               port@b {
-                       reg = <11>;
-
-                       adv7482_txb: endpoint {
-                               clock-lanes = <0>;
-                               data-lanes = <1>;
-                               remote-endpoint = <&csi20_in>;
-                       };
-               };
        };
 };

-------------------------- TARGET ---------------------------------------------
[root@alarm ~]# media-ctl -p -d /dev/media2
...
- entity 7: adv748x 4-0070 txa (2 pads, 2 links)
            type V4L2 subdev subtype Unknown flags 0
            device node name /dev/v4l-subdev21
        pad0: Sink
                [fmt:unknown/0x0]
                <- "adv748x 4-0070 hdmi":1 [ENABLED,IMMUTABLE]
        pad1: Source
                [fmt:unknown/0x0]
                -> "rcar_csi2 feaa0000.csi2":0 [ENABLED,IMMUTABLE]

- entity 10: adv748x 4-0070 hdmi (2 pads, 1 link)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev20
        pad0: Sink
                [dv.caps:BT.656/1120 min:640x480@13000000 max:1920x1200@162000000 stds:CEA-861,DMT caps:progressive]
        pad1: Source
                [fmt:RGB888_1X24/1280x720 field:none colorspace:srgb]
                [dv.caps:BT.656/1120 min:640x480@13000000 max:1920x1200@162000000 stds:CEA-861,DMT caps:progressive]
                [dv.query:no-link]
                [dv.current:BT.656/1120 1280x720p30 (3300x750) stds:CEA-861 flags:can-reduce-fps,CE-video,has-cea861-vic]
                -> "adv748x 4-0070 txa":0 [ENABLED,IMMUTABLE]
..



Jacopo Mondi (5):
  media: i2c: adv748x: Support probing a single output
  media: i2c: adv748x: Handle TX[A|B] power management
  media: i2c: adv748x: Conditionally enable only CSI-2 outputs
  media: i2c: adv748x: Register only enabled inputs
  media: i2c: adv748x: Register all input subdevices

 drivers/media/i2c/adv748x/adv748x-afe.c  |   2 +-
 drivers/media/i2c/adv748x/adv748x-core.c |  83 +++++++++++++------------
 drivers/media/i2c/adv748x/adv748x-csi2.c | 102 +++++++++++++------------------
 drivers/media/i2c/adv748x/adv748x-hdmi.c |   2 +-
 drivers/media/i2c/adv748x/adv748x.h      |  19 ++++--
 5 files changed, 102 insertions(+), 106 deletions(-)

--
2.7.4
