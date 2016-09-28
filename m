Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([198.47.19.11]:58033 "EHLO bear.ext.ti.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754137AbcI1VQx (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Sep 2016 17:16:53 -0400
From: Benoit Parrot <bparrot@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Benoit Parrot <bparrot@ti.com>
Subject: [Patch 00/35] media: ti-vpe: fixes and enhancements
Date: Wed, 28 Sep 2016 16:16:08 -0500
Message-ID: <20160928211643.26298-1-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series is to publish a number of enhancements
we have been carrying for a while.

A number of bug fixes and feature enhancements have been
included.

We also need to prepare the way for the introduction of
the VIP (Video Input Port) driver (coming soon) which
has internal IP module in common with VPE.

The relevant modules (vpdma, sc and csc) are therefore converted
into individual kernel modules.

Archit Taneja (1):
  media: ti-vpe: Use line average de-interlacing for first 2 frames

Benoit Parrot (16):
  media: ti-vpe: vpdma: Make vpdma library into its own module
  media: ti-vpe: vpdma: Add multi-instance and multi-client support
  media: ti-vpe: vpdma: Add helper to set a background color
  media: ti-vpe: vpdma: Fix bus error when vpdma is writing a descriptor
  media: ti-vpe: vpe: Added MODULE_DEVICE_TABLE hint
  media: ti-vpe: vpdma: Corrected YUV422 data type label.
  media: ti-vpe: vpdma: RGB data type yield inverted data
  media: ti-vpe: vpe: Fix vb2 buffer cleanup
  media: ti-vpe: vpe: Enable DMABUF export
  media: ti-vpe: Make scaler library into its own module
  media: ti-vpe: scaler: Add debug support for multi-instance
  media: ti-vpe: vpe: Make sure frame size dont exceed scaler capacity
  media: ti-vpe: vpdma: Add RAW8 and RAW16 data types
  media: ti-vpe: Make colorspace converter library into its own module
  media: ti-vpe: csc: Add debug support for multi-instance
  media: ti-vpe: vpe: Add proper support single and multi-plane buffer

Harinarayan Bhatta (2):
  media: ti-vpe: Increasing max buffer height and width
  media: ti-vpe: Free vpdma buffers in vpe_release

Nikhil Devshatwar (16):
  media: ti-vpe: vpe: Do not perform job transaction atomically
  media: ti-vpe: Add support for SEQ_TB buffers
  media: ti-vpe: vpe: Return NULL for invalid buffer type
  media: ti-vpe: vpdma: Add support for setting max width height
  media: ti-vpe: vpdma: Add abort channel desc and cleanup APIs
  media: ti-vpe: vpdma: Make list post atomic operation
  media: ti-vpe: vpdma: Clear IRQs for individual lists
  media: ti-vpe: vpe: configure line mode separately
  media: ti-vpe: vpe: Setup srcdst parameters in start_streaming
  media: ti-vpe: vpe: Post next descriptor only for list complete IRQ
  media: ti-vpe: vpe: Add RGB565 and RGB5551 support
  media: ti-vpe: vpdma: allocate and maintain hwlist
  media: ti-vpe: sc: Fix incorrect optimization
  media: ti-vpe: vpdma: Fix race condition for firmware loading
  media: ti-vpe: vpdma: Use bidirectional cached buffers
  media: ti-vpe: vpe: Fix line stride for output motion vector

 drivers/media/platform/Kconfig             |  14 +
 drivers/media/platform/ti-vpe/Makefile     |  10 +-
 drivers/media/platform/ti-vpe/csc.c        |  18 +-
 drivers/media/platform/ti-vpe/csc.h        |   2 +-
 drivers/media/platform/ti-vpe/sc.c         |  28 +-
 drivers/media/platform/ti-vpe/sc.h         |  11 +-
 drivers/media/platform/ti-vpe/vpdma.c      | 349 +++++++++++++++++++---
 drivers/media/platform/ti-vpe/vpdma.h      |  85 +++++-
 drivers/media/platform/ti-vpe/vpdma_priv.h | 130 ++++-----
 drivers/media/platform/ti-vpe/vpe.c        | 450 ++++++++++++++++++++++++-----
 10 files changed, 891 insertions(+), 206 deletions(-)

-- 
2.9.0

