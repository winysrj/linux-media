Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:50712 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752309AbeEGMrb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 May 2018 08:47:31 -0400
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Yannick Fertre <yannick.fertre@st.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Florent Revest <florent.revest@free-electrons.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Smitha T Murthy <smitha.t@samsung.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Randy Li <ayaka@soulik.info>
Subject: [PATCH v3 00/14] Sunxi-Cedrus driver for the Allwinner Video Engine, using media requests
Date: Mon,  7 May 2018 14:44:46 +0200
Message-Id: <20180507124500.20434-1-paul.kocialkowski@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This presents a third iteration of the updated Sunxi-Cedrus driver,
that supports the Video Engine found in most Allwinner SoCs, starting
with the A10. It was tested on the A13, A20 and A33.

The initial version of this driver[0] was originally written and
submitted by Florent Revest using a previous version of the request API
that is necessary to provide coherency between controls and the buffers
they apply to.

The driver was adapted to use the latest version of the media request
API[1], as submitted by Hand Verkuil. Media request API support is a
hard requirement for the Sunxi-Cedrus driver.

The driver itself currently only supports MPEG2 and more codecs will be
added to the driver eventually. The output frames provided by the
Video Engine are in a multi-planar 32x32-tiled YUV format, with a plane
for luminance (Y) and a plane for chrominance (UV). A specific format is
introduced in the V4L2 API to describe it.

This implementation is based on the significant work that was conducted
by various members of the linux-sunxi community for understanding and
documenting the Video Engine's innards.

Changes since v2:
* updated to version 13 of the media request API;
* integrated various changes from Maxime Ripard;
* reworked memory reservation to use CMA, dynamic allocation and allow
  DMABUF;
* removed reserved memory binding since the CMA pool is the default one
  (and allow ENODEV in the driver, for that use case);
* added SRAM controller support for the SRAM region used by the VE;
* updated the device-tree bindings the for SRAM region;
* added per-platform bindings;
* added A13 support;
* renamed VE node name and label;
* fixed Florent's authorship for the MPEG2 headers;
* added a MAINTAINERS entry.

Changes since v1:
* use the latest version of the request API for Hans Verkuil;
* added media controller support and dependency
* renamed v4l2 format to the more explicit V4L2_PIX_FMT_MB32_NV12;
* reworked bindings documentation;
* moved driver to drivers/media/platforms/sunxi/cedrus to pair with
  incoming CSI support ;
* added a workqueue and lists to schedule buffer completion, since it
  cannot be done in interrupt context;
* split mpeg2 support into a setup and a trigger function to avoid race
  condition;
* split video-related ops to a dedicated sunxi_cedrus_video file;
* cleaned up the included headers for each file;
* used device PFN offset instead of subtracting PHYS_BASE;
* used reset_control_reset instead of assert+deassert;
* put the device in reset when removing driver;
* changed dt bindings to use the last 96 Mib of the first 256 MiB of
  DRAM;
* made it clear in the mpeg frame header structure that forward and
  backward indexes are used as reference frames for motion vectors;
* lots of small cosmetic and consistency changes, including naming
  harmonization and headers text rework.

Remaining tasks:
* cleaning up registers description and documenting the fields used;
* removing the assigned-clocks property and setting the clock rate
  in the driver directly;
* checking the series with checkpatch and fixing warnings;
* documenting the MB32 NV12 format and adding it to v4l_fill_fmtdesc;
* reworking and documenting the MPEG2 header, then adding it to
  v4l_fill_fmtdesc;
* checking and fixing the error paths;
* testing on more platforms.

Cheers!

[0]: https://patchwork.kernel.org/patch/9299073/
[1]: https://git.linuxtv.org/hverkuil/media_tree.git/log/?h=reqv13

Florent Revest (1):
  media: v4l: Add definitions for MPEG2 frame format and header metadata

Maxime Ripard (4):
  drivers: soc: sunxi: Add support for the C1 SRAM region
  ARM: sun5i: Add support for the C1 SRAM region with the SRAM
    controller
  ARM: sun7i-a20: Add support for the C1 SRAM region with the SRAM
    controller
  ARM: sun8i-a33: Add SRAM controller node and C1 SRAM region

Paul Kocialkowski (9):
  drivers: soc: sunxi: Add dedicated compatibles for the A13, A20 and
    A33
  ARM: dts: sun5i: Use dedicated SRAM controller compatible
  ARM: dts: sun7i-a20: Use dedicated SRAM controller compatible
  media: v4l: Add definition for Allwinner's MB32-tiled NV12 format
  dt-bindings: media: Document bindings for the Sunxi-Cedrus VPU driver
  media: platform: Add Sunxi-Cedrus VPU decoder driver
  ARM: dts: sun5i: Add Video Engine and reserved memory nodes
  ARM: dts: sun7i-a20: Add Video Engine and reserved memory nodes
  ARM: dts: sun8i-a33: Add Video Engine and reserved memory nodes

 .../devicetree/bindings/media/sunxi-cedrus.txt     |  58 +++
 MAINTAINERS                                        |   7 +
 arch/arm/boot/dts/sun5i.dtsi                       |  47 +-
 arch/arm/boot/dts/sun7i-a20.dtsi                   |  47 +-
 arch/arm/boot/dts/sun8i-a33.dtsi                   |  54 +++
 drivers/media/platform/Kconfig                     |  15 +
 drivers/media/platform/Makefile                    |   1 +
 drivers/media/platform/sunxi/cedrus/Makefile       |   4 +
 drivers/media/platform/sunxi/cedrus/sunxi_cedrus.c | 333 ++++++++++++++
 .../platform/sunxi/cedrus/sunxi_cedrus_common.h    | 128 ++++++
 .../media/platform/sunxi/cedrus/sunxi_cedrus_dec.c | 188 ++++++++
 .../media/platform/sunxi/cedrus/sunxi_cedrus_dec.h |  35 ++
 .../media/platform/sunxi/cedrus/sunxi_cedrus_hw.c  | 240 ++++++++++
 .../media/platform/sunxi/cedrus/sunxi_cedrus_hw.h  |  37 ++
 .../platform/sunxi/cedrus/sunxi_cedrus_mpeg2.c     | 160 +++++++
 .../platform/sunxi/cedrus/sunxi_cedrus_mpeg2.h     |  33 ++
 .../platform/sunxi/cedrus/sunxi_cedrus_regs.h      | 175 +++++++
 .../platform/sunxi/cedrus/sunxi_cedrus_video.c     | 505 +++++++++++++++++++++
 .../platform/sunxi/cedrus/sunxi_cedrus_video.h     |  31 ++
 drivers/media/v4l2-core/v4l2-ctrls.c               |  10 +
 drivers/media/v4l2-core/v4l2-ioctl.c               |   1 +
 drivers/soc/sunxi/sunxi_sram.c                     |  13 +
 include/uapi/linux/v4l2-controls.h                 |  26 ++
 include/uapi/linux/videodev2.h                     |   4 +
 24 files changed, 2150 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/sunxi-cedrus.txt
 create mode 100644 drivers/media/platform/sunxi/cedrus/Makefile
 create mode 100644 drivers/media/platform/sunxi/cedrus/sunxi_cedrus.c
 create mode 100644 drivers/media/platform/sunxi/cedrus/sunxi_cedrus_common.h
 create mode 100644 drivers/media/platform/sunxi/cedrus/sunxi_cedrus_dec.c
 create mode 100644 drivers/media/platform/sunxi/cedrus/sunxi_cedrus_dec.h
 create mode 100644 drivers/media/platform/sunxi/cedrus/sunxi_cedrus_hw.c
 create mode 100644 drivers/media/platform/sunxi/cedrus/sunxi_cedrus_hw.h
 create mode 100644 drivers/media/platform/sunxi/cedrus/sunxi_cedrus_mpeg2.c
 create mode 100644 drivers/media/platform/sunxi/cedrus/sunxi_cedrus_mpeg2.h
 create mode 100644 drivers/media/platform/sunxi/cedrus/sunxi_cedrus_regs.h
 create mode 100644 drivers/media/platform/sunxi/cedrus/sunxi_cedrus_video.c
 create mode 100644 drivers/media/platform/sunxi/cedrus/sunxi_cedrus_video.h

-- 
2.16.3
