Return-path: <linux-media-owner@vger.kernel.org>
Received: from fllnx209.ext.ti.com ([198.47.19.16]:17462 "EHLO
        fllnx209.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751716AbcKRXUy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Nov 2016 18:20:54 -0500
From: Benoit Parrot <bparrot@ti.com>
To: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-kernel@vger.kernel.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jyri Sarha <jsarha@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Benoit Parrot <bparrot@ti.com>
Subject: [Patch v2 00/35] media: ti-vpe: fixes and enhancements
Date: Fri, 18 Nov 2016 17:20:10 -0600
Message-ID: <20161118232045.24665-1-bparrot@ti.com>
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

Changes since v1:
- Fix typos from comments
- Clarified commit log based on comments
- Added Acked-by and Reviewed-by tags to relevant patches.

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

