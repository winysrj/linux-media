Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-co1nam03on0050.outbound.protection.outlook.com ([104.47.40.50]:13728
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751929AbeECCnM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 2 May 2018 22:43:12 -0400
From: Satish Kumar Nagireddy <satish.nagireddy.nagireddy@xilinx.com>
To: <linux-media@vger.kernel.org>, <laurent.pinchart@ideasonboard.com>,
        <michal.simek@xilinx.com>, <hyun.kwon@xilinx.com>
CC: Satish Kumar Nagireddy <satish.nagireddy.nagireddy@xilinx.com>
Subject: [PATCH v5 0/8] Add support for multi-planar formats and 10 bit formats 
Date: Wed, 2 May 2018 19:42:45 -0700
Message-ID: <cover.1525312401.git.satish.nagireddy.nagireddy@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

 The patches are for xilinx v4l. The patcheset enable support to handle multiplanar
 formats and 10 bit formats. Single planar implementation is removed as mplane can
 handle both.

 Patch-set has downstream changes and bug fixes. Added new media bus format
 MEDIA_BUS_FMT_VYYUYY8_1X24, new pixel format V4L2_PIX_FMT_XV15 and rst
 documentation.

Jeffrey Mouroux (1):
  uapi: media: New fourcc code and rst for 10 bit format

Radhey Shyam Pandey (1):
  v4l: xilinx: dma: Remove colorspace check in xvip_dma_verify_format

Rohit Athavale (1):
  xilinx: v4l: dma: Update driver to allow for probe defer

Satish Kumar Nagireddy (4):
  media-bus: uapi: Add YCrCb 420 media bus format and rst
  v4l: xilinx: dma: Update video format descriptor
  v4l: xilinx: dma: Add multi-planar support
  v4l: xilinx: dma: Add support for 10 bit formats

Vishal Sagar (1):
  xilinx: v4l: dma: Terminate DMA when media pipeline fail to start

 Documentation/media/uapi/v4l/pixfmt-xv15.rst    | 134 +++++++++++++++++++
 Documentation/media/uapi/v4l/subdev-formats.rst |  38 +++++-
 Documentation/media/uapi/v4l/yuv-formats.rst    |   1 +
 drivers/media/platform/xilinx/xilinx-dma.c      | 170 +++++++++++++++---------
 drivers/media/platform/xilinx/xilinx-dma.h      |   4 +-
 drivers/media/platform/xilinx/xilinx-vip.c      |  37 ++++--
 drivers/media/platform/xilinx/xilinx-vip.h      |  15 ++-
 drivers/media/platform/xilinx/xilinx-vipp.c     |  16 +--
 include/uapi/linux/media-bus-format.h           |   3 +-
 include/uapi/linux/videodev2.h                  |   1 +
 10 files changed, 333 insertions(+), 86 deletions(-)
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-xv15.rst

-- 
2.7.4
