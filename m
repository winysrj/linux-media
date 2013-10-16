Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:55399 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992Ab3JPFht (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Oct 2013 01:37:49 -0400
From: Archit Taneja <archit@ti.com>
To: <k.debski@samsung.com>
CC: <hverkuil@xs4all.nl>, <linux-media@vger.kernel.org>,
	<linux-omap@vger.kernel.org>, Archit Taneja <archit@ti.com>
Subject: [PATCH v5 0/4] v4l: VPE mem to mem driver
Date: Wed, 16 Oct 2013 11:06:44 +0530
Message-ID: <1381901808-25119-1-git-send-email-archit@ti.com>
In-Reply-To: <1378462346-10880-1-git-send-email-archit@ti.com>
References: <1378462346-10880-1-git-send-email-archit@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

VPE(Video Processing Engine) is an IP found on DRA7xx, this series adds VPE as a
mem to mem v4l2 driver, and VPDMA as a helper library.

The first version of the patch series described VPE in detail, you can have a
look at it here:

http://www.spinics.net/lists/linux-media/msg66518.html

Changes in v5:
 - updated how pix->colorspace is set.
 - adds comments on what our private control ID is used for.

Archit Taneja (4):
  v4l: ti-vpe: Create a vpdma helper library
  v4l: ti-vpe: Add helpers for creating VPDMA descriptors
  v4l: ti-vpe: Add VPE mem to mem driver
  v4l: ti-vpe: Add de-interlacer support in VPE

 drivers/media/platform/Kconfig             |   16 +
 drivers/media/platform/Makefile            |    2 +
 drivers/media/platform/ti-vpe/Makefile     |    5 +
 drivers/media/platform/ti-vpe/vpdma.c      |  846 +++++++++++
 drivers/media/platform/ti-vpe/vpdma.h      |  203 +++
 drivers/media/platform/ti-vpe/vpdma_priv.h |  641 +++++++++
 drivers/media/platform/ti-vpe/vpe.c        | 2099 ++++++++++++++++++++++++++++
 drivers/media/platform/ti-vpe/vpe_regs.h   |  496 +++++++
 include/uapi/linux/v4l2-controls.h         |    4 +
 9 files changed, 4312 insertions(+)
 create mode 100644 drivers/media/platform/ti-vpe/Makefile
 create mode 100644 drivers/media/platform/ti-vpe/vpdma.c
 create mode 100644 drivers/media/platform/ti-vpe/vpdma.h
 create mode 100644 drivers/media/platform/ti-vpe/vpdma_priv.h
 create mode 100644 drivers/media/platform/ti-vpe/vpe.c
 create mode 100644 drivers/media/platform/ti-vpe/vpe_regs.h

-- 
1.8.1.2

