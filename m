Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:55496 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750925AbdE2NqQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 May 2017 09:46:16 -0400
Subject: Re: [PATCH v7 00/34] i.MX Media Driver
To: Steve Longerbeam <slongerbeam@gmail.com>, robh+dt@kernel.org,
        mark.rutland@arm.com, shawnguo@kernel.org, kernel@pengutronix.de,
        fabio.estevam@nxp.com, linux@armlinux.org.uk, mchehab@kernel.org,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org,
        shuah@kernel.org, sakari.ailus@linux.intel.com, pavel@ucw.cz
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
References: <1495672189-29164-1-git-send-email-steve_longerbeam@mentor.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <dd82968a-4c0b-12a4-f43b-7e63a255812d@xs4all.nl>
Date: Mon, 29 May 2017 15:46:08 +0200
MIME-Version: 1.0
In-Reply-To: <1495672189-29164-1-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

On 05/25/2017 02:29 AM, Steve Longerbeam wrote:
> In version 7:
> 
> - video-mux: switched to Philipp's latest video-mux driver and updated
>    bindings docs, that makes use of the mmio-mux framework.
> 
> - mmio-mux: includes Philipp's temporary patch that adds mmio-mux support
>    to video-mux driver, until mux framework is merged.
> 
> - mmio-mux: updates to device tree from Philipp that define the i.MX6 mux
>    devices and modifies the video-mux device to become a consumer of the
>    video mmio-mux.
> 
> - minor updates to Documentation/media/v4l-drivers/imx.rst.
> 
> - ov5640: do nothing if entity stream count is greater than 1 in
>    ov5640_s_stream().
> 
> - Previous versions of this driver had not tested the ability to enable
>    multiple independent streams, for instance enabling multiple output
>    pads from the imx6-mipi-csi2 subdevice, or enabling both prpenc and
>    prpvf outputs. Marek Vasut tested this support and reported issues
>    with it.
> 
>    v4l2_pipeline_inherit_controls() used the media graph walk APIs, but
>    that walks both sink and source pads, so if there are multiple paths
>    enabled to video capture devices, controls would be added to the wrong
>    video capture device, and no controls added to the other enabled
>    capture devices.
> 
>    These issues have been fixed. Control inheritance works correctly now
>    even with multiple enabled capture paths, and (for example)
>    simultaneous capture from prpenc and prpvf works also, and each with
>    independent scaling, CSC, and controls. For example prpenc can be
>    capturing with a 90 degree rotation, while prpvf is capturing with
>    vertical flip.
> 
>    So the v4l2_pipeline_inherit_controls() patch has been dropped. The
>    new version of control inheritance could be made generically available,
>    but it would be more involved to incorporate it into v4l2-core.
> 
> - A new function imx_media_fill_default_mbus_fields() is added to setup
>    colorimetry at sink pads, and these are propagated to source pads.
> 
> - Ensure that the current sink and source rectangles meet alignment
>    restrictions before applying a new rotation control setting in
>    prp-enc/vf subdevices.
> 
> - Chain the s_stream() subdev calls instead of implementing a custom
>    stream on/off function that attempts to call a fixed set of subdevices
>    in a pipeline in the correct order. This also simplifies imx6-mipi-csi2
>    subdevice, since the correct MIPI CSI-2 startup sequence can be
>    enforced completely in s_stream(), and s_power() is no longer
>    required. This also paves the way for more arbitrary OF graphs
>    external to the i.MX6.
> 
> - Converted the v4l2_subdev and media_entity ops structures to const.

What is the status as of v7?

 From what I can tell patch 2/34 needs an Ack from Rob Herring, patches
4-14 are out of scope for the media subsystem, patches 20-25 and 27-34
are all staging (so fine to be merged from my point of view).

I'm not sure if patch 26 (defconfig) should be applied while the imx
driver is in staging. I would suggest that this patch is moved to the end
of the series.

That leaves patches 15-19. I replied to patch 15 with a comment, patches
16-18 look good to me, although patches 17 and 18 should be combined to one
patch since patch 17 won't compile otherwise. Any idea when the multiplexer is
expected to be merged? (just curious)

I would really like to get this merged for 4.13, so did I miss anything?
 From what I can tell it is really just an Ack for patch 2/34.

Regards,

	Hans

> 
> 
> Marek Vasut (1):
>    media: imx: Drop warning upon multiple S_STREAM disable calls
> 
> Philipp Zabel (9):
>    dt-bindings: Add bindings for video-multiplexer device
>    ARM: dts: imx6qdl: add multiplexer controls
>    ARM: dts: imx6qdl: Add video multiplexers, mipi_csi, and their
>      connections
>    add mux and video interface bridge entity functions
>    platform: add video-multiplexer subdevice driver
>    platform: video-mux: include temporary mmio-mux support
>    media: imx: csi: increase burst size for YUV formats
>    media: imx: csi: add frame skipping support
>    media: imx: csi: add sink selection rectangles
> 
> Russell King (3):
>    media: imx: csi: add support for bayer formats
>    media: imx: csi: add frame size/interval enumeration
>    media: imx: capture: add frame sizes/interval enumeration
> 
> Steve Longerbeam (21):
>    [media] dt-bindings: Add bindings for i.MX media driver
>    [media] dt/bindings: Add bindings for OV5640
>    ARM: dts: imx6qdl: Add compatible, clocks, irqs to MIPI CSI-2 node
>    ARM: dts: imx6qdl: add capture-subsystem device
>    ARM: dts: imx6qdl-sabrelite: remove erratum ERR006687 workaround
>    ARM: dts: imx6-sabrelite: add OV5642 and OV5640 camera sensors
>    ARM: dts: imx6-sabresd: add OV5642 and OV5640 camera sensors
>    ARM: dts: imx6-sabreauto: create i2cmux for i2c3
>    ARM: dts: imx6-sabreauto: add reset-gpios property for max7310_b
>    ARM: dts: imx6-sabreauto: add pinctrl for gpt input capture
>    ARM: dts: imx6-sabreauto: add the ADV7180 video decoder
>    [media] add Omnivision OV5640 sensor driver
>    media: Add userspace header file for i.MX
>    media: Add i.MX media core driver
>    media: imx: Add Capture Device Interface
>    media: imx: Add CSI subdev driver
>    media: imx: Add VDIC subdev driver
>    media: imx: Add IC subdev drivers
>    media: imx: Add MIPI CSI-2 Receiver subdev driver
>    ARM: imx_v6_v7_defconfig: Enable staging video4linux drivers
>    media: imx: set and propagate default field, colorimetry
> 
>   .../devicetree/bindings/media/i2c/ov5640.txt       |   45 +
>   Documentation/devicetree/bindings/media/imx.txt    |   74 +
>   .../devicetree/bindings/media/video-mux.txt        |   60 +
>   Documentation/media/uapi/mediactl/media-types.rst  |   22 +
>   Documentation/media/v4l-drivers/imx.rst            |  590 ++++++
>   arch/arm/boot/dts/imx6dl-sabrelite.dts             |    5 +
>   arch/arm/boot/dts/imx6dl-sabresd.dts               |    5 +
>   arch/arm/boot/dts/imx6dl.dtsi                      |  189 ++
>   arch/arm/boot/dts/imx6q-sabrelite.dts              |    5 +
>   arch/arm/boot/dts/imx6q-sabresd.dts                |    5 +
>   arch/arm/boot/dts/imx6q.dtsi                       |  125 ++
>   arch/arm/boot/dts/imx6qdl-sabreauto.dtsi           |  144 +-
>   arch/arm/boot/dts/imx6qdl-sabrelite.dtsi           |  152 +-
>   arch/arm/boot/dts/imx6qdl-sabresd.dtsi             |  114 +-
>   arch/arm/boot/dts/imx6qdl.dtsi                     |   20 +-
>   arch/arm/configs/imx_v6_v7_defconfig               |   11 +
>   drivers/media/i2c/Kconfig                          |    9 +
>   drivers/media/i2c/Makefile                         |    1 +
>   drivers/media/i2c/ov5640.c                         | 2224 ++++++++++++++++++++
>   drivers/media/platform/Kconfig                     |    6 +
>   drivers/media/platform/Makefile                    |    2 +
>   drivers/media/platform/video-mux.c                 |  357 ++++
>   drivers/staging/media/Kconfig                      |    2 +
>   drivers/staging/media/Makefile                     |    1 +
>   drivers/staging/media/imx/Kconfig                  |   20 +
>   drivers/staging/media/imx/Makefile                 |   12 +
>   drivers/staging/media/imx/TODO                     |   15 +
>   drivers/staging/media/imx/imx-ic-common.c          |  113 +
>   drivers/staging/media/imx/imx-ic-prp.c             |  514 +++++
>   drivers/staging/media/imx/imx-ic-prpencvf.c        | 1309 ++++++++++++
>   drivers/staging/media/imx/imx-ic.h                 |   38 +
>   drivers/staging/media/imx/imx-media-capture.c      |  775 +++++++
>   drivers/staging/media/imx/imx-media-csi.c          | 1842 ++++++++++++++++
>   drivers/staging/media/imx/imx-media-dev.c          |  665 ++++++
>   drivers/staging/media/imx/imx-media-fim.c          |  463 ++++
>   drivers/staging/media/imx/imx-media-internal-sd.c  |  349 +++
>   drivers/staging/media/imx/imx-media-of.c           |  268 +++
>   drivers/staging/media/imx/imx-media-utils.c        |  896 ++++++++
>   drivers/staging/media/imx/imx-media-vdic.c         | 1009 +++++++++
>   drivers/staging/media/imx/imx-media.h              |  326 +++
>   drivers/staging/media/imx/imx6-mipi-csi2.c         |  697 ++++++
>   include/linux/imx-media.h                          |   27 +
>   include/media/imx.h                                |   15 +
>   include/uapi/linux/media.h                         |    6 +
>   include/uapi/linux/v4l2-controls.h                 |    4 +
>   45 files changed, 13504 insertions(+), 27 deletions(-)
>   create mode 100644 Documentation/devicetree/bindings/media/i2c/ov5640.txt
>   create mode 100644 Documentation/devicetree/bindings/media/imx.txt
>   create mode 100644 Documentation/devicetree/bindings/media/video-mux.txt
>   create mode 100644 Documentation/media/v4l-drivers/imx.rst
>   create mode 100644 drivers/media/i2c/ov5640.c
>   create mode 100644 drivers/media/platform/video-mux.c
>   create mode 100644 drivers/staging/media/imx/Kconfig
>   create mode 100644 drivers/staging/media/imx/Makefile
>   create mode 100644 drivers/staging/media/imx/TODO
>   create mode 100644 drivers/staging/media/imx/imx-ic-common.c
>   create mode 100644 drivers/staging/media/imx/imx-ic-prp.c
>   create mode 100644 drivers/staging/media/imx/imx-ic-prpencvf.c
>   create mode 100644 drivers/staging/media/imx/imx-ic.h
>   create mode 100644 drivers/staging/media/imx/imx-media-capture.c
>   create mode 100644 drivers/staging/media/imx/imx-media-csi.c
>   create mode 100644 drivers/staging/media/imx/imx-media-dev.c
>   create mode 100644 drivers/staging/media/imx/imx-media-fim.c
>   create mode 100644 drivers/staging/media/imx/imx-media-internal-sd.c
>   create mode 100644 drivers/staging/media/imx/imx-media-of.c
>   create mode 100644 drivers/staging/media/imx/imx-media-utils.c
>   create mode 100644 drivers/staging/media/imx/imx-media-vdic.c
>   create mode 100644 drivers/staging/media/imx/imx-media.h
>   create mode 100644 drivers/staging/media/imx/imx6-mipi-csi2.c
>   create mode 100644 include/linux/imx-media.h
>   create mode 100644 include/media/imx.h
> 
