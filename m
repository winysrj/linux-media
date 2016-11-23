Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:55797 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933864AbcKWQlO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Nov 2016 11:41:14 -0500
Received: from avalon.localnet (dfj612ybrt5fhg77mgycy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:2e86:4862:ef6a:2804])
        by galahad.ideasonboard.com (Postfix) with ESMTPSA id 419AC2111A
        for <linux-media@vger.kernel.org>; Wed, 23 Nov 2016 17:41:04 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.10] uvcvideo updates
Date: Wed, 23 Nov 2016 18:41:25 +0200
Message-ID: <5023082.x839zPCRQf@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 30f88a42b65858d777b8dfb40bb222fa31d5f0d9:

  [media] staging: lirc: Improvement in code readability (2016-11-22 12:21:25 
-0200)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git uvc/next

for you to fetch changes up to 798e756c4d758ba97551de547d16e36944f1282d:

  uvcvideo: Use memdup_user() rather than duplicating its implementation 
(2016-11-23 17:41:32 +0200)

----------------------------------------------------------------
Edgar Thier (1):
      uvcvideo: Add bayer 16-bit format patterns

Laurent Pinchart (1):
      v4l: Add description of the Y8I, Y12I and Z16 formats

Markus Elfring (1):
      uvcvideo: Use memdup_user() rather than duplicating its implementation

Sakari Ailus (2):
      v4l: Add 16-bit raw bayer pixel formats
      doc-rst: Specify raw bayer format variant used in the examples

 Documentation/media/uapi/v4l/pixfmt-rgb.rst             |  2 +-
 Documentation/media/uapi/v4l/pixfmt-srggb10p.rst        |  2 +-
 Documentation/media/uapi/v4l/pixfmt-srggb12.rst         |  2 +-
 .../uapi/v4l/{pixfmt-sbggr16.rst => pixfmt-srggb16.rst} | 25 ++++++++++------
 Documentation/media/uapi/v4l/pixfmt-srggb8.rst          |  2 +-
 drivers/media/usb/uvc/uvc_driver.c                      | 20 ++++++++++++++++
 drivers/media/usb/uvc/uvc_v4l2.c                        | 11 +++--------
 drivers/media/usb/uvc/uvcvideo.h                        | 12 ++++++++++++
 drivers/media/v4l2-core/v4l2-ioctl.c                    |  8 +++++++-
 include/uapi/linux/videodev2.h                          |  3 +++
 10 files changed, 65 insertions(+), 22 deletions(-)
 rename Documentation/media/uapi/v4l/{pixfmt-sbggr16.rst => pixfmt-
srggb16.rst} (52%)

-- 
Regards,

Laurent Pinchart

