Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:41082 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934822AbeFRPAM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Jun 2018 11:00:12 -0400
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Marco Franchi <marco.franchi@nxp.com>,
        Icenowy Zheng <icenowy@aosc.io>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tom Saeger <tom.saeger@oracle.com>,
        Smitha T Murthy <smitha.t@samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "David S . Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Jacob Chen <jacob-chen@iotwrt.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Todor Tomov <todor.tomov@linaro.org>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-sunxi@googlegroups.com,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Randy Li <ayaka@soulik.info>
Subject: [PATCH v4 00/19] Sunxi-Cedrus driver for the Allwinner Video Engine, using media requests
Date: Mon, 18 Jun 2018 16:58:24 +0200
Message-Id: <20180618145843.14631-1-paul.kocialkowski@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is the fourth iteration of the updated Sunxi-Cedrus driver,
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

Remaining tasks:
* verifying that the defined PCT types apply as-is to all MPEG formats;
* cleaning up register descriptions and documenting the fields used;
* testing on more platforms.

Changes since v3:
* updated to version 15 of the media request API;
* got rid of untested MPEG1 support;
* added definitons for picture coding types;
* added documentation about MPEG2 slice header fields;
* added documentation about MPEG2 slice format;
* added documentation about the MB32 NV12 format;
* added MPEG2 slice header validation;
* removed the assigned-clocks property;
* reworked and fixed error paths;
* harmonized debug prints, with v4l2 helpers when applicable;
* checked the series through checkpatch;
* switched to SPDX license headers;
* renamed MPEG2 frame header to slice header for consistency and clarity;
* removed A20 SRAM compatible from the driver's list.

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

Cheers!

[0]: https://patchwork.kernel.org/patch/9299073/
[1]: https://git.linuxtv.org/hverkuil/media_tree.git/log/?h=reqv15

Maxime Ripard (4):
  drivers: soc: sunxi: Add support for the C1 SRAM region
  ARM: sun5i: Add support for the C1 SRAM region with the SRAM
    controller
  ARM: sun7i-a20: Add support for the C1 SRAM region with the SRAM
    controller
  ARM: sun8i-a33: Add SRAM controller node and C1 SRAM region

Paul Kocialkowski (15):
  dt-bindings: sram: sunxi: Add A13, A20 and A33 SRAM controller
    bindings
  dt-bindings: sram: sunxi: Add A10 binding for the C1 SRAM region
  dt-bindings: sram: sunxi: Add A13 binding for the C1 SRAM region
  dt-bindings: sram: sunxi: Add A20 binding for the C1 SRAM region
  dt-bindings: sram: sunxi: Add A33 binding for the C1 SRAM region
  drivers: soc: sunxi: Add dedicated compatibles for the A13 and A33
  ARM: dts: sun5i: Use dedicated SRAM controller compatible
  ARM: dts: sun7i-a20: Also use dedicated SRAM controller compatible
  media: v4l: Add definitions for MPEG2 slice format and header metadata
  media: v4l: Add definition for Allwinner's MB32-tiled NV12 format
  dt-bindings: media: Document bindings for the Sunxi-Cedrus VPU driver
  media: platform: Add Sunxi-Cedrus VPU decoder driver
  ARM: dts: sun5i: Add Video Engine and reserved memory nodes
  ARM: dts: sun7i-a20: Add Video Engine and reserved memory nodes
  ARM: dts: sun8i-a33: Add Video Engine and reserved memory nodes

 .../bindings/media/sunxi-cedrus.txt           |  53 ++
 .../devicetree/bindings/sram/sunxi-sram.txt   |  13 +
 .../media/uapi/v4l/extended-controls.rst      |  73 +++
 .../media/uapi/v4l/pixfmt-compressed.rst      |   5 +
 .../media/uapi/v4l/pixfmt-reserved.rst        |  15 +-
 MAINTAINERS                                   |   7 +
 arch/arm/boot/dts/sun5i.dtsi                  |  44 +-
 arch/arm/boot/dts/sun7i-a20.dtsi              |  45 +-
 arch/arm/boot/dts/sun8i-a33.dtsi              |  51 ++
 drivers/media/platform/Kconfig                |   2 +
 drivers/media/platform/Makefile               |   1 +
 drivers/media/platform/sunxi/Kconfig          |  15 +
 drivers/media/platform/sunxi/Makefile         |   1 +
 drivers/media/platform/sunxi/cedrus/Kconfig   |  13 +
 drivers/media/platform/sunxi/cedrus/Makefile  |   3 +
 drivers/media/platform/sunxi/cedrus/cedrus.c  | 327 ++++++++++++
 drivers/media/platform/sunxi/cedrus/cedrus.h  | 117 ++++
 .../media/platform/sunxi/cedrus/cedrus_dec.c  | 170 ++++++
 .../media/platform/sunxi/cedrus/cedrus_dec.h  |  27 +
 .../media/platform/sunxi/cedrus/cedrus_hw.c   | 262 +++++++++
 .../media/platform/sunxi/cedrus/cedrus_hw.h   |  30 ++
 .../platform/sunxi/cedrus/cedrus_mpeg2.c      | 146 +++++
 .../platform/sunxi/cedrus/cedrus_mpeg2.h      |  24 +
 .../media/platform/sunxi/cedrus/cedrus_regs.h | 167 ++++++
 .../platform/sunxi/cedrus/cedrus_video.c      | 502 ++++++++++++++++++
 .../platform/sunxi/cedrus/cedrus_video.h      |  23 +
 drivers/media/v4l2-core/v4l2-ctrls.c          |  44 ++
 drivers/media/v4l2-core/v4l2-ioctl.c          |   2 +
 drivers/soc/sunxi/sunxi_sram.c                |  12 +
 include/uapi/linux/v4l2-controls.h            |  30 ++
 include/uapi/linux/videodev2.h                |   4 +
 31 files changed, 2225 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/sunxi-cedrus.txt
 create mode 100644 drivers/media/platform/sunxi/Kconfig
 create mode 100644 drivers/media/platform/sunxi/Makefile
 create mode 100644 drivers/media/platform/sunxi/cedrus/Kconfig
 create mode 100644 drivers/media/platform/sunxi/cedrus/Makefile
 create mode 100644 drivers/media/platform/sunxi/cedrus/cedrus.c
 create mode 100644 drivers/media/platform/sunxi/cedrus/cedrus.h
 create mode 100644 drivers/media/platform/sunxi/cedrus/cedrus_dec.c
 create mode 100644 drivers/media/platform/sunxi/cedrus/cedrus_dec.h
 create mode 100644 drivers/media/platform/sunxi/cedrus/cedrus_hw.c
 create mode 100644 drivers/media/platform/sunxi/cedrus/cedrus_hw.h
 create mode 100644 drivers/media/platform/sunxi/cedrus/cedrus_mpeg2.c
 create mode 100644 drivers/media/platform/sunxi/cedrus/cedrus_mpeg2.h
 create mode 100644 drivers/media/platform/sunxi/cedrus/cedrus_regs.h
 create mode 100644 drivers/media/platform/sunxi/cedrus/cedrus_video.c
 create mode 100644 drivers/media/platform/sunxi/cedrus/cedrus_video.h

-- 
2.17.0
