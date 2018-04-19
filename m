Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:42461 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752385AbeDSPnv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Apr 2018 11:43:51 -0400
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Alexandre Courbot <acourbot@chromium.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Subject: [PATCH v2 00/10] Sunxi-Cedrus driver for the Allwinner Video Engine, using media requests
Date: Thu, 19 Apr 2018 17:41:14 +0200
Message-Id: <20180419154124.17512-1-paul.kocialkowski@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This presents a second iteration of the updated Sunxi-Cedrus driver,
that supports the Video Engine found in most Allwinner SoCs, starting
with the A10. It was tested on both the A20 and the A33.

The initial version of this driver[0] was originally written and
submitted by Florent Revest using a previous version of the request API
that is necessary to provide coherency between controls and the buffers
they apply to.

The driver was adapted to use the latest version of the media request
API[1], as submitted by Hand Verkuil. Media request API support is a
hard requirement for the Sunxi-Cedrus driver.

This series also contains fixes for issues encountered with the current
version of the request API. If accepted, these should eventually be
squashed into the request API series.

The driver itself currently only supports MPEG2 and more codecs will be
added to the driver eventually. The output frames provided by the
Video Engine are in a multi-planar 32x32-tiled YUV format, with a plane
for luminance (Y) and a plane for chrominance (UV). A specific format is
introduced in the V4L2 API to describe it.

This implementation is based on the significant work that was conducted
by various members of the linux-sunxi community for understanding and
documenting the Video Engine's innards.

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
* using the dedicated SRAM controller driver;
* cleaning up registers description and documenting the fields used;
* removing the assigned-clocks property and setting the clock rate
  in the driver directly;
* testing on more platforms.

Cheers!

Paul Kocialkowski (10):
  media: v4l2-ctrls: Add missing v4l2 ctrl unlock
  media-request: Add a request complete operation to allow m2m
    scheduling
  videobuf2-core: Add helper to get buffer private data from media
    request
  media: vim2m: Implement media request complete op to schedule m2m run
  media: v4l: Add definitions for MPEG2 frame format and header metadata
  media: v4l: Add definition for Allwinner's MB32-tiled NV12 format
  media: platform: Add Sunxi-Cedrus VPU decoder driver
  dt-bindings: media: Document bindings for the Sunxi-Cedrus VPU driver
  ARM: dts: sun7i-a20: Add Video Engine and reserved memory nodes
  ARM: dts: sun8i-a33: Add Video Engine and reserved memory nodes

 .../devicetree/bindings/media/sunxi-cedrus.txt     |  50 +++
 arch/arm/boot/dts/sun7i-a20.dtsi                   |  31 ++
 arch/arm/boot/dts/sun8i-a33.dtsi                   |  38 ++
 drivers/media/common/videobuf2/videobuf2-core.c    |  15 +
 drivers/media/media-request.c                      |   3 +
 drivers/media/platform/Kconfig                     |  15 +
 drivers/media/platform/Makefile                    |   1 +
 drivers/media/platform/sunxi/cedrus/Makefile       |   4 +
 drivers/media/platform/sunxi/cedrus/sunxi_cedrus.c | 292 ++++++++++++
 .../platform/sunxi/cedrus/sunxi_cedrus_common.h    | 105 +++++
 .../media/platform/sunxi/cedrus/sunxi_cedrus_dec.c | 228 ++++++++++
 .../media/platform/sunxi/cedrus/sunxi_cedrus_dec.h |  36 ++
 .../media/platform/sunxi/cedrus/sunxi_cedrus_hw.c  | 201 +++++++++
 .../media/platform/sunxi/cedrus/sunxi_cedrus_hw.h  |  29 ++
 .../platform/sunxi/cedrus/sunxi_cedrus_mpeg2.c     | 157 +++++++
 .../platform/sunxi/cedrus/sunxi_cedrus_mpeg2.h     |  33 ++
 .../platform/sunxi/cedrus/sunxi_cedrus_regs.h      | 172 +++++++
 .../platform/sunxi/cedrus/sunxi_cedrus_video.c     | 497 +++++++++++++++++++++
 .../platform/sunxi/cedrus/sunxi_cedrus_video.h     |  31 ++
 drivers/media/platform/vim2m.c                     |  12 +
 drivers/media/v4l2-core/v4l2-ctrls.c               |  17 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               |   1 +
 include/media/media-device.h                       |   2 +
 include/media/videobuf2-core.h                     |   1 +
 include/uapi/linux/v4l2-controls.h                 |  26 ++
 include/uapi/linux/videodev2.h                     |   4 +
 26 files changed, 2000 insertions(+), 1 deletion(-)
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
