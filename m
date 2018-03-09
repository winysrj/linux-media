Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:49646 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750920AbeCIKKl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Mar 2018 05:10:41 -0500
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Cc: Icenowy Zheng <icenowy@aosc.xyz>,
        Florent Revest <revestflo@gmail.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Thomas van Kleef <thomas@vitsch.nl>,
        "Signed-off-by : Bob Ham" <rah@settrans.net>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Subject: [PATCH 0/9] Sunxi-Cedrus driver for the Allwinner Video Engine, using the V4L2 request API
Date: Fri,  9 Mar 2018 11:09:24 +0100
Message-Id: <20180309100933.15922-1-paul.kocialkowski@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This presents a newer version of the Sunxi-Cedrus driver, that supports
the Video Engine found in most Allwinner SoCs, starting with the A10.

The first version of this driver[0] was originally written and submitted
by Florent Revest using a previous version of the request API, that is
necessary to provide coherency between controls and the buffers they apply
to. The driver was since adapted to use the latest version of the request
API[1], as submitted by Alexandre Courbot. It is a hard requirement for
this driver.

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

[0]: https://lkml.org/lkml/2016/8/25/246
[1]: https://lkml.org/lkml/2018/2/19/872

Florent Revest (5):
  v4l: Add sunxi Video Engine pixel format
  v4l: Add MPEG2 low-level decoder API control
  media: platform: Add Sunxi Cedrus decoder driver
  sunxi-cedrus: Add device tree binding document
  ARM: dts: sun5i: Use video-engine node

Icenowy Zheng (1):
  ARM: dts: sun8i: add video engine support for A33

Paul Kocialkowski (2):
  media: vim2m: Try to schedule a m2m device run on request submission
  media: videobuf2-v4l2: Copy planes when needed in request qbuf

Thomas van Kleef (1):
  ARM: dts: sun7i: Add video engine support for the A20

 .../devicetree/bindings/media/sunxi-cedrus.txt     |  44 ++
 arch/arm/boot/dts/sun5i-a13.dtsi                   |  30 ++
 arch/arm/boot/dts/sun7i-a20.dtsi                   |  47 ++
 arch/arm/boot/dts/sun8i-a33.dtsi                   |  39 ++
 drivers/media/common/videobuf2/videobuf2-v4l2.c    |  19 +
 drivers/media/platform/Kconfig                     |  14 +
 drivers/media/platform/Makefile                    |   1 +
 drivers/media/platform/sunxi-cedrus/Makefile       |   4 +
 drivers/media/platform/sunxi-cedrus/sunxi_cedrus.c | 313 ++++++++++++
 .../platform/sunxi-cedrus/sunxi_cedrus_common.h    | 106 ++++
 .../media/platform/sunxi-cedrus/sunxi_cedrus_dec.c | 568 +++++++++++++++++++++
 .../media/platform/sunxi-cedrus/sunxi_cedrus_dec.h |  33 ++
 .../media/platform/sunxi-cedrus/sunxi_cedrus_hw.c  | 185 +++++++
 .../media/platform/sunxi-cedrus/sunxi_cedrus_hw.h  |  36 ++
 .../platform/sunxi-cedrus/sunxi_cedrus_mpeg2.c     | 152 ++++++
 .../platform/sunxi-cedrus/sunxi_cedrus_regs.h      | 170 ++++++
 drivers/media/platform/vim2m.c                     |  13 +-
 drivers/media/v4l2-core/v4l2-ctrls.c               |  15 +
 drivers/media/v4l2-core/v4l2-ioctl.c               |   1 +
 include/uapi/linux/v4l2-controls.h                 |  26 +
 include/uapi/linux/videodev2.h                     |   6 +
 21 files changed, 1821 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/media/sunxi-cedrus.txt
 create mode 100644 drivers/media/platform/sunxi-cedrus/Makefile
 create mode 100644 drivers/media/platform/sunxi-cedrus/sunxi_cedrus.c
 create mode 100644 drivers/media/platform/sunxi-cedrus/sunxi_cedrus_common.h
 create mode 100644 drivers/media/platform/sunxi-cedrus/sunxi_cedrus_dec.c
 create mode 100644 drivers/media/platform/sunxi-cedrus/sunxi_cedrus_dec.h
 create mode 100644 drivers/media/platform/sunxi-cedrus/sunxi_cedrus_hw.c
 create mode 100644 drivers/media/platform/sunxi-cedrus/sunxi_cedrus_hw.h
 create mode 100644 drivers/media/platform/sunxi-cedrus/sunxi_cedrus_mpeg2.c
 create mode 100644 drivers/media/platform/sunxi-cedrus/sunxi_cedrus_regs.h

-- 
2.16.2
