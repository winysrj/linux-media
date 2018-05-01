Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bn3nam01on0056.outbound.protection.outlook.com ([104.47.33.56]:14968
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752673AbeEABfZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Apr 2018 21:35:25 -0400
From: Satish Kumar Nagireddy <satish.nagireddy.nagireddy@xilinx.com>
To: <linux-media@vger.kernel.org>, <laurent.pinchart@ideasonboard.com>,
        <michal.simek@xilinx.com>, <hyun.kwon@xilinx.com>
CC: Satish Kumar Nagireddy <satish.nagireddy.nagireddy@xilinx.com>
Subject: [PATCH v4 00/10] Add support for multi-planar formats and 10 bit formats 
Date: Mon, 30 Apr 2018 18:35:03 -0700
Message-ID: <cover.1524955156.git.satish.nagireddy.nagireddy@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

 The patches are for xilinx v4l. The patcheset enable support to handle multiplanar
 formats and 10 bit formats. The implemenation has handling of single plane formats
 too for backward compatibility of some existing applications.

Changes in v4 (Thanks to Sakari Ailus, Hyun Kwon and Ian Arkver):
 - rst documentation is moved to 24 bit yuv formats group
 - Single plane implementation is removed as multi-plane supports both
 - num_buffers and bpl_factor parameters are removed to have clean
   implementation
 - macropixel concept is used to calculate number of bytes in a row
   for 10 bit formats
 - Video format descriptor table updated with 10 bit format information

Changes in v3:
 - Fixed table alignment issue in rst file. Ensured the output is proper uisng
   'make pdfdocs'

Changes in v2:
 - Added rst documentation for MEDIA_BUS_FMT_VYYUYY8_1X24

Jeffrey Mouroux (2):
  Documentation: uapi: media: v4l: New pixel format
  uapi: media: New fourcc codes needed by Xilinx Video IP

Laurent Pinchart (1):
  xilinx: v4l: dma: Use the dmaengine_terminate_all() wrapper

Radhey Shyam Pandey (1):
  v4l: xilinx: dma: Remove colorspace check in xvip_dma_verify_format

Rohit Athavale (2):
  xilinx: v4l: dma: Update driver to allow for probe defer
  media: Add new dt-bindings/vf_codes for supported formats

Satish Kumar Nagireddy (4):
  media-bus: uapi: Add YCrCb 420 media bus format
  v4l: xilinx: dma: Update video format descriptor
  v4l: xilinx: dma: Add multi-planar support
  v4l: xilinx: dma: Add support for 10 bit formats

 Documentation/media/uapi/v4l/pixfmt-xv15.rst    | 135 ++++++++++++++++++
 Documentation/media/uapi/v4l/pixfmt-xv20.rst    | 136 ++++++++++++++++++
 Documentation/media/uapi/v4l/subdev-formats.rst |  38 ++++-
 Documentation/media/uapi/v4l/yuv-formats.rst    |   2 +
 drivers/media/platform/xilinx/xilinx-dma.c      | 177 +++++++++++++++---------
 drivers/media/platform/xilinx/xilinx-dma.h      |   4 +-
 drivers/media/platform/xilinx/xilinx-vip.c      |  45 ++++--
 drivers/media/platform/xilinx/xilinx-vip.h      |  13 +-
 drivers/media/platform/xilinx/xilinx-vipp.c     |  16 +--
 include/dt-bindings/media/xilinx-vip.h          |   2 +
 include/uapi/linux/media-bus-format.h           |   3 +-
 include/uapi/linux/videodev2.h                  |   4 +
 12 files changed, 488 insertions(+), 87 deletions(-)
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-xv15.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-xv20.rst

-- 
2.1.1
