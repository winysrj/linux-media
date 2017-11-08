Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:56461 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752603AbdKHQAS (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 8 Nov 2017 11:00:18 -0500
Received: from axis700.grange ([84.44.207.202]) by mail.gmx.com (mrgmx002
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0MUoma-1ekbnA22xw-00YBYM for
 <linux-media@vger.kernel.org>; Wed, 08 Nov 2017 17:00:16 +0100
Received: from 200r.grange (200r.grange [192.168.1.16])
        by axis700.grange (Postfix) with ESMTP id 4F28E61886
        for <linux-media@vger.kernel.org>; Wed,  8 Nov 2017 17:00:15 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
Subject: [PATCH 0/3 v7] uvcvideo: metadata nodes
Date: Wed,  8 Nov 2017 17:00:11 +0100
Message-Id: <1510156814-28645-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>

Comments by Laurent and Hans addressed, thanks.

Regards
Guennadi

Guennadi Liakhovetski (3):
  V4L: Add a UVC Metadata format
  uvcvideo: add extensible device information
  uvcvideo: add a metadata device node

 Documentation/media/uapi/v4l/meta-formats.rst    |   1 +
 Documentation/media/uapi/v4l/pixfmt-meta-uvc.rst |  50 ++++++
 drivers/media/usb/uvc/Makefile                   |   2 +-
 drivers/media/usb/uvc/uvc_driver.c               | 142 ++++++++++------
 drivers/media/usb/uvc/uvc_isight.c               |   2 +-
 drivers/media/usb/uvc/uvc_metadata.c             | 204 +++++++++++++++++++++++
 drivers/media/usb/uvc/uvc_queue.c                |  41 ++++-
 drivers/media/usb/uvc/uvc_video.c                | 127 ++++++++++++--
 drivers/media/usb/uvc/uvcvideo.h                 |  19 ++-
 drivers/media/v4l2-core/v4l2-ioctl.c             |   1 +
 include/uapi/linux/uvcvideo.h                    |  26 +++
 include/uapi/linux/videodev2.h                   |   1 +
 12 files changed, 546 insertions(+), 70 deletions(-)
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-meta-uvc.rst
 create mode 100644 drivers/media/usb/uvc/uvc_metadata.c

-- 
1.9.3
