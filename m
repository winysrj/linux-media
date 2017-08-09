Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-dm3nam03on0059.outbound.protection.outlook.com ([104.47.41.59]:9100
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752301AbdHIBbc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Aug 2017 21:31:32 -0400
From: Jeffrey Mouroux <jeff.mouroux@xilinx.com>
To: <mchehab@kernel.org>, <hansverk@cisco.com>,
        <laurent.pinchart+renesas@ideasonboard.com>,
        <sakari.ailus@linux.intel.com>, <tiffany.lin@mediatek.com>,
        <ricardo.ribalda@gmail.com>, <evgeni.raikhel@intel.com>,
        <nick@shmanahar.org>
CC: <linux-media@vger.kernel.org>,
        Jeffrey Mouroux <jmouroux@xilinx.com>
Subject: [PATCH v1 0/2] New fourcc codes needed by Video DMA Driver
Date: Tue, 8 Aug 2017 18:31:16 -0700
Message-ID: <1502242278-14686-1-git-send-email-jmouroux@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch set is introduced to support a driver we are developing
for our new Video Framebuffer DMA IP, a DMA device that is "video format aware".
Clients need only specify memory layout information for a single plane
(i.e. luma) and then provide a video format code (e.g. YUV420) which will permit
for intelligent reads or writes (depending on the IP configuration) to host
memory with only a minimal set of video memory configuration data.

The IP supports a variety of 8-bit and 10-bit video formats, some of which
are not represented in the current V4L2 user api or framework.  This patch
set introduces these needed video format codes and updates the 
framework with the metadata required.

The DMA driver requiring these updates is not being submitted as part of this
patch set as it is still undergoing final development.

We are submitting this patch series for review and comment with regard to
ensuring we haven't missed any required framework updates and/or in regards to
the choices we've made to the fourcc string values.

Jeffrey Mouroux (2):
  uapi: media: New fourcc codes needed by Xilinx Video IP
  media: v4l2-core: Update V4L2 framework with new fourcc codes

 drivers/media/v4l2-core/v4l2-ioctl.c | 9 +++++++++
 include/uapi/linux/videodev2.h       | 9 +++++++++
 2 files changed, 18 insertions(+)

-- 
1.9.1
