Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:60137 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751329AbeACOVZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 3 Jan 2018 09:21:25 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: mchehab@s-opensource.com
Cc: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.16] uvcvideo changes
Date: Wed, 03 Jan 2018 16:21:46 +0200
Message-ID: <2334224.jSy5smKVkF@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 9eb124fe796cbadd454c8f946d7051f4c3f4a251:

  Merge branch 'docs-next' of git://git.lwn.net/linux into patchwork 
(2017-12-22 14:38:28 -0500)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git uvc/next

for you to fetch changes up to 0a108c817a45bd5215d041bc0ecfe1e13e8559a6:

  uvcvideo: Add a quirk for Generalplus Technology Inc. 808 Camera (2017-12-28 
17:50:27 +0200)

----------------------------------------------------------------
Arnd Bergmann (2):
      uvcvideo: Use ktime_t for stats
      uvcvideo: Use ktime_t for timestamps

Guennadi Liakhovetski (3):
      v4l: Add a UVC Metadata format
      uvcvideo: Add extensible device information
      uvcvideo: Add a metadata device node

Laurent Pinchart (2):
      uvcvideo: Factor out video device registration to a function
      uvcvideo: Report V4L2 device caps through the video_device structure

Neil Armstrong (1):
      uvcvideo: Add a quirk for Generalplus Technology Inc. 808 Camera

 Documentation/media/uapi/v4l/meta-formats.rst    |   1 +
 Documentation/media/uapi/v4l/pixfmt-meta-uvc.rst |  51 +++++++
 drivers/media/usb/uvc/Makefile                   |   2 +-
 drivers/media/usb/uvc/uvc_driver.c               | 230 ++++++++++++++++------
 drivers/media/usb/uvc/uvc_isight.c               |   2 +-
 drivers/media/usb/uvc/uvc_metadata.c             | 179 ++++++++++++++++++++++
 drivers/media/usb/uvc/uvc_queue.c                |  44 +++++-
 drivers/media/usb/uvc/uvc_v4l2.c                 |   4 -
 drivers/media/usb/uvc/uvc_video.c                | 182 +++++++++++++++------
 drivers/media/usb/uvc/uvcvideo.h                 |  30 +++-
 drivers/media/v4l2-core/v4l2-ioctl.c             |   1 +
 include/uapi/linux/uvcvideo.h                    |  26 ++++
 include/uapi/linux/videodev2.h                   |   1 +
 13 files changed, 618 insertions(+), 135 deletions(-)
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-meta-uvc.rst
 create mode 100644 drivers/media/usb/uvc/uvc_metadata.c

-- 
Regards,

Laurent Pinchart
