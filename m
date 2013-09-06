Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:40368 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919Ab3IFKNj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Sep 2013 06:13:39 -0400
From: Archit Taneja <archit@ti.com>
To: <linux-media@vger.kernel.org>, <hverkuil@xs4all.nl>,
	<laurent.pinchart@ideasonboard.com>
CC: <linux-omap@vger.kernel.org>, <tomi.valkeinen@ti.com>,
	Archit Taneja <archit@ti.com>
Subject: [PATCH v4 0/4] v4l: VPE mem to mem driver
Date: Fri, 6 Sep 2013 15:42:22 +0530
Message-ID: <1378462346-10880-1-git-send-email-archit@ti.com>
In-Reply-To: <1376996457-17275-1-git-send-email-archit@ti.com>
References: <1376996457-17275-1-git-send-email-archit@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

VPE(Video Processing Engine) is an IP found on DRA7xx, this series adds VPE as a
mem to mem v4l2 driver, and VPDMA as a helper library.

The first version of the patch series described VPE in detail, you can have a
look at it here:

http://www.spinics.net/lists/linux-media/msg66518.html

Changes in v4:
- Control ID for the driver reserved in v4l2-controls.h
- Some fixes/clean ups suggested by Hans.
- A small hack done in VPE's probe to use a fixed 64K resource size, this
  is needed as the DT bindings will split the addresses accross VPE
  submodules, the driver currently works with register offsets from the top
  level VPE base. The driver can be modified later to support multiple
  ioremaps of the sub modules.
- Addition of sync on channel descriptors for input DMA channels, this
  ensures the VPDMA list is stalled in the rare case of an input channel's
  DMA getting completed after all the output channel DMAs.
- Removed the DT and hwmod patches from this series. DRA7xx support is not
  yet got in the 3.12 merge window. Will deal with those separately.

Archit Taneja (4):
  v4l: ti-vpe: Create a vpdma helper library
  v4l: ti-vpe: Add helpers for creating VPDMA descriptors
  v4l: ti-vpe: Add VPE mem to mem driver
  v4l: ti-vpe: Add de-interlacer support in VPE

 drivers/media/platform/Kconfig             |   16 +
 drivers/media/platform/Makefile            |    2 +
 drivers/media/platform/ti-vpe/Makefile     |    5 +
 drivers/media/platform/ti-vpe/vpdma.c      |  846 ++++++++++++
 drivers/media/platform/ti-vpe/vpdma.h      |  203 +++
 drivers/media/platform/ti-vpe/vpdma_priv.h |  641 +++++++++
 drivers/media/platform/ti-vpe/vpe.c        | 2074 ++++++++++++++++++++++++++++
 drivers/media/platform/ti-vpe/vpe_regs.h   |  496 +++++++
 include/uapi/linux/v4l2-controls.h         |    4 +
 9 files changed, 4287 insertions(+)
 create mode 100644 drivers/media/platform/ti-vpe/Makefile
 create mode 100644 drivers/media/platform/ti-vpe/vpdma.c
 create mode 100644 drivers/media/platform/ti-vpe/vpdma.h
 create mode 100644 drivers/media/platform/ti-vpe/vpdma_priv.h
 create mode 100644 drivers/media/platform/ti-vpe/vpe.c
 create mode 100644 drivers/media/platform/ti-vpe/vpe_regs.h

-- 
1.8.1.2

