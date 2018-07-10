Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:52640 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751230AbeGJICC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Jul 2018 04:02:02 -0400
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
        Keiichi Watanabe <keiichiw@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Smitha T Murthy <smitha.t@samsung.com>,
        Tom Saeger <tom.saeger@oracle.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Jacob Chen <jacob-chen@iotwrt.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Benoit Parrot <bparrot@ti.com>,
        Todor Tomov <todor.tomov@linaro.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Pawel Osciak <posciak@chromium.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        linux-sunxi@googlegroups.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Randy Li <ayaka@soulik.info>
Subject: [PATCH v5 00/22] Sunxi-Cedrus driver for the Allwinner Video Engine, using media requests
Date: Tue, 10 Jul 2018 10:00:52 +0200
Message-Id: <20180710080114.31469-1-paul.kocialkowski@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is the fifth iteration of the updated Sunxi-Cedrus driver,
that supports the Video Engine found in most Allwinner SoCs, starting
with the A10. It was tested on the A13, A20, A33 and H3.

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

In addition to the media requests API, the following series is required for
Sunxi-Cedrus:
* allwinner: a64: add SRAM controller / system control

Changes since v4:
* updated to version 16 of the media requests API;
* added support for VPU-based untiling (starting with the A33);
* added support for the H3, with SRAM support;
* reworked SRAM support and associated compatibles;
* improved failure paths;
* added some MPEG2 input data validation;
* reworked video/format functions to handle multiple formats;
* removed in-driver buffer queues;
* used a threaded irq instead of a workqueue;
* merged various improvements and cleanups from Maxime;
* renamed MPEG2_SLICE_HEADER to MPEG2_SLICE_PARAMS;
* added prefixes to MPEG2 picture coding types;
* used single-buffer allocations to ensure contiguous planes

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
[1]: https://git.linuxtv.org/hverkuil/media_tree.git/log/?h=reqv16

Hans Verkuil (1):
  v4l2-ctrls: add v4l2_ctrl_request_hdl_find/put/ctrl_find functions

Maxime Ripard (4):
  drivers: soc: sunxi: Add support for the C1 SRAM region
  ARM: sun5i: Add support for the C1 SRAM region with the SRAM
    controller
  ARM: sun7i-a20: Add support for the C1 SRAM region with the SRAM
    controller
  ARM: sun8i-a23-a33: Add SRAM controller node and C1 SRAM region

Paul Kocialkowski (17):
  fixup! v4l2-ctrls: add v4l2_ctrl_request_hdl_find/put/ctrl_find
    functions
  dt-bindings: sram: sunxi: Introduce new A10 binding for system-control
  dt-bindings: sram: sunxi: Add A13, A20, A23 and H3 dedicated bindings
  dt-bindings: sram: sunxi: Populate valid sections compatibles
  soc: sunxi: sram: Add dt match for the A10 system-control compatible
  ARM: dts: sun4i-a10: Use system-control compatible
  ARM: dts: sun5i: Use most-qualified system control compatibles
  ARM: dts: sun7i-a20: Use most-qualified system control compatibles
  ARM: sun8i-h3: Add SRAM controller node and C1 SRAM region
  media: v4l: Add definitions for MPEG2 slice format and header metadata
  media: v4l: Add definition for Allwinner's MB32-tiled NV12 format
  dt-bindings: media: Document bindings for the Sunxi-Cedrus VPU driver
  media: platform: Add Sunxi-Cedrus VPU decoder driver
  ARM: dts: sun5i: Add Video Engine and reserved memory nodes
  ARM: dts: sun7i-a20: Add Video Engine and reserved memory nodes
  ARM: dts: sun8i-a33: Add Video Engine and reserved memory nodes
  ARM: dts: sun8i-h3: Add Video Engine and reserved memory nodes

 .../bindings/media/sunxi-cedrus.txt           |  54 ++
 .../devicetree/bindings/sram/sunxi-sram.txt   |  36 +-
 .../media/uapi/v4l/extended-controls.rst      |  74 +++
 .../media/uapi/v4l/pixfmt-compressed.rst      |   5 +
 .../media/uapi/v4l/pixfmt-reserved.rst        |  15 +-
 MAINTAINERS                                   |   7 +
 arch/arm/boot/dts/sun4i-a10.dtsi              |   4 +-
 arch/arm/boot/dts/sun5i.dtsi                  |  53 +-
 arch/arm/boot/dts/sun7i-a20.dtsi              |  53 +-
 arch/arm/boot/dts/sun8i-a23-a33.dtsi          |  23 +
 arch/arm/boot/dts/sun8i-a33.dtsi              |  29 +
 arch/arm/boot/dts/sun8i-h3.dtsi               |  50 ++
 drivers/media/platform/Kconfig                |   2 +
 drivers/media/platform/Makefile               |   1 +
 drivers/media/platform/sunxi/Kconfig          |  15 +
 drivers/media/platform/sunxi/Makefile         |   1 +
 drivers/media/platform/sunxi/cedrus/Kconfig   |  13 +
 drivers/media/platform/sunxi/cedrus/Makefile  |   3 +
 drivers/media/platform/sunxi/cedrus/cedrus.c  | 374 ++++++++++++
 drivers/media/platform/sunxi/cedrus/cedrus.h  | 161 +++++
 .../media/platform/sunxi/cedrus/cedrus_dec.c  | 129 ++++
 .../media/platform/sunxi/cedrus/cedrus_dec.h  |  27 +
 .../media/platform/sunxi/cedrus/cedrus_hw.c   | 325 ++++++++++
 .../media/platform/sunxi/cedrus/cedrus_hw.h   |  29 +
 .../platform/sunxi/cedrus/cedrus_mpeg2.c      | 178 ++++++
 .../media/platform/sunxi/cedrus/cedrus_regs.h | 195 ++++++
 .../platform/sunxi/cedrus/cedrus_video.c      | 556 ++++++++++++++++++
 .../platform/sunxi/cedrus/cedrus_video.h      |  31 +
 drivers/media/v4l2-core/v4l2-ctrls.c          |  69 +++
 drivers/media/v4l2-core/v4l2-ioctl.c          |   2 +
 drivers/soc/sunxi/sunxi_sram.c                |  14 +
 include/media/v4l2-ctrls.h                    |  60 +-
 include/uapi/linux/v4l2-controls.h            |  30 +
 include/uapi/linux/videodev2.h                |   4 +
 34 files changed, 2600 insertions(+), 22 deletions(-)
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
 create mode 100644 drivers/media/platform/sunxi/cedrus/cedrus_regs.h
 create mode 100644 drivers/media/platform/sunxi/cedrus/cedrus_video.c
 create mode 100644 drivers/media/platform/sunxi/cedrus/cedrus_video.h

-- 
2.17.1
