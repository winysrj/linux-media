Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:37990 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822Ab3HTLCP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Aug 2013 07:02:15 -0400
From: Archit Taneja <archit@ti.com>
To: <linux-media@vger.kernel.org>, <hverkuil@xs4all.nl>,
	<laurent.pinchart@ideasonboard.com>, <tomi.valkeinen@ti.com>
CC: <linux-omap@vger.kernel.org>, Archit Taneja <archit@ti.com>
Subject: [PATCH v2 0/6] v4l: VPE mem to mem driver
Date: Tue, 20 Aug 2013 16:30:51 +0530
Message-ID: <1376996457-17275-1-git-send-email-archit@ti.com>
In-Reply-To: <1375452223-30524-1-git-send-email-archit@ti.com>
References: <1375452223-30524-1-git-send-email-archit@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

VPE(Video Processing Engine) is an IP found on DRA7xx, this series adds VPE as a
mem to mem v4l2 driver, and VPDMA as a helper library.

The previous revision of the series described VPE in detail, you can have a look
at it here:

http://www.spinics.net/lists/linux-media/msg66518.html

There were a lot of useful suggestions made by Hans, Tomi and Laurent. This
series incorporate these changes. There are few comments which I haven't been
able to address, I've pointed those below too.

Changes in v2:
- Constify the structs that can be constified.
- Remove the use of wmb() from vpdma_submit_descs().
- Remove an unnecessary layer of helper macros used for creating or reading
  VPDMA descriptors.
- Create a CONFIG which enables/disables VPE debug prints.
- Remove CAPTURE/OUTPUT_MPLANE from device_caps.
- Fix the pix->field setting in TRY_FMT ioctl.
- Fix a bug in the v4l2 control handler registration and release.
- Move video_register_device() at the end of driver probe.
- Improve some of the function names, remove unnecessary BUG_ONs etc, use
  ERR_PTR() to return error codes correctly.

Things still open in v2:
- Tomi had a comment about the usage msleep_interruptible in the first patch. I
  am not clear whether this is actually a problem and what's the right approach.
- Laurent suggested using DMA allocation API for the VPDMA library, we currently
  use kzalloc to allocate and dma_map/unmap_single api to map to VPDMA/CPU. DMA
  pool api won't be a good replacement here.
- There was a suggestion to use synchronous firmware interface. If I understand
  right, synchronous interfaces forces us to have the firmware appended to the
  kernel, that's not something we want.


Archit Taneja (6):
  v4l: ti-vpe: Create a vpdma helper library
  v4l: ti-vpe: Add helpers for creating VPDMA descriptors
  v4l: ti-vpe: Add VPE mem to mem driver
  v4l: ti-vpe: Add de-interlacer support in VPE
  arm: dra7xx: hwmod data: add VPE hwmod data and ocp_if info
  experimental: arm: dts: dra7xx: Add a DT node for VPE

 arch/arm/boot/dts/dra7.dtsi                |   11 +
 arch/arm/mach-omap2/omap_hwmod_7xx_data.c  |   42 +
 drivers/media/platform/Kconfig             |   16 +
 drivers/media/platform/Makefile            |    2 +
 drivers/media/platform/ti-vpe/Makefile     |    5 +
 drivers/media/platform/ti-vpe/vpdma.c      |  846 ++++++++++++
 drivers/media/platform/ti-vpe/vpdma.h      |  202 +++
 drivers/media/platform/ti-vpe/vpdma_priv.h |  640 +++++++++
 drivers/media/platform/ti-vpe/vpe.c        | 2042 ++++++++++++++++++++++++++++
 drivers/media/platform/ti-vpe/vpe_regs.h   |  496 +++++++
 10 files changed, 4302 insertions(+)
 create mode 100644 drivers/media/platform/ti-vpe/Makefile
 create mode 100644 drivers/media/platform/ti-vpe/vpdma.c
 create mode 100644 drivers/media/platform/ti-vpe/vpdma.h
 create mode 100644 drivers/media/platform/ti-vpe/vpdma_priv.h
 create mode 100644 drivers/media/platform/ti-vpe/vpe.c
 create mode 100644 drivers/media/platform/ti-vpe/vpe_regs.h

-- 
1.8.1.2

