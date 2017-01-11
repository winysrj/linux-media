Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:34868 "EHLO
        mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760775AbdAKXOp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Jan 2017 18:14:45 -0500
Received: by mail-io0-f171.google.com with SMTP id j18so5598356ioe.2
        for <linux-media@vger.kernel.org>; Wed, 11 Jan 2017 15:14:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
From: Tim Harvey <tharvey@gateworks.com>
Date: Wed, 11 Jan 2017 15:14:43 -0800
Message-ID: <CAJ+vNU2zU++Xam_UpDPfmSQhauhhS3_z8L-+ww6o-D9brWhiwA@mail.gmail.com>
Subject: Re: [PATCH v3 00/24] i.MX Media Driver
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        mchehab@kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        nick@shmanahar.org, markus.heiser@darmarit.de,
        Philipp Zabel <p.zabel@pengutronix.de>,
        laurent.pinchart+renesas@ideasonboard.com, bparrot@ti.com,
        geert@linux-m68k.org, Arnd Bergmann <arnd@arndb.de>,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        Simon Horman <horms+renesas@verge.net.au>,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>, robert.jarzmik@free.fr,
        songjun.wu@microchip.com, andrew-ct.chen@mediatek.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        linux-media <linux-media@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jan 6, 2017 at 6:11 PM, Steve Longerbeam <slongerbeam@gmail.com> wrote:
> In version 3:
>
> Changes suggested by Rob Herring <robh@kernel.org>:
>
>   - prepended FIM node properties with vendor prefix "fsl,".
>
>   - make mipi csi-2 receiver compatible string SoC specific:
>     "fsl,imx6-mipi-csi2" instead of "fsl,imx-mipi-csi2".
>
>   - redundant "_clk" removed from mipi csi-2 receiver clock-names property.
>
>   - removed board-specific info from the media driver binding doc. These
>     were all related to sensor bindings, which already are (adv7180)
>     or will be (ov564x) covered in separate binding docs. All reference
>     board info not related to DT bindings has been moved to
>     Documentation/media/v4l-drivers/imx.rst.
>
>   - removed "_mipi" from the OV5640 compatible string.
>
> Changes suggested by Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>:
>
>   Mostly cosmetic/non-functional changes which I won't list here, except
>   for the following:
>
>   - spin_lock_irqsave() changed to spin_lock() in a couple interrupt handlers.
>
>   - fixed some unnecessary of_node_put()'s in for_each_child_of_node() loops.
>
>   - check/handle return code from required reg property of CSI port nodes.
>
>   - check/handle return code from clk_prepare_enable().
>
> Changes suggested by Fabio Estevam <festevam@gmail.com>:
>
>   - switch to VGEN3 Analog Vdd supply assuming rev. C SabreSD boards.
>
>   - finally got around to passing valid IOMUX pin config values to the
>     pin groups.
>
> Other changes:
>
>   - removed the FIM properties that overrided the v4l2 FIM control defaults
>     values. This was left-over from a requirement of a customer and is not
>     necessary here.
>
>   - The FIM must be explicitly enabled in the fim child node under the CSI
>     port nodes, using the status property. If not enabled, FIM v4l2 controls
>     will not appear in the video capture driver.
>
>   - brought in additional media types patch from Philipp Zabel. Use new
>     MEDIA_ENT_F_VID_IF_BRIDGE in mipi csi-2 receiver subdev.
>
>   - brought in latest platform generic video multiplexer subdevice driver
>     from Philipp Zabel (squashed with patch that uses new MEDIA_ENT_F_MUX).
>
>   - removed imx-media-of.h, moved those prototypes into imx-media.h.
>
>
<snip>

Hi Steve,

I took a stab at testing this today on a gw51xx which has an adv7180
hooked up as follows:
- i2c3@0x20
- 8bit data bus from DAT12 to DAT19, HSYNC, VSYNC, PIXCLK on CSI0 pads
(CSI0_IPU1)
- PWRDWN# on MX6QDL_PAD_CSI0_DATA_EN__GPIO5_IO20
- IRQ# on MX6QDL_PAD_CSI0_DAT5__GPIO5_IO23
- all three analog inputs available to off-board connector

My patch to the imx6qdl-gw51xx dtsi is:
diff --git a/arch/arm/boot/dts/imx6qdl-gw51xx.dtsi
b/arch/arm/boot/dts/imx6qdl-gw51xx.dtsi
index afec2c7..2583d72 100644
--- a/arch/arm/boot/dts/imx6qdl-gw51xx.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-gw51xx.dtsi
@@ -165,6 +174,52 @@
        pinctrl-names = "default";
        pinctrl-0 = <&pinctrl_i2c3>;
        status = "okay";
+
+       camera: adv7180@20 {
+               compatible = "adi,adv7180";
+               pinctrl-names = "default";
+               pinctrl-0 = <&pinctrl_adv7180>;
+               reg = <0x20>;
+               powerdown-gpio = <&gpio5 20 GPIO_ACTIVE_LOW>;
+               interrupt-parent = <&gpio5>;
+               interrupts = <23 GPIO_ACTIVE_LOW>;
+               inputs = <0x00 0x01 0x02>;
+               input-names = "ADV7180 Composite on Ain1",
+                             "ADV7180 Composite on Ain2",
+                             "ADV7180 Composite on Ain3";
+
+               port {
+                       adv7180_to_ipu1_csi0_mux: endpoint {
+                               remote-endpoint =
<&ipu1_csi0_mux_from_parallel_sensor>;
+                               bus-width = <8>;
+                       };
+               };
+       };
+};
+
+&ipu1_csi0_from_ipu1_csi0_mux {
+       bus-width = <8>;
+};
+
+&ipu1_csi0_mux_from_parallel_sensor {
+       remote-endpoint = <&adv7180_to_ipu1_csi0_mux>;
+       bus-width = <8>;
+};
+
+&ipu1_csi0 {
+       pinctrl-names = "default";
+       pinctrl-0 = <&pinctrl_ipu1_csi0>;
+
+       /* enable frame interval monitor on this port */
+       fim {
+               status = "okay";
+       };
 };

 &pcie {
@@ -236,6 +291,13 @@

 &iomuxc {
        imx6qdl-gw51xx {
+               pinctrl_adv7180: adv7180grp {
+                       fsl,pins = <
+                               MX6QDL_PAD_CSI0_DAT5__GPIO5_IO23
 0x0001b0b0 /* VIDDEC_IRQ# */
+                               MX6QDL_PAD_CSI0_DATA_EN__GPIO5_IO20
 0x4001b0b0 /* VIDDEC_EN */
+                       >;
+               };
+
                pinctrl_enet: enetgrp {
                        fsl,pins = <
                                MX6QDL_PAD_RGMII_RXC__RGMII_RXC         0x1b030
@@ -306,6 +368,22 @@
                        >;
                };

+               pinctrl_ipu1_csi0: ipu1csi0grp { /* IPU1_CSI0: 8-bit input */
+                       fsl,pins = <
+
MX6QDL_PAD_CSI0_DAT12__IPU1_CSI0_DATA12    0x1b0b0
+
MX6QDL_PAD_CSI0_DAT13__IPU1_CSI0_DATA13    0x1b0b0
+
MX6QDL_PAD_CSI0_DAT14__IPU1_CSI0_DATA14    0x1b0b0
+
MX6QDL_PAD_CSI0_DAT15__IPU1_CSI0_DATA15    0x1b0b0
+
MX6QDL_PAD_CSI0_DAT16__IPU1_CSI0_DATA16    0x1b0b0
+
MX6QDL_PAD_CSI0_DAT17__IPU1_CSI0_DATA17    0x1b0b0
+
MX6QDL_PAD_CSI0_DAT18__IPU1_CSI0_DATA18    0x1b0b0
+
MX6QDL_PAD_CSI0_DAT19__IPU1_CSI0_DATA19    0x1b0b0
+                               MX6QDL_PAD_CSI0_MCLK__IPU1_CSI0_HSYNC
    0x1b0b0
+                               MX6QDL_PAD_CSI0_VSYNC__IPU1_CSI0_VSYNC
    0x1b0b0
+
MX6QDL_PAD_CSI0_PIXCLK__IPU1_CSI0_PIXCLK   0x1b0b0
+                       >;
+               };
+
                pinctrl_pcie: pciegrp {
                        fsl,pins = <
                                MX6QDL_PAD_GPIO_0__GPIO1_IO00           0x1b0b0

On an IMX6Q I'm getting the following when the adv7180 module loads:
[   12.862477] adv7180 2-0020: chip found @ 0x20 (21a8000.i2c)
[   12.907767] imx-media: Registered subdev adv7180 2-0020
[   12.907793] imx-media soc:media@0: Entity type for entity adv7180
2-0020 was not initialized!
[   12.907867] imx-media: imx_media_create_link: adv7180 2-0020:0 ->
ipu1_csi0_mux:1

Is the warning that adv7180 was not initialized expected and or an issue?

Now that your driver is hooking into the current media framework, I'm
not at all clear on how to link and configure the media entities.
Using 'media-ctl -p' to list the entities I see:
Media controller API version 0.1.0

Media device information
------------------------
driver          imx-media
model           imx-media
serial
bus info
hw revision     0x0
driver version  0.0.0

Device topology
- entity 1: ipu2_csi1_mux (3 pads, 1 link)
            type V4L2 subdev subtype Unknown flags 0
            device node name /dev/v4l-subdev0
        pad0: Sink
                [fmt:unknown/0x0]
        pad1: Sink
                [fmt:unknown/0x0]
        pad2: Source
                [fmt:unknown/0x0]
                -> "ipu2_csi1":0 []

- entity 5: ipu1_csi0_mux (3 pads, 2 links)
            type V4L2 subdev subtype Unknown flags 0
            device node name /dev/v4l-subdev1
        pad0: Sink
                [fmt:unknown/0x0]
        pad1: Sink
                [fmt:unknown/0x0]
                <- "adv7180 2-0020":0 []
        pad2: Source
                [fmt:unknown/0x0]
                -> "ipu1_csi0":0 []

- entity 9: ipu1_ic_prpenc (2 pads, 4 links)
            type V4L2 subdev subtype Unknown flags 0
            device node name /dev/v4l-subdev2
        pad0: Sink
                [fmt:UYVY2X8/640x480 field:none]
                <- "ipu1_csi0":1 []
                <- "ipu1_csi1":1 []
        pad1: Source
                [fmt:UYVY2X8/640x480 field:none]
                -> "camif0":0 []
                -> "camif1":0 []

- entity 12: ipu1_ic_prpvf (2 pads, 8 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev3
        pad0: Sink
                [fmt:UYVY2X8/640x480 field:none]
                <- "ipu1_csi0":1 []
                <- "ipu1_csi1":1 []
                <- "ipu1_smfc0":1 []
                <- "ipu1_smfc1":1 []
        pad1: Source
                [fmt:UYVY2X8/640x480 field:none]
                -> "camif0":0 []
                -> "camif1":0 []
                -> "ipu1_ic_pp0":0 []
                -> "ipu1_ic_pp1":0 []

- entity 15: ipu1_ic_pp0 (2 pads, 4 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev4
        pad0: Sink
                [fmt:UYVY2X8/640x480 field:none]
                <- "ipu1_ic_prpvf":1 []
                <- "ipu1_smfc0":1 []
        pad1: Source
                [fmt:UYVY2X8/640x480 field:none]
                -> "camif0":0 []
                -> "camif1":0 []

- entity 18: ipu1_ic_pp1 (2 pads, 4 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev5
        pad0: Sink
                [fmt:UYVY2X8/640x480 field:none]
                <- "ipu1_ic_prpvf":1 []
                <- "ipu1_smfc1":1 []
        pad1: Source
                [fmt:UYVY2X8/640x480 field:none]
                -> "camif0":0 []
                -> "camif1":0 []

- entity 21: ipu2_ic_prpenc (2 pads, 4 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev6
        pad0: Sink
                [fmt:UYVY2X8/640x480 field:none]
                <- "ipu2_csi0":1 []
                <- "ipu2_csi1":1 []
        pad1: Source
                [fmt:UYVY2X8/640x480 field:none]
                -> "camif2":0 []
                -> "camif3":0 []

- entity 24: ipu2_ic_prpvf (2 pads, 8 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev7
        pad0: Sink
                [fmt:UYVY2X8/640x480 field:none]
                <- "ipu2_csi0":1 []
                <- "ipu2_csi1":1 []
                <- "ipu2_smfc0":1 []
                <- "ipu2_smfc1":1 []
        pad1: Source
                [fmt:UYVY2X8/640x480 field:none]
                -> "camif2":0 []
                -> "camif3":0 []
                -> "ipu2_ic_pp0":0 []
                -> "ipu2_ic_pp1":0 []

- entity 27: ipu2_ic_pp0 (2 pads, 4 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev8
        pad0: Sink
                [fmt:UYVY2X8/640x480 field:none]
                <- "ipu2_ic_prpvf":1 []
                <- "ipu2_smfc0":1 []
        pad1: Source
                [fmt:UYVY2X8/640x480 field:none]
                -> "camif2":0 []
                -> "camif3":0 []

- entity 30: ipu2_ic_pp1 (2 pads, 4 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev9
        pad0: Sink
                [fmt:UYVY2X8/640x480 field:none]
                <- "ipu2_ic_prpvf":1 []
                <- "ipu2_smfc1":1 []
        pad1: Source
                [fmt:UYVY2X8/640x480 field:none]
                -> "camif2":0 []
                -> "camif3":0 []

- entity 33: ipu1_csi0 (2 pads, 4 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev10
        pad0: Sink
                [fmt:UYVY2X8/640x480 field:none]
                <- "ipu1_csi0_mux":2 []
        pad1: Source
                [fmt:UYVY2X8/640x480 field:none
                 crop.bounds:(0,0)/640x480
                 crop:(0,0)/0x0]
                -> "ipu1_ic_prpenc":0 []
                -> "ipu1_ic_prpvf":0 []
                -> "ipu1_smfc0":0 []

- entity 36: ipu1_csi1 (2 pads, 3 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev11
        pad0: Sink
                [fmt:UYVY2X8/640x480 field:none]
        pad1: Source
                [fmt:UYVY2X8/640x480 field:none
                 crop.bounds:(0,0)/640x480
                 crop:(0,0)/0x0]
                -> "ipu1_ic_prpenc":0 []
                -> "ipu1_ic_prpvf":0 []
                -> "ipu1_smfc1":0 []

- entity 39: ipu2_csi0 (2 pads, 3 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev12
        pad0: Sink
                [fmt:UYVY2X8/640x480 field:none]
        pad1: Source
                [fmt:UYVY2X8/640x480 field:none
                 crop.bounds:(0,0)/640x480
                 crop:(0,0)/0x0]
                -> "ipu2_ic_prpenc":0 []
                -> "ipu2_ic_prpvf":0 []
                -> "ipu2_smfc0":0 []

- entity 42: ipu2_csi1 (2 pads, 4 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev13
        pad0: Sink
                [fmt:UYVY2X8/640x480 field:none]
                <- "ipu2_csi1_mux":2 []
        pad1: Source
                [fmt:UYVY2X8/640x480 field:none
                 crop.bounds:(0,0)/640x480
                 crop:(0,0)/0x0]
                -> "ipu2_ic_prpenc":0 []
                -> "ipu2_ic_prpvf":0 []
                -> "ipu2_smfc1":0 []

- entity 45: ipu1_smfc0 (2 pads, 5 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev14
        pad0: Sink
                [fmt:UYVY2X8/640x480 field:none]
                <- "ipu1_csi0":1 []
        pad1: Source
                [fmt:UYVY2X8/640x480 field:none]
                -> "ipu1_ic_prpvf":0 []
                -> "ipu1_ic_pp0":0 []
                -> "camif0":0 []
                -> "camif1":0 []

- entity 48: ipu1_smfc1 (2 pads, 5 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev15
        pad0: Sink
                [fmt:UYVY2X8/640x480 field:none]
                <- "ipu1_csi1":1 []
        pad1: Source
                [fmt:UYVY2X8/640x480 field:none]
                -> "ipu1_ic_prpvf":0 []
                -> "ipu1_ic_pp1":0 []
                -> "camif0":0 []
                -> "camif1":0 []

- entity 51: ipu2_smfc0 (2 pads, 5 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev16
        pad0: Sink
                [fmt:UYVY2X8/640x480 field:none]
                <- "ipu2_csi0":1 []
        pad1: Source
                [fmt:UYVY2X8/640x480 field:none]
                -> "ipu2_ic_prpvf":0 []
                -> "ipu2_ic_pp0":0 []
                -> "camif2":0 []
                -> "camif3":0 []

- entity 54: ipu2_smfc1 (2 pads, 5 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev17
        pad0: Sink
                [fmt:UYVY2X8/640x480 field:none]
                <- "ipu2_csi1":1 []
        pad1: Source
                [fmt:UYVY2X8/640x480 field:none]
                -> "ipu2_ic_prpvf":0 []
                -> "ipu2_ic_pp1":0 []
                -> "camif2":0 []
                -> "camif3":0 []

- entity 57: camif0 (2 pads, 7 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev18
        pad0: Sink
                [fmt:UYVY2X8/640x480 field:none]
                <- "ipu1_ic_prpenc":1 []
                <- "ipu1_ic_prpvf":1 []
                <- "ipu1_ic_pp0":1 []
                <- "ipu1_ic_pp1":1 []
                <- "ipu1_smfc0":1 []
                <- "ipu1_smfc1":1 []
        pad1: Source
                [fmt:UYVY2X8/640x480 field:none]
                -> "camif0 devnode":0 [ENABLED,IMMUTABLE]

- entity 58: camif0 devnode (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video0
        pad0: Sink
                <- "camif0":1 [ENABLED,IMMUTABLE]

- entity 66: camif1 (2 pads, 7 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev19
        pad0: Sink
                [fmt:UYVY2X8/640x480 field:none]
                <- "ipu1_ic_prpenc":1 []
                <- "ipu1_ic_prpvf":1 []
                <- "ipu1_ic_pp0":1 []
                <- "ipu1_ic_pp1":1 []
                <- "ipu1_smfc0":1 []
                <- "ipu1_smfc1":1 []
        pad1: Source
                [fmt:UYVY2X8/640x480 field:none]
                -> "camif1 devnode":0 [ENABLED,IMMUTABLE]

- entity 67: camif1 devnode (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video1
        pad0: Sink
                <- "camif1":1 [ENABLED,IMMUTABLE]

- entity 75: camif2 (2 pads, 7 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev20
        pad0: Sink
                [fmt:UYVY2X8/640x480 field:none]
                <- "ipu2_ic_prpenc":1 []
                <- "ipu2_ic_prpvf":1 []
                <- "ipu2_ic_pp0":1 []
                <- "ipu2_ic_pp1":1 []
                <- "ipu2_smfc0":1 []
                <- "ipu2_smfc1":1 []
        pad1: Source
                [fmt:UYVY2X8/640x480 field:none]
                -> "camif2 devnode":0 [ENABLED,IMMUTABLE]

- entity 76: camif2 devnode (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video2
        pad0: Sink
                <- "camif2":1 [ENABLED,IMMUTABLE]

- entity 84: camif3 (2 pads, 7 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev21
        pad0: Sink
                [fmt:UYVY2X8/640x480 field:none]
                <- "ipu2_ic_prpenc":1 []
                <- "ipu2_ic_prpvf":1 []
                <- "ipu2_ic_pp0":1 []
                <- "ipu2_ic_pp1":1 []
                <- "ipu2_smfc0":1 []
                <- "ipu2_smfc1":1 []
        pad1: Source
                [fmt:UYVY2X8/640x480 field:none]
                -> "camif3 devnode":0 [ENABLED,IMMUTABLE]

- entity 85: camif3 devnode (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video3
        pad0: Sink
                <- "camif3":1 [ENABLED,IMMUTABLE]

- entity 93: adv7180 2-0020 (1 pad, 1 link)
             type V4L2 subdev subtype Unknown flags 20004
             device node name /dev/v4l-subdev22
        pad0: Source
                [fmt:UYVY2X8/720x480 field:interlaced]
                -> "ipu1_csi0_mux":1 []

How do I link the entities here to be able to capture frames with
v4l2-ctl or gstreamer?

Additionally I've found that on an IMX6S/IMX6DL we crash while
registering the media-ic subdev's:
[    3.975473] imx-media: Registered subdev ipu1_csi1_mux
[    3.980921] imx-media: Registered subdev ipu1_csi0_mux
[    4.003205] imx-media: Registered subdev ipu1_ic_prpenc
[    4.025373] imx-media: Registered subdev ipu1_ic_prpvf
[    4.037944] ------------[ cut here ]------------
[    4.042571] Kernel BUG at c06717dc [verbose debug info unavailable]
[    4.048845] Internal error: Oops - BUG: 0 [#1] SMP ARM
[    4.053990] Modules linked in:
[    4.057076] CPU: 1 PID: 1 Comm: swapper/0 Not tainted
4.9.0-rc6-00524-g84dad6e-dirty #446
[    4.065260] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
...
[    4.296250] [<c0671780>] (v4l2_subdev_init) from [<c06fb02c>]
(imx_ic_probe+0x94/0x1ac)
[    4.304271] [<c06faf98>] (imx_ic_probe) from [<c05173d8>]
(platform_drv_probe+0x54/0xb8)
[    4.312373]  r9:c0d5e858 r8:00000000 r7:fffffdfb r6:c0e5dbf8
r5:da603810 r4:c16738d8
[    4.320129] [<c0517384>] (platform_drv_probe) from [<c0515978>]
(driver_probe_device+0x20c/0x2c0)
[    4.329010]  r7:c0e5dbf8 r6:00000000 r5:da603810 r4:c16738d8
[    4.334681] [<c051576c>] (driver_probe_device) from [<c0515af4>]
(__driver_attach+0xc8/0xcc)
[    4.343129]  r9:c0d5e858 r8:00000000 r7:00000000 r6:da603844
r5:c0e5dbf8 r4:da603810
[    4.350889] [<c0515a2c>] (__driver_attach) from [<c0513adc>]
(bus_for_each_dev+0x74/0xa8)
[    4.359078]  r7:00000000 r6:c0515a2c r5:c0e5dbf8 r4:00000000
[    4.364753] [<c0513a68>] (bus_for_each_dev) from [<c05151d4>]
(driver_attach+0x20/0x28)

I assume there is an iteration that needs a test on a missing pointer
only available on chips with both IPU's or PRP

Regards,

Tim
