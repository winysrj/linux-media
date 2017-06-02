Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:35433 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751129AbdFBA0A (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Jun 2017 20:26:00 -0400
Received: by mail-wm0-f51.google.com with SMTP id b84so7502996wmh.0
        for <linux-media@vger.kernel.org>; Thu, 01 Jun 2017 17:25:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1495672189-29164-1-git-send-email-steve_longerbeam@mentor.com>
References: <1495672189-29164-1-git-send-email-steve_longerbeam@mentor.com>
From: Tim Harvey <tharvey@gateworks.com>
Date: Thu, 1 Jun 2017 17:25:57 -0700
Message-ID: <CAJ+vNU2K1g32HTbJktLYaCGWLbPs19HSM_PMNryPBqQC-O77vw@mail.gmail.com>
Subject: Re: [PATCH v7 00/34] i.MX Media Driver
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        mchehab@kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Nick Dyer <nick@shmanahar.org>, markus.heiser@darmarit.de,
        Philipp Zabel <p.zabel@pengutronix.de>,
        laurent.pinchart+renesas@ideasonboard.com, bparrot@ti.com,
        geert@linux-m68k.org, Arnd Bergmann <arnd@arndb.de>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        minghsiu.tsai@mediatek.com, Tiffany Lin <tiffany.lin@mediatek.com>,
        Jean-Christophe TROTIN <jean-christophe.trotin@st.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>, robert.jarzmik@free.fr,
        songjun.wu@microchip.com, andrew-ct.chen@mediatek.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        shuah@kernel.org, sakari.ailus@linux.intel.com, pavel@ucw.cz,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        linux-media <linux-media@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 24, 2017 at 5:29 PM, Steve Longerbeam <slongerbeam@gmail.com> wrote:
> In version 7:
>
> - video-mux: switched to Philipp's latest video-mux driver and updated
>   bindings docs, that makes use of the mmio-mux framework.
>
> - mmio-mux: includes Philipp's temporary patch that adds mmio-mux support
>   to video-mux driver, until mux framework is merged.
>
> - mmio-mux: updates to device tree from Philipp that define the i.MX6 mux
>   devices and modifies the video-mux device to become a consumer of the
>   video mmio-mux.
>
> - minor updates to Documentation/media/v4l-drivers/imx.rst.
>
> - ov5640: do nothing if entity stream count is greater than 1 in
>   ov5640_s_stream().
>
> - Previous versions of this driver had not tested the ability to enable
>   multiple independent streams, for instance enabling multiple output
>   pads from the imx6-mipi-csi2 subdevice, or enabling both prpenc and
>   prpvf outputs. Marek Vasut tested this support and reported issues
>   with it.
>
>   v4l2_pipeline_inherit_controls() used the media graph walk APIs, but
>   that walks both sink and source pads, so if there are multiple paths
>   enabled to video capture devices, controls would be added to the wrong
>   video capture device, and no controls added to the other enabled
>   capture devices.
>
>   These issues have been fixed. Control inheritance works correctly now
>   even with multiple enabled capture paths, and (for example)
>   simultaneous capture from prpenc and prpvf works also, and each with
>   independent scaling, CSC, and controls. For example prpenc can be
>   capturing with a 90 degree rotation, while prpvf is capturing with
>   vertical flip.
>
>   So the v4l2_pipeline_inherit_controls() patch has been dropped. The
>   new version of control inheritance could be made generically available,
>   but it would be more involved to incorporate it into v4l2-core.
>
> - A new function imx_media_fill_default_mbus_fields() is added to setup
>   colorimetry at sink pads, and these are propagated to source pads.
>
> - Ensure that the current sink and source rectangles meet alignment
>   restrictions before applying a new rotation control setting in
>   prp-enc/vf subdevices.
>
> - Chain the s_stream() subdev calls instead of implementing a custom
>   stream on/off function that attempts to call a fixed set of subdevices
>   in a pipeline in the correct order. This also simplifies imx6-mipi-csi2
>   subdevice, since the correct MIPI CSI-2 startup sequence can be
>   enforced completely in s_stream(), and s_power() is no longer
>   required. This also paves the way for more arbitrary OF graphs
>   external to the i.MX6.
>
> - Converted the v4l2_subdev and media_entity ops structures to const.
>

Hi Steve,

I've applied adv7180 device-tree config for the Gateworks ventana
boards on top of your imx-media-staging-md-v15 github branch but am
not able to get it to work.

Here's my device-tree patch that adds adv7180 to the GW54xx connected
to IPU2_CSI1:
--- a/arch/arm/boot/dts/imx6q-gw54xx.dts
+++ b/arch/arm/boot/dts/imx6q-gw54xx.dts
@@ -18,6 +18,76 @@
        compatible = "gw,imx6q-gw54xx", "gw,ventana", "fsl,imx6q";
 };

+&i2c3 {
+       adv7180: camera@20 {
+               compatible = "adi,adv7180";
+               pinctrl-names = "default";
+               pinctrl-0 = <&pinctrl_adv7180>;
+               reg = <0x20>;
+               powerdown-gpios = <&gpio3 31 GPIO_ACTIVE_LOW>;
+               interrupt-parent = <&gpio3>;
+               interrupts = <30 GPIO_ACTIVE_LOW>;
+               inputs = <0x00 0x01 0x02>;
+               input-names = "ADV7180 Composite on Ain1",
+                             "ADV7180 Composite on Ain2",
+                             "ADV7180 Composite on Ain3";
+
+               port {
+                       adv7180_to_ipu2_csi1_mux: endpoint {
+                               remote-endpoint =
<&ipu2_csi1_mux_from_parallel_sensor>;
+                               bus-width = <8>;
+                       };
+               };
+       };
+};
+
+&ipu2_csi1_from_ipu2_csi1_mux {
+       bus-width = <8>;
+};
+
+&ipu2_csi1_mux_from_parallel_sensor {
+       remote-endpoint = <&adv7180_to_ipu2_csi1_mux>;
+       bus-width = <8>;
+};
+
+&ipu2_csi1 {
+       pinctrl-names = "default";
+       pinctrl-0 = <&pinctrl_ipu2_csi1>;
+
+       /* enable frame interval monitor on this port */
+       fim {
+               status = "okay";
+       };
+};
+
 &sata {
        status = "okay";
 };
+
+&iomuxc {
+       video {
+               pinctrl_adv7180: adv7180grp {
+                       fsl,pins = <
+                               MX6QDL_PAD_EIM_D30__GPIO3_IO30
 0x0001b0b0
+                               MX6QDL_PAD_EIM_D31__GPIO3_IO31
 0x4001b0b0
+                       >;
+               };
+
+               pinctrl_ipu2_csi1: ipu2_csi1grp { /* IPU2_CSI1: 8-bit input */
+                       fsl,pins = <
+                               MX6QDL_PAD_EIM_EB2__IPU2_CSI1_DATA19    0x1b0b0
+                               MX6QDL_PAD_EIM_D16__IPU2_CSI1_DATA18    0x1b0b0
+                               MX6QDL_PAD_EIM_D18__IPU2_CSI1_DATA17    0x1b0b0
+                               MX6QDL_PAD_EIM_D19__IPU2_CSI1_DATA16    0x1b0b0
+                               MX6QDL_PAD_EIM_D20__IPU2_CSI1_DATA15    0x1b0b0
+                               MX6QDL_PAD_EIM_D26__IPU2_CSI1_DATA14    0x1b0b0
+                               MX6QDL_PAD_EIM_D27__IPU2_CSI1_DATA13    0x1b0b0
+                               MX6QDL_PAD_EIM_A17__IPU2_CSI1_DATA12    0x1b0b0
+                               MX6QDL_PAD_EIM_D29__IPU2_CSI1_VSYNC     0x1b0b0
+                               MX6QDL_PAD_EIM_EB3__IPU2_CSI1_HSYNC     0x1b0b0
+                               MX6QDL_PAD_EIM_A16__IPU2_CSI1_PIXCLK    0x1b0b0
+                       >;
+               };
+       };
+};
+

Here's my userspace test commands:

media-ctl -r # reset all links
export outputfmt="UYVY2X8/720x480"
# Setup links (ADV7180 IPU2_CSI1)
media-ctl -l '"adv7180 2-0020":0 -> "ipu2_csi1_mux":1[1]'
media-ctl -l '"ipu2_csi1_mux":2 -> "ipu2_csi1":0[1]'
media-ctl -l '"ipu2_csi1":1 -> "ipu2_vdic":0[1]'
media-ctl -l '"ipu2_vdic":2 -> "ipu2_ic_prp":0[1]'
media-ctl -l '"ipu2_ic_prp":2 -> "ipu2_ic_prpvf":0[1]'
media-ctl -l '"ipu2_ic_prpvf":1 -> "ipu2_ic_prpvf capture":0[1]'
# Configure pads
media-ctl -V "'adv7180 2-0020':0 [fmt:UYVY2X8/720x480]"
media-ctl -V "'ipu2_csi1_mux':2 [fmt:UYVY2X8/720x480 field:interlaced]"
media-ctl -V "'ipu2_csi1':1 [fmt:UYVY2X8/720x480 field:interlaced]"
media-ctl -V "'ipu2_vdic':2 [fmt:UYVY2X8/720x480 field:none]"
media-ctl -V "'ipu2_ic_prp':2 [fmt:AYUV32/720x480 field:none]"
media-ctl -V "'ipu2_ic_prpvf':1 [fmt:$outputfmt field:none]"
^^^^ no errors up to this point; streaming can now begin on
'ipu2_ic_prpvf capture'

# select input
v4l2-ctl --device /dev/video3 -i0 # 0=AIN1 1=AIN2 2=AIN3
VIDIOC_S_INPUT: failed: Inappropriate ioctl for device
^^^^ /sys/class/video4linux/v4l-subdev2/name is 'ipu2_ic_prpvf
capture' - is this not right?

# select any supported YUV or RGB pixelformat on the capture device node
v4l2-ctl --device /dev/video3
--set-fmt-video=width=720,height=480,pixelformat=UYVY
v4l2-ctl --device /dev/video3 --stream-mmap --stream-to=/x.raw
--stream-count=1 # capture single raw-frame
[  904.870444] ipu2_ic_prpvf: EOF timeout
VIDIOC_DQBUF: failed: Input/output error
[  905.910702] ipu2_ic_prpvf: wait last EOF timeout
^^^^ not getting any frames

The last patchset of yours I had running on this board was your v3
patchset - any ideas?

As it looks like things have settled down with this patchset and it
sounds like it will get merged for 4.13 I'm going to start working on
a driver for the tda1997x HDMI receiver which is also on this board
connected to IPU1_CSI0.

Thanks,

Tim
