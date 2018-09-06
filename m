Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44605 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbeIFMTW (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Sep 2018 08:19:22 -0400
Received: by mail-pg1-f195.google.com with SMTP id r1-v6so4766945pgp.11
        for <linux-media@vger.kernel.org>; Thu, 06 Sep 2018 00:45:14 -0700 (PDT)
From: dorodnic@gmail.com
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, evgeni.raikhel@intel.com,
        Sergey Dorodnicov <sergey.dorodnicov@intel.com>
Subject: [PATCH 0/2] [media] Confidence pixel-format for Intel RealSense cameras
Date: Thu,  6 Sep 2018 03:51:05 -0400
Message-Id: <1536220267-22347-1-git-send-email-sergey.dorodnicov@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sergey Dorodnicov <sergey.dorodnicov@intel.com>

Define new fourcc describing depth sensor confidence data used in Intel RealSense cameras.
Confidence information is stored as packed 4 bits per pixel single-plane image.
The patches were tested on 4.18-rc2 and merged with media_tree/master.

Sergey Dorodnicov (2):
  CNF4 fourcc for 4 bit-per-pixel packed confidence information
  CNF4 pixel format for media subsystem

 Documentation/media/uapi/v4l/depth-formats.rst |  1 +
 Documentation/media/uapi/v4l/pixfmt-cnf4.rst   | 30 ++++++++++++++++++++++++++
 drivers/media/usb/uvc/uvc_driver.c             |  5 +++++
 drivers/media/usb/uvc/uvcvideo.h               |  3 +++
 drivers/media/v4l2-core/v4l2-ioctl.c           |  1 +
 include/uapi/linux/videodev2.h                 |  1 +
 6 files changed, 41 insertions(+)
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-cnf4.rst

-- 
2.7.4
