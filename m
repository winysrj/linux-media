Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:46636 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725969AbeICU1b (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Sep 2018 16:27:31 -0400
Received: from avalon.localnet (unknown [IPv6:2a02:a03f:44af:b200:7127:b50e:4bc9:57a3])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 81D001AAF
        for <linux-media@vger.kernel.org>; Mon,  3 Sep 2018 18:06:42 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.20] uvcvideo changes
Date: Mon, 03 Sep 2018 19:06:46 +0300
Message-ID: <1960104.jB7WYTBLo6@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit d842a7cf938b6e0f8a1aa9f1aec0476c9a599310:

  media: adv7842: enable reduced fps detection (2018-08-31 10:03:51 -0400)

are available in the Git repository at:

  git://linuxtv.org/pinchartl/media.git tags/uvc-next-20180903

for you to fetch changes up to 8cefb491d85d35e9a2279a98f2545c10718524d7:

  media: uvcvideo: Add a D4M camera description (2018-09-03 19:00:47 +0300)

----------------------------------------------------------------
UVC changes for v4.20

----------------------------------------------------------------
Colin Ian King (1):
      media: uvcvideo: Fix spelling mistake: "entites" -> "entities"

Guennadi Liakhovetski (2):
      media: uvcvideo: Rename UVC_QUIRK_INFO to UVC_INFO_QUIRK
      media: uvcvideo: Add a D4M camera description

Gustavo A. R. Silva (1):
      media: uvcvideo: Remove unnecessary NULL check before 
debugfs_remove_recursive

Joe Perches (1):
      media: uvcvideo: Make some structs const

Laurent Pinchart (2):
      media: uvcvideo: Make uvc_control_mapping menu_info field const
      media: uvcvideo: Store device information pointer in struct uvc_device

Nadav Amit (1):
      media: uvcvideo: Fix uvc_alloc_entity() allocation alignment

 Documentation/media/uapi/v4l/meta-formats.rst     |   1 +
 Documentation/media/uapi/v4l/pixfmt-meta-d4xx.rst | 210 +++++++++++++++++++++
 drivers/media/usb/uvc/uvc_ctrl.c                  |  14 +-
 drivers/media/usb/uvc/uvc_debugfs.c               |   6 +-
 drivers/media/usb/uvc/uvc_driver.c                |  53 +++---
 drivers/media/usb/uvc/uvc_metadata.c              |   7 +-
 drivers/media/usb/uvc/uvcvideo.h                  |  10 +-
 include/uapi/linux/videodev2.h                    |   1 +
 8 files changed, 261 insertions(+), 41 deletions(-)
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-meta-d4xx.rst

-- 
Regards,

Laurent Pinchart
