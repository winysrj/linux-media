Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39504 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753425AbdDDKfJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 4 Apr 2017 06:35:09 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: "Raikhel, Evgeni" <evgeni.raikhel@intel.com>,
        "Liakhovetski, Guennadi" <guennadi.liakhovetski@intel.com>,
        "Tamir, Eliezer" <eliezer.tamir@intel.com>
Subject: [GIT PULL FOR v4.12] uvcvideo changes
Date: Tue, 04 Apr 2017 13:35:54 +0300
Message-ID: <5928784.K3TpbEiYEy@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit c3d4fb0fb41f4b5eafeee51173c14e50be12f839:

  [media] rc: sunxi-cir: simplify optional reset handling (2017-03-24 08:30:03 
-0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git uvc/next

for you to fetch changes up to 3f416962224e74817effbc99979eb7a2c4a6ed08:

  uvcvideo: Add support for Intel SR300 depth camera (2017-04-04 13:33:06 
+0300)

----------------------------------------------------------------
Daniel Patrick Johnson (1):
      uvcvideo: Add support for Intel SR300 depth camera

Evgeni Raikhel (1):
      Documentation: Intel SR300 Depth camera INZI format

Kieran Bingham (2):
      uvcvideo: Fix empty packet statistic
      uvcvideo: Don't recode timespec_sub

 Documentation/media/uapi/v4l/depth-formats.rst |  1 +
 Documentation/media/uapi/v4l/pixfmt-inzi.rst   | 81 +++++++++++++++++++++++++
 drivers/media/usb/uvc/uvc_driver.c             | 15 +++++++
 drivers/media/usb/uvc/uvc_video.c              | 12 ++---
 drivers/media/usb/uvc/uvcvideo.h               |  9 ++++
 drivers/media/v4l2-core/v4l2-ioctl.c           |  1 +
 include/uapi/linux/videodev2.h                 |  1 +
 7 files changed, 111 insertions(+), 9 deletions(-)
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-inzi.rst

-- 
Regards,

Laurent Pinchart
