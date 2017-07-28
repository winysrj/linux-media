Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:63172 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751628AbdG1Mda (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Jul 2017 08:33:30 -0400
Received: from axis700.grange ([87.78.105.5]) by mail.gmx.com (mrgmx001
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0MAQXq-1dPTc22aVe-00BblH for
 <linux-media@vger.kernel.org>; Fri, 28 Jul 2017 14:33:28 +0200
Received: from 200r.grange (200r.grange [192.168.1.16])
        by axis700.grange (Postfix) with ESMTP id 186CA8B104
        for <linux-media@vger.kernel.org>; Fri, 28 Jul 2017 14:30:58 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 0/6 v5] uvcvideo: metadata nodes and controls
Date: Fri, 28 Jul 2017 14:33:19 +0200
Message-Id: <1501245205-15802-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The first four patches are for UVC metadata nodes, the last two patches
are for asynchronous controls and control error reporting.

Thanks
Guennadi

Guennadi Liakhovetski (6):
  UVC: fix .queue_setup() to check the number of planes
  V4L: Add a UVC Metadata format
  uvcvideo: convert from using an atomic variable to a reference count
  uvcvideo: add a metadata device node
  uvcvideo: send a control event when a Control Change interrupt arrives
  uvcvideo: handle control pipe protocol STALLs

 Documentation/media/uapi/v4l/meta-formats.rst    |   1 +
 Documentation/media/uapi/v4l/pixfmt-meta-uvc.rst |  39 +++++
 drivers/media/usb/uvc/Makefile                   |   2 +-
 drivers/media/usb/uvc/uvc_ctrl.c                 | 150 +++++++++++++++++--
 drivers/media/usb/uvc/uvc_driver.c               |  43 ++++--
 drivers/media/usb/uvc/uvc_isight.c               |   2 +-
 drivers/media/usb/uvc/uvc_metadata.c             | 139 ++++++++++++++++++
 drivers/media/usb/uvc/uvc_queue.c                |  43 +++++-
 drivers/media/usb/uvc/uvc_status.c               | 112 ++++++++++++--
 drivers/media/usb/uvc/uvc_v4l2.c                 |   4 +-
 drivers/media/usb/uvc/uvc_video.c                | 178 +++++++++++++++++++++--
 drivers/media/usb/uvc/uvcvideo.h                 |  33 ++++-
 drivers/media/v4l2-core/v4l2-ioctl.c             |   1 +
 include/uapi/linux/uvcvideo.h                    |  28 ++++
 include/uapi/linux/videodev2.h                   |   1 +
 15 files changed, 705 insertions(+), 71 deletions(-)
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-meta-uvc.rst
 create mode 100644 drivers/media/usb/uvc/uvc_metadata.c

-- 
1.9.3
