Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:14613 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750844AbdBSQTX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 19 Feb 2017 11:19:23 -0500
From: evgeni.raikhel@intel.com
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, guennadi.liakhovetski@intel.com,
        eliezer.tamir@intel.com, Evgeni Raikhel <evgeni.raikhel@intel.com>
Subject: [PATCH v3 0/2] Intel  Depth Formats for SR300 camera
Date: Sun, 19 Feb 2017 18:14:35 +0200
Message-Id: <1487520877-23173-1-git-send-email-evgeni.raikhel@intel.com>
In-Reply-To: <AA09C8071EEEFC44A7852ADCECA86673A1E6E7@hasmsx108.ger.corp.intel.com>
References: <AA09C8071EEEFC44A7852ADCECA86673A1E6E7@hasmsx108.ger.corp.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Evgeni Raikhel <evgeni.raikhel@intel.com>

This is the third iteration of the patch that addresses reported issues.
Change Log:
- Adding V4L2_PIX_FMT_INZI format description to v4l_fill_fmtdesc(..)
- Reorder INZI entry in ../depth-formats.rst to keep the list strictly alphabetic
- Patch comments minor amendments


Daniel Patrick Johnson (1):
  uvcvideo: Add support for Intel SR300 depth camera

eraikhel (1):
  Documentation: Intel SR300 Depth camera INZI format

 Documentation/media/uapi/v4l/depth-formats.rst |  1 +
 Documentation/media/uapi/v4l/pixfmt-inzi.rst   | 81 ++++++++++++++++++++++++++
 drivers/media/usb/uvc/uvc_driver.c             | 15 +++++
 drivers/media/usb/uvc/uvcvideo.h               |  9 +++
 drivers/media/v4l2-core/v4l2-ioctl.c           |  1 +
 include/uapi/linux/videodev2.h                 |  1 +
 6 files changed, 108 insertions(+)
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-inzi.rst

-- 
2.7.4

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
