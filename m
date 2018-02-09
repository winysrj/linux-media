Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-sn1nam02on0085.outbound.protection.outlook.com ([104.47.36.85]:41888
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752056AbeBIBVO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Feb 2018 20:21:14 -0500
From: Satish Kumar Nagireddy <satish.nagireddy.nagireddy@xilinx.com>
To: <linux-media@vger.kernel.org>, <laurent.pinchart@ideasonboard.com>,
        <michal.simek@xilinx.com>, <hyun.kwon@xilinx.com>
CC: Satish Kumar Nagireddy <satishna@xilinx.com>
Subject: [PATCH v2 0/9] Add support for multi-planar formats and 10 bit formats 
Date: Thu, 8 Feb 2018 17:21:01 -0800
Message-ID: <1518139261-21540-1-git-send-email-satishna@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

 The patches are for xilinx v4l. The patcheset enable support to handle mul=
tiplanar
 formats and 10 bit formats. The implemenation has handling of single plane=
 formats
 too for backward compatibility of some existing applications.

 Some patches are included as dependencies and are intended to sync downstr=
eam with
 upstream as well.

Hyun Kwon (1):
  media: xilinx: vip: Add the pixel format for RGB24

Jeffrey Mouroux (1):
  uapi: media: New fourcc codes needed by Xilinx Video IP

Radhey Shyam Pandey (1):
  v4l: xilinx: dma: Remove colorspace check in xvip_dma_verify_format

Rohit Athavale (1):
  media-bus: uapi: Add YCrCb 420 media bus format

Satish Kumar Nagireddy (4):
  v4l: xilinx: dma: Update video format descriptor
  v4l: xilinx: dma: Add multi-planar support
  v4l: xilinx: dma: Add scaling and padding factor functions
  v4l: xilinx: dma: Get scaling and padding factor to calculate DMA
    params

 drivers/media/platform/xilinx/xilinx-dma.c  | 365 ++++++++++++++++++++++++=
----
 drivers/media/platform/xilinx/xilinx-dma.h  |   2 +-
 drivers/media/platform/xilinx/xilinx-vip.c  |  61 ++++-
 drivers/media/platform/xilinx/xilinx-vip.h  |  13 +-
 drivers/media/platform/xilinx/xilinx-vipp.c |  22 +-
 include/uapi/linux/media-bus-format.h       |   3 +-
 include/uapi/linux/videodev2.h              |  11 +
 7 files changed, 409 insertions(+), 68 deletions(-)

--
2.7.4

This email and any attachments are intended for the sole use of the named r=
ecipient(s) and contain(s) confidential information that may be proprietary=
, privileged or copyrighted under applicable law. If you are not the intend=
ed recipient, do not read, copy, or forward this email message or any attac=
hments. Delete this email message and any attachments immediately.
