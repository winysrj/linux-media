Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([198.47.19.11]:38409 "EHLO bear.ext.ti.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752640AbcJJRbB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Oct 2016 13:31:01 -0400
From: "Parrot, Benoit" <bparrot@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [Patch 00/35] media: ti-vpe: fixes and enhancements
Date: Mon, 10 Oct 2016 17:30:56 +0000
Message-ID: <AAE35E953C746D4784A1A0C604EFEA714E44D29E@DLEE10.ent.ti.com>
References: <20160928211643.26298-1-bparrot@ti.com>
In-Reply-To: <20160928211643.26298-1-bparrot@ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans, Mauro,

Ping.

Benoit

-----Original Message-----
From: Parrot, Benoit 
Sent: Wednesday, September 28, 2016 4:16 PM
To: Hans Verkuil
Cc: linux-media@vger.kernel.org; linux-kernel@vger.kernel.org; Parrot, Benoit
Subject: [Patch 00/35] media: ti-vpe: fixes and enhancements

This patch series is to publish a number of enhancements we have been carrying for a while.

A number of bug fixes and feature enhancements have been included.

We also need to prepare the way for the introduction of the VIP (Video Input Port) driver (coming soon) which has internal IP module in common with VPE.

The relevant modules (vpdma, sc and csc) are therefore converted into individual kernel modules.

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

