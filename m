Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f52.google.com ([209.85.160.52]:61208 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757489AbaFZBHP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jun 2014 21:07:15 -0400
Received: by mail-pb0-f52.google.com with SMTP id rq2so2401359pbb.39
        for <linux-media@vger.kernel.org>; Wed, 25 Jun 2014 18:07:14 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 00/28] IPUv3 prep for video capture
Date: Wed, 25 Jun 2014 18:05:27 -0700
Message-Id: <1403744755-24944-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philip, Sascha,

Here is a rebased set of IPU patches that prepares for video capture
support. Video capture is not included in this set. I've addressed
all your IPU-specific concerns from the previous patch set, the
major ones being:

- the IOMUXC control for CSI input selection has been removed. This
  should be part of a future CSI media entity driver.

- the ipu-irt unit has been removed. Enabling the IRT module is
  folded into ipu-ic unit. The ipu-ic unit is also cleaned up a bit.

- the ipu-csi APIs are consolidated/simplified.

- added CSI and IC base offsets for i.MX51/i.MX53.


Steve Longerbeam (28):
  ARM: dts: imx6qdl: Add ipu aliases
  gpu: ipu-v3: Add ipu_get_num()
  gpu: ipu-v3: Add functions to set CSI/IC source muxes
  gpu: ipu-v3: Rename and add IDMAC channels
  gpu: ipu-v3: Add units required for video capture
  gpu: ipu-v3: smfc: Move enable/disable to ipu-smfc.c
  gpu: ipu-v3: smfc: Convert to per-channel
  gpu: ipu-v3: smfc: Add ipu_smfc_set_watermark()
  gpu: ipu-v3: Add ipu_mbus_code_to_colorspace()
  gpu: ipu-v3: Add rotation mode conversion utilities
  gpu: ipu-v3: Add helper function checking if pixfmt is planar
  gpu: ipu-v3: Move IDMAC channel names to imx-ipu-v3.h
  gpu: ipu-v3: Add ipu_idmac_buffer_is_ready()
  gpu: ipu-v3: Add ipu_idmac_clear_buffer()
  gpu: ipu-v3: Add __ipu_idmac_reset_current_buffer()
  gpu: ipu-v3: Add ipu_stride_to_bytes()
  gpu: ipu-v3: Add ipu_idmac_enable_watermark()
  gpu: ipu-v3: Add ipu_idmac_lock_enable()
  gpu: ipu-v3: Add idmac channel linking support
  gpu: ipu-v3: Add ipu-cpmem unit
  staging: imx-drm: Convert to new ipu_cpmem API
  gpu: ipu-cpmem: Add ipu_cpmem_set_block_mode()
  gpu: ipu-cpmem: Add ipu_cpmem_set_axi_id()
  gpu: ipu-cpmem: Add ipu_cpmem_set_rotation()
  gpu: ipu-cpmem: Add second buffer support to ipu_cpmem_set_image()
  gpu: ipu-v3: Add more planar formats support
  gpu: ipu-cpmem: Add ipu_cpmem_dump()
  gpu: ipu-v3: Add ipu_dump()

 arch/arm/boot/dts/imx6q.dtsi          |    1 +
 arch/arm/boot/dts/imx6qdl.dtsi        |    1 +
 drivers/gpu/ipu-v3/Makefile           |    3 +-
 drivers/gpu/ipu-v3/ipu-common.c       | 1077 +++++++++++++++++++--------------
 drivers/gpu/ipu-v3/ipu-cpmem.c        |  817 +++++++++++++++++++++++++
 drivers/gpu/ipu-v3/ipu-csi.c          |  701 +++++++++++++++++++++
 drivers/gpu/ipu-v3/ipu-ic.c           |  812 +++++++++++++++++++++++++
 drivers/gpu/ipu-v3/ipu-prv.h          |  103 +++-
 drivers/gpu/ipu-v3/ipu-smfc.c         |  156 ++++-
 drivers/staging/imx-drm/ipuv3-plane.c |   16 +-
 include/video/imx-ipu-v3.h            |  371 +++++++-----
 11 files changed, 3389 insertions(+), 669 deletions(-)
 create mode 100644 drivers/gpu/ipu-v3/ipu-cpmem.c
 create mode 100644 drivers/gpu/ipu-v3/ipu-csi.c
 create mode 100644 drivers/gpu/ipu-v3/ipu-ic.c

-- 
1.7.9.5

