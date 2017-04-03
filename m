Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:18989 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751008AbdDCIxu (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Apr 2017 04:53:50 -0400
From: "Raikhel, Evgeni" <evgeni.raikhel@intel.com>
To: "laurent.pinchart@ideasonboard.com"
        <laurent.pinchart@ideasonboard.com>
CC: "Liakhovetski, Guennadi" <guennadi.liakhovetski@intel.com>,
        "Tamir, Eliezer" <eliezer.tamir@intel.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RE: [PATCH v4 0/2]  Intel Depth Formats for SR300 Camera
Date: Mon, 3 Apr 2017 08:53:44 +0000
Message-ID: <AA09C8071EEEFC44A7852ADCECA86673020CE09B@hasmsx108.ger.corp.intel.com>
References: <AA09C8071EEEFC44A7852ADCECA86673A1E6E7@hasmsx108.ger.corp.intel.com>
 <1488498200-8014-1-git-send-email-evgeni.raikhel@intel.com>
In-Reply-To: <1488498200-8014-1-git-send-email-evgeni.raikhel@intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,
Can you please update on the status of the submission?
The last version has been reviewed a month ago.
Is there any estimate on when it is going to be staged/triaged/merged into media tree?

Please advise,
Evgeni


-----Original Message-----
From: Raikhel, Evgeni 
Sent: Friday, March 03, 2017 01:43
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com; Liakhovetski, Guennadi <guennadi.liakhovetski@intel.com>; Tamir, Eliezer <eliezer.tamir@intel.com>; Raikhel, Evgeni <evgeni.raikhel@intel.com>
Subject: [PATCH v4 0/2] Intel Depth Formats for SR300 Camera

From: Evgeni Raikhel <evgeni.raikhel@intel.com>

Change Log:
 - Fixing FourCC description in v4l2_ioctl.c to be less than 32 bytes
 - Reorder INZI format entry in Documentation chapter

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
