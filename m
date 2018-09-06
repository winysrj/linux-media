Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:59109 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727629AbeIFNgq (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Sep 2018 09:36:46 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Jacopo Mondi <jacopo@jmondi.org>,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de
Subject: [PATCH v3 0/4] i.MX PXP scaler/CSC driver
Date: Thu,  6 Sep 2018 11:02:11 +0200
Message-Id: <20180906090215.15719-1-p.zabel@pengutronix.de>
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

Changes since v2:
 - fix Kconfig whitespace
 - remove unused defines
 - fix video_unregister_device/v4l2_m2m_release order in pxp_remove
 - use GPL-2.0+ instead of GPL-2.0-or-later SPDX license identifer
 - remove pxp_default_ycbcr_enc/quantization, always map to default
   encoding/quantization
 - rename pxp_fixup_colorimetry to pxp_fixup_colorimetry_cap

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
 drivers/media/platform/imx-pxp.c              | 1752 +++++++++++++++++
 drivers/media/platform/imx-pxp.h              | 1685 ++++++++++++++++
 8 files changed, 3495 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/fsl-pxp.txt
 create mode 100644 drivers/media/platform/imx-pxp.c
 create mode 100644 drivers/media/platform/imx-pxp.h

-- 
2.18.0
