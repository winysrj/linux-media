Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33874 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbeILLi4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Sep 2018 07:38:56 -0400
Received: by mail-pf1-f195.google.com with SMTP id k19-v6so510419pfi.1
        for <linux-media@vger.kernel.org>; Tue, 11 Sep 2018 23:35:54 -0700 (PDT)
From: dorodnic@gmail.com
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, evgeni.raikhel@intel.com,
        Sergey Dorodnicov <sergey.dorodnicov@intel.com>
Subject: [PATCH v2 0/2] [media] Depth confidence pixel-format for Intel RealSense cameras
Date: Wed, 12 Sep 2018 02:42:05 -0400
Message-Id: <1536734527-3770-1-git-send-email-sergey.dorodnicov@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sergey Dorodnicov <sergey.dorodnicov@intel.com>

Define new fourcc describing depth sensor confidence data used in Intel RealSense cameras.
Confidence information is stored as packed 4 bits per pixel single-plane image.
The patches were tested on 4.18-rc2 and merged with media_tree/master.
Addressing code-review comments by Hans Verkuil <hverkuil@xs4all.nl> and
Laurent Pinchart <laurent.pinchart@ideasonboard.com>.

Sergey Dorodnicov (2):
  CNF4 fourcc for 4 bit-per-pixel packed depth confidence information
  CNF4 pixel format for media subsystem

 Documentation/media/uapi/v4l/depth-formats.rst |  1 +
 Documentation/media/uapi/v4l/pixfmt-cnf4.rst   | 31 ++++++++++++++++++++++++++
 drivers/media/usb/uvc/uvc_driver.c             |  5 +++++
 drivers/media/usb/uvc/uvcvideo.h               |  3 +++
 drivers/media/v4l2-core/v4l2-ioctl.c           |  1 +
 include/uapi/linux/videodev2.h                 |  1 +
 6 files changed, 42 insertions(+)
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-cnf4.rst

-- 
2.7.4
