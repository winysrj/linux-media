Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:39595 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726422AbeIEOa2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Sep 2018 10:30:28 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Jacopo Mondi <jacopo@jmondi.org>,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de
Subject: [PATCH v2 0/4] i.MX PXP scaler/CSC driver
Date: Wed,  5 Sep 2018 12:00:14 +0200
Message-Id: <20180905100018.27556-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Pixel Pipeline (PXP) is a memory-to-memory graphics processing
engine that supports scaling, colorspace conversion, alpha blending,
rotation, and pixel conversion via lookup table. Different versions are
present on various i.MX SoCs from i.MX23 to i.MX7. The latest versions
on i.MX6ULL and i.MX7D have grown an additional pipeline for dithering
and e-ink update processing that is ignored by this driver.

This series adds a V4L2 mem-to-mem scaler/CSC driver for the PXP version
found on i.MX6ULL SoCs which is a size reduced variant of the i.MX7 PXP.
The driver uses only the legacy pipeline, so it should be reasonably
easy to extend it to work with the older PXP versions found on i.MX6UL,
i.MX6SX, i.MX6SL, i.MX28, and i.MX23. The driver supports scaling and
colorspace conversion. There is currently no support for rotation,
alpha-blending, and the LUTs.

Changes since v1:
- fix node address order in imx6ul.dtsi
- add Rec.709, BT.2020, and SMPTE 240m YCbCr encoding coefficients,
  list quantization errors in comments
- split ycbcr_enc and quantization into per-queue configuration,
  use default encoding and quantization on capture queue
- replace strncpy with strlcpy
- use struct video_device .device_caps
- remove buffer count reduction, reqbufs will just -ENOMEM if there's not
  enough memory
- register video device after m2m init
- disable clocks on failed probe
- remove superfluous whitespace
- fix YUV32 depth
- rename vidioc_* functions to pxp_*
- keep default colorimetry when set
- force ycbcr_enc and quantization to be equal for CSC bypass (RGB<->RGB
  and YUV<->YUV conversions)

regards
Philipp

Philipp Zabel (4):
  dt-bindings: media: Add i.MX Pixel Pipeline binding
  ARM: dts: imx6ull: add pxp support
  media: imx-pxp: add i.MX Pixel Pipeline driver
  MAINTAINERS: add entry for i.MX PXP media mem2mem driver

 .../devicetree/bindings/media/fsl-pxp.txt     |   26 +
 MAINTAINERS                                   |    7 +
 arch/arm/boot/dts/imx6ul.dtsi                 |    8 +
 arch/arm/boot/dts/imx6ull.dtsi                |    6 +
 drivers/media/platform/Kconfig                |    9 +
 drivers/media/platform/Makefile               |    2 +
 drivers/media/platform/imx-pxp.c              | 1774 +++++++++++++++++
 drivers/media/platform/imx-pxp.h              | 1685 ++++++++++++++++
 8 files changed, 3517 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/fsl-pxp.txt
 create mode 100644 drivers/media/platform/imx-pxp.c
 create mode 100644 drivers/media/platform/imx-pxp.h

-- 
2.18.0
