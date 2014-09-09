Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:32776 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbaIIIlE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Sep 2014 04:41:04 -0400
Received: from avalon.localnet (dsl-hkibrasgw3-50ddcc-40.dhcp.inet.fi [80.221.204.40])
	by galahad.ideasonboard.com (Postfix) with ESMTPSA id 3EA1720015
	for <linux-media@vger.kernel.org>; Tue,  9 Sep 2014 10:40:03 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.18] uvcvideo changes
Date: Tue, 09 Sep 2014 11:41 +0300
Message-ID: <352565057.M5lg4dyeH3@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 91f96e8b7255537da3a58805cf465003521d7c5f:

  [media] tw68: drop bogus cpu_to_le32() call (2014-09-08 16:40:54 -0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git uvc/next

for you to fetch changes up to 18e27c1f02310ecc196b059d890bd840fe247960:

  media: usb: uvc: add a quirk for Dell XPS M1330 webcam (2014-09-09 11:37:43 
+0300)

----------------------------------------------------------------
Paul Fertser (1):
      media: usb: uvc: add a quirk for Dell XPS M1330 webcam

Vincent Palatin (2):
      v4l: Add camera pan/tilt speed controls
      v4l: uvcvideo: Add support for pan/tilt speed controls

William Manley (1):
      uvcvideo: Work around buggy Logitech C920 firmware

 Documentation/DocBook/media/v4l/compat.xml   | 10 ++++++
 Documentation/DocBook/media/v4l/controls.xml | 21 +++++++++++++
 drivers/media/usb/uvc/uvc_ctrl.c             | 60 ++++++++++++++++++++++++---
 drivers/media/usb/uvc/uvc_driver.c           | 20 +++++++++++-
 drivers/media/usb/uvc/uvc_video.c            |  6 ++++
 drivers/media/usb/uvc/uvcvideo.h             |  3 +-
 drivers/media/v4l2-core/v4l2-ctrls.c         |  2 ++
 include/uapi/linux/v4l2-controls.h           |  2 ++
 8 files changed, 118 insertions(+), 6 deletions(-)

-- 
Regards,

Laurent Pinchart

